//
//  ForgotView.m
//  Loyalty App
//
//  Created by Amit Parmar on 18/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "ForgotView.h"
#import "Singleton.h"

@interface ForgotView ()

@end

@implementation ForgotView

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
    
    self.btnSubmit.layer.cornerRadius = 5.0;
    self.btnSubmit.clipsToBounds = YES;
    
//    self.lblTitleForgot.font = FONT_centuryGothic_35;
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
    
    [self.txtEmailId becomeFirstResponder];
    
    
    // Do any additional setup after loading the view from its nib.
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    [self.txtEmailId becomeFirstResponder];
//    return YES;
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField== self.txtEmailId)
    {
        [self.txtEmailId resignFirstResponder];
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (IBAction)btnHideClick:(id)sender
{
    [self.txtEmailId resignFirstResponder];
}

- (IBAction)btnSubmitClicked:(id)sender {
    
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
    }
    else
    {
        
        NSString *emailId = self.txtEmailId.text;
    
        if([[[Singleton sharedSingleton] ISNSSTRINGNULL:emailId] isEqualToString:@""] )
        {
            [[Singleton sharedSingleton] errorFilledUpAllData];
        }
        else if(![[Singleton sharedSingleton] validateEmailWithString:emailId])
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Please Enter Correct Email ID" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else
        {
            [self startActivity];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:emailId forKey:@"UserEmail"];
            
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 NSLog(@" %@ -- ", dict);
                [self stopActivity];
                 if (dict)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];                    
                 }
                 else
                 {
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                   
                 }
             } :@"/Login/ForgetPassword" data:dict];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if(buttonIndex == 0)
//    {
//         [self.navigationController popViewControllerAnimated:YES];
//    }
}

@end
