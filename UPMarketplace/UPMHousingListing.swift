//
//  UPMHousingListing.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/13/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//



/**
 The UPMHousingListing class is a subclass of UPMListing used to
 display listings related to housing on the UPMarketplace.
*/

//TODO: Implement class
public class UPMHousingListing: UPMListing, PFSubclassing {
  
  // MARK: - Public Properties
  
  // MARK: - PFSubclassing Methods
  
  /// The name of the PFObject subclass as it would appear
  /// in the data browser.
  ///
  /// :returns: The name of the class
  public class func parseClassName() -> String! {
    return "UPMHousingListing"
  }
  
}
