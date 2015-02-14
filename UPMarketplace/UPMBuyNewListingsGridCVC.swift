//
//  UPMBuyNewListingsGridCVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/21/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

/**
  The UPMBuyNewListingsGridCVC displays the most recent UPMListings that have
  been posted in the marketplace. These include UPMTextbookListing, UPMOtherListing,
  and UPMHousingListing.
*/
class UPMBuyNewListingsGridCVC: UPMBuyGridCVC {
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    navigationController?.navigationBar.backItem.title = "Back!"
    navigationController?.navigationBar.backItem?.title = "Back"
    // Check if a user is logged in
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    UPMLoginVC.displayLoginInController(self)
  }
    
  
  override func changeDefaults() {
  }
  
  //TODO: Change query to retrieve the three major UPMListing types.
  override func query() -> PFQuery {
    var listingQuery = PFQuery(className: "UPMOtherListing")
    listingQuery.orderByDescending("createdAt")
    listingQuery.whereKey("isHidden", equalTo: NSNumber(bool: false))
    listingQuery.includeKey("blackListedUsers")
    listingQuery.includeKey("reservations")
    return listingQuery
  }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath, withObject object: PFObject) -> Void {

    if(object.parseClassName == "UPMOtherListing"){
      var listing = object as! UPMOtherListing
      let viewController = UPMBuyItemDetailsOtherTVC()
      viewController.listingOther = listing
      navigationController?.pushViewController(viewController, animated: true)
    }
    
    
  }




    
}
