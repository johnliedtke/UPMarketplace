//
//  UPMContactVCTableViewController.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/24/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit


/**
Used for sending emails to other users.
  - Should be presented modally and with a UINavigationcontroller.
  - Dismisses when the email is sucessfully sent.
*/
public class UPMContactVC: UIViewController, MBProgressHUDDelegate {
  
  
  /// Body
  
  // MARK: - Public Properties
  
  /// Who to send the email to
  public var user: PFUser!
  
  /// Subject of the email
  public var subject: String?

  // MARK: - UI Elements
  public lazy var toField: UITextField = {
    var field = UITextField(forAutoLayout: true)
    field.font = UIFont.standardTextFont()
    field.userInteractionEnabled = false
    return field
  }()
  
  public lazy var subjectField: UITextField = {
    var field = UITextField(forAutoLayout: true)
    field.font = UIFont.standardTextFont()
    return field
  }()
  
  public lazy var bodyTextView: UITextView = {
    var textView = UITextView()
    textView.setTranslatesAutoresizingMaskIntoConstraints(false)
    textView.text = ""
    textView.scrollEnabled = false
    textView.textContainerInset = UIEdgeInsetsMake(-3,-5,0,0)
    textView.font = UIFont.standardTextFont()
    textView.backgroundColor = UIColor.clearColor()
    return textView
  }()
  
  
  // MARK: - Private Properties
  
  // MARK: - Public Methods
  
  /**
  Creates a UPMContactVC with a navigation controller.
  
  :param: subject Subject of email
  :param: user Recipient of email
  :returns: navigation controller with a UPMContactVC as root controller
  */
  class func initWithNavigationController(user: PFUser, withSubject subject: String) -> UINavigationController {
    var contactVC = UPMContactVC(user: user, withSubject: subject)
    var navigationController = UINavigationController(rootViewController: contactVC)
    return navigationController
  }
  
  /**

  :param: subject Subject of email
  :param: user Recipient of email
  */
  convenience init(user: PFUser, withSubject subject: String) {
    self.init()
    self.user = user
    self.subject = subject
  }
  
  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    view.endEditing(true)
  }
  
  // MARK: - Private Methods

  override public func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.standardBackgroundColor()
    view.addSubview(toField)
    view.addSubview(subjectField)
    view.addSubview(bodyTextView)
    
    // Initialize fields
    toField.text = user.username
    subjectField.text = subject

    var toLabel = UILabel.standardCaptionLabel(true)
    toLabel.text = "To"
    toLabel.setContentHuggingPriority(800, forAxis: UILayoutConstraintAxis.Horizontal)
    toField.setContentHuggingPriority(100, forAxis: UILayoutConstraintAxis.Horizontal)
    view.addSubview(toLabel)
    
    var subjectLabel = UILabel.standardCaptionLabel(true)
    subjectLabel.text = "Subject"
    subjectLabel.setContentHuggingPriority(800, forAxis: UILayoutConstraintAxis.Horizontal)
    subjectField.setContentHuggingPriority(100, forAxis: UILayoutConstraintAxis.Horizontal)
    subjectLabel.setContentCompressionResistancePriority(1000, forAxis: UILayoutConstraintAxis.Horizontal)

    view.addSubview(subjectLabel)
    
    var messageLabel = UILabel.standardCaptionLabel(true)
    messageLabel.text = "Message"
    view.addSubview(messageLabel)
    
   
    var elements: [NSObject : AnyObject] = ["toField": toField, "topLayoutGuide": topLayoutGuide, "view": view, "toLabel": toLabel, "fromLabel": subjectLabel, "fromField": subjectField, "bodyTextView": bodyTextView, "messageLabel": messageLabel]

    
    // Horizontal layout
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-(hlp)-[toLabel]-[toField]-(hrp)-|",
      options: .DirectionLeadingToTrailing,
      metrics: UPMStandards.autoLayoutMetrics,
      views: elements))
    
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-(hlp)-[fromLabel]-[fromField]-(hrp)-|",
      options: .DirectionLeadingToTrailing,
      metrics: UPMStandards.autoLayoutMetrics,
      views: elements))

    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-(hlp)-[bodyTextView]-(hrp)-|",
      options: .DirectionLeadingToTrailing,
      metrics: UPMStandards.autoLayoutMetrics,
      views: elements))
    
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-(hlp)-[messageLabel]-(hrp)-|",
      options: .DirectionLeadingToTrailing,
      metrics: UPMStandards.autoLayoutMetrics,
      views: elements))
    
    // Vertical layout
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide]-[toField]-[fromField]", options: .DirectionLeadingToTrailing, metrics: nil, views: elements))
    
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide]-[toLabel]-[fromLabel]-[messageLabel]-[bodyTextView]", options: .DirectionLeadingToTrailing, metrics: nil, views: elements))
    
    // Center labels
    view.addConstraint(NSLayoutConstraint(item: toLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal, toItem: toField, attribute: .CenterY, multiplier: 1.0, constant: 0))
    
    view.addConstraint(NSLayoutConstraint(item: subjectLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal, toItem: subjectField, attribute: .CenterY, multiplier: 1.0, constant: 0))
    
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
  
  /**
  Validates the email email by checking if a minimum length is met for 
  the subject and body.
  
  :returns: error - Valid email or not and a possible error message.
  */
  private func validateEmail() -> (error: Bool, errorMessage: String?) {
    var error = ""
    view.endEditing(true)
    
    if count(subjectField.text) <= 1 {
      error += "Please enter a subject. "
    }
    
    if count(bodyTextView.text) <= 1{
      error += "Please enter a message. "
    }
    return error == "" ? (false, nil) : (true, error)
  }
  
  /**
  Checks if the email is valid and then sends email to the user
  specified by user variable.
  */
  func sendEmail() {
    
    if validateEmail().error {
      var invalidEmailAlert = UIAlertController(title: "Invaild Email", message: validateEmail().errorMessage, preferredStyle: .Alert)
      var okayAction = UIAlertAction(title: "Okay", style: .Default, handler: {
        (action) -> Void in
        self.bodyTextView.becomeFirstResponder()
        return
      })
      invalidEmailAlert.addAction(okayAction)
      presentViewController(invalidEmailAlert, animated: true, completion: nil)
      return
    }
    
    // create dictionary to send
    var currentUser = PFUser.currentUser()!
    let email: [String: String] = ["to": "jcliedtke@gmail.com", "from": currentUser.email!, "subject": subjectField.text, "message": bodyTextView.text]
    
    // Progress HUD
    var progressHUD = MBProgressHUD.showHUDAddedTo(view, animated: true)
    progressHUD.labelText = "Sending email..."
    
    PFCloudExt.callFunctionAsync(PFCloudExtConstants.sendEmailFunction, withParameters: email).continueWithBlock {
      (task: BFTask!) -> AnyObject! in
      
      if task.error == nil { // success
        progressHUD.labelText = "Success"
        progressHUD.hide(true)
        self.dismissViewControllerAnimated(true, completion: nil)
        return nil
        
      } else { // handle error or timeout
        progressHUD.labelText = "Error"
        progressHUD.hide(true)
        var errorString = task.error.userInfo?[NSString(string: "error")] as! NSString
        var alertError = UIAlertController(title: "Error", message: String(errorString), preferredStyle:.Alert)
        alertError.addAction(UIAlertAction(title: "Okay", style: .Default, handler:nil))
        self.presentViewController(alertError, animated: true, completion: nil)
        return nil;
      }
    }
  }
  

}
