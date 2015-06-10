//
//  ModestyTableViewController.h
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>

/**
 *  This is a subclass of UITableViewController.  It takes care of some of the across the board setup that
 *  was required for this application.
 */
@interface ModestyTableViewController : UITableViewController <SFSafariViewControllerDelegate>

/**
 *  Search text for search term
 *
 *  @param searchTerm The term to search the searchText for
 *  @param searchText The text to search
 *
 *  @return BOOL value if the searchText contains the searchTerm or not
 */
-(BOOL)contains:(NSString *)searchTerm on:(NSString *)searchText;

/**
 *  Calls the shared instance of DataMapper to refresh the data from the middle tier.
 */
-(void)refreshData;

/**
 *  Open UIWebView that shows the specified URL
 *
 *  @param url The URl to show in the webview
 */
-(void)initializeBrowserWithURL:(NSURL *)url;

@end
