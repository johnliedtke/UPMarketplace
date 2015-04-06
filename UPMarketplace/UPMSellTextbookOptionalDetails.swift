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
class UPMSellTextbookOptionalDeatils: UPMSellSingleInput, UITextFieldDelegate {
  
  var currentTextbookDetails = [String: String?]()
  
  /// Pointer to edition textField
  private weak var editionField: UITextField!
  
  /// Pointer to professor textField
  private weak var professorField: UITextField!
  
  /// Pointer to authors textField
  private weak var authorsField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Extra Info"
    tableView.estimatedRowHeight = 50.0 // simulator auto-layout fix
    
    let editionInput = UPMSellInput(labelText: "Edition", valueText: currentTextbookDetails["edition"]!) {
      [weak self] (tf) in
      if let weakSelf = self {
        tf.placeholder = "e.g. 4"
        tf.text = weakSelf.currentTextbookDetails["edition"]!
        weakSelf.editionField = tf
        tf.delegate = weakSelf
      }
    }
    
    let professorInput = UPMSellInput(labelText: "Professor", valueText: currentTextbookDetails["professor"]!) {
      [weak self] (tf) in
      if let weakSelf = self {
        tf.delegate = weakSelf
        tf.placeholder = "Vegdahl"
        weakSelf.professorField = tf
        tf.text = weakSelf.currentTextbookDetails["professor"]!
      }
    }
    
    let authorsInput = UPMSellInput(labelText: "Authors", valueText: currentTextbookDetails["authors"]!) {
      [weak self] (tf) in
      if let weakSelf = self {
        tf.delegate = weakSelf
        tf.placeholder = "John Slade, Alex Wallace"
        weakSelf.authorsField = tf
        tf.text = weakSelf.currentTextbookDetails["authors"]!
      }
    }

    dataSource.rows = [editionInput, professorInput, authorsInput]
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if let tf = editionField {
      editionField.becomeFirstResponder()
    }
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
