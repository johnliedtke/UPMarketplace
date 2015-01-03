//
//  UPMSellItem.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/9/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit


/**
  The UPMSellItem is a simple data structure to aid in gathering user-input
  for a UPMListing. It can be coupled with UPMSellCell well.

  - See UPMSellItemContainer
*/
class UPMSellItem {
  
  /// The display title of the attribute.
  var title: String
  
  /// The display description of the attribute.
  var itemDescription: String
  
  /// Indicates whether the attribute is optional.
  var isOptional: Bool = false
  
  /// Indicates whether the attribute is complete. (The user has filled
  /// in all information pertaining to the attribute)
  var isComplete: Bool = false
  
  
  init(title: String, description: String) {
    self.title = title
    self.itemDescription = description
  }

}
