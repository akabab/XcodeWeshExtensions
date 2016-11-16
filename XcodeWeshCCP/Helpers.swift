//
//  Helpers.swift
//  XcodeWeshCCP
//
//  Created by Yoann Cribier on 16/11/2016.
//  Copyright © 2016 akabab. All rights reserved.
//

import XcodeKit

extension NSArray {

  func filterByType<T>() -> [T] {
    return self.filter { $0 as? T != nil }.map { $0 as! T }
  }

}

extension XCSourceTextBuffer {

  var cursorLineIndex: Int? {
    let textSelections: [XCSourceTextRange] = self.selections.filterByType()
    return textSelections.first?.start.line
  }

}

extension XCSourceTextPosition: Equatable {

  public static func ==(lhs: XCSourceTextPosition, rhs: XCSourceTextPosition) -> Bool {
    return lhs.line == rhs.line && lhs.column == rhs.column
  }

}
