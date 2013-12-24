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

@interface ModestyInfo : NSObject

@property (strong, nonatomic) Server *serverInformation;
@property (strong, nonatomic) NSArray *players;

@end
