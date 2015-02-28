//
//  UPMBuyCategoryCell.swift
//  UPMarketplace
//
//  Created by Krismy on 1/15/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit


struct UPMBuyCategoryCellConstants {
  static let reuseIdentifier = "UPMBuyCategoryCell"
}

@IBDesignable
class UPMBuyCategoryCell: UICollectionViewCell {
    
    
  // MARK: - Public Properties
  
  /// Reference to the imageView at the top of the cell.
  lazy var listingPicture: PFImageView = {
    var imageView = PFImageView()
    imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
    imageView.clipsToBounds = true
    imageView.contentMode = .ScaleAspectFill
    return imageView
    }()
  
  /// Use to display the title of UPMListing
  lazy var listingCategory: UILabel =  {
    var label = UILabelVertical(forAutoLayout: true)
    label.font = UIFont.standardBoldTitleFont()
    label.text = "Title"
    
    label.numberOfLines = 0
    return label
    }()
    
    
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