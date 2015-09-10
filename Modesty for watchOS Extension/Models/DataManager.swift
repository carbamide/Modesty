//
//  DataManager.swift
//  Modesty
//
//  Created by Joshua Barrow on 5/12/15.
//  Copyright (c) 2015 Jukaela Enterprises. All rights reserved.
//

import Foundation
#if os(watchOS)
import WatchKit
#endif

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
        let url = NSURL(string:"https://aqueous-lowlands-3303.herokuapp.com")
        
        self.session.dataTaskWithURL(url!, completionHandler: {
            (data, response, error) in
            
            do {
                let modestyDict = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
                let playersArray = modestyDict?.objectForKey("players") as? NSArray
                
                guard let players = playersArray else { return }
                
                self.playerDataSource.removeAll(keepCapacity: false)
                
                for username in players {
                    var player = Player()
                    player.username = username as! String
                    
                    self.playerDataSource.append(player)
                }
            }
            catch {
                print(error)
            }
            
            self.loadStaffData(completion)
        }).resume()
    }
    
    private func loadStaffData(completion: (() -> ())? = nil) {
        let url = NSURL(string:"http://safe-retreat-6833.herokuapp.com/users.json")
        
        self.session.dataTaskWithURL(url!, completionHandler: {
            (data, response, error) in
            guard let data = data else { return }
            
            do {
                let staffArray = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as? NSArray
                guard let staff = staffArray else { return }
                
                self.staffDataSource.removeAll(keepCapacity: false)
                
                for array: NSArray in staff as! [NSArray] {
                    for dict: NSDictionary in array as! [NSDictionary] {
                        var staffMember = Staff()
                        staffMember.username = dict["username"] as! String
                        staffMember.rank = dict["rank"] as! String
                        
                        self.staffDataSource.append(staffMember)
                    }
                }
                
                completion?()
            }
            catch {
                print(error)
            }
        }).resume()
    }
#if os(watchOS)
    func loadImageFromRemoteForPlayer(username: String, rowController: PlayerRowController) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        
        if NSFileManager.defaultManager().fileExistsAtPath(documentsPath.stringByAppendingPathComponent(username)) {
            let imageData = NSData(contentsOfFile: documentsPath.stringByAppendingPathComponent(username))
            
            dispatch_async(dispatch_get_main_queue()) {
                if let imageView = rowController.playerImageView {
                    imageView.setImageData(imageData)
                }
            }
        }
        
        let url = NSURL(string: String(format: "https://minotar.net/helm/%@/120.png", username))
        
        self.session.dataTaskWithURL(url!, completionHandler: {
            (data, response, error) in
            guard let data = data else { return }
            
            self.saveImageData(data, username: username, fullSize: false)
            
            dispatch_async(dispatch_get_main_queue()) {
                if let imageView = rowController.playerImageView {
                    imageView.setImageData(data)
                }
            }
        }).resume()
    }
#endif
    func loadFullSizeImageForPlayer(username: String, completion: ((image: NSData) -> ())? = nil) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        
        if NSFileManager.defaultManager().fileExistsAtPath(documentsPath.stringByAppendingPathComponent(username)) {
            let imageData = NSData(contentsOfFile: documentsPath.stringByAppendingPathComponent(username))
            
            if let imageData = imageData {
                dispatch_async(dispatch_get_main_queue()) {
                    completion?(image: imageData)
                }
            }
        }
        
        let url = NSURL(string: String(format: "https://minotar.net/helm/%@/360.png", username))
        
        self.session.dataTaskWithURL(url!, completionHandler: {
            (data, response, error) in
            guard let data = data else { return }
            
            self.saveImageData(data, username: username, fullSize: true)
            
            dispatch_async(dispatch_get_main_queue()) {
                completion?(image: data)
            }
        }).resume()
    }
    
    func rankForUsername(username: String) -> String {
        let staff = self.staffDataSource.filter { (staffMember: Staff) in
            staffMember.username == username
        }
        
        return staff.first?.rank ?? ""
    }
    
    private func saveImageData(data: NSData, username: String, fullSize: Bool) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        
        data.writeToFile(documentsPath.stringByAppendingPathComponent(username + (fullSize ? "fullSize" : "")), atomically: true)
    }
}

