//
//  UPMTablePickerVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 3/2/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import Foundation

protocol UPMTablePickerVCDelegate: class {
  func didSelectItem(sender: UPMTablePickerVC, item: AnyObject?)
}

class UPMTablePickerVC: UITableViewController {
  
  weak var delegate: UPMTablePickerVCDelegate?
  typealias T = String
  
  var rows = [String]()
  var datasource: SingleSectionDataSource<T> = SingleSectionDataSource<T>() {
    didSet { tableView.dataSource = datasource.tableViewDataSource }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let d = delegate {
      d.didSelectItem(self, item: datasource.getRow(indexPath))
      navigationController?.popViewControllerAnimated(true)
    }
  }
}

