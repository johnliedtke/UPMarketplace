//
//  UPMSellDescriptionTextView.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/15/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

@IBDesignable
class UPMSellDescriptionTextView: UITextView {
  

  override func layoutSubviews() {
    super.layoutSubviews()

    
    
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0).CGColor
    self.layer.cornerRadius = 10
    
    let inset: CGFloat = 10.0
    


    
    self.textContainerInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset - 5)
    

  }


}
