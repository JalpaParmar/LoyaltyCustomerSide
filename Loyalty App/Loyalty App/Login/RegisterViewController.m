//
//  RegisterViewController.m
//  Loyalty App
//
//  Created by Amit Parmar on 17/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "RegisterViewController.h"
#import "DashboardView.h"
#import <QuartzCore/QuartzCore.h>
#import "Singleton.h"

@interface RegisterViewController ()
@end

@implementation RegisterViewController

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
    
    TERMS = FALSE;
    
    self.btnSubmit.layer.cornerRadius = 5.0;
    self.btnSubmit.clipsToBounds = YES;
    
    btnDOBDone_iPhone.layer.cornerRadius = 5.0;
    btnDOBDone_iPhone.clipsToBounds = YES;
    
    btnDone.layer.cornerRadius = 5.0;
    btnDone.clipsToBounds = YES;
    
    self.btnCancel.layer.cornerRadius = 5.0;
    self.btnCancel.clipsToBounds = YES;
    
     [txtName becomeFirstResponder];
    
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        [[UITableView appearanceWhenContainedIn:[UIDatePicker class], nil] setBackgroundColor:nil]; // for iOS 8
    } else {
        [[UITableViewCell appearanceWhenContainedIn:[UIDatePicker class], [UITableView class], nil] setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]]; // for iOS 7
    }
   
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDate * currentDate = [NSDate date];
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    [comps setYear: -10];
    NSDate * maxDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];

    pickerDate.maximumDate =maxDate;
    pickerDate.date = [NSDate date];
    pickerDate.minimumDate = [NSDate date];
    
    pickerDOB_iPhone.maximumDate =maxDate;
    pickerDOB_iPhone.date = [NSDate date];
    pickerDOB_iPhone.minimumDate = [NSDate date];
    
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
    
    btnDone.layer.cornerRadius=5.0;
    btnDone.clipsToBounds=YES;
    
    if(IS_IPAD)
    {
        viewbackWebView.layer.cornerRadius = 5.0;
        viewbackWebView.clipsToBounds = YES;
        viewbackWebView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        viewbackWebView.layer.borderWidth = 1.0f;
    }

    if(IS_IPAD)
    {
        [pickerDate addTarget:self action:@selector(updateLabelFromPicker:) forControlEvents:UIControlEventValueChanged];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Button Click event

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

- (IBAction)btnRegiClick:(id)sender
{
    [self.view endEditing:YES];
    pickerDate.hidden=YES;
    
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
    }
    else
    {
     
        NSString *firstname = txtName.text;
        NSString *lastname = txtLastName.text;
        NSString *mobile = txtMoblie.text;
        NSString *email = txtEmail.text;
        NSString *password = txtPwd.text;
        NSString *repassword = txtRepwd.text;
        
        
        //check birth year -
        NSString *d =  [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL: btnDOB.titleLabel.text]];
        int age=0;
        
        
        if(IS_IPAD)
        {
            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:d] isEqualToString:@""] && ![d isEqualToString:@"Select DOB"])
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                dateFormatter.dateFormat = @"dd MMMM yyyy";
                NSDate *date = [dateFormatter dateFromString:d];
                // add this check and set
                if (date == nil) {
                    date = [NSDate date];
                }
                dateFormatter.dateFormat = @"MMM d, yyyy";
                [pickerDate setDate:date];
                
                NSDate *selectedDate1=[pickerDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy"];//yyyy-MM-dd
                NSString *selectedYear = [NSString stringWithFormat:@"%@", [formatter stringFromDate:selectedDate1]];
                NSString *CurrentYear = [NSString stringWithFormat:@"%@", [formatter stringFromDate:[NSDate date]]];
                age = [CurrentYear intValue] - [selectedYear intValue];
                NSLog(@"Current Agr : %d", age);
            }

        }
        else
        {
            //pickerDOB_iPhone
            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:d] isEqualToString:@""] && ![d isEqualToString:@"Select DOB"])
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                dateFormatter.dateFormat = @"dd MMMM yyyy";
                NSDate *date = [dateFormatter dateFromString:d];
                // add this check and set
                if (date == nil) {
                    date = [NSDate date];
                }
                dateFormatter.dateFormat = @"MMM d, yyyy";
                [pickerDOB_iPhone setDate:date];
                
                NSDate *selectedDate1=[pickerDOB_iPhone date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy"];//yyyy-MM-dd
                NSString *selectedYear = [NSString stringWithFormat:@"%@", [formatter stringFromDate:selectedDate1]];
                NSString *CurrentYear = [NSString stringWithFormat:@"%@", [formatter stringFromDate:[NSDate date]]];
                age = [CurrentYear intValue] - [selectedYear intValue];
                NSLog(@"Current Agr : %d", age);
            }

        }
        
       
        
        if([firstname isEqualToString:@""]  || [lastname isEqualToString:@""] ||[mobile isEqualToString:@""] || [email isEqualToString:@""] || [password isEqualToString:@""] || [repassword isEqualToString:@""] || [[[Singleton sharedSingleton] ISNSSTRINGNULL:selectedDate] isEqualToString:@""])
        {
            [[Singleton sharedSingleton] errorFilledUpAllData];
        }
        else if(mobile.length < 4)
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Mobile length should be atleast 4 or more" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else if(![[Singleton sharedSingleton] validateEmailWithString:email])
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Please Enter Correct Email ID" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else if(![password isEqualToString:repassword])
        {
            [[Singleton sharedSingleton] errorPasswordMismatch];
        }
        else if(age < 10)
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Minimum age should be 10 years" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else if(TERMS==NO)
        {
              [[Singleton sharedSingleton] errorCheckTermsCondition];
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
        d=@"9042510773dc4ed24d7afe7ca65f6d4aac615f5776a9dd18eabae78f6e0479cb";
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:firstname forKey:@"FirstName"];
            [dict setValue:lastname forKey:@"LastName"];
            [dict setValue:mobile forKey:@"MobileNo"];
            [dict setValue:email forKey:@"EMail"];
            [dict setValue:password forKey:@"Password"];
            [dict setValue:@"IOS" forKey:@"RegistrationSource"];
            [dict setValue:d forKey:@"DeviceId"];
            [dict setValue:@"TRUE" forKey:@"AcceptTerms"];
            [dict setValue:selectedDate forKey:@"DOB"];
            
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 NSLog(@" %@ -- ", dict);
                 
                 if (dict)
                 {
                    [self stopActivity];
                     Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                     if (!strCode)
                     {
                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alt show];
                     }
                     else
                     {
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                 }
                 else
                 {
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     [self stopActivity];
                 }
             } :@"Login/Registration" data:dict];
        }
    }
}
- (IBAction)btnAcceptTermsClick:(id)sender
{
    [self.view endEditing:YES];
    pickerDate.hidden=YES;
    
    UIImage *checkimg = [UIImage imageNamed:@"check-box-select.png"];
    UIImage *uncheckimg = [UIImage imageNamed:@"check-box.png"];
    
    if([self.btnTerms.currentBackgroundImage isEqual:uncheckimg])
    {
        // now do check
        [self.btnTerms setBackgroundImage:checkimg forState:UIControlStateNormal];
        TERMS = TRUE;
    }
    else if([self.btnTerms.currentBackgroundImage isEqual:checkimg])
    {
        //now do uncheck
          [self.btnTerms setBackgroundImage:uncheckimg forState:UIControlStateNormal];
        TERMS = FALSE;
    }
    else
    {
        // now do check
        [self.btnTerms setBackgroundImage:checkimg forState:UIControlStateNormal];
        TERMS = TRUE;
    }
}
- (IBAction)btnReadTermsClick:(id)sender
{
    [self.view endEditing:YES];
    pickerDate.hidden=YES;
    
    
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
- (IBAction)btnHideClick:(id)sender
{
     scrlView.contentOffset=CGPointMake(0, 0);
    [txtName resignFirstResponder];
    [txtMoblie resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtRepwd resignFirstResponder];    
    [txtPwd resignFirstResponder];
    [txtLastName resignFirstResponder];
    pickerDate.hidden = YES;
}
- (IBAction)btnDOBClicked:(id)sender
{
    if(IS_IPAD)
    {
        [self.view endEditing:YES];
        pickerDate.hidden = NO;
    }
    else
    {
        [self.view addSubview:viewDBO_iPhone];
        //pickerDate.maximumDate = [NSDate date];
        
    }
}
- (IBAction)updateLabelFromPicker:(id)sender
{
        if(IS_IPAD)
        {
            //Date
            NSDate *date=[pickerDate date];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeZone:[NSTimeZone systemTimeZone]];
            [formatter setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd
            selectedDate = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
            
            [formatter setDateFormat:@"dd MMMM yyyy"];
            [btnDOB setTitle:[NSString stringWithFormat:@"  %@",[formatter stringFromDate:date]] forState:UIControlStateNormal];
        }
        else
        {
            //Date
            NSDate *date=[pickerDOB_iPhone date];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeZone:[NSTimeZone systemTimeZone]];
            [formatter setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd
            selectedDate = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
            
            [formatter setDateFormat:@"dd MMMM yyyy"];
            [btnDOB setTitle:[NSString stringWithFormat:@"  %@",[formatter stringFromDate:date]] forState:UIControlStateNormal];
            
            [viewDBO_iPhone removeFromSuperview];
        }
}
#pragma  mark - UITEXTFIELD
#pragma mark TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    pickerDate.hidden = YES;
    if(!IS_IPAD)
    {
        if(textField == txtEmail)
        {
            scrlView.contentOffset=CGPointMake(0, 20);
        }
        else if(textField == txtPwd)
        {
            scrlView.contentOffset=CGPointMake(0, 50);
        }
        else if(textField == txtRepwd)
        {
            scrlView.contentOffset=CGPointMake(0, 60);
        }
        else
        {
            scrlView.contentOffset=CGPointMake(0, 0);
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField==txtName)
    {
        [txtName resignFirstResponder];
        [txtLastName becomeFirstResponder];
    }
    else if (textField==txtLastName)
    {
        [txtLastName resignFirstResponder];
        [txtMoblie becomeFirstResponder];
    }
    else if (textField==txtMoblie)
    {
        [txtMoblie resignFirstResponder];
        [txtEmail becomeFirstResponder];
    }
    else if (textField==txtEmail)
    {
        [txtEmail resignFirstResponder];
        [txtPwd becomeFirstResponder];
        if (!IS_IPAD)
            scrlView.contentOffset=CGPointMake(0, 40);
    }
    else if (textField==txtPwd)
    {
        [txtPwd resignFirstResponder];
        [txtRepwd becomeFirstResponder];
        if (!IS_IPAD)
            scrlView.contentOffset=CGPointMake(0, 90);
    }
    else if (textField==txtRepwd)
    {
        [txtRepwd resignFirstResponder];
        if (!IS_IPAD)
            scrlView.contentOffset=CGPointMake(0, 0);
    }
    return YES;
}


- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString: (NSString *)string
{
    //return yes or no after comparing the characters
    
    // allow backspace
    if (!string.length)
    {
        return YES;
    }
     if(theTextField == txtMoblie)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS_MOBILE] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    
    
    return YES;
}

@end
