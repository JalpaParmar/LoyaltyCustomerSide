//
//  MyAccountView.h
//  Loyalty App
//
//  Created by Amit Parmar on 19/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MyAccountView : UIViewController<UIWebViewDelegate>
{
    AppDelegate *app;
    IBOutlet UITableView *tblAccount;
    
    NSMutableArray *arrName, *arrIcons;
    IBOutlet UIView *viewbackWebView, *viewTermsCindition;
    IBOutlet UIWebView *webview;
    IBOutlet UILabel *lblTitle;
    IBOutlet UIButton *btnDone, *btnBgBack;
    
}
- (IBAction)btnDoneClicked:(id)sender;
- (IBAction)hideParentView:(id)sender;

//- (IBAction)btnLogoutClicked:(id)sender;
//
//- (IBAction)btnPrivacyClicked:(id)sender;
//- (IBAction)btnSettingClicked:(id)sender;
//
//- (IBAction)btnProfileClicked:(id)sender;
//
//- (IBAction)btnTermsClicked:(id)sender;

- (IBAction)btnBackClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleMyAccount;

@end
