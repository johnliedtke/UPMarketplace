//
//  UPMBuyFilterCell.swift
//  UPMarketplace
//
//  Created by Krismy on 2/23/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

class UPMBuyFilterCell: UITableViewCell {

  struct UPMBuyItemImageCellConstants {
    static let reuseIdentifier = "UPMBuyFilterCell"
  }
  
  // MARK: - Init
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupConstraints()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupConstraints()
  }
  
  lazy var titleLabel: UILabel = {
    var label = UILabelVertical()
    label.numberOfLines = 0
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(label)
    label.text = "Category Title"
    label.font = UIFont.standardHeaderOneFont()
    return label
    }()

  /**
  Convenience method for configuring the cell.
  
  :param: title Sets the titleLabel text
  :param: price Sets the priceLabel text
  */
  func configureCell(title: String!) {
    titleLabel.text = title
   
  }
  
  // MARK: - Private Methods
  
  /**
  Sets up the layout of the cell.
  */
  private func setupConstraints() -> Void {
    
    var ed: [NSObject : AnyObject] = ["titleLabel": titleLabel]
    
    // Horizontal Layout
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-(>=50)-[titleLabel]-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: UPMStandards.autoLayoutMetrics,
      views: ed))
    

    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-[titleLabel]-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
  }

  
}
