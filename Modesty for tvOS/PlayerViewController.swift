//
//  FirstViewController.swift
//  Modesty for tvOS
//
//  Created by Joshua Barrow on 9/10/15.
//  Copyright © 2015 Jukaela Enterprises. All rights reserved.
//

import UIKit

struct UserVisibleStrings {
    static let LOADING_STRING = "Loading…"
    static let STAFF_STRING = "Staff"
    static let PLAYERS_SINGULAR = "Player"
    static let PLAYERS_PLURAL = "Players"
}

class PlayerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.sharedInstance.refreshData({
            dispatch_async(dispatch_get_main_queue()) {
                self.refreshData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func refreshData() {
        let playerCount = DataManager.sharedInstance.playerDataSource.count
        
//        self.playerLabel.setText(String(format:"%d %@", playerCount, playerCount == 1 ? UserVisibleStrings.PLAYERS_SINGULAR : UserVisibleStrings.PLAYERS_PLURAL))
//        
//        if playerCount > 0 {
//            self.playerButton.setEnabled(true)
//        }
//        
//        self.staffLabel.setText(UserVisibleStrings.STAFF_STRING)
//        self.staffButton.setEnabled(true)
    }
}

