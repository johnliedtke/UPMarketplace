//
//  UPMConstants.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/21/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

struct Constants {
  
  struct Email {
    static let kNotificationFooter = "This email was auto-generated from the UP Market app. To disable email email notifications, log into the app and navigate to Account->Settings and deselect email notifications"
    static let kNoReplyAddress = "no-reply@upmarket.us"
  }
  
  
  
  struct SellStoryboard {
  static let MainStoryboard = "SellMain"
  }
}


func ==(lhs: PFObject, rhs: PFObject) -> Bool {
  return lhs.objectId == rhs.objectId
}


func isItemInArray<T: Equatable>(array: [T], item: T) -> Bool {
  for i in array {
    if item == i {
      return true
    }
  }
  return false
}