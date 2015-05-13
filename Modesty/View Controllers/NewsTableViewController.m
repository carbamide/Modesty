//
//  NewsTableViewController.m
//  Modesty
//
//  Created by Josh on 12/30/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "NewsTableViewController.h"
#import "NSString+HTML.h"
#import "MWFeedParser.h"
#import "NewsDetailTableViewController.h"

@interface NewsTableViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSMutableArray *parsedItems;
@property (strong, nonatomic) MWFeedParser *feedParser;

@end

@implementation NewsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setTitle:@"News"];
    
    [self setDateFormatter:[[NSDateFormatter alloc] init]];
    
	[[self dateFormatter] setDateStyle:NSDateFormatterShortStyle];
	[[self dateFormatter] setTimeStyle:NSDateFormatterShortStyle];
    
    [self setParsedItems:[NSMutableArray array]];
    [self setItemsToDisplay:[NSArray array]];

	NSURL *feedURL = [NSURL URLWithString:kRssFeed];
    
    [self setFeedParser:[[MWFeedParser alloc] initWithFeedURL:feedURL]];
    
    [[self feedParser] setDelegate:self];
    [[self feedParser] setFeedParseType:ParseTypeFull];
    [[self feedParser] setConnectionType:ConnectionTypeAsynchronously];
    [[self feedParser] parse];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Parsing

-(void)refreshData
{
    [super refreshData];
    
    [self refresh];
}

// Reset and reparse
- (void)refresh
{
	[[self parsedItems] removeAllObjects];
	[[self feedParser] stopParsing];
	[[self feedParser] parse];
    
    [[self tableView] setUserInteractionEnabled:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        [[self tableView] setAlpha:0.3];
    }];
}

- (void)updateTableWithParsedItems
{
    [self setItemsToDisplay:[[self parsedItems] sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]]]];
    
    [[self tableView] setUserInteractionEnabled:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        [[self tableView] setAlpha:1.0];
    }];
    
    [[self tableView] reloadData];
}

#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser
{
	NSLog(@"Started Parsing: %@", [parser url]);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info
{
	NSLog(@"Parsed Feed Info: “%@”", [info title]);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item
{
	NSLog(@"Parsed Feed Item: “%@”", [item title]);
    
	if (item) {
        [[self parsedItems] addObject:item];
    }
}

- (void)feedParserDidFinish:(MWFeedParser *)parser
{
	NSLog(@"Finished Parsing %@", ([parser isStopped] ? @" (Stopped)" : [NSString string]));
    
    [self updateTableWithParsedItems];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error
{
	NSLog(@"Finished Parsing With Error: %@", error);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"There was an error during the parsing of the Modesty News feed. Not all of the feed items could read."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self updateTableWithParsedItems];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self itemsToDisplay] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewsCell];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kNewsCell];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
	MWFeedItem *item = [self itemsToDisplay][[indexPath row]];
    
	if (item) {
		NSString *itemTitle = [item title] ? [[item title] stringByConvertingHTMLToPlainText] : @"[No Title]";
		NSString *itemSummary = [item summary] ? [[item summary] stringByConvertingHTMLToPlainText] : @"[No Summary]";
		
        [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
        [[cell textLabel] setText:itemTitle];
        
		NSMutableString *subtitle = [NSMutableString string];
        
		if ([item date]) {
            [subtitle appendFormat:@"%@: ", [[self dateFormatter] stringFromDate:[item date]]];
        }
        
		[subtitle appendString:itemSummary];
        
        [[cell detailTextLabel] setText:subtitle];
		
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NewsDetailTableViewController *detail = [[NewsDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [detail setItem:[self itemsToDisplay][[indexPath row]]];
    
    [[self navigationController] pushViewController:detail animated:YES];
	
    [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
}
@end