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

  lazy var firstColumnLabel: UILabel = {
    var label = UILabelVertical()
    label.numberOfLines = 0
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(label)
    
    label.text = "First Item"
    
    return label
    }()
  
  lazy var secondColumnLabel: UILabel = {
    var label = UILabelVertical()
    label.numberOfLines = 0
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(label)
    
    label.text = "Second Item"
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
    
    var ed = NSDictionary(dictionary: ["firstColumnLabel": firstColumnLabel, "secondColumnLabel": secondColumnLabel])
    
    
    
    // Horizontal Layout
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-[firstColumnLabel(75)]-[secondColumnLabel]-|",
      options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
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
  
  
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configureCell(first: String!, second: String!){
    firstColumnLabel.text = first
    secondColumnLabel.text = second
  }
    
}
