//
//  UPMTextbook.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/15/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

/**
 The UPMTextbook class represents a textbook that can be sold on the 
 marketplace. It is closely associated with a UPMTextbookListing.
*/
public class UPMTextbook: PFObject, PFSubclassing  {
  
  // MARK: Properties
  /// Category for filtering other listings
  @NSManaged public var title: String?
  
  /// Edition of textbook
  @NSManaged public var edition: String?
  
  /// The ISBN10 number of a textbook, formatting removed
  @NSManaged public var iSBN10: String?
  
  /// The ISBN13 number of a textbook, formatting removed
  @NSManaged public var iSBN13: String?
  
  /// The professor that assigned the textbook
  @NSManaged public var professor: String?

  /// The course the textbook was used in. e.g. CS301
  @NSManaged public var course: String?
  
  /// Authors (separated by comma) in alphabetical order
  @NSManaged public var authors: String?
  
  /// The URL of an image of the book
  public var imageURL: String?
  
  // MARK: - Public Methods
  
  /**
  Creates a more readable ISBN number for humans. Formatted to the
  standards.

  :returns: Formatted iSBN
  */
  public func getFormattedISBN() -> String {
    return iSBN10!
  }
  
  // MARK: - PFSubclassing Methods
  
  /**
  The name of the PFObject subclass as it would appear
  in the Parse data browser.

  :returns: The name of the class
  */
  public class func parseClassName() -> String! {
    return "UPMTextbook"
  }
  
  
}
