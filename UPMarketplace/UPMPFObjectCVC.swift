import UIKit

/**
  Used to display PFObjects from parse. Fetches data in a "pagination" style.
  However, pages are automatically loaded for an endless-scroll feel.
  */
class UPMPFObjectCVC: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  // MARK: - Public Properties

  /// Number of objects per page
  var objectsPerPage: UInt = 25
  
  /// Status of fetching data from parse
  var isLoading: Bool = false
  
  /// Should objects be seperated into pages, that load automatically.
  var paginationEnabled: Bool = true
  
  /// All of the currenlty fetched objects.
  var objects: [PFObject] = [PFObject]()
  
  /// Enable activity indicator in middle of screen when loading
  var activityViewEnabled = false
  
  /// Enable pull to refresh
  var pullToRefreshEnabled: Bool = true
  
  /// Currently refreshing the data (pulled to refresh)
  var isRefreshing: Bool = false
  
  // MARK: - Private Properties
  
  /// Loading indicator dispalyed in middle of screen
  var activityIndicator: UIActivityIndicatorView!
  
  /// Pull to refresh control
  var refreshControl: UIRefreshControl!

  // MARK: - Public Methods
  
  /// Performs query for objects on load and sets up pull to refresh.
  override func viewDidLoad() {
    super.viewDidLoad()
    changeDefaults()
    performQuery()
    if pullToRefreshEnabled {
      refreshControl = UIRefreshControl()
      refreshControl.tintColor = UIColor.grayColor()
      refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
      collectionView.addSubview(refreshControl)
      collectionView.alwaysBounceVertical = true
    }
  }
  
  /// Display label when there is no data
  func displayNoDataAvailable() -> Void {
    var messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: view.bounds.size.height))
    
    messageLabel.text = "No data is currently available. Please pull down to refresh.";
    messageLabel.textColor = UIColor.darkGrayColor()
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = NSTextAlignment.Center
    messageLabel.font = UIFont.systemFontOfSize(16.0)
    
    collectionView.backgroundView = messageLabel;

  }
  
  /// Override to change the default values before the first data is fetched
  func changeDefaults() -> Void {
    
  }
  
  /// Override to provide a query for objects
  func query() -> PFQuery {
    return PFQuery()
  }
  
  /// May need to override if using multiple sections
  func objectAtIndexPath(indexPath: NSIndexPath) -> PFObject {
    return objects[indexPath.row]
  }
  
  // MARK: - Collection View Datasource
  
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    // Do not display anything if fetching data
    return isLoading ? 0 : 1
  }
  
  /// Default is one section
  override func collectionView(collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
      if objects.isEmpty {
        displayNoDataAvailable()
      }
      return objects.count
  }
  
  /**
  Must override to provide to a UICollectionViewCell
  
  :param: indexPath The indexPath the cell will be displayed at
  :param: collectionView The collection view requesting the cell.
  :param: object PFObject corresponding to indexPath.
  */
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject) -> UICollectionViewCell {
    return UICollectionViewCell()
  }

  /// Obtains cell from other method... Provides object.
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

    return self.collectionView(collectionView, cellForItemAtIndexPath: indexPath, object: objects[indexPath.row])
  }
  
  // MARK: - Private Methods
  func refreshControlAction(sender: AnyObject) {
    isRefreshing = true
    performQuery()
  }
  
  /// Uses performQuery() to fetch data from parse in background.
  func performQuery() -> Void {
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
    
    queryToPeform.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
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
      //self.objects.removeAll(keepCapacity: false)
      self.objectsDidLoad(error)
    } // end block
  }
  
  /// Prepare for fetching data from parse
  func objectsWillLoad() -> Void {
    // Begin loading objects
    isLoading = true
    
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
    // Done Loading
    isLoading = false
    isRefreshing = false
    if activityIndicator != nil {
      activityIndicator.stopAnimating()
    }
    refreshControl.endRefreshing()
    
    // Reload that data
    collectionView.reloadData()
  }
  
  // MARK: Sroll View Delegate
  
  /// When we hit the end of the scrollView, fetch more items!
  override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    var bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
    if bottomEdge >= scrollView.contentSize.height {
      isRefreshing = false
      performQuery()
    }
  }

}
