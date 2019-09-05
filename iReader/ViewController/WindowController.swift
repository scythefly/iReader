//
//  WindowController.swift
//  iReader
//
//  Created by Chessur on 2019/9/4.
//  Copyright © 2019 Chessur. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        self.window?.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)?.isHidden = true
        self.window?.standardWindowButton(NSWindow.ButtonType.zoomButton)?.isHidden = true
        window?.isMovableByWindowBackground = true
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.charactersIgnoringModifiers {
        case "e":
            if self.window?.titlebarAppearsTransparent == true {
                self.window?.titlebarAppearsTransparent = false
                self.window?.titleVisibility = .visible
                self.window?.standardWindowButton(NSWindow.ButtonType.closeButton)?.isHidden = false
            } else {
                self.window?.titlebarAppearsTransparent = true
                self.window?.titleVisibility = .hidden
                self.window?.standardWindowButton(NSWindow.ButtonType.closeButton)?.isHidden = true
            }
        default:
            break
        }
//        print("window ", event.charactersIgnoringModifiers ?? "")
    }
}
