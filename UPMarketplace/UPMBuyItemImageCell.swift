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
class UPMBuyItemImageCell: UITableViewCell {

  @IBOutlet weak var buyItemImage: PFImageView!
  
 
  
  override func layoutSubviews() {
    super.layoutSubviews()
    buyItemImage.clipsToBounds = true
    buyItemImage.backgroundColor = UIColor.flatLightWhiteColor()
     
  }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
