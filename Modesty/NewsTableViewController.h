//
//  NewsTableViewController.h
//  Modesty
//
//  Created by Josh on 12/30/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"
#import "ModestyTableViewController.h"

@interface NewsTableViewController : ModestyTableViewController <MWFeedParserDelegate>
{
	
	// Parsing
	
}

@property (nonatomic, strong) NSArray *itemsToDisplay;

@end
