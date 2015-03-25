//
//  LoginViewController.h
//  Loyalty App
//
//  Created by Amit Parmar on 17/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonDelegateViewController.h"

@protocol CommonDelegateClass;

@interface LoginViewController : UIViewController <CommonDelegateClass>
{
    UITextField *txtUnm;
    UITextField *txtPwd;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
}
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;

@property (strong, nonatomic) IBOutlet UITextField *txtUnm;
@property (strong, nonatomic) IBOutlet UITextField *txtPwd;

- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnLoginClick:(id)sender;
- (IBAction)btnForgotClick:(id)sender;
- (IBAction)btnRegiClick:(id)sender;
- (IBAction)btnHideClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleLogin;

@end
