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
   
    let reuseidentifer = "BuyViewCell"
    
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseidentifer, forIndexPath: indexPath) as BuyViewCategoryCell
    
        cell.pic = UIImage(named: pictures[indexPath.row])
        cell.title = categories[indexPath.row]

        
        return cell
    }
    
    func collectionView(collection: UICollectionView, selectedItemIndex: NSIndexPath)
    {
        
        self.performSegueWithIdentifier("chooseCategory", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "chooseCategory"){
            let destinationVC = segue.destinationViewController as BuyChosenCategoryViewController
   
            let indexPaths : NSArray = self.collectionView!.indexPathsForSelectedItems()
            let indexPath : NSIndexPath = indexPaths[0] as NSIndexPath
            
           destinationVC.category = categories[indexPath.row]
            

                 }
    }
    
  
    
}