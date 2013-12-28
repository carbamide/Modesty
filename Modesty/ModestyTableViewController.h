//
//  ModestyTableViewController.h
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  This is a subclass of UITableViewController.  It takes care of some of the across the board setup that
 *  was required for this application.
 */
@interface ModestyTableViewController : UITableViewController

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
 *  Creates a UIAlertView that informs the user that they're leaving the app.
 *
 *  @param tag Tag to pass to the UIAlertView delegate.  This allows opening the correct website.
 *
 *  @return Instantiated UIAlertView that will then need to be shown with [alertView show].
 */
-(UIAlertView *)leavingModestyAlertWithTag:(NSInteger)tag;

@end
