//
//  StaffTableViewController.m
//  Modesty
//
//  Created by Josh on 12/28/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "StaffTableViewController.h"
#import "DataMapper.h"
#import "Modesty-Swift.h"

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
 *  Cache to store player avatars
 */
@property (strong, nonatomic) NSCache *imageCache;

@end

@implementation StaffTableViewController

#pragma mark -
#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Staff"];
}

-(void)refreshData
{
    [super refreshData];
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
    return [[[DataMapper sharedInstance] staff] count];
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
    
    Staff *staffMember = [[DataMapper sharedInstance] staff][[indexPath row]];
    
    [[cell textLabel] setText:[staffMember username]];
    
    [[cell detailTextLabel] setText:[staffMember rank]];
    
    if ([[self imageCache] objectForKey:[staffMember username]]) {
        [[cell imageView] setImage:[[self imageCache] objectForKey:[staffMember username]]];
    }
    else {
        [self getUserImage:[staffMember username] forCell:cell];
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
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self imageCache] setObject:image forKey:username];
                
                if ([[self tableView] indexPathForCell:cell]) {
                    [[cell imageView] setNeedsLayout];
                    [[cell imageView] setImage:image];
                    
                    [cell setNeedsLayout];
                }
            });
        }
    }] resume];
}

@end
