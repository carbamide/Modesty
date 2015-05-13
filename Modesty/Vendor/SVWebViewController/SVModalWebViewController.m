//
//  SVModalWebViewController.m
//
//  Created by Oliver Letterer on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVModalWebViewController.h"
#import "SVWebViewController.h"

@interface SVWebViewController ()
-(void)doneButtonClicked:(id)sender;
@end

@interface SVModalWebViewController ()

@property (nonatomic, strong) SVWebViewController *webViewController;

@end


@implementation SVModalWebViewController

#pragma mark - Initialization


- (id)initWithAddress:(NSString*)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL *)URL {
    self.webViewController = [[SVWebViewController alloc] initWithURL:URL];
    if (self = [super initWithRootViewController:self.webViewController]) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self.webViewController
                                                                                    action:@selector(doneButtonClicked:)];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            self.webViewController.navigationItem.leftBarButtonItem = doneButton;
        else
            self.webViewController.navigationItem.rightBarButtonItem = doneButton;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [[self navigationBar] setBackgroundImage:[UIImage imageNamed:@"background"] forBarMetrics:UIBarMetricsDefault];
            [[self toolbar] setBackgroundImage:[UIImage imageNamed:@"background"] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
        }
        else {
            [[self navigationBar] setBackgroundImage:[UIImage imageNamed:@"background_ios6"] forBarMetrics:UIBarMetricsDefault];
            [[self toolbar] setBackgroundImage:[UIImage imageNamed:@"background"] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
        }
        
        [[self navigationBar] setBarStyle:UIBarStyleBlack];
        [[self toolbar] setBarStyle:UIBarStyleBlack];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    self.webViewController.title = self.title;
}

@end
