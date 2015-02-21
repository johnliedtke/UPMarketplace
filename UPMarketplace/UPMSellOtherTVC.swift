//
//  UPMSellOtherTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/20/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

class UPMSellOtherTVC: UPMSellTVC, UPMSellDetailsTVCDelegate {
  
  
  var otherListng: UPMOtherListing = UPMOtherListing()
  override var listing: UPMListing? {
    get {
      return otherListng
    }
    set {
      if newValue is UPMOtherListing {
        otherListng = newValue as! UPMOtherListing
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundColor = UIColor.standardBackgroundColor()
    tableView.estimatedRowHeight = 100 // autLayout Fix
  }

  override func pushDetailsVC() {
    var detailsVC = UPMSellOtherDetailsTVC()
    detailsVC.listing = listing // pass reference
    detailsVC.delegate = self
    navigationController?.pushViewController(detailsVC, animated: true)
  }
  
  func didDetailsUpdate(details: String, isComplete: Bool) {
    if isComplete {
      let detailsItem = requiredItems.itemWithTitle(RequiredItems.Details.rawValue)
      detailsItem?.isComplete = isComplete
      detailsItem?.itemDescription = details
    }
  }
  
}
