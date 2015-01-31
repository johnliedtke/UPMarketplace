//
//  UPMAccountActivityTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/28/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit


class UPMAccountActivityCell: PFTableViewCell {
  
  lazy var messageLabel: UILabel = {
    var label = UILabel()
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(label)
    label.font = UIFont.systemFontOfSize(14.0)
    label.numberOfLines = 0
    return label
  }()
  
  lazy var iconImageView: UIImageView = {
    var iv = UIImageView()
    iv.setTranslatesAutoresizingMaskIntoConstraints(false)
    iv.backgroundColor = UIColor.purpleColor()
    self.contentView.addSubview(iv)
    return iv
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    // Elements dictionary, holds all subviews
    var ed = NSDictionary(dictionary: ["messageLabel": messageLabel, "iconImageView": iconImageView])
    
    // Layout
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-[iconImageView(50)]-[messageLabel]-(>=8)-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-[iconImageView(50)]-(>=8)-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-[messageLabel]-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
}

class UPMAccountActivityTVC: UPMPFQueryTableVC {

  // MARK: - Public Properties
  
  
  
  // MARK: UPMPFQueryTableVC
  
  override func queryForTable() -> PFQuery! {
    var query = PFQuery(className: "UPMOtherListing")
    
    return query
  }
  
  
  
  // MARK: - Private Properties 
  
  // MARK: - Public Methods
  
  override init!(style: UITableViewStyle, className aClassName: String!) {
    super.init(style: style, className: "UPMOtherListing")

  }

  required internal init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK - Private Methods
  
 
  // MARK: - Table view data source

  
  override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
    var listing = object as UPMOtherListing
    
    if indexPath.section == objects.count {
      var loadMoreCell = tableView.cellForRowAtIndexPath(indexPath)
      return loadMoreCell as PFTableViewCell
    }

    //var cell = UPMAccountActivityCell(style: .Default, reuseIdentifier: "Meow")
    var cell = UPMAccountListingCell(style: .Default, reuseIdentifier: "Meow")
    
    cell.statusLabel.text = "Status: Accepted"
    cell.titleLabel.text = listing.title

    
    return cell
  }

  
  
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

  
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}


public class UPMPFQueryTableVC: PFQueryTableViewController {
  
  // MARK: - Public Properties
  
  /// The key used on fetched PFObjects to put them into sections
  public var sectionKey: String = "category"
  
  // MARK: - Private Properties
  
  
  /// Contains all the indices (for objects) corresponding to a section
  private var sectionIndices = [String: [Int]]()
  
  /** 
  Maps a section to a sectionKey that can be used to obtain the indices for
  a section
  */
  private var sectionToKeyMap = [Int: String]()
  
  // MARK: - Public Methods
  
  
  // MARK: - Init
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  // MARK: Private Methods
  
  /**
  Fetches the section key given a section that can be used to retreive 
  the indices from sectionIndices
  
  :returns: Section's key
  */
  private func keyForSection(section: Int) -> String {
    return sectionToKeyMap[section]!
  }

  override init() {
    super.init()
    self.pullToRefreshEnabled = true
    self.paginationEnabled = true
    self.objectsPerPage = 25
  }
  
  
  // MARK: - Init
  // Crashes without all these stupid inits
  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init!(style: UITableViewStyle, className aClassName: String!) {
    super.init(style: style, className: aClassName)
  }
  
  override init(style: UITableViewStyle) {
    super.init(style: style)
    
    self.pullToRefreshEnabled = true
    self.paginationEnabled = true
    self.objectsPerPage = 5
  }
 

  
  
  // MARK: - PFQueryTableViewController
  
  override public func objectsDidLoad(error: NSError!) {
    super.objectsDidLoad(error)
    sectionIndices.removeAll(keepCapacity: false)
    sectionToKeyMap.removeAll(keepCapacity: false)
    
    var section = 0
    for (rowIndex, object) in enumerate(objects as [PFObject]) {
      var currentSectionKey = object.objectForKey(sectionKey) as String
      var objectsInSection = sectionIndices[currentSectionKey]
      
      // First time we've seen sectionKey
      if objectsInSection == nil {
        objectsInSection = [Int]()
        sectionToKeyMap[section++] = currentSectionKey
      }
      objectsInSection?.append(rowIndex)
      sectionIndices[currentSectionKey] = objectsInSection!
    }
  }
  
  override public func objectAtIndexPath(indexPath: NSIndexPath!) -> PFObject! {
    var currentSectionKey = keyForSection(indexPath.section)
    var rowIndicesInSection = sectionIndices[currentSectionKey]!
    
    var rowIndex = rowIndicesInSection[indexPath.row]
    return objects[rowIndex] as PFObject
  }
  
  // MARK: - UITableViewDatasource
  
  public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return sectionToKeyMap.count
  }
  
  public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var currentSectionKey = keyForSection(section)
    var rowsInSection = sectionIndices[currentSectionKey]!
    return rowsInSection.count
  }
  
  public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return keyForSection(section)
  }
  
  
}




