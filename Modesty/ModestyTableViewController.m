//
//  ModestyTableViewController.m
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "ModestyTableViewController.h"
#import "DataMapper.h"

@interface ModestyTableViewController ()
/**
 *  Refresh control that is used across all instances.
 */
@property (strong, nonatomic) UIRefreshControl *refreshControl;

/**
 *  Calls the shared instance of DataMapper to refresh the data from the middle tier.
 */
-(void)refreshData;

/**
 *  Displays an alert telling the user that modesty is up.
 */
-(void)modestyUpAlert;

/**
 *  Displays an alert telling the user that Modesty is down.
 */
-(void)modestyDownAlert;

@end

@implementation ModestyTableViewController

#pragma mark -
#pragma mark - View Lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"background"] forBarMetrics:UIBarMetricsDefault];
    }
    else {
        [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"background_ios6"] forBarMetrics:UIBarMetricsDefault];
    }
    
    [[[self tabBarController] tabBar] setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
    
    [self setRefreshControl:[[UIRefreshControl alloc] init]];
    [[self refreshControl] addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    [self setTitle:@"Modesty"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modestyUp) name:kModestyUp object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modestyDown) name:kModestyDown object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:kModestyUpdateFinished object:nil];
}

#pragma mark -
#pragma mark - Notification Handlers

-(void)modestyUp
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:kModestyUpImage] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(modestyUpAlert) forControlEvents:UIControlEventTouchUpInside];

    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
}

-(void)modestyDown
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:kModestyDownImage] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(modestyDownAlert) forControlEvents:UIControlEventTouchUpInside];
    
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
}

-(void)reloadTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self tableView] reloadData];
        
        [[self refreshControl] endRefreshing];
    });
}

#pragma mark -
#pragma mark - Methods

-(void)refreshData
{
    [[DataMapper sharedInstance] refreshInformation];
}

-(void)modestyUpAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Modesty is Up!"
                                message:@"Modesty appears to be up!  Yay!"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil, nil] show];
}

-(void)modestyDownAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Modesty is Down!"
                                message:@"Modesty appears to be down!  :-("
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil, nil] show];
    
}



@end
