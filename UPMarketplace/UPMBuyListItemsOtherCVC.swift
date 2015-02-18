//
//  UPMBuyListItemsOtherCVC.swift
//  UPMarketplace
//
//  Created by Krismy on 1/19/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit
/**
Displays all UPMOtherListings in a grid format.
*/
class UPMBuyListItemsOtherCVC: UPMBuyGridCVC {
  
    
  override func query() -> PFQuery {
    var listQuery = PFQuery(className: "UPMOtherListing")
    listQuery.orderByDescending("createdAt")
    return listQuery
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView = collectionView;
    self.collectionView!.dataSource = self;
    self.collectionView!.delegate = self;
  }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath, withObject object: PFObject) -> Void {
    
      var listing = object as! UPMOtherListing
      let viewController = UPMBuyItemDetailsOtherTVC()
      viewController.listingOther = listing
      navigationController?.pushViewController(viewController, animated: true)
  
  }
}