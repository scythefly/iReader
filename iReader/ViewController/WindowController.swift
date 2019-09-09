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
        window?.isMovableByWindowBackground = true        
    }
}

