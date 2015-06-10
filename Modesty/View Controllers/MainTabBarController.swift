//
//  MainTabBarController.swift
//  Modesty
//
//  Created by Joshua Barrow on 5/10/15.
//  Copyright (c) 2015 Jukaela Enterprises. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func restoreUserActivityState(activity: NSUserActivity) {
        if let userInfo: NSDictionary = activity.userInfo {
            let viewing: String = userInfo["viewing"] as! String
            
            if (viewing == "staff") {
                self.selectedIndex = 0
//                let infoViewController: InfoTableViewController = (self.viewControllers?.first?.topViewController as? InfoTableViewController)!
//                
//                    infoViewController.activateStaffListing()
            }
            else if (viewing == "players") {
                self.selectedIndex = 1
            }
            else if (viewing == "news") {
                self.selectedIndex = 3
            }
        }
        
        super.restoreUserActivityState(activity)
    }

}
