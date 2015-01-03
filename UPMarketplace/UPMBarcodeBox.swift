//
//  UPMBarcodeBox.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/28/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit


/**
Draws a barcode scanner box with a blinking red line in the middle of the screen. 
View should be removed and added if switching between view controllers to ensure 
the animation of the red line does not stop.
*/
class UPMBarcodeBox: UIView {
  
  let ScreenFrame = UIScreen.mainScreen().applicationFrame
  let ScreenWidth = UIScreen.mainScreen().applicationFrame.width
  let ScreenHeight = UIScreen.mainScreen().applicationFrame.height

  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    
    // Padding
    let FivePercentInFromLeft = ScreenWidth * 0.05
    let FivePercentInFromRight = ScreenWidth * 0.95
    
    // Current context
    var context = UIGraphicsGetCurrentContext()
    
    CGContextSetLineWidth(context, 2.0)
    
    // White rectangle in middle of screen
    CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
    var WhiteRect = CGRect(x: FivePercentInFromLeft, y: ScreenHeight * 0.35, width: ScreenWidth * 0.90, height: ScreenHeight * 0.30)
    
    CGContextStrokeRect(context, WhiteRect)
    
    // Remove left part of rectangle
    CGContextSetBlendMode(context, kCGBlendModeClear)
    CGContextSetLineWidth(context, 4.0)
    
    CGContextMoveToPoint(context, FivePercentInFromLeft, ScreenHeight * 0.40)
    CGContextAddLineToPoint(context, FivePercentInFromLeft, ScreenHeight * 0.60)
    
    CGContextStrokePath(context)
    
    // Remove right part of rectangle
    CGContextMoveToPoint(context, FivePercentInFromRight, ScreenHeight * 0.40)
    CGContextAddLineToPoint(context, FivePercentInFromRight, ScreenHeight * 0.60)
    
    CGContextStrokePath(context)
    
    CGContextSetBlendMode(context, kCGBlendModeColor)
    
    // Create the red line path
    var redPath = UIBezierPath()
    redPath.lineWidth = 2.0
    redPath.moveToPoint(CGPoint(x: ScreenWidth * 0.10, y:  ScreenHeight / 2.0))
    redPath.addLineToPoint(CGPoint(x: ScreenWidth * 0.90, y:  ScreenHeight / 2.0))
    UIColor.redColor().setStroke()
    
    // Convert to shape layer for animation
    var redLineLayer = CAShapeLayer()
    redLineLayer.path = redPath.CGPath
    redLineLayer.strokeColor = UIColor.redColor().CGColor
    redLineLayer.lineWidth = 2.0
    
    // Animate the line to blink
    var animation = CABasicAnimation(keyPath: "opacity")
    animation.duration = 0.50
    animation.repeatCount = Float(Int.max)
    animation.toValue = 1.0
    animation.fromValue = 0.0
    redLineLayer.addAnimation(animation, forKey: "animatePath")
    layer.addSublayer(redLineLayer)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    backgroundColor = UIColor.clearColor()
  }
}
