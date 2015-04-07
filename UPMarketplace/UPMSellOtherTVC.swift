//
//  UPMSellOtherTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/20/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

class UPMSellOtherTVC: UPMSellTVC, UPMSellDetailsTVCDelegate {
  
  let CategoryTag = "Category"
  
  // MARK: - Listing override
  
  var otherListng: UPMOtherListing = UPMOtherListing()
  override var listing: UPMListing? {
    get { return otherListng }
    set {
      if newValue is UPMOtherListing {
        otherListng = newValue as UPMOtherListing
      }
    }
  }

  // MARK: - View
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundColor = UIColor.standardBackgroundColor()
    tableView.estimatedRowHeight = 100 // autLayout Fix
  }
  
  // MARK: - Items
  
  override func createRequiredItems() {
    super.createRequiredItems()
    requiredItems.removeItemWithTitle(RequiredItems.Details.rawValue)
    requiredItems.addItem(UPMSellItem(title: CategoryTag, description: "Select"))
  }
  
  override func didSelectItemAtIndexPath(indexPath: NSIndexPath) {
    super.didSelectItemAtIndexPath(indexPath)
    if requiredItems.itemAtIndex(indexPath.row).title == CategoryTag {
      var categoryTVC = UPMSellCategoryTVC()
      categoryTVC.listing = otherListng
      categoryTVC.delegate = self
      navigationController?.pushViewController(categoryTVC, animated: true)
    }
  }
  
  override func initItemFields() {
    super.initItemFields()
    if isUpdatingListing {
      if let category = otherListng.category {
        requiredItems.updateItemWithTitle(CategoryTag, description: "Category: \(category)", isComplete: true)
        if let tag = otherListng.tag {
          requiredItems.updateItemWithTitle(CategoryTag, description: "Category: \(category)\nTag: \(tag)", isComplete: true)
        }

      }
    }
  }
  
  // MARK: - Details

  override func pushDetailsVC() {
    var detailsVC = UPMSellOtherDetailsTVC()
    detailsVC.listing = listing // pass reference
    detailsVC.delegate = self
    navigationController?.pushViewController(detailsVC, animated: true)
  }
  
  func didDetailsUpdate(details: String, isComplete: Bool) {
      requiredItems.updateItemWithTitle(CategoryTag, description: details, isComplete: isComplete)
  }
}





