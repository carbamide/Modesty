//
//  ModestyTableViewController.m
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "ModestyTableViewController.h"

@interface ModestyTableViewController ()

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
    
    [self setTitle:@"Modesty"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modestyUp) name:kModestyUp object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modestyDown) name:kModestyDown object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:kModestyUpdateFinished object:nil];
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
    });
}

@end
