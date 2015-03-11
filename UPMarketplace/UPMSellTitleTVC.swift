//
//  UPMSellTitleTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/16/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

protocol UPMSellTitleDelegate: class {
  func didUpdateTitle(title: String)
}

class UPMSellTitleTVC: UITableViewController, UITextViewDelegate {
  weak var delegate: UPMSellTitleDelegate?
  var titleS = ""
  @IBOutlet var titleTextView: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    titleTextView.textContainerInset = UIEdgeInsetsZero
    
    addDoneButtonToNavigationItemWithSelector("didPressDoneButton:")
    addCancelButtontToNavigationItemWithSelector("didPressCancelButton:")
    titleTextView.becomeFirstResponder()
    titleTextView.text = titleS
      


  }
  
  func textViewDidEndEditing(textView: UITextView) {
    if textView == titleTextView {
      titleS = textView.text
    }
  }
  

  func didPressDoneButton(sender: AnyObject) {
    view.endEditing(true)
    delegate?.didUpdateTitle(titleS)
    navigationController?.popViewControllerAnimated(true)
  }
  
  func didPressCancelButton(sender: AnyObject) {
    navigationController?.popViewControllerAnimated(true)
    
  }


}
