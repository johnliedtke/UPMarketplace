//
//  BuyViewController.swift
//  UPMarketplace
//
//  Created by Krismy on 11/19/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

class BuyViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout{
    
    var categories = ["Textbooks", "Housing", "Other"]
    var pictures = ["Textbooks.png", "Housing.png", "Other.png"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("buyViewCategoryCell", forIndexPath: indexPath) as BuyViewCategoryCell
    
        cell.pic = UIImage(named: pictures[indexPath.row])
        cell.title = categories[indexPath.row]

        
        return cell
    }

  
    
}