//
//  addOrderViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/23/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "DeliveryAddressViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "paymentViewController.h"
#import "homeDeliveryViewController.h"
#import "HomeDelivery.h"
#import "Singleton.h"
#import "OrderDetailViewController.h"
#import "DashboardView.h"

#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLAvailability.h>

#define FONT_CATEGORY_IPHONE [UIFont fontWithName:@"OpenSans-Light" size:17]
@interface DeliveryAddressViewController ()<GMSMapViewDelegate,CLLocationManagerDelegate>
{
    CLGeocoder *geocoder;
}
@end
@implementation NSArray(SPFoundationAdditions)
- (id)onlyObject
{
    return [self count] == 1 ? [self objectAtIndex:0] : nil;
}
@end

@implementation DeliveryAddressViewController
@synthesize arrProfileData;

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
 
    IS_POSSIBLE_HOMEDELIVERY=FALSE;
    IS_SELECT_CASHMODE=FALSE;
    
//    self.lblTitleAddOrder.font = FONT_centuryGothic_35;
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GettingCountryList) name:@"GettingCountryList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OTPSend) name:@"OTPSend" object:nil];
    
    NSLog(@"[[Singleton sharedSingleton] getIndexId] : %d", [[Singleton sharedSingleton] getIndexId]);
    NSLog(@"[[Singleton sharedSingleton] getarrRestaurantList]  : %@", [[Singleton sharedSingleton] getarrRestaurantList] );
    NSLog(@"[[Singleton sharedSingleton] getarrRestaurantList]  : %@", [[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:[[Singleton sharedSingleton] getIndexId]] objectForKey:@"CountryISO2"] );
    
    
    countryCodeISO2 = [[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:[[Singleton sharedSingleton] getIndexId]] objectForKey:@"CountryISO2"]; //@"IN";
    CurrencyCode = [[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:[[Singleton sharedSingleton] getIndexId]] objectForKey:@"CurrencyCode"]; //@"IN";
    
    
    if([countryCodeISO2 isEqualToString:@""])
    {
        countryCodeISO2=@"PL";
    }
    arrLocation = [[NSMutableArray alloc] init];
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
 ///   tapGesture.cancelsTouchesInView = NO;
 //   [self.scrollview addGestureRecognizer:tapGesture];
 //   self.scrollview.delaysContentTouches = NO;

   
    
    tblLocationList.tableFooterView = [[UIView alloc] init];
    
    self.btnDeliveredToAddress.layer.cornerRadius = 5.0;
    self.btnDeliveredToAddress.clipsToBounds = YES;
   
     self.btnDelete.layer.cornerRadius = 5.0;
     self.btnDelete.clipsToBounds = YES;

    self.btnEdit.layer.cornerRadius = 5.0;
    self.btnEdit.clipsToBounds = YES;
    
    self.btnDone.layer.cornerRadius = 5.0;
    self.btnDone.clipsToBounds = YES;

    self.btnCancel.layer.cornerRadius = 5.0;
    self.btnCancel.clipsToBounds = YES;

    self.viewNewAddress.hidden = YES;

    btnOTPSend.layer.cornerRadius = 5.0;
    btnOTPSend.clipsToBounds = YES;
    
    txtOTP.hidden = YES;
    btnOTPResend.hidden = YES;
    btnOTPSend.hidden = YES;
    
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [txtOTP setLeftViewMode:UITextFieldViewModeAlways];
    [txtOTP setLeftView:spacerView];
    
    if([[[Singleton sharedSingleton] getarrProfileDetail] count] <= 0)
    {
        [self getProfileDetail];
    }
    else
    {
        arrProfileData = [[NSMutableArray alloc] init];
        [arrProfileData addObject:[[Singleton sharedSingleton] getarrProfileDetail] ];
        
        [self ViewFilledUpProfileData];
    }
    [[Singleton sharedSingleton] PayPalConfigOnDidLoad];

    //Cancel & Done button for num pad
    UIToolbar *numberToolbar = [[Singleton sharedSingleton] AccessoryButtonsForNumPad:self];
    self.txtZipcode.inputAccessoryView = numberToolbar;
    self.txtphoneNumber.inputAccessoryView = numberToolbar;
    self.txtEdit_phone.inputAccessoryView = numberToolbar;
  
    // Do any additional setup after loading the view from its nib.
}

-(void)cancelNumberPad{
    
    [self.txtZipcode resignFirstResponder];
    [self.txtphoneNumber resignFirstResponder];
    [self.txtEdit_phone resignFirstResponder];
    
    self.scrollview.contentOffset=CGPointMake(0, 0);
    // self.txtContactnumber.text = @"";
}

-(void)doneWithNumberPad{
    //NSString *numberFromTheKeyboard = self.txtContactnumber.text;
    [self.txtZipcode resignFirstResponder];
    [self.txtphoneNumber resignFirstResponder];
    [self.txtEdit_phone resignFirstResponder];
    
    self.scrollview.contentOffset=CGPointMake(0, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    // Preconnect to PayPal early
    [[Singleton sharedSingleton] setPayPalEnvironment];
}

-(void)GettingCountryList
{
    [self stopActivity];
    [self getCountryList];
}
-(void)OTPSend
{
    txtOTP.hidden = NO;
    btnOTPResend.hidden = NO;
    btnOTPSend.hidden = NO;
    
//    [self setScrollContentToView];
    
    if(!IS_IPAD)
    {
        NSLog(@"self.btnDeliveredToAddress.frame : %@", NSStringFromCGRect(self.btnDeliveredToAddress.frame));
        
        NSLog(@"self.btnEdit.frame : %@", NSStringFromCGRect(self.btnEdit.frame));
     
        NSLog(@"self.viewAllButtons.frame : %@", NSStringFromCGRect(self.viewAllButtons.frame));
                
        if(self.viewOldAddress.hidden)
        {
            
            CGRect f = txtOTP.frame;
            f.origin.y = self.btnDeliveredToAddress.frame.origin.y+self.btnDeliveredToAddress.frame.size.height + 15;
            txtOTP.frame = f;
            
            f  = btnOTPSend.frame;
            f.origin.x = txtOTP.frame.origin.x+txtOTP.frame.size.width + 15;
            f.origin.y = txtOTP.frame.origin.y;
            btnOTPSend.frame = f;
            
            f  = btnOTPResend.frame;
            f.origin.y = txtOTP.frame.origin.y +txtOTP.frame.size.height + 8;
            btnOTPResend.frame = f;
            
        }
        else
        {
            CGRect f = txtOTP.frame;
            f.origin.y = self.btnEdit.frame.origin.y+self.btnEdit.frame.size.height + 15;
            txtOTP.frame = f;
            
            f  = btnOTPSend.frame;
            f.origin.x = txtOTP.frame.origin.x+txtOTP.frame.size.width + 15;
            f.origin.y = txtOTP.frame.origin.y;
            btnOTPSend.frame = f;
            
            f  = btnOTPResend.frame;
            f.origin.y = txtOTP.frame.origin.y +txtOTP.frame.size.height + 8;
            btnOTPResend.frame = f;
        }
        
        self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.viewAllButtons.frame.origin.y + self.viewAllButtons.frame.size.height+70);
        
        self.scrollview.scrollEnabled = YES;
        self.scrollview.delaysContentTouches = NO;
        [self.scrollview setClipsToBounds:YES];
        
    }
}
-(void)ViewFilledUpProfileData
{
    [self.btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
    [self.btnDelete setTitle:@"Add new address" forState:UIControlStateNormal];
    
    if([arrProfileData count] > 0)
    {
        if([[[arrProfileData objectAtIndex:0] objectAtIndex:0] count] > 0)
        {
           
            [self setImageFromPath];
            
            self.lblPhoneNumber.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"MobileNo"]]];
            
            self.lblName.text = [NSString stringWithFormat:@"%@ %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"FirstName"]], [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"LastName"]]];
            
            
            NSString *s1 = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"StreetLine1"]];
            NSString *s2 = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"StreetLine2"]];
            NSString *s3 =  [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"City"]];
            NSString *s4 = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"ZipCode"]];
            NSString *s5 = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"StateName"]];
            NSString *s6 = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"CountryName"]];
            countryDBID =[NSString stringWithFormat:@"%@", [[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"Country"]];
            stateDBID =[NSString stringWithFormat:@"%@", [[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"State"]];
          
            self.lblAddress.text = [NSString stringWithFormat:@"%@, %@, %@-%@, %@, %@", s1, s2, s3, s4, s5, s6];
            CGRect f = self.lblAddress.frame;
            f.size.height = ceilf([[Singleton sharedSingleton] heightOfTextForLabel:self.lblAddress.text andFont:self.lblAddress.font maxSize:CGSizeMake(self.lblAddress.frame.size.width, 20000)].height);
            self.lblAddress.frame = f;
            
            if([self.lblAddress.text isEqualToString:@", , -, , "])
            {
                self.lblAddress.text=@"";
            }
          
            email = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"EMail"]]];
            
            dob = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"DOB"]]];
            
            storeName = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"StoreName"]]];
            
            [self setFrameOfButtons];
        }
    }
    
    [self.view setUserInteractionEnabled:YES];
    [self setFrameOfButtons];    
}
-(void)setScrollContentToView
{
    if(!IS_IPAD)
    {
        
        if(self.viewOldAddress.hidden)
        {
            if(txtOTP.hidden)
            {
                 self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.viewAllButtons.frame.origin.y + self.viewAllButtons.frame.size.height+10);
            }
            else
            {
                 self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.viewAllButtons.frame.origin.y + self.viewAllButtons.frame.size.height+50);
            }
           
            
            self.scrollview.scrollEnabled = YES;
            self.scrollview.delaysContentTouches = NO;
            [self.scrollview setClipsToBounds:YES];            
        }
        else
        {
            if(txtOTP.hidden)
            {
                self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.viewAllButtons.frame.origin.y + self.viewAllButtons.frame.size.height+10);
            }
            else
            {
                self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.viewAllButtons.frame.origin.y + self.viewAllButtons.frame.size.height+50);
            }
            
            self.scrollview.scrollEnabled = YES;
            self.scrollview.delaysContentTouches = NO;
            [self.scrollview setClipsToBounds:YES];
        }
    }
    else
    {
        if(self.viewOldAddress.hidden)
        {
            CGRect f = txtOTP.frame;
            f.origin.y = self.btnDeliveredToAddress.frame.origin.y+self.btnDeliveredToAddress.frame.size.height + 15;
            txtOTP.frame = f;
            
            f  = btnOTPSend.frame;
            f.origin.x = txtOTP.frame.origin.x+txtOTP.frame.size.width + 15;
            f.origin.y = txtOTP.frame.origin.y;
            btnOTPSend.frame = f;
            
            f  = btnOTPResend.frame;
            f.origin.y = txtOTP.frame.origin.y +txtOTP.frame.size.height + 8;
            btnOTPResend.frame = f;
            
            self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.viewAllButtons.frame.origin.y + self.viewAllButtons.frame.size.height+10);
            
            self.scrollview.scrollEnabled = YES;
            self.scrollview.delaysContentTouches = NO;
            [self.scrollview setClipsToBounds:YES];
        }
        else
        {
                CGRect f = txtOTP.frame;
                f.origin.y = self.btnEdit.frame.origin.y+self.btnEdit.frame.size.height + 15;
                txtOTP.frame = f;
                
                f  = btnOTPSend.frame;
                f.origin.x = txtOTP.frame.origin.x+txtOTP.frame.size.width + 15;
                f.origin.y = txtOTP.frame.origin.y;
                btnOTPSend.frame = f;
                
                f  = btnOTPResend.frame;
                f.origin.y = txtOTP.frame.origin.y +txtOTP.frame.size.height + 8;
                btnOTPResend.frame = f;
                
                self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.viewAllButtons.frame.origin.y + self.viewAllButtons.frame.size.height+10);
                
                self.scrollview.scrollEnabled = YES;
                self.scrollview.delaysContentTouches = NO;
                [self.scrollview setClipsToBounds:YES];
            
        }
        
    }
}


-(void)setFrameOfButtons
{
    
    if(self.btnEdit.hidden)
    {
        CGRect f = self.viewAllButtons.frame;
        if(IS_IPAD)
        {
            f.origin.y = self.viewNewAddress.frame.origin.y + self.viewNewAddress.frame.size.height - 30;
        }
        else
        {
            f.origin.y = self.viewNewAddress.frame.origin.y + self.viewNewAddress.frame.size.height + 10;
        }
        self.viewAllButtons.frame = f;
    }
    else if([self.btnEdit.titleLabel.text isEqualToString:@"Edit"])
    {
        CGRect f = self.viewAllButtons.frame;
        if(IS_IPAD)
        {
            f.origin.y = self.viewOldAddress.frame.origin.y + self.viewOldAddress.frame.size.height - 30;
        }
        else
        {
            f.origin.y = self.viewOldAddress.frame.origin.y + self.viewOldAddress.frame.size.height + 10;
        }
        self.viewAllButtons.frame = f;
    }
    
}
-(void)setFrameOfButtons_AddNewAddress
{
    if(self.btnDelete.hidden)
    {
        CGRect f = self.viewAllButtons.frame;
        if(IS_IPAD)
        {
            f.origin.y = self.viewNewAddress.frame.origin.y + self.viewNewAddress.frame.size.height - 30;
        }
        else
        {
            f.origin.y = self.viewNewAddress.frame.origin.y + self.viewNewAddress.frame.size.height + 10;
        }
        self.viewAllButtons.frame = f;
    }
    else if([self.btnDelete.titleLabel.text isEqualToString:@"Add new address"])
    {
        CGRect f = self.viewAllButtons.frame;
        if(IS_IPAD)
        {
            f.origin.y = self.viewOldAddress.frame.origin.y + self.viewOldAddress.frame.size.height - 30;
        }
        else
        {
            f.origin.y = self.viewOldAddress.frame.origin.y + self.viewOldAddress.frame.size.height + 10;
        }
        self.viewAllButtons.frame = f;
    }
}
-(void)setImageFromPath
{
    NSString *Photo = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"Photo"]]];
    
    if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:Photo] isEqualToString:@""])
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
        dispatch_async(queue, ^{
            NSData *imageData;
            UIImage *image;
            
            
            NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, Photo];
            
            image =  [[Singleton sharedSingleton] getImageFromCache:[imageName lastPathComponent]];
            
            if(image != nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                
                    [[Singleton sharedSingleton] setstrImgEncoded:[[Singleton sharedSingleton] encodeToBase64String:image]];
                    
                    [[Singleton sharedSingleton] setstrImgFilename: [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"OriginalName"]]];
                });
            }
            else
            {
                NSURL *imageURL =[NSURL URLWithString:imageName];
                if(imageData == nil)
                {
                    imageData = [[NSData alloc] init];
                }
                imageData = [NSData dataWithContentsOfURL:imageURL];
                //        NSData *data = [NSData dataWithContentsOfURL:imageURL];
                image = [UIImage imageWithData:imageData];
                
                //  /Upload/UserCard/bb1f9253-ae44-44a1-8427-94d1a0e71dfc/bb1f9253-ae44-44a1-8427-94d1a0e71dfc_06102014521AM.png
                
                [[Singleton sharedSingleton] saveImageInCache:image ImgName:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"Photo"]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(image == nil)
                        
                    {
                       
                        
                    }
                    
                    else{
                        
                        
                        [[Singleton sharedSingleton] setstrImgEncoded:[[Singleton sharedSingleton] encodeToBase64String:image]];
                        
                        
                        
                        [[Singleton sharedSingleton] setstrImgFilename: [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"OriginalName"]]];
                        
                    }
                });
                
            }
            
            
            
        });
        
        
        
        
    }
}
-(void)SendToServerPaymentInfo
{
    [self.view endEditing:YES];
    if([[[Singleton sharedSingleton] ISNSSTRINGNULL:[Singleton sharedSingleton].PaymentMode] isEqualToString:@""])
    {
        [self stopActivity];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please select payment mode" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
//        UIImage *Checkimage = [UIImage imageNamed:@"check-box-select.png"];
//        UIImage *Uncheckimage = [UIImage imageNamed:@"check-box.png"];
//        self.radioButton1.enabled =YES;
//        self.radioButton2.enabled =YES;
//        [self.radioButton1 setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
//        [self.radioButton2 setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
        
         [self stopActivity];
        
        if([[Singleton sharedSingleton].PaymentMode isEqualToString:CashOnDelivery])
        {
            [[Singleton sharedSingleton] sendOTPToUser];
//            [[Singleton sharedSingleton] sendSuccessTranscationToServer];
        }
        else
        {
            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
            NSString * orderID ;
            if([st objectForKey:@"OrderID"])
            {
                orderID =  [st objectForKey:@"OrderID"];
            }
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:orderID forKey:@"orderID"];
            [dict setValue:[NSString stringWithFormat:@"%.02f", self.orderTotal] forKey:@"totalPrice"];
            [dict setValue:CurrencyCode forKey:@"currencyCode"];
            
            [[Singleton sharedSingleton] PayPalCheckOutClicked:dict];
        }
    }
}

#pragma mark UIBUTTON CLICKED
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
#pragma mark Get Profile Detail

-(void)getProfileDetail
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
        [self startActivity];
        
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        NSString * userId ;
        if([st objectForKey:@"UserId"])
        {
            userId =  [st objectForKey:@"UserId"];
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:userId forKey:@"UserId"];
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Profile Data - - %@ -- ", dict);
             
             if (dict)
             {
                 
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                   
                     [self stopActivity];
                 }
                 else
                 {
                     if([[dict objectForKey:@"data"] count] > 0)
                     {
                         arrProfileData = [[NSMutableArray alloc] init];
                         [arrProfileData addObject:[dict objectForKey:@"data"]];
                         
                         [[Singleton sharedSingleton] setarrProfileDetail:[dict objectForKey:@"data"]];
                         
                         [self ViewFilledUpProfileData];
                         
                         [self stopActivity];
                     }
                 }
             }
             else
             {
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
                 [self stopActivity];
             }
         } :@"Login/GetProfile" data:dict];
    }
}
#pragma mark Save Profile Detail

-(void)saveProfileDetail
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        NSString * OrderID ;
        if([st objectForKey:@"OrderID"])
        {
            OrderID =  [st objectForKey:@"OrderID"];
        }
        
        
        NSString *firstname = [[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtFirtname.text];
        NSString *lastname = [[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtLastname.text];
        
        NSString *contactNumber = [[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtphoneNumber.text];
        NSString *StreetLine1 = [[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtAddress1.text];
        NSString *StreetLine2 = [[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtAddress2.text];
        NSString *City = [[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtCity.text];
        NSString *ZipCode = [[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtZipcode.text];
        NSString *photo = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[Singleton sharedSingleton] getstrImgEncoded]];
        NSString *originalname = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[Singleton sharedSingleton] getstrImgFilename]];
        
        
//        //edit old address
//        BOOL IS_SELCT_CASHMODE_OLD=FALSE;
//        if([[[Singleton sharedSingleton] ISNSSTRINGNULL:[Singleton sharedSingleton].PaymentMode] isEqualToString:@""])
//        {
//            IS_SELCT_CASHMODE_OLD=FALSE;
//        }
//        else
//        {
//            IS_SELCT_CASHMODE_OLD=TRUE;
//        }
        
        
        if([[[Singleton sharedSingleton] ISNSSTRINGNULL:[Singleton sharedSingleton].PaymentMode] isEqualToString:@""])
        {
            IS_SELECT_CASHMODE=FALSE;
        }
        else
        {
            IS_SELECT_CASHMODE=TRUE;
        }

        
        if([firstname isEqualToString:@""] || [lastname isEqualToString:@""]  ||[contactNumber isEqualToString:@""] || [StreetLine1 isEqualToString:@""]|| [StreetLine2 isEqualToString:@""] || [ZipCode isEqualToString:@""])
        { [self stopActivity];
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_EMPTY_DATA message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }       
        else if(contactNumber.length < 4)
        { [self stopActivity];
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Mobile length should be atleast 4 or more" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else if(ZipCode.length <= 3)
        { [self stopActivity];
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Zipcode length should be atleast 3 or more" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else if([strURL isEqualToString:@"User/OrderDelivery"] && !IS_POSSIBLE_HOMEDELIVERY)
        {
            [self stopActivity];
            if([[[Singleton sharedSingleton] ISNSSTRINGNULL:distance] isEqualToString:@""])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The restaurant you tring to order/home delivery does not provide service in this area" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"This restaurant is provide food/drinks home delivery service in %.01f Km and your address distance is %@", res_minimuDistance, distance] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else if([strURL isEqualToString:@"User/OrderDelivery"] && !IS_SELECT_CASHMODE)
        { [self stopActivity];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please select payment mode" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if([strURL isEqualToString:@"Login/EditProfile"] && !IS_POSSIBLE_HOMEDELIVERY)
        { [self stopActivity];
            if([[[Singleton sharedSingleton] ISNSSTRINGNULL:distance] isEqualToString:@""])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The restaurant you tring to order/home delivery does not provide service in this area" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"This restaurant is provide food/drinks home delivery service in %.01f Km and your address distance is %@", res_minimuDistance, distance] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else if([strURL isEqualToString:@"Login/EditProfile"] && !IS_SELECT_CASHMODE)
        {
             [self stopActivity];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please select payment mode" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            [self startActivity];
            
            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
            NSString * userId ;
            if([st objectForKey:@"UserId"])
            {
                userId =  [st objectForKey:@"UserId"];
            }
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:userId forKey:@"UserId"];
            [dict setValue:firstname forKey:@"FirstName"];
            [dict setValue:lastname forKey:@"LastName"];
            
            [dict setValue:StreetLine1 forKey:@"StreetLine1"];
            [dict setValue:StreetLine2 forKey:@"StreetLine2"];
            [dict setValue:City forKey:@"City"];
            [dict setValue:ZipCode forKey:@"ZipCode"];
            [dict setValue:stateDBID forKey:@"State"];
            [dict setValue:countryDBID forKey:@"Country"];
            
            if([strURL isEqualToString:@"Login/EditProfile"])
            {
                [dict setValue:contactNumber forKey:@"MobileNo"];
                [dict setValue:dob forKey:@"DOB"];
                [dict setValue:email forKey:@"EMail"];
                [dict setValue:storeName forKey:@"StoreName"];
                [dict setValue:photo forKey:@"Photo"];
                [dict setValue:originalname forKey:@"OriginalName"];
            }
            else
            {
                 [dict setValue:OrderID forKey:@"OrderId"];
                 [dict setValue:strLatitude forKey:@"Latidute"];
                 [dict setValue:strLongitude forKey:@"Longitude"];
                 [dict setValue:contactNumber forKey:@"ContactNo"];
            }
            
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 NSLog(@"Add Profile Data - - %@ -- ", dict);
                 
                 if (dict)
                 {
                     Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                     if (!strCode)
                     {
                          [self stopActivity];
                         
                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alt show];
                         
                         //                     self.scrollview.hidden = NO;
                         //                     self.viewAddProfile.hidden = NO;
                         //                     self.viewFilledUpProfile.hidden = YES;
                         //                     self.btnEditProfile.hidden = NO;
                         //
                         //                     [self.btnEditProfile setTitle:@"Save" forState:UIControlStateNormal];
                     }
                     else
                     {
                         if([dict objectForKey:@"data"]  != [NSNull null])
                         {
                             if([[dict objectForKey:@"data"] count] > 0)
                             {
                                 [self SendToServerPaymentInfo];
                                 
                                 [arrProfileData removeAllObjects];
                                 [arrProfileData addObject:[dict objectForKey:@"data"]];
                                 
                                 [[Singleton sharedSingleton] setarrProfileDetail:[dict objectForKey:@"data"]];
                                 
                            }
                         }
                         else
                         {
                            [self SendToServerPaymentInfo];
                         }
                         
                         [self ViewFilledUpProfileData];
                         
                         self.btnEdit.hidden = NO;
                         self.btnDelete.hidden = NO;
                         
                         [self.btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
                         [self.btnDelete setTitle:@"Add new address" forState:UIControlStateNormal];
                         
                         CGRect f = self.btnDeliveredToAddress.frame;
                         if(IS_IPAD)
                         {
                             f.origin.x = 280;
                         }
                         else
                         {
                             f.origin.x = 55;
                         }
                         self.btnDeliveredToAddress.frame = f;
                         
                         f = self.btnEdit.frame;
                         if(IS_IPAD)
                         {
                             f.origin.x = 215;
                         }
                         else{
                             f.origin.x = 40;
                         }
                         f.origin.y = self.btnDeliveredToAddress.frame.origin.y +  self.btnDeliveredToAddress.frame.size.height + 15;
                         self.btnEdit.frame = f;
                         
                         f = self.btnDelete.frame;
                         if(IS_IPAD)
                         {
                             f.origin.x = self.btnEdit.frame.origin.x + self.btnEdit.frame.size.width + 35;
                         }
                         else
                         {
                             f.origin.x = self.btnEdit.frame.origin.x + self.btnEdit.frame.size.width + 10;
                         }
                         f.origin.y = self.btnDeliveredToAddress.frame.origin.y + self.btnDeliveredToAddress.frame.size.height + 15;
                         f.size.width = 155;
                         self.btnDelete.frame = f;
                         //                                 }
                         
                         
                         self.viewNewAddress.hidden = YES ;
                         self.viewOldAddress.hidden = NO;
                         f = self.viewOldAddress.frame;
                         f.origin.y = self.viewNewAddress.frame.origin.y;
                         self.viewOldAddress.frame = f;
                         
                         self.btnDeliveredToAddress.enabled = YES;
                         self.btnDeliveredToAddress.alpha = 1;
                         
                         
                         if([strURL isEqualToString:@"Login/EditProfile"])
                         {
                             [self setFrameOfButtons];
                             
                         }
                         else
                         {
                             //                                     [self.btnDelete setTitle:@"Add new address" forState:UIControlStateNormal];
                             [self setFrameOfButtons_AddNewAddress];
                         }
                         
                         self.txtCity.enabled = YES;
                         self.btnbackCity.backgroundColor = [UIColor whiteColor];
                         self.txtCity.alpha = 1.0;
                         
                         self.txtState.enabled = YES;
                         self.btnbackState.backgroundColor = [UIColor whiteColor];
                         self.txtState.alpha = 1.0;
                         
                         self.btnCountry.enabled = YES;
                         self.btnCountry.backgroundColor = [UIColor whiteColor];
                         self.btnCountry.alpha = 1.0;
                         
                         [self stopActivity];
                         
                         [self setScrollContentToView];

                         
                         [self stopActivity];
                     }
                 }
                 else
                 {
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     [self stopActivity];
                 }
             } :strURL data:dict];
        }
    }
}

#pragma mark btn Delivered Click:
- (IBAction)btnDeliveredClick:(id)sender
{
    [self.view endEditing:YES];
    txtOTP.hidden = YES;
    btnOTPResend.hidden = YES;
    btnOTPSend.hidden = YES;
    
    UIButton* b = (UIButton*)sender;
    if(b.tag == 1)
    {
         //distance
        [self startActivity];
    
        if ([[Singleton sharedSingleton] connection]==0)
        {
            [[Singleton sharedSingleton] errorInternetConnection];
        }
        else
        {
            //[self startActivity];
            
            if(!self.btnEdit.hidden && !self.btnDelete.hidden)
            {
                NSLog(@"self.txtZipcode.text : %@", self.txtZipcode.text);
                if([self.txtZipcode.text isEqualToString:@""])
                {
                    self.txtZipcode.text = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"ZipCode"]];
                }
            }
            
            NSString *hostURL=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=true&components=country:%@&key=AIzaSyDUg1gY-fxa05fbOz6EQIfNQDkPxxf3fbM",self.txtZipcode.text, countryCodeISO2];
            hostURL=[hostURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            NSURL *url=[[NSURL alloc] initWithString:hostURL];
            //NSLog(@"Location Search URL:-----%@",url);
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"GET"];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data,NSError *connectionError)
             {
                 if ([data length]>0 && connectionError==nil)
                 {
                     NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
                     NSMutableArray *arrLocationTemp=[[NSMutableArray alloc] init];
                     arrLocationTemp=[dict objectForKey:@"predictions"];
                     [arrLocation removeAllObjects];
                     for (int index=0; index<[arrLocationTemp count]; index++)
                     {
                         [arrLocation addObject:[[arrLocationTemp objectAtIndex:index] objectForKey:@"description"]];
                     }
                    
                     //search exacte keyword from array list
                     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@ OR SELF LIKE %@ OR SELF CONTAINS[cd] %@", self.txtZipcode.text, self.txtZipcode.text, self.txtZipcode.text];
                     NSArray *array = [arrLocation filteredArrayUsingPredicate: predicate];
                     NSLog(@"result: %@", array);
                     
                     if([array count] > 0)
                     {
                         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                             [[self geocoder] geocodeAddressString:[array objectAtIndex:0] completionHandler:^(NSArray *placemarks, NSError *error) {
                                 if (error)
                                 {
                                     [self stopActivity];
                                     //block(nil, nil, error);
                                 } else
                                 {
                                     NSLog(@"%@",placemarks);
                                     //                NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
                                     
                                     //lblLoading.hidden = YES;
                                     
                                     CLPlacemark *placemark = [placemarks onlyObject];
                                     CLLocation *location=placemark.location;
                                     CLLocationCoordinate2D coordinate = [location coordinate];
                                     //                [self setPlace:coordinate];
                                     NSLog(@"%f",coordinate.latitude);
                                     NSLog(@"%f",coordinate.longitude);
                                     
                                     strLatitude= [NSNumber numberWithDouble:coordinate.latitude];
                                     strLongitude = [NSNumber numberWithDouble:coordinate.longitude];
                                     
                                     double res_lat = [[[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:[[Singleton sharedSingleton] getIndexId]] objectForKey:@"Latidute"] doubleValue];
                                     double res_long = [[[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:[[Singleton sharedSingleton] getIndexId]] objectForKey:@"Longitude"] doubleValue];
                                     
                                     distance = [[Singleton sharedSingleton] getDistanceBetweenLocations:[strLatitude doubleValue] Lon:[strLongitude doubleValue] Aontherlat:res_lat AnotheLong:res_long];
                                     distance = [[Singleton sharedSingleton] ISNSSTRINGNULL:distance];
                                     
                                     res_minimuDistance = [[Singleton sharedSingleton] globalHomeDeliveryDistance];
                                     
                                     if(res_minimuDistance > [distance intValue])
                                     {
                                         IS_POSSIBLE_HOMEDELIVERY=TRUE;
                                     }
                                     else
                                     {
                                         IS_POSSIBLE_HOMEDELIVERY=FALSE;
                                     }
                                     
                                     
                                     //del old addess
                                     if(!self.viewNewAddress.hidden && self.btnEdit.hidden)
                                     {
                                         
                                         //edit clicked so now save edited profile
                                         strURL=@"Login/EditProfile";
                                         [self saveProfileDetail];
                                     }
                                     else if(!self.viewNewAddress.hidden && self.btnDelete.hidden)
                                     {
                                         strURL=@"User/OrderDelivery";
                                         [self saveProfileDetail];
                                     }
                                     else
                                     {
                                         [self SendToServerPaymentInfo];
                                     }
                                     
                                     //                        [self stopActivity];
                                 }
                             }];
                         }];
                     }
                     else
                     {
//                         [self stopActivity];
                         //del old addess
                         if(!self.viewNewAddress.hidden && self.btnEdit.hidden)
                         {
                             
                             //edit clicked so now save edited profile
                             strURL=@"Login/EditProfile";
                             [self saveProfileDetail];
                         }
                         else if(!self.viewNewAddress.hidden && self.btnDelete.hidden)
                         {
                             strURL=@"User/OrderDelivery";
                             [self saveProfileDetail];
                         }
                         else
                         {
                             if([[[Singleton sharedSingleton] ISNSSTRINGNULL:distance] isEqualToString:@""])
                             {
                                  [self stopActivity];
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The restaurant you tring to order/home delivery does not provide service in this area" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                 [alert show];
                             }
                             else
                             {
                                 [self SendToServerPaymentInfo];
                             }
                         }
                     }                    
                 }
                 else{
                     NSLog(@"Error : %@", connectionError);
                 }
             }];
        }

       
        
        
        
//            //del old addess
//            if(!self.viewNewAddress.hidden && self.btnEdit.hidden)
//            {
//            }
//            else if(!self.viewNewAddress.hidden && self.btnDelete.hidden)
//            {
//             
//            }
//            else
//            {
//                [self SendToServerPaymentInfo];
//            }
    }
    else if(b.tag == 2)
    {
        //edit
        if([self.btnEdit.titleLabel.text isEqualToString:@"Edit"])
        {
            //[self.btnEdit setTitle:@"Save" forState:UIControlStateNormal];
            [self.btnDelete setTitle:@"Cancel" forState:UIControlStateNormal];
            self.btnEdit.hidden = YES;

            CGRect f = self.btnDeliveredToAddress.frame;
            if(IS_IPAD)
            {
                 f.origin.x = 180;
            }
            else
            {
                 f.origin.x = 5;
            }
            self.btnDeliveredToAddress.frame = f;
            
            f = self.btnDelete.frame;
            f.origin.x = self.btnDeliveredToAddress.frame.origin.x + self.btnDeliveredToAddress.frame.size.width + 5;
            f.origin.y = self.btnDeliveredToAddress.frame.origin.y;
            if(IS_IPAD)
            {
                f.size.width =  160;
            }
            else
            {
                f.size.width =  80;
            }
            self.btnDelete.frame = f;

            self.viewOldAddress.hidden = YES;
            self.viewNewAddress.hidden = NO ;
            
             f = self.viewNewAddress.frame;
            f.origin.y = self.viewOldAddress.frame.origin.y - 5;
            self.viewNewAddress.frame = f;
            
            [self setFrameOfButtons];
            
             [self setScrollContentToView];
            
            self.txtCity.enabled = NO;
            self.btnbackCity.backgroundColor = [UIColor lightGrayColor];
            self.txtCity.alpha = 0.5;
            
            self.txtState.enabled = NO;
            self.btnbackState.backgroundColor = [UIColor lightGrayColor];
            self.txtState.alpha = 0.5;
            
            self.btnCountry.enabled = NO;
            self.btnCountry.backgroundColor = [UIColor lightGrayColor];
            self.btnCountry.alpha = 0.5;
            
            NSString *fname = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"FirstName"]]];
            
            NSString *lname = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"LastName"]]];
            
            NSString *number = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"MobileNo"]]];
            
            
            NSString *StreetLine1 = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"StreetLine1"]]];
            
            NSString *StreetLine2 = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"StreetLine2"]]];
            
            NSString *City = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"City"]]];
            
            NSString *ZipCode = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"ZipCode"]]];
          
            NSString *sName_ = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"StateName"]]];
            
            NSString *cName_ = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"CountryName"]]];
            
          

            if(![fname isEqualToString:@""])
            {
                self.txtFirtname.text = fname;
            }
            if(![lname isEqualToString:@""])
            {
                self.txtLastname.text = lname;
            }
            if(![number isEqualToString:@""])
            {
                self.txtphoneNumber.text = number;
            }
            if(![StreetLine1 isEqualToString:@""])
            {
                self.txtAddress1.text = StreetLine1;
            }
            if(![StreetLine2 isEqualToString:@""])
            {
                self.txtAddress2.text = StreetLine2;
            }
            if(![City isEqualToString:@""])
            {
                self.txtCity.text = City;
            }
            if(![ZipCode isEqualToString:@""])
            {
                self.txtZipcode.text = ZipCode;
            }
            if(![cName_ isEqualToString:@""])
            {
                [self.btnCountry setTitle:[NSString stringWithFormat:@"  %@", cName_] forState:UIControlStateNormal];
            }
            if(![sName_ isEqualToString:@""])
            {
                self.txtState.text = [NSString stringWithFormat:@"  %@", sName_] ;
            }
            
        }
        else if([self.btnEdit.titleLabel.text isEqualToString:@"Cancel"])
        {
            //cancel - so display old address
            [self ViewFilledUpProfileData];
            
            self.btnEdit.hidden = NO;
            self.btnDelete.hidden = NO;
            
            [self.btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
            [self.btnDelete setTitle:@"Add new address" forState:UIControlStateNormal];

                CGRect f = self.btnDeliveredToAddress.frame;
                if(IS_IPAD)
                {
                    f.origin.x = 280;
                }
                else
                {
                    f.origin.x = 55;
                }
                self.btnDeliveredToAddress.frame = f;
                
                 f = self.btnEdit.frame;
                if(IS_IPAD)
                {
                    f.origin.x = 215;
                }
                else
                {
                    f.origin.x = 40;
                }
            
                f.origin.y = self.btnDeliveredToAddress.frame.origin.y +  self.btnDeliveredToAddress.frame.size.height + 15;
                self.btnEdit.frame = f;
                
                 f = self.btnDelete.frame;
                if(IS_IPAD)
                {
                    f.origin.x = self.btnEdit.frame.origin.x + self.btnEdit.frame.size.width + 35;
                }
                else
                {
                    f.origin.x = self.btnEdit.frame.origin.x + self.btnEdit.frame.size.width + 10;
                }
                f.size.width = 155;
                f.origin.y = self.btnDeliveredToAddress.frame.origin.y +  self.btnDeliveredToAddress.frame.size.height + 15;
                self.btnDelete.frame = f;
//            }
           
            self.viewNewAddress.hidden = YES ;
            self.viewOldAddress.hidden = NO;
             f = self.viewOldAddress.frame;
            f.origin.y = self.viewNewAddress.frame.origin.y;
            self.viewOldAddress.frame = f;
            
            self.btnDeliveredToAddress.enabled = YES;
            self.btnDeliveredToAddress.alpha = 1;
            
            self.txtCity.enabled = YES;
            self.btnbackCity.backgroundColor = [UIColor whiteColor];
            self.txtCity.alpha = 1.0;
            
            self.txtState.enabled = YES;
            self.btnbackState.backgroundColor = [UIColor whiteColor];
            self.txtState.alpha = 1.0;
            
            self.btnCountry.enabled = YES;
            self.btnCountry.backgroundColor = [UIColor whiteColor];
            self.btnCountry.alpha = 1.0;
            
            
            [self setFrameOfButtons_AddNewAddress];
            
            
            self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width,0);
        }
    }
    else if(b.tag == 3)
    {
        //add new address

        if([self.btnDelete.titleLabel.text isEqualToString:@"Add new address"])
        {
            [self.btnEdit setTitle:@"Cancel" forState:UIControlStateNormal];
            
             self.btnDelete.hidden = YES;
            
            CGRect f = self.btnDeliveredToAddress.frame;
            if(IS_IPAD)
            {
                f.origin.x = 180; //200;
            }
            else
            {
                f.origin.x = 5;
            }
            self.btnDeliveredToAddress.frame = f;
            
            f = self.btnEdit.frame;
            f.origin.x = self.btnDeliveredToAddress.frame.origin.x + self.btnDeliveredToAddress.frame.size.width + 5;
            f.origin.y = self.btnDeliveredToAddress.frame.origin.y;
            self.btnEdit.frame = f;

            
            self.viewNewAddress.hidden = NO;
            self.viewOldAddress.hidden = YES;
            
             f = self.viewNewAddress.frame;
            f.origin.y = self.viewOldAddress.frame.origin.y - 5;
            self.viewNewAddress.frame = f;
            
            [self setFrameOfButtons_AddNewAddress];
            
            
            [self setScrollContentToView];
            
            
            self.txtFirtname.text=@"";
            self.txtLastname.text=@"";
            self.txtphoneNumber.text=@"";
            self.txtZipcode.text=@"";
            self.txtAddress2.text=@"";
            self.txtAddress1.text=@"";
            
            self.txtCity.enabled = YES;
            self.txtState.enabled = YES;
            self.btnCountry.enabled = YES;
           
            if([[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:[[Singleton sharedSingleton] getIndexId]] count] > 0)
            {
                self.txtCity.text =  [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[[Singleton sharedSingleton] getarrRestaurantList]objectAtIndex:[[Singleton sharedSingleton] getIndexId]] objectForKey:@"City"]];
                self.txtState.text = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[[Singleton sharedSingleton] getarrRestaurantList]  objectAtIndex:[[Singleton sharedSingleton] getIndexId]] objectForKey:@"StateName"]];
                 [self.btnCountry setTitle:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:[[Singleton sharedSingleton] getIndexId]] objectForKey:@"CountryName"]] forState:UIControlStateNormal];
                
                countryDBID =[NSString stringWithFormat:@"%@", [[[[Singleton sharedSingleton] getarrRestaurantList]  objectAtIndex:[[Singleton sharedSingleton] getIndexId]] objectForKey:@"Country"]];
                stateDBID =[NSString stringWithFormat:@"%@", [[[[Singleton sharedSingleton] getarrRestaurantList]   objectAtIndex:[[Singleton sharedSingleton] getIndexId]] objectForKey:@"State"]];
            }
            
            
            self.txtCity.enabled = NO;
            self.btnbackCity.backgroundColor = [UIColor lightGrayColor];
            self.txtCity.alpha = 0.5;
            
            self.txtState.enabled = NO;
            self.btnbackState.backgroundColor = [UIColor lightGrayColor];
            self.txtState.alpha = 0.5;
            
            self.btnCountry.enabled = NO;
            self.btnCountry.backgroundColor = [UIColor lightGrayColor];
            self.btnCountry.alpha = 0.5;
            
            [self.btnDelete setTitle:@"Save" forState:UIControlStateNormal];
          
            self.btnDelete.hidden = YES;
            
            self.btnDeliveredToAddress.enabled = YES;
            self.btnDeliveredToAddress.alpha = 1;
        }
        else if([self.btnDelete.titleLabel.text isEqualToString:@"Cancel"])
        {
            //cancel - so display old address
            [self ViewFilledUpProfileData];
            
            self.btnEdit.hidden = NO;
            self.btnDelete.hidden = NO;
           
            [self.btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
            [self.btnDelete setTitle:@"Add new address" forState:UIControlStateNormal];
            
                CGRect f = self.btnDeliveredToAddress.frame;
                if(IS_IPAD)
                {
                    f.origin.x = 280;
                }
                else
                {
                    f.origin.x = 55;
                }
                self.btnDeliveredToAddress.frame = f;
                
            
               f = self.btnEdit.frame;
                if(IS_IPAD)
                {
                    f.origin.x = 215;// f.origin.x-15;
                }
                else
                {
                    
                }
               f.origin.y = self.btnDeliveredToAddress.frame.origin.y +  self.btnDeliveredToAddress.frame.size.height + 15;
               self.btnEdit.frame = f;
               
            
                f = self.btnDelete.frame;
            if(IS_IPAD)
            {
                f.origin.x = self.btnEdit.frame.origin.x + self.btnEdit.frame.size.width + 35;
            }
            else
            {
                f.origin.x = self.btnEdit.frame.origin.x + self.btnEdit.frame.size.width + 10;
            }
                f.size.width = 155;
                f.origin.y = self.btnDeliveredToAddress.frame.origin.y +  self.btnDeliveredToAddress.frame.size.height + 15;
                self.btnDelete.frame = f;
//            }
            
           
            
            self.viewNewAddress.hidden = YES ;
            self.viewOldAddress.hidden = NO;
             f = self.viewOldAddress.frame;
            f.origin.y = self.viewNewAddress.frame.origin.y;
            self.viewOldAddress.frame = f;
            
            self.btnDeliveredToAddress.enabled = YES;
            self.btnDeliveredToAddress.alpha = 1;
            
            self.txtCity.enabled = YES;
            self.btnbackCity.backgroundColor = [UIColor whiteColor];
            self.txtCity.alpha = 1.0;
            
            self.txtState.enabled = YES;
            self.btnbackState.backgroundColor = [UIColor whiteColor];
            self.txtState.alpha = 1.0;
            
            self.btnCountry.enabled = YES;
            self.btnCountry.backgroundColor = [UIColor whiteColor];
            self.btnCountry.alpha = 1.0;
            
            [self setFrameOfButtons];
            
            self.scrollview.contentSize = CGSizeMake(self.view.frame.size.width, 0);
        }
    }
    
    
}

- (IBAction)btnDoneClicked:(id)sender {
     UIButton* b = (UIButton*)sender;
    if(b.tag == 1)
    {
        //done
        [self.viewPickerCountry removeFromSuperview];
    }
    else if(b.tag == 2)
    {
        //cancel
        [self.viewPickerCountry removeFromSuperview];
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
        }
    }
}
- (IBAction)btnCountryClicked:(id)sender
{
    [self getCountryList];
     self.scrollview.contentOffset=CGPointMake(0, 0);
}
-(void)getCountryList
{
    if([[[Singleton sharedSingleton] arrCountryList] count] <= 0)
    {
        [self startActivity];
        [[Singleton sharedSingleton] getCountryList];
    }
    else
    {
        
        [self.pickerCountry reloadAllComponents];
        
        @try {
            [self.pickerCountry selectRow:[countryId intValue] inComponent:0 animated:YES];
        }
        @catch (NSException *exception) {
            [self.pickerCountry selectRow:0 inComponent:0 animated:YES];
        }
        [self.view addSubview:self.viewPickerCountry];
    }
}
#pragma mark OTP SEND
- (IBAction)btnOTPResendClick:(id)sender
{
    [self.view endEditing:YES];
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

#pragma  mark RADIO SELECTED
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
#pragma mark - UITableView Delegate  -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrLocation count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [tableView setUserInteractionEnabled:YES];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    cell.textLabel.text = [arrLocation objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    
    //lblLoading.hidden = YES;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.txtZipcode.text=[arrLocation objectAtIndex:indexPath.row];
    
//    tblLocationList.hidden=YES;
    
    [self startActivity];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[self geocoder] geocodeAddressString:[arrLocation objectAtIndex:indexPath.row] completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error)
            {
                [self stopActivity];
                //block(nil, nil, error);
            } else
            {
                //NSLog(@"%@",placemarks);
                //                NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
                
                //lblLoading.hidden = YES;
                
                CLPlacemark *placemark = [placemarks onlyObject];
                CLLocation *location=placemark.location;
                CLLocationCoordinate2D coordinate = [location coordinate];
                //                [self setPlace:coordinate];
                NSLog(@"%f",coordinate.latitude);
                NSLog(@"%f",coordinate.longitude);
                
                strLatitude= [NSNumber numberWithDouble:coordinate.latitude];
                strLongitude = [NSNumber numberWithDouble:coordinate.longitude];
            
                
                [self stopActivity];
            }
        }];
    }];
    [self.txtZipcode resignFirstResponder];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)findLatLongFromZipCode
{
    [self startActivity];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[self geocoder] geocodeAddressString:self.txtZipcode.text completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error)
            {
                [self stopActivity];
                //block(nil, nil, error);
            } else
            {
                //NSLog(@"%@",placemarks);
                //                NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
                
                //lblLoading.hidden = YES;
                
                CLPlacemark *placemark = [placemarks onlyObject];
                CLLocation *location=placemark.location;
                CLLocationCoordinate2D coordinate = [location coordinate];
                //                [self setPlace:coordinate];
                NSLog(@"%f",coordinate.latitude);
                NSLog(@"%f",coordinate.longitude);
                
                strLatitude= [NSNumber numberWithDouble:coordinate.latitude];
                strLongitude = [NSNumber numberWithDouble:coordinate.longitude];
                
                
                [self stopActivity];
            }
        }];
    }];
}
- (CLGeocoder *)geocoder
{
    if (!geocoder) {
        geocoder = [[CLGeocoder alloc] init];
    }
    return geocoder;
}
#pragma mark UITextViewDelegate methods
- (IBAction)txtLocationEditChange:(id)sender
{
    
    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
        //[self startActivity];
        
        NSString *hostURL=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=true&components=country:%@&key=AIzaSyDUg1gY-fxa05fbOz6EQIfNQDkPxxf3fbM",self.txtZipcode.text, countryCodeISO2];
        hostURL=[hostURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *url=[[NSURL alloc] initWithString:hostURL];
        //NSLog(@"Location Search URL:-----%@",url);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data,NSError *connectionError)
         {
             if ([data length]>0 && connectionError==nil)
             {
                 NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
                 //NSLog(@"%@",[dict objectForKey:@"predictions"]);
                 NSMutableArray *arrLocationTemp=[[NSMutableArray alloc] init];
                 arrLocationTemp=[dict objectForKey:@"predictions"];
                 //NSMutableArray *arrLocationList=[[NSMutableArray alloc] init];
                 [arrLocation removeAllObjects];
                 for (int index=0; index<[arrLocationTemp count]; index++)
                 {
                     // NSLog(@"%@",[[arrLocationTemp objectAtIndex:index] objectForKey:@"description"]);
                     [arrLocation addObject:[[arrLocationTemp objectAtIndex:index] objectForKey:@"description"]];
                 }
                 
                  //lblLoading.hidden = YES;
//                 [tblLocationList reloadData];
                 //[self stopActivity];
             }
             else{
                 NSLog(@"Error : %@", connectionError);
             }
         }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // allow backspace
    if (!string.length)
    {
        return YES;
    }
    
    if(textField == self.txtZipcode)
    {
//        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS_ZIPCODE] invertedSet];
//        
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//        
//        return [string isEqualToString:filtered];
    }
    else if(textField == self.txtphoneNumber)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS_MOBILE] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(IS_IPAD)
    {
        if(textField == self.txtFirtname)
        {
           // self.scrollview.contentOffset=CGPointMake(0, 20);
        }
        else  if(textField == self.txtLastname)
        {
            // self.scrollview.contentOffset=CGPointMake(0, 20);
        }
        else if(textField == self.txtAddress1)
        {
           // self.scrollview.contentOffset=CGPointMake(0, 50);
        }
        else if(textField == self.txtAddress2)
        {
            //self.scrollview.contentOffset=CGPointMake(0, 60);
        }
        else if(textField == self.txtCity)
        {
           // self.scrollview.contentOffset=CGPointMake(0, 120);
        }
        else if(textField == self.txtState)
        {
           // self.scrollview.contentOffset=CGPointMake(0, 180);
        }
        else if(textField == self.txtZipcode)
        {
//             tblLocationList.hidden = NO;
            if([arrLocation count] == 0)
            {
                //lblLoading.hidden = NO;
            }
            
            self.scrollview.contentOffset=CGPointMake(0, 80);
        }
        else if(textField == self.txtphoneNumber)
        {
            self.scrollview.contentOffset=CGPointMake(0, 120);
        }
        else
        {
            self.scrollview.contentOffset=CGPointMake(0, 0);
        }
    }
    else
    {
        
        if(textField == self.txtZipcode)
        {
//            tblLocationList.hidden = NO;
            if([arrLocation count] == 0)
            {
                //lblLoading.hidden = NO;
            }

        }
        svos = self.scrollview.contentOffset;
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:self.scrollview];
        pt = rc.origin;
        pt.x = 0;
        pt.y -= 100;
        [self.scrollview setContentOffset:pt animated:YES];
        
     
//            if(textField == self.txtFullname)
//            {
//                 self.scrollview.contentOffset=CGPointMake(0,300); //120
//            }
//            else if(textField == self.txtAddress1)
//            {
//                 self.scrollview.contentOffset=CGPointMake(0,  300); //180
//            }
//            else if(textField == self.txtAddress2)
//            {
//                self.scrollview.contentOffset=CGPointMake(0, self.txtAddress2.frame.origin.y+self.txtAddress2.frame.size.height); //240
//            }
//            else if(textField == self.txtCity)
//            {
//                self.scrollview.contentOffset=CGPointMake(0, 300);
//            }
//            else if(textField == self.txtState)
//            {
//                self.scrollview.contentOffset=CGPointMake(0, 370);
//            }
//            else if(textField == self.txtZipcode)
//            {
//                self.scrollview.contentOffset=CGPointMake(0, 450);
//            }
//            else if(textField == self.txtphoneNumber)
//            {
//                self.scrollview.contentOffset=CGPointMake(0, 580);
//            }
//            else
//            {
//                self.scrollview.contentOffset=CGPointMake(0, 0);
//            }
        
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField==self.txtFirtname)
    {
        [self.txtFirtname resignFirstResponder];
        [self.txtLastname becomeFirstResponder];
    }
    else  if (textField==self.txtLastname)
    {
        [self.txtLastname resignFirstResponder];
        [self.txtAddress1 becomeFirstResponder];
    }
    else if (textField==self.txtAddress1)
    {
        [self.txtAddress1 resignFirstResponder];
        [self.txtAddress2 becomeFirstResponder];
    }
    else if (textField==self.txtAddress2)
    {
        [self.txtAddress2 resignFirstResponder];
        [self.txtCity becomeFirstResponder];
        if(IS_IPAD)
        {
        // self.scrollview.contentSize=CGSizeMake(self.view.frame.size.width, 0);
             self.scrollview.contentOffset=CGPointMake(0, 0);
        }
    }
    else if (textField==self.txtCity)
    {
        [self.txtCity resignFirstResponder];
        [self.txtState becomeFirstResponder];
       
    }
    else if (textField==self.txtState)
    {
        [self.txtState resignFirstResponder];
        [self.txtZipcode becomeFirstResponder];
       
    }
    else if (textField==self.txtZipcode)
    {
        [self.txtZipcode resignFirstResponder];
        [self.txtphoneNumber becomeFirstResponder];
    }
    else if (textField==self.txtphoneNumber)
    {
        [textField resignFirstResponder];
        if(IS_IPAD)
        {
             self.scrollview.contentOffset=CGPointMake(0, 0);
//         self.scrollview.contentSize=CGSizeMake(self.view.frame.size.width, 0);
        }
    }
    else if (textField==txtOTP)
    {
        [txtOTP resignFirstResponder];
        self.scrollview.contentOffset=CGPointMake(0, 0);
    }
    else
    {
        [textField resignFirstResponder];
       // self.scrollview.contentSize=CGSizeMake(self.view.frame.size.width, 0);
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==self.txtFirtname)
    {
        [self.txtFirtname resignFirstResponder];
        [self.txtLastname becomeFirstResponder];
    }
    else  if (textField==self.txtLastname)
    {
        [self.txtLastname resignFirstResponder];
        [self.txtAddress1 becomeFirstResponder];
    }
    else if (textField==self.txtAddress1)
    {
        [self.txtAddress1 resignFirstResponder];
        [self.txtAddress2 becomeFirstResponder];
    }
    else if (textField==self.txtAddress2)
    {
        [self.txtAddress2 resignFirstResponder];
        [self.txtCity becomeFirstResponder];
        if(IS_IPAD)
        {
            self.scrollview.contentSize=CGSizeMake(self.view.frame.size.width, 0);
        }
    }
    else if (textField==self.txtCity)
    {
        [self.txtCity resignFirstResponder];
        [self.txtState becomeFirstResponder];
        
    }
    else if (textField==self.txtState)
    {
        [self.txtState resignFirstResponder];
        [self.txtZipcode becomeFirstResponder];
        
    }
    else if (textField==self.txtZipcode)
    {
        [self.txtZipcode resignFirstResponder];
        [self.txtphoneNumber becomeFirstResponder];
    }
    else if (textField==self.txtphoneNumber)
    {
        [textField resignFirstResponder];
        if(IS_IPAD)
        {
            self.scrollview.contentOffset=CGPointMake(0, 0);
            //         self.scrollview.contentSize=CGSizeMake(self.view.frame.size.width, 0);
        }
    }
    else if (textField==txtOTP)
    {
        [txtOTP resignFirstResponder];
        self.scrollview.contentOffset=CGPointMake(0, 0);
    }
    else
    {
        [textField resignFirstResponder];
        //self.scrollview.contentSize=CGSizeMake(self.view.frame.size.width, 0);
    }

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  
    [self.view endEditing:YES];
    [self.txtAddress1 resignFirstResponder];
    [self.txtAddress2 resignFirstResponder];
    [self.txtCity resignFirstResponder];
    [self.txtFirtname resignFirstResponder];
    [self.txtLastname resignFirstResponder];
    [self.txtphoneNumber resignFirstResponder];
    [self.txtState resignFirstResponder];
    [self.txtZipcode resignFirstResponder];
//    tblLocationList.hidden = YES;
    [super touchesBegan:touches withEvent:event];
    // self.scrollview.contentSize=CGSizeMake(self.view.frame.size.width, 0);
}
-(void)hideKeyboard
{
//    [self.txtAddress1 resignFirstResponder];
//    [self.txtAddress2 resignFirstResponder];
//    [self.txtCity resignFirstResponder];
//    [self.txtFirtname resignFirstResponder];
//    [self.txtLastname resignFirstResponder];
//    [self.txtphoneNumber resignFirstResponder];
//    [self.txtState resignFirstResponder];
//    [self.txtZipcode resignFirstResponder];
//     self.scrollview.contentSize=CGSizeMake(self.view.frame.size.width, 0);
//    tblLocationList.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark UIPICKER methods

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label;
    
    if(IS_IPAD)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, pickerView.frame.size.width, 84)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:32];
    }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, pickerView.frame.size.width, 44)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:20];
    }
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    
//    if(self.btnDoneCountryState.tag == 1)
//    {
        label.text = [NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"CountryName"]];
//    }
//    else if(self.btnDoneCountryState.tag == 2)
//    {
//        label.text = [NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"StateName"]];
//    }
    
    if(row == 0)
    {
         [self.btnCountry setTitle:[NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:0] objectForKey:@"CountryName"]] forState:UIControlStateNormal];
    }
    return label;
}
// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
//    if(self.btnDoneCountryState.tag == 1)
//    {
        return [[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] count];
//    }
//    else if(self.btnDoneCountryState.tag == 2)
//    {
//        return [[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0] count];
//    }
    return 0;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"  %@", [[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] objectAtIndex:row]];
}
// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    if(self.btnDoneCountryState.tag == 1)
//    {
        [self.btnCountry setTitle:[NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"CountryName"]] forState:UIControlStateNormal];
        
        countryId = [NSString stringWithFormat:@"%d", row]; //[[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"CountryId"];
//    }
//    else if(self.btnDoneCountryState.tag == 2)
//    {
//        [self.btnState setTitle:[NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"StateName"] ] forState:UIControlStateNormal];
//        
//        stateId = [NSString stringWithFormat:@"%d", row]; //[[[[[Singleton sharedSingleton] arrStateList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"StateID"];
//        
//        
//    }
}


@end
