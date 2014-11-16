//
//  UPMSellPriceFormatTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 11/15/14.
//  Copyright (c) 2014 UP Marketplace. All rights reserved.
//

import UIKit


protocol UPMSellPriceFormatDelegate {
  func updatedPriceFormat(price: Double, limit: Double?, oBo: Bool)
}

class UPMSellPriceFormatTVC: UITableViewController, UITextFieldDelegate {
  
  var delegate: UPMSellPriceFormatDelegate?
  var price: Double = 0.00
  var oBO: Bool = false
  var limit: Double = 0.00
  
  @IBOutlet var priceField: UITextField!
  @IBOutlet var oBOSwitch: UISwitch!
  @IBOutlet var limitField: UITextField!
  

  override func viewDidLoad() {
      super.viewDidLoad()
    
    
    addDoneButtonToNavigationItemWithSelector("didPressDoneButton:")
    addCancelButtontToNavigationItemWithSelector("didPressCancelButton:")
    // [yourSwitchObject addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    oBOSwitch.addTarget(self, action: "didChangeOBOSwitchState:", forControlEvents: UIControlEvents.ValueChanged)
    
  //  priceField.setN

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    var numberSet = NSCharacterSet.decimalDigitCharacterSet().mutableCopy() as NSMutableCharacterSet
    numberSet.formIntersectionWithCharacterSet(NSCharacterSet.whitespaceCharacterSet())
    var nonNumberSet = numberSet.invertedSet
  
    
    
    var result = false
    if countElements(string) == 0 {
      result = true
    } else if countElements(string.stringByTrimmingCharactersInSet(nonNumberSet)) > 0 {
      
    }
    
    if (result) {
      var mstring = textField.text as String
      
      if countElements(mstring) == 0 {
        var locale = NSLocale.currentLocale().objectForKey(NSLocaleCurrencySymbol) as String
        mstring += locale
        mstring += string
       
      } else {
        if countElements(string) > 0 {
          var mstringCopy = NSMutableString(string: mstring)
//          mstring.insert(string, atIndex: range.location)
          mstringCopy.insertString(string, atIndex: range.location)
          mstring = String(mstringCopy)
        } else {
          var mstringCopy = NSMutableString(string: mstring)
          mstringCopy.deleteCharactersInRange(range)
          mstring = String(mstringCopy)

        }
      }
    }

//    //here we deal with the UITextField on our own
//    if(result){
//      //grab a mutable copy of what's currently in the UITextField
//      NSMutableString* mstring = [[textField text] mutableCopy];
//      if([mstring length] == 0){
//        //special case...nothing in the field yet, so set a currency symbol first
//        [mstring appendString:[[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol]];
//        
//        //now append the replacement string
//        [mstring appendString:string];
//      }
//      else{
//        //adding a char or deleting?
//        if([string length] > 0){
//          [mstring insertString:string atIndex:range.location];
//        }
//        else {
//          //delete case - the length of replacement string is zero for a delete
//          [mstring deleteCharactersInRange:range];
//        }
//      }
//      
//      //to get the grouping separators properly placed
//      //first convert the string into a number. The function
//      //will ignore any grouping symbols already present -- NOT in iOS4!
//      //fix added below - remove locale specific currency separators first
//      NSString* localeSeparator = [[NSLocale currentLocale]
//        objectForKey:NSLocaleGroupingSeparator];
//      NSNumber* number = [currencyFormatter numberFromString:[mstring
//        stringByReplacingOccurrencesOfString:localeSeparator
//        withString:@""]];
//      [mstring release];
//      
//      //now format the number back to the proper currency string
//      //and get the grouping separators added in and put it in the UITextField
//      [textField setText:[currencyFormatter stringFromNumber:number]];
//    }
//    
//    //always return no since we are manually changing the text field
//    return NO;
    
    return true
    
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    
  }
  
  func didPressDoneButton(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
    
  }
  
  func didPressCancelButton(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
    
  }
  
  func didChangeOBOSwitchState(sender: AnyObject) {
    tableView.reloadData()
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
      return oBOSwitch.on ? 3 : 2
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
