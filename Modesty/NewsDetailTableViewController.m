//
//  NewsDetailTableViewController.m
//  Modesty
//
//  Created by Josh on 12/30/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.

#import "NewsDetailTableViewController.h"
#import "NSString+HTML.h"

@interface NewsDetailTableViewController ()

@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSString *summaryString;

@end

typedef enum { SectionHeader, SectionDetail } Sections;
typedef enum { SectionHeaderTitle, SectionHeaderDate, SectionHeaderURL, SectionHeaderAuthor } HeaderRows;
typedef enum { SectionDetailSummary } DetailRows;

@implementation NewsDetailTableViewController

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style
{
    if ((self = [super initWithStyle:style])) {
		
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
	if ([[self item] date]) {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeStyle:NSDateFormatterMediumStyle];
        
        [self setDateString:[formatter stringFromDate:[[self item] date]]];
	}
	
	if ([[self item] summary]) {
        [self setSummaryString:[[[self item] summary] stringByConvertingHTMLToPlainText]];
	}
    else {
        [self setSummaryString:@"[No Summary]"];
	}
	
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case 0:
            return 4;
            
            break;
		default:
            return 1;
            
            break;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewsDetailCell];
    
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNewsDetailCell];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
	
    [[cell textLabel] setTextColor:[UIColor blackColor]];
    [[cell textLabel] setFont:[UIFont systemFontOfSize:15]];
    
	if ([self item]) {
		NSString *itemTitle = [[self item] title] ? [[[self item] title] stringByConvertingHTMLToPlainText] : @"[No Title]";
		
		switch ([indexPath section]) {
			case SectionHeader: {
				// Header
				switch (indexPath.row) {
					case SectionHeaderTitle:
                        [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
                        [[cell textLabel] setText:itemTitle];
                        
						break;
					case SectionHeaderDate:
                        [[cell textLabel] setText:[self dateString] ? [self dateString] : @"[No Date]"];
                        
						break;
					case SectionHeaderURL:
                        [[cell textLabel] setText:[[self item] link] ? [[self item] link] : @"[No Link]"];
                        [[cell textLabel] setTextColor:[UIColor blueColor]];
                        
                        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
                        
						break;
					case SectionHeaderAuthor:
                        [[cell textLabel] setText:[[self item] author] ? [[self item] author] : @"Modesty Staff"];
                        
						break;
				}
				break;
			}
			case SectionDetail: {
                [[cell textLabel] setText:[self summaryString]];
                [[cell textLabel] setNumberOfLines:0];
                
				break;
			}
		}
	}
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath section] == SectionHeader) {
        return 34;
	}
    else {
		NSString *summary = @"[No Summary]";
		if ([self summaryString]) {
            summary = [self summaryString];
        }
        
		CGSize s = [summary sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(self.view.bounds.size.width - 40, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
		return s.height + 16;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == SectionHeader && [indexPath row] == SectionHeaderURL) {
		if ([[self item] link]) {
            [self initializeBrowserWithURL:[NSURL URLWithString:[[self item] link]]];
		}
	}
	
	[[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
}


@end
