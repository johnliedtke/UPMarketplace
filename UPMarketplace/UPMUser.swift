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

  /**
  Checks if the user has a verfified email.
  
  :return: Email verified
  */
  func isEmailVerified() -> Bool {
    //self["emailVerified"].fetchIfNeeded()
    return self["emailVerified"] as! Bool
  }
  
  /**
  A task for loggin in a user given a username and password in the
  background.
  
  :param: username User's Username (email)
  :param: password User's password
  */
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

/**
  A UPMActivity represents any activity by the user in the application. Serves 
  as a history for the user to view.
*/
class UPMActivity: PFObject, PFSubclassing {
  
  // MARK: - Public Properties
  
  /// Title of activity
  @NSManaged var title: String
  
  /// Description of the activity 
  @NSManaged var activityDescription: String
  
  /// Date of activity 
  @NSManaged var date: NSDate
  
  /// User assoicated with the activity 
  @NSManaged var user: PFUser
  
  // MARK: - Init
  
  convenience init(title: String, description: String, user: PFUser) {
    self.init()
    self.title = title
    self.activityDescription = description
    self.user = user
    self.date = NSDate()
    self.ACL = PFACL(user: user)
  }
  
  // MARK: - Parse Subclassing
  static func parseClassName() -> String! {
    return "UPMActivity"

  }
  
}


class UPMUserData: PFObject, PFSubclassing {

  static func parseClassName() -> String! {
    return "UPMUserData"
  }
  
}

