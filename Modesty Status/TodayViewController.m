//
//  TodayViewController.m
//  Modesty Status
//
//  Created by Joshua Barrow on 6/8/14.
//  Copyright (c) 2014 Jukaela Enterprises. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "DataMapper.h"
#import "Constants.h"

@interface TodayViewController () <NCWidgetProviding>
@property (strong, nonatomic) IBOutlet UIImageView *statusImage;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation TodayViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pingModesty];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    completionHandler(NCUpdateResultNewData);
}

-(void)pingModesty
{
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kPingURL]];
    
    [urlRequest setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"There was an error downloading the ping data.");
            
            [self modestyDown];
        }
        
        NSError *parsingError = nil;
        
        if (data) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parsingError];
            
            if (parsingError) {
                NSLog(@"An error has occurred parsing the json response.");
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([responseDict[@"status"] isEqualToString:kModestyUp]) {
                    [self modestyUp];
                }
                else {
                    [self modestyDown];
                }
            });
            
        }
        else {
            [self modestyDown];
        }
    }];
}

-(void)modestyUp
{
    [[self statusImage] setImage:[UIImage imageNamed:kModestyUpImage]];
    [[self statusLabel] setText:@"Modesty is up!"];
}

-(void)modestyDown
{
    [[self statusImage] setImage:[UIImage imageNamed:kModestyDownImage]];
    [[self statusLabel] setText:@"Modesty is down!"];
}

@end
