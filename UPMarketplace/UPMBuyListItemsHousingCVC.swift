//
//  UPMBuyListItemsHousingCVC.swift
//  UPMarketplace
//
//  Created by Krismy on 2/4/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit



class UPMBuyListItemsHousingCVC: UPMBuyGridCVC {
  // TODO: Make Clear Button reset the query to original State
  // TODO: Fix Issue of not showing first cell
  
  // MARK: - Public Properites
  var atFilter = false
  var category: String?
  
  override func query() -> PFQuery {
    var listQuery = PFQuery(className: "UPMHousingListing")
    listQuery.orderByDescending("createdAt")
    return listQuery
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
    
    var listing = object as! UPMHousingListing
    let viewController = UPMBuyItemDetailsHousingTVC()
    viewController.listingHousing = listing
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
    }
    else if(atFilter){
      
      self.revealViewController().navigationItem.title = category
      self.revealViewController().navigationItem.rightBarButtonItem?.title  = "Filter"
      self.revealViewController().navigationItem.hidesBackButton = false
      atFilter = false
    }
    self.revealViewController().rightRevealToggle(self)
    
  }
}
