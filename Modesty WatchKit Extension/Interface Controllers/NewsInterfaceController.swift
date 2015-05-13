//
//  NewsInterfaceController.swift
//  Modesty
//
//  Created by Joshua Barrow on 5/10/15.
//  Copyright (c) 2015 Jukaela Enterprises. All rights reserved.
//

import WatchKit
import Foundation

class NewsInterfaceController: WKInterfaceController, MWFeedParserDelegate {
    
    var dateFormatter: NSDateFormatter!
    var parsedItems: NSMutableArray!
    var itemsToDisplay: NSArray!
    var feedParser: MWFeedParser!
    
    @IBOutlet weak var newsTableView: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        parsedItems = NSMutableArray()
        itemsToDisplay = NSArray()
        
        feedParser = MWFeedParser(feedURL: NSURL(string: "http://www.minecraftmodesty.enjin.com/home/m/7353456/rss/true"))
        feedParser.delegate = self
        feedParser.feedParseType = ParseTypeFull
        feedParser.connectionType = ConnectionTypeAsynchronously
        feedParser.parse()
        
        updateUserActivity("com.jukaela.Modesty.watchkitapp.activity", userInfo: ["viewing" : "news"], webpageURL: nil)
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func updateTableWithParsedItems() {
        self.itemsToDisplay = parsedItems
        newsTableView.setNumberOfRows(self.itemsToDisplay.count, withRowType: "NewsRow")

        for (index, item) in enumerate(self.itemsToDisplay) {
            if let row = newsTableView.rowControllerAtIndex(index) as? NewsRowController {
                let itemTitle:NSString = NSString(string: item.title!!)
                let itemSummary:NSString = NSString(string: item.summary!!)
                
                let title = itemTitle.stringByConvertingHTMLToPlainText()
                let summary = itemSummary.stringByConvertingHTMLToPlainText()
                
                row.headlineLabel.setText(title)
                row.dateLabel.setText(self.dateFormatter!.stringFromDate(item.date!!))
                row.bodyLabel.setText(summary)
            }
        }
    }
    
    func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        if (item != nil) {
            self.parsedItems.addObject(item)
        }
    }
    
    func feedParserDidFinish(parser: MWFeedParser!) {
        updateTableWithParsedItems()
    }
}
