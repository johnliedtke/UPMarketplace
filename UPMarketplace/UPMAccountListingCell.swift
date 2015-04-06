//
//  UPMAccountListingCell.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/31/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

public class UPMAccountListingCell: PFTableViewCell {
  
  // MARK: - Public Properties
  
  lazy var titleLabel: UILabel = {
    var label = UILabelVertical()
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(label)
    label.numberOfLines = 0
    label.font = UIFont.systemFontOfSize(16.0)
    //label.backgroundColor = UIColor.flatLightOrangeColor()
    
    return label
  }()
  
  lazy var statusLabel: UILabel = {
    var label = UILabelVertical()
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(label)
    label.numberOfLines = 0
    label.font = UIFont.boldSystemFontOfSize(14.0)
    label.textColor = UIColor.flatDarkGreenColor()

    return label
  }()
  
  lazy var priceLabel: UILabel = {
    var label = UILabel()
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(label)
    label.numberOfLines = 0
    label.textAlignment = .Right
    label.font = UIFont.standardBolTextFont()
    return label
  }()
  
  lazy var displayImageView: UIImageView = {
    var iv = UIImageView()
    iv.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(iv)
    iv.backgroundColor = UIColor.flatLightPurpleColor()
    return iv
  }()
  
  
  // MARK: - Pubic Methods
  
  /**
  Initializes the layout of the cell.
  */
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    // Should adjust according to screen size
    let imageHeight = 60.0
    let imageWidth = 60.0
    let bottomMargin = 8.0
    
    // View dictionary
    var ed: [NSObject : AnyObject] = ["titleLabel": titleLabel, "statusLabel": statusLabel, "displayImageView": displayImageView, "priceLabel": priceLabel]
    
    
    // Horizontal layout
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-[displayImageView(\(imageHeight))]-[titleLabel]-|",
      options: .DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-[displayImageView]-[statusLabel]-[priceLabel]-|",
      options: .DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
    // Vertical layout
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-[displayImageView(\(imageHeight))]-(>=8)-|",
      options: .DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-[titleLabel]-[statusLabel]-|",
      options: .DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-[titleLabel]-[priceLabel]-|",
      options: .DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
  }
  
  /**
  Changes the color of the statusLabel corresponding to a reservation status.

  :param: status Status of a UPMListing
  */
  internal func changeStatusColor(status: ReservationStatus) {
    switch status {
    case .Accepted:
      statusLabel.textColor = UIColor.flatDarkGreenColor()
    case .Waiting:
      statusLabel.textColor = UIColor.flatLightOrangeColor()
    case .NoReservations:
      statusLabel.textColor = UIColor.flatLightRedColor()
    default:
      statusLabel.textColor = UIColor.flatLightBlueColor()
    }
  }
  
  // MARK: Private Methods

  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
}
