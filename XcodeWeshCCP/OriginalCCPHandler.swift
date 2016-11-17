//
//  OriginalCCPHandler.swift
//  XcodeWeshExtensions
//
//  Created by Yoann Cribier on 17/11/2016.
//  Copyright © 2016 akabab. All rights reserved.
//

import XcodeKit
import AppKit

class OriginalCCPHandler: CCPHandler {

  func copy(from buffer: XCSourceTextBuffer) {
    guard let selection = buffer.selections.firstObject as? XCSourceTextRange else { return }

    pasteboard.clearContents()

    pasteboard.contentString = content(of: selection, in: buffer).joined()
  }

  func cut(from buffer: XCSourceTextBuffer) {
    guard let selection = buffer.selections.firstObject as? XCSourceTextRange else { return }

    self.copy(from: buffer)

    // remove selection from buffer
    let start = selection.start, end = selection.end

    let startLine = buffer.lines[start.line] as! String
    let startPart = startLine.substring(to: start.column)!

    let endLine = buffer.lines[end.line] as! String
    let endPart = endLine.substring(from: end.column)!.removeOccurrences(of: "\n")

    let range = Range(uncheckedBounds: (lower: start.line, upper: min(end.line + 1, buffer.lines.count)))

    buffer.lines.replaceObjects(in: NSRange(range), withObjectsFrom: [ startPart + endPart ])


    // set cursor position at the end
    let cursorPosition = XCSourceTextPosition(line: start.line, column: start.column)

    let updatedSelection = [ XCSourceTextRange(start: cursorPosition, end: cursorPosition) ]
    buffer.selections.setArray(updatedSelection)
  }


  func paste(from buffer: XCSourceTextBuffer) {
    guard let selection = buffer.selections.firstObject as? XCSourceTextRange else { return }

    guard let pasteboardContent = pasteboard.string(forType: NSPasteboardTypeString) else { return }

    // remove selection from buffer
    let start = selection.start, end = selection.end

    let startLine = buffer.lines[start.line] as! String
    let startPart = startLine.substring(to: start.column)!

    let endLine = buffer.lines[end.line] as! String
    let endPart = endLine.substring(from: end.column)!.removeOccurrences(of: "\n")

    let contentJoined = startPart + pasteboardContent + endPart
    let contentLines = contentJoined.components(separatedBy: "\n")

    let range = Range(uncheckedBounds: (lower: start.line, upper: min(end.line + 1, buffer.lines.count)))

    buffer.lines.replaceObjects(in: NSRange(range), withObjectsFrom: contentLines)

    // set cursor position at the end
    let cursorLine = start.line + contentLines.count - 1
    let cursorColumn = contentLines[contentLines.count - 1].length - endPart.length
    let cursorPosition = XCSourceTextPosition(line: cursorLine, column: cursorColumn)
    
    let updatedSelection = [ XCSourceTextRange(start: cursorPosition, end: cursorPosition) ]
    buffer.selections.setArray(updatedSelection)
  }

}

extension OriginalCCPHandler {

  func content(of selection: XCSourceTextRange, in buffer: XCSourceTextBuffer) -> [String] {
    let start = selection.start, end = selection.end

    var contentLines: [String] = []

    for index in start.line...end.line {

      guard let currentLine = buffer.lines[index] as? String else { return [] }

      if index == start.line && index == end.line {
        contentLines += [ currentLine.substring(with: start.column..<end.column)! ]
      }

      else if index == start.line {
        contentLines += [ currentLine.substring(from: start.column)! ]
      }

      else if index == end.line {
        contentLines += [ currentLine.substring(to: end.column)! ]
      }
        
      else {
        contentLines += [ currentLine ]
      }
      
    }
    
    return contentLines
  }
  
}
