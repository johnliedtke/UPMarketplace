//
//  UPMUser.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/14/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

class UPMUser: PFUser, PFSubclassing {
  
  
  /// User's first and last name e.g. John Slade
  @NSManaged var fullName: String!
  
  
  
  /// Register subclass
  override class func load() {
    self.registerSubclass()
  }
   
}