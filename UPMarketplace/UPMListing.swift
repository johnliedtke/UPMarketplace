//
//  UPMListing.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/8/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

/**
  Abstract[ISH] class that provides the base for all
  marketplace listings. Must be subclassed. Steps to properly subclass:

  1. Adopt the PFSubclassing protocol
  2. Fullfill required methods parseClassName()
  3. Register subclass with Parse by overridng load() and calling
  self.registerSubclass()
*/
public class UPMListing: PFObject  {
  
  // MARK: - Properties
  
  /// Title of the listing
  @NSManaged public var title: String?
  
  /// User-description of listing
  @NSManaged public var descriptionS: String?
  
  /// Price of listing
  @NSManaged public var price: Double
  
  /// Indicator for Or Best Offer (OBO)
  @NSManaged public var oBO: ObjCBool
  
  /**
  Auto-reject limit for OBO
    1. Check oBO before using
  */
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
  
  /// Atomic key for handling reservation race conditions
  @NSManaged var atomicCount: Int
  
  // TODO: Add reservations array after class has been implemented - (WHAT IS THIS)
  
  /// Returns the image for a listing
  var photo: UIImage?
  
  /**
  MARK: - (E) Seller Actions
  Actions the seller can perform depending on the state of the listing.
  */
  enum SellerAction: Int, Printable {
    case AcceptReservation, ContactReserver, DeleteListing, RejectReservation
    var description: String {
      get {
        switch self {
        case .AcceptReservation:
          return "Accept"
        case .ContactReserver:
          return "Contact"
        case .DeleteListing:
          return "Delete"
        case .RejectReservation:
          return "Reject"
        }
      }
    } // end description
  }
  
  /**
  MARK: - (E) Seller Listing State
  State of the listing in regards to the seller
  */
  enum SellerState: Int, Printable {
    case Accepted, Waiting, NoAction
    var description : String {
      get {
        switch self {
        case .Accepted: // Seller has accepted a reservation
          return "Accepted"
        case .Waiting: // Waiting for reservations
          return "Waiting"
        case .NoAction:
          return "No Reservations"
        }
      }
    } // end description
  }

  
  // MARK: - Public Methods
  
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
    
    
    
    
    if self.isReserved() {
      // Listing is already reserved
      var error = NSError.createError("Listing is already reserved.",
        failureReason: "Another user has a valid reservation.",
        suggestion: "Wait")
      return BFTask(error: error)
      
    } else if self.owner == reserver {
      var error = NSError.createError("You cannot reserve your own listing",
        failureReason: "Listing owned by self.",
        suggestion: "Don't reserve own listing.")
      return BFTask(error: error)
    }
    
    let savedAtomicCount = atomicCount
    self.incrementKey("atomicCount")
    
    
    self.saveInBackground().continueWithBlock { (task) in
      print(self.atomicCount)
      
      if self.atomicCount - 1 != savedAtomicCount {
        println("Someone reserved while looking at listing.")
        self.isHidden = true
        return BFTask(error: NSError.createError("The listing has been already been reserved.", failureReason: "", suggestion: ""))
      } else {
        return PFObject.fetchAllInBackground(self.reservations)
      }
      
      }.continueWithBlock {
      [unowned self] (task: BFTask!) in
      
      if let res = task.result as? [UPMReservation] {
        println(res.count)
      }
      
      var error: NSError!
      var inThere = false
      for r in self.reservations {
        if reserver.objectId == r.reserver.objectId {
          println("in there")
          inThere = true
        }
      }
      
     // let filter = !self.reservations!.filter({ $0.reserver.objectId == reserver.objectId }).isEmpty

      if inThere {
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
        
      } else if self.owner == reserver {
        error = NSError.createError("You cannot reserve your own listing",
          failureReason: "Listing owned by self.",
          suggestion: "Don't reserve own listing.")
          return BFTask(error: error)
      
      } else {
        // Add user to reservations and hide the listing
        self.addObject(reservation, forKey: "reservations")
        self.isHidden = true
        return self.saveInBackground()
      }
      
      }.continueWithSuccessBlock {
        [unowned self] (task: BFTask!) -> AnyObject! in
        
        if let result = task.result as? UPMListing {
        }
        // Add activity for seller and buyer
        let title = self.title ?? ""
        let buyerActivity = UPMActivity(title: "Made Reservation:", description: "\(title)", user: reserver)
        return buyerActivity.saveInBackground()

      }.continueWithSuccessBlock { (task) in
        
        let subject = "UP-Market: Reserveration Made - \(self.title!)"
        
        let message = "\(reserver.fullNameOfUser()) reserved your listing: \(self.title!). \n\nLog into UP Market->Account to accept or reject the reservation."
        + "\n\n" + Constants.Email.kNotificationFooter
        
        return PFCloudExt.sendEmailTo(self.owner, from: reserver, subject: subject, body: message, notification: true)
        
      }.continueWithBlock { (task: BFTask!) -> AnyObject! in
        
        if task.error == nil {
    
          println(self.reservationCount().waiting)
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
    
    reservation.deleteInBackground().continueWithBlock { (task: BFTask!) in
      return self.saveInBackground()
      
    }.continueWithSuccessBlock { (task) in
      
      // No need to notify seller that a "rejected" reservation was deleted
      if reservation.status == ReservationStatus.Rejected.rawValue {
        return task
      } else {
        let subject = "UP-Market - User Deleted Reservation: \(self.title!)"
        
        let message = "\(reservation.reserver.fullNameOfUser()) deleted the reservation for your listing: \(self.title!)."
        + "\n\n Your listing has been placed back on the market."
        + "\n\n" + Constants.Email.kNotificationFooter
        
        return PFCloudExt.sendEmailTo(self.owner, from: nil, subject: subject, body: message, notification: true)
      }
      
    }.continueWithSuccessBlock { (task) in
      let deleteActivity = UPMActivity.activityWithTitle("Deleted Reservation", description: self.title!, user: PFUser.currentUser()!)
      return deleteActivity.saveInBackground()
      
    }.continueWithBlock { (task: BFTask!) in
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
  Reservation state is changed to rejected asynchronously. Listing is put 
  back on the marketplace. (isHidden = true)
  
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
    
    reservation.status = ReservationStatus.Rejected.rawValue
    isHidden = false
    
    let reserver = reservation.reserver
    
    saveInBackground().continueWithSuccessBlock {
      (task: BFTask!) in
        let subject = "UP-Market: Seller Rejected Reservation - \(self.title!)"
        
        let message = "Your reservation has been rejected for listing: \(self.title!)."
          + "\n\n" + Constants.Email.kNotificationFooter
        
        return PFCloudExt.sendEmailTo(reservation.reserver, from: nil, subject: subject, body: message, notification: true)
      
    }.continueWithSuccessBlock {
      [unowned self] (task) in
      
      let rejectReserverActivity = UPMActivity.activityWithTitle("Reservation Rejected", description: "Seller rejected \(self.title!)", user: reserver)
      let rejectSellerActivity = UPMActivity.activityWithTitle("Rejected Reservation", description: "\(self.title!)", user: self.owner)
      
      return PFObject.saveAllInBackground([rejectReserverActivity, rejectSellerActivity])
      
    }.continueWithBlock {
      (task) in
      
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
  Reject the reservation that the seller is acting upon. Rejects the accepting 
  reservation if it exists then the waitng reservation.
  
  //TODO: Deprecate
  
  :param: blackList Should reserver be blackListed
  */
  func rejectCurrentReservationInBackground(#blackList: Bool) -> BFTask {
    
    var rejectTask = BFTaskCompletionSource()
    
    func reject(reservation: UPMReservation) {
      if blackList {
        self.addObject(reservation.reserver, forKey: "blackListedUsers")
      }
      
      reservation.status = ReservationStatus.Rejected.rawValue
      self.isHidden = false
      
      self.saveInBackground().continueWithBlock {
        (task: BFTask!) -> AnyObject! in
        if task.error == nil {
          rejectTask.setResult(nil)
        } else {
          rejectTask.setError(task.error)
        }
        return nil
      }
    } // end reject
    
    if let acceptingReservation = getAcceptedReservation() {
      reject(acceptingReservation)
    } else if let waitingReservation = getWaitingReservation() {
      reject(waitingReservation)
    }
    
    return rejectTask.task
  }

  /**
  Deletes the listing and related data asynchronously.
  
  //TODO: Notify potential reservers of deletion.
  //TODO: Add activty...
  
  */
  func deleteListingAndRelatedInBackground() -> BFTask {
    var deleteTask = BFTaskCompletionSource()
    
    var currentReserver: PFUser!
    if let currentReservation = getCurrentReservation() {
      currentReserver = currentReservation.getReserver()
    }
    
    PFObject.deleteAllInBackground(reservations).continueWithBlock { (task) in
      return self.deleteInBackground()
      
    }.continueWithSuccessBlock { (task) in
     
      let sellerActivity = UPMActivity.activityWithTitle("Deleted Listing", description: self.title!, user: self.owner, action: .ListingDeleted)
      var activities = [sellerActivity]
      
      if currentReserver != nil {
        activities.append(UPMActivity.activityWithTitle("Seller Deleted Listing", description: self.title!, user: currentReserver!, action: .ListingDeleted))
      }
      
      return PFObject.saveAllInBackground(activities)
      
    }.continueWithBlock {
      (task) in
      
      if task.error == nil {
        deleteTask.setResult(true)
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
  //TODO: Potentially put in reservation class? meh
  
  :param: reservation Reservation to accept
  */
  func acceptReservationInBackground(reservation: UPMReservation) -> BFTask {
    var acceptTask = BFTaskCompletionSource()
    
    let reserver = getWaitingReservation()!.getReserver()
    reservation.status = ReservationStatus.Accepted.rawValue
    
    let subject = "UP-Market: Reservation Accepted - \(self.title!)"
    let body = "\(self.owner.fullNameOfUser()) accepted your reservation for \"\(self.title!)\".\n\nContact email: \(self.owner.email!)"
    
    let email: [String: String] = ["to": reserver.email!, "from": self.owner.email!, "subject": subject, "message": body]
    
    reservation.saveInBackground().continueWithSuccessBlock() { (task) in
      
      return PFCloudExt.callFunctionAsync(PFCloudExtConstants.sendEmailFunction, withParameters: email)
      
    }.continueWithSuccessBlock { (task) in
      
      
      let reserverActivity = UPMActivity.activityWithTitle("Reservation Accepted", description: self.title!, user: reserver, action: .ReservationAccepted)
      let sellerActivity = UPMActivity.activityWithTitle("Accept Reservation", description: self.title!, user: self.owner, action: .ReservationAccepted)
      
      return PFObject.saveAllInBackground([sellerActivity, reserverActivity])

    }.continueWithBlock { (task) in
      if let error = task.error {
        acceptTask.setError(error)
      } else {
        acceptTask.setResult(task.result)
      }
      return nil
    }
    return acceptTask.task
  }
  
  /**
  Complete the transaction gracefully and asynchronously!
  
  //TODO: Implement
  
  */
  func completeTransactionInBackground() {
    
  }
  
  /**
  Retrieves all reservations associated with listing.
  */
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
  Determines the available actions a seller can take based upon the state of 
  the listing.
    
    * Most of the actions (functions) are asynchronous and thus are wrapped in
      in a closure to avoid firing off network requests.
  
  :returns: SellerAction and a reference to the action.
  */
  internal func availableSellerActions() -> [(SellerAction, () -> BFTask)]? {
    
    // Helper closure to create contact action
    let contactActionMeow: (PFUser) -> BFTask = { (user: PFUser) in
      var contactTask = BFTaskCompletionSource()
      contactTask.setResult(UPMContactVC.initWithNavigationController(user, withSubject: "Message about \(self.title)"))
      return contactTask.task
    }
    
    var deleteTask = { return self.deleteListingAndRelatedInBackground() }
    var deleteAction = (SellerAction.DeleteListing, deleteTask)
   

    // Create the various "actions" based on the state of the listing.
    switch sellerState() {
    case .NoAction:
      
      return [deleteAction]
      
    case .Waiting:
      if let waitingReservation = getWaitingReservation() {
        var acceptAction = (SellerAction.AcceptReservation,
          { return self.acceptReservationInBackground(waitingReservation) })
        var rejectAction = (SellerAction.RejectReservation,
          { return self.rejectReservationInBackground(waitingReservation, blackList: false) })
        var contactAction = (SellerAction.ContactReserver, { return contactActionMeow(waitingReservation.reserver) })
        
        return [rejectAction, acceptAction]
      }
      
    case .Accepted:
      if let acceptedReservation = getAcceptedReservation() {
        var contactAction = (SellerAction.ContactReserver, { return contactActionMeow(acceptedReservation.reserver) })
        var rejectAction = (SellerAction.RejectReservation,
          { return self.rejectReservationInBackground(self.getAcceptedReservation()!, blackList: false) })
        
        return [contactAction, rejectAction]
      }
      
    default: break
    }
    return nil
  }
  
  
  /**
  Determines the available actions a buyer can take based upon the state of
  the listing.
  
  - Most of the actions (functions) are asynchronous and thus are wrapped in
  in a closure to avoid firing off network requests.
  
  :returns: BuyerAction and a reference to the action.
  */
  internal func availableBuyerActions() -> [(SellerAction, () -> BFTask)]? {
    return nil
  }
  
  /**
  Determines the state of the listing
  
  :returns: State of the listing
  */
  func sellerState() -> SellerState {
    if !isReserved() { // No reservations or rejected
      return .NoAction
    }
  
    if !reservations.filter({ $0.status == ReservationStatus.Accepted.rawValue }).isEmpty {
      return .Accepted
    } else {
      return .Waiting
    }
  }
  
  /**
  Returns the reservation that is waiting for action by the seller.
    
  :returns: First reservation waiting for action
  */
  public func getWaitingReservation() -> UPMReservation? {
    return reservations.filter({ $0.status == ReservationStatus.Waiting.rawValue}).first
  }
  
  /**
  Returns the reservation that is waiting for action by the seller.
  
  :returns: Returns the first accepted reservation
  */
  public func getAcceptedReservation() -> UPMReservation? {
    return reservations.filter({ $0.status == ReservationStatus.Accepted.rawValue}).first
  }
  
  /**
  Returns the current reservation which can be accepted reservation, waiting reservation, or
  nil.
  
  :returns: Reservation or nil
  */
  public func getCurrentReservation() -> UPMReservation? {
    return getAcceptedReservation() ?? getWaitingReservation() ?? nil
  }

  /**
  Checks if there is a reservation that has been accepted.
  
  :returns: Whether there is an accepted reservation
  */
  func isAcceptedReservation() -> Bool {
    return !reservations.filter() { $0.status == ReservationStatus.Accepted.rawValue }.isEmpty
  }
  
  /**
  Checks whether a listing is reserveable by fetching the latest data from
  parse.
  //TODO: DELETE?
  */
  public func isReseveableInBackground() -> BFTask {
    var reserveableTask = BFTaskCompletionSource()

    fetchInBackground().continueWithBlock { (task: BFTask!) -> AnyObject! in
      if task.error == nil {
        reserveableTask.setResult(self.isUserValidReserver(PFUser.currentUser()!))
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
    reservableTask.setResult(self.isUserValidReserver(PFUser.currentUser()!))
    return reservableTask.task
  }

  /**
  Determines whether a user can reserve a listing by checking if the user
  is in the blakcklist or has already made a reservation.
  */
  public func isUserValidReserver(user: PFUser) -> Bool {
    let isInReservations = reservations!.filter({ $0.reserver.objectId == user.objectId }).isEmpty // breaks compiler is one liner
    let isInBlackList = blackListedUsers!.filter({ $0.objectId == user.objectId }).isEmpty
    return isInReservations && isInBlackList
  }
  
  /**
  Returns a treble describing the count of the reservations statuses.

  */
  internal func reservationCount() -> (accepted: Int, waiting: Int, rejected: Int) {
    var accepted = reservations.filter({ $0.status == ReservationStatus.Accepted.rawValue }).count
    var waiting = reservations.filter({ $0.status == ReservationStatus.Waiting.rawValue }).count
    var rejected = reservations.filter({ $0.status == ReservationStatus.Rejected.rawValue }).count
    
    return (accepted, waiting, rejected)
  }
  
  /**
  */
  internal func sellerReservationStatus() -> ReservationStatus  {
    if reservationCount().accepted > 0 {
      return .Accepted
    } else if reservationCount().waiting > 0  {
      return .Waiting
    } else {
      return .NoReservations
    }
  }

  /**
  Checks the reservations array and returns a true boolean if any of the
  Methods meet the requirements for this listing
  
  :returns: Whether the listing is in a reserved state
  */
  func isReserved() -> Bool {
    if isHidden { return true }
    
    if oBO {
      for res in reservations! {
        if res is UPMReservationObo && isBlackListed(res.getReserver()) && (res as! UPMReservationObo).offer >= limit {
          return true
        }
      }
    }
    return !reservations!.filter( { $0.status == ReservationStatus.Accepted.rawValue || $0.status == ReservationStatus.Waiting.rawValue }).isEmpty
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
    else { //Not OBO
      var time: NSDate
      for res in reservations! {
        if !isBlackListed(res.getReserver()) {
          return res.getReserver()
        }
      }
    }
    return nil
  }
  
  deinit {
    println("Listing deallocated")
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
