//
//  orderListViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DLStarRatingControl.h"

@interface orderListViewController : UIViewController<DLStarRatingDelegate>
{
    AppDelegate *app;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    NSString *strURL;
    int index_Rating;
}
@property (strong, nonatomic) IBOutlet UIView *viewrating;
@property (strong, nonatomic) IBOutlet UILabel *lblrating;

@property (strong, nonatomic) NSMutableArray *arrFood, *arrReservation;
@property (strong, nonatomic) NSMutableArray *arrOrderHistory;
@property (strong, nonatomic) IBOutlet UIButton *btnReservation;
@property (strong, nonatomic) IBOutlet UIButton *btnFood;
- (IBAction)btnFoodReservationClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tblOrderHistory;
- (IBAction)btnBackClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleOrderHistory;
@end
