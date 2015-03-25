//
//  FavoriteViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface FavoriteViewController : UIViewController
{
   __strong AppDelegate *app;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    NSMutableArray *arrFavoriteRestaurantList;
}
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleFavorite;
- (IBAction)btnBackClick:(id)sender;
@end
