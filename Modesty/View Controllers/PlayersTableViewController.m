//
//  SecondViewController.m
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "PlayersTableViewController.h"
#import "DataMapper.h"
#import "ModestyInfo.h"
#import "Player.h"
#import "Staff.h"

@interface PlayersTableViewController ()
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

/**
 *  Cache to store player avatars
 */
@property (strong, nonatomic) NSCache *imageCache;

@end

@implementation PlayersTableViewController

#pragma mark -
#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setImageCache:[[NSCache alloc] init]];
    
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

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    Server *serverInformation = [[[DataMapper sharedInstance] modestyInfo] serverInformation];
    
    if (serverInformation) {
        return [NSString stringWithFormat:@"%@ of %@ max players", [serverInformation players], [serverInformation maxPlayers]];
    }
    else {
        return @"No current player information";
    }
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
    else {
        [[cell imageView] setImage:nil];
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
    
    if ([[self imageCache] objectForKey:[tempPlayer username]]) {
        [[cell imageView] setImage:[[self imageCache] objectForKey:[tempPlayer username]]];
    }
    else {
        [self getUserImage:[tempPlayer username] forCell:cell];
    }
    
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
                [[self imageCache] setObject:image forKey:username];
                
                [[cell imageView] setNeedsLayout];
                [[cell imageView] setImage:image];
                
                [cell setNeedsLayout];
            });
        }
    }];
}

-(NSString *)rankForUsername:(NSString *)username
{
    for (Staff *staffMember in [[DataMapper sharedInstance] staff]) {
        if ([username isEqualToString:[staffMember username]]) {
            return [staffMember rank];
        }
    }
    
    return nil;
}

@end
