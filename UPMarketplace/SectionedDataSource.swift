//
//  SectionedDataSource.swift
//  UPMarketplace
//
//  Created by John Liedtke on 3/2/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import Foundation

/**
* Represents a data source with arbitary sections with row type R.
* Use the tableViewDataSource property to feed this to a UITableView.
* Use the cellConfigurator or rowToString callbacks to configure the UITableViewCell.
*/
class SectionedDataSource<R> : SectionedDataSourceBridge {
  typealias RowToString = (R) -> (String)
  typealias CellConfigurator = (UITableViewCell!, R) -> (Void)
  var sections : [Section<R>] = []
  var reuseIdentifier = "Cell"
  
  var rowToString : RowToString = {
    r in
    return "\(r)"
  }
  
  var cellConfigurator : CellConfigurator = {
    cell, row in
  }
  
  lazy var tableViewDataSource : TableViewDataSource = TableViewDataSource(sectionedDataSource: self)
  
  // MARK: - Init
  init() {
    self.cellConfigurator = {
      (cell, row) in
      if let label = cell.textLabel {
        label.text = self.rowToString(row)
      }
    }
  }
  
  init(sections: [Section<R>], cellConfigurator: CellConfigurator) {
    self.sections = sections
    self.cellConfigurator = cellConfigurator
  }
  
  func getRow(row: Int, section : Int = 0) -> R? {
    return sections[section].rows[row]
  }
  
  func getRow(indexPath: NSIndexPath) -> R? {
    return getRow(indexPath.row, section: indexPath.section)
  }
  
  func populateCell(cell: UITableViewCell, row: R) {
    cellConfigurator(cell, row)
  }
  
  func numberOfSections() -> Int {
    return sections.count
  }
  
  func numberOfRowsInSection(section: Int) -> Int {
    return sections[section].rows.count
  }
  
  func cellForRowAtIndexPath(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
    var row = getRow(indexPath)
    var identifier = reuseIdentifier
    
    var cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
    
    if let row = row {
      populateCell(cell, row: row)
    }
    
    return cell
  }
  
  func titleForHeaderInSection(section: Int) -> String?  {
    return sections[section].header
  }
  
  func titleForFooterInSection(section: Int) -> String? {
    return sections[section].footer
  }
}
