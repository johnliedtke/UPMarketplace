//
//  UPMAccountActivityTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/28/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

class UPMAccountActivityTVC: UPMPFQueryTableVC {

  // MARK: - Public Properties
  
  // MARK: UPMPFQueryTableVC
  
  override func queryForTable() -> PFQuery! {
    var query = PFQuery(className: "UPMOtherListing")
    
    return query
  }
  
  // MARK: - Private Properties 
  
  // MARK: - Public Methods
  
  override init!(style: UITableViewStyle, className aClassName: String!) {
    super.init(style: style, className: "UPMOtherListing")

  }

  required internal init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    var reservationsQuery = PFQuery(className: "UPMReservation")
    reservationsQuery.whereKey("reserver", equalTo: PFUser.currentUser())

    reservationsQuery.findObjectsInBackground().continueWithBlock { (task: BFTask!) -> AnyObject! in
      
      var reservations = task.result as [UPMReservation]
      
      var listingsQuery = PFQuery(className: "UPMOtherListing")
      listingsQuery.whereKey("reservations", containedIn: reservations)

      
      
      return listingsQuery.findObjectsInBackground()
      }.continueWithBlock { (task: BFTask!) -> AnyObject! in
        if task.error == nil {
          var result = task.result as [UPMListing]
          println("Success")
          return PFObject.fetchAllInBackground(result)
        } else {
          return task.error
        }
      }.continueWithBlock { (task: BFTask!) -> AnyObject! in
        if task.error == nil {
          var result = task.result as [UPMListing]
          for l in result {
            var desc = l.price
            println(desc)
          }
          println("Success")
          return nil
        } else {
          return task.error
        }
    }
    
  }

  // MARK - Private Methods
  
 
  // MARK: - Table view data source

  
  override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
    var listing = object as UPMOtherListing
    
    if indexPath.section == objects.count {
      var loadMoreCell = tableView.cellForRowAtIndexPath(indexPath)
      return loadMoreCell as PFTableViewCell
    }

    //var cell = UPMAccountActivityCell(style: .Default, reuseIdentifier: "Meow")
    var cell = UPMAccountListingCell(style: .Default, reuseIdentifier: "Meow")
    
    cell.statusLabel.text = "Status: Accepted"
    cell.titleLabel.text = listing.title

   // cell.layoutIfNeeded()
    
    return cell
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.userInteractionEnabled = true

    
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    tableView.estimatedRowHeight = 50.0
    tableView.userInteractionEnabled = false

  }
  

  

  
  
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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





