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
  
  //TODO: Needs real name for seller

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
    
    // Register table cells
    tableView.registerNib(UINib(nibName: imageCellIdentifier, bundle: nil), forCellReuseIdentifier: imageCellIdentifier)
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
    
    var contactButton = UIBarButtonItem(title: "CONTACT", style: UIBarButtonItemStyle.Bordered, target: self, action: "contactSeller")
    var barItems = [flexSpace, contactButton, flexSpace, reserveButton, flexSpace]
    
    self.setToolbarItems(barItems, animated: true)
    navigationController?.toolbarHidden = false
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.toolbarHidden = true
  }

  // MARK: - Init
  
  override init(style: UITableViewStyle)
  { super.init(style: .Grouped) }
  
  required init(coder aDecoder: NSCoder)
  {super.init(coder: aDecoder)}
  
  // MARK: - Private Methods
  
  /**
  Creates a UPMContactVC for the user to contact the seller.
  */
  public func contactSeller() {
    //TODO: Use real seller
    var contactVC = UPMContactVC(user: PFUser.currentUser(), withSubject: "Question about: \(listing!.title)")
    var navigation = UINavigationController(rootViewController: contactVC)
    presentViewController(navigation, animated: true, completion: nil)
  }
  
  /**
  User has attempted to reserve the listing.
  */
  internal func reserveListing() {
    listing?.reserveInBackground(PFUser.currentUser(), message: "Reserving").continueWithBlock({
      (task: BFTask!) -> AnyObject! in
      var alertController: UIAlertController!
      if task.error == nil {
        alertController = UIAlertController(title: "Success", message: "You have reserved this listing. Please contact the seller to set up arrangements. Seller will be notified via email.", preferredStyle: .Alert)
      } else {
        alertController = UIAlertController(title: "Error", message: task.error.localizedDescription, preferredStyle: .Alert)
      }
      alertController.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
      self.presentViewController(alertController, animated: true, completion: nil)
      self.toggleReserveButton()
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
        let cell = tableView.dequeueReusableCellWithIdentifier(imageCellIdentifier, forIndexPath: indexPath) as! UPMBuyItemImageCell
      
        cell.buyItemImage.file = listing?.picture
        cell.buyItemImage.loadInBackground()
        cell.displayImageViewTapped = { (sender) in
          var imageVC = UPMBuyItemDetailsImageVC()
          
          self.providesPresentationContextTransitionStyle = true
          self.definesPresentationContext = true
          self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
          self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
          self.view.opaque = false
          self.tableView.opaque = false
          
          imageVC.image = cell.buyItemImage.image
          self.navigationController?.presentViewController(imageVC, animated: false, completion: nil)
        }
 
      return cell
      
    case tableCellSection.TitleSection:
      let cell = tableView.dequeueReusableCellWithIdentifier(titleCellIdentifier, forIndexPath: indexPath) as! UPMBuyItemTitleCell
      cell.configureCell(listing?.title, price: listing?.displayPrice())
      return cell
    case tableCellSection.FieldSection:
       let cell = tableView.dequeueReusableCellWithIdentifier(fieldCellIdentifier, forIndexPath: indexPath) as! UPMBuyItemFieldCell
       
       configureFieldCells(cell, indexPath: indexPath)

      return cell
    
    case tableCellSection.DescriptionSection:
      let cell = tableView.dequeueReusableCellWithIdentifier(descriptionCellIdentifier, forIndexPath: indexPath) as! UPMBuyItemDescriptionCell
      cell.setDescription(listing?.descriptionS)
      return cell
      
    case tableCellSection.SellerSection:
      let cell = tableView.dequeueReusableCellWithIdentifier(sellerCellIdentifier, forIndexPath: indexPath) as! UPMBuyItemFieldCell
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

      cell.configureCell("Seller", second: "Seller Name")

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
    imageView.contentMode = .ScaleAspectFill
    return imageView
  }()
  
  lazy var scrollView: UIScrollView = {
    var scrollView = UIScrollView()
    scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
    scrollView.delegate = self
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
    
    var elements: [NSObject : AnyObject] = ["scrollView": scrollView, "imageView": imageView]
    
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[scrollView]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: elements))
    
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: .DirectionLeadingToTrailing, metrics: nil, views: elements))
    
    scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageView]|", options: .DirectionLeadingToTrailing, metrics: nil, views: elements))
    
    scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: elements))
    
    scrollView.addConstraint(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
    
    scrollView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: 0))
    
    scrollView.addGestureRecognizer(swpipeUpGestureRecognizer)
    
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

