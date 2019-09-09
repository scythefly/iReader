//
//  PrefsViewController.swift
//  iReader
//
//  Created by Chessur on 2019/9/3.
//  Copyright © 2019 Chessur. All rights reserved.
//

import Cocoa

class PrefsViewController: NSViewController {
    
    @IBOutlet weak var themePopup: NSPopUpButton!
    @IBOutlet weak var encodingPopup: NSPopUpButton!
    @IBOutlet weak var pathField: NSTextField!
    @IBOutlet weak var charsField: NSTextField!
    @IBOutlet weak var indexField: NSTextField!
    @IBOutlet weak var fontLabel: NSTextField!
    @IBOutlet weak var previewField: NSTextField!
    @IBOutlet weak var totalPagesField: NSTextField!
    @IBOutlet weak var commonRatio: NSButton!
    @IBOutlet weak var customRatio: NSButton!
    
    var selectedRadio: NSButton?
    var prefs = Preferences()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDidChangePreferredTheme(notification:)), name: NSNotification.Name(rawValue: "didChangePreferredTheme"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePreferences(notification:)), name: NSNotification.Name(rawValue: "Preferences..."), object: nil)
        
//        loadSettings()
    }
    
    @objc func handlePreferences(notification: Notification) {
        loadSettings()
    }
    
    @IBAction func changePreferredTheme(_ sender: Any) {
        if let radio = sender as? NSButton, let selectedRadio = selectedRadio {
            if radio != selectedRadio {
                if radio == commonRatio {
                    prefs.preferredTheme = "common"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChangePreferredTheme"), object: "common")
                } else {
                    prefs.preferredTheme = "custom"
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didChangePreferredTheme"), object: "custom")
                }
            }
            self.selectedRadio = radio
        }
    }
    
    @IBAction func themePopupValueChanged(_ sender: NSPopUpButton) {
        prefs.themeTag = themePopup.selectedTag()
        updatePreview()
    }
    
    @IBAction func fontBtnClicked(_ sender: Any) {
        let fontManager = NSFontManager.shared
        fontManager.action = #selector(didChangeFont)
        fontManager.target = self
        fontManager.orderFrontFontPanel(self)
    }
    
    @IBAction func fontColorBtnClicked(_ sender: Any) {
        let colorPanel = NSColorPanel.shared
        colorPanel.mode = .RGB
        colorPanel.isContinuous = false
        colorPanel.setAction(#selector(didChangeFontColor))
        colorPanel.setTarget(self)
        
        colorPanel.orderFront(nil)
    }
    
    @IBAction func backgroundColorBtnClicked(_ sender: Any) {
        let colorPanel = NSColorPanel.shared
        colorPanel.mode = .RGB
        colorPanel.showsAlpha = true
        colorPanel.isContinuous = false
        colorPanel.setAction(#selector(didChangeBackgroundColor))
        colorPanel.setTarget(self)
        
        colorPanel.orderFront(nil)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        if selectedRadio == customRatio {
            prefs.preferredTheme = "custom"
        } else {
            prefs.preferredTheme = "common"
        }
        prefs.userFontColor = previewField.textColor ?? prefs._solarizedDarkFontColor
        prefs.userBackgroundColor = previewField.backgroundColor ?? prefs._solarizedDarkBackgroundColor
        prefs.themeTag = themePopup.selectedTag()
        prefs.chars = Int(charsField.stringValue) ?? 300
        prefs.index = Int(indexField.stringValue) ?? 0
        prefs.encodingTag = encodingPopup.selectedTag()
        prefs.filePath = pathField.stringValue
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "PrefsChanged"),
                                        object: nil)
        
        view.window?.close()
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        view.window?.close()
    }
    
    @objc func handleDidChangePreferredTheme(notification: Notification) {
        prefs.themeTag = themePopup.selectedTag()
        updatePreview()
    }
    
    @objc func didChangeFont(sender: NSFontManager) {
        previewField.font = sender.convert(prefs.txtFont)
    }
    
    @objc func didChangeFontColor(sender: NSColorPanel) {
        previewField.textColor = sender.color
    }
    
    @objc func didChangeBackgroundColor(sender: NSColorPanel) {
        previewField.backgroundColor = sender.color
    }
    
    func loadSettings() {
        fontLabel.stringValue = "\(prefs.fontName) \(prefs.fontSize)"
        
        if prefs.preferredTheme == "common" {
            commonRatio.state = .on
            selectedRadio = commonRatio
        } else {
            customRatio.state = .on
            selectedRadio = customRatio
        }
        indexField.stringValue = "\(prefs.index)"
        charsField.stringValue = "\(prefs.chars)"
        totalPagesField.stringValue = "/ \(prefs.pages)"
        pathField.stringValue = prefs.filePath
        updatePreview()
        for item in themePopup.itemArray {
            if item.tag == prefs.themeTag {
                themePopup.select(item)
            }
        }
        for item in encodingPopup.itemArray {
            if item.tag == prefs.encodingTag {
                encodingPopup.select(item)
            }
        }
    }
    
    func updatePreview() {
        previewField.font = prefs.txtFont
        previewField.textColor = prefs.fontColor
        previewField.backgroundColor = prefs.backgroundColor
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
