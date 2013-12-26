//
//  Constants.h
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark - Api

static NSString *const kApiPlayers = @"players";
static NSString *const kApiInfo = @"info";
static NSString *const kApiPlugins = @"Plugins";
static NSString *const kApiHostIp = @"HostIp";
static NSString *const kApiVersion = @"Version";
static NSString *const kApiGameType = @"GameType";
static NSString *const kApiSoftware = @"Software";
static NSString *const kApiHostName = @"HostName";
static NSString *const kApiMaxPlayers = @"MaxPlayers";
static NSString *const kApiMap = @"Map";
static NSString *const kApiPlayersArray = @"Players";
static NSString *const kApiHostPort = @"HostPort";

#pragma mark - 
#pragma mark - Notifications

static NSString *const kModestyUpdateFinished = @"finished_updating_information";
static NSString *const kModestyUp = @"up";
static NSString *const kModestyDown = @"down";

#pragma mark -
#pragma mark - Images

static NSString *const kModestyUpImage = @"up";
static NSString *const kModestyDownImage = @"down";

#pragma mark -
#pragma mark - Cells

static NSString *const kSocialCell = @"SocialCell";
static NSString *const kInfoCell = @"InfoCell";
static NSString *const kPlayerCell = @"ModestyCell";
static NSString *const kPluginCell = @"PluginCell";

#pragma mark -
#pragma mark - Segues

static NSString *const kShowPlugins = @"ShowPlugins";

#pragma mark - 
#pragma mark - URLS

static NSString *const kAPIURL = @"http://aqueous-lowlands-3303.herokuapp.com";
static NSString *const kPingURL = @"http://aqueous-lowlands-3303.herokuapp.com/ping.php";
static NSString *const kEnjinApi = @"http://www.minecraftmodesty.enjin.com/api/get-users";
static NSString *const kTwitterURL = @"https://twitter.com/modesty_mc";
static NSString *const kInstagramURL = @"http://instagram.com/degumaster";
static NSString *const kForumURL = @"http://www.minecraftmodesty.enjin.com/forum";