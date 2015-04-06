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
  public lazy var toLabel: UILabel = {
    var label = UILabel(forAutoLayout: true)
    label.font = UIFont.standardTextFont()
    return label
  }()
  
  public lazy var subjectField: UITextField = {
    var field = UITextField(forAutoLayout: true)
    field.font = UIFont.standardTextFont()
    field.adjustsFontSizeToFitWidth = true
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
  
  // MARK: - View Methods
  
//  public override func loadView() {
//////    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
////    let scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
////    scrollView.scrollEnabled = false
////  scrollView.clipsToBounds = true
////    self.view = scrollView;
//  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    // Keyboard fix
   
    
    view.backgroundColor = UIColor.standardBackgroundColor()
    view.addSubview(toLabel)
    view.addSubview(subjectField)
    view.addSubview(bodyTextView)
    
    // Initialize fields
    toLabel.text = user.username
    subjectField.text = subject

    var toDescLabel = UILabel.standardCaptionLabel(true)
    toDescLabel.text = "To"
    toDescLabel.setContentHuggingPriority(1000, forAxis: UILayoutConstraintAxis.Horizontal)
    toLabel.setContentHuggingPriority(100, forAxis: .Horizontal)
    view.addSubview(toDescLabel)
    
    var subjectLabel = UILabel.standardCaptionLabel(true)
    subjectLabel.text = "Subject"
    subjectLabel.setContentHuggingPriority(1, forAxis: UILayoutConstraintAxis.Horizontal)
    subjectField.setContentHuggingPriority(0, forAxis: UILayoutConstraintAxis.Horizontal)
    subjectLabel.setContentCompressionResistancePriority(1000, forAxis: UILayoutConstraintAxis.Horizontal)
    
    
    //subjectField.setContentCompressionResistancePriority(500, forAxis: UILayoutConstraintAxis.Horizontal)


    view.addSubview(subjectLabel)
    
    var messageLabel = UILabel.standardCaptionLabel(true)
    messageLabel.text = "Message"
    view.addSubview(messageLabel)
    
   
    var elements: [NSObject : AnyObject] = ["toLabel": toLabel, "topLayoutGuide": topLayoutGuide, "view": view, "toDescLabel": toDescLabel, "subjectLabel": subjectLabel, "subjectField": subjectField, "bodyTextView": bodyTextView, "messageLabel": messageLabel]

    
    // Horizontal layout
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-(hlp)-[toDescLabel]-[toLabel]-(hrp)-|",
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
    
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-(hlp)-[subjectLabel]-[subjectField]-(hrp)-|",
      options: .DirectionLeadingToTrailing,
      metrics: UPMStandards.autoLayoutMetrics,
      views: elements))
    
    
    // Vertical layout
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide]-[toLabel]-[subjectField]", options: .DirectionLeadingToTrailing, metrics: nil, views: elements))
    
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide]-[toDescLabel]-[subjectLabel]-[messageLabel]-[bodyTextView]", options: .DirectionLeadingToTrailing, metrics: nil, views: elements))
    
    // Center labels
    view.addConstraint(NSLayoutConstraint(item: toDescLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal, toItem: toDescLabel, attribute: .CenterY, multiplier: 1.0, constant: 0))
    
    //view.addConstraint(NSLayoutConstraint(item: subjectField, attribute: NSLayoutAttribute.Width, relatedBy: .Equal, toItem: toLabel, attribute: .Width, multiplier: 1.0, constant: 0))
    
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
    let toEmail = user.email!
    let email: [String: String] = ["to": user.email!, "from": currentUser.email!, "subject": subjectField.text, "message": bodyTextView.text]
    
    // Progress HUD
    APP().huddie(labelText: "Sending...")
    
    PFCloudExt.callFunctionAsync(PFCloudExtConstants.sendEmailFunction, withParameters: email).continueWithBlock {
      [unowned self] (task) in
      
      if let error = task.error {
        self.hideHuddieWithMessage("Error", delay: 0.1) {
          self.displayErrorAlertWithMessage(error.localizedDescription)
        }
      } else {
        self.hideHuddieWithMessage("Sent...", delay: 0.4) {
          self.dismissViewControllerAnimated(true, completion: nil)
        }
      }
      return nil;
    
    }
  }
  
}


