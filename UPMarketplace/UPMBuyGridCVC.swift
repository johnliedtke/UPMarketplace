//
//  UPMBuyGridCVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/20/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

/**
The basic template for browsing UPMListing's in the marketplace. This controller displays 
listings in a grid format. Aproximately 4.2 listings will be visible on the screen.To work 
property one should override the following methods.
  - parseListingClassName()
  - query() if special query 

*/
class UPMBuyGridCVC: UPMPFObjectCVC {
  
  let ListingsPerPage = 24
  var listing: UPMListing = UPMListing()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Public Methods
  /// Override to provide the UPMListing subclass name for a PFQuery
  func parseListingClassName() -> String {
    return ""
  }
  
  override func changeDefaults() {
    objectsPerPage = UInt(ListingsPerPage)
  }
  
  override func query() -> PFQuery {
    var listingQuery = PFQuery(className: parseListingClassName())
    listingQuery.orderByAscending("createdAt")
    return listingQuery
  }

}
