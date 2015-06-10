//
//  String+ImageLinksFromHTML.swift
//  SwiftRSS_Example
//
//  Created by Thibaut LE LEVIER on 22/10/2014.
//  Copyright (c) 2014 Thibaut LE LEVIER. All rights reserved.
//

import UIKit

extension String {
    var imageLinksFromHTMLString: [NSURL]
    {
        var matches = [NSURL]()
        
        let full_range: NSRange = NSMakeRange(0, self.characters.count)
        
        do {
            let regex = try NSRegularExpression(pattern:"(https?)\\S*(png|jpg|jpeg|gif)", options:.CaseInsensitive)
            regex.enumerateMatchesInString(self, options: NSMatchingOptions(rawValue: 0), range: full_range) {
                match, flags, stop in
                
                // didn't find a way to bridge an NSRange to Range<String.Index>
                // bridging String to NSString instead
                let str = (self as NSString).substringWithRange(match!.range) as String
                
                matches.append(NSURL(string: str)!)
            }
        }
        catch {
            print(error)
        }
        
        return matches
    }
}
