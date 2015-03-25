//
//  addOrderViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/23/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "RedeemOrderViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "paymentViewController.h"
#import "homeDeliveryViewController.h"
#import "HomeDelivery.h"
#import "Singleton.h"
#import "OrderDetailViewController.h"
#import "DashboardView.h"
#import "DeliveryAddressViewController.h"


@interface RedeemOrderViewController ()
@end

@implementation RedeemOrderViewController
@synthesize  arrRedeemOrderDetail, txtRedeem, lblGrandTotal, lblPoints, lblTitleAddOrder, btnPoints, btnSubmit;

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
 
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    
//    self.btnProceed.layer.cornerRadius = 5.0;
//    self.btnProceed.clipsToBounds = YES;
    
    self.btnSubmit.layer.cornerRadius = 5.0;
    self.btnSubmit.clipsToBounds = YES;
   
    self.btnPoints.layer.cornerRadius = 5.0;
    self.btnPoints.clipsToBounds = YES;
   
    self.btnSave.layer.cornerRadius = 5.0;
    self.btnSave.clipsToBounds = YES;
   
    self.btnCancel.layer.cornerRadius = 5.0;
    self.btnCancel.clipsToBounds = YES;
    
    btnOTPSend.layer.cornerRadius = 5.0;
    btnOTPSend.clipsToBounds = YES;
    
    txtOTP.hidden = YES;
    btnOTPResend.hidden = YES;
    btnOTPSend.hidden = YES;
    
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [txtOTP setLeftViewMode:UITextFieldViewModeAlways];
    [txtOTP setLeftView:spacerView];
    
    self.viewChildCashMode.layer.cornerRadius = 5.0;
    self.viewChildCashMode.clipsToBounds = YES;
    self.viewChildCashMode.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewChildCashMode.layer.borderWidth = 1.0f;
    
    [self.view setUserInteractionEnabled:YES];
    
    //TotalPoints
    @try {
        self.lblPoints.text = [NSString stringWithFormat:@"%.02f", [Singleton sharedSingleton].globalTotalPoints] ;
                               
        total_points =  [self.lblPoints.text floatValue];
    }
    @catch (NSException *exception) {

    }
    if([[[Singleton sharedSingleton] ISNSSTRINGNULL:self.lblPoints.text ] isEqualToString:@""])
    {
        self.lblPoints.text = @" 0 ";
    }
    NSLog(@" --- %@",  [NSString stringWithFormat:@"%f", [Singleton sharedSingleton].globalTotalPoints]  );
    
    //
    //restaurantPoints
    NSLog(@"[[Singleton sharedSingleton] getIndexId] : %d", [[Singleton sharedSingleton] getIndexId]);
    NSLog(@"[[Singleton sharedSingleton] getarrRestaurantList]  : %@", [[Singleton sharedSingleton] getarrRestaurantList] );
    NSLog(@"[[Singleton sharedSingleton] getarrRestaurantList]  : %@", [[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:[[Singleton sharedSingleton] getIndexId]] objectForKey:@"restaurantPoints"] );
    
    @try {
        
        if([[[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:[[Singleton sharedSingleton] getIndexId]] objectForKey:@"restaurantPoints"] count] > 0)
        {
            NSArray *arrPoints = [[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:[[Singleton sharedSingleton] getIndexId]] objectForKey:@"restaurantPoints"];
            NSLog(@"arrPoints : %@", arrPoints);
            
            if([arrPoints count] > 0)
            {
                onePoint = [[[arrPoints objectAtIndex:0] objectForKey:@"RedeemPoints"] floatValue];
                oneAmount = [[[arrPoints objectAtIndex:0] objectForKey:@"Amount"] floatValue];
                NSLog(@"onePoint : %f", onePoint);
                NSLog(@"oneAmount : %f", oneAmount);
            }
        }
    }
    @catch (NSException *exception) {
    }

    @try {
        
            //grand total
            if([arrRedeemOrderDetail count] > 0)
            {
                self.lblGrandTotal.text = [NSString stringWithFormat:@"Total: %@%.02f",  [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrRedeemOrderDetail objectAtIndex:0] objectForKey:@"CurrencySigh"]], [[[arrRedeemOrderDetail objectAtIndex:0] objectForKey:@"OrderTotal"] floatValue]] ;
                
                currencySign = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrRedeemOrderDetail objectAtIndex:0] objectForKey:@"CurrencySigh"]];
                
                grandTotal = [[[arrRedeemOrderDetail objectAtIndex:0] objectForKey:@"OrderTotal"] floatValue];
            }
    }
    @catch (NSException *exception) {
        
          self.lblGrandTotal.text = [NSString stringWithFormat:@"$0"] ;
         grandTotal=0;
         currencySign=@"$";
    }
       
    //Cancel & Done button for num pad
    UIToolbar *numberToolbar = [[Singleton sharedSingleton] AccessoryButtonsForNumPad:self];
    self.txtRedeem.inputAccessoryView = numberToolbar;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)cancelNumberPad{
    
    [self.txtRedeem resignFirstResponder];
    //self.scrllView.contentOffset=CGPointMake(0, 0);
    // self.txtContactnumber.text = @"";
}

-(void)doneWithNumberPad{
    //NSString *numberFromTheKeyboard = self.txtContactnumber.text;
    [self.txtRedeem resignFirstResponder];
    //self.scrllView.contentOffset=CGPointMake(0, 0);
}
-(void)viewWillAppear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OTPSend) name:@"OTPSend" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark UIBUTTON CLICKED
-(void)OTPSend
{
    [self.btnBGBack removeFromSuperview];
    [self.viewParentCashMode removeFromSuperview];
    
    txtOTP.hidden = NO;
    btnOTPResend.hidden = NO;
    btnOTPSend.hidden = NO;
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

- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
 
}
//-(void)changeOrderStatus
//{
//    if ([[Singleton sharedSingleton] connection]==0)
//    {
//        [[Singleton sharedSingleton] errorInternetConnection];
//    }
//    else
//    {
//        
//            [self startActivity];
//            
//            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
//            NSString * OrderID ;
//            if([st objectForKey:@"OrderID"])
//            {
//                OrderID =  [st objectForKey:@"OrderID"];
//            }
//        NSString * userId ;
//        if([st objectForKey:@"UserId"])
//        {
//            userId =  [st objectForKey:@"UserId"];
//        }
//            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//            [dict setValue:OrderID forKey:@"OrderID"];
//            [dict setValue:@"Send" forKey:@"OrderStatus"];
//            [dict setValue:txtRedeem.text forKey:@"RedeemPoint"];
//            [dict setValue:userId forKey:@"CustomerID"];
//            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
//             {
//                 NSLog(@"OrderStatus  Detail - %@ -- ", dict);
//                 if (dict)
//                 {
//                     Boolean strCode=[[dict objectForKey:@"code"] boolValue];
//                     if (!strCode)
//                     {
//                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                         [alt show];
//                     }
//                     else
//                     {
////                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
////                         [alt show];
//                         
//                         if([dict objectForKey:@"data"])
//                         {
//                           
//                             
////                                 //send - mean completed order - remove all settings
////                                 [[[Singleton sharedSingleton] arrOrderOfCurrentUser] removeAllObjects];
////                                 
////                                 //save "delete order " in prefernece
////                                 NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
////                                 [st setObject:@"NO" forKey:@"IS_ORDER_START"];
////                                 [st setObject:@"" forKey:@"OrderID"];
////                                 [st synchronize];
//                          
//                             
//                             NSMutableArray *tempArr = [[NSMutableArray alloc] initWithObjects:[dict objectForKey:@"data"], nil];
//                             if([tempArr count] > 0)
//                             {
//                                 tempArr = [tempArr objectAtIndex:0];
//                             }
//                             
//                             NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
//                             if([[st objectForKey:@"OrderType"] isEqualToString:OrderType_ATRestaurant])
//                             {
//                                 //AT Restaurant
//                                  [[Singleton sharedSingleton] sendSuccessTranscationToServer];
//                             }
//                             else if([[st objectForKey:@"OrderType"] isEqualToString:OrderType_TakeAway])
//                             {
//                                 //Take away
//                                 
//                                 [Singleton sharedSingleton].PaymentMode=@"";
//                                 UIImage *Uncheckimage = [UIImage imageNamed:@"check-box.png"];
//                                 
//                                   [self.radioButton1 setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
//                                    [self.radioButton2 setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
//                                     
//                                 [self.view addSubview:self.btnBGBack];
//                                 [self.view addSubview:self.viewParentCashMode];
//                                 if(IS_IPAD)
//                                 {
//                                     self.viewParentCashMode.frame = CGRectMake(0, 300, self.viewParentCashMode.frame.size.width, self.viewParentCashMode.frame.size.height);
//                                 }
//                                 else
//                                 {
//                                     self.viewParentCashMode.frame = CGRectMake(0, 130, self.viewParentCashMode.frame.size.width, self.viewParentCashMode.frame.size.height);
//                                 }
//
//                             }
//                             else
//                             {
//                                 // Home Delivery
//                                 DeliveryAddressViewController *payView;
//                                 if (IS_IPHONE_5)
//                                 {
//                                     payView=[[DeliveryAddressViewController alloc] initWithNibName:@"DeliveryAddressViewController-5" bundle:nil];
//                                 }
//                                 else if (IS_IPAD)
//                                 {
//                                     payView=[[DeliveryAddressViewController alloc] initWithNibName:@"DeliveryAddressViewController_iPad" bundle:nil];
//                                 }
//                                 else
//                                 {
//                                     payView=[[DeliveryAddressViewController alloc] initWithNibName:@"DeliveryAddressViewController" bundle:nil];
//                                 }
//                                 
//                                 payView.arrProfileData = [[NSMutableArray alloc] init];
//                                 [payView.arrProfileData addObject:[dict objectForKey:@"data"]];
//                                 payView.orderTotal = [[[arrRedeemOrderDetail objectAtIndex:0] objectForKey:@"OrderTotal"] floatValue];
//                                 payView.currencyCode = currencySign;
//                                 
//                                 [self.navigationController pushViewController:payView animated:YES];
//                             }
//                        }
//                     }
//                     [self stopActivity];
//                 }
//                 else
//                 {
//                     
//                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                     [alt show];
//                     [self stopActivity];
//                 }
//             } :@"User/ChangeOrderStatus" data:dict];
//        
//    }
//}
-(void)GoToNextViewForPayment
{
    if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtRedeem.text] isEqualToString:@""])
    {
        [Singleton sharedSingleton].globalEnteredRedeemPoints = [txtRedeem.text floatValue];
    }
    else
    {
        [Singleton sharedSingleton].globalEnteredRedeemPoints = 0;
    }
    
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    if([[st objectForKey:@"OrderType"] isEqualToString:OrderType_ATRestaurant])
    {
        //AT Restaurant
        [[Singleton sharedSingleton] sendSuccessTranscationToServer];
    }
    else if([[st objectForKey:@"OrderType"] isEqualToString:OrderType_TakeAway])
    {
        //Take away
        
        [Singleton sharedSingleton].PaymentMode=@"";
        UIImage *Uncheckimage = [UIImage imageNamed:@"check-box.png"];
        
        self.radioButton1.enabled = YES;
        self.radioButton2.enabled = YES;
        
        [self.radioButton1 setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
        [self.radioButton2 setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
        
        [self.view addSubview:self.btnBGBack];
        [self.view addSubview:self.viewParentCashMode];
        if(IS_IPAD)
        {
            self.viewParentCashMode.frame = CGRectMake(0, 300, self.viewParentCashMode.frame.size.width, self.viewParentCashMode.frame.size.height);
        }
        else
        {
            self.viewParentCashMode.frame = CGRectMake(0, 130, self.viewParentCashMode.frame.size.width, self.viewParentCashMode.frame.size.height);
        }
    }
    else
    {
        // Home Delivery
        DeliveryAddressViewController *payView;
        if (IS_IPHONE_5)
        {
            payView=[[DeliveryAddressViewController alloc] initWithNibName:@"DeliveryAddressViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            payView=[[DeliveryAddressViewController alloc] initWithNibName:@"DeliveryAddressViewController_iPad" bundle:nil];
        }
        else
        {
            payView=[[DeliveryAddressViewController alloc] initWithNibName:@"DeliveryAddressViewController" bundle:nil];
        }
        
        payView.arrProfileData = [[NSMutableArray alloc] init];
//        [payView.arrProfileData addObject:[dict objectForKey:@"data"]];
        payView.orderTotal = [[[arrRedeemOrderDetail objectAtIndex:0] objectForKey:@"OrderTotal"] floatValue];
        payView.currencyCode = currencySign;
        
        [self.navigationController pushViewController:payView animated:YES];
    }
    
}
-(IBAction)btnSubmitClicked:(id)sender
{
    [self.view endEditing:YES];
    
    NSLog(@"self.txtRedeem.text : %@", self.txtRedeem.text);

        if(total_points >= 0 )
        {
             [self GoToNextViewForPayment];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do You Want To Use Redeem Points?" message:@"" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            alert.tag = 89;
            [alert show];
        }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 89)
    {
        if(buttonIndex == 0)
        {
            //YES
//            [self changeOrderStatus];
            [self GoToNextViewForPayment];
        }
    }
//    else if(alertView.tag == 90)
//    {
//        NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
//        [Singleton sharedSingleton].strEnteredOTP = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[alertView textFieldAtIndex:0] text]]];
//        if( [[Singleton sharedSingleton].strEnteredOTP isEqualToString:@""])
//        {
//            IS_SUCCESS= FALSE;
//            [Singleton showToastMessage:@"Please enter OTP"];
//        }
//        else
//        {
//            if([strOTPServer isEqualToString:[[alertView textFieldAtIndex:0] text]])
//            {
//                IS_SUCCESS= TRUE;
//                [[Singleton sharedSingleton] sendSuccessTranscationToServer];
//            }
//            else
//            {
//                IS_SUCCESS= FALSE;
//                [Singleton showToastMessage:@"OTP does not match"];
//            }
//        }
//    }
}
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if(alertView.tag == 90)
//    {
//        if(!IS_SUCCESS)
//        {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:alertMsg message:@"Enter OTP" delegate:self cancelButtonTitle:@"Send OTP" otherButtonTitles:nil, nil];
//            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//            [[alert textFieldAtIndex:0] resignFirstResponder];
//            [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypePhonePad];
//            [[alert textFieldAtIndex:0] becomeFirstResponder];
//            alert.tag = 90;
//            [alert show];
//        }
//    }
//}


#pragma mark  COD CASH MODE CLICKS
- (IBAction)btnCashModeSaveClick:(id)sender
{
    if([[[Singleton sharedSingleton] ISNSSTRINGNULL:[Singleton  sharedSingleton].PaymentMode] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please select payment mode" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if([[Singleton sharedSingleton].PaymentMode isEqualToString:CashOnDelivery])
        {

            [[Singleton sharedSingleton] sendOTPToUser];
//            [[Singleton sharedSingleton] sendSuccessTranscationToServer];
        }
        else if([[Singleton sharedSingleton].PaymentMode isEqualToString:online])
        {
            [self.btnBGBack removeFromSuperview];
            [self.viewParentCashMode removeFromSuperview];

            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
            NSString * OrderID ;
            if([st objectForKey:@"OrderID"])
            {
                OrderID =  [st objectForKey:@"OrderID"];
            }
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:OrderID forKey:@"orderID"];
            [dict setValue:[NSString stringWithFormat:@"%@", [[arrRedeemOrderDetail objectAtIndex:0] objectForKey:@"OrderTotal"]]  forKey:@"totalPrice"];
            [dict setValue:currencySign forKey:@"currencyCode"];
            
            [[Singleton sharedSingleton] PayPalCheckOutClicked:dict];
        }
        else
        {
            
        }
    }
}
- (IBAction)btnCashModeCancelClick:(id)sender
{
    [self.btnBGBack removeFromSuperview];
    [self.viewParentCashMode removeFromSuperview];
}

#pragma mark OTP SEND
- (IBAction)btnOTPResendClick:(id)sender
{
    UIButton *b = sender;
    if(b.tag == 1)
    {
        [Singleton sharedSingleton].strEnteredOTP = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL: txtOTP.text ]];
        if( [[Singleton sharedSingleton].strEnteredOTP isEqualToString:@""])
        {
//            IS_OTP_SUCCESS= FALSE;
            [Singleton showToastMessage:@"Please enter OTP"];
        }
        else
        {
            if([[Singleton sharedSingleton].strOTPServer isEqualToString:[Singleton sharedSingleton].strEnteredOTP])
            {
//                IS_OTP_SUCCESS= TRUE;
                [[Singleton sharedSingleton] sendSuccessTranscationToServer];
            }
            else
            {
//                IS_OTP_SUCCESS= FALSE;
                [Singleton showToastMessage:@"OTP does not match"];
            }
        }
    }
    else if(b.tag == 2)
    {
        [[Singleton sharedSingleton] sendOTPToUser];
    }
}
/*-(void)sendOTPToUser
{
        [self startActivity];
    
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        NSString * OrderID, *userId, *userEmail ;
        if([st objectForKey:@"OrderID"])
        {
            OrderID =  [st objectForKey:@"OrderID"];
        }
        if([st objectForKey:@"UserId"])
        {
            userId =  [st objectForKey:@"UserId"];
        }
        if([st objectForKey:@"userEMail"])
        {
            userEmail = [st objectForKey:@"userEMail"];
        }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:userEmail forKey:@"Email"];
    [dict setValue:userId forKey:@"UserId"];
    [dict setValue:OrderID forKey:@"OrderId"];
    
    [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
     {
         NSLog(@"OTP  - - %@ -- ", dict);
       
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
                 alertMsg = [dict objectForKey:@"message"];
                 strOTPServer = [NSString stringWithFormat:@"%@", [dict objectForKey:@"data"]];
                 
                 [self.btnBGBack removeFromSuperview];
                 [self.viewParentCashMode removeFromSuperview];
                 
//                 [Singleton sharedSingleton].strOTPFromServer = @"";
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"Enter OTP" delegate:self cancelButtonTitle:@"Send OTP" otherButtonTitles:nil, nil];
                 alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                 [[alert textFieldAtIndex:0] resignFirstResponder];
                 [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypePhonePad];
                 [[alert textFieldAtIndex:0] becomeFirstResponder];
                 alert.tag = 90;
                 [alert show];
             }
             [self stopActivity];
         }
         else
         {
             UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alt show];
             [self stopActivity];
         }
     } :@"Data/SendOtp" data:dict];
}
*/
#pragma mark RADIO BUTTON SELECTION
-(void)setSelectedButton:(UIButton *)radioButton
{
    
    UIImage *Checkimage = [UIImage imageNamed:@"check-box-select.png"];
    UIImage *Uncheckimage = [UIImage imageNamed:@"check-box.png"];
    
    if(radioButton == self.radioButton1){
        [self.radioButton1 setBackgroundImage:Checkimage forState:UIControlStateNormal];
        [self.radioButton1 setBackgroundImage:Checkimage forState:UIControlStateSelected];
        [self.radioButton1 setBackgroundImage:Checkimage forState:UIControlStateHighlighted];
        self.radioButton1.adjustsImageWhenHighlighted = YES;
        
        [self.radioButton2 setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
        // [self.radioButton2 setBackgroundImage:Uncheckimage forState:UIControlStateSelected];
        //  [self.radioButton2 setBackgroundImage:Uncheckimage forState:UIControlStateHighlighted];
        // [self.radioButton2 setBackgroundImage:Uncheckimage forState:UIControlStateDisabled];
        
        
        
        self.radioButton1.enabled = NO;
        self.radioButton2.enabled = YES;
        
        [Singleton  sharedSingleton].PaymentMode = CashOnDelivery;
        
    }
    else if(radioButton == self.radioButton2){
        [self.radioButton2 setBackgroundImage:Checkimage forState:UIControlStateNormal];
        [self.radioButton2 setBackgroundImage:Checkimage forState:UIControlStateSelected];
        [self.radioButton2 setBackgroundImage:Checkimage forState:UIControlStateHighlighted];
        self.radioButton2.adjustsImageWhenHighlighted = YES;
        
        [self.radioButton1 setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
        //  [self.radioButton1 setBackgroundImage:Uncheckimage forState:UIControlStateDisabled];
        //  [self.radioButton1 setBackgroundImage:Uncheckimage forState:UIControlStateHighlighted];
        //  [self.radioButton1 setBackgroundImage:Uncheckimage forState:UIControlStateSelected];
        
        
        self.radioButton1.enabled = YES;
        self.radioButton2.enabled = NO;
        
        [Singleton  sharedSingleton].PaymentMode = online;
        
    }
    
}
-(IBAction)radioButton1Selected{
    [self setSelectedButton:self.radioButton1];
}
-(IBAction)radioButton2Selected{
    [self setSelectedButton:self.radioButton2];
}
#pragma mark UITextViewDelegate methods

-(void)hideKeyboard
{
    [self.txtRedeem resignFirstResponder];
   
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  
    if(textField == txtRedeem)
    {
        NSString * point = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS_ZIPCODE] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        float final_point = total_points - [point floatValue];
        NSLog(@"total_points : %f", total_points);
        NSLog(@"[point floatValue] : %f", [point floatValue]);
        NSLog(@"final_point : %f", final_point);
        
        //        int TP;
        //        @try
        //        {
        //            TP  = [lblPoints.text floatValue];
        //        }
        //        @catch (NSException *er){ }
        
        if(final_point >= 0 )
        {
            if([string isEqualToString:filtered])
            {
                if([point intValue] <= 0)
                {
                    //0, 00, 000, 0000 ....
                    
                    if([point isEqualToString:@"0"] || [point isEqualToString:@"00"] || [point isEqualToString:@"000"])
                    {
                        if(onePoint > 0)
                        {
                            NSLog(@"grandTotal : %f", grandTotal);
                            NSLog(@"oneAmount : %f", oneAmount);
                            NSLog(@"((oneAmount * [point floatValue]) : %f", (oneAmount * [point floatValue]));
                            NSLog(@"((oneAmount * [point floatValue])/RedeemPoints : %f",  ((oneAmount * [point floatValue])/onePoint));
                            
                            float final_price = grandTotal - ((oneAmount * [point floatValue])/onePoint);
                            NSLog(@"final_price : %f", final_price);
                            
                            if(final_price < 0)
                            {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Total Price is not enough to Redeem Points." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                [alert show];
                                return NO;
                            }
                            else
                            {
                                
                                lblPoints.text = [NSString stringWithFormat:@"%.02f", final_point];
                                
                                lblGrandTotal.text = [NSString stringWithFormat:@"Total: %@%.02f",currencySign, final_price];
                            }
                        }
                        else
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Redeem feature have been disabled by the restaurant" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            [alert show];
                            return NO;
                        }
                    }
                    else
                    {
                        // allow backspace
                        if (!string.length)
                        {
                            if(onePoint > 0)
                            {
                                NSLog(@"grandTotal : %f", grandTotal);
                                NSLog(@"oneAmount : %f", oneAmount);
                                NSLog(@"((oneAmount * [point floatValue]) : %f", (oneAmount * [point floatValue]));
                                NSLog(@"((oneAmount * [point floatValue]) : %f",  ((oneAmount * [point floatValue])/onePoint));
                                
                                float final_price = grandTotal - ((oneAmount * [point floatValue])/onePoint);
                                NSLog(@"final_price : %f", final_price);
                                
                                if(final_price < 0)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Total Price is not enough to Redeem Points." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                    [alert show];
                                    return NO;
                                }
                                else
                                {
                                    
                                    lblPoints.text = [NSString stringWithFormat:@"%.02f", final_point];
                                    
                                    lblGrandTotal.text = [NSString stringWithFormat:@"Total: %@%.02f",currencySign, final_price];
                                }
                            }
                            return YES;
                        }
                        return NO;
                    }
                }
                else
                {
                    if(onePoint > 0)
                    {
                        NSLog(@"grandTotal : %f", grandTotal);
                        NSLog(@"oneAmount : %f", oneAmount);
                        NSLog(@"((oneAmount * [point floatValue]) : %f", (oneAmount * [point floatValue]));
                        NSLog(@"((oneAmount * [point floatValue]) : %f",  ((oneAmount * [point floatValue])/onePoint));
                        
                        float final_price = grandTotal - ((oneAmount * [point floatValue])/onePoint);
                        NSLog(@"final_price : %f", final_price);
                        
                        if(final_price < 0)
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Total Price is not enough to Redeem Points." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            [alert show];
                            return NO;
                        }
                        else
                        {
                            
                            lblPoints.text = [NSString stringWithFormat:@"%.02f", final_point];
                            
                            lblGrandTotal.text = [NSString stringWithFormat:@"Total: %@%.02f",currencySign, final_price];
                        }
                    }
                    else
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Redeem feature have been disabled by the restaurant" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alert show];
                        return NO;
                    }
                }
            }
            return  [string isEqualToString:filtered];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You have not enough Total Points for Redeem" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
        
        // allow backspace
        if (!string.length)
        {
            return YES;
        }
    }
    else
    {
//        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        textField.text = [NSString stringWithFormat:@" %@", textField.text];
//        
//        // allow backspace
//        if (!string.length)
//        {
//            return YES;
//        }
    }
    
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField== self.txtRedeem)
    {
        [self.txtRedeem resignFirstResponder];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  
    [self.view endEditing:YES];
  
    [super touchesBegan:touches withEvent:event];
}
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    
//}
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView
//{
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
