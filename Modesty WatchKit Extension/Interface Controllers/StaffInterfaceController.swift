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
            let staffMember = dataSource[rowIndex]
            
            return staffMember.username
        }
        
        return nil;
    }
    
    @IBAction func refreshMenuAction() {
        DataManager.sharedInstance.refreshData({ () in
            dispatch_async(dispatch_get_main_queue()) {
                self.loadTableData()
            }
        })
    }
    
    func loadTableData() {
        playerTableView.setNumberOfRows(DataManager.sharedInstance.staffDataSource.count, withRowType: "PlayerRow")
        
        for (index, staffMember) in enumerate(DataManager.sharedInstance.staffDataSource) {
            if let row = playerTableView.rowControllerAtIndex(index) as? PlayerRowController {
                row.playerNameLabel.setText(staffMember.username)
                row.rankLabel.setText(DataManager.sharedInstance.rankForUsername(staffMember.username))
                
                var usingCachedImage = false
                
                if WKInterfaceDevice.currentDevice().cachedImages[staffMember.username] != nil {
                    row.playerImageView.setImageNamed(staffMember.username)
                    
                    usingCachedImage = true
                }
                
                if !usingCachedImage {
                    DataManager.sharedInstance.loadImageFromRemoteForPlayer(staffMember.username, rowController: row)
                }
                
                row.playerImageView.setAccessibilityLabel(String(format:"Avatar for %s", staffMember.username))
            }
        }
    }
    
}
