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
  private let facebook = "Link Facebook Account"
  private let unlinkFacebook = "Unlink Facebook Account"

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
    setupDataSource()
    tableView.dataSource = dataSource.tableViewDataSource
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let row = dataSource.sections[indexPath.section].rows[indexPath.row]
    let user = PFUser.currentUser()!
    
    if row == logout {
      PFUser.logOut()
      tabBarController?.selectedIndex = 0
      
    } else if row == about {
      let aboutStoryboard = UIStoryboard(name: "about", bundle: nil)
      navigationController?.pushViewController(aboutStoryboard.instantiateInitialViewController() as! UIViewController, animated: true)
      
    } else if row == facebook {
      var permissions = ["email", "publish_actions"]
      PFFacebookUtils.linkUserInBackground(user, permissions: permissions).continueWithBlock({ (task) -> AnyObject! in
        self.setupDataSource()
        self.APP().huddie(labelText: "Finishing...")
        self.delay(1.0) {
          self.hideHuddieWithMessage("Unlinked..", delay: 0.2) {
            self.navigationController?.popViewControllerAnimated(true)
          }
        }
        return nil
      })
      
    } else if row == unlinkFacebook {
      APP().huddie(labelText: "Unlinking...")
      PFFacebookUtils.unlinkUserInBackground(user).continueWithBlock {
        [unowned self] (task) in
        self.hideHuddieWithMessage("Unlinked..", delay: 0.2) {
          self.setupDataSource()
          self.tableView.reloadData()
        }
        return nil
      }
    }
  }
  
  private func setupDataSource() {
    var rows = [self.logout, self.emailNotficiations, self.about]

    if PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()!) {
      rows.append(self.unlinkFacebook)
    } else {
      rows.append(facebook)
    }

    accountSection = Section(header: "Account", rows: rows)
    dataSource.sections.removeAll(keepCapacity: true)
    dataSource.sections.append(accountSection)
    if let selectedIndexPath = tableView.indexPathForSelectedRow() {
      tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
    }

  }
  
  
}
