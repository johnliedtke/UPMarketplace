//
//  SingleSectionDataSource.swift
//  UPMarketplace
//
//  Created by John Liedtke on 3/2/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import Foundation

/**
* A specialisation of SectionedDataSource which only has one section, and so exposes a rows property directly.
*/
class SingleSectionDataSource<R> : SectionedDataSource<R>
{
  override init() {
    super.init()
    sections = [Section(header: "")]
  }
  
  convenience init(rows : [R]) {
    self.init()
    self.rows = rows
  }
  
  convenience init( rows : [R], cellConfigurator: CellConfigurator) {
    self.init(rows: rows)
    self.cellConfigurator = cellConfigurator
  }
  
  var rows: [R] {
    get { return sections[0].rows }
    set { sections[0].rows = newValue }
  }
  
}