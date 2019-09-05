//
//  Preferences.swift
//  iReader
//
//  Created by Chessur on 2019/9/4.
//  Copyright © 2019 Chessur. All rights reserved.
//

import Foundation
import Cocoa

enum ThemeTag: Int {
    case SolarizedDark = 1,
    SolarizedLight
}

struct Preferences {
    
    let _solarizedDarkFontColor = NSColor(red: 180/255.0, green: 182/255.0, blue: 182/255.0, alpha: 1)
    let _solarizedDarkBackgroundColor = NSColor(red: 0, green: 43/255.0, blue: 54/255.0, alpha: 1)
    // 89 109 116    /    253 246 227
    let _solarizedLightFontColor = NSColor(red: 89/255.0, green: 109/255.0, blue: 116/255.0, alpha: 1)
    let _solarizedLightBackgroundColor = NSColor(red: 253/255.0, green: 246/255.0, blue: 227/255.0, alpha: 1)
    
    var txtFont: NSFont {
        get {
            return NSFont(name: self.fontName, size: self.fontSize)!
        }
    }
    
    var fontName: String {
        get {
            if let fName = UserDefaults.standard.value(forKey: "fontName") as? String {
                if fName != "" {
                    return fName
                }
            }
            return "Monaco"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "fontName")
        }
    }
    var fontSize: CGFloat {
        get {
            let fSize = UserDefaults.standard.integer(forKey: "fontSize")
            if fSize > 0 {
                return CGFloat(fSize)
            }
            return CGFloat(14)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "fontSize")
        }
    }
    
    var chars: Int {
        get {
            if let cs = UserDefaults.standard.value(forKey: "charactersInOnePage") as? Int {
                if cs > 0 {
                    return cs
                }
            }
            return 300
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "charactersInOnePage")
        }
    }
    
    var index: Int {
        get {
            if let idx = UserDefaults.standard.value(forKey: "indexOfFile") as? Int {
                if idx > 0 {
                    return idx
                }
            }
            return 0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "indexOfFile")
        }
    }
    
    var pages: Int {
        get {
            if let c = UserDefaults.standard.value(forKey: "totalPages") as? Int {
                if c > 0 {
                    return c
                }
            }
            return 0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "totalPages")
        }
    }
    
    var preferredTheme: String {
        get {
            if let themeString = UserDefaults.standard.value(forKey: "themeType") as? String {
                if themeString == "custom" {
                    return "custom"
                }
            }
            return "common"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "themeType")
        }
    }
    
    var themeTag: Int {
        get {
            if let theme = UserDefaults.standard.value(forKey: "themeTag") as? Int {
                if theme == ThemeTag.SolarizedDark.rawValue {
                    return theme
                } else if theme == ThemeTag.SolarizedLight.rawValue {
                    return theme
                }
            }
            return ThemeTag.SolarizedDark.rawValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "themeTag")
        }
    }
    
    var filePath : String {
        get {
            if let filePath = UserDefaults.standard.value(forKey: "filePath") as? String {
                return filePath
            }
            return "/Users/iuz/Downloads/test.txt"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "filePath")
        }
    }
    
    func getColorFromKey(key: String) -> NSColor {
        var red, green, blue, alpha: CGFloat?
        //            var array: Array = [CGFloat]()
        if let array = UserDefaults.standard.array(forKey: key) as? [CGFloat] {
            for (i, v) in array.enumerated() {
                switch i {
                case 0:
                    red = v
                case 1:
                    green = v
                case 2:
                    blue = v
                case 3:
                    alpha = v
                default:
                    break
                }
            }
            return NSColor(red: red ?? 0, green: green ?? 0, blue: blue ?? 0, alpha: alpha ?? 1)
        }
        return NSColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func setColorToKey(color: NSColor, key: String) {
        var array = [CGFloat]()
        array.append(color.redComponent)
        array.append(color.greenComponent)
        array.append(color.blueComponent)
        array.append(color.alphaComponent)
        UserDefaults.standard.set(array, forKey: key)
    }
    
    var userFontColor: NSColor {
        // init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
        get {
            return getColorFromKey(key: "userFontColor")
        }
        set {
            setColorToKey(color: newValue, key: "userFontColor")
        }
    }
    
    var userBackgroundColor: NSColor {
        get {
            return getColorFromKey(key: "userBackgroundColor")
        }
        set {
            setColorToKey(color: newValue, key: "userBackgroundColor")
        }
    }
    
    var fontColor: NSColor {
        get {
            if preferredTheme == "common" {
                if themeTag == ThemeTag.SolarizedDark.rawValue {
                    return _solarizedDarkFontColor
                } else if themeTag == ThemeTag.SolarizedLight.rawValue {
                    return _solarizedLightFontColor
                }
                return _solarizedDarkFontColor
            } else {
                return userFontColor
            }
        }
    }
    
    var backgroundColor: NSColor {
        get {
            if preferredTheme == "common" {
                if themeTag == ThemeTag.SolarizedDark.rawValue {
                    return _solarizedDarkBackgroundColor
                } else if themeTag == ThemeTag.SolarizedLight.rawValue {
                    return _solarizedLightBackgroundColor
                }
                return _solarizedDarkBackgroundColor
            } else {
                return userBackgroundColor
            }
        }
    }
    
    var encodingTag: Int {
        get {
            if let encodingTagValue = UserDefaults.standard.value(forKey: "encodingTag") as? Int {
                if encodingTagValue >= 0 && encodingTagValue <= 2 {
                    return encodingTagValue
                }
            }
            return 0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "encodingTag")
        }
    }
    
    var encoding: String.Encoding {
        get {
            switch self.encodingTag {
            case 0:
                return String.Encoding.utf8
            case 1:
                return String.Encoding.ascii
            case 2:
                return String.Encoding.unicode
            default:
                return String.Encoding.utf8
            }
        }
    }
}
