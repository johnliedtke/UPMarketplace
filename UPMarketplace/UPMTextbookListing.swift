//
//  UPMTextbookListing.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/24/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

public class UPMTextbookListing: UPMListing, PFSubclassing {
  
  @NSManaged public var iSBN: String?
  @NSManaged public var course: String?
  @NSManaged public var professor: String?
  
  convenience init(title: String) {
    self.init()
    self.title = title
  }
  
  public class func parseClassName() -> String! {
    return "UPMTextbookListing"
  }
  
  override public class func load() {
    self.registerSubclass()
  }
   
}
