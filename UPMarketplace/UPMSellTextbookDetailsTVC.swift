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
  var textbookListing: UPMTextbookListing!
  override var listing: UPMListing? {
    get { return textbookListing }
    set { if newValue is UPMTextbookListing { textbookListing = newValue as! UPMTextbookListing } }
  }
  
  enum RequiredItem: String {
    case ISBN = "ISBN"
    case Course = "Course"
    case Required = "ISBN & Course"
    case Optional = "Extra Info"
  }
  
  // MARK: - Methods
  
  override func createRequiredItems() {
    func initializeRequiredItems() {
      self.didCourseUpdate(self.textbookListing.textbook?.course)
      self.didISBNUpdate(self.textbookListing.textbook?.iSBN13)
    }
    var iSBNItem = UPMSellItem(title: RequiredItem.ISBN.rawValue, description: "Select")
   // var courseItem = UPMSellItem(title: RequiredItem.Course.rawValue, description: "Select")
    var requiredTextbook = UPMSellItem(title: RequiredItem.Required.rawValue, description: "Select")
    requiredItems.addItems([requiredTextbook])
    optionalItems.addItems([UPMSellItem(title: "Extra Info", description: "Select")])
    //initializeRequiredItems()
    setupItemDescriptions()
  }
  
  override func didSelectItem(item: UPMSellItem) {
    let TextBookStoryboard = UIStoryboard(name: "UPMSellTextbook", bundle: nil)
    switch item.title {
    case RequiredItem.ISBN.rawValue:
      var iSBNVC = TextBookStoryboard.instantiateViewControllerWithIdentifier(SellTextbookDetailsISBNStoryboard) as! UPMSellTextbookDetailsISBNTVC
      if let iSBN = textbookListing.textbook?.iSBN13 {
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
    case RequiredItem.Required.rawValue:
      let textbookRequiredVC = UPMSellTextbookRequiredDeatils()
      textbookRequiredVC.currentTextbookDetails = ["isbn": textbookListing.textbook.iSBN13, "course": textbookListing.textbook.course]
      textbookRequiredVC.dataCollectedHandler = {
        [unowned self] (textbookDict) in
        self.textbookListing.textbook.iSBN13 = textbookDict["isbn"]
        self.textbookListing.textbook.course = textbookDict["course"]
        self.setupItemDescriptions()
      }
      navigationController?.pushViewController(textbookRequiredVC, animated: true)
    case RequiredItem.Optional.rawValue:
      let textbookOptional = UPMSellTextbookOptionalDeatils()
      textbookOptional.dataCollectedHandler = {
        [unowned self] (textbookDict) in
        self.textbookListing.textbook.authors = textbookDict["authors"]
        self.textbookListing.textbook.edition = textbookDict["edition"]
        self.textbookListing.textbook.professor = textbookDict["professor"]
      }
      textbookOptional.currentTextbookDetails = ["authors": textbookListing.textbook.authors, "professor": textbookListing.textbook.professor, "edition": textbookListing.textbook.course]
      navigationController?.pushViewController(textbookOptional, animated: true)
    default: break
    }
  }
  
  func setupItemDescriptions() {
    let isbn = textbookListing.textbook.iSBN13 ?? "Select"
    let course = textbookListing.textbook.course ?? "Select"
    let authors = textbookListing.textbook.authors ?? "Select"
    let professor = textbookListing.textbook.professor ?? "Select"
    let edition = textbookListing.textbook.edition ?? "Select"
    requiredItems.updateItemWithTitle(RequiredItem.Required.rawValue, description: "ISBN: \(isbn)\nCourse: \(course)" , isComplete: textbookListing.textbook.iSBN13 != nil && textbookListing.textbook.course != nil)
    optionalItems.updateItemWithTitle(RequiredItem.Optional.rawValue, description: "Authors: \(authors)\nProfessor: \(professor)\nEdition: \(edition)", isComplete: textbookListing.textbook.edition != nil && textbookListing.textbook.professor != nil && textbookListing.textbook.authors != nil)
  }
  
  // MARK: - Delegate Methods
  
  func didISBNUpdate(unformattedISBN: String?) {
    if let iSBN = unformattedISBN {
      requiredItems.updateItemWithTitle(RequiredItem.ISBN.rawValue, description: iSBN, isComplete: true)
      textbookListing.textbook?.iSBN13 = unformattedISBN
    }
  }
  
  func didCourseUpdate(course: String?) {
    if let course = course {
      requiredItems.updateItemWithTitle(RequiredItem.Course.rawValue, description: course, isComplete: true)
      textbookListing.textbook?.course = course
    }
  }
  
}
