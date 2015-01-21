//
//  UPMButton.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/15/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

@IBDesignable
class UPMButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setTitleColor(UIColor.lightPurpleColor(), forState: UIControlState.Normal)
  }

}
