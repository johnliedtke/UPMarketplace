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
  static let loginStoryboardIdentifier = "UPMLogin"
}


extension PFUser {
  class func doSomethingComplicatedAsync(taskFunc: ()->BFTask, progress: NSProgress) -> BFTask {
    let complicatedTask = BFTaskCompletionSource()
    
    taskFunc().continueWithBlock() { (task) in
      if progress.cancelled {
        complicatedTask.cancel()
      }
      if task.error == nil {
        complicatedTask.setResult(task.result)
      } else {
        if let error = task.error {
          println(error.localizedDescription)
        }
        complicatedTask.setError(task.error)
      }
      return nil
    }
    return complicatedTask.task
  }

  class func doSomethingComplicatedAsync(progress: NSProgress) {
    PFUser.logInWithUsernameInBackground("eow", password: "Meow").continueWithBlock() { (task) in
      if progress.cancelled {
        return task.cancelled
      }
      println("meow")
      return task.result
    }

  }
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
  private weak var forgotPasswordField: UITextField!
  
  // MARK: - Public Methods
  
  /*
  Displays an instance of UPMLoginVC if there is no user logged
  in.
  */
  public class func displayLoginInController(controller: UIViewController) {
    if PFUser.currentUser() == nil {
      var loginStoryboard = UIStoryboard(name: UPMLoginVCConstants.loginStoryboardIdentifier, bundle: nil)
      var nav = loginStoryboard.instantiateInitialViewController() as! UINavigationController
      var loginVc = nav.viewControllers.first as! UPMLoginVC
      loginVc.logInSuccessfulHandler = { (sender) -> Void in
        controller.dismissViewControllerAnimated(true, completion: nil)
      }
      
      controller.presentViewController(nav, animated: true, completion: nil)
      
    }
  }

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
    
    if PFUser.currentUser() == nil {
      SALQuickTutorialViewController.showIfNeededForKey("dfddddsfddgdfsfds", title: "Sign up", message: "Please sign up by selecting \"Create Account\" and confirming your UP email.", image: UIImage(named: "loginTut.png"))
    }
  }
  
  func timerFinished(timer: NSTimer) {
    println("Timer finished")
    if let progress = timer.userInfo?["progress"] as? NSProgress {
      progress.cancel()
    }

  }
  
  
  func pop() -> Void {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  /**
  Logs a user in and checks if the user has confirmed his or her 
  email. If not the user is logged out and presented with a reminder to 
  confirm email.
  
  :param: username Username of user (email address)
  :param: password Password of user
  */
  func logIn(username: String, password: String) -> Void {
    
    
    var progress = NSProgress(parent: nil, userInfo: nil)
    
    if UPMReachabilityManager.isUnreachable() {
      UPMReachabilityManager.alertOfNoNetworkConnectionInController(self)
      return
    }

    APP().huddie(labelText: "Loggin in...")
    
    PFUser.doSomethingComplicatedAsync({return PFUser.logInWithUsernameInBackground(username, password: password)}, progress: progress).continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock: { [unowned self] (task) in

      if task.error == nil {
        self.hideHuddieWithMessage("", delay: 0.1) {

          let user = task.result as! PFUser
          
          // Confirm that the user has a verified email address
          if !user.isEmailVerified() {
            PFUser.logOut()
            var emailAlert = UIAlertController(title: "Email not confirmed", message: "Please verify your email address.", preferredStyle: .Alert)
            emailAlert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
            self.presentViewController(emailAlert, animated: true, completion: nil)
            
          } else {
            self.logInSuccessfulHandler(sender: self)
          }
        }

      } else {
        self.hideHuddieWithMessage("Error", delay: 0.1) {
          // Display error
          let error = task.error
          var errorString = error.userInfo?[NSString(string: "error")] as! NSString
          var alertError = UIAlertController(title: "Error", message: String(errorString), preferredStyle:.Alert)
          alertError.addAction(UIAlertAction(title: "Okay", style: .Default, handler:nil))
          self.presentViewController(alertError, animated: true, completion: nil)
        }
      }
      return nil

    })

  }
  
  /**
  Creates an alertController for a user to enter in details to create an
  account.
  
  :param: defaultFieldValues Dictionary containing the default values for the fields
  */
  func createAccount(defaultFieldValues: [String: String]?) -> Void {
    let message = defaultFieldValues?["message"] ?? "You must sign up using your @up.edu email address."
    var signUpAlert = UIAlertController(title: "Registration", message: message, preferredStyle: .Alert)
    
    signUpAlert.addTextFieldWithConfigurationHandler { [unowned self] (textField) in
      textField.placeholder = "Email"
      textField.keyboardType = .EmailAddress
      textField.text = defaultFieldValues?["email"] ?? ""
      self.registerEmailField = textField
    }
    
    signUpAlert.addTextFieldWithConfigurationHandler { [unowned self] (textField) in
      textField.placeholder = "Full name"
      textField.text = defaultFieldValues?["fullName"] ?? ""
      self.registerFullNameField = textField
    }
    
    signUpAlert.addTextFieldWithConfigurationHandler { [unowned self] (textField) in
      textField.placeholder = "Password"
      textField.secureTextEntry = true
      self.registerPasswordField = textField
    }
    
    signUpAlert.addTextFieldWithConfigurationHandler { [unowned self] (textField) in
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
    user.username = registerEmailField?.text.lowercaseString
    user.fullName = registerFullNameField?.text
    user.password = registerPasswordField?.text

    // Sign up user
    
    user.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
      
      if success {
        // Log out user and notify of email verification requirment
        PFUser.logOut()
        var emailAlert = UIAlertController(title: "Success!", message: "You have signed up sucessfully. Please check your email to verify.", preferredStyle: .Alert)
        var okayAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil)
        emailAlert.addAction(okayAction)
        self.presentViewController(emailAlert, animated: true, completion: nil)
        
      } else {
        // Display error
        var errorString = error!.userInfo?[NSString(string: "error")] as! NSString
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
      return count(input) > minLength
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
    let forgotController = UIAlertController(title: "Forgot Password", message: "Enter your email address and a reset link will bet sent.", preferredStyle: .Alert)
    forgotController.addTextFieldWithConfigurationHandler { [unowned self] (textField) in
      textField.placeholder = "email address"
      textField.keyboardType = .EmailAddress
      self.forgotPasswordField = textField
    }
    forgotController.addAction(UIAlertAction(title: "Send", style: .Default) {
      [unowned self] (action) in
      self.APP().huddie(labelText: "Requesting reset...")
      PFUser.requestPasswordResetForEmailInBackground(self.forgotPasswordField.text).continueWithBlock() {
        (task) in
        if let error = task.error {
          self.hideHuddieWithMessage("Error", delay: 0.1) {
            self.displayErrorAlertWithMessage(error.localizedDescription)
          }
        } else {
          self.hideHuddieWithMessage("Sent...", delay: 0.3, action: nil)
        }
        return nil
      }
    })
      
    forgotController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
    presentViewController(forgotController, animated: true, completion: nil)
  }


}
