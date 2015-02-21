//
//  UPMBuyListItemsTextbookCVC.swift
//  UPMarketplace
//
//  Created by Krismy on 2/4/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit



class UPMBuyListItemsTextbookCVC: UPMBuyGridCVC {

  override func query() -> PFQuery {
    var listQuery = PFQuery(className: "UPMTextbookListing")
    listQuery.orderByDescending("createdAt")
    return UPMTextbookListing.displayQuery()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView = collectionView;
    self.collectionView!.dataSource = self;
    self.collectionView!.delegate = self;
  }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath, withObject object: PFObject) -> Void {
    
    var listing = object as! UPMTextbookListing
    let viewController = UPMBuyItemDetailsTextbookTVC()
    viewController.listingTextbook = listing
    navigationController?.pushViewController(viewController, animated: true)
    
  }

}
