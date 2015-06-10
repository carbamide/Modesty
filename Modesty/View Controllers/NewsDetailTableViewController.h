//
//  NewsDetailTableViewController.h
//  Modesty
//
//  Created by Josh on 12/30/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModestyTableViewController.h"
#import "Modesty-Swift.h"

@interface NewsDetailTableViewController : ModestyTableViewController

@property (nonatomic, strong) RSSItem *item;

@end