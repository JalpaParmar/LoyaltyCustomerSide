//
//  settingViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface settingViewController : UIViewController
{
    AppDelegate *app;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    NSString *P, *R,*L,*C;
}
- (IBAction)btnBackClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnLogout;
- (IBAction)btnLogoutClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tblSetting;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleSetting;
@property (nonatomic, strong) NSMutableArray *arrSettingKey, *arrSetting;
@end
