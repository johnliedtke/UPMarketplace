//
//  UPMAccountActivityCell.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/31/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit
class UPMAccountActivityCell: PFTableViewCell {
  
  lazy var messageLabel: UILabel = {
    var label = UILabel()
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(label)
    label.font = UIFont.systemFontOfSize(14.0)
    label.numberOfLines = 0
    return label
    }()
  
  lazy var iconImageView: UIImageView = {
    var iv = UIImageView()
    iv.setTranslatesAutoresizingMaskIntoConstraints(false)
    iv.backgroundColor = UIColor.purpleColor()
    self.contentView.addSubview(iv)
    return iv
    }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    // Elements dictionary, holds all subviews
    var ed = NSDictionary(dictionary: ["messageLabel": messageLabel, "iconImageView": iconImageView])
    
    // Layout
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-[iconImageView(50)]-[messageLabel]-(>=8)-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-[iconImageView(50)]-(>=8)-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-[messageLabel]-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}