//
//  UPMSellTitleCell.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/16/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

class UPMSellTitleCell: UITableViewCell {
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var displayImageView: UIImageView!
  var topBorder: UIView?
  var bottomBorder: UIView?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundColor = UIColor.clearColor()
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.backgroundColor = UIColor.clearColor()
    self.contentView.backgroundColor = UIColor.clearColor()
    
    // Remove borderes
    if topBorder == nil || bottomBorder == nil {
      topBorder = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 1.0))
      bottomBorder = UIView(frame: CGRectMake(0, self.frame.height-1, UIScreen.mainScreen().bounds.width, 1.0))
      topBorder?.backgroundColor = UIColor.standardBackgroundColor()
      bottomBorder?.backgroundColor = UIColor.standardBackgroundColor()
      addSubview(topBorder!)
      addSubview(bottomBorder!)
    }

    #if !TARGET_INTERFACE_BUILDER
      topBorder?.setNeedsDisplay()
      bottomBorder?.setNeedsDisplay()
    #endif
  }

  
}