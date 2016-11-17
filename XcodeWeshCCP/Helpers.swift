//
//  Helpers.swift
//  XcodeWeshCCP
//
//  Created by Yoann Cribier on 16/11/2016.
//  Copyright © 2016 akabab. All rights reserved.
//

import XcodeKit
import AppKit

extension NSPasteboard {

  var contentString: String {
    get {
      return self.string(forType: NSPasteboardTypeString) ?? ""
    }
    set {
      self.setString(newValue, forType: NSPasteboardTypeString)
    }
  }
  
}


extension NSArray {

  func filterByType<T>() -> [T] {
    return self.filter { $0 as? T != nil }.map { $0 as! T }
  }

}


extension String {

  var length: Int {
    return self.characters.count
  }

  func removeOccurrences(of occurrence: String) -> String {
    return self.replacingOccurrences(of: occurrence, with: "")
  }

  func substring(with range: Range<Int>) -> String? {
    let indices = self.characters.indices

    guard range.lowerBound >= 0 && range.lowerBound < indices.count && range.upperBound <= indices.count else {
      return nil
    }

    let start = self.characters.index(self.startIndex, offsetBy: range.lowerBound)
    let end = self.characters.index(self.startIndex, offsetBy: range.upperBound)

    return self.substring(with: start..<end)
  }


  subscript(range: Range<Int>) -> String? {
    return substring(with: range)
  }


  func substring(from index: Int) -> String? {
    guard abs(index) < self.length else {
      return nil
    }

    let fromIndex = index > 0 ? self.characters.index(self.startIndex, offsetBy: index) : self.characters.index(self.endIndex, offsetBy: index)

    return self.substring(from: fromIndex)
  }


  func substring(to index: Int) -> String? {
    guard abs(index) < self.length else {
      return nil
    }

    let toIndex = index > 0 ? self.characters.index(self.startIndex, offsetBy: index) : self.characters.index(self.endIndex, offsetBy: index)

    return self.substring(to: toIndex)
  }


  subscript(i: Int) -> Character? {
    guard i < self.length else { return nil }

    return Array(self.characters)[i]
  }

}
