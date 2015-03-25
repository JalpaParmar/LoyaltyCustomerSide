//
//  addOrderViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 7/23/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface RedeemOrderViewController : UIViewController
{
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    AppDelegate *app;
 
    NSMutableArray *arrRedeemOrderDetail;
    IBOutlet UILabel *lblPoints, *lblGrandTotal;
    IBOutlet UIButton *btnSubmit, *btnPoints;
    IBOutlet UITextField *txtRedeem;
    float onePoint, oneAmount, total_points, grandTotal;
    NSString *currencySign, *alertMsg;
    BOOL IS_SUCCESS;
    
    IBOutlet UITextField *txtOTP;
    IBOutlet UIButton *btnOTPSend, *btnOTPResend;
    
}
@property (strong, nonatomic) NSMutableArray *arrRedeemOrderDetail;

@property (strong, nonatomic) IBOutlet UITextField *txtRedeem;
@property (strong, nonatomic) IBOutlet UILabel *lblPoints, *lblGrandTotal;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit, *btnPoints;
@property (strong, nonatomic) IBOutlet UIButton *btnSave, *btnCancel, *btnBGBack;
@property (strong, nonatomic) IBOutlet UIView *viewParentCashMode, *viewChildCashMode;
@property (strong, nonatomic) IBOutlet UIButton *radioButton2;
@property (strong, nonatomic) IBOutlet UIButton *radioButton1;

-(IBAction)btnSubmitClicked:(id)sender;
- (IBAction)btnBackClick:(id)sender;

- (IBAction)btnCashModeSaveClick:(id)sender;
- (IBAction)btnCashModeCancelClick:(id)sender;
- (IBAction)btnOTPResendClick:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *lblTitleAddOrder;

@end
