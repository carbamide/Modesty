//
//  InterfaceController.swift
//  Modesty WatchKit Extension
//
//  Created by Joshua Barrow on 4/13/15.
//  Copyright (c) 2015 Jukaela Enterprises. All rights reserved.
//

import WatchKit
import Foundation

class PlayerInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var playerTableView: WKInterfaceTable!
    @IBOutlet weak var playerCountLabel: WKInterfaceLabel!
    
    override init() {
        super.init()
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    override func willActivate() {
        super.willActivate()
        
        updateUserActivity("com.jukaela.Modesty.watchkitapp.activity", userInfo: ["viewing" : "players"], webpageURL: nil)

        loadTableData()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        let player: AnyObject = DataManager.sharedInstance.playerDataSource[rowIndex]
        
        return player
    }
    
    @IBAction func refreshMenu() {
        playerCountLabel.setText("Refreshing")
        
        DataManager.sharedInstance.refreshData({ () in
            self.loadTableData()
        })
    }
    
    func loadTableData() {
        if let dataSource = DataManager.sharedInstance.playerDataSource {
            playerTableView.setNumberOfRows(dataSource.count, withRowType: "PlayerRow")
            
            for (index, playerName) in enumerate(dataSource) {
                if let row = playerTableView.rowControllerAtIndex(index) as? PlayerRowController {
                    if let username: String = playerName as? String {
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
            
            playerCountLabel.setText(String(format: "%d %@", dataSource.count, dataSource.count == 1 ? "player" : "players"))
        }
        else {
            refreshMenu()
        }
    }
}