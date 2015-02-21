//
//  UPMListing.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/8/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//


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
  
  /// Thumbnail of picture
  @NSManaged public var pictureThumbnail: PFFile?
  
  /// The User that created the listing
  @NSManaged internal var owner: PFUser
  
  /// Users that have been blacklisted by the listing owner
  @NSManaged internal var blackListedUsers: [PFUser]!
  
  /// The public visibility of the object
  @NSManaged public var isHidden: ObjCBool
  
  /// The array of reservations
  @NSManaged var reservations: [UPMReservation]!
  
  // TODO: Add reservations array after class has been implemented
  
  /// Returns the image for a listing
  var photo: UIImage?
  
  // MARK: - Public Methods

  /**
  Designated initializer
  */
//  class func initListing(#listing: UPMListing, owner: PFUser)-> UPMListing {
//    listing.reservations = [UPMReservation]()
//    listing.isHidden = false
//    listing.blackListedUsers = [PFUser]()
//    listing.owner = owner
//    return listing
//  }
  
  // MARK: - Background Logic Methods
  
  // MARK: Reservation Methods

  /**
  Reserves a listing for a given user asynchronously. Does not add the reservation if 
  there exists a valid reservation.
  
  //TODO: Send notification
  
  :param: reserver User reserving item.
  :param: message Message?
  */
  func reserveInBackground(reserver: PFUser, message: String) -> BFTask {
    // Create reservation
    var reservation = UPMReservation(reserver: reserver, listing: self, message: "Test Reservation")
    var reserveTask = BFTaskCompletionSource()
    
    // Fetch the reservations
    self.fetchInBackground().continueWithBlock {
      (task: BFTask!) -> AnyObject! in
      var error: NSError!

      if !self.reservations!.filter({ return $0.reserver.objectId == reserver.objectId }).isEmpty {
        // User has already reserved item
        error = NSError.createError("You have already reserved listing.",
          failureReason: "User already has a reservation",
          suggestion: "Do not reserve twice.")
        return BFTask(error: error)
        
      } else if self.isReserved() {
        // Listing is already reserved
        error = NSError.createError("Listing is already reserved.",
          failureReason: "Another user has a valid reservation.",
          suggestion: "Wait")
        return BFTask(error: error)
        
      } else {
        // Add user to reservations and hide the listing
        self.addObject(reservation, forKey: "reservations")
        self.isHidden = true
        return self.saveInBackground()
      }
      
      }.continueWithSuccessBlock {
        (task: BFTask!) -> AnyObject! in
        
        if task.error == nil {
          println("no erorr")
        }
        
        var activity = UPMActivity(title: "Made Reservation", description: "\(title)", user: reserver)
        return activity.saveInBackground()
        
      }.continueWithBlock { (task: BFTask!) -> AnyObject! in
        if task.error == nil {
          reserveTask.setResult("Success")
          return nil
        } else {
          reserveTask.setError(task.error)
          return nil
        }
    }
    return reserveTask.task
  }
  
  /**
  Delete reservation. Deletes a given reservation and updates the listing
  to be unhidden.
  
  //TODO: Notify seller of deleted reservation
  
  :param: reservation Reservation to be deleted
  :param: blackList Should user be added to blacklist
  */
  func deleteReservationInBackground(reservation: UPMReservation, blackList: Bool) -> BFTask {
    var deleteTask = BFTaskCompletionSource()
    
    if blackList {
      addObject(reservation.reserver, forKey: "blackListedUsers")
    }
    removeObject(reservation, forKey: "reservations")
    isHidden = false
    
    reservation.deleteInBackground().continueWithBlock { (task: BFTask!) -> AnyObject! in
      
      return self.saveInBackground()
    }.continueWithBlock { (task: BFTask!) -> AnyObject! in
      if task.error == nil {
        deleteTask.setResult(nil)
      } else {
        deleteTask.setError(task.error)
      }
      return nil
    }
    return deleteTask.task
  }
  
  /**
  Reservation is removed asynchronously. Listing is put back
  on the marketplace.
  
  //TODO: Status change for reservation
  //TODO: Reservation needs to linger so user can see "Rejected State"
  //TODO: Send notification
  
  :param: reservation Reservation to reject
  :param: blackList Should reserver be blacklisted
  */
  func rejectReservationInBackground(reservation: UPMReservation, blackList: Bool) -> BFTask {
    var rejectTask = BFTaskCompletionSource()
    
    if blackList {
      addObject(reservation.reserver, forKey: "blackListedUsers")
    }
    removeObject(reservation, forKey: "reservations")
    isHidden = false
    
    saveInBackground().continueWithBlock {
      (task: BFTask!) -> AnyObject! in
      if task.error == nil {
        rejectTask.setResult(nil)
      } else {
        rejectTask.setError(task.error)
      }
      return nil
    }
    return rejectTask.task
  }
  
  /**
  Deletes the listing and related data asynchronously.
  
  //TODO: Notify potential reservers of deletion
  
  */
  func deleteListingAndRelatedInBackground() -> BFTask {
    var deleteTask = BFTaskCompletionSource()
    
    deleteInBackground().continueWithBlock {
      (task: BFTask!) -> AnyObject! in
      if task.error == nil {
        deleteTask.setResult(nil)
      } else {
        deleteTask.setError(task.error)
      }
      return nil
    }
    return deleteTask.task
  }
  
  /**
  Accept a given resevation and update status. Reservation is updated
  asynchronously.
  
  //TODO: Notify user of status change
  //TODO: Potentially put in reservation class?
  
  :param: reservation Reservation to accept
  */
  func acceptReservationInBackground(reservation: UPMReservation) -> BFTask {
    var acceptTask = BFTaskCompletionSource()
    
    reservation.status = UPMReservation.reservationStatus.Accepted.rawValue
    
    reservation.saveInBackground().continueWithBlock {
      (task: BFTask!) -> AnyObject! in
      if task == nil {
        acceptTask.setResult(nil)
      } else {
        acceptTask.setError(task.error)
      }
      return nil
    }
    return acceptTask.task
  }
  
  /**
  Complete the transaction gracefully and asynchronously!
  */
  func completeTransactionInBackground() {
    
  }
  
  func fetchReservationsInBackground() -> BFTask {
    var reservationsTask = BFTaskCompletionSource()
    
    PFObject.fetchAllInBackground(reservations).continueWithBlock {
      (task: BFTask!) -> AnyObject! in
      
      if let rs = task.result as? [UPMReservation] {
        reservationsTask.setResult(rs)
      } else {
        reservationsTask.setError(task.error)
      }
      return nil
    }
    return reservationsTask.task
  }
  
  func fetchBlackListedBackground() -> BFTask {
    var blackListedTask = BFTaskCompletionSource()
    
    PFObject.fetchAllInBackground(blackListedUsers).continueWithBlock {
      (task: BFTask!) -> AnyObject! in
      
      if let users = task.result as? [PFUser] {
        blackListedTask.setResult(users)
      } else {
        blackListedTask.setError(task.error)
      }
      return nil
    }
    return blackListedTask.task
  }
  
  // MARK: - Helper Methods
  
  /**
  Checks whether a listing is reserveable by fetching the latest data from
  parse.
  //TODO: DELETE?
  */
  public func isReseveableInBackground() -> BFTask {
    var reserveableTask = BFTaskCompletionSource()

    fetchInBackground().continueWithBlock { (task: BFTask!) -> AnyObject! in
      if task.error == nil {
        reserveableTask.setResult(self.isUserValidReserver(PFUser.currentUser()))
      } else {
        reserveableTask.setResult(task.error)
      }
      return nil
    }
    return reserveableTask.task
  }
  
  /**
  Checks whether the listing is in a reservable state using the current data of the
  listing. If the data is not available, isReserveableInBackground() is used instead.
  */
  public func isReservable() -> BFTask {
    var reservableTask = BFTaskCompletionSource()
    reservableTask.setResult(isUserValidReserver(PFUser.currentUser()))
    return reservableTask.task
  }

  
  /**
  Determines whether a user can reserve a listing by checking if the user
  is in the blakcklist or has already made a reservation.
  */
  public func isUserValidReserver(user: PFUser) -> Bool {
    return reservations!.filter({ $0.reserver.objectId == user.objectId }).isEmpty && blackListedUsers!.filter({ $0.objectId == user.objectId }).isEmpty  }
  

  /**
  Checks the reservations array and returns a true boolean if any of the
  Methods meet the requirements for this listing
  
  :returns: Whether the listing is in a reserved state
  */
  func isReserved() -> Bool {
    


    if oBO {
      for res in reservations! {
        if res is UPMReservationObo && isBlackListed(res.getReserver()) && (res as! UPMReservationObo).offer >= limit {
          return true
        }
      }
    }
    return !reservations!.filter( { $0.status == UPMReservation.reservationStatus.Accepted.rawValue || $0.status == UPMReservation.reservationStatus.Waiting.rawValue }).isEmpty

  }
  
  /// checks if user is on black list
  /// @param reservr
  func isBlackListed(resevr: PFUser) -> Bool {
    return isItemInArray(blackListedUsers!, resevr)
  }
  
  /// Checks the reservations array and returns a  UPMUser if any of the
  /// Reservations meet the requirements for this listing.
  func currentReserver() -> PFUser?
  {
    if !isReserved()
    {
      return nil
    }
    var curUser: PFUser
    if oBO {
      var max = 0.0
      for res in reservations! {
        if res is UPMReservationObo && !isBlackListed(res.getReserver()) && (res as! UPMReservationObo).offer >= limit {
          if max < (res as! UPMReservationObo).offer {
            curUser = res.getReserver()
            max = (res as! UPMReservationObo).offer
          }
        }
      }
    }
      
    else{ //Not OBO
      var time: NSDate
      for res in reservations! {
        if !isBlackListed(res.getReserver()) {
          return res.getReserver()
        }
      }
    }
    return nil
  }
  
  // MARK: - Display 
  
  /**
  
  */
  class func displayQuery() -> PFQuery {
    var listingQuery = PFQuery(className: "UPMOtherListing")
    listingQuery.orderByDescending("createdAt")
    listingQuery.whereKey("isHidden", equalTo: NSNumber(bool: false))
    listingQuery.includeKey("blackListedUsers")
    listingQuery.includeKey(NSString(string: "reservations") as! String)
    listingQuery.includeKey("reservations.reserver")
    return listingQuery
  }
  
  /// Displays the price in human-readable form, e.g. $50.00
  func displayPrice() -> String {
    return String(format: "$%.2f", price)
  }
  
  /**
  Creates a string describing the status of a reservation.
  
  :returns: Reservation status of a listing.
  */
  public func displayReservationStatus() -> String {
    if reservations!.isEmpty {
      return "No Reservations"
    }
    if let firstReservation = reservations!.first {
      switch(UPMReservation.reservationStatus(rawValue: firstReservation.status)!) {
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

extension NSError {
  class func createError(localizedDescription: String, failureReason: String, suggestion: String) -> NSError {
    var userInfo = [NSLocalizedDescriptionKey: localizedDescription, NSLocalizedFailureReasonErrorKey: failureReason, NSLocalizedRecoverySuggestionErrorKey: suggestion]
    var error = NSError(domain: "UPM", code: -99, userInfo: userInfo)
    //var errorString = //error.userInfo?[NSString(string: "error")] as NSString
    return error
  }
}
