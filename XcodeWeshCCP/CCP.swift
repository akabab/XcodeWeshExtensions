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

class WeshCCPHandler: CCPHandler {

  var pasteboard: NSPasteboard {
    return NSPasteboard.general()
  }

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

  var pasteboard: NSPasteboard {
    return NSPasteboard.general()
  }

  func copy(from buffer: XCSourceTextBuffer) {
    print("original copy")
  }

  func cut(from buffer: XCSourceTextBuffer) {
    print("original cut")
  }

  func paste(from buffer: XCSourceTextBuffer) {
    print("original paste")
  }
  
}
