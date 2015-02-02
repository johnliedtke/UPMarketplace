//
//  UPMColorExtension.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/8/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

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
  
  /**
  Converts a hexadecimal represenation of a color to a UIColor
  
  :param: hex Hex triplet
  */
  convenience init(hex:Int) {
    self.init(red:(hex >> 0x10) & 0xff, green:(hex >> 0x8) & 0xff, blue:hex & 0xff)
  }
  
  // MARK: Flat UI Colors 
  
  class func flatLightRedColor() -> UIColor {
    return self.init(hex:0xe74c3c)
  }
  
  class func flatDarkRedColor() -> UIColor {
    return self.init(hex: 0xc0392b)
  }
  
  class func flatLightOrangeColor() -> UIColor {
    return self.init(hex: 0xe67e22)
  }
  
  class func flatDarkOrangeColor() -> UIColor {
    return self.init(hex: 0xd35400)
  }
  
  class func flatLightGreenColor() -> UIColor {
    return self.init(hex: 0x2ecc71)
  }
  
  class func flatDarkGreenColor() -> UIColor {
    return self.init(hex: 0x27ae60)
  }
  
  class func flatLightTealColor() -> UIColor {
    return self.init(hex: 0x1abc9c)
  }
  
  class func flatDarkTealColor() -> UIColor {
    return self.init(hex: 0x16a085)
  }
  
  class func flatLightBlueColor() -> UIColor {
    return self.init(hex: 0x3498db)
  }
  
  class func flatDarkBlueColor() -> UIColor {
    return self.init(hex: 0x2980b9)
  }
  
  class func flatLightPurpleColor() -> UIColor {
    return self.init(hex: 0x9b59b6)
  }
  
  class func flatDarkPurpleColor() -> UIColor {
    return self.init(hex: 0x8e44ad)
  }
  
  class func flatLightWhiteColor() -> UIColor {
    return self.init(hex: 0xecf0f1)
  }
  
  class func flatDarkWhiteColor() -> UIColor {
    return self.init(hex: 0xbdc3c7)
  }
  
  class func flatLightGrayColor() -> UIColor {
    return self.init(hex: 0x95a5a6)
  }
  
  class func flatDarkGrayColor() -> UIColor {
    return self.init(hex: 0x7f8c8d)
  }
  
  class func flatLightBlackColor() -> UIColor {
    return self.init(hex: 0x34495e)
  }
  
  class func flatDarkBlackColor() -> UIColor {
    return self.init(hex: 0x2c3e50)
  }
  
  
  /// Varient of light orange
  class func flatLightYellowColor() -> UIColor {
    return self.init(hex: 0xf39c12)
  }
  
  
  
  
  /// Background color of basically every view.
  class func standardBackgroundColor() -> UIColor {
    var standardBackgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    return standardBackgroundColor
  }

  class func flatGreenColor() -> UIColor {
      return UIColor(red: 46.0/255.0, green: 204.0/255.0, blue: 113.0/255.0, alpha: 1.0)
  }
  
//  class func flatLightGrayColor() -> UIColor {
//      return UIColor(hex: 0xbdc3c7)
//  }
  
  class func lightPurpleColor() -> UIColor {
    return UIColor.flatLightPurpleColor()
    //var lightPurpleColor = UIColor(red: 134.0/255.0, green: 92.0/255.0, blue: 168.0/255.0, alpha: 1.0)
    //return lightPurpleColor
  }
  
  class func darkPurpleColor() -> UIColor {
    var lightPurpleColor = UIColor(red: 142.0/255.0, green: 26.0/255.0, blue: 173.0/255.0, alpha: 1.0)
    return lightPurpleColor
  }
  
  class func tabBarUnselectedColor() -> UIColor {
    return UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1.0)
  }

  
}