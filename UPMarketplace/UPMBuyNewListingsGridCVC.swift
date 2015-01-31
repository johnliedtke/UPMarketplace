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
    
    //TODO: DELETE
    var loginStoryboard = UIStoryboard(name: "UPMLogin", bundle: nil)
    var loginVC = loginStoryboard.instantiateInitialViewController() as UINavigationController
    presentViewController(loginVC, animated: true, completion: nil)
    
  }
  
  override func changeDefaults() {
  }
  
  //TODO: Change query to retrieve the three major UPMListing types.
  override func query() -> PFQuery {
    var listingQuery = PFQuery(className: "UPMOtherListing")
    listingQuery.orderByDescending("createdAt")
    return listingQuery
  }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath, withObject object: PFObject) -> Void {
    var listing = object as UPMOtherListing
    
    let BuyItem = UIStoryboard(name: "UPMBuyWorkflow", bundle: nil)
    var buyDetailVC: UPMBuyItemDetailsTVC = BuyItem.instantiateViewControllerWithIdentifier("UPMBuyItemDetails") as UPMBuyItemDetailsTVC
    
    
    buyDetailVC.listing = listing
    navigationController?.pushViewController(buyDetailVC, animated: true)
    
    
  }




    
}
