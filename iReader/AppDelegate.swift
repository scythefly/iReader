//
//  AppDelegate.swift
//  iReader
//
//  Created by Chessur on 2019/8/6.
//  Copyright © 2019 Chessur. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var preferencesWindowController: NSWindowController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func showPreferences(_ sender: Any) {
        if preferencesWindowController == nil {
            let storyboardName = NSStoryboard.Name(stringLiteral: "Preferences")
            let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
            
            if let windowController = storyboard.instantiateInitialController() as? NSWindowController {
                preferencesWindowController = windowController
            }
        }
        
        if let windowController = preferencesWindowController {
            windowController.showWindow(nil)
        }
    }
}

