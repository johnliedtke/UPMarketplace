//
//  UPMTextbook.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/15/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import Foundation


/// A UPMOtherListing is the basic object for listing anything that is
/// not a housing or textbook listing. OtherListings are categorized
/// by the category propety.
public class UPMTextbook: PFObject, PFSubclassing  {
  
  // MARK: Properties
  /// Category for filtering other listings
  @NSManaged public var title: String?
  
  /// Edition of textbook
  @NSManaged public var edition: String?
  
  /// Unformatted ISBN of a textbook
  @NSManaged public var iSBN: String?
  
  /// The professor that assigned the textbook
  @NSManaged public var professor: String?
  
  /// The course the textbook was used in. e.g. CS301
  @NSManaged public var course: String?
  
  // MARK: Methods
  /// Creates a more readable ISBN number for humans. Formatted to the
  /// standards.
  ///
  /// :returns: Formatted iSBN
  public func getFormattedISBN() -> String {
    return iSBN!
  }
  
  // MARK: PFSubclassing Methods
  /// The name of the PFObject subclass as it would appear
  /// in the data browser.
  ///
  /// :returns: The name of the class
  public class func parseClassName() -> String! {
    return "UPMTextbook"
  }
  
  /// Registers the subclass with Parse
  override public class func load() {
    self.registerSubclass()
  }
  
  
}
