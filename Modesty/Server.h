//
//  Server.h
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Data storage class that holds information about the server
 */
@interface Server : NSObject


/**
 *  The server's IP
 */
@property (strong, nonatomic) NSString *hostIp;

/**
 *  The server's version
 */
@property (strong, nonatomic) NSString *version;

/**
 *  The server's gametype (Survival, creative or adventure)
 */
@property (strong, nonatomic) NSString *gameType;

/**
 *  Full array of plugins that the server uses
 */
@property (strong, nonatomic) NSArray *plugins;

/**
 *  The software version of the server
 */
@property (strong, nonatomic) NSString *software;

/**
 *  The host name of the server.  Sometimes used as the MOTD
 */
@property (strong, nonatomic) NSString *hostName;

/**
 *  The maximum number of players this server supports
 */
@property (strong, nonatomic) NSNumber *maxPlayers;

/**
 *  The type of map used in this server.
 */
@property (strong, nonatomic) NSString *map;

/**
 *  The current number of players that are connected to this server
 */
@property (strong, nonatomic) NSNumber *players;


/**
 *  The host port of this server
 */
@property (strong, nonatomic) NSNumber *hostPort;

@end
