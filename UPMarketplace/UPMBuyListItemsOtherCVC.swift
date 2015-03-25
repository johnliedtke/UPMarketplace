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
  var filter: OtherFilter<String> = OtherFilter(category: nil, tags: [String](), condition: "", price: 0)
  
  override func query() -> PFQuery {
    var query = UPMOtherListing.displayQuery()
    if let category = filter.category {
      query.whereKey("category", equalTo: category)
      if let tags = filter.tags where !tags.isEmpty {
        query.whereKey("tag", containedIn: tags)
      }
    }
    return query
  }
  
  // MARK: - View Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Add filter button
   var filterButton = UIBarButtonItem(title: "Filter", style: .Plain, target: self, action:Selector("goToRear"))
    revealViewController().navigationItem.rightBarButtonItem = filterButton
    revealViewController().navigationItem.title = "Furniture & Other Listings"

  }
  
  func didFinishFiltering(sender: UPMCategoryFilterMainTVC, filter: Filter) {
    self.revealViewController().pushFrontViewController(self, animated: true)
    revealViewController().navigationController?.navigationBar.hidden = false
    collectionView?.userInteractionEnabled = true
    self.filter = filter as? OtherFilter ?? self.filter
    refresh()
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
    if let nav = revealViewController().rightViewController as? UINavigationController {
      if let otherFilterVC = nav.viewControllers[0] as? UPMCategoryFilterMainTVC {
        println("Successful meow")
      }
    }
    revealViewController().rightRevealToggle(self)
    revealViewController().navigationController?.navigationBar.hidden = true
    collectionView?.userInteractionEnabled = false
  }
  

}