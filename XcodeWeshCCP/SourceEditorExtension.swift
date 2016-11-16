//
//  SourceEditorExtension.swift
//  XcodeWeshCCP
//
//  Created by Yoann Cribier on 13/11/2016.
//  Copyright © 2016 akabab. All rights reserved.
//

import XcodeKit

class SourceEditorExtension: NSObject, XCSourceEditorExtension {

  func extensionDidFinishLaunching() {
    // If your extension needs to do any work at launch, implement this optional method.
    print("launched")
  }

  /*
   var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
   // If your extension needs to return a collection of command definitions that differs from those in its Info.plist, implement this optional property getter.
   return []
   }
  */

}
