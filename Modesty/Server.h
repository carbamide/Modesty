//
//  Server.h
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Server : NSObject

@property (strong, nonatomic) NSString *hostIp;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSString *gameType;
@property (strong, nonatomic) NSArray *plugins;
@property (strong, nonatomic) NSString *software;
@property (strong, nonatomic) NSString *hostName;
@property (strong, nonatomic) NSNumber *maxPlayers;
@property (strong, nonatomic) NSString *map;
@property (strong, nonatomic) NSNumber *players;
@property (strong, nonatomic) NSNumber *hostPort;

@end
