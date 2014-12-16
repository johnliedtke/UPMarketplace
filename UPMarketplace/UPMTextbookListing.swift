//
//  UPMTextbookListing.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/13/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

/// A UPMTextbookListing is the basic object for a listing of a textbook.
public class UPMTextbookListing: UPMListing, PFSubclassing {
  
  // MARK: Properties
  /// Textbook associated with listing
  @NSManaged public var textbook: UPMTextbook?
  
  override init() {
    super.init()
    textbook = UPMTextbook()
  }
  
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
