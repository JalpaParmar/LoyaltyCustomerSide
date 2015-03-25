//
//  RestaurantJoinedViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 8/13/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LBorderView.h"

@interface RestaurantJoinedViewController : UIViewController
{
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    AppDelegate *app;
    NSMutableArray *arrRestaurantJoinDetail;
    int joinIndexId;
    NSString *_fromDetail;
}
@property (strong, nonatomic) IBOutlet UIButton *btnBG;
//- (IBAction)hideParentView:(id)sender;
@property (nonatomic, strong)  NSString *_fromDetail;
@property (nonatomic, assign) int joinIndexId;
@property (nonatomic, strong) NSMutableArray *arrRestaurantJoinDetail;
@property (strong, nonatomic) IBOutlet UIButton *btnJoin;
@property (strong, nonatomic) IBOutlet UIButton *btnRestaurantDetail;
@property (strong, nonatomic) IBOutlet UIImageView *imgRestaurantIcon;

@property (strong, nonatomic) IBOutlet UILabel *lblOfferTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnDiamond;
@property (strong, nonatomic) IBOutlet UIButton *btnRedeem;
@property (strong, nonatomic) IBOutlet UIButton *btnUsed;
@property (strong, nonatomic) IBOutlet UIView *viewArrayOfbtnUsed;
@property (strong, nonatomic) IBOutlet UIView *viewArrayOfbtnRedeem;

@property (strong, nonatomic) IBOutlet UILabel *lblPurchasedQty;
@property (strong, nonatomic) IBOutlet UILabel *lblRewardQty;
@property (strong, nonatomic) IBOutlet UILabel *lblStartDate;
@property (strong, nonatomic) IBOutlet UILabel *lblEndDate;

@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantDistance;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantName;
@property (strong, nonatomic) IBOutlet UIView *viewForOffer;
@property (strong, nonatomic) IBOutlet LBorderView *viewForDetail;
- (IBAction)btnbackClick:(id)sender;
- (IBAction)btnRestaurantDetailClicked:(id)sender;
- (IBAction)btnJoinClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnQRCodeImage;
@property (strong, nonatomic) IBOutlet UILabel *lblCustomerId;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *viewCustomerQRCode;
@property (strong, nonatomic) IBOutlet UIButton *btnCustomerQRCode;
@property (strong, nonatomic) IBOutlet UIButton *btnClose;
- (IBAction)btnCustomerQRCodeClicked:(id)sender;
- (IBAction)btnCloseClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleMyCard;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleRestaurantJoined;

@end
