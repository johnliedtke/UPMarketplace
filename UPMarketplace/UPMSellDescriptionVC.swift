//
//  UPMSellDescriptionVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/8/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

protocol UPMSellDescriptionDelegate: class {
  func descriptionUpdated(description: String)
}

class UPMSellDescriptionVC: UIViewController, UITextViewDelegate {
 let MIN_DESCRIPTOIN_LENGTH = 5
  
  @IBOutlet var descriptionTextView: UITextView!
  @IBOutlet var descriptionTextViewHeight: NSLayoutConstraint!
  var descriptionS = ""
  
  /// Delegate to receieve updated description
  weak var delegate: UPMSellDescriptionDelegate?
  
  /// Alert user if errors
  lazy var errorAlertController: UIAlertController = {
    return UIAlertController(title: "Error", message: "", preferredStyle: .Alert)
  }()


  override func viewDidLoad() {
    super.viewDidLoad()
    descriptionTextView.text = descriptionS
    descriptionTextView.scrollEnabled = true
    self.automaticallyAdjustsScrollViewInsets = false
    navigationItem.hidesBackButton = true
    self.view.backgroundColor = UIColor.standardBackgroundColor()
    
    // Done/Cancel buttons
    addCancelButtontToNavigationItemWithSelector("didPushCancelButton:")
    addDoneButtonToNavigationItemWithSelector("didPushDoneButton:")

    descriptionTextView.becomeFirstResponder()
    
    let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: {
      action in
        self.descriptionTextView.becomeFirstResponder()
        return
      }
    )
    errorAlertController.addAction(okayAction)
  }
  
  func alertIfInputIsIncomplete() -> Bool {
    var error = false
    var errorMessage = ""
    if count(descriptionS) < MIN_DESCRIPTOIN_LENGTH {
      errorMessage += "Description must be longer than \(MIN_DESCRIPTOIN_LENGTH) characters."
      error = true
    }
    
    if error {
      errorAlertController.message = errorMessage
      presentViewController(errorAlertController, animated: true, completion: nil)
    }
    return error
  }
  
  func didPushCancelButton(sender: AnyObject) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  func didPushDoneButton(sender: AnyObject) {
    view.endEditing(true)
    if alertIfInputIsIncomplete() {
      return
    }
    if let d = delegate {
      d.descriptionUpdated(descriptionS)
      self.navigationController?.popViewControllerAnimated(true)
    }
  }
  
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(true)
    descriptionTextView.endEditing(true)
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    if textView == descriptionTextView {
      descriptionS = textView.text
    }
  }


}
