//
//  UPMSellTextbookTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/24/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

class UPMSellTextbookTVC: UPMSellTVC, UPMSellDetailsTVCDelegate {
  
  var textbookListing: UPMTextbookListing = UPMTextbookListing()
  override var listing: UPMListing {
    get {
      return textbookListing
    } set {
      if newValue is UPMTextbookListing {
        textbookListing = newValue as UPMTextbookListing
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  override func post() {
    
  }
  
  func didDetailsUpdate(details: String, isComplete: Bool) {
    requiredItems.updateItemWithTitle(RequiredItems.Details.rawValue, description: details, isComplete: isComplete)
  }
  
  override func pushDetailsVC() {
    var detailsVC = UPMSellTextbookDetailsTVC()
    detailsVC.listing = listing
    detailsVC.delegate = self
    navigationController?.pushViewController(detailsVC, animated: true)
  }
  
}
