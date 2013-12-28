//
//  Constants.h
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

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
static NSString *const kXpBanker = @"http://dev.bukkit.org/bukkit-plugins/xpbanker/";
static NSString *const kCaptureCraft = @"http://dev.bukkit.org/bukkit-plugins/capture-craft/";
static NSString *const kDisguiseCraft = @"http://dev.bukkit.org/bukkit-plugins/disguisecraft/";
static NSString *const kMcmmo = @"http://dev.bukkit.org/bukkit-plugins/mcmmo/";
static NSString *const kModestyHomepage = @"http://www.minecraftmodesty.enjin.com";
static NSString *const kStaffJson = @"http://aqueous-lowlands-3303.herokuapp.com/staff.json";

#pragma mark -
#pragma mark - Special Usernames

static NSString *const kDeguMaster = @"DeguMaster";
static NSString *const kSimplySte = @"SimplySte";
static NSString *const kFuschii = @"fuschii";
static NSString *const kMrsDeguMaster = @"Mrs_DeguMaster";

#pragma mark -
#pragma mark - Ranks

static NSString *const kOwner = @"Owner";
static NSString *const kCoOwner = @"Co-Owner";
static NSString *const kQueen = @"Queen";
static NSString *const kOp = @"OP";
static NSString *const kAdmin = @"Admin";
static NSString *const kModmin = @"Modmin";
static NSString *const kMod = @"Mod";
static NSString *const kMinimod = @"Minimod";
static NSString *const kExecutive = @"Executive";
static NSString *const kEngineer = @"Engineer";
static NSString *const kContractor = @"Contractor";
static NSString *const kCrafter = @"Crafter";
static NSString *const kBuilder = @"Builder";
static NSString *const kNewPlayer = @"New Player";
static NSString *const kVipPlus = @"VIP+";
static NSString *const kVip = @"VIP";
static NSString *const kTimeyWimey = @"Timey Wimey";


