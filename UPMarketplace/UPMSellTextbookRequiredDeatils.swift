//
//  UPMSellTextbookRequiredDeatils.swift
//  UPMarketplace
//
//  Created by John Liedtke on 3/15/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import Foundation

/**
  UPMSellTextbookRequiredDeatils gathers user-input for the required fields
  of a UPMTextbookListing. Sends user-input back to the presenting controller
  through :dataCollectedHandler: in the form of a dictionary with the keys:

  - isbn
  - course
*/
class UPMSellTextbookRequiredDeatils: UPMSellSingleInput {
  
  var currentTextbookDetails = [String: String?]()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "ISBN & Course"
    dataSource.rows = [UPMSellInput(labelText: "ISBN", placeholderText: "MEOW", valueText: currentTextbookDetails["isbn"]!), UPMSellInput(labelText: "Course", placeholderText: "e.g. CS301", valueText: currentTextbookDetails["course"]!)]
  }
  
  
  override func didPressDoneFromNavigation() {
    //TODO: Validate...
    view.endEditing(true)
    var dict = [String: String]()
    for r in dataSource.rows {
      dict[r.labelText.lowercaseString] = r.valueText
    }
    dataCollectedHandler!(dict)
    navigationController?.popViewControllerAnimated(true)
  }
  
}