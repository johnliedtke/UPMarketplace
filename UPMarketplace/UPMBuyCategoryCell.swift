//
//  UPMBuyCategoryCell.swift
//  UPMarketplace
//
//  Created by Krismy on 1/15/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit


@IBDesignable
class UPMBuyCategoryCell: UICollectionViewCell {
    
    
    @IBOutlet weak var listingPicture: UIImageView!
    
    @IBOutlet weak var listingCategory: UILabel!
    
    
    var pic:UIImage? {
        didSet {
            listingPicture.image = pic
        }
    }
    
    
    var title: String? {
        didSet {
            listingCategory.text = title
        }
    }
  
  override func layoutSubviews() {
    super.layoutSubviews()
   
    contentView.clipsToBounds = true
    contentView.addSubview(listingPicture)
    contentView.addSubview(listingCategory)
    
    listingPicture.alpha = 0.67
    

    var elements: [NSObject : AnyObject] = ["listingPicture": listingPicture, "listingCategory": listingCategory]
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[listingPicture]|",
      options: .DirectionLeadingToTrailing,
      metrics: nil,
      views: elements))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-[listingCategory]-|",
      options: .DirectionLeadingToTrailing,
      metrics: nil,
      views: elements))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[listingPicture]|",
      options: .DirectionLeadingToTrailing,
      metrics: nil,
      views: elements))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-[listingCategory]-|",
      options: .DirectionLeadingToTrailing,
      metrics: nil,
      views: elements))


  }
  
}