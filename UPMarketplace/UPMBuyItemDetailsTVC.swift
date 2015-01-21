//
//  UPMBuyItemDetailsTVC.swift
//  UPMarketplace
//
//  Created by Krismy on 1/17/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit

class UPMBuyItemDetailsTVC: UITableViewController {

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var itemObject: PFObject
    @IBOutlet var selectedImage: PFImageView!
    var cellInfo: UICollectionViewCell!
    
    
    
}
