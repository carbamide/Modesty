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
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation ModestyTableViewController

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
    
    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"background"] forBarMetrics:UIBarMetricsDefault];

    [[[self tabBarController] tabBar] setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
    
    [self setRefreshControl:[[UIRefreshControl alloc] init]];

    [[self refreshControl] addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    [self setTitle:@"Modesty"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modestyUp) name:kModestyUp object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modestyDown) name:kModestyDown object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:kModestyUpdateFinished object:nil];
}

-(void)refreshData
{
    [[DataMapper sharedInstance] refreshInformation];
}

-(void)modestyUp
{
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kModestyUpImage] style:UIBarButtonItemStyleBordered target:nil action:nil]];
}

-(void)modestyDown
{
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kModestyDownImage] style:UIBarButtonItemStyleBordered target:nil action:nil]];
}

-(void)reloadTable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self tableView] reloadData];
        
        [[self refreshControl] endRefreshing];
    });
}

@end
