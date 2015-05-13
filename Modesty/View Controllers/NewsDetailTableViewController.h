//
//  NewsDetailTableViewController.h
//  Modesty
//
//  Created by Josh on 12/30/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedItem.h"
#import "ModestyTableViewController.h"
#import "NSString+HTML.h"

@interface NewsDetailTableViewController : ModestyTableViewController

@property (nonatomic, strong) MWFeedItem *item;

@end