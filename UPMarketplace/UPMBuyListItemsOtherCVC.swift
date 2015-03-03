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
class UPMBuyListItemsOtherCVC: UPMBuyGridCVC {
  // TODO: Make Clear Button reset the query to original State
  // TODO: Fix Issue of not showing first cell
  
  // MARK: - Public Properites
  var atFilter = false
  var category: String?
  var subCategory: String?
  
  override func query() -> PFQuery {
    var listQuery = PFQuery(className: "UPMOtherListing")
    listQuery.orderByDescending("createdAt")
    return UPMOtherListing.displayQuery()
  }
  
  // MARK: - View Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView = collectionView;
    self.collectionView!.dataSource = self;
    self.collectionView!.delegate = self;

    
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
    if (!atFilter){
    
      self.revealViewController().navigationItem.title = "Filter"
      self.revealViewController().navigationItem.rightBarButtonItem?.title  = "Clear"
      self.revealViewController().navigationItem.hidesBackButton = true
      
      atFilter = true
      self.revealViewController().rightRevealToggle(self)
    }
    else if(atFilter){
      
      self.revealViewController().navigationItem.title = category
      self.revealViewController().navigationItem.rightBarButtonItem?.title  = "Filter"
      self.revealViewController().navigationItem.hidesBackButton = false
      atFilter = false
      
      self.revealViewController().pushFrontViewController(self, animated: true)
    }
  

  

  }
  

}