//
//  Server.swift
//  Modesty
//
//  Created by Joshua Barrow on 5/15/15.
//  Copyright (c) 2015 Jukaela Enterprises. All rights reserved.
//

import Foundation

@objc class Server: NSObject {
    var hostIp: NSString!
    var gameType: NSString!
    var plugins: NSArray!
    var software: NSString!
    var hostName: NSString!
    var maxPlayers: NSNumber!
    var map: NSString!
    var players: NSNumber!
    var hostPort: NSNumber!
    var version: NSString!
}
