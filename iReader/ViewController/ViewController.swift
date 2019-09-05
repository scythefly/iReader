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
    var fileIsOpen: Bool = false
    
    var prefs = Preferences()
    
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
                openFile("/Users/iuz/Downloads/test.txt", prefs.encoding)
            }
            displayPage(index)
        case "a":
            if index > 1 {
                displayPage(index - 2)
            }
        default:
            break
        }
    }
    
    func openFile(_ path: String, _ encoding: String.Encoding) {
        let manager = FileManager.default
        let data = manager.contents(atPath: path)
        if data != nil {
            bookString = String(data: data!, encoding: encoding)
            pages = bookString.count / chars
            prefs.pages = pages
            fileIsOpen = true
        } else {
            let alert = NSAlert()
            alert.messageText = "Unable to read file data, please check the file path."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
        
        txtContent.backgroundColor = prefs.backgroundColor
        txtContent.textColor = prefs.fontColor
        txtContent.font = prefs.txtFont
        view.window?.backgroundColor = prefs.backgroundColor
    }
    
    func displayPage(_ page: Int) {
        if page * chars + chars > bookString.count {
            txtContent.stringValue = (bookString as NSString).substring(from: page * chars)
            return
        }
        self.offset = page * chars
        var txtString: String = (bookString as NSString).substring(with: NSMakeRange(self.offset, chars))
        txtString = txtString.regReplace(pattern: #"[ \t\r\f\v]+\n"#, with: "\n")
        txtContent.stringValue = txtString.regReplace(pattern: #"[\n]{2,}"#, with: "\n")
        index = page + 1
        prefs.index = index
    }
    
    func initDisplay() {
        bookPath = prefs.filePath
        chars = prefs.chars
        index = prefs.index
    }
    
    func updateDisplay() {
        txtContent.backgroundColor = prefs.backgroundColor
        txtContent.textColor = prefs.fontColor
        txtContent.font = prefs.txtFont
        view.window?.backgroundColor = prefs.backgroundColor
        
        if self.bookPath != prefs.filePath {
            self.bookPath = prefs.filePath
            self.openFile(self.bookPath, prefs.encoding)
            self.displayPage(prefs.index)
        }
        
        if chars != prefs.chars {
            chars = prefs.chars
            pages = bookString.count / chars
            prefs.pages = pages
            
            if self.index != prefs.index {
                self.index = prefs.index
                displayPage(self.index)
            } else {
                var i = 0
                while chars * i < self.offset {
                    i += 1
                }
                self.offset = chars * i
                self.index = i
                txtContent.stringValue = (bookString as NSString).substring(with: NSMakeRange(self.offset, chars))
            }
        } else if self.index != prefs.index {
            self.index = prefs.index
            displayPage(self.index)
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
