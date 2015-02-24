//
//  UPMReservation.swift
//  UPMarketplace
//
//  Created by Justice Nichols on 1/17/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//


enum ReservationStatus: Int, Printable {
  case Rejected, Accepted, Waiting
  
  var description : String {
    get {
      switch(self) {
      case .Rejected:
        return "Rejected"
      case .Accepted:
        return "Accepted"
      case .Waiting:
        return "Waiting"
      }
    }
  }
}


/**
 A UPMReservation is an object containing information pertinent to a reservation of UPMListing and
 is used for sending notifications.
*/
public class UPMReservation: PFObject, PFSubclassing  {

  // MARK: - Enum Def
  
  
  // MARK: - Properties

  /// The time that the reservation object was created
  @NSManaged public var reserveTime: NSDate
  
  /// The UPMUser that reserved the object
  @NSManaged internal var reserver: PFUser
  
  /// An associated message written by the reserver
  @NSManaged public var message: String
  
  /// Associated listing of reservation
  //@NSManaged public var listing: UPMListing
  
  /// Status of reservation
  @NSManaged public var status: Int
  
  /// Listing associated with the reservervation. Stored in the first array spot.
  @NSManaged public var listing: [UPMListing]
  
  // MARK: - Methods
  
  /**
  Creates a UPMReservation with a default state of waiting.
  */
  convenience init(reserver: PFUser, listing: UPMListing, message: String) {
    self.init()
    var reservePointer = PFObject(withoutDataWithClassName:"_User", objectId: reserver.objectId)
    self.reserver = reservePointer as! UPMUser
    self.message = message
    self.reserveTime = NSDate()
    self.status = ReservationStatus.Waiting.rawValue
    self.listing = [UPMListing]()
    self.listing.append(listing)
  }
  
  /**
  Get the listing that is associated with the reservation.
  */
  public func getListing() -> UPMListing {
    return listing.first!
  }
  
  public func displayStatus() -> String {
    return (ReservationStatus(rawValue: status)?.description)!
  }
  
  /// returns the reserver{
  internal func getReserver() -> PFUser
  {
    return reserver
  }
  
  // MARK: - PFSubclassing Methods
  
  /**
  The name of the PFObject subclass as it would appear
  in the Parse data browser.
  
  :returns: The name of the class
  */
  public class func parseClassName() -> String! {
    return "UPMReservation"
  }
 
}

//internal class UPMReservationContainer {
//  
//  /// Reservations
//  private var reservations = [UPMReservation]()
//  
//  // Associated Listing
//  private var listing = UPMListing()
//  
//  convenience init(reservations: [UPMReservation], listing: UPMListing) {
//    self.init()
//    self.reservations += reservations
//    self.listing = listing
//  }
//  
//}
//
//






