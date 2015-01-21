//
//  UPMSellTitleCell.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/16/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

internal class UPMSellTitleCell: UITableViewCell {
 
  // MARK: - Public Properties
  
  /// Reference to the label for displaying a title
  @IBOutlet var titleLabel: UILabel!
  
  /// Reference to the displayImageView
  @IBOutlet var displayImageView: UIImageView!

  /// Handle event when displayImageView is tapped
  var displayImageViewTapped: ((sender: AnyObject) -> ())!
  
  /// Handle event when the title label is tapped
  var titleLabelTapped: ((sender: AnyObject) -> ())!
  
  // MARK: - Private Properties
  
  /// Reference to the gesture recognizer that listens for taps on displayImageView
  var displayImageViewapGestureRecognizer: UITapGestureRecognizer!
  
  /// Reference to the gesture recognizer that listens for taps on titleLabel
  var titleLabelTapGestureRecognizer: UITapGestureRecognizer!
  
  /// White line to remove cell border
  var topBorder: UIView?
  var bottomBorder: UIView?
  
  // MARK - Private Methods

  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundColor = UIColor.clearColor()
  }

  func handleTapGesture(sender: UITapGestureRecognizer) {
    if sender == displayImageViewapGestureRecognizer && displayImageViewTapped != nil {
      displayImageViewTapped(sender: self)
    } else if sender == titleLabelTapGestureRecognizer && titleLabelTapped != nil {
      titleLabelTapped(sender: self)
    }
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    // Remove background
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
      
      // For tapping
      displayImageView.userInteractionEnabled = true
      titleLabel.userInteractionEnabled = true
      
      // Initialize gesture recognizers
      if displayImageViewapGestureRecognizer == nil {
        displayImageViewapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        displayImageView.addGestureRecognizer(displayImageViewapGestureRecognizer)
      }
      
      if titleLabelTapGestureRecognizer == nil {
        titleLabelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        titleLabel.addGestureRecognizer(titleLabelTapGestureRecognizer)
      }
      
    }

    #if !TARGET_INTERFACE_BUILDER
      topBorder?.setNeedsDisplay()
      bottomBorder?.setNeedsDisplay()
    #endif
  }

  
}
