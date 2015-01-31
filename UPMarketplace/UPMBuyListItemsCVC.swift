//
//  UPMBuyListItemsCVC.swift
//  UPMarketplace
//
//  Created by Krismy on 1/19/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit
/**
Displays all UPMOtherListings in a grid format.
*/
class UPMBuyListItemsCVC: UPMBuyGridCVC {
  
  
  var chosenCategory: String!

  
  //TODO: Change query to retrieve the three major UPMListing types.
  override func query() -> PFQuery {
    var listQuery = PFQuery(className: chosenCategory)
    listQuery.orderByDescending("createdAt")
    return listQuery
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  override func parseListingClassName() -> String {
    return chosenCategory
  }


  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath, withObject object: PFObject) -> Void {
    var listing = object as UPMOtherListing

    let BuyItem = UIStoryboard(name: "UPMBuyWorkflow", bundle: nil)
    var buyDetailVC: UPMBuyItemDetailsTVC = BuyItem.instantiateViewControllerWithIdentifier("UPMBuyItemDetails") as UPMBuyItemDetailsTVC
    

    buyDetailVC.listing = listing
    navigationController?.pushViewController(buyDetailVC, animated: true)


  }


    
}