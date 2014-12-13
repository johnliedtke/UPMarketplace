//
//  UPMHousingListing.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/13/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

public class UPMHousingListing: UPMListing, PFSubclassing {
  
  // MARK: Properties
  
  // MARK: PFSubclassing Methods
  /// The name of the PFObject subclass as it would appear
  /// in the data browser.
  ///
  /// :returns: The name of the class
  public class func parseClassName() -> String! {
    return "UPMTextbookListing"
  }
  
  /// Registers the subclass with Parse
  override public class func load() {
    self.registerSubclass()
  }
  
}
