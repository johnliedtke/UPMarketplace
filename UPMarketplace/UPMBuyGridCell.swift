//
//  UPMBuyGridCell.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/21/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

struct UPMBuyGridCellConstants {
  static let reuseIdentifier = "UPMBuyGridCell"
}

/**
  Used to display UPMListings in UICollectionView. Specifically used with
  a UPMBuyGridCVC. The cell is linked to the UPMBuyGrideCell.xib
*/
class UPMBuyGridCell: UICollectionViewCell {
  
  // MARK: - Public Properties
  
  /// Reference to the imageView at the top of the cell.
  lazy var listingImageView: UIImageView = { [unowned self] in 
    var imageView = UIImageView()
    imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
    imageView.clipsToBounds = true
    imageView.contentMode = .ScaleAspectFill
    return imageView
  }()
  
  /// Use to display the title of UPMListing
  lazy var titleLabel: UILabel =  {
    var label = UILabelVertical(forAutoLayout: true)
    label.font = UIFont.standardTextFont()
    label.text = "Title"
    label.numberOfLines = 0
    return label
  }()
  
  /// Use to display the price of a UPMListing
  lazy var priceLabel: UILabel = {
    var label = UILabel(forAutoLayout: true)
    label.font = UIFont.standardBoldHeaderTwoFont()
    label.textAlignment = .Right
    return label
  }()
  
  /// Use to display any details such as Reserve Now or OBO
  lazy var detailsLabel: UILabel = {
    var label = UILabel(forAutoLayout: true)
    label.font = UIFont.standardTextFont()
    label.textAlignment = .Right
    return label
    }()
  
  // MARK: - Public Methods
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  /**
  Initializes the layout of the cell.
  */
  func setup() {
    contentView.addSubview(listingImageView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(priceLabel)
    contentView.addSubview(detailsLabel)
    
    var elements: [NSObject : AnyObject] = ["listingImageView": listingImageView, "titleLabel": titleLabel,
      "priceLabel": priceLabel, "detailsLabel": detailsLabel]
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[listingImageView]|",
      options: .DirectionLeadingToTrailing,
      metrics: nil,
      views: elements))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-[titleLabel]-|",
      options: .DirectionLeadingToTrailing,
      metrics: nil,
      views: elements))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-[priceLabel]-|",
      options: .DirectionLeadingToTrailing,
      metrics: nil,
      views: elements))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-[detailsLabel]-|",
      options: .DirectionLeadingToTrailing,
      metrics: nil,
      views: elements))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[listingImageView]-[titleLabel]-(>=8)-[priceLabel][detailsLabel]-|",
      options: .DirectionLeadingToTrailing,
      metrics: nil,
      views: elements))
    
    priceLabel.setContentCompressionResistancePriority(900, forAxis: UILayoutConstraintAxis.Vertical)
    detailsLabel.setContentCompressionResistancePriority(900, forAxis: UILayoutConstraintAxis.Vertical)
    titleLabel.setContentCompressionResistancePriority(400, forAxis: UILayoutConstraintAxis.Vertical)
    
    contentView.addConstraint(NSLayoutConstraint(item: listingImageView, attribute: .Height, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 0.55, constant: 0))
    
    // Add a border
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0).CGColor
    
  }

  deinit {
    println("deallocating")
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
