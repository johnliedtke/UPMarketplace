//
//  UPMBuyItemImageCell.swift
//  UPMarketplace
//
//  Created by Krismy on 1/28/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

struct UPMBuyItemImageCellConstants {
  static let reuseIdentifier = "UPMBuyItemImageCell"
}

/**
  Use for displaying picture of a UPMListing.
*/
class UPMBuyItemImageCell: UITableViewCell {
  // MARK: - Public Properties

  
  lazy var buyItemImage: UIImageView = {
    var imageView = UIImageView()
    imageView.contentMode = UIViewContentMode.ScaleAspectFit
    imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
    imageView.clipsToBounds = true
    
    imageView.backgroundColor = UIColor.flatLightWhiteColor()
    imageView.userInteractionEnabled = true
    imageView.addGestureRecognizer(self.imageViewGestureRecognizer)
    return imageView
  }()
  
  
   var displayImageViewTapped: ((sender: AnyObject?) -> Void)!
  
  // MARK: - Private Properties
  lazy private var imageViewGestureRecognizer: UITapGestureRecognizer = {
    var gr = UITapGestureRecognizer(target: self, action: "imageViewTapped:")
    return gr
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
    contentView.addSubview(buyItemImage)
    
    var elements: [NSObject: AnyObject] = ["buyItemImage": buyItemImage]
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[buyItemImage]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: elements))
    
    var imageHeight = UIScreen.mainScreen().bounds.height * 0.35
    
    var metrics: [NSObject : AnyObject] = ["imageHeight": imageHeight]
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(>=0)-[buyItemImage(imageHeight)]-(>=0)-|", options: .DirectionLeadingToTrailing, metrics: metrics, views: elements))
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()

  }
  
  deinit {
    println("deallocating image cell")
    buyItemImage.image = nil
  }
  
  func imageViewTapped(sender: AnyObject?) {
    if displayImageViewTapped != nil {
      weak var weakSelf = self
      displayImageViewTapped(sender: nil)
    }
  }

  
}
