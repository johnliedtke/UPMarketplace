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
  weak var listingOther: UPMOtherListing?
  
  override func changeDefaults() {
    numberOfAttributes = numRows
    listing = listingOther
  }
  deinit {
    println("deallocating UPMBuyItemDetailsTVC")
    //listing = nil
  }
  
  
  override func configureFieldCells(cell: UPMBuyItemFieldCell!, indexPath: NSIndexPath) {
    switch(indexPath.row){
    case 0:
      cell.configureCell("Category:", second: listingOther?.category)
      break
    case 1:
      if let createdAt = listingOther?.createdAt {
        cell.configureCell("Posted:", second: super.fixDateFormat(createdAt))
      }
      break
    default:
      break
    }
    
  }

  
}