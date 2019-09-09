//
//  ViewController.swift
//  iReader
//
//  Created by Chessur on 2019/8/6.
//  Copyright © 2019 Chessur. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var txtContent: NSTextField!
    
    var bookString: String! = ""
    var bookPath: String! = "/Users/iuz/Downloads/test.txt"
    var pages = 0
    var index = 0
    var chars = 180
    var offset = 0
    var columns = 0
    var rows = 0
    var fileIsOpen: Bool = false
    var isWindowVisible: Bool = true
    
    var prefs = Preferences()
    var bookReader = Pages()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
        
        setupPrefs()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.charactersIgnoringModifiers {
        case "d":
            if !fileIsOpen {
                openFile(prefs.filePath, prefs.encoding)
            }
            if fileIsOpen {
                txtContent.stringValue = bookReader.display()
            }
        case "a":
            if !fileIsOpen {
                openFile(prefs.filePath, prefs.encoding)
            }
            if fileIsOpen {
                txtContent.stringValue = bookReader.displayPrevPage()
            }
        case "s":
            if !fileIsOpen {
                break
            }
            txtContent.stringValue = bookReader.skipPages(skipPages: 100)
        case "w":
            if !fileIsOpen {
                break
            }
            txtContent.stringValue = bookReader.goBackPages(backPages: 100)
        case " ":
            toggleWindow()
        default:
            break
        }
    }
    
    func toggleWindow() {
        if isWindowVisible {
            self.view.window?.orderBack(nil)
            isWindowVisible = false
        } else {
            self.view.window?.orderFront(nil)
            isWindowVisible = true
        }
    }
    
    func openFile(_ path: String, _ encoding: String.Encoding) {
        let manager = FileManager.default
        let data = manager.contents(atPath: path)
        if data != nil {
            bookString = String(data: data!, encoding: encoding)
            bookReader.parseBookString(data: bookString)
            fileIsOpen = true
        } else {
            let alert = NSAlert()
            alert.messageText = "Unable to read file data, please check the file path."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
            return
        }
        
        txtContent.backgroundColor = prefs.backgroundColor
        txtContent.textColor = prefs.fontColor
        txtContent.font = prefs.txtFont
        view.window?.backgroundColor = prefs.backgroundColor
    }
    
    func initDisplay() {
        bookPath = prefs.filePath
        bookReader.index = prefs.index
        columns = prefs.columns
        rows = prefs.rows
        
        let width = prefs.fontSize * CGFloat(prefs.columns) + 5
        let height = prefs.fontSize * 1.4 * CGFloat(prefs.rows) + 5
        
        self.view.setFrameSize(NSSize(width: width, height: height))
    }
    
    func updateDisplay() {
        txtContent.backgroundColor = prefs.backgroundColor
        txtContent.textColor = prefs.fontColor
        txtContent.font = prefs.txtFont
        view.window?.backgroundColor = prefs.backgroundColor
        
        if self.bookPath != prefs.filePath {
            self.bookPath = prefs.filePath
            self.openFile(self.bookPath, prefs.encoding)
            txtContent.stringValue = self.bookReader.displayPage(idx: prefs.index)
        } else {
            if columns != prefs.columns || rows != prefs.rows {
                bookReader.parseBookString(data: bookString)
                columns = prefs.columns
                rows = prefs.rows
                
                let width = prefs.fontSize * CGFloat(prefs.columns) + 5
                let height = prefs.fontSize * 1.4 * CGFloat(prefs.rows) + 5
                
                self.view.setFrameSize(NSSize(width: width, height: height))
            }
        }
    }
    
    deinit {
        NSEvent.removeMonitor(keyDown)
    }
}

extension ViewController {
    func setupPrefs() {
        initDisplay()
        
        let notificationName = Notification.Name(rawValue: "PrefsChanged")
        NotificationCenter.default.addObserver(forName: notificationName,
                                               object: nil, queue: nil) {
                                                (notification) in self.updateDisplay()
        }
    }
}

extension String {
    var count: Int {
        let string_NS = self as NSString
        return string_NS.length
    }
    
    func regReplace(pattern: String, with: String,
                     options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
    }
}
