//
//  UPMBuyGridCVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/20/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

/**
The basic template for browsing UPMListing's in the marketplace. This controller displays 
listings in a grid format. Aproximately 4.2 listings will be visible on the screen.To work 
property one should override the following methods.
  - parseListingClassName()
  - query() if special query 

*/
class UPMBuyGridCVC: UPMPFObjectCVC {

  // MARK: - Constants
  let ListingsPerPage = 24
  let reuseIdentifier = "UPMBuyGridCell"

  // MARK: - Public Properties
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Public Methods
  /// Override to provide the UPMListing subclass name for a PFQuery
  func parseListingClassName() -> String {
    return ""
  }
  
  override func changeDefaults() {
    objectsPerPage = UInt(ListingsPerPage)
  }
  
  override func query() -> PFQuery {
    var listingQuery = PFQuery(className: parseListingClassName())
    listingQuery.orderByDescending("createdAt")
    return listingQuery
  }
  
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UPMBuyGridCell
    
    //var price = object["photo"] as Int
    let listing = object as UPMListing// *** Can't do this ***
    
    
    
    // Grab the picture-file and retrieve it from parse
    var picture = object["picture"] as? PFFile
    cell.listingImageView.file = listing.picture
    cell.listingImageView.loadInBackground()
    cell.configureCell(listing.title, price: listing.displayPrice(), details: "Reserve Now")
    
    return cell
  }
  
  
  /**
  Create the grid into an aproximately 2 x 2.1 format. Adustments are made based on the
  resolution of the screen. The cell height shrinks as the screen size grows.
   */
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    
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
