//
//  UPMAccountSellerActionsTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 3/25/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

class UPMAccountSellerActionsTVC: UITableViewController {
  
  struct RowAction {
    var action: UPMListing.SellerAction
    var title: String
  }
  
  // MARK: - Public Properties

  /// Listing to display actions for
  var listing: UPMListing!
  
  private var dataSource = SectionedDataSource(sections: [Section<RowAction>]()) { (cell, row) -> (Void) in
    cell.textLabel!.text = row.title
  }
  
  /// Listing section
  private var listingSection: Section<RowAction>!
  
  /// Reservation section
  private var reservationSection: Section<RowAction>?
  
  // MARK: - View
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView = UITableView(frame: tableView.bounds, style: .Grouped)
    tableView.backgroundColor = UIColor.standardBackgroundColor()
    navigationItem.title = "Listing Options"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "didSelectDoneButton")
    createDatasource()
  }
  
  func didSelectDoneButton() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  // MARK: - Private
  
  private func createReservationSection() -> Section<RowAction>? {
    var section: Section<RowAction>!
    
    switch listing.sellerState() {
      
    case .Accepted:
      let rejectRow = RowAction(action: .RejectReservation, title: "Reject")
      let contactRow = RowAction(action: .ContactReserver, title: "Contact Reserver")
      let reserver = listing.getAcceptedReservation()?.reserver.username
      section = Section(header: "Reservation from \(reserver!)", rows: [rejectRow,contactRow])
      
    case .Waiting:
      let acceptRow = RowAction(action: .AcceptReservation, title: "Accept")
      let rejectRow = RowAction(action: .RejectReservation, title: "Reject")
      let contactRow = RowAction(action: .ContactReserver, title: "Contact Reserver")
      let reserver = listing.getWaitingReservation()?.reserver.fullNameOfUser()
      section = Section(header: "Reservation from \(reserver!)", rows: [acceptRow, rejectRow, contactRow])

    case .NoAction:
      section = nil
      
    default: break
    }
    
    return section
  }
  
  private func createListingSection() -> Section<RowAction> {
    let deleteListing = RowAction(action: .DeleteListing, title: "Delete Listing")
    return Section(header: "Listing Actions", rows: [deleteListing])
  }
  
  // MARK: - TableView Delegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let resHeader = reservationSection?.header
    if dataSource.sections[indexPath.section].header == resHeader {
      switch listing.sellerState() {
        
      /**
        Accepted Reservation Actions
      */
      case .Accepted:
        let reservation = listing.getAcceptedReservation()!

        switch reservationSection!.rows[indexPath.row].action {
          
          // Contact
        case .ContactReserver:
          self.presentViewController(UPMContactVC.initWithNavigationController(reservation.reserver, withSubject: listing.title!), animated: true, completion: nil)
          // end contact
          
          // Reject
        case .RejectReservation:
          displayConfirmationAlertWithTitle("Confirm Rejection", message: "Please confirm that you would like to REJECT this reservation.") {
            [unowned self] in
          
            self.APP().huddie()
            self.APP().hud.labelText = "Rejecting reservation..."

            self.listing.rejectReservationInBackground(reservation, blackList: true).continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock: { (task) in
              
              if let error = task.error {
                self.hideHuddieWithMessage("Error", delay: 0.1, action: nil)
                self.displayErrorAlertWithMessage(error.localizedDescription)
              } else {
                self.hideHUD(message: "Success")
              }
              
              return nil
          })
          }
        // end reject

        default: break
        }
        
      /**
        Waiting Reservation Actions
      */
      case .Waiting:
        let reservation = listing.getWaitingReservation()!
        
        switch reservationSection!.rows[indexPath.row].action {
          
          // Contact Reserver
        case .ContactReserver:
           self.presentViewController(UPMContactVC.initWithNavigationController(reservation.reserver, withSubject: listing.title!), animated: true, completion: nil)
          
          // Reject
        case .RejectReservation:
          displayConfirmationAlertWithTitle("Confirm Rejection", message: "Please confirm that you would like to REJECT this reservation.") {
            [unowned self] in
            
            self.APP().huddie()
            self.APP().hud.labelText = "Rejecting reservation..."
            
            self.listing.rejectReservationInBackground(reservation, blackList: true).continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock: { (task) in
              
              if let error = task.error {
                self.hideHuddieWithMessage("Error", delay: 0.1, action: nil)
                self.displayErrorAlertWithMessage(error.localizedDescription)
              } else {
                self.hideHUD(message: "Success")
              }
              
              return nil
            })
          }
          // end reject

          // Accept
        case .AcceptReservation:
          displayConfirmationAlertWithTitle("Confirm Reservation", message: "Please confirm that you would like to ACCEPT this reservation.") {
            [unowned self] in

            self.APP().huddie()
            self.APP().hud.labelText = "Accepting reservation..."
            
            self.listing.acceptReservationInBackground(reservation).continueWithBlock({
              [unowned self] (task) in
              
              if let error = task.error {
                self.hideHuddieWithMessage("Error", delay: 0.1, action: nil)
                self.displayErrorAlertWithMessage(error.localizedDescription)
              } else {
                self.hideHUD(message: "Success")
              }
              
              return nil
            })
          }
          // end accept
          
        default: break
        }
      default: break
      }
    
    
      /**
      Listing Actions
      */
    } else if let resHeader = listingSection?.header  {
      if dataSource.sections[indexPath.section].header == resHeader {
      if indexPath.row == 0 { // Delete Listing
        displayConfirmationAlertWithTitle("Confirm DELETION", message: "Please confirm the DELETION of your listing.") { [unowned self] in

        self.APP().huddie()
        self.APP().hud.labelText = "Deleting listing..."
        
        self.listing.deleteListingAndRelatedInBackground().continueWithBlock { [unowned self] (task) in
          
          if let error = task.error {
            self.hideHUD(message: "Error")
            self.displayErrorAlertWithMessage(error.localizedDescription)
          } else {
            self.hideHuddieWithMessage("Sucess", delay: 0.5) {
              self.dismissViewControllerAnimated(true, completion: nil)
            }
          }
          return nil
          }
        }

      }
      
    }
    }
    tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow()!, animated: true)
  }

  func hideHUD(#message: String) {
    self.hideHuddieWithMessage("Sucess", delay: 0.5) {
      self.createDatasource()
      self.tableView.reloadData()
    }
  }
  
  private func createDatasource() {
    dataSource.sections.removeAll(keepCapacity: true)
    if let reservationSection = createReservationSection() {
      self.reservationSection = reservationSection
      dataSource.sections.append(reservationSection)
    }
    listingSection = createListingSection()
    dataSource.sections.append(createListingSection())
    tableView.dataSource = dataSource.tableViewDataSource
  }

}
