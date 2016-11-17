//
//  CCPHandler+Protocols.swift
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
