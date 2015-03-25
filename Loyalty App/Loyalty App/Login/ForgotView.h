//
//  ForgotView.h
//  Loyalty App
//
//  Created by Amit Parmar on 18/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotView : UIViewController
{
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;

    
}
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutlet UITextField *txtEmailId;
- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnHideClick:(id)sender;
- (IBAction)btnSubmitClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleForgot;

@end
