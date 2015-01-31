//
//  UPMBuyItemDetailsTVC.swift
//  UPMarketplace
//
//  Created by Krismy on 1/17/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit



class UPMBuyItemDetailsTVC: UITableViewController {

  let imageCellIdentifier = "UPMBuyItemImageCell"
  let titleCellIdentifier = "UPMBuyItemTitleCell"

  // MARK: - Public Properties
  var listing: UPMListing?
  
  
 
  @IBOutlet var selectedImage: PFImageView!

  enum tableCellSection: Int {
    case ImageSection = 0, TitleSection;
    static let allValues = [ImageSection, TitleSection]
  }

  // MARK: - Public Methods
  override func viewDidLoad() {
   // selectedImage.file = listing?.picture
   // selectedImage.loadInBackground()
    

    
   
    
    
    tableView.registerNib(UINib(nibName: imageCellIdentifier, bundle: nil), forCellReuseIdentifier: imageCellIdentifier)
    
    tableView.registerNib(UINib(nibName: titleCellIdentifier, bundle: nil), forCellReuseIdentifier: titleCellIdentifier)
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    var testButton = UIBarButtonItem(title: "CONTACT SDFLSADFADSF", style: UIBarButtonItemStyle.Bordered, target: self, action: "")
    
    navigationController?.setToolbarItems([testButton], animated: true)
    navigationController?.toolbarHidden = false
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.toolbarHidden = true
  }
  
  
  
  required init(coder aDecoder: NSCoder!)
  {
      super.init(coder: aDecoder)
    
    
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
  }
  

  override func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let Section: tableCellSection = (tableCellSection(rawValue: indexPath.section))! as tableCellSection
    
    switch Section{
      case tableCellSection.ImageSection:
        let cell = tableView.dequeueReusableCellWithIdentifier(imageCellIdentifier, forIndexPath: indexPath) as UPMBuyItemImageCell
      
        cell.buyItemImage.file = listing?.picture
       cell.buyItemImage.loadInBackground()
      return cell
    case tableCellSection.TitleSection:
      let cell = tableView.dequeueReusableCellWithIdentifier(titleCellIdentifier, forIndexPath: indexPath) as UPMBuyItemTitleCell
      cell.configureCell(listing?.title, price: listing?.displayPrice())
      

      return cell
    default:
      NSLog("not one of the sections")
    }
    
  }
  
//  override func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
//  {
//    
//    let Section: tableCellSection = (tableCellSection(rawValue: indexPath.section))! as tableCellSection
//    switch Section{
//    case tableCellSection.ImageSection:
//      return tableView.frame.height * 0.30
//    default:
//      return UITableViewAutomaticDimension
//    }
//    
//  }
  
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
    return 2
  }
    
}
