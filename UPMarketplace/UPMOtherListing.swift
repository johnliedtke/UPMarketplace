//
//  UPMOtherListing.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/13/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

/**
 A UPMOtherListing is the basic object for listing anything that is
 not a housing or textbook listing. OtherListings are categorized
 by the category propety. It is a subclass of UPMListing.
*/
public class UPMOtherListing: UPMListing, PFSubclassing  {
  
  // MARK: - Public Properties
  
  /// Category for filtering the different other listings.
  @NSManaged public var category: String?
  
  /// Tag for filtering
  @NSManaged public var tag: String?
  
  // MARK: -  PFSubclassing Methods
  
  /**
  The name of the PFObject subclass as it would appear
  in the data browser.
  
  :returns: The name of the class
  */
  public class func parseClassName() -> String! {
    return "UPMOtherListing"
  }
  
  override class func displayQuery() -> PFQuery {
    var listingQuery = PFQuery(className: "UPMOtherListing")
    listingQuery.orderByDescending("createdAt")
    listingQuery.whereKey("isHidden", equalTo: NSNumber(bool: false))
    listingQuery.includeKey("blackListedUsers")
    listingQuery.includeKey("reservations")
    listingQuery.includeKey("reservations.reserver")
    listingQuery.includeKey("owner")
    return listingQuery
  }

}
