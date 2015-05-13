//
//  DataManager.swift
//  Modesty
//
//  Created by Joshua Barrow on 5/12/15.
//  Copyright (c) 2015 Jukaela Enterprises. All rights reserved.
//

import Foundation
import WatchKit

private let _DataManagerSharedInstance = DataManager()

class DataManager: NSObject {
    static let sharedInstance = DataManager()
    
    private var session: NSURLSession!
    
    var playerDataSource: NSArray!
    var staffDataSource: NSArray!
    
    override init() {
        super.init()
        
        var sessionConfiguration:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfiguration.HTTPMaximumConnectionsPerHost = 5
        
        self.session = NSURLSession(configuration: sessionConfiguration)
        
        loadPlayerData()
    }

    func refreshData(completion: () -> Void) {
        loadPlayerData(completion: completion);
    }
    
    private func loadPlayerData(completion: (() -> ())? = nil) {
        let url = NSURL(string:"http://aqueous-lowlands-3303.herokuapp.com")
        let request = NSURLRequest(URL: url!)
        
        self.session.dataTaskWithURL(url!, completionHandler: {
            (data, response, error) in
            let modestyDict = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: nil) as? NSDictionary
            let playersArray = modestyDict?.objectForKey("players") as? NSArray
            
            if let players = playersArray {
                self.playerDataSource = players
                
                self.loadStaffData(completion: completion)
            }
        }).resume()
    }
    
    private func loadStaffData(completion: (() -> ())? = nil) {
        let url = NSURL(string:"http://safe-retreat-6833.herokuapp.com/users.json")
        let request = NSURLRequest(URL: url!)
        
        self.session.dataTaskWithURL(url!, completionHandler: {
            (data, response, error) in
            
            let staffArray = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: nil) as? NSArray
            
            if let array = staffArray {
                self.staffDataSource = array
                
                completion?()
            }
        }).resume()
    }
    
    func loadImageFromRemoteForPlayer(username: String, rowController: PlayerRowController) {
        let url = NSURL(string: String(format: "https://minotar.net/helm/%@/30.png", username))
        
        self.session.dataTaskWithURL(url!, completionHandler: {
            (data, response, error) in
            let data = NSData(contentsOfURL: url!)
            
            if let d = data {
                dispatch_async(dispatch_get_main_queue()) {
                    let image = UIImage(data: d)
                    
                    if let imageView = rowController.playerImageView {
                        if let playerAvatarImage = image {
                            let addedImageToCache = WKInterfaceDevice.currentDevice().addCachedImage(playerAvatarImage, name: username)
                            
                            if !addedImageToCache {
                                WKInterfaceDevice.currentDevice().removeAllCachedImages()
                                
                                WKInterfaceDevice.currentDevice().addCachedImage(playerAvatarImage, name: username)
                            }
                            
                            rowController.playerImageView.setImage(image)
                        }
                    }
                }
            }
        }).resume()
    }
    
    func rankForUsername(username: String) -> String {
        if let staffListing = self.staffDataSource {
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

