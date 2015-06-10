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
    
    private var session: NSURLSession!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let sessionConfiguration:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfiguration.HTTPMaximumConnectionsPerHost = 5
        
        self.session = NSURLSession(configuration: sessionConfiguration)
    }
    
    override func willActivate() {
        super.willActivate()
        
        loadPlayerData()
        
        updateUserActivity("com.jukaela.Modesty.watchkitapp.glance", userInfo: ["viewing": "players"], webpageURL: nil)
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func loadPlayerData() {
        let url = NSURL(string:"http://aqueous-lowlands-3303.herokuapp.com")
        
        self.session.dataTaskWithURL(url!, completionHandler: {
            (data, response, error) in
            do {
                let modestyDict = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
                let playersArray = modestyDict?.objectForKey("players") as? NSArray
                
                if let players = playersArray {
                    self.updateLabels(players)
                }
                else {
                    self.updateLabelsForError()
                }
            }
            catch {
                print(error)
            }
        })!.resume()
    }
    
    func updateLabels(players: NSArray) {
        dispatch_async(dispatch_get_main_queue()) {
            let singular = players.count == 1
            
            self.statusLabel.setText("Modesty is up!")
            
            if (players.count > 0) {
                self.playerCountLabel.setText(String(format:"There %@ currently %d %@ online.", (singular ? "is" : "are"), players.count, (singular ? "player" : "players")))
            }
            else {
                self.playerCountLabel.setText("No players are online.")
            }
        }
    }
    
    func updateLabelsForError() {
        dispatch_async(dispatch_get_main_queue()) {
            self.statusLabel.setText("Modesty is down!")
            self.playerCountLabel.setText("No players are online.")
        }
    }
}
