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
    if let dict = jsonData.dictionary  { // 1
      if jsonData.error == nil { // 2
        if let items = dict["items"] as? NSArray  { // 3
          if let bookDict = items.firstObject as? NSDictionary { // 4
            if let volumeInfo = bookDict["volumeInfo"] as? NSDictionary { // 5
              if let title = volumeInfo["title"] as? String { // 6
                if let authors = volumeInfo["authors"] as? [String] { // 7
                  if let imageDict = volumeInfo["imageLinks"] as? [String: String] { //8
                    if let description = volumeInfo["description"] as? String { // 9
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
                    }// end 9
                  } // end 8
                }// end 7
              } // end 6
            } // end 5
          } // end 4
        } // end 3
      } // end 2
    } // end 1
    return UPMTextbook(className: "UPMTextbook")
  }
}

/**
  Used to do basic interactions with the Google Books REST API
*/
class GoogleBooksAPI {
  
  let baseURL = "https://www.googleapis.com/books/v1/volumes"
  let key = "AIzaSyBRkLoyss25C1Rh65Q-mlTe-k-dXBt6ofw"
  
  func standardURL() -> String {
    var url = baseURL + "&key" + key
    return url
  }
  
  func searchByISBNURL(#ISBN: String) -> NSURL? {
    return NSURL(string: baseURL + "?q=isbn:" + ISBN + "&key" + self.key)
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
    var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
    
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
