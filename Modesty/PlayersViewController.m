//
//  SecondViewController.m
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "PlayersViewController.h"
#import "DataMapper.h"
#import "ModestyInfo.h"
#import "Player.h"

#define kMinotarHelper @"https://minotar.net/helm/%@/30.png"

@interface PlayersViewController ()
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

@end

@implementation PlayersViewController

#pragma mark -
#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Players"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 
#pragma mark UITableViewDelegate and Datasource

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Currently Playing";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[[DataMapper sharedInstance] modestyInfo] players] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlayerCell];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kPlayerCell];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    Player *tempPlayer = [[[DataMapper sharedInstance] modestyInfo] players][[indexPath row]];
    
    [[cell textLabel] setText:[tempPlayer username]];
    
    if ([[tempPlayer username] isEqualToString:kDeguMaster]) {
        [[cell detailTextLabel] setText:kOwner];
    }
    else if ([self contains:kSimplySte on:[tempPlayer username]] || [self contains:kFuschii on:[tempPlayer username]]) {
        [[cell detailTextLabel] setText:kCoOwner];
    }
    else if ([self contains:kMrsDeguMaster on:[tempPlayer username]]) {
        [[cell detailTextLabel] setText:kQueen];
    }
    else {
        [[cell detailTextLabel] setText:[self rankForUsername:[tempPlayer username]]];
    }

    [self getUserImage:[tempPlayer username] forCell:cell];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    NSArray *ops = [[DataMapper sharedInstance] staff][@"op"];
    NSArray *admins = [[DataMapper sharedInstance] staff][@"admin"];
    NSArray *modmins = [[DataMapper sharedInstance] staff][@"modmin"];
    NSArray *minimods = [[DataMapper sharedInstance] staff][@"minimod"];
    NSArray *mods = [[DataMapper sharedInstance] staff][@"mod"];
    
    for (NSString *staff in ops) {
        if ([staff isEqualToString:username]) {
            return kOp;
        }
    }

    for (NSString *staff in admins) {
        if ([staff isEqualToString:username]) {
            return kAdmin;
        }
    }
    
    for (NSString *staff in modmins) {
        if ([staff isEqualToString:username]) {
            return kModmin;
        }
    }
    
    for (NSString *staff in minimods) {
        if ([staff isEqualToString:username]) {
            return kMinimod;
        }
    }
    
    for (NSString *staff in mods) {
        if ([staff isEqualToString:username]) {
            return kMod;
        }
    }
    
    return nil;
}

@end
