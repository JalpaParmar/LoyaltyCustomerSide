//
//  ProfileDetailViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "ProfileDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Singleton.h"

#define ACCEPTABLE_CHARECTERS_MOBILE @"0123456789+"

@interface ProfileDetailViewController ()
@end

@implementation ProfileDetailViewController

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
    
//     self.lblTitleProfile.font = FONT_centuryGothic_35;
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    
    self.btnEditProfile.layer.cornerRadius  = 5.0;
    self.btnEditProfile.clipsToBounds = YES;
    
    self.viewAddProfile.layer.cornerRadius  = 5.0;
    self.viewAddProfile.clipsToBounds = YES;
    
    self.viewFilledUpProfile.layer.cornerRadius  = 5.0;
    self.viewFilledUpProfile.clipsToBounds = YES;
    
    self.btnDoneCountryState.layer.cornerRadius  = 5.0;
    self.btnDoneCountryState.clipsToBounds = YES;
      
    self.btnEditProfile.hidden = YES;
    self.viewAddProfile.hidden = YES;
    self.scrollview.hidden = YES;
    self.viewFilledUpProfile.hidden = YES;
    
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        [[UITableView appearanceWhenContainedIn:[UIDatePicker class], nil] setBackgroundColor:nil]; // for iOS 8
    } else {
        [[UITableViewCell appearanceWhenContainedIn:[UIDatePicker class], [UITableView class], nil] setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]]; // for iOS 7
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.scrollview addGestureRecognizer:tapGesture];

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GettingBarcodePhoto) name:@"GettingBarcodePhoto" object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GettingStateList) name:@"GettingStateList" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GettingCountryList) name:@"GettingCountryList" object:nil];
    
    self.btnState.enabled = NO;
    
    //Cancel & Done button for num pad
    UIToolbar *numberToolbar = [[Singleton sharedSingleton] AccessoryButtonsForNumPad:self];
    self.txtContactnumber.inputAccessoryView = numberToolbar;
    self.txtZipCode.inputAccessoryView = numberToolbar;

}
-(void)cancelNumberPad{
    [self.txtContactnumber resignFirstResponder];
    [self.txtZipCode resignFirstResponder];
    self.scrollview.contentOffset=CGPointMake(0, 0);
   // self.txtContactnumber.text = @"";
}

-(void)doneWithNumberPad{
    //NSString *numberFromTheKeyboard = self.txtContactnumber.text;
    [self.txtContactnumber resignFirstResponder];
    [self.txtZipCode resignFirstResponder];
    self.scrollview.contentOffset=CGPointMake(0, 0);
}
-(void)GettingStateList
{
    [self stopActivity];
    self.btnState.enabled = YES;
}
-(void)GettingCountryList
{
    [self stopActivity];
    self.btnDoneCountryState.tag = 1;
    self.pickerCountryState.hidden = NO;
    self.pickerDate.hidden = YES;
    [self.pickerCountryState reloadAllComponents];
    [self.pickerCountryState selectRow:[countryId intValue] inComponent:0 animated:YES];
    [self.btnState setTitle:@"  Select State" forState:UIControlStateNormal];
    stateDBID=@"";
    [self.view addSubview:self.viewCountryState];
}
-(void)GettingBarcodePhoto // : (NSNotification *)notification
{
    NSLog(@"_________ Getting photo n name __________");
    
    [self.btnProfile setBackgroundImage:[[Singleton sharedSingleton] decodeBase64ToImage:[[Singleton sharedSingleton] getstrImgEncoded]] forState:UIControlStateNormal];
    [self.btnProfileforView setBackgroundImage:[[Singleton sharedSingleton] decodeBase64ToImage:[[Singleton sharedSingleton] getstrImgEncoded]] forState:UIControlStateNormal];
    
    if(self.btnProfile.currentBackgroundImage == nil)
    {
        NSLog(@"Null Profile Image");
        [self.btnProfile setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
    }
}
#pragma mark Button Click Event
-(void)getCountryList
{
    if([[[Singleton sharedSingleton] arrCountryList] count] <= 0)
    {
        [self startActivity];
        [[Singleton sharedSingleton] getCountryList];
    }
    else{
       // [self stopActivity];
        self.btnDoneCountryState.tag = 1;
        self.pickerCountryState.hidden = NO;
        self.pickerDate.hidden = YES;
        [self.pickerCountryState reloadAllComponents];
        [self.pickerCountryState selectRow:[countryId intValue] inComponent:0 animated:YES];
        [self.btnState setTitle:@"  Select State" forState:UIControlStateNormal];
        stateDBID=@"";
        [self.view addSubview:self.viewCountryState];
    }
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
                         
                         self.scrollview.hidden = NO;
                         self.viewAddProfile.hidden = NO;
                         self.viewFilledUpProfile.hidden = YES;
                        self.btnEditProfile.hidden = NO;
                         
                         [self.btnEditProfile setTitle:@"Save" forState:UIControlStateNormal];
                         
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

-(void)saveProfileDetail
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
        NSString *firstname = [[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtFirstname.text];
        NSString *lastname = [[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtlastname.text];
        NSString *companyAddress = [[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtCompanyName.text];
        NSString *contactNumber = [[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtContactnumber.text];
        NSString *DOB = [[Singleton sharedSingleton] ISNSSTRINGNULL:strDOB];
        NSString *emailID = [[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtEmailID.text];
        NSString *StreetLine1 = [[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtStreetLine1.text];
        NSString *StreetLine2 = [[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtStreetLine2.text];
        NSString *City = [[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtCity.text];
        NSString *ZipCode = [[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtZipCode.text];
        NSString *photo = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[Singleton sharedSingleton] getstrImgEncoded]];
        NSString *originalname = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[Singleton sharedSingleton] getstrImgFilename]];
        
        //strDOB
       //check birth year -
        NSString *d =  [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL: self.btnDOB.titleLabel.text]];
        
        if(![d isEqualToString:@""])
        {
//            NSString *a = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ConvertMilliSecIntoDate:d]];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            dateFormatter.dateFormat = @"dd MMMM yyyy";
            NSDate *date = [dateFormatter dateFromString:d];
            // add this check and set
            if (date == nil) {
                date = [NSDate date];
            }
            dateFormatter.dateFormat = @"MMM d, yyyy";
            [self.pickerDate setDate:date];
        }
        
        NSDate *selectedDate=[self.pickerDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];//yyyy-MM-dd
        NSString *selectedYear = [NSString stringWithFormat:@"%@", [formatter stringFromDate:selectedDate]];
        NSString *CurrentYear = [NSString stringWithFormat:@"%@", [formatter stringFromDate:[NSDate date]]];
        int age = [CurrentYear intValue] - [selectedYear intValue];
        NSLog(@"Current Agr : %d", age);
        
            
        if([firstname isEqualToString:@""] || [lastname isEqualToString:@""] || [companyAddress isEqualToString:@""] || [contactNumber isEqualToString:@""] || [DOB isEqualToString:@""] || [emailID isEqualToString:@""]|| [StreetLine1 isEqualToString:@""]|| [StreetLine2 isEqualToString:@""]|| [City isEqualToString:@""]|| [ZipCode isEqualToString:@""] || [stateDBID isEqualToString:@""] || [countryDBID isEqualToString:@""])
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_EMPTY_DATA message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else if( [photo isEqualToString:@""] || [originalname isEqualToString:@""])
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Photo is required." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else if(![[Singleton sharedSingleton] validateEmailWithString:emailID])
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Please Enter Correct Email ID" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else if(age < 10)
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Minimum age should be 10 years" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else if(contactNumber.length < 4)
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Mobile length should be atleast 4 or more" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else if(ZipCode.length <= 3)
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Zipcode length should be atleast 3 or more" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
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
            [dict setValue:contactNumber forKey:@"MobileNo"];
            [dict setValue:DOB forKey:@"DOB"];
            [dict setValue:emailID forKey:@"EMail"];
            [dict setValue:companyAddress forKey:@"StoreName"];
            [dict setValue:StreetLine1 forKey:@"StreetLine1"];
            [dict setValue:StreetLine2 forKey:@"StreetLine2"];
            [dict setValue:City forKey:@"City"];
            [dict setValue:ZipCode forKey:@"ZipCode"];
            [dict setValue:stateDBID forKey:@"State"];
            [dict setValue:countryDBID forKey:@"Country"];
            [dict setValue:photo forKey:@"Photo"];
            [dict setValue:originalname forKey:@"OriginalName"];
            
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 NSLog(@"Add Profile Data - - %@ -- ", dict);
                 
                 if (dict)
                 {
                     Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                     if (!strCode)
                     {
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
                                 UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                 [alt show];
                                 
                             [arrProfileData removeAllObjects];
                             [arrProfileData addObject:[dict objectForKey:@"data"]];
                                 
                            [[Singleton sharedSingleton] setarrProfileDetail:[dict objectForKey:@"data"]];
                              self.txtEmailID.enabled = YES;
                              self.backEditButton.backgroundColor = [UIColor clearColor];
                             [self ViewFilledUpProfileData];
                            
                             }
                         }
                     }
                    
                     [self stopActivity];
                 }
                 else
                 {
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     [self stopActivity];
                 }
             } :@"Login/EditProfile" data:dict];

        }
    }
}
-(void)ViewFilledUpProfileData
{
    self.scrollview.hidden = YES;
    self.viewAddProfile.hidden = YES;
    self.viewFilledUpProfile.hidden = NO;
    
    if([arrProfileData count] > 0)
    {
        if([[[arrProfileData objectAtIndex:0] objectAtIndex:0] count] > 0)
        {
            [self setImageFromPath];
            
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
            
            self.lblCompanyname.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"StoreName"]]];
            
            self.lblContactNumber.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"MobileNo"]]];
            
            
            NSString *d =  [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL: [[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"DOB"]]];
            if(![d isEqualToString:@""])
            {
                self.lblDOB.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ConvertMilliSecIntoDate:d]];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd MMMM yyyy"];
                NSDate *date = [formatter dateFromString:self.lblDOB.text];
                
                [formatter setDateFormat:@"MM-dd-yyyy"];
                strDOB = [formatter stringFromDate:date];
            }
            else
            {
                self.lblDOB.text = d;
            }
            
            self.lblEmailID.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"EMail"]]];
            
            self.lblFullname.text = [NSString stringWithFormat:@"%@ %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"FirstName"]], [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"LastName"]]];
            
            NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"UfId"]);
            NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userEMail"]);
            
            lblCustomerId.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"UfId"]];
            
            f = viewCustomerQRCode.frame;
            if(IS_IPAD)
            {
                f.origin.y = self.lblAddress.frame.origin.y + self.lblAddress.frame.size.height + 10;
            }
            else
            {
                 f.origin.y = self.lblAddress.frame.origin.y + self.lblAddress.frame.size.height + 8;
            }
            viewCustomerQRCode.frame = f;
     
            f = self.viewFilledUpProfile.frame;
            if(IS_IPAD)
            {
            f.size.height = viewCustomerQRCode.frame.origin.y + viewCustomerQRCode.frame.size.height + 20;
            }
            else
            {
            f.size.height = viewCustomerQRCode.frame.origin.y + viewCustomerQRCode.frame.size.height + 10;
            }                
            self.viewFilledUpProfile.frame = f;
            
            self.btnEditProfile.hidden = NO;
            [self.btnEditProfile setTitle:@"Edit" forState:UIControlStateNormal];
             f = self.btnEditProfile.frame;
            f.origin.y = self.viewFilledUpProfile.frame.origin.y + self.viewFilledUpProfile.frame.size.height + 10;
            self.btnEditProfile.frame = f;            
                        
        }
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
                    
                    [self.btnProfile setBackgroundImage:image forState:UIControlStateNormal];
                    
                    [self.btnProfileforView setBackgroundImage:image forState:UIControlStateNormal];
                    
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
                        
                        [self.btnProfile setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
                        
                        
                        
                        [self.btnProfileforView setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
                        
                    }
                    
                    else{
                        
                        [self.btnProfile setBackgroundImage:image forState:UIControlStateNormal];
                        
                        
                        
                        [self.btnProfileforView setBackgroundImage:image forState:UIControlStateNormal];
                        
                        
                        
                        [[Singleton sharedSingleton] setstrImgEncoded:[[Singleton sharedSingleton] encodeToBase64String:image]];
                        
                        
                        
                        [[Singleton sharedSingleton] setstrImgFilename: [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"OriginalName"]]];
                        
                    }
                });
                
            }
            
            
            
        });
    }
    
    
    //set QR Code
    dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.myCompanyName.imagegrabber.bgqueue", NULL);
    dispatch_async(backgroundQueue, ^(void) {
        
        // QRCode Image
        NSString *imageName = [NSString stringWithFormat:@"https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=%@&choe=UTF-8", [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            if(image == nil)
            {
                [imgQRCode setImage:[UIImage imageNamed:@"defaultImage.png"]];
            }
            else
            {
                [imgQRCode setImage:image];
            }
        });
        
    });

    
}
- (IBAction)btnEditProfileClicked:(id)sender
{
    if([self.btnEditProfile.titleLabel.text isEqualToString:@"Edit"])
    {
        self.viewFilledUpProfile.hidden = YES;
        self.viewAddProfile.hidden = NO;
        self.scrollview.hidden = NO;
        
        self.btnEditProfile.hidden = NO;
        [self.btnEditProfile setTitle:@"Save" forState:UIControlStateNormal];
        CGRect f = self.btnEditProfile.frame;
        f.origin.y = self.scrollview.frame.origin.y + self.scrollview.frame.size.height + 10;
        self.btnEditProfile.frame = f;
        
        NSString *fname = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"FirstName"]]];
        
        NSString *lname = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"LastName"]]];
        
        NSString *email = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"EMail"]]];
        
      
        
       NSString *DOB = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"DOB"]]];
        
        NSString *StoreName = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"StoreName"]]];

          NSString *number = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"MobileNo"]]];
        
        NSString *StreetLine1 = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"StreetLine1"]]];

        NSString *StreetLine2 = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"StreetLine2"]]];

        NSString *City = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"City"]]];
        
        NSString *ZipCode = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"ZipCode"]]];

       

        NSString *cName_ = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"CountryName"]]];

        NSString *sName_ = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"StateName"]]];

        NSString *OriginalName = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"OriginalName"]]];

        if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:OriginalName] isEqualToString:@""])
        {
            [[Singleton sharedSingleton] setstrImgFilename:OriginalName];
        }
        
         [self performSelector:@selector(setImageFromPath) withObject:nil afterDelay:2.0];

        if(![fname isEqualToString:@""])
        {
            self.txtFirstname.text =   fname;
        }
        if(![lname isEqualToString:@""])
        {
            self.txtlastname.text = lname;
        }
        if(![email isEqualToString:@""])
        {
            self.txtEmailID.text = email;
            self.txtEmailID.enabled = NO;
            self.backEditButton.backgroundColor = [UIColor lightGrayColor];
        }
        if(![number isEqualToString:@""])
        {
            self.txtContactnumber.text = number;
        }
        if(![StoreName isEqualToString:@""])
        {
            self.txtCompanyName.text = StoreName;
        }
        if(![DOB isEqualToString:@""])
        {
            [self.btnDOB setTitle:[NSString stringWithFormat:@"  %@", [[Singleton sharedSingleton] ConvertMilliSecIntoDate:DOB]] forState:UIControlStateNormal] ;
        }
        if(![StreetLine1 isEqualToString:@""])
        {
            self.txtStreetLine1.text = StreetLine1;
        }
        if(![StreetLine2 isEqualToString:@""])
        {
            self.txtStreetLine2.text = StreetLine2;
        }
        if(![City isEqualToString:@""])
        {
            self.txtCity.text = City;
        }
        if(![ZipCode isEqualToString:@""])
        {
            self.txtZipCode.text = ZipCode;
        }
        if(![cName_ isEqualToString:@""])
        {
            [self.btnCountry setTitle:[NSString stringWithFormat:@"  %@", cName_] forState:UIControlStateNormal];
        }
        if(![sName_ isEqualToString:@""])
        {
            self.btnState.enabled = YES;
            [self.btnState setTitle:[NSString stringWithFormat:@"  %@", sName_] forState:UIControlStateNormal];
            self.btnState.enabled = NO;
        }
    }
    else  if([self.btnEditProfile.titleLabel.text isEqualToString:@"Save"])
    {
        [self saveProfileDetail];
    }
}
- (IBAction)btnProfilePicClicked:(id)sender
{
    [[Singleton sharedSingleton] CameraClicked:self.view Control:self.btnProfile];
}
- (IBAction)btnCountryClicked:(id)sender
{
//    [self performSelectorInBackground:@selector(getCountryList) withObject:nil];
  
    [self getCountryList];
}
- (IBAction)btnStateClicked:(id)sender
{
    self.btnDoneCountryState.tag = 2;
    self.pickerCountryState.hidden = NO;
    self.pickerDate.hidden = YES;
    [self.pickerCountryState reloadAllComponents];
    if([self.btnState.titleLabel.text isEqualToString:@"  Select State"])
    {
         [self.pickerCountryState selectRow:0 inComponent:0 animated:YES];
    }
    else
    {
         [self.pickerCountryState selectRow:[stateId intValue] inComponent:0 animated:YES];
    }   
    [self.view addSubview:self.viewCountryState];
}
- (IBAction)btnDOBClicked:(id)sender
{
    self.btnDoneCountryState.tag = 3;
    self.pickerCountryState.hidden = YES;
    self.pickerDate.hidden = NO;
    self.pickerDate.maximumDate = [NSDate date];
    
    if([arrProfileData count] > 0)
    {
        if([[arrProfileData objectAtIndex:0] count] > 0)
        {
//            NSString *d =  [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL: [[[arrProfileData objectAtIndex:0] objectAtIndex:0] objectForKey:@"DOB"]]];
            
            NSString *d =  [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL: self.btnDOB.titleLabel.text]];
            
            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:d] isEqualToString:@""] && ![d isEqualToString:@"Select DOB"])
            {
//                NSString *a = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ConvertMilliSecIntoDate:d]];
            
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                dateFormatter.dateFormat = @"dd MMMM yyyy";
//                NSDate *date = [dateFormatter dateFromString:a];
                 NSDate *date = [dateFormatter dateFromString:self.btnDOB.titleLabel.text];
                // add this check and set
                if (date == nil) {
                    date = [NSDate date];
                }
                dateFormatter.dateFormat = @"MMM d, yyyy";
                [self.pickerDate setDate:date];
            }
        }
    }
   
  [self.view addSubview:self.viewCountryState];
}

-(void)removeViewOfCountryState
{
    [self.viewCountryState removeFromSuperview];
    
}
- (IBAction)btnDoneCountryStateClicked:(id)sender
{
    [self performSelector:@selector(removeViewOfCountryState) withObject:nil afterDelay:0.2];
    
    UIButton *btn = (UIButton*)sender;
    if(btn.tag == 1)
    {
        //country
        NSLog(@"Selected Country index---- %@", countryId);
        
        [self.btnCountry setTitle:[NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:[countryId intValue]] objectForKey:@"CountryName"]] forState:UIControlStateNormal];
        
        // cId - is Country id in DB
        // Country id - is local varible contain index of array
        
        countryDBID = [NSString stringWithFormat:@" %@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:[countryId intValue]] objectForKey:@"CountryId"]];
        
        self.btnState.enabled = NO;
        
        [self startActivity];
//        if([[[Singleton sharedSingleton] arrStateList] count] <= 0)
//        {
            [[Singleton sharedSingleton] getStateList: countryDBID];
//        }
       // [self stopActivity];
    }
    else if(btn.tag == 2)
    {
        //state
        NSLog(@"Selected State index---- %@", stateId);
        [self.btnState setTitle:[NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0]objectAtIndex:[stateId intValue]] objectForKey:@"StateName"] ] forState:UIControlStateNormal];
        stateDBID = [NSString stringWithFormat:@" %@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0]objectAtIndex:[stateId intValue]] objectForKey:@"StateID"] ];
     }
    else if(btn.tag == 3)
    {
        // date Picker
        NSDate *date=[self.pickerDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd MMMM yyyy"];//yyyy-MM-dd
        [self.btnDOB setTitle:[NSString stringWithFormat:@"  %@",[formatter stringFromDate:date]] forState:UIControlStateNormal];
        [formatter setDateFormat:@"MM-dd-yyyy"];
        strDOB = [formatter stringFromDate:date];
        NSLog(@" Selected Date : %@", self.btnDOB.titleLabel.text);
    }
}

- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TextField Delegate
- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString: (NSString *)string
{
    //return yes or no after comparing the characters
    
    
    // allow backspace
    if (!string.length)
    {
        return YES;
    }
    
    if(theTextField == self.txtZipCode)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS_ZIPCODE] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else if(theTextField == self.txtContactnumber)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS_MOBILE] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField==self.txtFirstname)
    {
        [self.txtFirstname resignFirstResponder];
        [self.txtlastname becomeFirstResponder];
    }
    else if (textField==self.txtlastname)
    {
        [self.txtlastname resignFirstResponder];
        [self.txtContactnumber becomeFirstResponder];
    }
    else if (textField==self.txtContactnumber)
    {
        [self.txtContactnumber resignFirstResponder];
        [self.txtCompanyName becomeFirstResponder];
       // [self.txtDOB becomeFirstResponder];
    }
//    else if (textField==self.txtDOB)
//    {
//        [self.txtDOB resignFirstResponder];
//        [self.txtCompanyName becomeFirstResponder];
//        //        self.MYID_ADD_scrollview.contentOffset=CGPointMake(0, 40);
//    }
    else if (textField==self.txtCompanyName)
    {
        [self.txtCompanyName resignFirstResponder];
        [self.txtEmailID becomeFirstResponder];
        //        self.MYID_ADD_scrollview.contentOffset=CGPointMake(0, 90);
    }
    else if (textField==self.self.txtEmailID)
    {
        [self.txtEmailID resignFirstResponder];
        [self.txtStreetLine1 becomeFirstResponder];
        //        self.MYID_ADD_scrollview.contentOffset=CGPointMake(0, 90);
    }
    else if (textField==self.txtStreetLine1)
    {
        [self.txtStreetLine1 resignFirstResponder];
        [self.txtStreetLine2 becomeFirstResponder];
        self.scrollview.contentOffset=CGPointMake(0, 10);
    }
    else if (textField==self.txtStreetLine2)
    {
        [self.txtStreetLine2 resignFirstResponder];
        [self.txtCity becomeFirstResponder];
        self.scrollview.contentOffset=CGPointMake(0, 50);
    }
    else if (textField==self.txtCity)
    {
        [self.txtCity resignFirstResponder];
        [self.txtZipCode becomeFirstResponder];
        self.scrollview.contentOffset=CGPointMake(0, 50);
    }
    else if (textField==self.txtZipCode)
    {
        [self.txtZipCode resignFirstResponder];
        self.scrollview.contentOffset=CGPointMake(0, 0);
    }
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(!IS_IPAD)
    {
        if(textField == self.txtStreetLine1)
        {
            self.scrollview.contentOffset=CGPointMake(0, 10);
        }
        else if(textField == self.txtStreetLine2)
        {
            self.scrollview.contentOffset=CGPointMake(0, 10);
        }
        else if(textField == self.txtCity)
        {
            self.scrollview.contentOffset=CGPointMake(0, 50);
        }
        else if(textField == self.txtZipCode)
        {
            self.scrollview.contentOffset=CGPointMake(0, 50);
        }
    }
    
    return YES;
}
-(void)hideKeyboard
{
//    CGRect f = self.tblviewICE.frame;
//    f.size.height = 120;
//    self.tblviewICE.frame = f;
    
    [self.txtCity resignFirstResponder];
    [self.txtCompanyName resignFirstResponder];
    [self.txtContactnumber resignFirstResponder];
   // [self.txtDOB resignFirstResponder];
    [self.txtEmailID resignFirstResponder];
    [self.txtFirstname resignFirstResponder];
    [self.txtlastname resignFirstResponder];
    [self.txtStreetLine1 resignFirstResponder];
    [self.txtStreetLine2 resignFirstResponder];
    [self.txtZipCode resignFirstResponder];
    
    self.scrollview.contentOffset=CGPointMake(0, 0);
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    self.scrollview.contentOffset=CGPointMake(0, 0);
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
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
    
    if(self.btnDoneCountryState.tag == 1)
    {
        label.text = [NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"CountryName"]];
    }
    else if(self.btnDoneCountryState.tag == 2)
    {
        label.text = [NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"StateName"]];
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
    if(self.btnDoneCountryState.tag == 1)
    {
        return [[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] count];
    }
    else if(self.btnDoneCountryState.tag == 2)
    {
        return [[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0] count];
    }
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
    if(self.btnDoneCountryState.tag == 1)
    {
        [self.btnCountry setTitle:[NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"CountryName"]] forState:UIControlStateNormal];
        
        countryId = [NSString stringWithFormat:@"%ld", (long)row]; //[[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"CountryId"];
    }
    else if(self.btnDoneCountryState.tag == 2)
    {
        [self.btnState setTitle:[NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"StateName"] ] forState:UIControlStateNormal];
        
        stateId = [NSString stringWithFormat:@"%d", row]; //[[[[[Singleton sharedSingleton] arrStateList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"StateID"];
        
    
    }
}

-(void)viewdid:(BOOL)animated
{
   // [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
