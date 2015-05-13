//
//  StaffInterfaceController.swift
//  Modesty
//
//  Created by Joshua Barrow on 5/7/15.
//  Copyright (c) 2015 Jukaela Enterprises. All rights reserved.
//

import WatchKit
import Foundation

class StaffInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var playerTableView: WKInterfaceTable!
    
    override init() {
        super.init()
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    override func willActivate() {
        super.willActivate()
        
        updateUserActivity("com.jukaela.Modesty.watchkitapp.activity", userInfo: ["viewing" : "staff"], webpageURL: nil)
        
        loadTableData()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        if let dataSource = DataManager.sharedInstance.staffDataSource {
            var tempDataSource: Array<String> = []
            
            if let staffListing = DataManager.sharedInstance.staffDataSource {
                for array: NSArray in staffListing as! [NSArray] {
                    for dict: NSDictionary in array as! [NSDictionary] {
                        tempDataSource.append(dict["username"]! as! String)
                    }
                }
            }
            
            let username = tempDataSource[rowIndex]
            
            return username
        }
        
        return nil;
    }
    
    @IBAction func refreshMenuAction() {        
        DataManager.sharedInstance.refreshData({ () in
            self.loadTableData()
        })
    }
    
    func loadTableData() {
        var dataSource: Array<String> = []
        
        if let staffListing = DataManager.sharedInstance.staffDataSource {
            for array: NSArray in staffListing as! [NSArray] {
                for dict: NSDictionary in array as! [NSDictionary] {
                    dataSource.append(dict["username"]! as! String)
                }
            }
        }
        
        playerTableView.setNumberOfRows(dataSource.count, withRowType: "PlayerRow")
        
        for (index, username) in enumerate(dataSource) {
            if let row = playerTableView.rowControllerAtIndex(index) as? PlayerRowController {
                row.playerNameLabel.setText(username)
                row.rankLabel.setText(DataManager.sharedInstance.rankForUsername(username))
                
                var usingCachedImage = false
                
                for imageDict in WKInterfaceDevice.currentDevice().cachedImages {
                    if imageDict.0 == username {
                        row.playerImageView.setImageNamed(username)
                        
                        usingCachedImage = true
                    }
                }
                
                if !usingCachedImage {
                    DataManager.sharedInstance.loadImageFromRemoteForPlayer(username, rowController: row)
                }
            }
        }
    }
    
}
