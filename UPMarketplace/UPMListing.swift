//
//  UPMListing.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/8/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//
import UIKit
/**
Abstract class that provides the base for all
marketplace listings. Must be subclassed. Steps to properly subclass:

1. Adopt the PFSubclassing protocol
2. Fullfill required methods parseClassName()
3. Register subclass with Parse by overridng load() and calling
self.registerSubclass()
*/
public class UPMListing: PFObject  {
  
  // MARK: - Properties
  
  /// Title of the listing
  @NSManaged public var title: String
  
  /// User-description of listing
  @NSManaged public var descriptionS: String?
  
  /// Price of listing
  @NSManaged public var price: Double
  
  /// Indicator for Or Best Offer (OBO)
  @NSManaged public var oBO: ObjCBool
  
  /// Auto-reject limit for OBO
  ///
  /// 1. Check oBO before using
  @NSManaged public var limit: Double
  
  /// The image for a listing stored as a PFFile
  @NSManaged public var picture: PFFile?
  
  /// The User that created the listing
  @NSManaged internal var owner: UPMUser
  
  /// Users that have been blacklisted by the listing owner
  @NSManaged internal var blackListedUsers: [UPMUser]
  
  /// The public visibility of the object
  @NSManaged public var isHidden: ObjCBool
  
  /// The array of reservations
  @NSManaged internal var reservations: [UPMReservation]
  
  // TODO: Add reservations array after class has been implemented
  
  /// Returns the image for a listing
  var photo: UIImage?
  
  // MARK: - Methods
  
  /// Displays the price in human-readable form, e.g. $50.00
  func displayPrice() -> String {
    return String(format: "$%.2f", price)
  }
  
  /// Checks the reservations array and returns a true boolean if any of the
  /// Methods meet the requirements for this listing
  func isReserved() -> Bool {
    if oBO {
      for res in reservations {
        if res is UPMReservationObo && isNotBlackListed(res.getReserver()) && (res as UPMReservationObo).offer >= limit {
          return true
        }
      }
    }
      
    else{ //Not OBO
      for res in reservations {
        if isNotBlackListed(res.getReserver()) {
          return true
        }
      }
    }
    return false
  }
  
  /// checks if user is on black list
  /// @param reservr
  func isNotBlackListed(resevr: UPMUser) -> Bool {
    for user in blackListedUsers {
      if user.objectId == resevr.objectId {
        return true
      }
    }
    return false
  }
  /// Checks the reservations array and returns a  UPMUser if any of the
  /// Reservations meet the requirements for this listing.
  func currentReserver() -> UPMUser?
  {
    if !isReserved()
    {
      return nil
    }
    var curUser: UPMUser
    if oBO {
      var max = 0.0
      for res in reservations {
        if res is UPMReservationObo && isNotBlackListed(res.getReserver()) && (res as UPMReservationObo).offer >= limit {
          if max < (res as UPMReservationObo).offer {
            curUser = res.getReserver()
            max = (res as UPMReservationObo).offer
          }
        }
      }
    }
      
    else{ //Not OBO
      var time: NSDate
      for res in reservations {
        if isNotBlackListed(res.getReserver()) {
          return res.getReserver()
        }
      }
    }
    return nil
  }
  
  
  func reserve(res: UPMReservation) {
    reservations.append(res)
  }
  
  // TODO:  Add display methods for all price objects
  
  
  
  
}
