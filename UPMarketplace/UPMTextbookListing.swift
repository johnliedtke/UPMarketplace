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
  
  /// Registers the subclass with Parse
//  override public class func load() {
//    self.registerSubclass()
//  }
  
}
