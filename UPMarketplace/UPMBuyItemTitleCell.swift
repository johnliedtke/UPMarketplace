//
//  UPMBuyItemTitleCell.swift
//  UPMarketplace
//
//  Created by Krismy on 1/28/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit


struct UPMBuyItemTitleCellConstants {
  static let reuseIdentifier = "UPMBuyItemTitleCell"
}

@IBDesignable
class UPMBuyItemTitleCell: UITableViewCell {
  
  lazy var titleLabel: UILabel = {
    var label = UILabelVertical()
    label.numberOfLines = 0
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(label)
    
    label.text = "title Label"
    
    return label
  }()
  
  lazy var priceLabel: UILabel = {
    var label = UILabelVertical()
    label.numberOfLines = 0
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(label)
    
    label.text = "Price Label"
    return label
    }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    
    
    var ed = NSDictionary(dictionary: ["priceLabel": priceLabel, "titleLabel": titleLabel])
    
    
    // Horizontal Layout
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-[titleLabel]-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-[priceLabel]-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-[titleLabel]-[priceLabel]-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    
    var ed = NSDictionary(dictionary: ["priceLabel": priceLabel, "titleLabel": titleLabel])
    
    
    // Horizontal Layout
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-[titleLabel]-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-[priceLabel]-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-[titleLabel]-[priceLabel]-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
  }
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configureCell(title: String!, price: String!) {
    titleLabel.text = title
    priceLabel.text = price
  }
    
}
