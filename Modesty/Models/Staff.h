//
//  Staff.h
//  Modesty
//
//  Created by Josh on 12/30/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Staff : NSObject

@property (strong, nonatomic) NSNumber *staffId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *rank;
@property (strong, nonatomic) NSURL *url;

@end
