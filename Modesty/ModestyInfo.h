//
//  ModestyInfo.h
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Server.h"
#import "Player.h"

/**
 *  ModestyInfo is a data storage class that holds infomation about Modesty and it's players.
 */
@interface ModestyInfo : NSObject

/**
 *  Reference to the Server class that is a data storage class.
 */
@property (strong, nonatomic) Server *serverInformation;

/**
 *  NSArray that holds the Player objects.
 */
@property (strong, nonatomic) NSArray *players;

@end
