//
//  homeDeliveryViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 7/22/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface homeDeliveryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    int selectedRow;
    UIImageView *imageArrow;
    IBOutlet UITableView *tblCategory;
    AppDelegate *app;
   // UIImageView *imageArrow ;
    NSMutableArray *arrCategoryList, *arrItemList;
    int indexId;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    BOOL IS_Order_StartDelete;
    IBOutlet UIButton *btnLoyaltyPoints;
    IBOutlet UILabel *lblTotal;
}

@property (strong, nonatomic) IBOutlet UITableView *tblVW;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollCategory;
-(IBAction)SeachClicked:(id)sender;
- (IBAction)btnBackClick:(id)sender;
-(void)startActivity;
-(void)stopActivity;
@property (strong, nonatomic) IBOutlet UIButton *btnOrderList;
- (IBAction)btnOrderListClicked:(id)sender;
- (IBAction)btnLoyaltyPointsClicked:(id)sender;

@end
