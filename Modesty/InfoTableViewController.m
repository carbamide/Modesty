//
//  FirstViewController.m
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "InfoTableViewController.h"
#import "DataMapper.h"
#import "ModestyInfo.h"
#import "Server.h"
#import "TestFlight.h"

@interface InfoTableViewController ()
@end

@implementation InfoTableViewController

#pragma mark -
#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Modesty"];
    
    [TestFlight passCheckpoint:@"Loaded Info Controller"];
    
    if ([[DataMapper sharedInstance] isUpdating]) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        
        [activityView sizeToFit];
        [activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin |
                                           UIViewAutoresizingFlexibleRightMargin |
                                           UIViewAutoresizingFlexibleTopMargin |
                                           UIViewAutoresizingFlexibleBottomMargin)];
        
        [activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [activityView startAnimating];
        
        UIBarButtonItem *loadingView = [[UIBarButtonItem alloc] initWithCustomView:activityView];
        [[self navigationItem] setRightBarButtonItem:loadingView];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - UITableViewDelegate and Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Server Information";
            break;
        case 1:
            return @"Staff";
            break;
        case 2:
            return @"Player Count";
            break;
        case 3:
            return @"Advanced";
            break;
        default:
            return nil;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kInfoCell];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kInfoCell];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    Server *serverInformation = [[[DataMapper sharedInstance] modestyInfo] serverInformation];
    
    switch ([indexPath section]) {
        case 0: {
            switch ([indexPath row]) {
                case 0: {
                    [[cell textLabel] setText:@"Host"];
                    [[cell detailTextLabel] setText:[serverInformation hostIp]];
                }
                    break;
                case 1: {
                    [[cell textLabel] setText:@"Port"];
                    [[cell detailTextLabel] setText:[[serverInformation hostPort] stringValue]];
                }
                    break;
                case 2: {
                    [[cell textLabel] setText:@"Version"];
                    [[cell detailTextLabel] setText:[serverInformation version]];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            [[cell textLabel] setText:@"Staff"];
            [[cell detailTextLabel] setText:[NSString string]];
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
            break;
        case 2: {
            switch ([indexPath row]) {
                case 0: {
                    [[cell textLabel] setText:@"Players"];
                    
                    if (serverInformation) {
                        [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%@ of %@ max players", [serverInformation players], [serverInformation maxPlayers]]];
                    }
                }
                    break;
                default:
                    break;
            }
            break;
            
        case 3: {
            switch ([indexPath row]) {
                case 0: {
                    [[cell textLabel] setText:@"Plugins"];
                    [[cell detailTextLabel] setText:[NSString string]];
                    
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 1) {
        if ([indexPath row] == 0) {
            [self performSegueWithIdentifier:kShowStaff sender:self];
        }
    }
    else if ([indexPath section] == 2) {
        if ([indexPath row] == 0) {
            [[self tabBarController] setSelectedIndex:1];
        }
    }
    else if ([indexPath section] == 3) {
        if ([indexPath row] == 0) {
            [TestFlight passCheckpoint:@"Clicked Show Plugins"];
            [self performSegueWithIdentifier:kShowPlugins sender:self];
        }
    }
    
    [[[self tableView] cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}

@end
