//
//  MyAccountView.m
//  Loyalty App
//
//  Created by Amit Parmar on 19/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "MyAccountView.h"
#import "settingViewController.h"
#import "ViewController.h"
#import "MyAccountCell.h"
#import "ProfileDetailViewController.h"
#import "ResetPasswordViewController.h"
#import "Singleton.h"
#import <QuartzCore/QuartzCore.h>

@interface MyAccountView ()

@end
#define PROFILE 1
#define TERMS 2
#define POLICY 3
#define SETTING 4
#define RESETPASSWORD 5
#define LOGOUT 6

@implementation MyAccountView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    app = APP;
    [self.view addSubview:[app setFooterPart]];
    app._flagMainBtn = 0; //2;
    
    
//     self.lblTitleMyAccount.font = FONT_centuryGothic_35;
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    
    tblAccount.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [tblAccount setScrollEnabled:NO];
    [tblAccount setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
   
    arrName = [[NSMutableArray alloc] initWithObjects:@"My Profile", @"Terms Of Use", @"Privacy Policy",  @"Settings",@"Reset Password", @"Logout", nil];
    arrIcons = [[NSMutableArray alloc] initWithObjects:@"my-profile.png", @"terms-of-use.png", @"privacy-policy.png", @"settingss.png", @"resetPassword.png", @"log-out.png", nil];
    
    btnDone.layer.cornerRadius=5.0;
    btnDone.clipsToBounds=YES;
    
    if(IS_IPAD)
    {
        viewbackWebView.layer.cornerRadius = 5.0;
        viewbackWebView.clipsToBounds = YES;
        viewbackWebView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        viewbackWebView.layer.borderWidth = 1.0f;
    }
    // Do any additional setup after loading the view from its nib.
}
#pragma mark TableView Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPAD)
        return 80;
    else
        return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    if(IS_IPAD)
        simpleTableIdentifier= @"MyAccountCell_iPad";
    else
        simpleTableIdentifier=@"MyAccountCell";

        MyAccountCell *cell = (MyAccountCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        cell.lblName.text = [NSString stringWithFormat:@"%@", [arrName  objectAtIndex:indexPath.row]];
        [cell.btnIcon setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [arrIcons  objectAtIndex:indexPath.row]]] forState:UIControlStateNormal];
        cell.btnbackground.tag = indexPath.row+1;
    
        [cell.btnbackground addTarget:self action:@selector(myAccountButtonClickedEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark BUTTON CLICK EVENTS
-(void)myAccountButtonClickedEvent:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if(btn.tag == PROFILE)
    {
        // profile
        ProfileDetailViewController *profile;
        if (IS_IPHONE_5)
        {
            profile=[[ProfileDetailViewController alloc] initWithNibName:@"ProfileDetailViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            profile=[[ProfileDetailViewController alloc] initWithNibName:@"ProfileDetailViewController_iPad" bundle:nil];
        }
        else
        {
            profile=[[ProfileDetailViewController alloc] initWithNibName:@"ProfileDetailViewController" bundle:nil];
        }
        [self.navigationController pushViewController:profile animated:YES];
        
    }
    else if(btn.tag == TERMS)
    {
        [self.view addSubview:btnBgBack];
        [self.view addSubview:viewTermsCindition];
        lblTitle.text=@"Terms & Condition";
        
        if(IS_IPAD)
        {
            viewTermsCindition.frame = CGRectMake(0, 100, viewTermsCindition.frame.size.width, viewTermsCindition.frame.size.height);
        }
        else
        {
            viewTermsCindition.frame = CGRectMake(0, 50, viewTermsCindition.frame.size.width, viewTermsCindition.frame.size.height);
        }
        
        [[Singleton sharedSingleton] ReadTermsCondition_privacypolicy:@"Terms" WebView:(UIWebView*)webview];
        
   
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Terms and Condition" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
        
    }
    else if(btn.tag == POLICY)
    {
        [self.view addSubview:btnBgBack];
        [self.view addSubview:viewTermsCindition];
        if(IS_IPAD)
        {
            viewTermsCindition.frame = CGRectMake(0, 100, viewTermsCindition.frame.size.width, viewTermsCindition.frame.size.height);
        }
        else
        {
            viewTermsCindition.frame = CGRectMake(0, 50, viewTermsCindition.frame.size.width, viewTermsCindition.frame.size.height);
        }
        
        lblTitle.text=@"Privacy Policy";
        [[Singleton sharedSingleton] ReadTermsCondition_privacypolicy:@"Privacy" WebView:(UIWebView*)webview];;
        //    [webview loadRequest:request];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Policy" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
    }
    else if(btn.tag == SETTING)
    {
        settingViewController *setting;
        if (IS_IPHONE_5)
        {
            setting=[[settingViewController alloc] initWithNibName:@"settingViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            setting=[[settingViewController alloc] initWithNibName:@"settingViewController_iPad" bundle:nil];
        }

        else
        {
            setting=[[settingViewController alloc] initWithNibName:@"settingViewController" bundle:nil];
        }
        [self.navigationController pushViewController:setting animated:YES];
        

    }
    else if(btn.tag == RESETPASSWORD)
    {
        ResetPasswordViewController *reset;
        if (IS_IPHONE_5)
        {
            reset=[[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            reset=[[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController_iPad" bundle:nil];
        }
        
        else
        {
            reset=[[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
        }
        [self.navigationController pushViewController:reset animated:YES];
        
        
    }
    else if(btn.tag == LOGOUT)
    {
        [[Singleton sharedSingleton] CallLogoutGlobally];
    }
}
- (IBAction)hideParentView:(id)sender
{
    [viewTermsCindition removeFromSuperview];
    [btnBgBack removeFromSuperview];
}
- (IBAction)btnDoneClicked:(id)sender
{
    [viewTermsCindition removeFromSuperview];
    [btnBgBack removeFromSuperview];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
}

@end
