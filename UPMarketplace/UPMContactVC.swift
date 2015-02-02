//
//  UPMContactVCTableViewController.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/24/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit



public class UPMContactVC: UIViewController, MBProgressHUDDelegate {
  
  
  /// Who to send the email to
  public var user: PFUser!
  
  /// Subject of the email
  public var subject: String?
  
  /// Body
  
  // MARK: - Public Properties
  
  public lazy var toField: UITextField = {
    var field = UITextField(forAutoLayout: true)
    field.text = "liedtke15"
    field.font = UIFont.systemFontOfSize(15.0)
    //field.textColor = UIColor.flatLightGrayColor()
    return field
  }()
  
  public lazy var subjectField: UITextField = {
    var field = UITextField(forAutoLayout: true)
    field.text = "Lawn Chair"
    field.font = UIFont.systemFontOfSize(15.0)
    //field.textColor = UIColor.flatLightGrayColor()
    return field
  }()
  
  public lazy var bodyTextView: UITextView = {
    var textView = UITextView()
    textView.text = "Email body"
    textView.scrollEnabled = false
    textView.textContainerInset = UIEdgeInsetsMake(-3,-5,0,0)
    textView.font = UIFont.systemFontOfSize(15.0)
    textView.backgroundColor = UIColor.clearColor()
    textView.setTranslatesAutoresizingMaskIntoConstraints(false)
    return textView
  }()
  
  
  // MARK: - Private Properties
  
  // MARK: - Public Methods
  
  // MARK: - Private Methods

  override public func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.standardBackgroundColor()
    view.addSubview(toField)
    view.addSubview(subjectField)
    view.addSubview(bodyTextView)
    
    let padding = 10.0

    var toLabel = UILabel()
    toLabel.addBottomBorderWithColor(UIColor.flatLightOrangeColor(), andThickness: 3.0)
    toLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
    toLabel.textColor = UIColor.flatDarkGrayColor()
    toLabel.text = "To"
    toLabel.font = UIFont.systemFontOfSize(15.0)
    toLabel.setContentHuggingPriority(800, forAxis: UILayoutConstraintAxis.Horizontal)
    toField.setContentHuggingPriority(100, forAxis: UILayoutConstraintAxis.Horizontal)
    view.addSubview(toLabel)
    
    var fromLabel = UILabel()
    fromLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
    fromLabel.textColor = UIColor.flatDarkGrayColor()
    fromLabel.text = "Subject"
    fromLabel.font = UIFont.systemFontOfSize(15.0)
    fromLabel.setContentHuggingPriority(800, forAxis: UILayoutConstraintAxis.Horizontal)
    subjectField.setContentHuggingPriority(100, forAxis: UILayoutConstraintAxis.Horizontal)
    view.addSubview(fromLabel)
    
    var messageLabel = UILabel(forAutoLayout: true)
    messageLabel.textColor = UIColor.flatDarkGrayColor()
    messageLabel.text = "Message"
    messageLabel.font = UIFont.systemFontOfSize(15.0)
    view.addSubview(messageLabel)
    
   
    var elements = NSDictionary(dictionary: ["toField": toField, "topLayoutGuide": topLayoutGuide, "view": view, "toLabel": toLabel, "fromLabel": fromLabel, "fromField": subjectField, "bodyTextView": bodyTextView, "messageLabel": messageLabel])

    
    // Horizontal layout
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[toLabel]-[toField]-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: elements))
    
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[fromLabel]-[fromField]-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: elements))

    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[bodyTextView]-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: elements))
    
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[messageLabel]-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: elements))
    
    // Vertical layout
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide]-[toField]-[fromField]", options: .DirectionLeadingToTrailing, metrics: nil, views: elements))
    
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide]-[toLabel]-[fromLabel]-[messageLabel]-[bodyTextView]", options: .DirectionLeadingToTrailing, metrics: nil, views: elements))
    
    // Center labels
    view.addConstraint(NSLayoutConstraint(item: toLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal, toItem: toField, attribute: .CenterY, multiplier: 1.0, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: fromLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal, toItem: subjectField, attribute: .CenterY, multiplier: 1.0, constant: 0))
    
    // TextView Height
    view.addConstraint(NSLayoutConstraint(item: bodyTextView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: 0.33, constant: 0))
    
    subjectField.setNeedsDisplay()
    
    bodyTextView.becomeFirstResponder()
    navigationItem.title = "Contact"
    
    addCancelButtontToNavigationItemWithSelector("didPushCancelButton:")
    
    var sendButton = UIBarButtonItem(title: "Send", style: .Done, target: self, action: "didPushSendButton:")
    navigationItem.setRightBarButtonItem(sendButton, animated: true)
  }
  
  func didPushCancelButton(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func didPushSendButton(sender: AnyObject) {
    sendEmail()
  }
  
  
  func validateEmail() {
  }
  
  func sendEmail() {
    
    // create dictionary to send
    var currentUser = PFUser.currentUser()
    let email: [String: String] = ["to": "jcliedtke@gmail.com", "from": currentUser.email, "subject": "Testing Contact Controller", "message": bodyTextView.text]
    
    var progressHUD = MBProgressHUD.showHUDAddedTo(view, animated: true)
    progressHUD.labelText = "Sending email..."

    
    PFCloudExt.callFunctionAsync(PFCloudExtConstants.sendEmailFunction, withParameters: email).continueWithBlock {
      (task: BFTask!) -> AnyObject! in
      
      if task.error == nil { // success
        progressHUD.labelText = "Success"
        progressHUD.hide(true)

        println("Sucess, email was sent!")
        return nil
      } else { // handle error or timeout
        progressHUD.labelText = "Error"
        progressHUD.hide(true)
        var errorString = task.error.userInfo?[NSString(string: "error")] as NSString
        var alertError = UIAlertController(title: "Error", message: String(errorString), preferredStyle:.Alert)
        alertError.addAction(UIAlertAction(title: "Okay", style: .Default, handler:nil))
        self.presentViewController(alertError, animated: true, completion: nil)
        return nil;
      }
    }
  }
  
  public func hudWasHidden(hud: MBProgressHUD!) {
    
  }
  
  func handleTimeout(timer: NSTimer) {
    var timeoutAlert = UIAlertController(title: "Network Problem", message: "Could not establish a connection, please try again.", preferredStyle: .Alert)
    var okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
    timeoutAlert.addAction(okayAction)
  }

}
