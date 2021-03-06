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
  
  /// Whether an existing listing is being updated.
  var isUpdatingListing = false
  
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
    initItemFields()
    
    // Cells
    tableView.registerNib(UINib(nibName: SellCellIdentifier, bundle: nil), forCellReuseIdentifier: SellCellIdentifier)
    tableView.registerNib(UINib(nibName: SellTitleCelIdentifier, bundle: nil), forCellReuseIdentifier: SellTitleCelIdentifier)
  }
  
  /**
  What happens when you press the cancel button in the top left corner.
  */
  func didPressCancelButton(sender: AnyObject) {
    if requiredItems.completedCount > 0 && !isUpdatingListing {
      let cancelAlert = UIAlertController(title: "Cancel Confirmation", message: "Are you sure you want to discard your listing? Listing will not be saved.", preferredStyle: .Alert)
      cancelAlert.addAction(UIAlertAction(title: "Discard", style: .Destructive, handler: {
        (action) in
          self.navigationController?.popToRootViewControllerAnimated(true)
      }))
      cancelAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
      presentViewController(cancelAlert, animated: true, completion: nil)
    } else {
      navigationController?.popToRootViewControllerAnimated(true)
    }
  }
  deinit {
    println("Deallocating SellController")
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
  
  /**
  Used to set the sell items if being used to update a listing.
  */
  func initItemFields() {
    if isUpdatingListing {
      navigationItem.rightBarButtonItem?.title = "Update"
      navigationItem.title = "Listing"
      self.didUpdateTitle((self.listing?.title)!)
      self.updatedPriceFormat((listing?.price)!, limit: 33.2, oBo: Bool((listing?.oBO)!))
      descriptionUpdated((listing?.descriptionS)!)
      if let url = listing?.picture?.url, let imageURL = NSURL(string: url) {
        let sharedManager = SDWebImageManager.sharedManager()
        sharedManager.downloadImageWithURL(imageURL, options: nil, progress: nil, completed: { [weak self] (image, error, cache, finished, url) -> Void in
          if let weakSelf = self where error == nil {
              var imageItem = weakSelf.requiredItems.itemWithTitle(RequiredItems.Photos.rawValue)
              weakSelf.requiredItems.updateItemWithTitle(RequiredItems.Photos.rawValue, description: "Image Selected", isComplete: true)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
              weakSelf.listing?.photo = image
              weakSelf.tableView.reloadData()
            })
          }
        })

      }

    }
  }
  
  /// Creates the default optional items, can be overriden to provide custom optional items.
  func createOptionalItems() {
    //TODO: Implement a tags controller
    //var tagsItem = UPMSellItem(title: OptionalItems.Tags.rawValue, description: "Select")
    //optionalItems.addItems([tagsItem])
  }
  
  // MARK: Private Methods
  

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

    if requiredItems.isItemsComplete() {
      
      let facebookAlert = UIAlertController(title: "Post to facebook?", message: "Would you also like to post this to facebook?", preferredStyle: .Alert)
      facebookAlert.addAction(UIAlertAction(title: "Yes", style: .Default) { [unowned self] (action) in
        
        let composeController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        composeController.setInitialText("\(self.listing!.title!) \n\(self.listing!.displayPrice())\n\(self.facebookDecription())")
        composeController.addImage(self.listing?.photo)
        
        composeController.completionHandler = { (result) in
          
          if result == .Done {
            self.postToParse()
          }
        }
        
        self.presentViewController(composeController, animated: true, completion: nil)
        
      })
      
      facebookAlert.addAction(UIAlertAction(title: "No", style: .Default) {
        [unowned self] (action) in
        self.postToParse()
      })
      
      facebookAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
      
      presentViewController(facebookAlert, animated: true, completion: nil)
      
    } else {
      alertIfMissingRequiredItems()
    }
  }
  
  private func postToParse() {
    self.APP().huddie(labelText: "Posting...")
    
    self.post().continueWithBlock({
      [unowned self] (task: BFTask!)  in
      
      if let error = task.error {
        self.hideHuddieWithMessage("Error", delay: 0.1) {
          self.displayErrorAlertWithMessage(error.localizedDescription)
        }
      } else {
        self.hideHuddieWithMessage("Success", delay: 0.4) {
          self.navigationController?.popToRootViewControllerAnimated(true)
        }
      }
      return nil
      })
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
      return optionalItems.count > 0 ? "Optional" : nil
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
        cell.displayImageViewTapped = { [unowned self] (sender: AnyObject) in
          self.pushImagePickerVC()
          return
        }
        cell.titleLabelTapped = { [unowned self] (sender: AnyObject) in
          self.pushTitleVC()
          return;
        }
        return cell
      case CellSection.Required:
        let cell = tableView.dequeueReusableCellWithIdentifier(SellCellIdentifier, forIndexPath: indexPath) as! UPMSellCell
        var i = requiredItems.itemAtIndex(indexPath.row)
        if count(i.itemDescription) > 300 {
          cell.configureCell(i.title, details: i.itemDescription.substringToIndex(advance(i.itemDescription.startIndex, 299)), isComplete: i.isComplete)
        } else {
          cell.configureCell(i.title, details: i.itemDescription, isComplete: i.isComplete)
        }
        return cell
      case CellSection.Optional:
        let cell = tableView.dequeueReusableCellWithIdentifier(SellCellIdentifier, forIndexPath: indexPath) as! UPMSellCell
        var i = optionalItems.itemAtIndex(indexPath.row)
        cell.configureCell(i.title, details: i.itemDescription, isComplete: i.isComplete)
        return cell
      default: break
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
  
  /**
  Override to provice a custom description for the facebook post
  */
  func facebookDecription() -> String {
    return (listing?.descriptionS)!
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    didSelectItemAtIndexPath(indexPath)
  }

}
