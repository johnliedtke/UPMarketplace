//
//  UPMLoginCalls.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/18/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import Foundation


class UPMLoginCalls {
  
  
  class func loginAsync(username: String, password: String) -> BFTask {
    var task = BFTaskCompletionSource()
    
    PFUser.logInWithUsernameInBackground(username, password: password) {
      (user: PFUser!, error: NSError!) -> Void in
    
      if error == nil {
        task.setResult(user)
      } else {
        task.setError(error)
      }
    
    }
    return task.task
  }
  
  
}
