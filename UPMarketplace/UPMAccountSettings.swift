//
//  UPMAccountSettings.swift
//  UPMarketplace
//
//  Created by John Liedtke on 2/28/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

class UPMAccountSettings: UITableViewController {
  
  var rows = [Section:[Row]]()

  enum Section: Int {
    case Account
    static let allValues = [Account]
    var description: String {
      get {
        switch self {
        case .Account:
          return "Account"
        default: break
        }
      }
    }

  }
  
  enum Row: Int, Printable {
    case Logout
    
    var description: String {
      get {
        switch self {
        case .Logout:
          return "Logout"
        default: break
        }
      }
    }
  }
  
  
  let NUMBER_OF_SECTIONS = 1
  
  // MARK: - View
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView = UITableView(frame: self.tableView.frame, style: .Grouped)
    navigationItem.title = "Settings"
    
    for s in Section.allValues {
      switch s {
      case .Account:
        rows[s] = [Row.Logout]
      }
    }
  }
  
  // MARK: - TableView Datasource
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return Section.allValues.count
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let sec = Section(rawValue: section), let rowArray = rows[sec] {
      return rowArray.count
    }
    return 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cellIdentifier = "SettingsCell"
    
    var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
    
    if cell == nil {
      cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
    }
    
    if let section = Section(rawValue: indexPath.section), let arows = rows[section] {
      cell?.textLabel?.text = arows[indexPath.row].description
    }
    
    return cell!
    
  }
  
  
  override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    
  }
  
  
}
