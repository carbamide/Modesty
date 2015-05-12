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
    
    var dataSource: NSMutableArray!
    var staffDataList: NSArray!
    
    override init() {
        super.init()
        
        updateUserActivity("com.jukaela.Modesty.watchkitapp.activity", userInfo: ["viewing" : "staff"], webpageURL: nil)
        
        dataSource = NSMutableArray()
        
        loadStaffData()
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
        let dict: NSDictionary = dataSource[rowIndex] as! NSDictionary
        let usernameString = dict.allKeys.first as! NSString
        
        return usernameString
    }
    
    func loadTableData() {
        playerTableView.setNumberOfRows(dataSource.count, withRowType: "PlayerRow")
        
        for (index, dict) in enumerate(dataSource) {
            if let row = playerTableView.rowControllerAtIndex(index) as? PlayerRowController {
                if let playerDict: NSDictionary = dict as? NSDictionary {
                    let username = playerDict.allKeys.first as? String
                    
                    if let usernameString = username {
                        let rank = playerDict.valueForKey(usernameString) as? String
                        
                        row.playerNameLabel.setText(usernameString)
                        row.rankLabel.setText(rankForUsername(usernameString))
                        
                        var usingCachedImage = false
                        
                        for imageDict in WKInterfaceDevice.currentDevice().cachedImages {
                            if imageDict.0 == usernameString {
                                row.playerImageView.setImageNamed(usernameString)
                                
                                usingCachedImage = true
                            }
                        }
                        
                        if !usingCachedImage {
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                                let url = NSURL(string: String(format: "https://minotar.net/helm/%@/30.png", usernameString))
                                let data = NSData(contentsOfURL: url!)
                                if let d = data {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        let image = UIImage(data: d)
                                        
                                        if let imageView = row.playerImageView {
                                            if let playerAvatarImage = image {
                                                let addedImageToCache = WKInterfaceDevice.currentDevice().addCachedImage(playerAvatarImage, name: usernameString)
                                                
                                                if !addedImageToCache {
                                                    WKInterfaceDevice.currentDevice().removeAllCachedImages()
                                                    
                                                    WKInterfaceDevice.currentDevice().addCachedImage(playerAvatarImage, name: usernameString)
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
            }
        }
    }
    
    func loadStaffData() {
        let url = NSURL(string:"http://safe-retreat-6833.herokuapp.com/users.json")
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            let staffArray = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: nil) as? NSArray
            
            if let staffListing = staffArray {
                self.staffDataList = staffListing
                
                for array: NSArray in staffListing as! [NSArray] {
                    for dict: NSDictionary in array as! [NSDictionary] {
                        let username = dict["username"] as? String
                        let rank = dict["rank"] as? String
                        
                        self.dataSource.addObject(NSDictionary(object: rank!, forKey: username!))
                    }
                }
                
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
