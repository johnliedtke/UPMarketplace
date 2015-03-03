//
//  TableViewDataSource.swift
//  UPMarketplace
//
//  Created by John Liedtke on 3/2/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

/**
* Allows the UITableViewDataSource to talk to our datasource without knowing the underlying type is generic (which is against the rules for Obj-C objects)
*/
protocol SectionedDataSourceBridge{
  
  func numberOfSections() -> Int
  
  func numberOfRowsInSection(section: Int) -> Int
  
  func cellForRowAtIndexPath(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell
  
  func titleForHeaderInSection(section: Int) -> String?
  
  func titleForFooterInSection(section: Int) -> String?
}


class TableViewDataSource : NSObject, UITableViewDataSource {
  
  var sectionedDataSource : SectionedDataSourceBridge
  
  init (sectionedDataSource : SectionedDataSourceBridge) {
    self.sectionedDataSource = sectionedDataSource
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sectionedDataSource.numberOfRowsInSection(section)
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return sectionedDataSource.cellForRowAtIndexPath(tableView, indexPath: indexPath)
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return sectionedDataSource.numberOfSections()
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionedDataSource.titleForHeaderInSection(section)
  }
  
  func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return sectionedDataSource.titleForFooterInSection(section)
  }
}
