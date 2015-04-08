//
//  UPMBuyItemDetailsTextbookTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/24/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

class UPMBuyItemDetailsTextbookTVC: UPMBuyItemDetailsTVC {
  
  
    
  var numRows: Int {
    get { return (listingTextbook?.textbook.textbookDetails())!.count + 1 }
  }
  
  var listingTextbook: UPMTextbookListing?
    
  override func changeDefaults() {
    numberOfAttributes = numRows
    listing = listingTextbook
  }
  
  override func configureFieldCells(cell: UPMBuyItemFieldCell!, indexPath: NSIndexPath) {
    if indexPath.row != tableView.numberOfRowsInSection(indexPath.section) - 1 {
      if let fields = listingTextbook?.textbook.textbookDetails() {
        cell.configureCell(fields[indexPath.row].0, second: fields[indexPath.row].1)
      }
    } else {
      cell.configureCell("Posted:", second:fixDateFormat((listingTextbook?.createdAt)!))
    }
  }


  
}
