//
//  UPMBuyListItemsTextbookCVC.swift
//  UPMarketplace
//
//  Created by Krismy on 2/4/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit



class UPMBuyListItemsTextbookCVC: UPMBuyGridCVC, UPMFilterDelegate {
  // TODO: Make Clear Button reset the query to original State
  // TODO: Fix Issue of not showing first cell
  
  // MARK: - Public Properites
  var atFilter = false
  var category: String?
  
  /// Filter for textbooks
  var filter = TextbookFilter(isbn: nil, course: nil)

  
  override func query() -> PFQuery {
    var query = UPMTextbookListing.displayQuery()
    var textbookQuery = PFQuery(className: "UPMTextbook")
    if let course = filter.course {
      textbookQuery.whereKey("course", equalTo: course)
    }
    if let isbn = filter.isbn {
      textbookQuery.whereKey("iSBN13", equalTo: isbn)
    }
    if filter.isbn != nil || filter.course != nil {
    query.whereKey("textbook", matchesQuery: textbookQuery)
    }
    return query
  }
  
  // MARK: - View Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    var filterButton = UIBarButtonItem(title: "Filter", style: .Plain, target: self, action:Selector("goToRear"))
    revealViewController().navigationItem.rightBarButtonItem = filterButton
    revealViewController().navigationItem.title = "Textbooks"
    navigationItem.title = "Textbooks"
  }
  
  // MARK: - Data Source Methods
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath, withObject object: PFObject) -> Void {
    
    var listing = object as UPMTextbookListing
    let viewController = UPMBuyItemDetailsTextbookTVC(style: .Grouped)
    viewController.listingTextbook = listing
    navigationController?.pushViewController(viewController, animated: true)
    
  }
  
  func didFinishFiltering(sender: UIViewController, filter: Filter) {
    if let f = filter as? TextbookFilter {
      self.filter = f
    }
    goToRear()
    refresh()
  }
  
  // MARK: - Button Action
  func goToRear(){
    atFilter = !atFilter
    revealViewController().navigationController?.navigationBar.hidden = atFilter
    collectionView?.userInteractionEnabled = !atFilter
    self.revealViewController().rightRevealToggle(self)
  }

}
