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
    // Need to refresh to show table cells
    tableView.reloadData()
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

