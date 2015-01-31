//
//  UPMAccountReservedTVC.swift
//  UPMarketplace
//
//  Created by John Liedtke on 1/28/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit


public class UPMAccountListingCell: PFTableViewCell {
  
  // MARK: - Public Properties
  
  lazy var titleLabel: UILabel = {
    var label = UILabelVertical()
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(label)
    label.numberOfLines = 0
    label.font = UIFont.boldSystemFontOfSize(16.0)
    //label.backgroundColor = UIColor.flatLightOrangeColor()
    return label
  }()
  
  lazy var statusLabel: UILabel = {
    var label = UILabelVertical()
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(label)
    label.numberOfLines = 0
    label.font = UIFont.systemFontOfSize(14.0)
    label.textColor = UIColor.flatDarkGreenColor()
    //label.backgroundColor = UIColor.flatDarkTealColor()
    return label
  }()
  
  lazy var priceLabel: UILabel = {
    var label = UILabelVertical()
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(label)
    label.numberOfLines = 0
    label.font = UIFont.systemFontOfSize(14.0)
    //label.backgroundColor = UIColor.flatLightGreenColor()
    label.text = "$5.00"
    return label
  }()
  
  lazy var displayImageView: UIImageView = {
    var iv = UIImageView()
    iv.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.contentView.addSubview(iv)
    iv.backgroundColor = UIColor.flatLightPurpleColor()
    return iv
  }()
  
  
  // MARK: - Private Properties
  
  
  // MARK: - Pubic Methods
  
  /**
  Initializes the layout of the cell.
  */
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    // Should adjust according to screen size
    let imageHeight = 60.0
    let imageWidth = 60.0
    let bottomMargin = 8.0
    
    // View dictionary
    var ed = NSDictionary(dictionary: ["titleLabel": titleLabel, "statusLabel": statusLabel, "displayImageView": displayImageView, "priceLabel": priceLabel])
    
    
    // Horizontal layout
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-[displayImageView(\(imageHeight))]-[titleLabel]-|",
      options: .DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-[displayImageView]-[statusLabel]-[priceLabel]-|",
      options: .DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
    // Vertical layout
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-[displayImageView(\(imageHeight))]-(>=8)-|",
      options: .DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-[titleLabel]-[statusLabel]-|",
      options: .DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-[titleLabel]-[priceLabel]-|",
      options: .DirectionLeadingToTrailing,
      metrics: nil,
      views: ed))

    // Make the titleLabel grow faster
    titleLabel.setContentHuggingPriority(400, forAxis: UILayoutConstraintAxis.Vertical)
    statusLabel.setContentHuggingPriority(800, forAxis: UILayoutConstraintAxis.Vertical)

  }
  
  /**
  Changes the color of the statusLabel corresponding to the status parameter.

  :param: status Status of a UPMListing
  */
  internal func changeStatusColor(status: UPMReservation.reservationStatus) {
    switch status {
    case .Accepted:
      statusLabel.textColor = UIColor.flatDarkGreenColor()
    case .Waiting:
      statusLabel.textColor = UIColor.flatDarkOrangeColor()
    case .Rejected:
      statusLabel.textColor = UIColor.flatDarkRedColor()
    default:
      statusLabel.textColor = UIColor.flatLightBlueColor()
    }
  }
  
  // MARK: Private Methods

  required public init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
}

class UPMAccountReservedTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
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