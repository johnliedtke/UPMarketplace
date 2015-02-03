//
//  UPMBuyItemFieldCell.swift
//  UPMarketplace
//
//  Created by Krismy on 1/28/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

struct UPMBuyItemFieldCellConstants {
  static let reuseIdentifier = "UPMBuyItemFieldCell"
}

@IBDesignable
class UPMBuyItemFieldCell: UITableViewCell {
  
  // MARK: - UI Elements

  lazy var firstColumnLabel: UILabel = {
    var label = UILabel.standardCaptionLabel(true)
    label.numberOfLines = 0
    self.contentView.addSubview(label)
    label.text = "First Item"
    return label
    }()
  
  lazy var secondColumnLabel: UILabel = {
    var label = UILabel(forAutoLayout: true)
    label.numberOfLines = 0
    label.font = UIFont.standardTextFont()
    self.contentView.addSubview(label)
    label.text = "Second Item"
    return label
    }()
  
  // MARK: - Init

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupConstraints()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupConstraints()
  }
  
  func setupConstraints() {
    
    var ed = NSDictionary(dictionary: ["firstColumnLabel": firstColumnLabel, "secondColumnLabel": secondColumnLabel])
    
    // Horizontal layout
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-(hlp)-[firstColumnLabel(75)]-[secondColumnLabel]-(hrp)-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: UPMStandards.autoLayoutMetrics,
      views: ed))
    
    // Vertical layout
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-[firstColumnLabel]-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-[secondColumnLabel]-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
  }
  
  
  func configureCell(first: String!, second: String!){
    firstColumnLabel.text = first
    secondColumnLabel.text = second
  }
    
}
