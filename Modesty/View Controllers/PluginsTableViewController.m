//
//  PluginsTableViewController.m
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "PluginsTableViewController.h"
#import "DataMapper.h"
#import "Modesty-Swift.h"

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
    
    NSString *cellTitle = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    
    if ([self contains:@"XPBanker" on:cellTitle]) {
        [self initializeBrowserWithURL:[NSURL URLWithString:kXpBanker]];
    }
    else if ([self contains:@"CaptureCraft" on:cellTitle]) {
        [self initializeBrowserWithURL:[NSURL URLWithString:kCaptureCraft]];
    }
    else if ([self contains:@"DisguiseCraft" on:cellTitle]) {
        [self initializeBrowserWithURL:[NSURL URLWithString:kDisguiseCraft]];
    }
    else if ([self contains:@"mcMMO" on:cellTitle]) {
        [self initializeBrowserWithURL:[NSURL URLWithString:kMcmmo]];
    }
    else {
        UIAlertView *secretSauce = [[UIAlertView alloc] initWithTitle:@"Secret Sauce!"
                                                              message:@"Part of what makes Modesty so great is the secret sauce of plugins that have created such a great environment for us to enjoy!  Come check it out!"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"OK", nil];
        
        [secretSauce setTag:0];
        [secretSauce show];
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
                [self initializeBrowserWithURL:[NSURL URLWithString:kModestyHomepage]];

            }
            break;
        default:
            break;
    }
}

@end
