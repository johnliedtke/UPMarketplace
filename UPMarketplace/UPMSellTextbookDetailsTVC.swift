//
//  UPMSellTextbookDetailsTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/24/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

class UPMSellTextbookDetailsTVC: UPMSellDetailsTVC {
  var textbookListing: UPMTextbookListing = UPMTextbookListing()
  override var listing: UPMListing {
    get {
      return textbookListing
    }
    set {
      if newValue is UPMTextbookListing {
        textbookListing = newValue as UPMTextbookListing
      }
    }
  }
  
  
  enum RequiredItem: String {
    case Category = "Category"
  }


  
 
  
  

  
}
