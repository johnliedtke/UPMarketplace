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
  
  
  var chosenCategory = "UPMOtherListing"

  
  //TODO: Change query to retrieve the three major UPMListing types.
  override func query() -> PFQuery {
    var listQuery = PFQuery(className: "UPMOtherListing")
    listQuery.orderByDescending("createdAt")
    return listQuery
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView = collectionView;
    self.collectionView!.dataSource = self;
    self.collectionView!.delegate = self;
  }
  
  
  /**
  Provide UPMPFObjectCVC with our custom UPMBuyCell. Images are automatically
  loaded asynchronously.
  */
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(UPMBuyGridCellConstants.reuseIdentifier, forIndexPath: indexPath) as! UPMBuyGridCell
    
    let listing = object as! UPMListing
    
    // Grab the picture-file and retrieve it from parse
    var picture = object["picture"] as? PFFile
    
    if let thumbnail = object["pictureThumbnail"] as? PFFile {
      cell.listingImageView.file = thumbnail
      cell.listingImageView.loadInBackground()
    } else {
      cell.listingImageView.file = listing.picture
      cell.listingImageView.loadInBackground()
    }
    
    
    
    //TODO: Change details
    cell.configureCell(listing.title, price: listing.displayPrice(), details: "Reserve Now")
    
    return cell
  }
  
  
  /**
  Create the grid into an aproximately 2 x 2.1 format. Adustments are made based on the
  resolution of the screen. The cell height shrinks as the screen size grows.
  */
  override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    
    // Left + Right + In Between
    let Spacing:CGFloat = 30.0
    
    // Calculate Width
    let ScreenWidth = UIScreen.mainScreen().bounds.size.width
    let Width:CGFloat = (ScreenWidth - Spacing) / 2.0
    
    // Calculate Height
    var TabBarHeight:CGFloat = (self.tabBarController?.tabBar.frame.height)!
    var NavBarHeight:CGFloat = (self.navigationController?.navigationBar.frame.height)!
    
    var height:CGFloat
    if ScreenWidth > 320 {
      height = (self.view.bounds.size.height - (Spacing + TabBarHeight + NavBarHeight)) / 2.15
    } else {
      height = (self.view.bounds.size.height - (Spacing + TabBarHeight + NavBarHeight)) / 2.0
    }
    
    return CGSizeMake(Width, height)
  }

    
}