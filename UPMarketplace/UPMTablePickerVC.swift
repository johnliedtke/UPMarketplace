//
//  UPMTablePickerVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 3/2/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import Foundation


protocol UPMTablePickerVCDelegate: class {
  func didSelectItem(sender: UPMTablePickerVC, item: AnyObject)
}

class UPMTablePickerVC: UITableViewController {
  
  let CategoryCellIdentifer = "UPMOtherListingCategoryCell"
  weak var delegate: UPMTablePickerVCDelegate?
  
  var rows: [String] = ["Furniture",	"Appliance",	"Transportation",	"Clothing", "Decor",	"Cooking", "School",	"Outdoors", "Electronics"]
  lazy var datasource: SingleSectionDataSource<String> = {
    return SingleSectionDataSource(rows: self.rows)
    }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = datasource.tableViewDataSource
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let d = delegate {
      //d.didSelectItem(self, item: datasource.itemAtIndexPath(indexPath))
      navigationController?.popViewControllerAnimated(true)
    }
  }
}

