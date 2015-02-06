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

  @IBOutlet weak var buyItemImage: PFImageView!
  
  var displayImageViewTapped: ((sender: AnyObject) -> Void)!
  
  // MARK: - Private Properties
  lazy private var imageViewGestureRecognizer: UITapGestureRecognizer = {
    var gr = UITapGestureRecognizer(target: self, action: "imageViewTapped:")
    return gr
  }()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    buyItemImage.clipsToBounds = true
    buyItemImage.backgroundColor = UIColor.flatLightWhiteColor()
    buyItemImage.userInteractionEnabled = true
    buyItemImage.addGestureRecognizer(imageViewGestureRecognizer)

  }
  
  override func awakeFromNib() {
    super.awakeFromNib()

  }
  
  func imageViewTapped(sender: AnyObject) {
    if displayImageViewTapped != nil {
      displayImageViewTapped(sender: self)
    }
  }

  
}
