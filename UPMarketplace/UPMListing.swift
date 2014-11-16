//
//  UPMListing.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/8/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

class UPMListing: PFObject, PFSubclassing {
  
  var descriptionS: String = ""
  var price: Double = 0.00
  var oBO: Bool = false
  var limit: Double = 0.00
  
    
    class func parseClassName() -> String! {
        return "UPMListing"
    }
    
    override class func load() {
        self.registerSubclass()
    }

}
