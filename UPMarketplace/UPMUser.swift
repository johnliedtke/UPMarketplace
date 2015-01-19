//
//  UPMUser.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/14/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

struct UPMUserConstants {
  static let className = "UPMUser"
}

class UPMUser: PFUser, PFSubclassing {
  
  /// User's first and last name e.g. John Slade
  @NSManaged var fullName: String!
  
  
  
  /// Register subclass
  override class func load() {
    self.registerSubclass()
  }
  
  
  
  func emailVerified() -> Bool {
    return self["emailVerified"] as Bool
  }
  
  class func loginAsync(username: String, password: String) -> BFTask {
    let task = BFTaskCompletionSource()
    
    PFUser.logInWithUsernameInBackground(username, password: password) {
      (user, error) -> Void in
      if error == nil {
        task.setResult(user)
      } else {
        task.setError(error)
      }
    }
    return task.task
  }
   
}
