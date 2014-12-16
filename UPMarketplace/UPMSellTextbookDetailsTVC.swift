//
//  UPMSellTextbookDetailsTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/24/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

let SellTextbookDetailsISBNStoryboard = "SellTextbookDetailsISBN"

class UPMSellTextbookDetailsTVC: UPMSellDetailsTVC, UPMSellTextbookDetailsISBNDelegate {
  // MARK: Properties
  var textbookListing: UPMTextbookListing = UPMTextbookListing()
  override var listing: UPMListing {
    get {
      return textbookListing
    }
    set {
      if newValue is UPMTextbookListing {
        textbookListing = newValue as UPMTextbookListing
      }
    }
  }
  
  enum RequiredItem: String {
    case ISBN = "ISBN"
    case Course = "Course"
  }
  
  // MARK: Methods
  
  override func createRequiredItems() {
    func initializeRequiredItems() {
      
    }
    var iSBNItem = UPMSellItem(title: RequiredItem.ISBN.rawValue, description: "Select")
    var courseItem = UPMSellItem(title: RequiredItem.Course.rawValue, description: "Select")
    requiredItems.addItems([iSBNItem,courseItem])
    initializeRequiredItems()
  }
  
  override func didSelectItem(item: UPMSellItem) {
    let TextBookStoryboard = UIStoryboard(name: "UPMSellTextbook", bundle: nil)
    switch item.title {
    case RequiredItem.ISBN.rawValue:
      var iSBNVC = TextBookStoryboard.instantiateViewControllerWithIdentifier(SellTextbookDetailsISBNStoryboard) as UPMSellTextbookDetailsISBNTVC
      if let iSBN = textbookListing.textbook?.iSBN {
        iSBNVC.iSBN = iSBN
      }
      iSBNVC.delegate = self
      navigationController?.pushViewController(iSBNVC, animated: true) 
    default:
      println("Default Select")
    }
  }

  
  // MARK: Delegate Methods
  
  func didISBNUpdate(unformattedISBN: String) {
    requiredItems.updateItemWithTitle(RequiredItem.ISBN.rawValue, description: unformattedISBN, isComplete: true)
    textbookListing.textbook?.iSBN = unformattedISBN
  }


  

  
}
