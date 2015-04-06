//
//  UPMAccountActivityCell.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/31/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

extension UPMAccountActivityCell {
  func configureCellForActivity(#activity: UPMActivity) {
    titleLabel.text = activity.title
    messageLabel.text = activity.activityDescription
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.setLocalizedDateFormatFromTemplate("EEE, MMM d, hh:mma")
    dateLabel.text = dateFormatter.stringFromDate(activity.date)

    }
}

class UPMAccountActivityCell: PFTableViewCell {
  
  lazy var titleLabel: UILabel = { [unowned self] in
    let label = UILabel(forAutoLayout: true)
    label.font = UIFont.standardBoldFontOfSize(17.0)
    label.numberOfLines = 0
    self.contentView.addSubview(label)
    return label
  }()
  
  lazy var dateLabel: UILabel = { [unowned self] in
    let label = UILabel(forAutoLayout: true)
    label.font = UIFont.standardCaptionFont()
    self.contentView.addSubview(label)
    return label
  }()
  
  lazy var messageLabel: UILabel = { [unowned self] in
    var label = UILabel()
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    label.font = UIFont.systemFontOfSize(14.0)
    label.numberOfLines = 0
    self.contentView.addSubview(label)
    return label
    }()
  
  lazy var iconImageView: PFImageView = {
    var iv = PFImageView()
    iv.setTranslatesAutoresizingMaskIntoConstraints(false)
    iv.backgroundColor = UIColor.purpleColor()
    self.contentView.addSubview(iv)
    return iv
    }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()

    
  }

 
  
  func setup() {
    // Elements dictionary, holds all subviews
    let ed: [NSObject : AnyObject] = ["messageLabel": messageLabel, "iconImageView": iconImageView, "titleLabel": titleLabel, "dateLabel": dateLabel]
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[dateLabel]-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[titleLabel]-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[messageLabel]-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[dateLabel][titleLabel][messageLabel]-|", options: NSLayoutFormatOptions.DirectionLeftToRight, metrics: nil, views: ed))

    //contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[iconImageView(50)]-(>=8)-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ed))

    
    titleLabel.setContentHuggingPriority(100, forAxis: .Horizontal)
    dateLabel.setContentHuggingPriority(900, forAxis: .Horizontal)
    messageLabel.setContentHuggingPriority(100, forAxis: .Vertical)
    //messageLabel.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
    
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
}