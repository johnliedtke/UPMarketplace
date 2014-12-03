//
//  UPMOtherListing.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/20/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit
import Foundation


public class UPMOtherListing: UPMListing, PFSubclassing  {
  
  @NSManaged public var category: String?
  
  convenience init(title: String) {
    self.init()
    self.title = title
  }
  
  public class func parseClassName() -> String! {
    return "UPMOtherListing"
  }

 override public class func load() {
    self.registerSubclass()
  }

  
}
