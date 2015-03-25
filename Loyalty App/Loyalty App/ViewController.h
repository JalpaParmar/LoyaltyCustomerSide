//
//  ViewController.h
//  Loyalty App
//
//  Created by Amit Parmar on 17/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FbGraph.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CommonDelegateViewController.h"

@protocol CommonDelegateClass;

@interface ViewController : UIViewController <FBLoginViewDelegate, CommonDelegateClass>
{
    AppDelegate *app;
    FbGraph *fbGraph;
   
    IBOutlet UITextField *txtFBFirstname;

    IBOutlet UIButton *btnDOBDone;
    IBOutlet UIView *viewPickerDOB, * viewForLoader;
    IBOutlet UIButton *btnBG;
    IBOutlet UIButton *btnFBDOB;
    IBOutlet UIButton *btnFBSubmit;
    IBOutlet UITextField *txtFBEmail;
    IBOutlet UITextField *txtFBLastname;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    IBOutlet UIDatePicker *pickerDOB;
    
    IBOutlet UIView *viewFBData;
    NSDictionary * userData;
    NSString *fbAccessToken, *deviceToken;
}
@property (strong, nonatomic) IBOutlet FBLoginView *loginButton;

@property (nonatomic, retain) FbGraph *fbGraph;
@property (strong, nonatomic) IBOutlet UIButton *btnEmailLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnFbLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
- (IBAction)btnFBDOBDoneClicked:(id)sender;
- (IBAction)btnFBSubmitClicked:(id)sender;
- (IBAction)hideParentView:(id)sender;
- (IBAction)btnDOBClicked:(id)sender;
- (IBAction)btnLoginEmailClick:(id)sender;
- (IBAction)btnLoginFBClick:(id)sender;
- (IBAction)btnSkipClick:(id)sender;

@end
