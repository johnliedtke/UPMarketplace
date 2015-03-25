//
//  Section.swift
//  UPMarketplace
//
//  Created by John Liedtke on 3/2/15.
//  Copyright (c) 2015 UP Marketplace. All rights reserved.
//

import Foundation

/**
* Represents a section with row datatype R
*/
class Section<R> {
  var header: String = ""
  var footer: String = ""
  var value: Any?
  var rows: [R] = []
  
  init(header: String)
  {
    self.header = header
  }
  
  init(header: String, value: Any?)
  {
    self.header = header
    self.value = value
  }
  
  init(rows: [R]) {
    self.rows = rows
  }
  
  init(header: String, rows: [R]) {
    self.header = header
    self.rows = rows
  }
  
  init(header: String, rows: [R], value: Any) {
    self.header = header
    self.rows = rows
    self.value = value
  }
}
