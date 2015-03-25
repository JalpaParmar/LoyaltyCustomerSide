//
//  MyAccountView.h
//  Loyalty App
//
//  Created by Amit Parmar on 19/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface HelpViewController : UIViewController
{
    AppDelegate *app;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
}
@property (strong, nonatomic) IBOutlet UIButton *btnReset, *btnCancel;
- (IBAction)btnResetClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtOldPassword;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleResetPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@end
