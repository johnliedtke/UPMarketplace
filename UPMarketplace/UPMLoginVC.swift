//
//  UPMLoginVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/15/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

/// Constants
struct UPMLoginVCConstants {
  static let minPasswordLength = 5
  static let minEmailLength = 4
  static let minFullNameLength = 4
}

/**
  UPMLoginVC handles creating new users and signing in existing
  ones. Users who are signed in must have their email confirmed. 
  This controller should be presented modally pushed onto a 
  navigation controller so it can be dismissed easily when the 
  user signs in.
*/
public class UPMLoginVC: UIViewController {
  
  // MARK: - Public Properties
  @IBOutlet var logoImageView: UIImageView!
  @IBOutlet var emailField: UITextField!
  @IBOutlet var passwordField: UITextField!
  
  
  // Handle when a user sucessfully logs in, perhaps dismiss?
  var logInSuccessfulHandler: ((sender: AnyObject) -> ())!

  // MARK: - Private Properties
  private var registerEmailField: UITextField?
  private var registerFullNameField: UITextField?
  private var registerPasswordField: UITextField?
  private var registerPasswordConfirmationField: UITextField?
  
  // MARK: - Public Methods

  /// Calls createAccount()
  @IBAction func createAccountPressed(sender: UIButton) {
    createAccount(nil)
  }
  
  /// Calls logIn(:password) with textfield input
  @IBAction func signInPressed(sender: AnyObject) {
    logIn(emailField.text ?? "", password: passwordField.text ?? "")
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.standardBackgroundColor()
    
    var currentUser = PFUser.currentUser()
    
    if currentUser == nil {
      println("No User")
    }
    
    var barButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "pop")
    navigationItem.leftBarButtonItem = barButtonItem
    
  }
  func pop() -> Void {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  override public func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    //tabBarController?.tabBar.hidden = true
  }
  
  override public func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
   // tabBarController?.tabBar.hidden = false
  }
  
  /**
  Logs a user in and checks if the user has confirmed his or her 
  email. If not the user is logged out and presented with a reminder to 
  confirm email.
  
  :param: username Username of user (email address)
  :param: password Password of user
  */
  func logIn(username: String, password: String) -> Void {
    
    UPMUser.loginAsync(username, password: password).continueWithBlock {
      (task: BFTask!) -> AnyObject! in
      if let error = task.error {
        
      } else {
        let user = task.result as UPMUser
        
        // Confirmed email
        if !user.isEmailVerified() {
          //PFUser.logOut()
          println("Email is not verified")
        }
        // Notify of success
        self.logInSuccessfulHandler(sender: self)
      }
      return nil
    }
    
  }
  
  /**
  Creates an alertController for a user to enter in details to create an
  account.
  
  :param: defaultFieldValues Dictionary containing the default values for the fields
  */
  func createAccount(defaultFieldValues: [String: String]?) -> Void {
    let message = defaultFieldValues?["message"] ?? "You must sign up using your @up.edu email address."
    var signUpAlert = UIAlertController(title: "Registration", message: message, preferredStyle: .Alert)
    
    signUpAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.placeholder = "Email"
      textField.keyboardType = .EmailAddress
      textField.text = defaultFieldValues?["email"] ?? ""
      self.registerEmailField = textField
    }
    
    signUpAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.placeholder = "Full name"
      textField.text = defaultFieldValues?["fullName"] ?? ""
      self.registerFullNameField = textField
    }
    
    signUpAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.placeholder = "Password"
      textField.secureTextEntry = true
      self.registerPasswordField = textField
    }
    
    signUpAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.placeholder = "Confirm password"
      textField.secureTextEntry = true
      self.registerPasswordConfirmationField = textField
    }
    
    var signUpAction = UIAlertAction(title: "Sign Up", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
      self.signUp()
    }
    var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
    
    signUpAlert.addAction(signUpAction)
    signUpAlert.addAction(cancelAction)
    
    presentViewController(signUpAlert, animated: true, completion: nil)
  }
  
  // MARK: - Private Methods
  
  func signUp() -> Void {
    
    if !validateSignUpFields().isValid {
      // handle error
      createAccountText()
      return;
    }
    
    var user = UPMUser()

    user.email = registerEmailField?.text
    user.username = registerEmailField?.text
    user.fullName = registerFullNameField?.text
    user.password = registerPasswordField?.text
    
    
    // Sign up user
    user.signUpInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
      
      if success {
        // Log out user and notify of email verification requirment
        PFUser.logOut()
        var emailAlert = UIAlertController(title: "Success!", message: "You have signed up sucessfully. Please check your email to verify.", preferredStyle: .Alert)
        var okayAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil)
        emailAlert.addAction(okayAction)
        
      } else {
        // Display error
        var errorString = error.userInfo?[NSString(string: "error")] as NSString
        var alertError = UIAlertController(title: "Error", message: String(errorString), preferredStyle: UIAlertControllerStyle.Alert)
        var errorAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: {
          (alert: UIAlertAction!) -> Void in
          // Show them registeration again
          self.createAccountText()
        })
        alertError.addAction(errorAction)
        self.presentViewController(alertError, animated: true, completion: nil)
      }
    }
  }
  
  private func createAccountText() {
    var defaultFieldValues = [String: String]()
    defaultFieldValues["fullName"] = registerFullNameField?.text
    defaultFieldValues["email"] = registerEmailField?.text
    defaultFieldValues["message"] = validateSignUpFields().error
    createAccount(defaultFieldValues)
  }

  
  /**
  Validates the user input in the createAccount fields. Checks length and
  that the passwords match. Back-end handles the rest of checking. Returns
  a tuple with a possible error and whether the input is valid.
  
  :return: isValid Is valid input
  :return: error Possible error with input
  */
  private func validateSignUpFields() -> (isValid: Bool, error: String?) {
    let invalidInput = ""
    let fullName = registerFullNameField?.text ?? invalidInput
    let email = registerEmailField?.text ?? invalidInput
    let password = registerPasswordField?.text ?? invalidInput
    let passwordConfirmed = registerPasswordConfirmationField?.text ?? invalidInput
    
    var error = ""
    
    // Meets minimum legnth requirements
    func validInputLength(input: String, minLength: Int) -> Bool {
      return countElements(input) > minLength
    }
    
    if !validInputLength(fullName, UPMLoginVCConstants.minFullNameLength) {
      error += "Full name too short (> \(UPMLoginVCConstants.minFullNameLength)). "
    }
    
    if !validInputLength(email, UPMLoginVCConstants.minEmailLength) {
      error += "Email too short (> \(UPMLoginVCConstants.minEmailLength)). "
    }
    
    if !validInputLength(password, UPMLoginVCConstants.minPasswordLength) {
      error += "Password too short (> \(UPMLoginVCConstants.minFullNameLength)). "
    }
    
    if !(password == passwordConfirmed) {
      error += "Passwords do not match. "
    }
    
    return (error == "", error)
  }
  
  
  
  
  //TODO: Implement
  @IBAction func forgotPasswordPressed(sender: UIButton) {
    
  }


}