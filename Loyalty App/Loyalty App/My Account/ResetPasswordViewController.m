//
//  MyAccountView.m
//  Loyalty App
//
//  Created by Amit Parmar on 19/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "settingViewController.h"
#import "ViewController.h"
#import "MyAccountCell.h"
#import "ProfileDetailViewController.h"
#import "Singleton.h"

@interface ResetPasswordViewController ()

@end
#define PROFILE 1
#define TERMS 2
#define POLICY 3
#define SETTING 4
#define RESETPASSWORD 5
#define LOGOUT 6

@implementation ResetPasswordViewController

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
    
//     self.lblTitleResetPassword.font = FONT_centuryGothic_35;
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    
    self.btnReset.layer.cornerRadius = 5.0;
    self.btnReset.clipsToBounds = YES;
 
    self.btnCancel.layer.cornerRadius = 5.0;
    self.btnCancel.clipsToBounds = YES;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)callResetPassword
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
       if([self.txtOldPassword.text isEqualToString:@""] || [self.txtNewPassword.text isEqualToString:@""])
       {
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ERROR_EMPTY_DATA message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
           [alert show];
       }
        else if(![self.txtNewPassword.text isEqualToString:self.txtConfirmPassword.text])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ERROR_PASSWORD_MISMATCH message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            [self startActivity];
            //UserId,OrderId ,OrderRate
            
            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
            NSString * userId ;
            if([st objectForKey:@"UserId"])
            {
                userId =  [st objectForKey:@"UserId"];
            }
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:userId forKey:@"UserId"];
            [dict setValue:self.txtOldPassword.text forKey:@"OldPassword"];
            [dict setValue:self.txtNewPassword.text forKey:@"NewPassword"];
            
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 NSLog(@"Reset Password- - %@ -- ", dict);
                 if (dict)
                 {
                     Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                     if (!strCode)
                     {
                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alt show];
                     }
                     else
                     {
                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         alt.tag = 20;
                         [alt show];
                    }
                     [self stopActivity];
                 }
                 else
                 {
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     [self stopActivity];
                 }
             } :@"Login/ResetPassword" data:dict];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 20)
    {
        if(buttonIndex == 0)
        {
             [[Singleton sharedSingleton] CallLogoutGlobally];
           // [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}
#pragma mark BUTTON CLICK EVENTS
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
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
- (IBAction)btnResetClicked:(id)sender
{
    [self.view endEditing:YES];
    [self callResetPassword];
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
@end
