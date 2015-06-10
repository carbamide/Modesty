//
//  NewsTableViewController.m
//  Modesty
//
//  Created by Josh on 12/30/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "NewsTableViewController.h"
#import "NewsDetailTableViewController.h"
#import "Modesty-Swift.h"

@interface NewsTableViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSMutableArray *parsedItems;

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
    NSURLRequest *request = [NSURLRequest requestWithURL:feedURL];
    
    [RSSParser parseFeedForRequest:request callback:^(RSSFeed *feed, NSError *error) {
        for (RSSItem *item in [feed items]) {
            [[self parsedItems] addObject:item];
        }
        
        [self updateTableWithParsedItems];
    }];
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
    
    [[self tableView] setUserInteractionEnabled:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        [[self tableView] setAlpha:0.3];
    }];
}

- (void)updateTableWithParsedItems
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setItemsToDisplay:[[self parsedItems] sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:NO]]]];
        
        [[self tableView] setUserInteractionEnabled:YES];
        
        [UIView animateWithDuration:0.3 animations:^{
            [[self tableView] setAlpha:1.0];
        }];
        
        [[self tableView] reloadData];
    });
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
    
    RSSItem *item = [self itemsToDisplay][[indexPath row]];
    
    if (item) {
        NSString *itemTitle = [item title] ? [item title] : @"[No Title]";
        
        NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[[item content] dataUsingEncoding:NSUTF8StringEncoding]
                                                                    options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                              NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                         documentAttributes:nil
                                                                      error:nil];
        NSString *finalString = [attr string];
        
        NSString *itemSummary = finalString ? finalString : @"[No Summary]";
        
        [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
        [[cell textLabel] setText:itemTitle];
        
        NSMutableString *subtitle = [NSMutableString string];
        
        if ([item pubDate]) {
            [subtitle appendFormat:@"%@: ", [[self dateFormatter] stringFromDate:[item pubDate]]];
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