//
//  UPMBuyTextbookFilter.swift
//  UPMarketplace
//
//  Created by John Liedtke on 4/3/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import UIKit


struct TextbookFilter: Filter {
  var condition: String
  var price: Double
  var isbn: String?
  var course: String?
  
  init(isbn: String?, course: String?) {
    self.condition = ""
    self.price = 1.0
    self.isbn = isbn
    self.course = course
  }
  
  mutating func clearFilter() {
    course = nil
    isbn = nil
  }

}


class UPMBuyTextbookFilter: UITableViewController {
  
  var textbookFilter = TextbookFilter(isbn: nil, course: nil)
  
  
  weak var delegate: UPMFilterDelegate?

  /// Clear section
  lazy private var clearSection = Section(rows: ["Clear"])
  
  /// Tag section
  lazy private var isbnCourseSection = Section(header: "ISBN or Course", rows: [String]())
  
  /// Datasource
  lazy private var dataSource: SectionedDataSource<String> = SectionedDataSource(sections: [self.clearSection,self.isbnCourseSection]) {
    (cell, row) in
    cell.textLabel?.text = row
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView = UITableView(frame: tableView.bounds, style: .Grouped)
    tableView.backgroundColor = UIColor.standardBackgroundColor()
    tableView.dataSource = dataSource.tableViewDataSource
    navigationItem.title = "Filter"
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "didSelectDone")
    
    isbnCourseSection.rows = ["ISBN: " + (textbookFilter.isbn ?? "Select"), "Course: " + (textbookFilter.course ?? "Select ")]

  }
  
  func didSelectDone() {
    if let d = delegate {
      d.didFinishFiltering(self, filter: textbookFilter)
    }
  }
  
  private func clear() {
    isbnCourseSection.rows = ["ISBN: Select", "Course: Select"]
    textbookFilter.clearFilter()
    tableView.reloadData()
  }
  
  
  // MARK: - TableView Delegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if dataSource.sections[indexPath.section].header == clearSection.header {
      clear()
      
    } else if dataSource.sections[indexPath.section].header == isbnCourseSection.header {
      let courseISBNVC = UPMSellTextbookRequiredDeatils()
      courseISBNVC.currentTextbookDetails = ["isbn": textbookFilter.isbn, "course": textbookFilter.course]
      courseISBNVC.dataCollectedHandler = {
        [unowned self] (dict) in
        let isbn = "ISBN: " + (dict["isbn"] ?? "Select")
        let course = "Course: " +  (dict["course"] ?? "Select")

        self.textbookFilter.isbn = dict["isbn"] == nil || dict["isbn"] == "" ? nil : dict["isbn"]
        self.textbookFilter.course = dict["course"] == nil || dict["course"] == "" ? nil : dict["course"]
        self.dataSource.sections[indexPath.section].rows[0] = isbn
        self.dataSource.sections[indexPath.section].rows[1] = course

        tableView.reloadData()
      } 

      navigationController?.pushViewController(courseISBNVC, animated: true)
      
    }
    
  }

  
  
  
  
  
  
  

  


}
