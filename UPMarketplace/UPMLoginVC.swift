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

public class UPMLoginVC: UIViewController {
  
  // MARK: - Public Properties
  @IBOutlet var logoImageView: UIImageView!
  @IBOutlet var emailField: UITextField!
  @IBOutlet var passwordField: UITextField!
  
  // MARK: - Private Properties
  private var registerEmailField: UITextField?
  private var registerFullNameField: UITextField?
  private var registerPasswordField: UITextField?
  private var registerPasswordConfirmationField: UITextField?
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.standardBackgroundColor()
   
  }
  
  func login(sender: AnyObject) {
  }
  
  @IBAction func createAccountPressed(sender: UIButton) {
    createAccount(nil)
  }
  
  /**
  
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
  
  func signUp() -> Void {
    
    if !validateSignUpFields().isValid {
      // handle error
      var defaultFieldValues = [String: String]()
      defaultFieldValues["fullName"] = registerFullNameField?.text
      defaultFieldValues["email"] = registerEmailField?.text
      defaultFieldValues["message"] = validateSignUpFields().error
      createAccount(defaultFieldValues)
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
        println("User signed up")
      } else {
        println("Failure")
      }

    }
  }
  
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
  
  
  
  

  @IBAction func forgotPasswordPressed(sender: UIButton) {
    
  }
    /*
  @IBOutlet var forgotPasswordPressed: UIButton!
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
