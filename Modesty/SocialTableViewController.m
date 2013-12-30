//
//  SocialTableViewController.m
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "SocialTableViewController.h"
#import "TestFlight.h"

#define kTwitterURL @"https://twitter.com/modesty_mc"
#define kInstagramURL @"http://instagram.com/degumaster"
#define kForumURL @"http://www.minecraftmodesty.enjin.com/forum"
#define kFacebookURL @"https://www.facebook.com/minecraftmodesty"

@interface SocialTableViewController ()
@end

@implementation SocialTableViewController

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
    
    [self setTitle:@"Social"];
    
    [TestFlight passCheckpoint:@"Loaded Social Controller"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - UITableViewDelegate and Datasource

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Social Networks";
            break;
        case 1:
            return @"Websites";
            break;
        case 2:
            return @"Voting";
        default:
            return nil;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSocialCell forIndexPath:indexPath];
    
    switch ([indexPath section]) {
        case 0:
            switch ([indexPath row]) {
                case 0:
                    [[cell textLabel] setText:@"Twitter"];
                    [[cell imageView] setImage:[UIImage imageNamed:@"twitter"]];
                    break;
                case 1:
                    [[cell textLabel] setText:@"Instagram"];
                    [[cell imageView] setImage:[UIImage imageNamed:@"instagram"]];
                    break;
                case 2:
                    [[cell textLabel] setText:@"Facebook"];
                    [[cell imageView] setImage:[UIImage imageNamed:@"facebook"]];
                default:
                    break;
            }
            break;
        case 1:
            switch ([indexPath row]) {
                case 0:
                    [[cell textLabel] setText:@"Modesty Forums"];
                    [[cell imageView] setImage:[UIImage imageNamed:@"modesty"]];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch ([indexPath row]) {
                case 0:
                    [[cell textLabel] setText:@"PlanetMinecraft"];
                    [[cell imageView] setImage:[UIImage imageNamed:@"modesty"]];
                    break;
                case 1:
                    [[cell textLabel] setText:@"Minecraftservers.org"];
                    [[cell imageView] setImage:[UIImage imageNamed:@"modesty"]];
                    break;
                case 2:
                    [[cell textLabel] setText:@"Minecraft Servers List"];
                    [[cell imageView] setImage:[UIImage imageNamed:@"modesty"]];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case 0:
            switch ([indexPath row]) {
                case 0: {
                    [TestFlight passCheckpoint:@"Opened Twitter"];
                    
                    [self initializeBrowserWithURL:[NSURL URLWithString:kTwitterURL]];
                }
                    break;
                case 1: {
                    [TestFlight passCheckpoint:@"Opened Instagram"];
                    
                    [self initializeBrowserWithURL:[NSURL URLWithString:kInstagramURL]];
                }
                    break;
                case 2: {
                    [TestFlight passCheckpoint:@"Opened Facebook"];
                    
                    [self initializeBrowserWithURL:[NSURL URLWithString:kFacebookURL]];
                }
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch ([indexPath row]) {
                case 0: {
                    [TestFlight passCheckpoint:@"Opened Forum"];
                    
                    [self initializeBrowserWithURL:[NSURL URLWithString:kForumURL]];
                }
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch ([indexPath row]) {
                case 0: {
                    [TestFlight passCheckpoint:@"Opened Planetminecraft"];
                    
                    [self initializeBrowserWithURL:[NSURL URLWithString:@"http://www.planetminecraft.com/server/modesty/"]];
                }
                    break;
                case 1: {
                    [TestFlight passCheckpoint:@"Opened Minecraftservers.org"];
                    
                    [self initializeBrowserWithURL:[NSURL URLWithString:@"http://minecraftservers.org/server/6465"]];
                }
                    break;
                case 2: {
                    [TestFlight passCheckpoint:@"Opened Minecraft Servers List"];
                    
                    [self initializeBrowserWithURL:[NSURL URLWithString:@"http://minecraft-server-list.com/server/128633/vote/"]];
                }
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
            
    }
    [[[self tableView] cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}
@end
