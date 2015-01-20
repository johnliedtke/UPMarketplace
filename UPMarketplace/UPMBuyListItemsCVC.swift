//
//  UPMBuyListItemsCVC.swift
//  UPMarketplace
//
//  Created by Krismy on 1/19/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

class UPMBuyListItemsCVC: UPMBuyGridCVC {
  
    //TODO: Change query to retrieve the three major UPMListing types.
    override func query() -> PFQuery {
        var listQuery = PFQuery(className: "UPMOtherListing")
        listQuery.orderByDescending("createdAt")
        return listQuery
    }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.registerClass(UPMBuyGridCell.self, forCellWithReuseIdentifier: reuseIdentifier)
  }
  





    
}