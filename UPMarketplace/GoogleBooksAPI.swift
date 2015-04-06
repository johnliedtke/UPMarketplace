//
//  GoogleBooksAPI.swift
//  UPMarketplace
//
//  Created by John Liedtke on 3/12/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import Foundation

extension UPMTextbook {

  class func createBookFromJSON(inputData: NSData) -> UPMTextbook {
    var textbook = UPMTextbook()
    
    var jsonData = GoogleBooksAPI.parseJSON(inputData)
    
    // Some horrible parsing of JSONh
    if let dict = jsonData.dictionary where jsonData.error == nil {
      if let items = dict["items"] as? NSArray, let bookDict = items.firstObject as? NSDictionary {
        if let volumeInfo = bookDict["volumeInfo"] as? NSDictionary, let title = volumeInfo["title"] as? String, let authors = volumeInfo["authors"] as? [String], let imageDict = volumeInfo["imageLinks"] as? [String: String], let description = volumeInfo["description"] as? String {//
         if let isbns = volumeInfo["industryIdentifiers"] as? [[String: String]] {
          if let isbn10 = isbns.filter({ $0["type"] == "ISBN_10"}).first!["identifier"] {
            textbook.iSBN10 = isbn10
          }
          if let isbn13 = isbns.filter({ $0["type"] == "ISBN_13"}).first!["identifier"] {
            textbook.iSBN13 = isbn13
          }
          //if let imageURL =
          if let imageURL = imageDict["thumbnail"] {
            textbook.imageURL = imageURL
          }
          
          textbook.title = title
          textbook.bookDescription = description
          textbook.authors = ", ".join(authors)
          return textbook
        }
      }
      }
    }
    return UPMTextbook(className: "UPMTextbook")
  }
}

/**
  Used to do basic interactions with the Google Books REST API
*/
class GoogleBooksAPI {
  
  static private let baseURL = "https://www.googleapis.com/books/v1/volumes"
  static private let key = "AIzaSyBRkLoyss25C1Rh65Q-mlTe-k-dXBt6ofw"
  
  func standardURL() -> String {
    var url = GoogleBooksAPI.baseURL + "&key" + GoogleBooksAPI.key
    return url
  }
  
  func searchByISBNURL(#ISBN: String) -> NSURL? {
    return NSURL(string: GoogleBooksAPI.baseURL + "?q=isbn:" + ISBN + "&key" + GoogleBooksAPI.key)
  }
  
  func searchByISBNURL(#ISBN: String, fields: String) -> NSURL? {
    if let isbnURL = searchByISBNURL(ISBN: ISBN)?.absoluteString {
      return NSURL(string: isbnURL + "&fields=" + fields)
    }
    return nil
  }
  
  class func getJSON(urlToRequest: NSURL) -> NSData? {
    return NSData(contentsOfURL: urlToRequest)
  }
  
  class func getJSON(urlToRequest: String) -> NSData? {
    if let url = NSURL(string: urlToRequest) {
      return NSData(contentsOfURL: url)!
    }
    return nil
  }
  
  class func parseJSON(inputData: NSData) -> (dictionary: NSDictionary?, error: NSError?) {
    var error: NSError?
    var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
    
    return (boardsDictionary, error)
  }

  /*
  var bookURL = "https://www.googleapis.com/books/v1/volumes?q=isbn:9780262033848&key=AIzaSyBRkLoyss25C1Rh65Q-mlTe-k-dXBt6ofw&fields=kind,items(volumeInfo(title,authors,imageLinks))"
  
  //https://www.googleapis.com/books/v1/volumes?q=isbn:0735619670
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
  if let bookData = getJSON(bookURL) {
  var parseJSON = parseJSON(bookData)
  println("worked?")
  }
  })
  */
  
}
