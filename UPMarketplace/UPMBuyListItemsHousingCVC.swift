//
//  UPMBuyListItemsHousingCVC.swift
//  UPMarketplace
//
//  Created by Krismy on 2/4/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit



class UPMBuyListItemsHousingCVC: UPMBuyGridCVC {

  override func query() -> PFQuery {
    var listQuery = PFQuery(className: "UPMHousingListing")
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
    
    var listing = object as! UPMHousingListing
    let viewController = UPMBuyItemDetailsHousingTVC()
    viewController.listingHousing = listing
    navigationController?.pushViewController(viewController, animated: true)
    
  }
}
