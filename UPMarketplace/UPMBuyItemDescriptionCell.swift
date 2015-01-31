//
//  UPMBuyItemDescriptionCell.swift
//  UPMarketplace
//
//  Created by Krismy on 1/28/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit



struct UPMBuyItemDescriptionCellConstants {
  static let reuseIdentifier = "UPMBuyItemDescriptionCell"
}

@IBDesignable
class UPMBuyItemDescriptionCell: UITableViewCell {
  
  lazy var titleLabel: UILabel = {
    var label = UILabelVertical()
    label.numberOfLines = 0
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(label)
    label.font = label.font.fontWithSize(12)
    label.text = "Item Description:"
    
    return label
    }()
  
  lazy var descriptionLabel: UILabel = {
    var label = UILabelVertical()
    label.numberOfLines = 2
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(label)
    label.text = "This is a fake description. This is a fake description. This is a fake description. This is a fake description. This is a fake description. This is a fake description. This is a fake description."
    return label
    }()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupConstraints()
    
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupConstraints()
    
  }
  
  func setupConstraints() {
    
    var ed = NSDictionary(dictionary: ["titleLabel": titleLabel, "descriptionLabel": descriptionLabel])
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-[titleLabel]-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-[descriptionLabel]-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-[titleLabel(15)]-[descriptionLabel]-|",
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
  
  func setDescription(description: String!){
    descriptionLabel.text = description
  }
    
}
