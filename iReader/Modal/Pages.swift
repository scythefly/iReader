//
//  Pages.swift
//  iReader
//
//  Created by Chessur on 2019/9/6.
//  Copyright © 2019 Chessur. All rights reserved.
//

import Foundation

struct Pages {
    var bookString: String! = ""
    var pages: Int = 0
    var prefs = Preferences()
    var pagesArray = [String]()
    var index: Int = 0
    
    mutating func parseBookString(data: String) {
        self.bookString = data.regReplace(pattern: #"[ \t\r\f\v]+\n"#, with: "\n")
        self.bookString = self.bookString.regReplace(pattern: #"[\n]{2,}"#, with: "\n")
        
        splitPages()
    }
    
    mutating func splitPages() {
        var pageString = ""
        var columns = 0
        var rows = 0
        for c in bookString {
            pageString += "\(c)"
            
            if c == "\n" {
                columns = 0
                rows += 1
            } else {
                columns += 1
                if columns >= prefs.columns {
                    rows += 1
                    columns = 0
                }
            }
            
            if rows >= prefs.rows {
                pagesArray.append(pageString)
                pageString = ""
                columns = 0
                rows = 0
            }
        }
        
        self.pages = pagesArray.count
        prefs.pages = self.pages
        prefs.index = self.index
    }
    
    mutating func displayPage(idx: Int) -> String {
        if idx < self.pages && idx >= 0{
            prefs.index = self.index
            self.index = idx + 1
            return self.pagesArray[idx]
        }
        if idx < 0 {
            self.index = 0
            return self.pagesArray[0]
        }
        self.index = self.pages - 1
        return self.pagesArray[self.pages - 1]
    }
    
    mutating func display() -> String {
        return displayPage(idx: self.index)
    }
    
    mutating func skipPages(skipPages: Int) -> String {
        return displayPage(idx: self.index + skipPages)
    }
    
    mutating func displayPrevPage() -> String {
        if self.index > 1 {
            return displayPage(idx: self.index - 2)
        }
        return displayPage(idx: 0)
    }
    
    mutating func goBackPages(backPages: Int) -> String {
        return displayPage(idx: self.index - backPages)
    }
}
