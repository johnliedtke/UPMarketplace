//
//  UPMBuyGridCell.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/21/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit


class UPMBuyGridCell: UICollectionViewCell {

  // MARK: - Public Properties
  @IBOutlet var listingImageView: PFImageView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var priceLabel: UILabel!
  @IBOutlet var detailsLabel: UILabel!
  
  
  // MARK: - Public Methods
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0).CGColor
  }
  
  
  func configureCell(title: String, price: String, details: String) {
    titleLabel.text = title
    detailsLabel.text = details
    priceLabel.text = price
  }
    
}
