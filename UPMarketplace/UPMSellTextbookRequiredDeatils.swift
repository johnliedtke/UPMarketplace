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
  
  /// Must be set
  var currentTextbookDetails = [String: String?]()
  
  /// Pointer to the isbnField
  private weak var isbnField: UITextField!
  
  /// Pointer to course textfield
  private weak var courseField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.estimatedRowHeight = 50.0 // simulator auto-layout fix
    navigationItem.title = "ISBN & Course"
    
    let isbn = currentTextbookDetails["isbn"]!
    let course = currentTextbookDetails["course"]!
    
    let isbnInput = UPMSellInput(labelText: "ISBN", valueText: isbn) {
      [weak self] (tf) in
      if let weakSelf = self {
        tf.placeholder = "e.g. 9780262033848"
        tf.text = weakSelf.currentTextbookDetails["isbn"] ?? ""
        tf.autocapitalizationType = .AllCharacters
        tf.delegate = self
        tf.keyboardType = .NumberPad
        weakSelf.isbnField = tf
      }
    }
    
    let courseInput = UPMSellInput(labelText: "Course", valueText: course) {
      [weak self] (tf) in
      if let weakSelf = self {
        tf.placeholder = "e.g. ENG112"
        tf.text = weakSelf.currentTextbookDetails["course"] ?? ""
        tf.delegate = weakSelf
        weakSelf.courseField = tf
        tf.autocapitalizationType = .AllCharacters
      }
    }

    dataSource.rows = [isbnInput, courseInput]
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if isbnField != nil {
      isbnField.becomeFirstResponder()
    }
  }
  
  
  override func didPressDoneFromNavigation() {
    //TODO: Validate...
    view.endEditing(true)
    var dict = [String: String]()
    for r in dataSource.rows {
      dict[r.labelText.lowercaseString] = r.valueText
    }
    if let handler = dataCollectedHandler {
      handler(dict)
    }
    navigationController?.popViewControllerAnimated(true)
  }
  
  // MARK: - UITextField Delegate
  
  func textField(textField: UITextField,
    shouldChangeCharactersInRange range: NSRange,
    replacementString string: String) -> Bool {

      let newLength = countElements(textField.text) + countElements(string) - range.length
      
      if range.length + range.location > countElements(textField.text) {
        return false
      }

      if textField == courseField {
        return !(newLength > 7);
      } else if textField == isbnField {
        return !(newLength > 14);
      }
    
    return false
  }

  
}