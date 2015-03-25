//
//  RegisterViewController.h
//  Loyalty App
//
//  Created by Amit Parmar on 17/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
{
    IBOutlet UIScrollView *scrlView;
    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtLastName;
    
    IBOutlet UITextField *txtRepwd;
    IBOutlet UITextField *txtPwd;
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtMoblie;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    BOOL TERMS;
    IBOutlet UIView *viewbackWebView, *viewTermsCindition;
    IBOutlet UIWebView *webview;
    IBOutlet UILabel *lblTitle;
    IBOutlet UIButton *btnDone, *btnBgBack, *btnDOB;
    IBOutlet UIDatePicker *pickerDate;
    NSString *selectedDate;
    IBOutlet UIView *viewDBO_iPhone;
    IBOutlet UIButton *btnDOBDone_iPhone;
    IBOutlet UIDatePicker *pickerDOB_iPhone;
}

@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnTerms;
@property (strong, nonatomic) IBOutlet UIButton *btnTermsText;

- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnRegiClick:(id)sender;
- (IBAction)btnAcceptTermsClick:(id)sender;
- (IBAction)btnReadTermsClick:(id)sender;
- (IBAction)btnDoneClicked:(id)sender;
- (IBAction)hideParentView:(id)sender;
- (IBAction)btnDOBClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleRegister;

@end
