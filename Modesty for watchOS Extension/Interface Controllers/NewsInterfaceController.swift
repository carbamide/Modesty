//
//  NewsInterfaceController.swift
//  Modesty
//
//  Created by Joshua Barrow on 5/10/15.
//  Copyright (c) 2015 Jukaela Enterprises. All rights reserved.
//

import WatchKit
import Foundation

class NewsInterfaceController: WKInterfaceController {
    
    var dateFormatter: NSDateFormatter!
    var parsedItems: NSMutableArray!
    var itemsToDisplay: NSArray!
    
    @IBOutlet weak var loadingLabel: WKInterfaceLabel!
    @IBOutlet weak var newsTableView: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        updateUserActivity("com.jukaela.Modesty.watchkitapp.activity", userInfo: ["viewing" : "news"], webpageURL: nil)
        
        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        parsedItems = NSMutableArray()
        itemsToDisplay = NSArray()
        
        let request = NSURLRequest(URL: NSURL(string: "http://www.minecraftmodesty.enjin.com/home/m/7353456/rss/true")!)
        
        RSSParser.parseFeedForRequest(request, callback: {
            (feed, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                if let _ = feed {
                    for item in feed!.items {
                        self.parsedItems.addObject(item)
                    }
                    
                    self.newsTableView.setHidden(false)
                    self.loadingLabel.setHidden(true)
                    
                    self.updateTableWithParsedItems()
                }
            }
        })
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func updateTableWithParsedItems() {
        self.itemsToDisplay = parsedItems
        
        self.newsTableView.setNumberOfRows(self.itemsToDisplay.count, withRowType: "NewsRow")
        
        for (index, item) in self.itemsToDisplay.enumerate() {
            let feedItem: RSSItem = item as! RSSItem
            
            if let row = self.newsTableView.rowControllerAtIndex(index) as? NewsRowController {
                row.headlineLabel.setText(feedItem.title!)
                row.dateLabel.setText(self.dateFormatter!.stringFromDate(feedItem.pubDate!))
                
                row.bodyLabel.setHyphenatedText((feedItem.content?.removeHTML())!)
            }
        }
    }
}

extension WKInterfaceLabel
{
    func setHyphenatedText(text: String) {
        let style = NSMutableParagraphStyle()
        style.hyphenationFactor = 1
        
        let attributes = [NSParagraphStyleAttributeName: style]
        setAttributedText(NSAttributedString(string: text, attributes: attributes))
    }
}
