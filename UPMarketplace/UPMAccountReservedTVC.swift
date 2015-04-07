//
//  UPMAccountReservedTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/28/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

class UPMAccountReservedTVC: UPMPFQueryTableVC {

    // MARK: - Public Properties
    
    // MARK: Query
    override func queryForTable() -> PFQuery! {
      var query = PFQuery(className: "UPMReservation")
      query.whereKey("reserver", equalTo: PFUser.currentUser()!)
      query.includeKey("listing")
      query.includeKey("listing.owner")
      query.whereKeyExists("listing")
      query.cachePolicy = .NetworkElseCache
      query.includeKey("pictureThumbnail")
      query.orderByDescending("status")
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
    
    // MARK: - View
    
    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.estimatedRowHeight = 100.0
      noDataMessage = "You have not reserved anything.\nPull to refresh."
      tableView.allowsSelection = false
      
      SALQuickTutorialViewController.showIfNeededForKey("AccountReserved11331", title: "Reserved Listings", message: "Reserved - Displays all the listings that you have reserved. Swipe for actions.", image: UIImage(named: "reservedTut.png"))
      
    }
    
    override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      tableView.userInteractionEnabled = true
    }
    
    override func viewWillDisappear(animated: Bool) {
      super.viewWillDisappear(animated)
      tableView.userInteractionEnabled = false
    }
  
    // MARK - Private 
  
    /// Currently displaying an action sheet
    private var isDisplayingActionSheet = false
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
      var reservation = object as UPMReservation
      
      if indexPath.section == objects.count {
        var loadMoreCell = tableView.cellForRowAtIndexPath(indexPath)
        return loadMoreCell as PFTableViewCell
      }
      
      //var cell = UPMAccountActivityCell(style: .Default, reuseIdentifier: "Meow")
      var cell = UPMAccountListingCell(style: .Default, reuseIdentifier: "Meow")
      
      var status = ReservationStatus(rawValue: reservation.status)
      cell.statusLabel.text = reservation.displayStatus()
      cell.titleLabel.text = reservation.getListing().title
      cell.priceLabel.text = reservation.getListing().displayPrice()

      // Grab the picture-file and retrieve it from parse
      var imageFile = reservation.getListing().pictureThumbnail
      if let url = imageFile?.url {
        cell.displayImageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: nil, completed: { [unowned self, cell] (image, error, cache, url) in
          })
      }
      cell.changeStatusColor(ReservationStatus(rawValue: reservation.status)!)
      
      // Add long press
      var gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
      cell.addGestureRecognizer(gestureRecognizer)
      
      return cell
    }
    
    /**
    Handle long press of cells.
  
    :param: sender The gesture-recognizer that detected a long press.
    */
    func handleLongPress(sender: UILongPressGestureRecognizer) {
      if sender.state == .Ended { // No second press
        return
      }
      isDisplayingActionSheet = true
      
      // Grab the cell long pressed
      var point = sender.locationInView(tableView)
      var indexPath = tableView.indexPathForRowAtPoint(point)
      var reservation = objectAtIndexPath(indexPath) as UPMReservation
      
      var actionSheet = UIAlertController(title: "Reservation Options", message: "", preferredStyle: .ActionSheet)
      
      // Contact action
      var contactAction = UIAlertAction(title: "Contact Seller", style: .Default) {
        (action: UIAlertAction!) -> Void in
        var contactVC = UPMContactVC.initWithNavigationController(reservation.getListing().owner, withSubject: "Question about: \(reservation.getListing().title!)")
        self.navigationController?.presentViewController(contactVC, animated: true, completion: nil)
      }
      
      // Delete reservation action
      var deleteReservationAction = UIAlertAction(title: "Delete Reservation", style: .Default) {
        [unowned self] (action) in
        
        // Network connection
        if UPMReachabilityManager.isUnreachable() {
          UPMReachabilityManager.alertOfNoNetworkConnectionInController(self.navigationController!)
          return
        }
        
        self.APP().huddie(labelText: "Deleting...")
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        // delete reservation
        reservation.getListing().deleteReservationInBackground(reservation, blackList: true).continueWithBlock {
          [unowned self] (task: BFTask!) in

          if let error = task.error {
            self.hideHuddieWithMessage("Error", delay: 0.1) {
              self.displayErrorAlertWithMessage(error.localizedDescription)
            }
          } else {
            self.hideHuddieWithMessage("Success", delay: 0.4) {
              self.loadObjects()
            }
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

  override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
    var reservation = objectAtIndexPath(indexPath) as UPMReservation
    
    // Delete reservation
    var deleteReservationAction = UITableViewRowAction(style: .Default, title: "Delete", handler:{ [unowned self] action, indexpath in
      
      self.displayConfirmationAlertWithTitle("Confirm", message: "Please confirm the deletion of your reservation.") {
      
        // Network connection
        if UPMReachabilityManager.isUnreachable() {
          UPMReachabilityManager.alertOfNoNetworkConnectionInController(self.navigationController!)
          return
        }
        
        self.APP().huddie(labelText: "Deleting...")
        
        // delete reservation
        reservation.getListing().deleteReservationInBackground(reservation, blackList: true).continueWithBlock {
          [unowned self] (task: BFTask!) in
          
          if let error = task.error {
            self.hideHuddieWithMessage("Error", delay: 0.1) {
              self.displayErrorAlertWithMessage(error.localizedDescription)
            }
          } else {
            self.hideHuddieWithMessage("Success", delay: 0.4) {
              self.loadObjects()
            }
          }
          return nil
        }
      }
    });
    deleteReservationAction.backgroundColor = UIColor.flatLightRedColor()
    // end delete
    
    // Contact
    var contactReservationAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Contact", handler:{action, indexpath in
      let owner = reservation.getListing()
    //  reservation.getListing().owner.fetch()
      var contactVC = UPMContactVC.initWithNavigationController(reservation.getListing().owner, withSubject: "Question about: \(reservation.getListing().title!)")
      self.navigationController?.presentViewController(contactVC, animated: true, completion: nil)

    });
    contactReservationAction.backgroundColor = UIColor.flatLightYellowColor()
    
    return [contactReservationAction, deleteReservationAction]
  }
    
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  }
  
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
}





