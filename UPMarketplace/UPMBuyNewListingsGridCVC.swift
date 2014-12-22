//
//  UPMBuyNewListingsGridCVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/21/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

class UPMBuyNewListingsGridCVC: UPMBuyGridCVC {
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func changeDefaults() {
  }
  
  override func query() -> PFQuery {
    var listingQuery = PFQuery(className: "UPMOtherListing")
    listingQuery.orderByDescending("createdAt")
    return listingQuery
  }



    
}
