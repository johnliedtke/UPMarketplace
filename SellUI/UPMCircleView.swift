//
//  UPMCircleView.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/8/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit


@IBDesignable
public class UPMCircleView: UIView {
  
  @IBInspectable
  var circleColor: UIColor = UIColor.flatLightGrayColor()
    
    
  public override func layoutSubviews() {
    super.layoutSubviews()
    backgroundColor = UIColor.clearColor()
  }
  

  override public func drawRect(rect: CGRect) {
  // Drawing code

  
  var r: CGRect = CGRect();
  var centerX = bounds.size.width / 2
  var centerY = bounds.size.height / 2
  var radius = bounds.size.width / 4.25
  
  r.origin.y = centerY-radius
  r.origin.x = centerX-radius
  r.size.width = 2 * radius
  r.size.height = 2 * radius
  
  var context = UIGraphicsGetCurrentContext()
  CGContextSetLineWidth(context, 2.0)
  CGContextSetStrokeColorWithColor(context, circleColor.CGColor)
  CGContextAddEllipseInRect(context, r)
  CGContextStrokePath(context)
  CGContextSetFillColorWithColor(context, circleColor.CGColor)
  CGContextFillEllipseInRect(context, r)
    

  }




}
