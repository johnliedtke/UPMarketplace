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
    query.whereKey("user", equalTo: PFUser.currentUser())
    query.cachePolicy = kPFCachePolicyNetworkElseCache
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
    tableView.estimatedRowHeight = 50.0

//    tableView.estimatedRowHeight = 100.0
    //tableView.registerClass(UPMAccountActivityCell.self, forHeaderFooterViewReuseIdentifier: "ActivityCell")
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
  var isDisplayingActionSheet = false
  
 
  // MARK: - Table view data source

  
  override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
    var activity = object as! UPMActivity
    
    if indexPath.section == objects.count {
      var loadMoreCell = tableView.cellForRowAtIndexPath(indexPath)
      return loadMoreCell as! PFTableViewCell
    }
    
    var cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell") as? UPMAccountActivityCell ?? UPMAccountActivityCell(style: .Default, reuseIdentifier: "ActivityCell")
    cell.configureCellForActivity(activity: activity)

    return cell
  }
  
  
  /**
  Handle long press of cells.
  */
  func handleLongPress(sender: UILongPressGestureRecognizer) {
    if sender.state == .Ended { // No second press
     return
    }
    isDisplayingActionSheet = true
    



    
    // Grab the cell long pressed
    var point = sender.locationInView(tableView)
    var indexPath = tableView.indexPathForRowAtPoint(point)
    var reservation = objectAtIndexPath(indexPath) as! UPMReservation
    
    var actionSheet = UIAlertController(title: "Reservation Options", message: "", preferredStyle: .ActionSheet)
    
    // Contact action
    var contactAction = UIAlertAction(title: "Contact Seller", style: .Default) {
      (action: UIAlertAction!) -> Void in
      var contactVC = UPMContactVC.initWithNavigationController(PFUser.currentUser(), withSubject: "Question about: \(reservation.getListing().title)")
      self.navigationController?.presentViewController(contactVC, animated: true, completion: nil)
    }
    
    // Delete reservation action
    var deleteReservationAction = UIAlertAction(title: "Delete Reservation", style: .Default) {
      (action: UIAlertAction!) -> Void in
      
      // Network connection
      if UPMReachabilityManager.isUnreachable() {
        UPMReachabilityManager.alertOfNoNetworkConnectionInController(self.navigationController!)
        return
      }
      
      MBProgressHUD.showHUDAddedTo(self.view, animated: true)
      
       // delete reservation
        reservation.getListing().deleteReservationInBackground(reservation, blackList: true).continueWithBlock {
        (task: BFTask!) -> AnyObject! in
        //self.progressHUD.hide(true)
        MBProgressHUD.hideAllHUDsForView(self.view, animated: false)
        if task.error == nil {
          self.loadObjects()
        } else {
          
        }
          return nil
        }
    }
    
    // Dismiss action
    var dismissAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    
    // Add actions
    actionSheet.addAction(contactAction)
    actionSheet.addAction(deleteReservationAction)
    actionSheet.addAction(dismissAction)
    
    // Present
    navigationController?.presentViewController(actionSheet, animated: true, completion: { () -> Void in
      self.isDisplayingActionSheet = false
    })
    
  }
  
  func deleteReservation() -> Void {
    self.progressHUD.show(true)

  }
  
    // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
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





