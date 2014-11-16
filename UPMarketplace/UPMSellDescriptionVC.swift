//
//  UPMSellDescriptionVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/8/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

protocol UPMSellDescriptionDelegate {
  func descriptionUpdated(description: String)
}

class UPMSellDescriptionVC: UIViewController, UITextViewDelegate {
 
  
  @IBOutlet var descriptionTextView: UITextView!
  @IBOutlet var descriptionTextViewHeight: NSLayoutConstraint!
  var descriptionS = ""
  var delegate: UPMSellDescriptionDelegate?
  
  
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    descriptionTextView.text = descriptionS
    self.automaticallyAdjustsScrollViewInsets = false
    navigationItem.hidesBackButton = true
    addCancelButtontToNavigationItemWithSelector("didPushCancelButton:")
    addDoneButtonToNavigationItemWithSelector("didPushDoneButton:")
  



    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardAppeared:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    descriptionTextView.becomeFirstResponder()

    self.view.backgroundColor = UIColor.standardBackgroundColor()
  }
  
  func didPushCancelButton(sender: AnyObject) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  func didPushDoneButton(sender: AnyObject) {
    descriptionTextView.endEditing(true)
    delegate?.descriptionUpdated(descriptionS)
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  
  func keyboardAppeared(notification: NSNotification) -> Void {
    if let userInfo = notification.userInfo as? Dictionary<NSString, NSValue> {
      
      if let keyboardFrameBegin = userInfo[UIKeyboardFrameBeginUserInfoKey] {
        var keyboardFrameBeginRext: CGRect = keyboardFrameBegin.CGRectValue()
        descriptionTextViewHeight.constant = self.view.frame.height - (getNavigationBarHeight() + keyboardFrameBeginRext.height + 50)
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        descriptionTextView.setNeedsDisplay()
        descriptionTextView.setNeedsLayout()
        var what = descriptionTextView.textContainer.size
      }
    }
      
  }
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
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

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
