//
//  DataMapper.h
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModestyInfo;

@interface DataMapper : NSObject

@property (strong, nonatomic) ModestyInfo *modestyInfo;
@property (nonatomic, getter = isUpdating) BOOL updating;
@property (strong, nonatomic) NSDictionary *enjinDict;

+(DataMapper *)sharedInstance;

-(void)refreshInformation;
-(BOOL)isUpdating;

@end
