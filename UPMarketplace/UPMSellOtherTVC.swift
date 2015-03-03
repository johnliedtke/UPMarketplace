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
    get {
      return otherListng
    }
    set {
      if newValue is UPMOtherListing {
        otherListng = newValue as! UPMOtherListing
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
    requiredItems.addItem(UPMSellItem(title: CategoryTag, description: "Select"))
  }
  
  override func didSelectItemAtIndexPath(indexPath: NSIndexPath) {
    super.didSelectItemAtIndexPath(indexPath)
    if requiredItems.itemAtIndex(indexPath.row).title == CategoryTag {
      var categoryTVC = UPMSellCategoryTVC()
      categoryTVC.listing = otherListng
      navigationController?.pushViewController(categoryTVC, animated: true)
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
    if isComplete {
      let detailsItem = requiredItems.itemWithTitle(RequiredItems.Details.rawValue)
      detailsItem?.isComplete = isComplete
      detailsItem?.itemDescription = details
    }
  }
  
}

class UPMSellCategoryTVC: UPMSellDetailsTVC, UPMOtherListingCategoryDelegate {
  
  let Category = "Category"
  let Tag = "Tag"
  
  // MARK: - Public Properties
  var otherListing: UPMOtherListing = UPMOtherListing()
  override var listing: UPMListing? {
    get {
      return otherListing
    }
    set {
      if newValue is UPMOtherListing {
        otherListing = newValue as! UPMOtherListing
      }
    }
  }
  
  override func createRequiredItems() {
    requiredItems.addItem(UPMSellItem(title: "Category", description: "Select"))
    requiredItems.addItem(UPMSellItem(title: "Tag", description: "Select"))
    
  }
  
  override func didSelectItem(item: UPMSellItem) {
    switch item.title {
    case Category:
//      let Storyboard = UIStoryboard(name: "SellMain", bundle: nil)
//      var categoryVC = Storyboard.instantiateViewControllerWithIdentifier(OtherListingCategoryStoryboard) as! UPMOtherListingCategoryTVC
//      categoryVC.delegate = self
      
      var controller = UPMTablePickerVC()
      
      navigationController?.pushViewController(controller, animated: true)
    case Tag:
      println("Tag coming to a place near you")
    default: break
    }
  }
  
  
  // MARK: - Delegate
  func didUpdateCategory(category: String?) {
    
  }

  
}


















