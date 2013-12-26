//
//  SocialTableViewController.m
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "SocialTableViewController.h"

#define kTwitterURL @"https://twitter.com/modesty_mc"
#define kInstagramURL @"http://instagram.com/degumaster"
#define kForumURL @"http://www.minecraftmodesty.enjin.com/forum"

@interface SocialTableViewController ()

/**
 *  Creates a UIAlertView that informs the user that they're leaving the app.
 *
 *  @param tag Tag to pass to the UIAlertView delegate.  This allows opening the correct website.
 *
 *  @return Instantiated UIAlertView that will then need to be shown with [alertView show].
 */
-(UIAlertView *)leavingModestyAlertWithTag:(int)tag;
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
        default:
            return nil;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
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
                    UIAlertView *twitterAlert = [self leavingModestyAlertWithTag:0];
                    
                    [twitterAlert show];
                }
                    break;
                case 1: {
                    UIAlertView *instagramAlert = [self leavingModestyAlertWithTag:1];
                    
                    [instagramAlert show];
                }
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch ([indexPath row]) {
                case 0: {
                    UIAlertView *forumAlert = [self leavingModestyAlertWithTag:2];
                    
                    [forumAlert show];
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

#pragma mark -
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    switch ([alertView tag]) {
        case 0:
            if ([title isEqualToString:@"OK"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kTwitterURL]];
            }
            break;
        case 1:
            if ([title isEqualToString:@"OK"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kInstagramURL]];
            }
            break;
        case 2:
            if ([title isEqualToString:@"OK"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kForumURL]];
            }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark - Methods

-(UIAlertView *)leavingModestyAlertWithTag:(int)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Leaving Modesty"
                                                    message:@"Clicking OK will leave the Modesty app and continue to Safari."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    
    [alert setTag:tag];
    
    return alert;
}
@end
