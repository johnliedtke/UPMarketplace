//
//  UPMPFQueryTableVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/31/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

/**
@abstract 
  Modified PFQueryTableViewController to support sections.
*/
public class UPMPFQueryTableVC: PFQueryTableViewController {
  
  // MARK: - Public Properties
  
  /// The key used on fetched PFObjects to put them into sections
  public var sectionKey: String = "message"
  
  public var noDataMessage: String = "No data available."
  
  // MARK: - Private Properties
  
  /// Contains all the indices (for objects) corresponding to a section
  private var sectionIndices = [String: [Int]]()
  
  /// No Data Label
  var noDataLabel = UILabel()
  
  /**
  Maps a section to a sectionKey that can be used to obtain the indices for
  a section
  */
  private var sectionToKeyMap = [Int: String]()
  
  // MARK: - Public Methods
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    tableView.estimatedRowHeight = 50.0
  }
  
  // MARK: - Init
  
  // MARK: Private Methods
  
  /**
  Fetches the section key given a section that can be used to retreive
  the indices from sectionIndices
  
  :returns: Section's key
  */
  private func keyForSection(section: Int) -> String {
    return sectionToKeyMap[section]!
  }
  
  // MARK: - Init
  
  // Crashes without all these stupid inits
  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init!(style: UITableViewStyle, className aClassName: String!) {
    super.init(style: style, className: aClassName)
  }
  
  // MARK: - PFQueryTableViewController
  
  override public func objectsDidLoad(error: NSError!) {
    super.objectsDidLoad(error)
    sectionIndices.removeAll(keepCapacity: false)
    sectionToKeyMap.removeAll(keepCapacity: false)
    
    var section = 0
    for (rowIndex, object) in enumerate(objects as! [PFObject]) {
      
      var currentSectionKey: String!
      
      if let secKey = object.objectForKey(sectionKey) as? Int {
        //FIXME: Do this better
        currentSectionKey = ReservationStatus(rawValue: secKey)?.description
      } else {
        currentSectionKey = object.objectForKey(sectionKey) as! String
      }
      
      var objectsInSection = sectionIndices[currentSectionKey]
      
      // First time we've seen sectionKey
      if objectsInSection == nil {
        objectsInSection = [Int]()
        sectionToKeyMap[section++] = currentSectionKey
      }
      objectsInSection?.append(rowIndex)
      sectionIndices[currentSectionKey] = objectsInSection!
    }
    // Need to refresh to show table cells
    tableView.reloadData()
  }
  
  public func queries() -> [PFQuery]? {
    return nil
  }
  
  override public func objectAtIndexPath(indexPath: NSIndexPath!) -> PFObject! {
    var currentSectionKey = keyForSection(indexPath.section)
    var rowIndicesInSection = sectionIndices[currentSectionKey]!
    
    var rowIndex = rowIndicesInSection[indexPath.row]
    return objects[rowIndex] as! PFObject
  }
  
  // MARK: - UITableViewDatasource
  
  public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    displayNoDataAvailable()
    return sectionToKeyMap.count
  }
  
  public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var currentSectionKey = keyForSection(section)
    var rowsInSection = sectionIndices[currentSectionKey]!

    return rowsInSection.count
  }

  func displayNoDataAvailable() {
    
    if objects.isEmpty {
    tableView.addSubview(noDataLabel)
    noDataLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
    tableView.addConstraint(NSLayoutConstraint(item: noDataLabel, attribute: .CenterX, relatedBy: .Equal, toItem: tableView, attribute: .CenterX, multiplier: 1.0, constant: 0))
    tableView.addConstraint(NSLayoutConstraint(item: noDataLabel, attribute: .CenterY, relatedBy: .Equal, toItem: tableView, attribute: .CenterY, multiplier: 1.0, constant: -100))
    tableView.addConstraint(NSLayoutConstraint(item: noDataLabel, attribute: .Width, relatedBy: .Equal, toItem: tableView, attribute: .Width, multiplier: 1.0, constant: 0))
    noDataLabel.text = noDataMessage
    noDataLabel.textColor = UIColor.darkGrayColor()
    noDataLabel.numberOfLines = 0
    noDataLabel.textAlignment = NSTextAlignment.Center
    noDataLabel.font = UIFont.standardBoldTitleFont()
    tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    } else {
      noDataLabel.removeFromSuperview()
    }
  }

  
  
}

