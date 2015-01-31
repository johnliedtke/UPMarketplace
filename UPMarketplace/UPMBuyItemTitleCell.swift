//
//  UPMBuyItemTitleCell.swift
//  UPMarketplace
//
//  Created by Krismy on 1/28/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit


struct UPMBuyItemTitleCellConstants {
  static let reuseIdentifier = "UPMBuyItemTitleCell"
}


class UPMBuyItemTitleCell: UITableViewCell {

  @IBOutlet weak var itemTitleLabel: UILabel!
  
  @IBOutlet weak var itemPriceLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configureCell(title: String!, price: String!) {
    itemTitleLabel.text = title
    itemPriceLabel.text = price
  }
    
}
