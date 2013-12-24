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

+(DataMapper *)sharedInstance;

-(void)refreshInformation;

@end
