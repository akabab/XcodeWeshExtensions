//
//  WeshCCPHandler.swift
//  XcodeWeshExtensions
//
//  Created by Yoann Cribier on 17/11/2016.
//  Copyright © 2016 akabab. All rights reserved.
//

import XcodeKit
import AppKit

class WeshCCPHandler: CCPHandler {

  func copy(from buffer: XCSourceTextBuffer) {
    guard let cursorLineIndex = buffer.cursorLineIndex else { return }

    pasteboard.clearContents()

    if let currentLineContent = buffer.lines[cursorLineIndex] as? String {
      pasteboard.contentString = currentLineContent
    }
  }

  func cut(from buffer: XCSourceTextBuffer) {
    guard let cursorLineIndex = buffer.cursorLineIndex else { return }

    self.copy(from: buffer)

    buffer.lines.removeObject(at: cursorLineIndex)
  }

  func paste(from buffer: XCSourceTextBuffer) {
    guard let cursorLineIndex = buffer.cursorLineIndex else { return }

    buffer.lines.insert(pasteboard.contentString, at: cursorLineIndex)
  }
  
}
