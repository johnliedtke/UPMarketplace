 import UIKit
 
 /**
 Used to display PFObjects from parse. Fetches data in a "pagination" style.
 However, pages are automatically loaded for an endless-scroll feel.
 Notes:
 
 - Must override collectionView(_:didSelectItemAtIndexPath:withObject:) to provide a cell to the datasource.
 - Override collectionView(_:didSelectItemAtIndexPath:withObject:) to handle
 selection of cells.
 - Must override either query() or queryTask() to obtain a [PFObject]
 */
 class UPMPFQueryAllTVC: UITableViewController {
  
  // MARK: - Public Properties
  
  /// Number of objects per page
  var objectsPerPage: UInt = 25
  
  /// Status of fetching data from parse
  var isLoading: Bool = false
  
  /// Should objects be seperated into pages, that load automatically.
  var paginationEnabled: Bool = false
  
  /// All of the currenlty fetched objects.
  var objects: [PFObject] = [PFObject]()
  
  /// Enable activity indicator in middle of screen when loading
  var activityViewEnabled = false
  
  /// Enable pull to refresh
  var pullToRefreshEnabled: Bool = true
  
  /// Currently refreshing the data (pulled to refresh)
  var isRefreshing: Bool = false
  
  /// The message to display whent there is no data
  var noDataMessage = "No data.\nPull to refresh."
  
  // MARK: - Private Properties
  
  /// Loading indicator dispalyed in middle of screen
  var activityIndicator: UIActivityIndicatorView!
  
  /// Displays when there is no data or network connection
  private var noDataLabel = UILabel()
  
  /// First time the objects have been loaded
  private var isFirstLoad = true
  
  private var savedSeparatorStyle = UITableViewCellSeparatorStyle.None
  
  /// Pull to refresh control
 // var refreshControl: UIRefreshControl!
  
  // MARK: - View
  
  /// Performs query for objects on load and sets up pull to refresh.
  override func viewDidLoad() {
    super.viewDidLoad()

    changeDefaults()
    performQuery()
    if pullToRefreshEnabled {
      refreshControl = UIRefreshControl()
      refreshControl!.tintColor = UIColor.grayColor()
      refreshControl!.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
      tableView.addSubview(refreshControl!)
      tableView.alwaysBounceVertical = true
    }
  }

  /// Override to change the default values before the first data is fetched
  func changeDefaults() -> Void {
    
  }
  
  /// Override to provide a query for objects
  func query() -> PFQuery {
    return PFQuery()
  }
  
  /**
  Override if you are querying multiple tables
  
  :returns: An array of queries that should have the same base class
  */
  func queries() -> [PFQuery]? {
    return nil
  }
  
  /// May need to override if using multiple sections
  func objectAtIndexPath(indexPath: NSIndexPath) -> PFObject {
    return objects[indexPath.row]
  }
  
  // MARK: - Collection View Datasource
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // Do not display anything if fetching data
    return isLoading ? 0 : 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return objects.count
  }
  
  /// Obtains cell from other method... Provides object.
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return self.tableView(tableView, cellForRowAtIndexPath: indexPath, object: objects[indexPath.row])
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.tableView(tableView, didSelectRowAtIndexPath: indexPath, withObject: objects[indexPath.row])

  }
  
  // MARK: - Methods to Override
  
  /**
  Must override to provide to a UICollectionViewCell
  
  :param: indexPath The indexPath the cell will be displayed at
  :param: collectionView The collection view requesting the cell.
  :param: object PFObject corresponding to indexPath.
  */
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject) -> UITableViewCell {
    return UITableViewCell()
  }
  
  /**
  Override to handle selection of cells.
    
  :param: indexPath The indexPath of the selected cell.
  :param: collectionView The collection view of the selected cell.
  :param: object PFObject corresponding to selected cell/indexPath.
  */
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, withObject object: PFObject) -> Void {
    
  }
  
  // MARK: - Private Methods
  
  /// Pull to refresh action
  func refreshControlAction(sender: AnyObject) {
    isRefreshing = true
    performQuery()
  }
  
  /**
  Fetches PFObjects according to the query returned from query(). Handles
  both pullToRefresh and auto-loading from bottom.
  */
  func performQuery() -> Void {
    if var queriesToPerform = queries() {
      if paginationEnabled {
        for q in queriesToPerform {
          q.limit = Int(objectsPerPage) / queriesToPerform.count
        }
      
        if !isRefreshing {
          for q in queriesToPerform {
            q.skip = objects.filter { $0.parseClassName == q.parseClassName }.count
          }
        }
      }
      
        // About to fetch
        self.objectsWillLoad()
        
        //FIXME: Fix slow initial fetching.
        
        PFQuery.combineQueriesInBackground(queriesToPerform).continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock: {
          [unowned self] (task) in
          if task.error == nil {
            // Success
            if var fetchedObjects = task.result as? [PFObject] {
              fetchedObjects.sort { $0.createdAt!.compare($1.createdAt!) == NSComparisonResult.OrderedDescending }
              if self.paginationEnabled && !self.isRefreshing {
                self.objects += fetchedObjects
              } else {
                self.objects.removeAll(keepCapacity: false)
                self.objects = fetchedObjects
              }
            }
          } else {
            // error
          }
          self.objectsDidLoad(task.error)
          return nil
          })
      
    
    } else {
      var queryToPeform = query()
      
      if paginationEnabled {
        queryToPeform.limit = Int(objectsPerPage)
        // next page of objects
        if !isRefreshing {
          queryToPeform.skip = objects.count
        }
      }
      
      // About to fetch objects
      objectsWillLoad()
      
      
      queryToPeform.findObjectsInBackgroundWithBlock { [unowned self] (objects: [AnyObject]?, error: NSError?) in
        if error == nil {
          // Success
          // Convert objects
          if let fetchedObjects = objects as? [PFObject] {
            if self.paginationEnabled && !self.isRefreshing {
              self.objects += fetchedObjects
            } else {
              self.objects = fetchedObjects
            }
          }
        } else {
          // error
        }
        self.objectsDidLoad(error)
      } // end findObjectsInBackground
    } // end else
  } // end performQuery()
  
  /**
  Prepare for fetching data from parse by displaying an activity indicator.
  */
  func objectsWillLoad() -> Void {
    if isLoading  { return }

    // Begin loading objects
    isLoading = true
    toggleSeparatorStyle()
    
    if isFirstLoad {
      savedSeparatorStyle = tableView.separatorStyle;
      tableView.separatorStyle = .None;
    }
    
    if activityViewEnabled {
      if activityIndicator == nil {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.center = view.center
        activityIndicator.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleBottomMargin
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
      }
      activityIndicator.hidden = false
      activityIndicator.startAnimating()
    }
  }
  
  /**
  Called when query for the objects has completed and the objects array
  has been updated.
  
  :param: error Error from fetching data (if any)
  */
  func objectsDidLoad(error: NSError?) -> Void {
    toggleSeparatorStyle()
    // Done Loading
    if isFirstLoad {
      isFirstLoad = false
      tableView.separatorStyle = savedSeparatorStyle
    }
    
    isLoading = false
    isRefreshing = false
    if activityIndicator != nil {
      activityIndicator.stopAnimating()
    }
    refreshControl!.endRefreshing()
    
    // Reload that data
    tableView.reloadData()
  }
  
  private func toggleSeparatorStyle() {
    noDataLabel.removeFromSuperview()
    if objects.isEmpty && isViewLoaded() && !isLoading {
      tableView.separatorStyle = .None
      noDataLabel = UILabel()
      noDataLabel.text = noDataMessage
      tableView.addSubview(noDataLabel)
      noDataLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
      tableView.addConstraint(NSLayoutConstraint(item: noDataLabel, attribute: .CenterX, relatedBy: .Equal, toItem: tableView, attribute: .CenterX, multiplier: 1.0, constant: 0))
      tableView.addConstraint(NSLayoutConstraint(item: noDataLabel, attribute: .CenterY, relatedBy: .Equal, toItem: tableView, attribute: .CenterY, multiplier: 1.0, constant: -100))
      tableView.addConstraint(NSLayoutConstraint(item: noDataLabel, attribute: .Width, relatedBy: .Equal, toItem: tableView, attribute: .Width, multiplier: 1.0, constant: 0))
      noDataLabel.textColor = UIColor.darkGrayColor()
      noDataLabel.numberOfLines = 0
      noDataLabel.textAlignment = NSTextAlignment.Center
      noDataLabel.font = UIFont.standardBoldTitleFont()
    } else {
      tableView.separatorStyle = .SingleLine
    }
  }
  
  // MARK: - Sroll View Delegate
  
  /// When we hit the end of the scrollView, fetch more items!
  override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    var bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
    if bottomEdge >= scrollView.contentSize.height {
      isRefreshing = false
      performQuery()
    }
  }
  
 }
