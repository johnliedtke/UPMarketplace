//
//  BuyViewCategoryCell.swift
//  UPMarketplace
//
//  Created by Krismy on 11/30/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit
import QuartzCore

public class BuyViewCategoryCell: UICollectionViewCell {
    
    
    @IBOutlet weak var listingPicture: UIImageView!
    
    @IBOutlet weak var listingCategory: UITextView!
    
    
    public var pic:UIImage? {
        didSet {
            listingPicture.image = pic
        }
    }
    
    
    public var title: String? {
        didSet {
            listingCategory.text = title
        }
    }
    
    
}
