//
//  DataMapper.h
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModestyInfo;

/**
 *  DataMapper is responsible for the API calls and the mapping of response data to local objects.
 *  DataMapper is instantiated as a singleton and is referenced via the sharedInstance class method.
 */
@interface DataMapper : NSObject

/**
 *  Reference to ModestyInfo
 */
@property (strong, nonatomic) ModestyInfo *modestyInfo;

/**
 *  BOOL value that indicates whether an update is currently happening.
 */
@property (nonatomic, getter = isUpdating) BOOL updating;

/**
 *  NSArray listing of all staff
 */
@property (strong, nonatomic) NSArray *staff;

/**
 *  The shared instance that returns the singleton instantiated DataMapper
 *
 *  @return The ready to use instantiated DataMapper
 */
+(DataMapper *)sharedInstance;

/**
 *  Refresh Modesty information from the server.
 */
-(void)refreshInformation;

/**
 * Check modesty status.
 */
-(void)pingModesty;

/**
 *  Indicates whether the local information is currently updating from the middle-tier
 *
 *  @return BOOL value.
 */
-(BOOL)isUpdating;

@end
