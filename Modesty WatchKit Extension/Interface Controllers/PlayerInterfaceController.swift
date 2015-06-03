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
        let player = DataManager.sharedInstance.playerDataSource[rowIndex]
        
        return player.username
    }
    
    @IBAction func refreshMenu() {
        DataManager.sharedInstance.refreshData({ () in
            dispatch_async(dispatch_get_main_queue()) {
                self.loadTableData()
            }
        })
    }
    
    private func setRankLabel(username: String, inRow row: PlayerRowController) {
        let rank = DataManager.sharedInstance.rankForUsername(username)
        
        if rank == "" {
            row.rankLabel.setHidden(true)
        }
        else {
            row.rankLabel.setHidden(false)
            row.rankLabel.setText(rank)
        }
    }
    
    func loadTableData() {
        if let dataSource = DataManager.sharedInstance.playerDataSource {
            playerTableView.setNumberOfRows(dataSource.count, withRowType: "PlayerRow")
            
            for (index, player) in enumerate(dataSource) {
                if let
                    row = playerTableView.rowControllerAtIndex(index) as? PlayerRowController {
                        row.playerNameLabel.setText(player.username)
                        
                        self.setRankLabel(player.username, inRow: row)
                        
                        var usingCachedImage = false
                        
                        if WKInterfaceDevice.currentDevice().cachedImages[player.username] != nil {
                            row.playerImageView.setImageNamed(player.username)
                            
                            usingCachedImage = true
                        }
                        
                        if !usingCachedImage {
                            DataManager.sharedInstance.loadImageFromRemoteForPlayer(player.username, rowController: row)
                        }
                        
                        row.playerImageView.setAccessibilityLabel(String(format:"Avatar for %s", player.username))
                }
            }
        }
        else {
            refreshMenu()
        }
    }
}