//
//  UPMSellTextbookTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/24/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

class UPMSellTextbookTVC: UPMSellTVC, UPMSellDetailsTVCDelegate, UPMBarcodeScannerDelegate {
  
  var textbookListing: UPMTextbookListing = UPMTextbookListing.initListing()
  
  /// The book scanned using the barcode scanner
  private var scannedTextbook: UPMTextbook!

  override var listing: UPMListing? {
    get { return textbookListing }
    set { if newValue is UPMTextbookListing { textbookListing = newValue as! UPMTextbookListing } }
  }

  let CategoryTag = "Category"

  // MARK: - View

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.estimatedRowHeight = 100
    refreshDetailDescriptions()
    scanISBNAlert()
  }


  // MARK: - Details

  func didDetailsUpdate(details: String, isComplete: Bool) {
    requiredItems.updateItemWithTitle(RequiredItems.Details.rawValue, description: textbookListing.displayRequiredFields("Select") + "\nOptional Details\n" + textbookListing.displayOptionalFields("Select"), isComplete: isComplete)
  }
  
  override func pushDetailsVC() {
    var detailsVC = UPMSellTextbookDetailsTVC()
    detailsVC.listing = listing
    detailsVC.delegate = self
    navigationController?.pushViewController(detailsVC, animated: true)
  }
  
  func scanISBNAlert() {
    if !isUpdatingListing {
      let isbnSheet = UIAlertController(title: "Scan ISBN", message: "Do you want prefill fields by scanning your book's barcode?", preferredStyle:  .ActionSheet)
      
      isbnSheet.addAction(UIAlertAction(title: "Scan", style: .Default) {
        (action) in
        let barcodeScannerVC = UPMBarcodeScanner()
        barcodeScannerVC.delegate = self
        barcodeScannerVC.barcodeReadHandler = { (isbn) in
          let bookTask = BFTaskCompletionSource()
          
          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var google = GoogleBooksAPI()
            var url = google.searchByISBNURL(ISBN: isbn, fields: "kind,items(volumeInfo(title,authors,imageLinks,publishedDate,industryIdentifiers,description))")
            var bookJSON = GoogleBooksAPI.getJSON(url!)
            
            var dict = GoogleBooksAPI.parseJSON(bookJSON!)
            var textbook = UPMTextbook.createBookFromJSON(bookJSON!)
            
            if let title = textbook.title, let authors = textbook.authors {
              var isbns = "ISBN10: \(textbook.iSBN10!)\nISBN13: \(textbook.iSBN13!)"
              self.scannedTextbook = textbook
              bookTask.setResult(title + "\n" + authors + "\n" + isbns)
            } else {
              bookTask.setError(NSError.createError("Could not find textbok information.", failureReason: "Bad Read", suggestion: "Try again, or enter info manually"))
            }
          }
          return bookTask.task
        }
        self.navigationController?.presentViewController(UINavigationController(rootViewController: barcodeScannerVC), animated: true, completion: nil)
      })
      
      isbnSheet.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: nil))
      
      presentViewController(isbnSheet, animated: true, completion: nil)
    }
  }

  func refreshDetailDescriptions() {
    // textbookListing.textbook.course != nil &&
    didDetailsUpdate("", isComplete: textbookListing.textbook.iSBN13 != nil && textbookListing.textbook.course != nil )
  }
  
  func didReadBarcode(barcode: String, shouldUseBarCode: Bool) {
    if shouldUseBarCode {
      didUpdateTitle(scannedTextbook.title!)
      textbookListing.textbook = scannedTextbook
      listing?.descriptionS = scannedTextbook.bookDescription
      descriptionUpdated(scannedTextbook.bookDescription!)
      refreshDetailDescriptions()
      var manager = SDWebImageManager.sharedManager()
      if let url = NSURL(string: scannedTextbook.imageURL!) {
      manager.downloadImageWithURL(url, options: nil, progress: nil, completed: {
        (image, error, cacheType, finished, url) in
        dispatch_async(dispatch_get_main_queue(), {
          self.didUpdatePhoto(image)
          self.tableView.reloadData()
        })
        
      })
      }
    }
  }
  
  override func facebookDecription() -> String {
    var desc = textbookListing.descriptionS!
    if count(desc) > 50 {
      desc = desc.substringToIndex(advance(desc.startIndex, 49))
    }
    return textbookListing.displayRequiredFields("") + "\n" + desc
  }

}





