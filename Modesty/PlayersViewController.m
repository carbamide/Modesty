//
//  SecondViewController.m
//  Modesty
//
//  Created by Josh on 12/24/13.
//  Copyright (c) 2013 Jukaela Enterprises. All rights reserved.
//

#import "PlayersViewController.h"
#import "DataMapper.h"
#import "ModestyInfo.h"
#import "Player.h"

@interface PlayersViewController ()

@end

@implementation PlayersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Players"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[[DataMapper sharedInstance] modestyInfo] players] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlayerCell];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ModestyCell"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    Player *tempPlayer = [[[DataMapper sharedInstance] modestyInfo] players][[indexPath row]];
    
    [[cell textLabel] setText:[tempPlayer username]];
    
    [self getUserImage:[tempPlayer username] forCell:cell];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[self tableView] cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}

-(void)getUserImage:(NSString *)username forCell:(UITableViewCell *)cell
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://minotar.net/helm/%@/150.png", username]]];
    
    [request setHTTPMethod:@"GET"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[cell imageView] setImage:image];
                [[cell imageView] setNeedsLayout];
                [cell setNeedsLayout];
            });
        }
    }] resume];
}
@end
