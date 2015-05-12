//
//  MainInterfaceController.swift
//  Modesty
//
//  Created by Joshua Barrow on 5/7/15.
//  Copyright (c) 2015 Jukaela Enterprises. All rights reserved.
//

import WatchKit
import Foundation


class MainInterfaceController: WKInterfaceController {

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    override func handleUserActivity(userInfo: [NSObject : AnyObject]!) {
        let viewing: String = userInfo["viewing"] as! String
        
        if (viewing == "players") {
            pushControllerWithName("PlayerInterfaceController", context: nil)
        }
    }
    
    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

}
