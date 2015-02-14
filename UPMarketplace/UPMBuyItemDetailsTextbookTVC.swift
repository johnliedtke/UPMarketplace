//
//  UPMBuyItemDetailsTextbookTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/24/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

class UPMBuyItemDetailsTextbookTVC: UPMBuyItemDetailsTVC {
  
    
    var numRows = 4
    var listingTextbook: UPMTextbookListing?
    
    override func changeDefaults() {
      numberOfAttributes = numRows
    }
    
    override func configureFieldCells(cell: UPMBuyItemFieldCell!, indexPath: NSIndexPath) {
      switch(indexPath.row){
      case 0:
        cell.configureCell("Edition:", second: listingTextbook?.textbook?.edition)
        break
      case 1:
        cell.configureCell("ISBN:", second: listingTextbook?.textbook?.iSBN)
        break
      case 2:
        cell.configureCell("Course:", second: listingTextbook?.textbook?.course)
        break
      case 3:
        cell.configureCell("Professor:", second: listingTextbook?.textbook?.professor)
        break
      case 4:
        cell.configureCell("Posted:", second:fixDateFormat((listingTextbook?.createdAt)!))
        break
      default:
        break
        
      }
    }
}
