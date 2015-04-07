//
//  UPMAccountActivityTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/28/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

class UPMAccountActivityTVC: UPMPFQueryTableVC {

  // MARK: - Public Propertie
  
  // MARK: UPMPFQueryTableVC
  
  override func queryForTable() -> PFQuery! {
    var query = PFQuery(className: "UPMActivity")
    query.whereKey("user", equalTo: PFUser.currentUser()!)
    query.cachePolicy = .NetworkElseCache
    query.orderByDescending("createdAt")
    return query
  }
  
  // MARK: - Private Properties 
  
  /// Progress HUD 
  lazy var progressHUD: MBProgressHUD = {
    var ph = MBProgressHUD()
    self.view.addSubview(self.progressHUD)
    ph.userInteractionEnabled = false
    return ph
  }()
  
  // MARK: - Public Methods
  
  override init!(style: UITableViewStyle, className aClassName: String!) {
    super.init(style: style, className: "UPMOtherListing")

  }

  required internal init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }
  
  // MARK: - View Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    SALQuickTutorialViewController.showIfNeededForKey("AccountActivity111", title: "Activity", message: "Account: Activity - Displays all your acions on UP Market.", image: UIImage(named: "activityTut.png"))

    
    
    tableView.estimatedRowHeight = 50.0
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.userInteractionEnabled = true
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    tableView.userInteractionEnabled = false
  }
  

  // MARK - Private Methods
  
 
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
    var activity = object as UPMActivity
    
    if indexPath.section == objects.count {
      var loadMoreCell = tableView.cellForRowAtIndexPath(indexPath)
      return loadMoreCell as PFTableViewCell
    }
    
    var cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell") as? UPMAccountActivityCell ?? UPMAccountActivityCell(style: .Default, reuseIdentifier: "ActivityCell")
    cell.configureCellForActivity(activity: activity)

    return cell
  }
  
  
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }

    // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
      if editingStyle == .Delete {
          // Delete the row from the data source
          tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      } else if editingStyle == .Insert {
          // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
      }    
  }
  
  override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
    let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete", handler: { (action, indexPath) -> Void in
      if let activity = self.objectAtIndexPath(indexPath) as? UPMActivity {
        self.APP().huddie()
        self.APP().hud.labelText = "Deleting..."
        activity.title = ""
        activity.deleteInBackground().continueWithBlock {
          [unowned self] (task) in
          
          if let error = task.error {
            self.hideHuddieWithMessage("Error", delay: 0.1) {
              [unowned self] in
              self.displayErrorAlertWithMessage(error.localizedDescription)
            }
          } else {
            self.hideHuddieWithMessage("Success", delay: 0.2) {
              self.loadObjects()
            }
          }
          
          return nil
        }
      }
    })
    deleteAction.backgroundColor = UIColor.flatLightRedColor()
    return [deleteAction]
  }

}





