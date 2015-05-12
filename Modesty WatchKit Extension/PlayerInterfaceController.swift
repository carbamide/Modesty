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
    
    var dataSource: NSArray!
    var staffDataList: NSArray!
    
    override init() {
        super.init()
        
        updateUserActivity("com.jukaela.Modesty.watchkitapp.activity", userInfo: ["viewing" : "players"], webpageURL: nil)
        
        loadPlayerData()
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        let player: AnyObject = dataSource[rowIndex]
        
        return player
    }
    
    @IBAction func refreshMenu() {
        playerCountLabel.setText("Refreshing")
        
        loadPlayerData()
    }
    
    func loadTableData() {
        if let data = self.dataSource {
            playerTableView.setNumberOfRows(dataSource.count, withRowType: "PlayerRow")
            
            for (index, playerName) in enumerate(dataSource) {
                if let row = playerTableView.rowControllerAtIndex(index) as? PlayerRowController {
                    if let player: String = playerName as? String {
                        row.playerNameLabel.setText(player)
                        row.rankLabel.setText(self.rankForUsername(player))
                        
                        var usingCachedImage = false
                        
                        for imageDict in WKInterfaceDevice.currentDevice().cachedImages {
                            if imageDict.0 == player {
                                row.playerImageView.setImageNamed(player)
                                
                                usingCachedImage = true
                            }
                        }
                        
                        if !usingCachedImage {
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                                let url = NSURL(string: String(format: "https://minotar.net/helm/%@/30.png", player))
                                let data = NSData(contentsOfURL: url!)
                                if let d = data {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        let image = UIImage(data: d)
                                        
                                        if let playerAvatarImage = image {
                                            let addedImageToCache = WKInterfaceDevice.currentDevice().addCachedImage(playerAvatarImage, name: player)
                                            
                                            if !addedImageToCache {
                                                WKInterfaceDevice.currentDevice().removeAllCachedImages()
                                                
                                                WKInterfaceDevice.currentDevice().addCachedImage(playerAvatarImage, name: player)
                                            }
                                            
                                            row.playerImageView.setImage(image)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            playerCountLabel.setText(String(format: "%d %@", dataSource.count, dataSource.count == 1 ? "player" : "players"))
        }
        else {
            loadPlayerData()
        }
    }
    
    func loadPlayerData() {
        let url = NSURL(string:"http://aqueous-lowlands-3303.herokuapp.com")
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            let modestyDict = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: nil) as? NSDictionary
            let playersArray = modestyDict?.objectForKey("players") as? NSArray
            
            if let players = playersArray {
                self.dataSource = players
                self.loadStaffData()
            }
            
        })
    }
    
    func loadStaffData() {
        let url = NSURL(string:"http://safe-retreat-6833.herokuapp.com/users.json")
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            let staffArray = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: nil) as? NSArray
            
            if let array = staffArray {
                self.staffDataList = array
                self.loadTableData()
            }
        })
    }
    
    func rankForUsername(username: String) -> String {
        if let staffListing = self.staffDataList {
            for array: NSArray in staffListing as! [NSArray] {
                for dict: NSDictionary in array as! [NSDictionary] {
                    if dict["username"] as! String == username {
                        return dict["rank"] as! String
                    }
                }
            }
        }
        
        return ""
    }
}