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
@class UIPrintInteractionController;

@interface DeliveryOrderDetail : UIViewController<DLStarRatingDelegate, UIPrintInteractionControllerDelegate>
{
    AppDelegate *app;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    NSMutableArray *arrOrderDeliveredDetail;
    NSString *selectedOrderId;
    UIPrintInteractionController *printController;
    IBOutlet UIScrollView *scrlView;
    CGSize pageSize;
}
@property (nonatomic, strong) NSString *selectedOrderId;
@property (strong, nonatomic) NSMutableArray *arrOrderDeliveredDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderType;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderId;
@property (strong, nonatomic) IBOutlet UILabel *lblCustomerName;
@property (strong, nonatomic) IBOutlet UIButton *btnCashMode;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderdStatus;
@property (strong, nonatomic) IBOutlet UITableView *tblOrderDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblNetPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblDeliveryFee;
@property (strong, nonatomic) IBOutlet UILabel *lblTax;
@property (strong, nonatomic) IBOutlet UILabel *lblBenefitFromPoints, *lblRedeemPoints;
@property (strong, nonatomic) IBOutlet UILabel *lblGrandTotal;
@property (strong, nonatomic) IBOutlet UIButton *btnPrint;
- (IBAction)btnPrintClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *viewbackItemDetail, *viewForprintDetail, *viewwholeWithprint;


@end
