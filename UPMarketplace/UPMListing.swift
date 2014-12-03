//
//  UPMListing.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/8/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

public class UPMListing: PFObject  {
  
  @NSManaged public var title: String
  @NSManaged public var descriptionS: String?
  @NSManaged public var price: Double
  @NSManaged public var oBO: Bool
  @NSManaged public var limit: Double
  @NSManaged public var picture: PFFile?
  var photo: UIImage?
  
  
//  class func parseClassName() -> String! {
//    return "UPMListing"
//  }
  
//  override class func load() {
//    self.registerSubclass()
//  }
  

  

}
