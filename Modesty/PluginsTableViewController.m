//
//  PluginsTableViewController.m
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "PluginsTableViewController.h"
#import "DataMapper.h"
#import "ModestyInfo.h"
#import "Server.h"
#import "TestFlight.h"

@interface PluginsTableViewController ()
/**
 *  Subset datasource
 */
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation PluginsTableViewController

#pragma mark -
#pragma mark - View Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Plugins"];
    
    [TestFlight passCheckpoint:@"Loaded Plugins Controller"];

    [self setDataSource:[NSMutableArray array]];
    
    for (NSString *plugin in [[[[DataMapper sharedInstance] modestyInfo] serverInformation] plugins]) {
        if ([self contains:@"CaptureCraft" on:plugin] ||
            [self contains:@"DisguiseCraft" on:plugin] ||
            [self contains:@"mcMMO" on:plugin] ||
            [self contains:@"XPBanker" on:plugin]) {
            [_dataSource addObject:plugin];
        }
    }
    
    [_dataSource addObject:@"And Many More!"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - UITableViewDelegate and Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Bukkit Plugins";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self dataSource] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPluginCell forIndexPath:indexPath];
    
    NSString *plugin = [self dataSource][[indexPath row]];
    
    [[cell textLabel] setText:plugin];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    UIAlertView *leavingModestyAlert = nil;
    
    switch ([indexPath row]) {
        case 0:
        case 1:
        case 2:
        case 3:
            leavingModestyAlert = [self leavingModestyAlertWithTag:[indexPath row]];
            [leavingModestyAlert show];
            
            break;
        case 4: {
            UIAlertView *secretSauce = [[UIAlertView alloc] initWithTitle:@"Secret Sauce!"
                                                                  message:@"Part of what makes Modesty so great is the secret sauce of plugins that have created such a great environment for us to enjoy!  Come check it out!"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                        otherButtonTitles:@"OK", nil];
            
            [secretSauce setTag:4];
            [secretSauce show];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];

    switch ([alertView tag]) {
        case 0:
            if ([title isEqualToString:@"OK"]) {
                [TestFlight passCheckpoint:@"Opened XPBanker"];

                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kXpBanker]];
            }
            break;
        case 1:
            if ([title isEqualToString:@"OK"]) {
                [TestFlight passCheckpoint:@"Opened CaptureCraft"];

                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kCaptureCraft]];
            }
            break;
        case 2:
            if ([title isEqualToString:@"OK"]) {
                [TestFlight passCheckpoint:@"Opened DisguiseCraft"];

                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kDisguiseCraft]];
            }
            break;
        case 3:
            if ([title isEqualToString:@"OK"]) {
                [TestFlight passCheckpoint:@"Opened Mcmmo"];

                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kMcmmo]];
            }
            break;
        case 4:
            if ([title isEqualToString:@"OK"]) {
                [TestFlight passCheckpoint:@"Opened Modesty"];

                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kModestyHomepage]];
            }
            break;
        default:
            break;
    }
}

@end
