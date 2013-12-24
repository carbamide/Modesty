//
//  SocialTableViewController.m
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "SocialTableViewController.h"

@interface SocialTableViewController ()

@end

@implementation SocialTableViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SocialCell" forIndexPath:indexPath];
    
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
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row]) {
        case 0: {
            UIAlertView *twitterAlert = [[UIAlertView alloc] initWithTitle:@"Leaving Modesty"
                                                                   message:@"Clicking OK will leave the Modesty app and continue to Safari."
                                                                  delegate:self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:@"Cancel", nil];
            
            [twitterAlert setTag:0];
            [twitterAlert show];
        }
            break;
        case 1: {
            UIAlertView *instagramAlert = [[UIAlertView alloc] initWithTitle:@"Leaving Modesty"
                                                                   message:@"Clicking OK will leave the Modesty app and continue to Safari."
                                                                  delegate:self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:@"Cancel", nil];
            
            [instagramAlert setTag:1];
            [instagramAlert show];
        }
            break;
        default:
            break;
    }
    
    [[[self tableView] cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    switch ([alertView tag]) {
        case 0:
            if ([title isEqualToString:@"OK"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/modesty_mc"]];
            }
            break;
        case 1:
            if ([title isEqualToString:@"OK"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://instagram.com/degumaster"]];
            }
            break;
        default:
            break;
    }
}
@end
