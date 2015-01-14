//
//  UPMBuyGridCell.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/21/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit


/**
  Used to display UPMListings in UICollectionView. Specifically used with
  a UPMBuyGridCVC. The cell is linked to the UICollectionView found in
  UPMBuy.storyboard
*/
class UPMBuyGridCell: UICollectionViewCell {
  
  // MARK: - Public Properties
  
  /// Reference to the imageView at the top of the cell.
  @IBOutlet var listingImageView: PFImageView!
  
  /// Use to display the title of UPMListing
  @IBOutlet var titleLabel: UILabel!
  
  /// Use to display the price of a UPMListing
  @IBOutlet var priceLabel: UILabel!
  
  /// Use to display any details such as Reserve Now or OBO
  @IBOutlet var detailsLabel: UILabel!
  
  // MARK: - Private Properties
  
  /// Reference to the height of :listingImageView:
  @IBOutlet var imageViewHeight: NSLayoutConstraint!
  
  // MARK: - Public Methods
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    // Add a border
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0).CGColor
  
    // imageView is always 55% of the height of the cell.
    listingImageView.clipsToBounds = true
    imageViewHeight.constant = frame.height * 0.55;
  }
  
  /**
  Convience method to set the UI elements of the cell.
  
  :param: title What the :titleLabel: text should display.
  :param: price What the :priceLabel: text should display.
  :param: details What the :detailsLabel: text should display.
  */
  func configureCell(title: String, price: String, details: String) {
    titleLabel.text = title
    detailsLabel.text = details
    priceLabel.text = price
  }
    
}
