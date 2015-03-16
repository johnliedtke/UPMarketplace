//
//  UPMBuyNewListingsGridCVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/21/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

/**
  The UPMBuyNewListingsGridCVC displays the most recent UPMListings that have
  been posted in the marketplace. These include UPMTextbookListing, UPMOtherListing,
  and UPMHousingListing.
*/
class UPMBuyNewListingsGridCVC: UPMBuyGridCVC {
  
  @IBOutlet var filterButton: UIBarButtonItem!
  
  //MARK: - Button Action
  @IBAction func a(sender: AnyObject) {
    self.revealViewController().rightRevealToggle(self)
  }
  
   // MARK: - Public Properties
  var chosenCategory: Int = -1 //this is the default value which is used to determine query performed
  var titleTop = "New Listings" //title displayed in the navigation bar
  
  
  // MARK: - View Methods
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.navigationBar.backItem?.title = "Back"
    self.title = titleTop
    
    self.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Barcdoe", style: .Done, target: self, action: "pushBarcode")
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Barcode", style: UIBarButtonItemStyle.Done, target: self, action: "pushBarcode")
    
    // reveal controller
    var revealViewController = self.revealViewController
    if (( revealViewController  != nil))
    {
     //allow swipe gestures to be used to also trigger the filter categories to come into view
      var swipeRight = UISwipeGestureRecognizer(target: self.revealViewController(), action: "rightRevealToggle:")
      swipeRight.direction = UISwipeGestureRecognizerDirection.Right
      self.view.addGestureRecognizer(swipeRight)
      
      var swipeLeft = UISwipeGestureRecognizer(target: self.revealViewController(), action: "rightRevealToggle:")
      swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
      self.view.addGestureRecognizer(swipeLeft)
    }

  }
  
  func pushBarcode() {
    let singleinput = UPMSellTextbookRequiredDeatils()
    singleinput.dataCollectedHandler = {
      [unowned self] (bookDetails) in
      let isbn = bookDetails["ISBN"]
      println(isbn!)
      
    }

    self.navigationController?.pushViewController(singleinput, animated: true)
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    UPMLoginVC.displayLoginInController(self)
  }
    
  // MARK: - Override methods
  override func changeDefaults() {
  }
  
  //TODO: Change query to retrieve the three major UPMListing types.
  override func queries() -> [PFQuery]? {
    
    switch(chosenCategory){
    case 0:
      var listQuery = PFQuery(className: "UPMOtherListing")
      listQuery.orderByDescending("createdAt")
      return [UPMOtherListing.displayQuery()]
    case 1:
      var listQuery = PFQuery(className: "UPMHousingListing")
      listQuery.orderByDescending("createdAt")
      return [listQuery]
    case 2:
      var listQuery = PFQuery(className: "UPMTextbookListing")
        return [UPMTextbookListing.displayQuery()]
    default:
      var listQuery = PFQuery(className: "UPMHousingListing")
      listQuery.orderByDescending("createdAt")
      return [UPMOtherListing.displayQuery(), UPMTextbookListing.displayQuery()]
    }
    
  }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath, withObject object: PFObject) -> Void {

    if(object.parseClassName == "UPMOtherListing"){
      var listing = object as! UPMOtherListing
      let viewController = UPMBuyItemDetailsOtherTVC()
      viewController.listingOther = listing
      navigationController?.pushViewController(viewController, animated: true)
    }
    else if(object.parseClassName == "UPMTextbookListing"){
      var listing = object as! UPMTextbookListing
      let viewController = UPMBuyItemDetailsTextbookTVC()
      viewController.listingTextbook = listing
      navigationController?.pushViewController(viewController, animated: true)

    }

  }
  
    
}
