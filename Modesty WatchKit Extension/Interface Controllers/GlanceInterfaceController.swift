//
//  GlanceInterfaceController.swift
//  Modesty
//
//  Created by Joshua Barrow on 5/7/15.
//  Copyright (c) 2015 Jukaela Enterprises. All rights reserved.
//

import WatchKit
import Foundation


class GlanceInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var statusLabel: WKInterfaceLabel!
    @IBOutlet weak var playerCountLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        loadPlayerData()
        
        updateUserActivity("com.jukaela.Modesty.watchkitapp.glance", userInfo: ["viewing": "players"], webpageURL: nil)
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func loadPlayerData() {
        let url = NSURL(string:"http://aqueous-lowlands-3303.herokuapp.com")
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            let modestyDict = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: nil) as? NSDictionary
            let playersArray = modestyDict?.objectForKey("players") as? NSArray
            
            if let players = playersArray {
                self.updateLabels(players)
            }
            else {
                self.updateLabelsForError()
            }
            
        })
    }
    
    func updateLabels(players: NSArray) {
        let singular = players.count == 1
        
        statusLabel.setText("Modesty is up!")
        
        if (players.count > 0) {
            playerCountLabel.setText(String(format:"There %@ currently %d %@ online.", (singular ? "is" : "are"), players.count, (singular ? "player" : "players")))
        }
        else {
            playerCountLabel.setText("No players are online.")
        }
    }
    
    func updateLabelsForError() {
        statusLabel.setText("Modesty is down!")
        playerCountLabel.setText("No players are online.")
    }
}
