//
//  UPMBuyItemDetailsHousingTVC.swift
//  UPMarketplace
//
//  Created by Krismy on 2/4/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

class UPMBuyItemDetailsHousingTVC: UPMBuyItemDetailsTVC {
    
    var numRows = 2
    var listingHousing: UPMHousingListing?
    
    override func changeDefaults() {
      numberOfAttributes = numRows
    }
  
  //TODO: Update cells with appropriate housing stuff
    override func configureFieldCells(cell: UPMBuyItemFieldCell!, indexPath: NSIndexPath) {
      switch(indexPath.row){
      case 0:
        cell.configureCell("Type: ", second: "its a house!")
        break
      case 1:
        cell.configureCell("Posted:", second:fixDateFormat((listingHousing?.createdAt)!))
        break
      default:
        break
        
      }
    }


}


