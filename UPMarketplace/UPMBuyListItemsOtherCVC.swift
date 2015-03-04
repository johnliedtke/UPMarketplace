//
//  UPMBuyListItemsOtherCVC.swift
//  UPMarketplace
//
//  Created by Krismy on 1/19/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit
/**
Displays all UPMOtherListings in a grid format.
*/
class UPMBuyListItemsOtherCVC: UPMBuyGridCVC, UPMFilterDelegate {
  // TODO: Make Clear Button reset the query to original State
  // TODO: Fix Issue of not showing first cell
  
  // MARK: - Public Properites
  var atFilter = false
  var category: String?
  var subCategory: String?
  
  override func query() -> PFQuery {
    return UPMOtherListing.displayQuery()
  }
  
  // MARK: - View Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Add filter button
   // var filterButton = UIBarButtonItem(title: "Filter", style: .Plain, target: self, action:Selector("goToRear"))
   // revealViewController().navigationItem.rightBarButtonItem = filterButton
    revealViewController().navigationItem.title = "Furniture & Other Listings"
    
   

    
  }


  
  
  func didFinishFiltering(sender: UPMCategoryFilterMainTVC, category: String) {
    self.revealViewController().pushFrontViewController(self, animated: true)
    revealViewController().navigationController?.navigationBar.hidden = false
    collectionView?.userInteractionEnabled = true
  }
  
  // MARK: - Data Source Methods
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath, withObject object: PFObject) -> Void {
      var listing = object as! UPMOtherListing
      let viewController = UPMBuyItemDetailsOtherTVC()
      viewController.listingOther = listing
      navigationController?.pushViewController(viewController, animated: true)
  }
  
  // MARK: - Button Action
  func goToRear(){
    
    //depending on whether we are showing the filter tableview change the behavior of
    //button and the navigation bar
    revealViewController().rightRevealToggle(self)
    revealViewController().navigationController?.navigationBar.hidden = true
    collectionView?.userInteractionEnabled = false
  }
  

}