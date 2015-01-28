//
//  UPMBuyItemDetailsTVC.swift
//  UPMarketplace
//
//  Created by Krismy on 1/17/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit



class UPMBuyItemDetailsTVC: UITableViewController {


  // MARK: - Public Properties
  var listing: UPMListing?
  
  
 //var itemObject: PFObject
  @IBOutlet var selectedImage: PFImageView!


  // MARK: - Public Methods
  override func viewDidLoad() {
    selectedImage.file = listing?.picture
    selectedImage.loadInBackground()
  }
  
  
  
  required init(coder aDecoder: NSCoder!)
  {
      super.init(coder: aDecoder)
    
    
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 2
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
  
//  override func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
 // }
  
    
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
    return 2
  }
    
}
