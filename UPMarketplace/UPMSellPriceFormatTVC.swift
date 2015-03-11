//
//  UPMSellPriceFormatTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/15/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit


protocol UPMSellPriceFormatDelegate: class {
  func updatedPriceFormat(price: Double, limit: Double?, oBo: Bool)
}

let MAX_LENGTH = 8

/// Used to collect user-input for the price of a UPMListing.
class UPMSellPriceFormatTVC: UITableViewController, UITextFieldDelegate {
  
  weak var delegate: UPMSellPriceFormatDelegate?
  var price: Double = 0.00
  var oBO: Bool = false
  var limit: Double = 0.00
  var alertController = UIAlertController(title: "Error", message: "Problem", preferredStyle: UIAlertControllerStyle.Alert)
  
  @IBOutlet var priceField: UITextField!
  @IBOutlet var oBOSwitch: UISwitch!
  @IBOutlet var limitField: UITextField!
  
  var maximumFractionDigits: Int = 0
  var decimalSeparator: NSString = NSString()
  

  override func viewDidLoad() {
      super.viewDidLoad()
    
    // Done/Cancel buttons
    addDoneButtonToNavigationItemWithSelector("didPressDoneButton:")
    addCancelButtontToNavigationItemWithSelector("didPressCancelButton:")
    oBOSwitch.addTarget(self, action: "didChangeOBOSwitchState:", forControlEvents: UIControlEvents.ValueChanged)
    // Alert
    var okayAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil)
    alertController.addAction(okayAction)

    
    // Initialize fields
    if price > 0 {
      priceField.text = price.toString()
    }
    if oBO {
      oBOSwitch.on = oBO
      limitField.text = limit.toString()
    }
    
    priceField.becomeFirstResponder()
    var numberFormatter = NSNumberFormatter()
    numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
    numberFormatter.currencyCode = "USD"
    maximumFractionDigits = numberFormatter.maximumFractionDigits
    decimalSeparator = numberFormatter.decimalSeparator!
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

    var selectedRange: UITextRange = textField.selectedTextRange!
    var start: UITextPosition = textField.beginningOfDocument
    var cursorOffset = textField.offsetFromPosition(start, toPosition: selectedRange.start)
    // Update the string in the text input
    var currentString: NSMutableString = NSMutableString(string: textField.text)
    var currentLength: UInt = UInt(currentString.length)
    currentString.replaceCharactersInRange(range, withString: string)
    // Strip out the decimal seperator
    let r = NSRange(location: 0, length: currentString.length)
    currentString.replaceOccurrencesOfString(decimalSeparator as! String, withString: "", options: NSStringCompareOptions.LiteralSearch, range: r)
    // Generate a new string for the text input
    var currentValue: Int = currentString.integerValue
    var format: NSString = NSString(format: "%%.%df", maximumFractionDigits)
    var minotUnitsPerMajor: Double = pow(10.00, Double(maximumFractionDigits))
    var m = Double(currentValue) / minotUnitsPerMajor
    var newString: NSString = NSString(format: format, m).stringByReplacingOccurrencesOfString(".", withString: decimalSeparator as! String)
    if newString.length <= MAX_LENGTH {
      textField.text = newString as! String
      // if the cursor was not at the end of the string being entered, restore cursor position
      if UInt(cursorOffset) != currentLength {
        var lengthDelta: Int = newString.length - Int(currentLength)
        var newCursorOffset: Int = max(0, min(newString.length, cursorOffset + lengthDelta))
        var newPosition: UITextPosition = textField.positionFromPosition(textField.beginningOfDocument, offset: newCursorOffset)!
        var newRange = textField.textRangeFromPosition(newPosition, toPosition: newPosition)
        textField.selectedTextRange = newRange
      }
    }
    return false
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    var string = NSString(string: textField.text)
    if textField == priceField {
      price = string.doubleValue
    } else if textField == limitField {
      limit = string.doubleValue
    }
   }
  
  func alertIfInputIsIncomplete() -> Bool {
    var errorString = ""
    var error = false
    
    if price <= 0.00 {
      errorString += "Price must be greater than $0.00\n"
      error = true
    }
    
    if oBO && (limit <= 0.00) {
      errorString += "Limit must be greater than $0.00"
      error = true
    }
    
    alertController.message = errorString
    if error {
      presentViewController(alertController, animated: true, completion: nil)
    }
    return error
  }
  
  func didPressDoneButton(sender: AnyObject) {
    view.endEditing(true)
    if alertIfInputIsIncomplete() {
      return
    }
    delegate?.updatedPriceFormat(price, limit: limit, oBo: oBOSwitch.on)
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func didPressCancelButton(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func didChangeOBOSwitchState(sender: AnyObject) {
    oBO = oBOSwitch.on
    tableView.reloadData()
    if oBOSwitch.on {
      limitField.becomeFirstResponder()
    } else {
      priceField.becomeFirstResponder()
    }
  }
    // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return oBOSwitch.on ? 3 : 2
  }


}
