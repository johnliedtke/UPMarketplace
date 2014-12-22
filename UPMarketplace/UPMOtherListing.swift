//
//  UPMOtherListing.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/13/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//
import UIKit
import Foundation

/// A UPMOtherListing is the basic object for listing anything that is
/// not a housing or textbook listing. OtherListings are categorized
/// by the category propety.
public class UPMOtherListing: UPMListing, PFSubclassing  {
  
  // MARK: Properties
  /// Category for filtering other listings
  @NSManaged public var category: String?
  
  // MARK: PFSubclassing Methods
  /// The name of the PFObject subclass as it would appear
  /// in the data browser.
  ///
  /// :returns: The name of the class
  public class func parseClassName() -> String! {
    return "UPMOtherListing"
  }
  
  /// Registers the subclass with Parse
  override public class func load() {
    self.registerSubclass()
  }



}
