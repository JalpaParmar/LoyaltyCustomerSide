//
//  LoginViewController.m
//  Loyalty App
//
//  Created by Amit Parmar on 17/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "LoginViewController.h"
#import "DashboardView.h"
#import "ForgotView.h"
#import "RegisterViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Singleton.h"
#import "RestaurantView.h"

@interface LoginViewController ()
@end

@implementation LoginViewController
@synthesize txtUnm,txtPwd;
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
    
    self.btnLogin.layer.cornerRadius = 5.0;
    self.btnLogin.clipsToBounds = YES;
    
    self.btnRegister.layer.cornerRadius = 5.0;
    self.btnRegister.clipsToBounds = YES;

    [self.txtUnm becomeFirstResponder];
    
//    self.lblTitleLogin.font = [UIFont fontWithName:@"centuryGothic" size:26];
       [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
    
   // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (textField==txtUnm)
    {
        [txtUnm resignFirstResponder];
        [txtPwd becomeFirstResponder];
    }
    else if (textField==txtPwd)
    {
        [txtPwd resignFirstResponder];
    }
    return YES;
}

#pragma mark Button Click Event

-(void)startActivity
{
    [self.view addSubview:backgroundIndicatorView];
    [actIndicatorView startAnimating];
}
-(void)stopActivity
{
    [backgroundIndicatorView removeFromSuperview];
    [actIndicatorView stopAnimating];
}

- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnLoginClick:(id)sender
{
   [self.view endEditing:YES];
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
    }
    else
    {
        
       
        NSString *username = txtUnm.text;
        NSString *password = txtPwd.text;
        if([username isEqualToString:@""] || [password isEqualToString:@""])
        {
            [[Singleton sharedSingleton] errorFilledUpAllData];
        }
        else if(![[Singleton sharedSingleton] validateEmailWithString:username])
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Please Enter Correct Email ID" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else
        {
             [self startActivity];
            
            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
            NSString *d;
            if([st objectForKey:@"DEVICE_TOKEN_ID"])
            {
                d = [st objectForKey:@"DEVICE_TOKEN_ID"];
            }
            if([[[Singleton sharedSingleton] ISNSSTRINGNULL:d] isEqualToString:@""])
            {
                d=@"9042510773dc4ed24d7afe7ca65f6d4aac615f5776a9dd18eabae78f6e0479cb";
            }
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:username forKey:@"UserName"];
            [dict setValue:password forKey:@"Password"];
            [dict setValue:@"IOS" forKey:@"LoginSource"];
            [dict setValue:d forKey:@"DeviceId"];
            
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
               NSLog(@" %@ -- ", dict);
                 
                 if (dict)
                 {
                     [self stopActivity];
                     Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                     if (!strCode)
                     {
                         if(![[dict objectForKey:@"message"] isEqualToString:@""])
                         {
                             UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                             [alt show];
                         }
                     }
                     else
                     {
                         
                         NSUserDefaults *login=[NSUserDefaults standardUserDefaults];
                         [login setValue:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"FirstName"]]  forKey:@"userFirstName"];
                         [login setValue:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"LastName"] ] forKey:@"userLastName"];
                         [login setValue:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"MobileNo"]]  forKey:@"userMobileNo"];
                         [login setValue:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"UserId"] ] forKey:@"UserId"];
                         [login setValue:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"EMail"]]  forKey:@"userEMail"];
                         [login setValue:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"UfId"]]  forKey:@"UfId"];
                         [login synchronize];
                        
                         NSLog(@" -- %@", [login objectForKey:@"UfId"]);
                         @try {
                               [[Singleton sharedSingleton] setstrLoginUserChat:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"Chat"]];
                         }
                         @catch (NSException *exception) {
                               [[Singleton sharedSingleton] setstrLoginUserChat:@"0"];
                         }
                         
                         
                         [self checkGPSCallViews];
                         
                     }
                 }
                 else
                 {
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     [self stopActivity];
                 }

                 
             } :@"Login/Login" data:dict];
            
           
        }
        
    }
}
-(void)checkGPSCallViews
{
    //Check Locaiton GPS Service Enabled/Disabled
    BOOL servicesEnabled = [CLLocationManager locationServicesEnabled];
    if(!servicesEnabled)
    {
        // open popup - country,state,city
        CommonDelegateViewController *join;
        if (IS_IPHONE_5)
        {
            join=[[CommonDelegateViewController alloc] initWithNibName:@"CommonDelegateViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            join=[[CommonDelegateViewController alloc] initWithNibName:@"CommonDelegateViewController_iPad" bundle:nil];
        }
        else
        {
            join=[[CommonDelegateViewController alloc] initWithNibName:@"CommonDelegateViewController" bundle:nil];
        }
        join.delegate = self;
        [self.navigationController pushViewController:join animated:YES];
        
    }
    else
    {
        DashboardView *dashBoard;
        if (IS_IPHONE_5)
        {
            dashBoard=[[DashboardView alloc] initWithNibName:@"DashboardView-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            dashBoard=[[DashboardView alloc] initWithNibName:@"DashboardView_iPad" bundle:nil];
        }
        else
        {
            dashBoard=[[DashboardView alloc] initWithNibName:@"DashboardView" bundle:nil];
        }
        [self.navigationController pushViewController:dashBoard animated:YES];
    }
}
-(void)LocationSelectionDone:(NSMutableArray *)arrSelectionValue
{
    NSLog(@" *** LocationSelectionDone  called***");
    NSLog(@" *** arrSelectionValue : %@***", arrSelectionValue);
    DashboardView *dashBoard;
    if (IS_IPHONE_5)
    {
        dashBoard=[[DashboardView alloc] initWithNibName:@"DashboardView-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        dashBoard=[[DashboardView alloc] initWithNibName:@"DashboardView_iPad" bundle:nil];
    }
    else
    {
        dashBoard=[[DashboardView alloc] initWithNibName:@"DashboardView" bundle:nil];
    }
    [self.navigationController pushViewController:dashBoard animated:YES];
}
-(void)BackFromSelectionView
{
//    btnFilterBySearch.tag = 0;
//    btnNearBySearch.tag = 1;
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnForgotClick:(id)sender
{
    ForgotView *forgotView;
    if (IS_IPHONE_5)
    {
        forgotView=[[ForgotView alloc] initWithNibName:@"ForgotView-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        forgotView=[[ForgotView alloc] initWithNibName:@"ForgotView_iPad" bundle:nil];
    }
    else
    {
        forgotView=[[ForgotView alloc] initWithNibName:@"ForgotView" bundle:nil];
    }
    [self.navigationController pushViewController:forgotView animated:YES];
}

- (IBAction)btnRegiClick:(id)sender
{
    RegisterViewController *regiView;
    if (IS_IPHONE_5)
    {
         regiView=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        regiView=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController_iPad" bundle:nil];
    }
    else
    {
        regiView=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    }
    [self.navigationController pushViewController:regiView animated:YES];
}

- (IBAction)btnHideClick:(id)sender
{
    [txtUnm resignFirstResponder];
    [txtPwd resignFirstResponder];
}

@end
