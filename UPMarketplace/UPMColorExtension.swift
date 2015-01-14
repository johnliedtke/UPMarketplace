//
//  UPMColorExtension.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/8/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import Foundation
import UIKit

/**
  Extra colors for the application. Defined are the standard colors the
  application will use throughtout the app. All are class methods that can
  be accessed via the UIColor class. e.g. UIColor.flatLightGrayColor()
*/
extension UIColor {
    
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  convenience init(netHex:Int) {
    self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
  }
  
  /// Background color of basically every view.
  class func standardBackgroundColor() -> UIColor {
    var standardBackgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    return standardBackgroundColor
  }

  class func flatGreenColor() -> UIColor {
      return UIColor(red: 46.0/255.0, green: 204.0/255.0, blue: 113.0/255.0, alpha: 1.0)
  }
  
  class func flatLightGrayColor() -> UIColor {
      return UIColor(netHex: 0xbdc3c7)
  }
  
  class func lightPurpleColor() -> UIColor {
    var lightPurpleColor = UIColor(red: 134.0/255.0, green: 92.0/255.0, blue: 168.0/255.0, alpha: 1.0)
    return lightPurpleColor
  }
  
  class func darkPurpleColor() -> UIColor {
    var lightPurpleColor = UIColor(red: 142.0/255.0, green: 26.0/255.0, blue: 173.0/255.0, alpha: 1.0)
    return lightPurpleColor
  }
  
  class func tabBarUnselectedColor() -> UIColor {
    return UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1.0)
  }

  
}