//
//  UPMAccountSellingTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/28/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit



class UPMAccountSellingTVC: UPMPFQueryTableVC {

  // MARK: - Public Properties
  
  // MARK: UPMPFQueryTableVC
  
  override func queryForTable() -> PFQuery! {
    var query = PFQuery(className: "UPMOtherListing")
    query.whereKey("owner", equalTo: PFUser.currentUser())
    return query
  }
  
  // MARK: - Private Properties
  
  // MARK: - Public Methods
  
  
  // MARK: - Init
  
  override init!(style: UITableViewStyle, className aClassName: String!) {
    super.init(style: style, className: "UPMOtherListing")
  }
  
  required internal init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK - Private Methods
  
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
    var listing = object as! UPMListing
    
    if indexPath.section == objects.count {
      var loadMoreCell = tableView.cellForRowAtIndexPath(indexPath)
      return loadMoreCell as! PFTableViewCell
    }
    var cell = UPMAccountListingCell(style: .Default, reuseIdentifier: "Meow")
    
    cell.statusLabel.text = listing.displayReservationStatus()
    //cell.changeStatusColor(UPMReservation.reservationStatus(rawValue: listing.status))
    cell.titleLabel.text = listing.title
    cell.displayImageView.file = listing.pictureThumbnail
    cell.displayImageView.loadInBackground()
    
    // Add long press
    var gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
    cell.addGestureRecognizer(gestureRecognizer)
    
    return cell
  }
  
  /**
  Handle long press of cells.
  */
  func handleLongPress(sender: UILongPressGestureRecognizer) {
    if sender.state == .Ended { // No second press
      return
    }
    
    // Grab the cell long pressed
    var point = sender.locationInView(tableView)
    var indexPath = tableView.indexPathForRowAtPoint(point)
    var listing = objectAtIndexPath(indexPath) as! UPMListing
    
    var actionSheet = UIAlertController(title: "Reservation Options", message: "", preferredStyle: .ActionSheet)
    
    // Contact action
    var contactAction = UIAlertAction(title: "Contact Buyer", style: .Default) {
      (action: UIAlertAction!) -> Void in
      var contactVC = UPMContactVC.initWithNavigationController(PFUser.currentUser(), withSubject: "Question about: \(listing.title)")
      self.navigationController?.presentViewController(contactVC, animated: true, completion: nil)
    }
    
    // Delete reservation action
    var deleteReservationAction = UIAlertAction(title: "Reject Reservation", style: .Default) {
      (action: UIAlertAction!) -> Void in
      
    }
    
    // Dismiss action
    var dismissAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    
    // Add actions
    actionSheet.addAction(contactAction)
    actionSheet.addAction(deleteReservationAction)
    actionSheet.addAction(dismissAction)
    
    // Present
    navigationController?.presentViewController(actionSheet, animated: true, completion: { () -> Void in
    })
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
         // tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      } else if editingStyle == .Insert {
          // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
      }    
  }

  override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
    
    var viewReservationsAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Reservations", handler:{action, indexpath in
      var accountReservationsTVC = UPMAccountReservationsTVC(style: .Plain, className: "UPMReservation")
      accountReservationsTVC.listing = self.objectAtIndexPath(indexPath) as? UPMListing
      self.navigationController?.pushViewController(accountReservationsTVC, animated: true)
    });
    viewReservationsAction.backgroundColor = UIColor.flatLightPurpleColor()
   
    return [viewReservationsAction];

  }

}

class UPMAccountReservationsTVC: UPMPFQueryTableVC {
  
  // The listing associated with the reservations.
  var listing: UPMListing?
  
  override func queryForTable() -> PFQuery! {
    var query: PFQuery?
    if let listing = self.listing {
      query = PFQuery(className: "UPMReservation")
      var array = [listing] as [AnyObject]
     // query.whereKey("listing", containedIn: array)
    }
    return query
  }
  
  
  
  override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
    var reservation = object as! UPMReservation
    
    if indexPath.section == objects.count {
      var loadMoreCell = tableView.cellForRowAtIndexPath(indexPath)
      return loadMoreCell as! PFTableViewCell
    }
    
    //var cell = UPMAccountActivityCell(style: .Default, reuseIdentifier: "Meow")
    var cell = UPMAccountListingCell(style: .Default, reuseIdentifier: "Meow")
    
    var status = UPMReservation.reservationStatus(rawValue: reservation.status)
    cell.statusLabel.text = reservation.displayStatus()
    cell.titleLabel.text = reservation.getListing().title
    cell.priceLabel.text = reservation.getListing().displayPrice()
//    cell.displayImageView.file = reservation.getListing().pictureThumbnail
  //  cell.displayImageView.loadInBackground()
//    cell.changeStatusColor(UPMReservation.reservationStatus(rawValue: reservation.status)!)
    
    return cell
  }

  
}





