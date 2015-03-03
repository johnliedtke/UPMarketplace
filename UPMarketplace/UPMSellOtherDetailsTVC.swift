//
//  UPMSellOtherDetailsTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/20/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit
let OtherListingCategoryStoryboard = "OtherListingCategory"

class UPMSellOtherDetailsTVC: UPMSellDetailsTVC, UPMOtherListingCategoryDelegate {
  let SellStoryboard = "UPMSell"
  
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

  enum RequiredItem: String {
    case Category = "Category"
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  override func createRequiredItems() {
    func initializeRequiredItems() {
      didUpdateCategory(otherListing.category)
    }
    var categoryItem = UPMSellItem(title: RequiredItem.Category.rawValue, description: "Select")
    requiredItems.addItem(categoryItem)
    initializeRequiredItems()
  }
  
  override func didSelectItem(item: UPMSellItem) {
    switch item.title {
    case RequiredItem.Category.rawValue:
      let Storyboard = UIStoryboard(name: "SellMain", bundle: nil)
      var categoryVC = Storyboard.instantiateViewControllerWithIdentifier(OtherListingCategoryStoryboard) as! UPMOtherListingCategoryTVC
      categoryVC.delegate = self
      navigationController?.pushViewController(categoryVC, animated: true)
    default:
      println("Default")
    }
  }
  
  func didUpdateCategory(category: String?) {
    if let updatedCategory = category {
      let CategoryItem = requiredItems.itemWithTitle(RequiredItem.Category.rawValue)
      CategoryItem?.itemDescription = updatedCategory
      CategoryItem?.isComplete = true
      otherListing.category = category
    }
  }

}
