//
//  UPMAccountSellingTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/28/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit



class UPMAccountSellingTVC: PFQueryTableViewController {

  // MARK: - Public Properties
  
  // MARK: UPMPFQueryTableVC
  
  override func queryForTable() -> PFQuery! {
    var query = PFQuery(className: "UPMOtherListing")
    query.whereKey("owner", equalTo: PFUser.currentUser())
    query.includeKey("reservations")
    query.includeKey("reservations.reserver")
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
    tableView.estimatedRowHeight = 50.0
  }
  
  // MARK - Private Methods
  
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView!,
    cellForRowAtIndexPath indexPath: NSIndexPath!,
    object: PFObject!) -> PFTableViewCell! {
      
    var listing = object as! UPMListing
    
    if indexPath.section == objects.count {
      var loadMoreCell = tableView.cellForRowAtIndexPath(indexPath)
      return loadMoreCell as! PFTableViewCell
    }
      
      var cell = tableView.dequeueReusableCellWithIdentifier("UPMAccountListingCell") as! UPMAccountListingCell!
      if cell == nil {
        cell = UPMAccountListingCell(style: .Default, reuseIdentifier: "UPMAccountListingCell")
      }
    
    cell.statusLabel.text = listing.displaySellerReservationStatus()
    cell.changeStatusColor(listing.sellerReservationStatus())
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
  
  // MARK: - Tableview Delegate

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
  
  override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    var listing = objectAtIndexPath(indexPath) as! UPMListing
    if !listing.isReserved() {
      return UITableViewCellEditingStyle.None
    } else {
      return UITableViewCellEditingStyle.Delete
    }
  }

  override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
    
    var listing = objectAtIndexPath(indexPath) as! UPMListing
    
    // Create the table actions...
    if let actions = listing.availableSellerActions() {
      var editActions = [UITableViewRowAction]()
      for (action, actionFunc) in actions {
        editActions.append(UITableViewRowAction(style: .Default, title: action.description) { (rowAction, indexPath) in

          switch action {
          case .AcceptReservation, .RejectReservation:
            
            if UPMReachabilityManager.isUnreachable() {
              UPMReachabilityManager.alertOfNoNetworkConnectionInController(self)
              return
            }
            
            var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = action.description
            
            actionFunc().continueWithBlock() { (task: BFTask!) in
              if task.error == nil {
                hud.labelText = "Success"
                sleep(1)
                dispatch_async(dispatch_get_main_queue()) {
                  MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                  self.loadObjects()
                }
              } else {
                hud.labelText = "Error"
                dispatch_async(dispatch_get_main_queue()) {
                  MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                }
              }
              return nil
            }

          case .ContactReserver:
            actionFunc().continueWithBlock({ (task) in
              if let contactNavigation = task.result as? UINavigationController {
                self.navigationController?.presentViewController(contactNavigation, animated: true, completion: nil)
              }
              return nil
            })

          default: break
          }
        })
      }
      let colors = [UIColor.flatLightOrangeColor(), UIColor.flatLightRedColor(), UIColor.flatLightGreenColor()]

      for (index, editAction) in enumerate(editActions) {
        editAction.backgroundColor = colors[index]
      }
      return editActions
      
    } else {
      return nil
    }
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
  
  


  
}





