//
//  UPMSellTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/8/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit
import SellUI

/**
  The UPMSellTVC is an abstract class used to post UPMListings to the marketplace. It gathers
  user-input through various controllers. It provides the following base controllers for gathering
  input:
    - UPMSellPriceFormatTVC, the price for a listing.
    - UPMSellDescriptionVC, :description of a listing.
    - UPMSellTitleTVC, the :title: of a listing.
    - UPMSellImagePickerVC, the :picture: of a listing.
  The delegatge methods of each of these controllers are implemented by this class. These can easily
  be removed by modifying the requiredItems container. Additional attributes can either be added in 
  the requiredItems and  optionalItems container or through the UPMSellDetailsTVC.
*/
class UPMSellTVC: UITableViewController, UPMSellDescriptionDelegate, UITextViewDelegate, UPMSellPriceFormatDelegate, UPMSellTitleDelegate, UPMSellImagePickerDelegate, MBProgressHUDDelegate {
  
  // MARK: - Constants
  let SellCellIdentifier = "UPMSellCell"
  let SellTitleCelIdentifier = "UPMSellTitleCell"
  
  // MARK: - Public Properties
  
  /// Container for all required items (attributes) of a listing.
  var requiredItems = UPMSellItemContainer()
  
  /// Container for optional items (attributes) of a listing.
  var optionalItems = UPMSellItemContainer()
  
  /// Listing to be posted. Should be overriden and return subclass.
  var listing: UPMListing?
  
  enum CellSection: Int {
    case Title = 0, Required , Optional;
    static let allValues = [Title, Required, Optional]
  }

  /// Default requiredItems
  enum RequiredItems: String {
    case Title = "Title"
    case Photos = "Photos"
    case Description = "Description"
    case PriceFormat = "Price Format"
    case Details = "Details"
    static let allValues = [Photos, Description, PriceFormat, Details]
  }
  
  enum OptionalItems: String {
    case Tags = "Tags"
  }
  
  // MARK: - Public  Methods

  override func viewDidLoad() {
    super.viewDidLoad()
    listing = UPMOtherListing()
    tableView.estimatedRowHeight = 100
    tableView = UITableView(frame: tableView.frame, style: UITableViewStyle.Grouped)
    tableView.backgroundColor = UIColor.standardBackgroundColor()
    
    addCancelButtontToNavigationItemWithSelector("didPressCancelButton:")
    var postButton = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Done, target: self, action: "didPressPostButton:")
    navigationItem.rightBarButtonItem = postButton
    self.automaticallyAdjustsScrollViewInsets = false
    
    self.edgesForExtendedLayout = UIRectEdge.All;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, CGRectGetHeight((self.tabBarController?.tabBar.frame)!), 0.0)
    
    // Items
    createRequiredItems()
    createOptionalItems()
    
    // Cells
    tableView.registerNib(UINib(nibName: SellCellIdentifier, bundle: nil), forCellReuseIdentifier: SellCellIdentifier)
    tableView.registerNib(UINib(nibName: SellTitleCelIdentifier, bundle: nil), forCellReuseIdentifier: SellTitleCelIdentifier)

  }
  
  func didPressCancelButton(sender: AnyObject) {
    self.navigationController?.popToRootViewControllerAnimated(true)
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  /// Creates default required items, may be overriden to provide custom required items.
  func createRequiredItems() {
    // Required
    var titleItem = UPMSellItem(title: RequiredItems.Title.rawValue, description: "Write")
    var photoItem = UPMSellItem(title: RequiredItems.Photos.rawValue, description: "Select")
    var priceFormatItem = UPMSellItem(title: RequiredItems.PriceFormat.rawValue, description: "Select")
    var detailsItem = UPMSellItem(title: RequiredItems.Details.rawValue, description: "Select")
    var descriptionItem = UPMSellItem(title: RequiredItems.Description.rawValue, description: "Write")
    requiredItems.addItems([titleItem, photoItem, priceFormatItem, detailsItem, descriptionItem])
  }
  
  /// Creates the default optional items, can be overriden to provide custom optional items.
  func createOptionalItems() {
    //TODO: Implement a tags controller
    var tagsItem = UPMSellItem(title: OptionalItems.Tags.rawValue, description: "Select")
    optionalItems.addItems([tagsItem])
  }
  
  // MARK: Private Methods
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // MARK: - Posting Methods
  
  /// Calls post() if required items are complete. Otherwise displays
  /// an alert view with missing items.
  func postIfComplete() {
    if requiredItems.isItemsComplete() {
      post()
    } else {
      alertIfMissingRequiredItems()
    }
  }
  
  /// Checks if required items are complete and alerts if there are missing items.
  /// Displays progress HUD while executing post().
  ///
  /// * Uses post() to save to parse
  /// * When complete, pops the controller from navigation stack.
  func postWithProgressHUD() {
    if UPMReachabilityManager.isUnreachable() {
      UPMReachabilityManager.alertOfNoNetworkConnectionInController(self)
      return
    }
    
    if requiredItems.isItemsComplete() {
      var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
      hud.labelText = "Posting..."
      
      self.post().continueWithBlock({ (task: BFTask!) -> AnyObject! in
        if task.error == nil {
          hud.labelText = "Success"
          sleep(1)
          dispatch_async(dispatch_get_main_queue(), { () -> Void in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            self.navigationController?.popToRootViewControllerAnimated(true)
          })
        } else {
          var errorAlert = UIAlertController(title: "Error", message: "An error ocurred.", preferredStyle: .Alert)
          errorAlert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
          dispatch_async(dispatch_get_main_queue(), { () -> Void in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            self.navigationController?.popToRootViewControllerAnimated(true)
          })
        }
        return nil
      })
    } else {
      alertIfMissingRequiredItems()
    }
  }
  
  /// Displays an alert if required items are not complete.
  func alertIfMissingRequiredItems() {
    if !requiredItems.isItemsComplete() {
      var alertController = UIAlertController(title: "Error", message: requiredItems.missingDescription(), preferredStyle: UIAlertControllerStyle.Alert)
      var okayAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil)
      alertController.addAction(okayAction);
      presentViewController(alertController, animated: true, completion: nil)
    }
  }

  /**
  Saves the listing to parse. Should not call directly, instead call
  postWithProgressHUD for a user-friendly experience.
  
    - May override for customization.
  
  :returns: task indicating the status of the posting
  */
  func post() -> BFTask {
    var postTask = BFTaskCompletionSource()

    listing?.saveInBackground().continueWithBlock({
      (task: BFTask!) -> AnyObject! in
      if task.error == nil {
        postTask.setResult(task.result)
      } else {
        postTask.setError(task.error)
      }
      return nil
    })
    return postTask.task
  }
  
  /// Calls postWithProgressHUD() when done button is pressed
  func didPressPostButton(sender: AnyObject) {
    postWithProgressHUD()
  }

  // MARK: - TableView Data Source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return CellSection.allValues.count
  }

  //TODO: Make it possible to remove title/image cell
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let Section = CellSection(rawValue: section)
    
    switch Section! {
    case CellSection.Title:
      return 1
    case CellSection.Required:
      return requiredItems.count
    case CellSection.Optional:
      return optionalItems.count
    default:
      return 0
    }
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let s = CellSection(rawValue: section)!
    switch s {
    case CellSection.Required:
      return "Required"
    case CellSection.Optional:
      return "Optional"
    default:
      return ""
    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let Section: CellSection = (CellSection(rawValue: indexPath.section))! as CellSection
    
      switch Section {
      case CellSection.Title:
        let cell = tableView.dequeueReusableCellWithIdentifier(SellTitleCelIdentifier, forIndexPath: indexPath) as! UPMSellTitleCell
        var titleItem = requiredItems.itemWithTitle(RequiredItems.Title.rawValue)
        cell.titleLabel.text = titleItem?.itemDescription
        if listing?.photo != nil {
          cell.displayImageView.image = listing?.photo
        }
        cell.displayImageViewTapped = { (sender: AnyObject) -> Void in
          self.pushImagePickerVC()
          return
        }
        cell.titleLabelTapped = { (sender: AnyObject) -> Void in
          self.pushTitleVC()
          return;
        }
        return cell
      case CellSection.Required:
        let cell = tableView.dequeueReusableCellWithIdentifier(SellCellIdentifier, forIndexPath: indexPath) as! UPMSellCell
        var i = requiredItems.itemAtIndex(indexPath.row)
        cell.configureCell(i.title, details: i.itemDescription, isComplete: i.isComplete)
        return cell
      case CellSection.Optional:
        let cell = tableView.dequeueReusableCellWithIdentifier(SellCellIdentifier, forIndexPath: indexPath) as! UPMSellCell
        var i = optionalItems.itemAtIndex(indexPath.row)
        cell.configureCell(i.title, details: i.itemDescription, isComplete: i.isComplete)
        return cell
      default:
        NSLog("meow")
      }
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return getNavigationBarHeight() + 30
    } else {
      return UITableViewAutomaticDimension
    }
  }

  // MARK: - Delegate Methods
  
  func descriptionUpdated(description: String)  {
    var descriptionItem = requiredItems.itemWithTitle(RequiredItems.Description.rawValue)
    if description != "" {
      descriptionItem?.isComplete = true
      descriptionItem?.itemDescription = description
      listing?.descriptionS = description
    }
  }
  
  func updatedPriceFormat(price: Double, limit: Double?, oBo: Bool) {
    listing?.price = price
    if oBo {
      listing?.limit = limit!
    } else {
      listing?.limit = 0.00
    }
    listing?.oBO = ObjCBool(oBo)
    
    var priceFormatItem = requiredItems.itemWithTitle(RequiredItems.PriceFormat.rawValue)
    var descriptionString = ""
    if oBo {
      descriptionString = String(format: "Best Offer, Reserve $%.2f \nDecline offers lower than: $%.2f", price,limit!)
    } else {
      descriptionString = String(format: "Reserve $%.2f", price)
    }
    priceFormatItem?.itemDescription = descriptionString
    priceFormatItem?.isComplete = true
  }
  
  func didUpdateTitle(title: String) {
    var titleItem = requiredItems.itemWithTitle(RequiredItems.Title.rawValue)
    listing?.title = title
    titleItem?.itemDescription = title
    titleItem?.isComplete = true
  }
  
  func didUpdatePhoto(image: UIImage) {
    var photoItem = requiredItems.itemWithTitle(RequiredItems.Photos.rawValue)
    var file: NSData = UIImageJPEGRepresentation(image, 0.45)
    listing?.picture = PFFile(name: "image.png", data: file)
    listing?.photo = image
    photoItem?.itemDescription = "Picture Added"
    photoItem?.isComplete = true
  }
  
  func didSelectItemAtIndexPath(indexPath: NSIndexPath) {
    let Section: CellSection = (CellSection(rawValue: indexPath.section))! as CellSection
    
    switch Section {
    case CellSection.Required:
      var item = requiredItems.itemAtIndex(indexPath.row)
      
      switch item.title {
      case RequiredItems.Title.rawValue:
        pushTitleVC()
        
      case RequiredItems.PriceFormat.rawValue:
        pushPriceFormatVC()
        
      case RequiredItems.Description.rawValue:
        pushDescriptionVC()
        
      case RequiredItems.Photos.rawValue:
        pushImagePickerVC()
        
      case RequiredItems.Details.rawValue:
        pushDetailsVC()
        
      default: break
      
      }
      
    default:
      NSLog("")
    }
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    didSelectItemAtIndexPath(indexPath)
  }

}
