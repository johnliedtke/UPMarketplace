//
//  UPMTextbookListing.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/13/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

/**
 A UPMTextbookListing is the basic object for a listing of a textbook. It
 is a sublclass of UPMListing. It has a reference to a UPMTextbook which
 is the basis of the listing.
*/
public class UPMTextbookListing: UPMListing, PFSubclassing {
  
  // MARK: - Public Properties
  
  /// Textbook associated with listing
  @NSManaged public var textbook: UPMTextbook!
  
  class func initListing() -> UPMTextbookListing {
    var textbookListing = UPMTextbookListing()
    textbookListing.textbook = UPMTextbook()
    return textbookListing
  }
  
  override class func displayQuery() -> PFQuery {
    var listingQuery = PFQuery(className: "UPMTextbookListing")
    listingQuery.orderByDescending("createdAt")
    listingQuery.whereKey("isHidden", equalTo: NSNumber(bool: false))
    listingQuery.includeKey("blackListedUsers")
    listingQuery.includeKey("reservations")
    listingQuery.includeKey("textbook")
    listingQuery.includeKey("reservations.reserver")
    listingQuery.includeKey("owner")
    return listingQuery
  }
  
  // MARK: - PFSubclassing Methods
  
  /// The name of the PFObject subclass as it would appear
  /// in the data browser.
  ///
  /// :returns: The name of the class
  public class func parseClassName() -> String! {
    return "UPMTextbookListing"
  }
  
  // MARK: - Display
  
  func displayRequiredFields(missingText: String) -> String {
    let isbn = textbook.iSBN13 ?? missingText
    let course = textbook.course ?? missingText
    return "ISBN: \(isbn)\nCourse: \(course)"
  }
  
  func displayOptionalFields(missingText: String) -> String {
    let authors = textbook.authors ?? missingText
    let edition = textbook.edition ?? missingText
    let professor = textbook.professor ?? missingText
    return "Authors: \(authors)\nEdition: \(edition)\nProfessor: \(professor)"
  }
  
  
}
