//
//  UPMCloud.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/24/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

struct PFCloudExtConstants {
  static let sendEmailFunction = "sendEmail"
}



class PFCloudExt: PFCloud {
  
  
  class func callFunctionAsync(
    name: NSString,
    withParameters parameters: NSDictionary) -> BFTask {
      
      let p = BFTaskCompletionSource()
      
      self.callFunctionInBackground(name as String, withParameters: parameters as [NSObject : AnyObject]) { (result, error) -> Void in
        if let result: AnyObject = result {
          p.setResult(result)
        } else {
          p.setError(error)
        }
      }
      return p.task
  }
  
  class func sendEmailTo(to: PFUser, from: PFUser?, subject: String, body: String, notification: Bool) -> BFTask {
    let emailTask = BFTaskCompletionSource()

    if !(UPMUserPrefs.userDefaults().objectForKey("emailNotifications") as! Bool) && notification {
      emailTask.setResult(true)
      return emailTask.task
    }
    
    var fromEmail: String!
    
    if from != nil {
      fromEmail = from!.email!
    } else {
      fromEmail = Constants.Email.kNoReplyAddress
    }
    
    let email: [String: String] = ["to": to.email!, "from": fromEmail, "subject": subject, "message": body]
    
    
    // if notifications enabled...
    
    PFCloud.callFunctionInBackground(PFCloudExtConstants.sendEmailFunction, withParameters: email).continueWithBlock {
      (task) in
      if let error = task.error {
        emailTask.setError(error)
      } else {
        emailTask.setResult(task.result)
      }
      return nil
    }

    return emailTask.task
  }

}


