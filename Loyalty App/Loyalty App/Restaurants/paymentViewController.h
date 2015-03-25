//
//  paymentViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 7/23/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PayPalMobile.h"

@interface paymentViewController : UIViewController <PayPalPaymentDelegate>
{
    AppDelegate *app;
    NSMutableArray *arrPayment;
}
@property (nonatomic, strong) NSMutableArray *arrPayment;
@property (strong, nonatomic) IBOutlet UIButton *radioButton3;
@property (strong, nonatomic) IBOutlet UIButton *radioButton2;
@property (strong, nonatomic) IBOutlet UIButton *radioButton1;
@property (strong, nonatomic) IBOutlet UIButton *btnPayNow;

@property(nonatomic, strong, readwrite) IBOutlet UIView *successView;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(nonatomic, strong, readwrite) NSString *environment;

-(IBAction)radioButton1Selected;
-(IBAction)radioButton2Selected;
-(IBAction)radioButton3Selected;
-(void)setSelectedButton:(UIButton *)radioButton;

-(IBAction)payNowClicked:(id)sender;


@end
