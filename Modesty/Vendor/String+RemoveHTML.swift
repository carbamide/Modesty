//
//  String+RemoveHTML.swift
//  Modesty
//
//  Created by Joshua Barrow on 6/9/15.
//  Copyright © 2015 Jukaela Enterprises. All rights reserved.
//

import Foundation

extension String {
    func removeHTML() -> String {
        do {
            let regex:NSRegularExpression = try NSRegularExpression(pattern: "<.*?>", options: NSRegularExpressionOptions.CaseInsensitive)
            
            let range = NSMakeRange(0, self.characters.count)
            let htmlLessString :String = regex.stringByReplacingMatchesInString(self, options: NSMatchingOptions(rawValue: 0), range:range, withTemplate: "")
            
            return htmlLessString
        }
        catch {
            print(error)
        }
        
        return self
    }
}