//
//  UPMAccountSettings.swift
//  UPMarketplace
//
//  Created by John Liedtke on 2/28/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

class UPMAccountSettings: UITableViewController {
  
  /// Datasource

  /// Row constants
  private let logout = "Logout"
  private let emailNotficiations = "Email Notifications"
  private let about = "About"
  
  private var accountSection = Section(header: "Account", rows: [String]())
  
  /// Datasource
  lazy private var dataSource: SectionedDataSource<String> = SectionedDataSource(sections: [self.accountSection]) {
    (cell, row) in
    cell.textLabel?.text = row
    
    if row == self.emailNotficiations {
      let cellSwitch = UISwitch(frame: CGRectZero)
      cellSwitch.on = UPMUserPrefs.emailNotificationsEnabled()
      cellSwitch.addTarget(self, action: "didSwitchChange:", forControlEvents: .ValueChanged)
      cell.accessoryView = cellSwitch
      cell.selectionStyle = .None
    }
  }
  
  func didSwitchChange(aSwitch: UISwitch) {
    UPMUserPrefs.toggleEmailNotifications(on: aSwitch.on)
  }
  
  // MARK: - View
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView = UITableView(frame: self.tableView.frame, style: .Grouped)
    navigationItem.title = "Settings"
    accountSection = Section(header: "Account", rows: [self.logout, self.emailNotficiations, self.about])
    tableView.dataSource = dataSource.tableViewDataSource
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let row = dataSource.sections[indexPath.section].rows[indexPath.row]

    if row == logout {
      PFUser.logOut()
      tabBarController?.selectedIndex = 0
    } else if row == about {
      let aboutStoryboard = UIStoryboard(name: "about", bundle: nil)
      navigationController?.pushViewController(aboutStoryboard.instantiateInitialViewController() as UIViewController, animated: true)
    }
  }
}
