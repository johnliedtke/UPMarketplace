//
//  UPMReservationObo.swift
//  UPMarketplace
//
//  Created by Justice Nichols on 1/17/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//




/**
A UPMReservationObo is an object containing information pertinent to a reservation of UPMListingObo and is used for sending notifications.
*/
public class UPMReservationObo: UPMReservation {

  /// An associated message written by the reserver
  @NSManaged public var offer: Double
  

}