//
//  NewListingsViewCell.swift
//  UPMarketplace
//
//  Created by Krismy on 11/16/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit
import QuartzCore
public class NewListingsViewCell: UICollectionViewCell {
    

    @IBOutlet weak var listingPicture: UIImageView!
    
    @IBOutlet weak var listingDescription: UITextView!
    
    @IBOutlet weak var listingPrice: UILabel!
    
    @IBOutlet weak var listingReserve: UILabel!
    
    public var image:UIImage? {
        didSet {
            listingPicture.image = image
        }
    }

    public var price:String? {
        didSet {
            listingPrice.text = "$" + price!
        }
        
    }
    
    public var title: String? {
        didSet {
            listingDescription.text = title
        }
    }
    
    
}
