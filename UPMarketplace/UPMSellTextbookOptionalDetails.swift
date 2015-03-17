//
//  UPMSellTextbookOptionalDetails.swift
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
class UPMSellTextbookOptionalDeatils: UPMSellSingleInput {
  
  var currentTextbookDetails = [String: String?]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Extra Info"

    var editionInput = UPMSellInput(labelText: "Edition", placeholderText: "e.g. 4", valueText: currentTextbookDetails["authors"]!)
    var professorInput = UPMSellInput(labelText: "Professor", placeholderText: "e.g. Dr. Johnson", valueText: currentTextbookDetails["professor"]!)
    var authorsInput = UPMSellInput(labelText: "Authors", placeholderText: "John Slade, Alex Wallace", valueText: currentTextbookDetails["authors"]!)
    dataSource.rows = [editionInput, professorInput, authorsInput]
  }
  
  
  override func didPressDoneFromNavigation() {
    //TODO: Validate...
    var dict = [String: String]()
    for r in dataSource.rows {
      dict[r.labelText.lowercaseString] = r.valueText
    }
    dataCollectedHandler!(dict)
    navigationController?.popViewControllerAnimated(true)
  }
  
}

//class UPMSellTextbookOptionalDeatils: UPMSellSingleInput {
//  
//  var currentTextbookDetails = [String: String?]()
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    navigationItem.title = "ISBN & Course"
//    dataSource.rows = [UPMSellInput(labelText: "ISBN", placeholderText: "MEOW", valueText: currentTextbookDetails["isbn"]!), UPMSellInput(labelText: "Course", placeholderText: "e.g. CS301", valueText: currentTextbookDetails["course"]!)]
//  }
//  
//  
//  override func didPressDoneFromNavigation() {
//    //TODO: Validate...
//    view.endEditing(true)
//    var dict = [String: String]()
//    for r in dataSource.rows {
//      dict[r.labelText.lowercaseString] = r.valueText
//    }
//    dataCollectedHandler!(dict)
//    navigationController?.popViewControllerAnimated(true)
//  }
//  
//}