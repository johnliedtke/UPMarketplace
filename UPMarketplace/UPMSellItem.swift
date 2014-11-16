//
//  UPMSellItem.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/9/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit



class UPMSellItem {
  
  var value: AnyObject?
  var title: String
  var itemDescription: String
  var isOptional: Bool = false
  var isComplete: Bool = false
  
  init(title: String, description: String) {
    self.title = title
    self.itemDescription = description
  }

}
