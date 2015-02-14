//
//  UPMActivity.swift
//  UPMarketplace
//
//  Created by John Liedtke on 2/14/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import Foundation


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


