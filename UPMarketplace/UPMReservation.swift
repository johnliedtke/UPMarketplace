//
//  UPMReservation.swift
//  UPMarketplace
//
//  Created by Justice Nichols on 1/17/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

/**
 A UPMReservation is an object containing information pertinent to a reservation of UPMListing and
 is used for sending notifications.
*/
public class UPMReservation: PFObject, PFSubclassing  {

  // MARK: - Enum Def
  
  enum reservationStatus: Int {
    case Rejected, Accepted, Waiting
  }
  
  // MARK: - Properties

  /// The time that the reservation object was created
  @NSManaged public var reserveTime: NSDate
  
  /// The UPMUser that reserved the object
  @NSManaged internal var reserver: UPMUser
  
  /// An associated message written by the reserver
  @NSManaged public var message: String
  
  /// Associated listing of reservation
  @NSManaged public var listing: UPMListing
  
  /// Status of reservation
  @NSManaged public var status: Int
  
  // MARK: - Methods
  
  /**
  Creates a UPMReservation with a default state of waitig.
  */
  convenience init(reserver: UPMUser, listing: UPMListing, message: String) {
    self.init()
    var reservePointer = PFObject(withoutDataWithClassName:"_User", objectId: reserver.objectId)
    self.reserver = reservePointer as UPMUser
    self.message = message
    self.reserveTime = NSDate()
    self.status = reservationStatus.Waiting.rawValue
  }
  
  /// returns the reserver{
  internal func getReserver() -> UPMUser
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
  
  /// Registers the subclass with Parse
  override public class func load() {
    self.registerSubclass()
  }
  

}