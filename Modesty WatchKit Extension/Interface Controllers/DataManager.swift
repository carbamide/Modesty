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
    
    var playerDataSource: [Player]!
    var staffDataSource: [Staff]!
    
    override init() {
        super.init()
        
        self.playerDataSource = Array()
        self.staffDataSource = Array()
        
        let sessionConfiguration:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfiguration.HTTPMaximumConnectionsPerHost = 5
        
        self.session = NSURLSession(configuration: sessionConfiguration)
        
        loadPlayerData()
    }
    
    func refreshData(completion: () -> Void) {
        loadPlayerData(completion);
    }
    
    private func loadPlayerData(completion: (() -> ())? = nil) {
        let url = NSURL(string:"http://aqueous-lowlands-3303.herokuapp.com")
        
        self.session.dataTaskWithURL(url!, completionHandler: {
            (data, response, error) in
            
            do {
                let modestyDict = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
                let playersArray = modestyDict?.objectForKey("players") as? NSArray
                
                if let players = playersArray {
                    self.playerDataSource.removeAll(keepCapacity: false)
                    
                    for username in players {
                        var player = Player()
                        player.username = username as! String
                        
                        self.playerDataSource.append(player)
                    }
                }
            }
            catch {
                print(error)
            }
            
            self.loadStaffData(completion)
        })!.resume()
    }
    
    private func loadStaffData(completion: (() -> ())? = nil) {
        let url = NSURL(string:"http://safe-retreat-6833.herokuapp.com/users.json")
        
        self.session.dataTaskWithURL(url!, completionHandler: {
            (data, response, error) in
            
            do {
                let staffArray = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSArray
                
                if let staffListing = staffArray {
                    self.staffDataSource.removeAll(keepCapacity: false)
                    
                    for array: NSArray in staffListing as! [NSArray] {
                        for dict: NSDictionary in array as! [NSDictionary] {
                            var staffMember = Staff()
                            staffMember.username = dict["username"] as! String
                            staffMember.rank = dict["rank"] as! String
                            
                            self.staffDataSource.append(staffMember)
                        }
                    }
                    
                    completion?()
                }
            }
            catch {
                print(error)
            }
        })!.resume()
    }
    
    func loadImageFromRemoteForPlayer(username: String, rowController: PlayerRowController) {
        let url = NSURL(string: String(format: "https://minotar.net/helm/%@/120.png", username))
        
        self.session.dataTaskWithURL(url!, completionHandler: {
            (data, response, error) in
            let data = NSData(contentsOfURL: url!)
            
            if let playerAvatarImageData = data {
//                let addedImageToCache = WKInterfaceDevice.currentDevice().addCachedImageWithData(playerAvatarImageData, name: username)
//                
//                if !addedImageToCache {
//                    WKInterfaceDevice.currentDevice().removeAllCachedImages()
//                    
//                    WKInterfaceDevice.currentDevice().addCachedImageWithData(playerAvatarImageData, name: username)
//                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    if let imageView = rowController.playerImageView {
                        imageView.setImageData(playerAvatarImageData)
                    }
                }
            }
        })!.resume()
    }
    
    func loadFullSizeImageForPlayer(username: String, completion: ((image: NSData) -> ())? = nil) {
        let url = NSURL(string: String(format: "https://minotar.net/helm/%@/360.png", username))
        
        self.session.dataTaskWithURL(url!, completionHandler: {
            (data, response, error) in
            let data = NSData(contentsOfURL: url!)
            
            if let userAvatar = data {
                dispatch_async(dispatch_get_main_queue()) {
                    completion?(image: userAvatar)
                }
            }
        })!.resume()
    }
    
    func rankForUsername(username: String) -> String {
        let staff = self.staffDataSource.filter { (staffMember: Staff) in
            staffMember.username == username
        }
        
        return staff.first?.rank ?? ""
    }
}

