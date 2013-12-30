//
//  StaffTableViewController.m
//  Modesty
//
//  Created by Josh on 12/28/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "StaffTableViewController.h"
#import "DataMapper.h"
#import "ModestyInfo.h"
#import "Player.h"
#import "TestFlight.h"

#define kMinotarHelper @"https://minotar.net/helm/%@/30.png"

@interface StaffTableViewController ()

/**
 *  This local method gets the user's face as a UIImage and applies that UIImage to the imageView of cell.
 *
 *  This method could be improved by providing local caching.  I've not yet decided whether this should be a database
 *  or simply saving the images as png files in the user's documents folder.
 *
 *  @param username The username that needs to be retrieved.
 *  @param cell     The cell that contains the imageView that this UIImage will need to be applied to.
 */
-(void)getUserImage:(NSString *)username forCell:(UITableViewCell *)cell;

/**
 *  Returns the rank string for the given username
 *
 *  @param username The username to check against known users and ranks
 *
 *  @return The rank string for the given user
 */
-(NSString *)rankForUsername:(NSString *)username;

@property (strong, nonatomic) NSMutableArray *dataSource;
@end

@implementation StaffTableViewController

#pragma mark -
#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Staff"];
    
    [TestFlight passCheckpoint:@"Loaded Staff Controller"];
    
    _dataSource = [NSMutableArray array];
    
    for (NSArray *array in [[DataMapper sharedInstance] staff]) {
        for (NSDictionary *dict in array) {
            [_dataSource addObject:dict[@"username"]];
        }
    }
}

-(void)refreshData
{
    [super refreshData];
    
    [_dataSource removeAllObjects];
    
    for (NSArray *array in [[DataMapper sharedInstance] staff]) {
        for (NSDictionary *dict in array) {
            [_dataSource addObject:dict[@"username"]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark UITableViewDelegate and Datasource

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Staff Members";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlayerCell];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kPlayerCell];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    NSString *username = [self dataSource][[indexPath row]];
    
    [[cell textLabel] setText:username];
    
    if ([username isEqualToString:kDeguMaster]) {
        [[cell detailTextLabel] setText:kOwner];
    }
    else if ([self contains:kSimplySte on:username] || [self contains:kFuschii on:username]) {
        [[cell detailTextLabel] setText:kCoOwner];
    }
    else if ([self contains:kMrsDeguMaster on:username]) {
        [[cell detailTextLabel] setText:kQueen];
    }
    else {
        [[cell detailTextLabel] setText:[self rankForUsername:username]];
    }
    
    [self getUserImage:username forCell:cell];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [TestFlight passCheckpoint:@"Clicked a username in Players Controller"];
    
    [[[self tableView] cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}

#pragma mark -
#pragma mark - Methods

-(void)getUserImage:(NSString *)username forCell:(UITableViewCell *)cell
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:kMinotarHelper, username]]];
    
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[cell imageView] setImage:image];
                [[cell imageView] setNeedsLayout];
                [cell setNeedsLayout];
            });
        }
    }];
}

-(NSString *)rankForUsername:(NSString *)username
{
    /*
     @owners = User.where('rank' => 'Owner')
     @coowners = User.where('rank' => 'Co-Owner')
     @queens = User.where('rank' => 'Queen')
     @ops = User.where('rank' => 'OP')
     @admins = User.where('rank' => 'Admin')
     @modmins = User.where('rank' => 'Modmin')
     @mods = User.where('rank' => 'Mod')
     @minimods = User.where('rank' => 'Minimod')
     */
    NSArray *owners = [[DataMapper sharedInstance] staff][0];
    NSArray *coowners = [[DataMapper sharedInstance] staff][1];
    NSArray *queens = [[DataMapper sharedInstance] staff][2];
    NSArray *ops = [[DataMapper sharedInstance] staff][3];
    NSArray *admins = [[DataMapper sharedInstance] staff][4];
    NSArray *modmins = [[DataMapper sharedInstance] staff][5];
    NSArray *mods = [[DataMapper sharedInstance] staff][6];
    NSArray *minimods = [[DataMapper sharedInstance] staff][7];
    
    for (NSDictionary *staffMember in owners) {
        if ([username isEqualToString:staffMember[@"username"]]) {
            return kOwner;
        }
    }
    
    for (NSDictionary *staffMember in coowners) {
        if ([username isEqualToString:staffMember[@"username"]]) {
            return kCoOwner;
        }
    }
    
    for (NSDictionary *staffMember in queens) {
        if ([username isEqualToString:staffMember[@"username"]]) {
            return kQueen;
        }
    }
    
    for (NSDictionary *staffMember in ops) {
        if ([username isEqualToString:staffMember[@"username"]]) {
            return kOp;
        }
    }
    
    for (NSDictionary *staffMember in admins) {
        if ([username isEqualToString:staffMember[@"username"]]) {
            return kAdmin;
        }
    }
    
    for (NSDictionary *staffMember in modmins) {
        if ([username isEqualToString:staffMember[@"username"]]) {
            return kModmin;
        }
    }
    
    for (NSDictionary *staffMember in mods) {
        if ([username isEqualToString:staffMember[@"username"]]) {
            return kMod;
        }
    }
    
    for (NSDictionary *staffMember in minimods) {
        if ([username isEqualToString:staffMember[@"username"]]) {
            return kMinimod;
        }
    }
    
    return nil;
}

@end
