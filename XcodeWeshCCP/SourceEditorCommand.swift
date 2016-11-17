//
//  SourceEditorCommand.swift
//  XcodeWeshCCP
//
//  Created by Yoann Cribier on 13/11/2016.
//  Copyright © 2016 akabab. All rights reserved.
//

import XcodeKit

// Global because SourceEditorCommand is beeing deinit each time
var originalHandler = OriginalCCPHandler()
var weshHandler = WeshCCPHandler()

var lastUsedHandler: CCPHandler?

class SourceEditorCommand: NSObject, XCSourceEditorCommand {

  func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {

    let buffer = invocation.buffer

    let selection = buffer.selections.firstObject as? XCSourceTextRange

    let hasSelection = selection != nil && selection!.start != selection!.end
    print("hasSelection:", hasSelection)

    switch invocation.commandIdentifier {

    case "wesh_copy":
      lastUsedHandler = (hasSelection ? originalHandler : weshHandler)
      lastUsedHandler?.copy(from: buffer)

    case "wesh_cut":
      lastUsedHandler = (hasSelection ? originalHandler : weshHandler)
      lastUsedHandler?.cut(from: buffer)

    case "wesh_paste":
      lastUsedHandler = lastUsedHandler ?? originalHandler
      lastUsedHandler?.paste(from: buffer)

    default: break
    }

    completionHandler(nil)
  }

}
