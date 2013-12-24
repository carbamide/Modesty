//
//  DataMapper.m
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "DataMapper.h"
#import "ModestyInfo.h"

#define kAPIURL @"http://aqueous-lowlands-3303.herokuapp.com"
#define kPingURL @"http://aqueous-lowlands-3303.herokuapp.com/ping.php"

@interface DataMapper ()
@property (strong, nonatomic) NSTimer *pingTimer;

-(void)mapToModestyInfo:(NSDictionary *)dict;
@end

@implementation DataMapper

+ (DataMapper *)sharedInstance
{
    static dispatch_once_t once;
    static DataMapper *instance;
    
    dispatch_once(&once, ^{
        instance = [[DataMapper alloc] init];
    });
    
    return instance;
}

-(instancetype)init
{
    if (self = [super init]) {
        _pingTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(pingModesty) userInfo:nil repeats:YES];
        [self pingModesty];
    }
    
    return self;
}

-(void)pingModesty
{
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kPingURL]];
    
    [urlRequest setHTTPMethod:@"GET"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"There was an error downloading the ping data.");
        }
        
        NSError *parsingError = nil;
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parsingError];
        
        if (parsingError) {
            NSLog(@"An error has occurred parsing the json response.");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([responseDict[@"status"] isEqualToString:@"up"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"modesty_up" object:nil];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"modesty_down" object:nil];
            }
        });
    }] resume];
}

-(void)refreshInformation
{
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kAPIURL]];
    
    [urlRequest setHTTPMethod:@"GET"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"An error has occurred downloading the json.");
            
            return;
        }
        
        NSError *jsonError = nil;
        
        NSDictionary *modestyDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            NSLog(@"An error has occurred parsing the json.");
            
            return;
        }
        
        [self mapToModestyInfo:modestyDict];
    }] resume];
}

-(void)mapToModestyInfo:(NSDictionary *)dict
{
    ModestyInfo *modestyInfo = [[ModestyInfo alloc] init];
    
    NSMutableArray *playersArray = [NSMutableArray array];
    
    for (NSString *playerName in dict[@"players"]) {
        Player *tempPlayer = [[Player alloc] init];
        
        [tempPlayer setUsername:playerName];
        
        [playersArray addObject:tempPlayer];
    }
    
    [modestyInfo setPlayers:playersArray];
    
    NSDictionary *tempInfoDict = dict[@"info"];
    
    Server *tempServer = [[Server alloc] init];
    
    NSMutableArray *tempPluginArray = [NSMutableArray array];
    
    for (NSString *plugin in tempInfoDict[@"Plugins"]) {
        [tempPluginArray addObject:plugin];
    }
    
    [tempServer setPlugins:tempPluginArray];
    [tempServer setHostIp:tempInfoDict[@"HostIp"]];
    [tempServer setVersion:tempInfoDict[@"Version"]];
    [tempServer setGameType:tempInfoDict[@"GameType"]];
    [tempServer setSoftware:tempInfoDict[@"Software"]];
    [tempServer setHostName:tempInfoDict[@"HostName"]];
    [tempServer setMaxPlayers:tempInfoDict[@"MaxPlayers"]];
    [tempServer setMap:tempInfoDict[@"Map"]];
    [tempServer setPlayers:tempInfoDict[@"Players"]];
    [tempServer setHostPort:tempInfoDict[@"HostPort"]];
    
    [modestyInfo setServerInformation:tempServer];
    
    [self setModestyInfo:modestyInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"finished_updating_information" object:nil];
}

@end
