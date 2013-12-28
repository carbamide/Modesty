//
//  AppDelegate.m
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "AppDelegate.h"
#import "DataMapper.h"
#import "TestFlight.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TestFlight takeOff:@"2f1ee9be-d0ff-489b-9764-8bca95a2f364"];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [[self window] setTintColor:UIColorFromRGB(0x299a24)];
        
        NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
        [titleBarAttributes addEntriesFromDictionary:@{UITextAttributeFont: [UIFont fontWithName:@"MinecraftEvenings" size:34]}];

        [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
        [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:5 forBarMetrics:UIBarMetricsDefault];
    }
    
    [[DataMapper sharedInstance] refreshInformation];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
