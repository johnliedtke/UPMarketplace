//
//  UPMSellTextbookDetailsTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/24/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

let SellTextbookDetailsISBNStoryboard = "SellTextbookDetailsISBN"
let SellTextbookDetailsCourseStoryboard = "SellTextbookDetailsCourse"

class UPMSellTextbookDetailsTVC: UPMSellDetailsTVC, UPMSellTextbookDetailsISBNDelegate, UPMSellTextbookDetailsCourseDelegate {
  // MARK: - Properties
  var textbookListing: UPMTextbookListing = UPMTextbookListing()
  override var listing: UPMListing? {
    get {
      return textbookListing
    }
    set {
      if newValue is UPMTextbookListing {
        textbookListing = newValue as! UPMTextbookListing
      }
    }
  }
  
  enum RequiredItem: String {
    case ISBN = "ISBN"
    case Course = "Course"
  }
  
  // MARK: - Methods
  
  override func createRequiredItems() {
    func initializeRequiredItems() {
      self.didCourseUpdate(self.textbookListing.textbook?.course)
      self.didCourseUpdate(self.textbookListing.textbook?.iSBN)
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
      var iSBNVC = TextBookStoryboard.instantiateViewControllerWithIdentifier(SellTextbookDetailsISBNStoryboard) as! UPMSellTextbookDetailsISBNTVC
      if let iSBN = textbookListing.textbook?.iSBN {
        iSBNVC.iSBN = iSBN
      }
      iSBNVC.delegate = self
      navigationController?.pushViewController(iSBNVC, animated: true)
    case RequiredItem.Course.rawValue:
      var courseTVC = TextBookStoryboard.instantiateViewControllerWithIdentifier(SellTextbookDetailsCourseStoryboard) as! UPMSellTextbookDetailsCourseTVC
      if let course = textbookListing.textbook?.course {
        courseTVC.course = course
      }
      courseTVC.delegate = self
      navigationController?.pushViewController(courseTVC, animated: true)
    default:
      println("Default Select")
    }
  }
  
  // MARK: - Delegate Methods
  
  func didISBNUpdate(unformattedISBN: String?) {
    if let iSBN = unformattedISBN {
      requiredItems.updateItemWithTitle(RequiredItem.ISBN.rawValue, description: iSBN, isComplete: true)
      textbookListing.textbook?.iSBN = unformattedISBN
    }
  }
  
  func didCourseUpdate(course: String?) {
    if let course = course {
      requiredItems.updateItemWithTitle(RequiredItem.Course.rawValue, description: course, isComplete: true)
      textbookListing.textbook?.course = course
    }
  }
  
}
