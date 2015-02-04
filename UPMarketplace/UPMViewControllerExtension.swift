//
//  UPMViewControllerExtension.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/9/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//
import Foundation


extension UITextField {
  convenience init(forAutoLayout: Bool) {
    self.init()
    setTranslatesAutoresizingMaskIntoConstraints(false)
  }
}


extension UIView {
  
  func addBottomBorderWithColor(color: UIColor, andThickness thickness: CGFloat) {
    var border = CALayer()
    var frame = self.frame
    border.backgroundColor = color.CGColor
    border.frame = CGRectMake(0, self.frame.size.height - thickness, self.frame.size.width, thickness)
    layer.addSublayer(border)
  }
}

/**
Standards for things such as autolayout
*/
struct UPMStandards {
  
  /**
  Standard spacing for autolayout to pass in for metrics.
  
  - hlp Horizontal left padding
  - hrp Horizontal right padding
  - vlp Vertical left padding
  - vrp Vertical left padding
  */
  static let autoLayoutMetrics = ["hlp": 15.0, "hrp": 15.0, "vlp": 8.0, "vrp": 8.0]
}


/** 
Use the following fonts when creating UILabel and UITextView objects.
*/
extension UIFont {
  
  class func standardFontOfSize(fontSize: CGFloat) -> UIFont {
    return UIFont.systemFontOfSize(fontSize)
  }
  
  class func standardBoldFontOfSize(fontSize: CGFloat) -> UIFont {
    return UIFont.boldSystemFontOfSize(fontSize)
  }
  
  class func standardTitleFont() -> UIFont {
    return standardFontOfSize(20.0)
  }
  
  class func standardBoldTitleFont() -> UIFont {
    return standardFontOfSize(20.0)
  }
  
  class func standardHeaderOneFont() -> UIFont {
    return standardFontOfSize(17.0)
  }
  
  class func standardBoldHeaderOneFont() -> UIFont {
    return standardBoldFontOfSize(17.0)
  }
  
  class func standardHeaderTwoFont() -> UIFont {
    return standardFontOfSize(16.0)
  }
  
  class func standardBoldHeaderTwoFont() -> UIFont {
    return standardBoldFontOfSize(16.0)
  }
  
  class func standardTextFont() -> UIFont {
    return standardFontOfSize(14.0)
  }
  
  class func standardBolTextFont() -> UIFont {
    return standardBoldFontOfSize(14.0)
  }
}


extension UILabel {
  
  /**
  Prepares the label for autoLayout by setting
  setTranslatesAutoresizingMaskIntoConstraints to false.
  */
  convenience init(forAutoLayout: Bool) {
    self.init()
    setTranslatesAutoresizingMaskIntoConstraints(false)
  }
  
  /**
  Creates a UILabel with the proper font and text color.
  */
  class func standardCaptionLabel(forAutoLayout: Bool) -> UILabel {
    var label = UILabel(forAutoLayout: forAutoLayout)
    label.font = UIFont.standardTextFont()
    label.textColor = UIColor.flatDarkGrayColor()
    return label
  }
}


extension UIViewController {
  
  func addCancelButtontToNavigationItemWithSelector(selector: String) {
    var cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: NSSelectorFromString(selector))
    navigationItem.setLeftBarButtonItem(cancelButton, animated: true)

  }
  
  func addDoneButtonToNavigationItemWithSelector(selector: String) {
    var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: NSSelectorFromString(selector))
    navigationItem.setRightBarButtonItem(doneButton, animated: true)
  }
  
  func getNavigationBarHeight() -> CGFloat {
    if let height = self.navigationController?.navigationBar.frame.height {
      return height
    } else {
      return 0
    }
  }
}

extension String {
  subscript (i: Int) -> String {
    return String(Array(self)[i])
  }
}

extension Double {
  func toString() -> String {
    return String(format: "%.2f",self)
  }
}
