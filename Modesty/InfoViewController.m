//
//  FirstViewController.m
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "InfoViewController.h"
#import "DataMapper.h"
#import "ModestyInfo.h"
#import "Server.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Modesty"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reloadTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
            return 2;
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
            return @"Player Count";
            break;
        case 2:
            return @"Advanced";
            break;
        default:
            return nil;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"InfoCell"];
        
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
            switch ([indexPath row]) {
                case 0: {
                    [[cell textLabel] setText:@"Players"];
                    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%@ of %@ max players", [serverInformation players], [serverInformation maxPlayers]]];
                }
                    break;
                default:
                    break;
            }
            break;
            
        case 2: {
            switch ([indexPath row]) {
                case 0: {
                    [[cell textLabel] setText:@"Server Version"];
                    [[cell detailTextLabel] setText:[serverInformation version]];
                }
                    break;
                case 1: {
                    [[cell textLabel] setText:@"Plugins"];
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
    if ([indexPath section] == 2) {
        if ([indexPath row] == 1) {
            [[[UIAlertView alloc] initWithTitle:@"Not Implemented" message:@"This feature is not yet implemented." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }
    
    [[[self tableView] cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}
@end
