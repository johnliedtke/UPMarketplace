//
//  UPMBuyCategoryCell.swift
//  UPMarketplace
//
//  Created by Krismy on 1/15/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit
import QuartzCore

class UPMBuyCategoryCell: UICollectionViewCell {
    
    
    @IBOutlet weak var listingPicture: UIImageView!
    
    @IBOutlet weak var listingCategory: UILabel!
    
    
    var pic:UIImage? {
        didSet {
            listingPicture.image = pic
        }
    }
    
    
    var title: String? {
        didSet {
            listingCategory.text = title
        }
    }
    
    
}