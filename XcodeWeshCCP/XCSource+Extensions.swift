//
//  XCSource+Extensions.swift
//  XcodeWeshExtensions
//
//  Created by Yoann Cribier on 17/11/2016.
//  Copyright © 2016 akabab. All rights reserved.
//

import XcodeKit

extension XCSourceTextPosition: Equatable {

  public static func ==(lhs: XCSourceTextPosition, rhs: XCSourceTextPosition) -> Bool {
    return lhs.line == rhs.line && lhs.column == rhs.column
  }

}

extension XCSourceTextBuffer {

  var cursorLineIndex: Int? {
    guard let firstSelection = self.selections.firstObject as? XCSourceTextRange else { return nil }

    return firstSelection.start.line
  }

}

extension XCSourceTextRange {

  var isInsertionPoint: Bool {
    return start == end
  }
  
}
