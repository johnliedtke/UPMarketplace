//
//  UPMSellCell.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/8/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

extension UPMSellCell {
  func configureCell(title: String, details: String, isComplete: Bool) {
    self.title = title
    self.details = details
    self.isComplete = isComplete
  }
}

@IBDesignable
public class UPMSellCell: UITableViewCell {

  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var circleView: UPMCircleView!
  @IBOutlet var detailsLabel: UILabel!
  
  public var title: String? {
    didSet {
      titleLabel.text = title
    }
  }
  
  public var details: String? {
    didSet {
      detailsLabel.text = details
    }
  }
    
  var isComplete: Bool = false {
    didSet {
      if isComplete {
        circleView.circleColor = UIColor.flatGreenColor()
      } else {
        circleView.circleColor = UIColor.flatLightGrayColor()
      }
    }
  }
  
  override public func awakeFromNib() {
      super.awakeFromNib()
    
   // clipsToBounds = true
    if isComplete {
      circleView.circleColor = UIColor.redColor()
    }
    

    

    
      // Initialization code
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    #if !TARGET_INTERFACE_BUILDER
    circleView.setNeedsDisplay()
    #endif
//    contentView.layoutIfNeeded()
//    detailsLabel.preferredMaxLayoutWidth = detailsLabel.frame.size.width
  }

  override public func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }
    
}
