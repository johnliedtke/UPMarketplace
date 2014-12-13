//
//  UPMListing.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/8/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//
import UIKit

/// Abstract class that provides the base for all
/// marketplace listings. Must be subclassed. Steps to properly subclass:
///
/// 1. Adopt the PFSubclassing protocol
/// 2. Fullfill required methods parseClassName()
/// 3. Register subclass with Parse by overridng load() and calling
///    self.registerSubclass()
///
public class UPMListing: PFObject  {
  
  /// MARK: Properties
  /// Title of the listing
  @NSManaged public var title: String
  
  /// User-description of listing
  @NSManaged public var descriptionS: String?
  
  /// Price of listing
  @NSManaged public var price: Double
  
  /// Indicator for Or Best Offer (OBO)
  @NSManaged public var oBO: Bool
  
  /// Auto-reject limit for OBO
  ///
  /// 1. Check oBO before using
  @NSManaged public var limit: Double
  
  /// The image for a listing stored as a PFFile
  @NSManaged public var picture: PFFile?
  
  /// Returns the image for a listing
  var photo: UIImage?
  
}
