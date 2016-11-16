//
//  SourceEditorCommand.swift
//  XcodeWeshCCP
//
//  Created by Yoann Cribier on 13/11/2016.
//  Copyright © 2016 akabab. All rights reserved.
//

import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {

  func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {

    let buffer = invocation.buffer

    let selection = buffer.selections.firstObject as? XCSourceTextRange

    let hasSelection = selection != nil && selection!.start != selection!.end
    print("hasSelection:", hasSelection)
    let handler: CCPHandler = hasSelection ? OriginalCCPHandler() : WeshCCPHandler()

    switch invocation.commandIdentifier {
    case "wesh_copy": handler.copy(from: buffer)
    case "wesh_cut": handler.cut(from: buffer)
    case "wesh_paste": handler.paste(from: buffer)
    default: break
    }

    completionHandler(nil)
  }

}
