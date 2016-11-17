//
//  CCP.swift
//  XcodeWeshCCP
//
//  Created by Yoann Cribier on 16/11/2016.
//  Copyright © 2016 akabab. All rights reserved.
//

import XcodeKit
import AppKit

protocol CCPHandler {

  func copy(from buffer: XCSourceTextBuffer)

  func cut(from buffer: XCSourceTextBuffer)

  func paste(from buffer: XCSourceTextBuffer)

}

extension CCPHandler {

  var pasteboard: NSPasteboard {
    return NSPasteboard.general()
  }

}

class WeshCCPHandler: CCPHandler {

  func copy(from buffer: XCSourceTextBuffer) {
    guard let cursorLineIndex = buffer.cursorLineIndex else { return }

    pasteboard.clearContents()

    if let currentLineContent = buffer.lines[cursorLineIndex] as? String {
      pasteboard.setString(currentLineContent, forType: NSPasteboardTypeString)
    }
  }

  func cut(from buffer: XCSourceTextBuffer) {
    guard let cursorLineIndex = buffer.cursorLineIndex else { return }

    self.copy(from: buffer)

    buffer.lines.removeObject(at: cursorLineIndex)
  }

  func paste(from buffer: XCSourceTextBuffer) {
    guard let cursorLineIndex = buffer.cursorLineIndex else { return }

    if let pasteboardContent = pasteboard.string(forType: NSPasteboardTypeString) {
      buffer.lines.insert(pasteboardContent, at: cursorLineIndex)
    }
  }

}

class OriginalCCPHandler: CCPHandler {

  func copy(from buffer: XCSourceTextBuffer) {
    print("original copy")

    guard let selection = buffer.selections.firstObject as? XCSourceTextRange else { return }

    pasteboard.clearContents()

    let start = selection.start
    let end = selection.end

    var strings = [String]()
    for index in start.line...end.line {
      let currentLine = buffer.lines[index] as! String

      var content = ""
      if index == start.line && index == end.line {
        let startIndex = currentLine.index(currentLine.startIndex, offsetBy: start.column)
        let endIndex = currentLine.index(currentLine.startIndex, offsetBy: end.column)
        content = currentLine.substring(with: startIndex..<endIndex)
      } else if index == start.line {
        let startIndex = currentLine.index(currentLine.startIndex, offsetBy: start.column)
        content = currentLine.substring(from: startIndex)
      } else if index == end.line {
        let endIndex = currentLine.index(currentLine.startIndex, offsetBy: end.column)
        content = currentLine.substring(to: endIndex)
      } else {
        content = currentLine
      }

      print("new line content: '\(content)'")
      strings.append(content)
    }

    pasteboard.setString(strings.joined(), forType: NSPasteboardTypeString)
  }

  func cut(from buffer: XCSourceTextBuffer) {
    print("original cut")

    guard let selection = buffer.selections.firstObject as? XCSourceTextRange else { return }

    self.copy(from: buffer)

    let start = selection.start
    let end = selection.end

    let startLine = buffer.lines[start.line] as! String
    let toColumnIndex = startLine.index(startLine.startIndex, offsetBy: start.column)
    let startPart = startLine.substring(to: toColumnIndex)

    let endLine = buffer.lines[end.line] as! String
    let fromColumnIndex = endLine.index(endLine.startIndex, offsetBy: end.column)
    let endPart = endLine.substring(with: fromColumnIndex..<endLine.index(endLine.endIndex, offsetBy: -1)) // trim \n

    print("startPart: '\(startPart)'")
    print("endPart: '\(endPart)'")

    let joinedContent = startPart + endPart

    // remove selection from buffer
    let range = Range(uncheckedBounds: (lower: start.line, upper: min(end.line + 1, buffer.lines.count)))
    print("range:", range)
    buffer.lines.replaceObjects(in: NSRange.init(range), withObjectsFrom: [ joinedContent ])

    // set cursor position at the end
    let cursorPosition = XCSourceTextPosition(line: start.line, column: start.column)
    print("cursorPosition:", cursorPosition)
    let newSelection = XCSourceTextRange(start: cursorPosition, end: cursorPosition)

    print("newSelection:", newSelection)
    let updatedSelection = [ newSelection ]

    print("updatedSelection:", updatedSelection)
    buffer.selections.setArray(updatedSelection)
  }

  func paste(from buffer: XCSourceTextBuffer) {
    print("original paste")

    guard let selection = buffer.selections.firstObject as? XCSourceTextRange else { return }

    // remove selection content
    let start = selection.start
    let end = selection.end

    let startLine = buffer.lines[start.line] as! String
    let toColumnIndex = startLine.index(startLine.startIndex, offsetBy: start.column)
    let startPart = startLine.substring(to: toColumnIndex)

    let endLine = buffer.lines[end.line] as! String
    let fromColumnIndex = endLine.index(endLine.startIndex, offsetBy: end.column)
    let endPart = endLine.substring(with: fromColumnIndex..<endLine.index(endLine.endIndex, offsetBy: -1)) // trim \n

    print("startPart: '\(startPart)'")
    print("endPart: '\(endPart)'")

    // insert pasteboard content
    if let pasteboardContent = pasteboard.string(forType: NSPasteboardTypeString) {

      let joined = [startPart, pasteboardContent, endPart].joined()
      print("joined:", joined)
      let contentLines = joined.components(separatedBy: "\n")
      print("content:", contentLines)

      let range = Range(uncheckedBounds: (lower: start.line, upper: min(end.line + 1, buffer.lines.count)))
      print("range:", range)

      buffer.lines.replaceObjects(in: NSRange.init(range), withObjectsFrom: contentLines)

      // set cursor position at the end
      let column = contentLines[contentLines.count - 1].characters.count - endPart.characters.count
      let cursorPosition = XCSourceTextPosition(line: start.line + contentLines.count - 1, column: column)
      print("cursorPosition:", cursorPosition)
      let newSelection = XCSourceTextRange(start: cursorPosition, end: cursorPosition)

      print("newSelection:", newSelection)
      let updatedSelection = [ newSelection ]

      print("updatedSelection:", updatedSelection)
      buffer.selections.setArray(updatedSelection)
    }

  }
  
}
