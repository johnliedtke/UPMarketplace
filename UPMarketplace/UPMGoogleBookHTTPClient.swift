//
//  UPMGoogleBookHTTPClient.swift
//  UPMarketplace
//
//  Created by John Liedtke on 12/30/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit

/// Does nothing at the moment....

protocol UPMGoogleBookHTTPClientDelegate {
  
}

/*
//https://www.googleapis.com/books/v1/volumes?q=isbn:<your_isbn_here>
var apiKey = "AIzaSyBRkLoyss25C1Rh65Q-mlTe-k-dXBt6ofw"
var url : String = "https://www.googleapis.com/books/v1/volumes?q=isbn:9788131722428" + "&key=" + apiKey
var request : NSMutableURLRequest = NSMutableURLRequest()
request.URL = NSURL(string: url)
request.HTTPMethod = "GET"

NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
  var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
  let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
  
  if (jsonResult != nil) {
    // process jsonResult
  } else {
    // couldn't load JSON, look at error
  }
 */


class UPMGoogleBookHTTPClient: AFHTTPSessionManager {
  
  let API_KEY = "AIzaSyBRkLoyss25C1Rh65Q-mlTe-k-dXBt6ofw"
  let BASE_URL = "https://www.googleapis.com/books/"
  
  var delegate: UPMGoogleBookHTTPClientDelegate?
  
//  class func sharedGoogleBookHTTPClient() -> UPMGoogleBookHTTPClient {
//    //static var sharedGoogleBookHTTPClient: UPMGoogleBookHTTPClient? = nil
//  }
   
}




















