//
//  UPMBuyItemDetailsTVC.swift
//  UPMarketplace
//
//  Created by Krismy on 1/17/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit


/**
  UPMBuyItemDetailsTVC class handles displaying the details
  of a UPMListing. Subclass to customize for different listings.
*/
class UPMBuyItemDetailsTVC: UITableViewController {
 
  // MARK: - Constants
  
  let imageCellIdentifier = "UPMBuyItemImageCell"
  let titleCellIdentifier = "UPMBuyItemTitleCell"
  let fieldCellIdentifier = "UPMBuyItemFieldCell"
  let descriptionCellIdentifier = "UPMBuyItemDescriptionCell"
  let sellerCellIdentifier = "UPMBuyItemFieldCell"
  
  // MARK: - Public Properties
  
  /// Number of attributes to display
  var numberOfAttributes = 3
  
  /// The listing to display details of.
  var listing: UPMListing!
  
  deinit {
    println("deallocating UPMBuyItemDetailsTVC")
    //listing.picture = nil
  }
  
  // MARK: - Private Properties
  
  /// Reference to the reserve button
  lazy private var reserveButton: UIBarButtonItem = {
    var button = UIBarButtonItem(title: "RESERVE", style: .Bordered, target: self, action: "reserveListing")
    return button
  }()
  
  enum tableCellSection: Int {
    case ImageSection = 0, TitleSection, FieldSection, DescriptionSection, SellerSection;
    static let allValues = [ImageSection, TitleSection, FieldSection, DescriptionSection, SellerSection]
  }
  
  /// Override to change the default values before the first data is fetched
  func changeDefaults() -> Void {
    
  }

  // MARK: - View Methods  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    changeDefaults()
    tableView = UITableView(frame: tableView.bounds, style: .Grouped)
    
    // Register table cells
    //tableView.registerNib(UINib(nibName: imageCellIdentifier, bundle: nil), forCellReuseIdentifier: imageCellIdentifier)
    tableView.registerClass(UPMBuyItemImageCell.self, forCellReuseIdentifier: imageCellIdentifier)
    tableView.registerNib(UINib(nibName: titleCellIdentifier, bundle: nil), forCellReuseIdentifier: titleCellIdentifier)
    tableView.registerNib(UINib(nibName: fieldCellIdentifier, bundle: nil), forCellReuseIdentifier: fieldCellIdentifier)
    tableView.registerNib(UINib(nibName: descriptionCellIdentifier, bundle: nil), forCellReuseIdentifier: descriptionCellIdentifier)
    tableView.registerNib(UINib(nibName: fieldCellIdentifier, bundle: nil), forCellReuseIdentifier: sellerCellIdentifier)
    
    // Background
    tableView.backgroundColor = UIColor.standardBackgroundColor()
    
    // Auto-layout
    tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
    tableView.estimatedRowHeight = 1000 // fix for auto-layout
    
    // Title
    navigationItem.title = "Listing"
    toggleReserveButton()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    changeDefaults()
    
    // Create toolbar for reserving and contacting
    var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    
    var contactButton = UIBarButtonItem(title: "CONTACT", style: .Plain, target: self, action: "contactSeller")
    var barItems = [flexSpace, contactButton, flexSpace, reserveButton, flexSpace]
    
    self.setToolbarItems(barItems, animated: true)
    navigationController?.toolbarHidden = false
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.toolbarHidden = true
    //listing.picture = nil
  }

  // MARK: - Init
  
  // MARK: - Private Methods
  
  /**
  Creates a UPMContactVC for the user to contact the seller.
  */
  internal func contactSeller() {
    //TODO: Use real seller
    var contactVC = UPMContactVC(user: listing.owner, withSubject: "Question about: \(listing!.title!)")
    var navigation = UINavigationController(rootViewController: contactVC)
    presentViewController(navigation, animated: true, completion: nil)
  }
  
  /**
  User has attempted to reserve the listing.
  */
  internal func reserveListing() {
    
    APP().huddie(labelText: "Reserving...")
    
    listing?.reserveInBackground(PFUser.currentUser()!, message: "Reserving").continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock: {
      [unowned self] (task) in

      
      if let error = task.error {
        self.hideHuddieWithMessage("Error...", delay: 0.2) {
          self.displayErrorAlertWithMessage(error.localizedDescription)
        }
      } else {
        self.hideHuddieWithMessage("Reserved...", delay: 0.2) {
          let alertController = UIAlertController(title: "Reserved", message: "Reservation successful.\n\n You will be notified when the seller accepts your reservation. Feel free to contact the seller via email.", preferredStyle: .Alert)
          alertController.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))
          self.presentViewController(alertController, animated: true, completion: nil)
        }
      }
      //self.toggleReserveButton()
      return nil
    })
  }
  
  /**
  Disables the reserve button if the listing ahs been reserved.
  */
  func toggleReserveButton() {
      listing.isReservable().continueWithBlock { (task: BFTask!) -> AnyObject! in
      if let reserveable = task.result as? Bool {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          self.reserveButton.enabled = reserveable
        })
      } else {
        //:TODO handle button error
      }
      return nil
    }
  }
  
  // MARK: - TableView Datasource

  override func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let Section: tableCellSection = (tableCellSection(rawValue: indexPath.section))! as tableCellSection
    
    switch Section{
      case tableCellSection.ImageSection:
        let cell = tableView.dequeueReusableCellWithIdentifier(imageCellIdentifier, forIndexPath: indexPath) as UPMBuyItemImageCell
      
        var weakFile = listing?.picture
        
        weakFile?.getDataInBackground().continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock: {
          [weak self, cell] (task)  in
          if let weakSelf = self {
            if task.error == nil {
              if let imageData = task.result as? NSData {
                cell.buyItemImage.image = UIImage(data: imageData)
                cell.displayImageViewTapped = { [weak self, cell] (sender) in
                  var imageVC = UPMBuyItemDetailsImageVC()
                  imageVC.modalTransitionStyle = .CrossDissolve
                  imageVC.image = UIImage(data: imageData)
                  weakSelf.navigationController?.presentViewController(imageVC, animated: false, completion: nil)
                }
              }
            }
          }
          return nil
        })

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
      
    case tableCellSection.SellerSection:
      let cell = tableView.dequeueReusableCellWithIdentifier(sellerCellIdentifier, forIndexPath: indexPath) as UPMBuyItemFieldCell
      configureSellerCells(cell, indexPath: indexPath)
      return cell
      
    default:
      println("not one of the sections")
    }
    
  }
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
    return tableCellSection.allValues.count
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

  
  func configureFieldCells(cell: UPMBuyItemFieldCell!, indexPath: NSIndexPath){
    if (indexPath.row == 0){
      cell.configureCell("Category",second: "More Information")
    }
    else{
      cell.configureCell("Hello There", second: "Mehh")
    }
  }
  
  func configureSellerCells(cell: UPMBuyItemFieldCell!, indexPath: NSIndexPath){
    
    if let username =  listing?.owner.username {
      cell.configureCell("Seller", second: username)
    }

  }
  
  func fixDateFormat(date: NSDate) -> String{
    var formatter: NSDateFormatter = NSDateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    var stringDate: String = formatter.stringFromDate(date)
    return stringDate
  }
  
  // MARK: - TableView Delegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let Section: tableCellSection = (tableCellSection(rawValue: indexPath.section))! as tableCellSection
    switch Section{
      
      case tableCellSection.DescriptionSection:
        let BuyItem = UIStoryboard(name: "UPMBuyWorkflow", bundle: nil)
        var buyDescriptionVC = UPMBuyItemDescriptionVC(desc: (listing?.descriptionS)!)
        navigationController?.pushViewController(buyDescriptionVC, animated: true)

    default:
      break
    }
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == tableCellSection.FieldSection.rawValue {
      return "Details"
    }
    if section == tableCellSection.SellerSection.rawValue {
      return "Seller Information"
    }
    else {
      return nil
    }
  }
  
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
    let Section = tableCellSection(rawValue: section)! as tableCellSection
    switch Section{
    case tableCellSection.ImageSection:
      return 0.00001
    case tableCellSection.TitleSection:
      return 0.00001
    case tableCellSection.FieldSection:
      return UITableViewAutomaticDimension
    case tableCellSection.DescriptionSection:
      return 0.00001
    default:
      return UITableViewAutomaticDimension
    }
  }

  override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    let Section = tableCellSection(rawValue: section)! as tableCellSection
    
    if section == numberOfSectionsInTableView(tableView) - 1 { return 25 } // space at bottom
    
    switch Section{
    case tableCellSection.ImageSection:
      return 0.00001
    case tableCellSection.TitleSection:
      return 0.00001
    case tableCellSection.FieldSection:
      return 0.00001
    case tableCellSection.DescriptionSection:
      return 0.00001
    default:
      return 0.00001
    }
  
  }
}

class UPMBuyItemDetailsImageVC: UIViewController, UIScrollViewDelegate {
  
  var image: UIImage?
  
  lazy var imageView: UIImageView = {
    var imageView = UIImageView()
    imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
    imageView.contentMode = .ScaleAspectFit
    return imageView
  }()
  
  lazy var scrollView: UIScrollView = {
    var scrollView = UIScrollView()
    scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
    scrollView.delegate = self
    scrollView.minimumZoomScale = 1.0
    scrollView.maximumZoomScale = CGFloat(4.0)
    scrollView.backgroundColor = UIColor.blackColor()
    return scrollView
  }()
  
  lazy var swpipeUpGestureRecognizer: UISwipeGestureRecognizer = {
    var gr = UISwipeGestureRecognizer(target: self, action: "didSwipeUp:")
    gr.direction = .Up
    return gr
  }()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(scrollView)
    scrollView.addSubview(imageView)
    
    if let image = image {
      imageView.image = image
    }
    
    let doneButton = UIButton()
    doneButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    doneButton.setTitle("Done", forState: .Normal)
    doneButton.addTarget(self, action: "didSwipeUp:", forControlEvents: .TouchUpInside)
    doneButton.backgroundColor = UIColor.flatDarkGrayColor().colorWithAlphaComponent(0.5)
    doneButton.layer.cornerRadius = 5.0
    doneButton.layer.borderColor = UIColor.flatDarkGrayColor().CGColor
    doneButton.layer.borderWidth = 1.0
    let ei = doneButton.contentEdgeInsets
    doneButton.contentEdgeInsets = UIEdgeInsets(top: ei.top+10.0, left: ei.left+10.0, bottom: ei.bottom+10.0, right: ei.right+10.0)
    
    var elements: [NSObject : AnyObject] = ["scrollView": scrollView, "imageView": imageView, "doneButton": doneButton]
    
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[scrollView]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: elements))
    
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: .DirectionLeadingToTrailing, metrics: nil, views: elements))
    
    scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageView]|", options: .DirectionLeadingToTrailing, metrics: nil, views: elements))
    
    scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: elements))
    
    scrollView.addConstraint(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
    
    scrollView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: 0))
    
    scrollView.addGestureRecognizer(swpipeUpGestureRecognizer)
    
    
    // Add a done button yo
    scrollView.addSubview(doneButton)
    scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[doneButton]", options: .DirectionLeadingToTrailing, metrics: nil, views: elements))
    scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[doneButton]", options: .DirectionLeadingToTrailing, metrics: nil, views: elements))

    
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  func didSwipeUp(sender: AnyObject) {

    var height = scrollView.frame.height

   self.dismissViewControllerAnimated(true, completion: nil)
    
    println("Did swipe up")
  }
  
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
}

