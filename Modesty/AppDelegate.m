//
//  AppDelegate.m
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "AppDelegate.h"
#import "DataMapper.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [[self window] setTintColor:UIColorFromRGB(0x299a24)];
        
        NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
        [titleBarAttributes addEntriesFromDictionary:@{NSFontAttributeName: [UIFont fontWithName:kFont size:34]}];
        
        [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
        [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:5 forBarMetrics:UIBarMetricsDefault];
    }
    
    [[DataMapper sharedInstance] refreshInformation];
    
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSDictionary *jsonDict = @{@"token": token};
    
    NSLog(@"%@", token);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://safe-retreat-6833.herokuapp.com/device_tokens"]];
    
    NSError *error = nil;
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&error]];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    if (error) {
        NSLog(@"An error has occurred during the creation of the json data object for sending tokens");
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            NSLog(@"The token has been created serverside");
        }
        else {
            NSLog(@"An error has occurred while creating the token serverside.");
        }
    }] resume];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *alertMsg = nil;
    
    if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"] != NULL) {
        alertMsg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    }
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Modesty"
                                                                        message:alertMsg
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];

    [[[self window] rootViewController] presentViewController:controller animated:YES completion:nil];
}

-(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler
{
    restorationHandler(@[self.window.rootViewController]);
    
    return true;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[DataMapper sharedInstance] refreshInformation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
