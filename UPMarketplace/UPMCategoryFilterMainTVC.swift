//
//  UPMCategoryFilterMainTVC.swift
//  UPMarketplace
//
//  Created by Krismy on 2/21/15.
//  Modified by John on 3/25/2015
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//


import UIKit

protocol Filter {
  var condition: String { get set }
  var price: Double { get set }
  mutating func clearFilter()
}

struct OtherFilter<T: Equatable>: Filter {
  var category: T?
  var tags: [T]?
  var condition: String
  var price: Double
  var clear = false
  
  init(category: T?, tags: [T], condition: String, price: Double) {
    self.category = category
    self.tags = tags
    self.condition = condition
    self.price = price
    self.clear = false
  }
  
  mutating func clearFilter() {
    tags?.removeAll(keepCapacity: false)
    category = nil
  }
  
  mutating func removeTag(tag: T) {
    tags = tags?.filter( { $0 != tag })
  }
  
  mutating func addTag(tag: T) {
    if let ts = self.tags where ts.filter({ $0 == tag }).isEmpty {
      tags?.append(tag)
    }
  }
  
}

protocol UPMFilterDelegate: class {
  func didFinishFiltering(sender: UIViewController, filter: Filter)
}

class UPMCategoryFilterMainTVC: UITableViewController, UPMTablePickerVCDelegate {

  // MARK: - Constants
  let filterCellIdentifier = "UPMBuyFilterCell"

  // MARK: - Public Properties

  // Delegate
  weak var delegate: UPMFilterDelegate?
  
  /// Filter for UPMOtherListings
  lazy var filter =  OtherFilter(category: nil, tags: [String](), condition: "", price: 0)
  
  // MARK: - Private
  
  /// Picker to choose category
  lazy private var categoryPickerTVC: UPMTablePickerVC = {
    var controller = UPMTablePickerVC()
    controller.datasource = SingleSectionDataSource(rows: UPMCategoryTag.categoryTagManager.categories())
    controller.delegate = self
    return controller
  }()
  
  /// Clear section
  lazy private var clearSection = Section(rows: ["Clear"])
  
  /// Tag section
  lazy private var tagSection = Section(header: "Select Tags", rows: [String](), value: "tag")
  
  /// Category section
  lazy private var categorySection = Section(header: "Choose a category", rows: ["Choose category"], value: "category")
  
  /// Datasource
  lazy private var dataSource: SectionedDataSource<String> = SectionedDataSource(sections: [self.clearSection,self.categorySection, self.tagSection]) {
    (cell, row) in
    cell.textLabel?.text = row
  }
  
  /// The indexPaths of the selected tag cells
  lazy private var selectedCells = [NSIndexPath: Bool]()
 
  // MARK: - View
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Filter"
    tableView = UITableView(frame: tableView.frame, style: .Grouped)
    tableView.estimatedRowHeight = 1000 // fix for auto-layout
    tableView.backgroundColor = UIColor.standardBackgroundColor()
    tableView.dataSource = dataSource.tableViewDataSource
    
    // Auto-layout
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "done")
  }

  /**
  User has selected the done button. Calls delegate
  */
  func done() {
    if let d = delegate {
      d.didFinishFiltering(self, filter: self.filter)
    }
  }
  
  // MARK: - Picker Delegate
  func didSelectItem(sender: UPMTablePickerVC, item: AnyObject?) {
    if sender == categoryPickerTVC, let category = item as? String {
      categorySection.rows[0] = category
      filter.category = category
      filter.tags?.removeAll(keepCapacity: false)
      selectedCells.removeAll(keepCapacity: false)
      tagSection.rows = UPMCategoryTag.categoryTagManager.tags()[category]!
      tableView.reloadData()
    }
  }

  /**
  Resets the filter
  */
  private func clearFilter() {
    filter.clearFilter()
    selectedCells.removeAll(keepCapacity: false)
    categorySection.rows[0] = "Choose cateogry"
    tagSection.rows.removeAll(keepCapacity: false)
    tableView.reloadData()
  }
  
  // MARK: - TableView Delegate

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    
    if dataSource.sections[indexPath.section].header == categorySection.header {
      self.navigationController?.pushViewController(categoryPickerTVC, animated: true)
      
    } else if dataSource.sections[indexPath.section].header == tagSection.header, let cell = cell {
      if cell.accessoryType == .Checkmark {
        cell.accessoryType = .None
        filter.removeTag(tagSection.rows[indexPath.row])
        selectedCells.removeValueForKey(indexPath)
      } else {
        cell.accessoryType = .Checkmark
        filter.addTag(tagSection.rows[indexPath.row])
        selectedCells[indexPath] = true
      }
    } else if dataSource.sections[indexPath.section].header == clearSection.header {
      clearFilter()
    }
  }
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if dataSource.sections[indexPath.section].header == tagSection.header && selectedCells[indexPath] != nil {
      cell.accessoryType = .Checkmark
    } else {
      cell.accessoryType = .None
    }
  }

}
