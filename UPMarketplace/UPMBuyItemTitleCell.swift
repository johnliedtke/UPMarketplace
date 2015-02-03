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
public class UPMBuyItemTitleCell: UITableViewCell {
  
  // MARK: - UI Elements
  
  lazy var titleLabel: UILabel = {
    var label = UILabelVertical()
    label.numberOfLines = 0
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(label)
    label.text = "Listing Title"
    label.font = UIFont.standardHeaderOneFont()
    return label
  }()
  
  lazy var priceLabel: UILabel = {
    var label = UILabelVertical()
    label.numberOfLines = 0
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(label)
    label.font = UIFont.standardTitleFont()
    label.text = "Price Label"
    return label
    }()
  
  // MARK: - Public Methods
  
  /**
  Convenience method for configuring the cell.
  
  :param: title Sets the titleLabel text
  :param: price Sets the priceLabel text
  */
  public func configureCell(title: String!, price: String!) {
    titleLabel.text = title
    priceLabel.text = price
  }
  
  // MARK: - Init
  
  override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupConstraints()
  }

  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupConstraints()
  }
  
  // MARK: - Private Methods
  
  /**
  Sets up the layout of the cell.
  */
  private func setupConstraints() -> Void {
    
    var ed = NSDictionary(dictionary: ["priceLabel": priceLabel, "titleLabel": titleLabel])
    
    
    // Horizontal Layout
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-(hlp)-[titleLabel]-(hrp)-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: UPMStandards.autoLayoutMetrics,
      views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-(hlp)-[priceLabel]-(hrp)-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: UPMStandards.autoLayoutMetrics,
      views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-[titleLabel]-[priceLabel]-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))

  }
  
  
  
}
