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
  let fieldCellIdentifier = "UPMBuyItemFieldCell"
  let descriptionCellIdentifier = "UPMBuyItemDescriptionCell"
  
  var numberOfAttributes = 3
  

  // MARK: - Public Properties
  var listing: UPMListing?
  

  enum tableCellSection: Int {
    case ImageSection = 0, TitleSection, FieldSection, DescriptionSection;
    static let allValues = [ImageSection, TitleSection, FieldSection, DescriptionSection]
  }
  
  /// Override to change the default values before the first data is fetched
  func changeDefaults() -> Void {
    
  }

  // MARK: - Public Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    changeDefaults()
    tableView.registerNib(UINib(nibName: imageCellIdentifier, bundle: nil), forCellReuseIdentifier: imageCellIdentifier)
    
    tableView.registerNib(UINib(nibName: titleCellIdentifier, bundle: nil), forCellReuseIdentifier: titleCellIdentifier)
    
    tableView.registerNib(UINib(nibName: fieldCellIdentifier, bundle: nil), forCellReuseIdentifier: fieldCellIdentifier)
    
    tableView.registerNib(UINib(nibName: descriptionCellIdentifier, bundle: nil), forCellReuseIdentifier: descriptionCellIdentifier)
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
   
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    changeDefaults()
     var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    var contactButton = UIBarButtonItem(title: "CONTACT", style: UIBarButtonItemStyle.Bordered, target: self, action: nil)
    var reserveButton = UIBarButtonItem(title: "RESERVE", style: UIBarButtonItemStyle.Bordered, target: self, action: nil)
    var barItems = [flexSpace, contactButton, flexSpace, reserveButton, flexSpace]
    
    self.setToolbarItems(barItems, animated: true)
    navigationController?.toolbarHidden = false
    tableView.reloadData()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.toolbarHidden = true
  }
  

  override init(){
    super.init()
  }
  
  
  required init(coder aDecoder: NSCoder)
  {
      super.init(coder: aDecoder)
    
    
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let Section = tableCellSection(rawValue: section)! as tableCellSection
    
    switch Section{
    case tableCellSection.FieldSection:
      return numberOfAttributes
    default:
      return 1
    }

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
    case tableCellSection.FieldSection:
       let cell = tableView.dequeueReusableCellWithIdentifier(fieldCellIdentifier, forIndexPath: indexPath) as UPMBuyItemFieldCell
       
       configureFieldCells(cell, indexPath: indexPath)

      return cell
    
    case tableCellSection.DescriptionSection:
      let cell = tableView.dequeueReusableCellWithIdentifier(descriptionCellIdentifier, forIndexPath: indexPath) as UPMBuyItemDescriptionCell
      cell.setDescription(listing?.descriptionS)
      return cell
      
    default:
      NSLog("not one of the sections")
    }
    
  }
  
  func configureFieldCells(cell: UPMBuyItemFieldCell!, indexPath: NSIndexPath){
    if (indexPath.row == 0){
      cell.configureCell("Category",second: "More Information")
    }
    else{
      cell.configureCell("Hello There", second: "Mehh")
    }
  }
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let Section: tableCellSection = (tableCellSection(rawValue: indexPath.section))! as tableCellSection
    switch Section{
      
      case tableCellSection.DescriptionSection:
        let BuyItem = UIStoryboard(name: "UPMBuyWorkflow", bundle: nil)
        var buyDescriptionVC: UPMBuyItemDescriptionVC = BuyItem.instantiateViewControllerWithIdentifier("UPMBuyItemDescriptionVC") as UPMBuyItemDescriptionVC
    
    
    buyDescriptionVC.descriptionS = (listing?.descriptionS)!
        navigationController?.pushViewController(buyDescriptionVC, animated: true)
      
      
    default:
      break
    }
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
    return tableCellSection.allValues.count
  }
  

  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
    let Section = tableCellSection(rawValue: section)! as tableCellSection
    switch Section{
    case tableCellSection.ImageSection:
      return 0.00001
    case tableCellSection.TitleSection:
      return 0.00001
    case tableCellSection.FieldSection:
      return 4.0
    case tableCellSection.DescriptionSection:
      return 4.0
    default:
      return 0.00001
    }
  }

  override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    let Section = tableCellSection(rawValue: section)! as tableCellSection
    switch Section{
    case tableCellSection.ImageSection:
      return 0.00001
    case tableCellSection.TitleSection:
      return 0.00001
    case tableCellSection.FieldSection:
      return 4.0
    case tableCellSection.DescriptionSection:
      return 4.0
    default:
      return 0.00001
    }
  
  }
}
