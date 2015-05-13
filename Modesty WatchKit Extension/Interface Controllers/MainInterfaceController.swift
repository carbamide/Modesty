//
//  MainInterfaceController.swift
//  Modesty
//
//  Created by Joshua Barrow on 5/7/15.
//  Copyright (c) 2015 Jukaela Enterprises. All rights reserved.
//

import WatchKit
import Foundation

struct UserVisibleStrings {
    static let LOADING_STRING = "Loading…"
    static let STAFF_STRING = "Staff"
}

struct InternalStrings {
    static let PLAYER_INTERFACE_CONTROLLER = "PlayerInterfaceController"
    static let VIEWING = "viewing"
    static let PLAYERS = "players"
}

class MainInterfaceController: WKInterfaceController {

    @IBOutlet weak var playerButton: WKInterfaceButton!
    @IBOutlet weak var staffButton: WKInterfaceButton!
    @IBOutlet weak var newsButton: WKInterfaceButton!
    @IBOutlet weak var loadingIndicatorImage: WKInterfaceImage!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.playerButton.setTitle(UserVisibleStrings.LOADING_STRING)
        self.staffButton.setTitle(UserVisibleStrings.LOADING_STRING)
        
        DataManager.sharedInstance.refreshData({
            self.playerButton.setTitle(String(format:"%d Players", DataManager.sharedInstance.playerDataSource.count))
            self.playerButton.setEnabled(true)
            
            self.staffButton.setTitle(UserVisibleStrings.STAFF_STRING)
            self.staffButton.setEnabled(true)
        })
    }

    override func handleUserActivity(userInfo: [NSObject : AnyObject]!) {
        let viewing: String = userInfo[InternalStrings.VIEWING] as! String
        
        if (viewing == InternalStrings.PLAYERS) {
            pushControllerWithName(InternalStrings.PLAYER_INTERFACE_CONTROLLER, context: nil)
        }
    }
    
    @IBAction func refreshMenuAction() {
        self.playerButton.setTitle(UserVisibleStrings.LOADING_STRING)
        self.staffButton.setTitle(UserVisibleStrings.LOADING_STRING)
        
        DataManager.sharedInstance.refreshData({
            self.playerButton.setTitle(String(format:"%d Players", DataManager.sharedInstance.playerDataSource.count))
            self.playerButton.setEnabled(true)
            
            self.staffButton.setTitle(UserVisibleStrings.STAFF_STRING)
            self.staffButton.setEnabled(true)
        })
    }
    
    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

}
