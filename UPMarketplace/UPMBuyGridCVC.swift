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
  listings in a grid format. It is a subclass of UPMPFObjectCVC. Aproximately 4.2 listings
  will be visible on the screen.To work property one should override the following methods:
    - query() to provide a specific query.
    - changeDefaults() If the default behavior of UPMPFObjectCVC should be changed.

*/
class UPMBuyGridCVC: UPMPFObjectCVC, UICollectionViewDelegateFlowLayout {

  // MARK: - Constants
  let ListingsPerPage = 24

  // MARK: - Public Methods
  
  /// Override to provide the UPMListing subclass name for a PFQuery
  func parseListingClassName() -> String {
    return ""
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    noDataMessage = "No listings available"
    
    
    collectionView?.backgroundColor = UIColor.standardBackgroundColor()
    // Register grid cell
    collectionView?.registerNib(UINib(nibName: UPMBuyGridCellConstants.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: UPMBuyGridCellConstants.reuseIdentifier)
  }
  
  /**
  If you want the default behavior of the UPMPFObjectCVC changed, it should
  be done in this method. It is automatically called in viewDidLoad().
  */
  override func changeDefaults() {
    objectsPerPage = UInt(ListingsPerPage)
  }
  
  /**
  The query for a UPMListings. Should be overriden to provide a customized
  PFQuery.
  */
  override func query() -> PFQuery {
    var listingQuery = PFQuery(className: parseListingClassName())
    listingQuery.orderByDescending("createdAt")
    return listingQuery
  }
  
  // MARK: - CollectionView Delegate
  
  /**
  Provide UPMPFObjectCVC with our custom UPMBuyCell. Images are automatically
  loaded asynchronously.
  */
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject) -> UICollectionViewCell {
    
    var cell: UPMBuyGridCell!
    
    if let newCell = collectionView.dequeueReusableCellWithReuseIdentifier(UPMBuyGridCellConstants.reuseIdentifier, forIndexPath: indexPath) as? UPMBuyGridCell {
      cell = newCell
    } else {
    cell = collectionView.dequeueReusableCellWithReuseIdentifier(UPMBuyGridCellConstants.reuseIdentifier, forIndexPath: indexPath) as UPMBuyGridCell
    }
    
    let listing = object as UPMListing
    
    // Grab the picture-file and retrieve it from parse
    var imageFile = listing.pictureThumbnail
    if let url = imageFile?.url {
      cell.listingImageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: nil, completed: { [unowned self, cell] (image, error, cache, url) in
      })
    }

    //TODO: Change details
    cell.configureCell(listing.title!, price: listing.displayPrice(), details: "Reserve Now")
    
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
    var TabBarHeight:CGFloat = (self.tabBarController?.tabBar.frame.height) ?? CGFloat(44)
    var NavBarHeight:CGFloat = (self.navigationController?.navigationBar.frame.height) ?? CGFloat(44)
    
    var height:CGFloat
    if ScreenWidth > 320 {
      height = (self.view.bounds.size.height - (Spacing + TabBarHeight + NavBarHeight)) / 2.15
    } else {
      height = (self.view.bounds.size.height - (Spacing + TabBarHeight + NavBarHeight)) / 2.0
    }
    
    return CGSizeMake(Width, height)
  }

  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
  }
  

}
