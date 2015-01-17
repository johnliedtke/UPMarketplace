//
//  UPMItemCategoryCell.swift
//  UPMarketplace
//
//  Created by Krismy on 1/16/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//
import UIKit

class UPMItemCategoryCell: UICollectionViewCell {

    @IBOutlet weak var itemImage: PFImageView!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDetails: UILabel!
    @IBOutlet weak var itemTitle: UILabelVertical!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    func configureCell(title: String, price: String, details: String) {
        itemPrice.text = price
        itemDetails.text = details
        itemPrice.text = price
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Add a border
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0).CGColor
        
        // imageView is always 55% of the height of the cell.
        itemImage.clipsToBounds = true
        imageHeight.constant = frame.height * 0.55;
    }
}
