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
  
  @IBAction func a(sender: AnyObject) {
    self.revealViewController().rightRevealToggle(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    navigationController?.navigationBar.backItem.title = "Back!"
    navigationController?.navigationBar.backItem?.title = "Back"
    // Check if a user is logged in
    var revealViewController = self.revealViewController
    if (( revealViewController  != nil))
    {
      
      filterButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self.revealViewController(), action: "rightRevealToggle:")
      self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
      
      var swipeRight = UISwipeGestureRecognizer(target: self.revealViewController(), action: "rightRevealToggle:")
      swipeRight.direction = UISwipeGestureRecognizerDirection.Right
      self.view.addGestureRecognizer(swipeRight)
      
      var swipeLeft = UISwipeGestureRecognizer(target: self.revealViewController(), action: "rightRevealToggle:")
      swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
      self.view.addGestureRecognizer(swipeLeft)
    }
    

  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    UPMLoginVC.displayLoginInController(self)
  }
    
  
  override func changeDefaults() {
  }
  
  //TODO: Change query to retrieve the three major UPMListing types.
  override func query() -> PFQuery {
    return UPMOtherListing.displayQuery()
  }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath, withObject object: PFObject) -> Void {

    if(object.parseClassName == "UPMOtherListing"){
      var listing = object as! UPMOtherListing
      let viewController = UPMBuyItemDetailsOtherTVC()
      viewController.listingOther = listing
      navigationController?.pushViewController(viewController, animated: true)
    }
    
    
  }




    
}
