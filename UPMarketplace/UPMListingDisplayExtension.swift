//
//  UPMListingDisplayExtension.swift
//  UPMarketplace
//
//  Created by John Liedtke on 3/5/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import Foundation

/**
  Methods that can be used to display various aspects of a listing.
*/
extension UPMListing {
  
  /**
  Creates a query that inlucdes all the necessary relational data to display
  a listing.
  
  :returns: Query to displaying listings
  */
  class func displayQuery() -> PFQuery {
    var listingQuery = PFQuery(className: "UPMOtherListing")
    listingQuery.orderByDescending("createdAt")
    listingQuery.whereKey("isHidden", equalTo: NSNumber(bool: false))
    listingQuery.includeKey("blackListedUsers")
    listingQuery.includeKey(NSString(string: "reservations") as String)
    listingQuery.includeKey("reservations.reserver")
    return listingQuery
  }
  
  /// Displays the price in human-readable form, e.g. $50.00
  func displayPrice() -> String {
    return String(format: "$%.2f", price)
  }
  
  /**
  Creates a description of listing's reservation status for the seller.
  
  :returns: Seller's listing reserveation status
  */
  public func displaySellerReservationStatus() -> String {
    if reservationCount().accepted > 0 {
      return "Accepted Reservation"
    } else if reservationCount().waiting > 0 {
      return "Reservation Waiting"
    } else {
      return "No Reservations"
    }
  }
  
  /**mathc
  Creates a string describing the status of a reservation.
  
  :returns: Reservation status of a listing.
  */
  public func displayReservationStatus() -> String {
    if reservations!.isEmpty {
      return "No Reservations"
    }
    if let firstReservation = reservations!.first {
      switch(ReservationStatus(rawValue: firstReservation.status)!) {
      case .Accepted:
        return "Reservation Accepted"
      case .Waiting:
        return "Reservation Need Action"
      case .Rejected:
        return "Reservation Rejcted"
      default:
        return "Reservation Error"
      }
    }
    return ""
  }
  
}

