//
//  UPMAccountSellingTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/28/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit
/**
  The UPMAccountSellingTVC class displays all of the current user's listings. In additoin, 
  it the location where users can edit and delete his or her listings. 
*/
class UPMAccountSellingTVC: UPMPFQueryAllTVC {

  // MARK: - View
  
 
  override func viewDidLoad() {
    noDataMessage = "You are not selling anything.\nPull to refresh."
    sectionsEnabled = true
    sectionKey = ""
    determineSectionKey = { (listing) in
      if let l = listing as? UPMListing {
        return l.displaySellerReservationStatus()
      }
      return ""
    }
    super.viewDidLoad()
    
    SALQuickTutorialViewController.showIfNeededForKey("AccountSelling123123636123", title: "Sellling", message: "Selling - Displays everything you are selling. Swipe for actions!", image: UIImage(named: "sellingTut.png"))
    
    tableView.estimatedRowHeight = 50.0 // auto-layout fix
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    refreshControlAction(self)
  }
  
  override func queries() -> [PFQuery]? {
    var query = PFQuery(className: "UPMOtherListing")
    query.whereKey("owner", equalTo: PFUser.currentUser()!)
    query.includeKey("reservations")
    query.includeKey("reservations.reserver")
    query.includeKey("owner")
    var textbookListing = PFQuery(className: "UPMTextbookListing")
    textbookListing.whereKey("owner", equalTo: PFUser.currentUser()!)
    textbookListing.includeKey("reservations")
    textbookListing.includeKey("reservations.reserver")
    textbookListing.includeKey("textbook")
    textbookListing.includeKey("owner")
    return [query, textbookListing]
  }
  
  // MARK: - TableView Datasource
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject) -> UITableViewCell {
    
    var listing = object as UPMListing
    
    if indexPath.section == objects.count {
      var loadMoreCell = tableView.cellForRowAtIndexPath(indexPath)
      return loadMoreCell as PFTableViewCell
    }
    
    var cell = tableView.dequeueReusableCellWithIdentifier("UPMAccountListingCell") as UPMAccountListingCell!
    if cell == nil {
      cell = UPMAccountListingCell(style: .Default, reuseIdentifier: "UPMAccountListingCell")
    }
    
    cell.statusLabel.text = listing.displaySellerReservationStatus()
    cell.changeStatusColor(listing.sellerReservationStatus())
    cell.titleLabel.text = listing.title
//    cell.displayImageView.file = listing.pictureThumbnail
    //cell.displayImageView.loadInBackground()
    
    // Grab the picture-file and retrieve it from parse
    var imageFile = listing.pictureThumbnail
    if let url = imageFile?.url {
      cell.displayImageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: nil, completed: { [unowned self, cell] (image, error, cache, url) in
        })
    }
    
    
    
    cell.priceLabel.text = listing.displayPrice()
    
    // Add long press
//    var gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
//    cell.addGestureRecognizer(gestureRecognizer)
    
    return cell
  }
  
  
  // MARK: - Tableview Delegate
  
  override func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath,
    withObject object: PFObject) {
    var listing = objectAtIndexPath(indexPath)
    
      switch listing.parseClassName {
      case UPMOtherListing.parseClassName():
        if let otherListing = listing as? UPMOtherListing {
          var updateOtherListing = UPMSellOtherTVC()
          updateOtherListing.otherListng = otherListing
          updateOtherListing.isUpdatingListing = true
          navigationController?.pushViewController(updateOtherListing, animated: true)
        }
      case UPMTextbookListing.parseClassName():
        if let textbookListing = listing as? UPMTextbookListing {
          var textbookListingTVC = UPMSellTextbookTVC()
          textbookListingTVC.textbookListing = textbookListing
          textbookListingTVC.isUpdatingListing = true
          navigationController?.pushViewController(textbookListingTVC, animated: true)
        }
      default: break
      }
  }
  
  // MARK: - Edit Actions
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
      if editingStyle == .Delete {
      } else if editingStyle == .Insert {
      }
  }
  
//  override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
//    return UITableViewCellEditingStyle.Delete
//  }
  
  override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
    
    var listing = objectAtIndexPath(indexPath) as UPMListing
    
    // Create the table actions...
    if let actions = listing.availableSellerActions() {
      var editActions = [UITableViewRowAction]()
      for (action, actionFunc) in actions {
        editActions.append(UITableViewRowAction(style: .Default, title: action.description) { (rowAction, indexPath) in

          switch action {
          case .AcceptReservation, .RejectReservation, .DeleteListing:
            
            self.displayConfirmationAlertWithTitle("Confirm", message: "Please confirm \(action.description.capitalizedString).") {
              
              if UPMReachabilityManager.isUnreachable() {
                UPMReachabilityManager.alertOfNoNetworkConnectionInController(self)
                return
              }
              
              var hud = MBProgressHUD.showHUDAddedTo(self.tableView.superview, animated: true)
              hud.labelText = action.description
              
              actionFunc().continueWithBlock() { [unowned self] (task: BFTask!) in
                if task.error == nil {
                  hud.labelText = "Success"
                  sleep(1)
                  dispatch_async(dispatch_get_main_queue()) {
                    MBProgressHUD.hideAllHUDsForView(self.view.superview, animated: true)
                    self.performQuery()
                  }
                } else {
                  hud.labelText = "Error"
                  dispatch_async(dispatch_get_main_queue()) {
                    MBProgressHUD.hideAllHUDsForView(self.view.superview, animated: true)
                    return
                  }
                }
                return nil
              }
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
      let colors = [UIColor.flatLightOrangeColor(), UIColor.flatLightRedColor(), UIColor.flatLightGreenColor(), UIColor.blueColor()]

      for (index, editAction) in enumerate(editActions) {
        if editAction.title == UPMListing.SellerAction.AcceptReservation.description {
          editAction.backgroundColor = UIColor.flatGreenColor()
        } else if editAction.title == UPMListing.SellerAction.RejectReservation.description {
          editAction.backgroundColor = UIColor.flatLightRedColor()
        } else if editAction.title == UPMListing.SellerAction.ContactReserver.description {
          editAction.backgroundColor = UIColor.flatLightOrangeColor()
        }
      }
      
      let moreAction = UITableViewRowAction(style: .Normal, title: "More") {
        [unowned self] (action, indexPath) in
        let sellerActionsTVC = UPMAccountSellerActionsTVC()
        sellerActionsTVC.listing = listing
        self.presentViewController(UINavigationController(rootViewController: sellerActionsTVC), animated: true, completion: nil)
      }
      moreAction.backgroundColor = UIColor.flatDarkPurpleColor()
      editActions.append(moreAction)

      return editActions
      
    } else {
      return nil
    }
  }
}








