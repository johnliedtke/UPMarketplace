//
//  UPMBuyItemDetailsOtherTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/24/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit


class UPMBuyItemDetailsOtherTVC: UPMBuyItemDetailsTVC {
  
  var numRows = 2
  var listingOther: UPMOtherListing?
  
  override func changeDefaults() {
    numberOfAttributes = numRows
    listing = listingOther
  }
  
  override func configureFieldCells(cell: UPMBuyItemFieldCell!, indexPath: NSIndexPath) {
    switch(indexPath.row){
    case 0:
      cell.configureCell("Category:", second: listingOther?.category)
      break
    case 1:
      cell.configureCell("Posted:", second: super.fixDateFormat((listingOther?.createdAt)!))
      break
    default:
      break
    }
    
  }

  
}