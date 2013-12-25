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
    return 3;
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
        case 2:
            [[cell textLabel] setText:@"Modesty Forums"];
            [[cell imageView] setImage:[UIImage imageNamed:@"modesty"]];
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
            UIAlertView *twitterAlert = [self leavingModestyAlertWithTag:0];
            
            [twitterAlert show];
        }
            break;
        case 1: {
            UIAlertView *instagramAlert = [self leavingModestyAlertWithTag:1];
            
            [instagramAlert show];
        }
            break;
        case 2: {
            UIAlertView *forumAlert = [self leavingModestyAlertWithTag:2];
            
            [forumAlert show];
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
        case 2:
            if ([title isEqualToString:@"OK"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.minecraftmodesty.enjin.com/forum"]];
            }
            break;
        default:
            break;
    }
}

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
