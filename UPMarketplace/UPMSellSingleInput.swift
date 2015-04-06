//
//  UPMSellSingleInput.swift
//  UPMarketplace
//
//  Created by John Liedtke on 3/14/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import Foundation

struct UPMSellInput {
  typealias ConfigureTextField = ((textField: UITextField) -> ())
  var labelText: String
  var placeholderText: String
  var valueText: String?
  var textFieldConfigurer: ConfigureTextField?
  init(labelText: String, placeholderText: String, valueText: String?, textFieldConfigurer: ConfigureTextField?) {
    self.textFieldConfigurer = textFieldConfigurer
    self.labelText = labelText
    self.placeholderText = placeholderText
    self.valueText = valueText
  }
  
  init(labelText: String, textFieldConfigurer: ConfigureTextField?) {
    self.labelText = labelText
    self.placeholderText = ""
    self.textFieldConfigurer = textFieldConfigurer
  }
  
  init(labelText: String, valueText: String?, textFieldConfigurer: ConfigureTextField?) {
    self.labelText = labelText
    self.valueText = valueText
    self.placeholderText = ""
    self.textFieldConfigurer = textFieldConfigurer
  }
  
}

class UPMSellInputCell: UITableViewCell {
  
  // MARK: - Public Properties 
  
  lazy var textField: UITextField = {
    let tf = UITextField(forAutoLayout: true)
    tf.borderStyle = .RoundedRect
    return tf
  }()
  
  lazy var textFieldLabel: UILabel = {
    let label = UILabel(forAutoLayout: true)
    label.font = UIFont.standardHeaderTwoFont()
    return label
  }()

  // MARK: - Init
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .Default, reuseIdentifier: "UPMSellInputCell")
    setup()
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: - Layout
  
  private func setup() {
    contentView.addSubview(textField)
    contentView.addSubview(textFieldLabel)
    let ed: [NSObject: AnyObject] = ["textField": textField, "textFieldLabel": textFieldLabel]
    
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(hlp)-[textFieldLabel]-[textField]-(hrp)-|", options: .DirectionLeadingToTrailing, metrics: UPMStandards.autoLayoutMetrics, views: ed))
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[textField]-(>=8)-|", options: .DirectionLeadingToTrailing, metrics: UPMStandards.autoLayoutMetrics, views: ed))
    
    // Center label vertically with field
    contentView.addConstraint(NSLayoutConstraint(item: textFieldLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: textField, attribute: .CenterY, multiplier: 1.0, constant: 0))
    
    textField.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
    textFieldLabel.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
  }
  
}

internal class UPMSellSingleInput: UITableViewController, UITextFieldDelegate {

  lazy var dataSource: SingleSectionDataSource<UPMSellInput> = {
    var ds = SingleSectionDataSource(rows: [UPMSellInput](), cellConfigurator: {
      [weak self] (cell, row) in
      if let inputCell = cell as? UPMSellInputCell {
        if let configure = row.textFieldConfigurer {
          configure(textField: inputCell.textField)
        } else {
          inputCell.textField.placeholder = row.placeholderText
          inputCell.textField.text = row.valueText
          inputCell.textField.delegate = self
        }
        inputCell.textFieldLabel.text = row.labelText
      }
    })
    ds.reuseIdentifier = "UPMSellInputCell"
    return ds
    }()
  
  var dataCollectedHandler: (([String: String]) -> ())?
  
  // MARK: - View
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView = UITableView(frame: self.tableView.frame, style: .Grouped)
    tableView.registerClass(UPMSellInputCell.self, forCellReuseIdentifier: "UPMSellInputCell")
    tableView.dataSource = dataSource.tableViewDataSource
    tableView.allowsSelection = false
    view.backgroundColor = UIColor.standardBackgroundColor()
    
    // Done/Cancel buttons
    addDoneButtonToNavigationItemWithSelector("didPressDoneFromNavigation")
    addCancelButtontToNavigationItemWithSelector("didPressCancelFromNavigation")
  }
  
  func didPressCancelFromNavigation() {
    navigationController?.popViewControllerAnimated(true)
  }
  
  func didPressDoneFromNavigation() {
    
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    let textFieldPoint = textField.convertPoint(textField.frame.origin, toView: tableView)
    let textFieldIndexPath = tableView.indexPathForRowAtPoint(textFieldPoint)!
    var row = dataSource.getRow(textFieldIndexPath)
    row?.valueText = textField.text
    dataSource.rows[textFieldIndexPath.row] = row!
  }
  
  // MARK: - Textfield
  /**
  Handle what happend when done is pushed from the keyboard. Override to customize.
  
  :param: textField Textfield done was pushed from
  */
  func donePushed(textField: UITextField) {
    view.endEditing(true)
  }

  
  
  
}