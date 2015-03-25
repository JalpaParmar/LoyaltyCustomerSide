//
//  ICEInfoViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 8/13/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "ICEInfoViewController.h"
#import "ICEcell.h"
#import "Singleton.h"
#import "ProfileDetailViewController.h"



@interface ICEInfoViewController ()
@end

#define NORMALBGCOLOR [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]
#define SELECTEDBGCOLOR [UIColor colorWithRed:80.0/255.0 green:190.0/255.0 blue:15.0/255.0 alpha:1]

@implementation ICEInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        if([[[Singleton sharedSingleton] arrCountryList] count] <= 0)
//        {
//            [[Singleton sharedSingleton] performSelectorInBackground:
//             @selector(getCountryList) withObject:nil];
//            // [[Singleton sharedSingleton] getCountryList];
//        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.flagForID =1;
    countryID=@"";
    stateID=@"";
    
    app = APP;
    [self.view addSubview:[app setFooterPart]];
    app._flagMainBtn = 3;
    
//    self.lblTitleMyCard.font = FONT_centuryGothic_35;
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    arrBloodType = [[NSArray alloc] initWithObjects:@"O+", @"O-", @"A+",@"A-",@"B+",@"B-",@"AB+",@"AB-",nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GettingBarcodePhoto) name:@"GettingBarcodePhoto" object:nil];

    [self.view addSubview:[app setMyLoyaltyTopPart]];
    app._flagMyLoyaltyTopButtons = 2;

    self.picker_DOB.maximumDate = [NSDate date];
    self.picker_DOB.datePickerMode = UIDatePickerModeDate;
//    if(IS_IOS_8)
//    {
//        [[UITableView appearanceWhenContainedIn:[UIDatePicker class], nil] setBackgroundColor:nil]; // for iOS 8
//    }
    
    
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        [[UITableView appearanceWhenContainedIn:[UIDatePicker class], nil] setBackgroundColor:nil]; // for iOS 8
    } else {
        [[UITableViewCell appearanceWhenContainedIn:[UIDatePicker class], [UITableView class], nil] setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]]; // for iOS 7
    }
    
    
    self.tblviewICE.tableFooterView = [[UIView alloc] init];
    
    self.btnAddEdit.layer.cornerRadius = 5.0;
    self.btnAddEdit.clipsToBounds = YES;
    
    self.btnSave.layer.cornerRadius = 5.0;
    self.btnSave.clipsToBounds = YES;
   
    self.btnICESave.layer.cornerRadius = 5.0;
    self.btnICESave.clipsToBounds = YES;
   
    self.btnICECancel.layer.cornerRadius = 5.0;
    self.btnICECancel.clipsToBounds = YES;
    
    self.btnICEMeditcationSave.layer.cornerRadius = 5.0;
    self.btnICEMeditcationSave.clipsToBounds = YES;
    
    self.btnICEMeditcationCancel.layer.cornerRadius = 5.0;
    self.btnICEMeditcationCancel.clipsToBounds = YES;
    
    self.btnViewMyId.layer.cornerRadius = 5.0;
    self.btnViewMyId.clipsToBounds = YES;
    
    self.viewDetail.layer.cornerRadius = 5.0;
    self.viewDetail.clipsToBounds = YES;
    
    self.viewAddEditDetail.layer.cornerRadius = 5.0;
    self.viewAddEditDetail.clipsToBounds = YES;
    
    self.viewCompanyIDDetail.layer.cornerRadius = 5.0;
    self.viewCompanyIDDetail.clipsToBounds = YES;
    
    self.subviewICEMeditcationAddEdit.layer.cornerRadius = 5.0;
    self.subviewICEMeditcationAddEdit.clipsToBounds = YES;
    
    self.viewICEMeditcationDetail.layer.cornerRadius = 5.0;
    self.viewICEMeditcationDetail.clipsToBounds = YES;
    
    self.subviewICEMedicaiton.layer.cornerRadius = 5.0;
    self.subviewICEMedicaiton.clipsToBounds = YES;
    
    self.btnCountryDone.layer.cornerRadius = 5.0;
    self.btnCountryDone.clipsToBounds = YES;
    
    self.btnDoneDOB.layer.cornerRadius = 5.0;
    self.btnDoneDOB.clipsToBounds = YES;
   
    self.COMPANY_txtAddress.text = @"Address";
    self.COMPANY_txtAddress.textColor = [UIColor lightGrayColor];
    self.COMPANY_txtAddress.delegate = self;
    
    
    //Top 3 buttons
    [self.viewMyIDCard setBackgroundColor:SELECTEDBGCOLOR];
    [self.viewCompanyID setBackgroundColor:NORMALBGCOLOR];
    [self.viewICEID setBackgroundColor:NORMALBGCOLOR];
    
    // First Only Add Id Info button display. After enter data it shows view detail
    
    self.btnSave.hidden =YES;
    self.btnViewMyId.hidden  =YES;
    self.btnAddEdit.hidden = YES;
    
    [self btnMyIDClicked:nil];
    
//    self.viewDetail.hidden = YES;
//    CGRect f = self.btnAddEdit.frame;
//    f.origin.y = self.viewMyIDCard.frame.origin.y + self.viewMyIDCard.frame.size.height + 10;
//    self.btnAddEdit.frame = f;
//    [self.btnAddEdit setTitle:@"Add ID Info" forState:UIControlStateNormal];
//    
//     self.flagForID = 1;
//    self.viewDetail.hidden = YES;
//    self.viewAddEditDetail.hidden=YES;
//    self.viewCompanyIDDetail.hidden = YES;
//    self.viewCompanyAddEditDetail.hidden = YES;
//    self.viewICEDetail.hidden = YES;
//    
//    self.btnViewMyId.hidden = YES;
//    self.btnSave.hidden = YES;
    
    [self setSelectedGenderButton:self.MYID_ADD_btnMale];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.MYID_ADD_scrollview addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GettingCountryList) name:@"GettingCountryList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GettingStateList) name:@"GettingStateList" object:nil];
    self.MYID_ADD_btnState.enabled = NO;

    
    //Cancel & Done button for num pad
    UIToolbar *numberToolbar = [[Singleton sharedSingleton] AccessoryButtonsForNumPad:self];
    self.MYID_ADD_txtPhoneno.inputAccessoryView = numberToolbar;
    self.ICECONTACT_phoneno.inputAccessoryView = numberToolbar;
    self.COMPANY_txtPhoneNo.inputAccessoryView = numberToolbar;
    self.COMPANY_txtPostalCode.inputAccessoryView = numberToolbar;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)cancelNumberPad{
    
    [self.MYID_ADD_txtPhoneno resignFirstResponder];
    [self.ICECONTACT_phoneno resignFirstResponder];
     [self.COMPANY_txtPhoneNo resignFirstResponder];
     [self.COMPANY_txtPostalCode resignFirstResponder];
  
    self.MYID_ADD_scrollview.contentOffset=CGPointMake(0, 0);
   
}

-(void)doneWithNumberPad{
    //NSString *numberFromTheKeyboard = self.txtContactnumber.text;
    [self.MYID_ADD_txtPhoneno resignFirstResponder];
    [self.ICECONTACT_phoneno resignFirstResponder];
    [self.COMPANY_txtPhoneNo resignFirstResponder];
    [self.COMPANY_txtPostalCode resignFirstResponder];
    
    self.MYID_ADD_scrollview.contentOffset=CGPointMake(0, 0);
}
-(void)GettingCountryList
{
    [self stopActivity];
    if([[[Singleton sharedSingleton] getarrCountryList] count] > 0)
    {
        self.MYID_ADD_btnCountry.enabled = YES;
        [self selectCountryAfterLoad];
    }
    else
    {
        self.MYID_ADD_btnCountry.enabled = NO;
    }
}
-(void)GettingStateList
{
    [self stopActivity];
    if([[[Singleton sharedSingleton] getarrStateList] count] > 0)
    {
        self.MYID_ADD_btnState.enabled = YES;
    }
    else
    {
        self.MYID_ADD_btnState.enabled = NO;
    }
    
}
-(void)GettingBarcodePhoto // : (NSNotification *)notification
{
    NSLog(@"_________ Getting photo n name __________");
    
    [self.COMPANY_btnCompanyLogo setBackgroundImage:[[Singleton sharedSingleton] decodeBase64ToImage:[[Singleton sharedSingleton] getstrImgEncoded]] forState:UIControlStateNormal];
    self.COMPANY_lblTakePhoto.hidden= YES;
    if(self.COMPANY_btnCompanyLogo.currentBackgroundImage == nil)
    {
        NSLog(@"Null barcode Image");
        self.COMPANY_lblTakePhoto.hidden= NO;
        [self.COMPANY_btnCompanyLogo  setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
    }
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Button Click Event

- (IBAction)btnbackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark TOP 3 TAB BUTTONS

- (IBAction)btnMyIDClicked:(id)sender
{
    pickerBloodType.hidden = YES;
    self.picker_DOB.hidden = YES;
    self.pickerCountry.hidden =YES;
    self.pickerCountryIpad.hidden = YES;

    [self.view endEditing:YES];
    
    if([[[Singleton sharedSingleton] getarrICEIDCardDetail] count] > 0)
    {
        arrICEIDCardDetail = [[NSMutableArray alloc] init];
        
         [arrICEIDCardDetail addObject:[[Singleton sharedSingleton] getarrICEIDCardDetail]  ];
    }
    
    if([[[Singleton sharedSingleton] getarrICEIDCardDetail] count] <= 0 && [[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"IdName"]] isEqualToString:@""])
    {
            NSLog(@"1 :--- %d", [[[Singleton sharedSingleton] getarrICEIDCardDetail] count]);
        
            NSLog(@"2 : ---- %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"IdName"]]);
        
        self.flagForID =1;
        [self.viewMyIDCard setBackgroundColor:SELECTEDBGCOLOR];
        [self.viewCompanyID setBackgroundColor:NORMALBGCOLOR];
        [self.viewICEID setBackgroundColor:NORMALBGCOLOR];
        
        self.viewDetail.hidden = YES;
        self.viewAddEditDetail.hidden = YES;
        
        [self getMYIDCardDetail];
        
    }
    else  if([[[Singleton sharedSingleton] getarrICEIDCardDetail] count] > 0 && [[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"IdName"]] isEqualToString:@""])
    {
        NSLog(@"1 :--- %d", [[[Singleton sharedSingleton] getarrICEIDCardDetail] count]);
        
        NSLog(@"2 : ---- %@",[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"IdName"]]);
        
        self.flagForID =1;
        [self.viewMyIDCard setBackgroundColor:SELECTEDBGCOLOR];
        [self.viewCompanyID setBackgroundColor:NORMALBGCOLOR];
        [self.viewICEID setBackgroundColor:NORMALBGCOLOR];
        
        self.viewDetail.hidden = YES;
        self.viewAddEditDetail.hidden = YES;
        
        [self getMYIDCardDetail];
    }
    else
    {
        self.flagForID =1;
        [self.viewMyIDCard setBackgroundColor:SELECTEDBGCOLOR];
        [self.viewCompanyID setBackgroundColor:NORMALBGCOLOR];
        [self.viewICEID setBackgroundColor:NORMALBGCOLOR];
       
//        arrICEIDCardDetail = [[NSMutableArray alloc] init];
//    
//        if([[[Singleton sharedSingleton] getarrICEIDCardDetail] count] > 0)
//        {
//            if([[[Singleton sharedSingleton] getarrICEIDCardDetail] count] > 0)
//            {
//                [arrICEIDCardDetail addObject:[[Singleton sharedSingleton] getarrICEIDCardDetail]  ];
//            }
//        }
        //[arrICEIDCardDetail addObject:[[Singleton sharedSingleton] getarrICEIDCardDetail]];
        
        [self displayMYIDCardDetailView];
    }
    //fistTime_id = 1;
}

- (IBAction)btnCompanyIDCliked:(id)sender
{
    pickerBloodType.hidden = YES;
    self.picker_DOB.hidden = YES;
    self.pickerCountry.hidden =YES;
    self.pickerCountryIpad.hidden = YES;

    [self.view endEditing:YES];
    
    if([[[Singleton sharedSingleton] getarrCompanyDetail] count] > 0)
    {
        arrCompanyDetail = [[NSMutableArray alloc] init];
        [arrCompanyDetail addObject:[[Singleton sharedSingleton] getarrCompanyDetail]];
    }
    
    if([[[Singleton sharedSingleton] getarrCompanyDetail] count] <= 0 &&  [[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail objectAtIndex:0] objectForKey:@"IDNumber"]] isEqualToString:@""])
      {
        self.flagForID = 2;
        [self.viewMyIDCard setBackgroundColor:NORMALBGCOLOR];
        [self.viewCompanyID setBackgroundColor:SELECTEDBGCOLOR];
        [self.viewICEID setBackgroundColor:NORMALBGCOLOR];
        
        self.viewDetail.hidden = YES;
        self.viewAddEditDetail.hidden = YES;
        self.viewCompanyIDDetail.hidden = YES;
        self.viewCompanyAddEditDetail.hidden = YES;
        
        self.btnAddEdit.hidden = YES;
        [self getCompanyDetail];
        
    }
    else if([[[Singleton sharedSingleton] getarrCompanyDetail] count] > 0 &&  [[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail objectAtIndex:0] objectForKey:@"IDNumber"]] isEqualToString:@""])
    {
        self.flagForID = 2;
        [self.viewMyIDCard setBackgroundColor:NORMALBGCOLOR];
        [self.viewCompanyID setBackgroundColor:SELECTEDBGCOLOR];
        [self.viewICEID setBackgroundColor:NORMALBGCOLOR];
        
        self.viewDetail.hidden = YES;
        self.viewAddEditDetail.hidden = YES;
        self.viewCompanyIDDetail.hidden = YES;
        self.viewCompanyAddEditDetail.hidden = YES;
        
        self.btnAddEdit.hidden = YES;
        [self getCompanyDetail];
        
    }
    else
    {
        self.flagForID =2;
        [self.viewMyIDCard setBackgroundColor:NORMALBGCOLOR];
        [self.viewCompanyID setBackgroundColor:SELECTEDBGCOLOR];
        [self.viewICEID setBackgroundColor:NORMALBGCOLOR];
     
        self.viewDetail.hidden = YES;
        self.viewAddEditDetail.hidden=YES;
        self.viewCompanyIDDetail.hidden = NO;
        self.viewCompanyAddEditDetail.hidden = YES;
         self.viewICEDetail.hidden = YES;
         self.viewICEMeditcationDetail.hidden = YES;
        
        self.btnViewMyId.hidden = YES;
        self.btnSave.hidden = YES;
        self.btnAddEdit.hidden = NO;
        CGRect f = self.btnAddEdit.frame;
        f.origin.y = self.viewCompanyIDDetail.frame.origin.y + self.viewCompanyIDDetail.frame.size.height + 10;
        self.btnAddEdit.frame = f;
        [self.btnAddEdit setTitle:@"Edit ID Info" forState:UIControlStateNormal];

        [self displayCompanyDetailView];
        
    }
}

- (IBAction)btnICEIDClicked:(id)sender {
   
    pickerBloodType.hidden = YES;
    self.picker_DOB.hidden = YES;
    self.pickerCountry.hidden =YES;
    self.pickerCountryIpad.hidden = YES;

    [self.view endEditing:YES];
    
    
    self.flagForID = 3;
    [self.viewMyIDCard setBackgroundColor:NORMALBGCOLOR];
    [self.viewCompanyID setBackgroundColor:NORMALBGCOLOR];
    [self.viewICEID setBackgroundColor:SELECTEDBGCOLOR];
  
    self.viewAddEditDetail.hidden = YES;
    self.viewDetail.hidden = YES;
    self.viewAddEditDetail.hidden = YES;
    self.viewCompanyIDDetail.hidden = YES;
    self.viewCompanyAddEditDetail.hidden = YES;
    self.viewICEDetail.hidden = NO;
    self.viewICEMeditcationDetail.hidden = YES;
    
    self.btnViewMyId.hidden = YES;
    self.btnSave.hidden = YES;
    self.btnAddEdit.hidden = YES;
    
    [self.btnSave setTitle:@"Add Contact" forState:UIControlStateNormal];
    [self.btnViewMyId setTitle:@"View ICE Card" forState:UIControlStateNormal];
    
    if([[[Singleton sharedSingleton] getarrICEContactDetail] count] > 0)
    {
        arrICEContactDetail = [[NSMutableArray alloc] init];
        [arrICEContactDetail addObject:[[Singleton sharedSingleton] getarrICEContactDetail]];
    }
    
    if([[[Singleton sharedSingleton] arrICEContactDetail] count] > 0)
    {
//        arrICEContactDetail = [[NSMutableArray alloc] init];
//        [arrICEContactDetail addObject:[[Singleton sharedSingleton] getarrICEContactDetail]];
        self.tblviewICE.hidden = NO;
        [self.tblviewICE reloadData];
        
        self.btnViewMyId.hidden = NO;
        self.btnSave.hidden = NO;
        
        CGRect f = self.btnSave.frame;
        f.origin.x = self.viewICEDetail.frame.origin.x + 10;
        f.origin.y = self.viewICEDetail.frame.origin.y + self.viewICEDetail.frame.size.height + 5;
        self.btnSave.frame = f;
        
        f = self.btnViewMyId.frame;
        f.origin.x = self.btnSave.frame.origin.x + self.btnSave.frame.size.width +5 ;
        f.origin.y = self.viewICEDetail.frame.origin.y + self.viewICEDetail.frame.size.height +5 ;
        self.btnViewMyId.frame = f;
    }
    else
    {
        [self getICEContactDetail];
    }
}

#pragma mark COMMON SAVE/ADD/VIEW BUTTONS

- (IBAction)btnAddEditClicked:(id)sender {
    
    pickerBloodType.hidden = YES;
    self.picker_DOB.hidden = YES;
    self.pickerCountry.hidden =YES;
    self.pickerCountryIpad.hidden = YES;

    [self.view endEditing:YES];
    
    if(self.flagForID == 1)
    {
        // My ID Card
        
//        if([[[Singleton sharedSingleton] arrCountryList] count] <= 0)
//        {
//            [[Singleton sharedSingleton] getCountryList];
//        }
//      
        self.btnAddEdit.hidden = YES;
        self.btnSave.hidden = NO;
        if([[[Singleton sharedSingleton] arrICEIDCardDetail] count] > 0)
        {
            self.btnViewMyId.hidden = NO;
        }
        
        self.viewDetail.hidden=YES;
        self.viewAddEditDetail.hidden= NO;
        self.viewCompanyIDDetail.hidden = YES;
        self.viewCompanyAddEditDetail.hidden = YES;
        
        [self.btnSave setTitle:@"Save" forState:UIControlStateNormal];
        [self.btnViewMyId setTitle:@"View ID Card" forState:UIControlStateNormal];
    
        if([arrICEIDCardDetail count] > 0)
        {
            if([[arrICEIDCardDetail objectAtIndex:0] count] > 0)
            {
                
                if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail  objectAtIndex:0] objectForKey:@"Photo"]] isEqualToString:@""])
                {
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
                    dispatch_async(queue, ^{
                        NSData *imageData;
                        UIImage *image;
                        NSString *imgStr =[[arrICEIDCardDetail  objectAtIndex:0] objectForKey:@"Photo"];
                        if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:imgStr] isEqualToString:@""])
                        {
                            NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, imgStr];
                            
                            image =  [[Singleton sharedSingleton] getImageFromCache:[imageName lastPathComponent]];
                            
                            if(image != nil)
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    if(image == nil)
                                    {
                                        [self.MYID_ADD_imgIcom setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
                                    }
                                    
                                    else{
                                        
                                        [self.MYID_ADD_imgIcom setBackgroundImage:image forState:UIControlStateNormal];
                                    }
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
                                
                                [[Singleton sharedSingleton] saveImageInCache:image ImgName:imgStr];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    if(image == nil)
                                        
                                    {
                                        
                                        [self.MYID_ADD_imgIcom setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
                                        
                                    }
                                    
                                    else{
                                        
                                        [self.MYID_ADD_imgIcom setBackgroundImage:image forState:UIControlStateNormal];
                                        
                                    }
                                });
                            }
                        }
                        
                    });
                }
                
                NSString *d =  [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL: [[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"DOB"]]];
                if(![d isEqualToString:@""])
                {
                    [self.MYID_ADD_btnDOB setTitle: [NSString stringWithFormat:@" %@", [[Singleton sharedSingleton] ConvertMilliSecIntoDate:d]] forState:UIControlStateNormal];
                }
                
                self.MYID_ADD_IDNumber.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"IdNumber"]]];
                
                if(![[NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"CountryName"]]] isEqualToString:@""])
                {
                    [self.MYID_ADD_btnCountry setTitle:[NSString stringWithFormat:@" %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"CountryName"]]]  forState:UIControlStateNormal];
//                    [self startActivity];
//                    [[Singleton sharedSingleton] getCountryList];
                }
                countryID = [NSString stringWithFormat:@"%@",[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"CountryID"]];
                
                
                if(![[NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"StateName"]]] isEqualToString:@""])
                {
                    [self.MYID_ADD_btnState setTitle:[NSString stringWithFormat:@" %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"StateName"]]]  forState:UIControlStateNormal];
                    [self startActivity];
                    [[Singleton sharedSingleton] getStateList: countryID];
                }
                stateID = [NSString stringWithFormat:@"%@",[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"StateId"]];
                
                gender = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"Sex"]]];
                gender = [gender stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if([gender isEqualToString:@"Male"])
                {
                    [self setSelectedGenderButton:self.MYID_ADD_btnMale];
                }
                else if([gender isEqualToString:@"Female"])
                {
                    [self setSelectedGenderButton:self.MYID_ADD_btnFemale];
                }
                else
                {
                    [self setSelectedGenderButton:self.MYID_ADD_btnMale];
                }
                
                self.MYID_VIEW_lblGender.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail  objectAtIndex:0] objectForKey:@"Sex"]]];
                self.MYID_ADD_txtGivenName.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"FirstName"]]];
                self.MYID_ADD_txtName.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"IdName"]]];
                self.MYID_ADD_txtSurname.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"LastName"]]];
                self.MYID_ADD_txtparentName.text = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL: [[arrICEIDCardDetail  objectAtIndex:0] objectForKey:@"ParentName"]]];
                self.MYID_ADD_txtFamilyName.text = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL: [[arrICEIDCardDetail  objectAtIndex:0] objectForKey:@"FamilyName"]]];
                 self.MYID_ADD_txtPhoneno.text = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL: [[arrICEIDCardDetail  objectAtIndex:0] objectForKey:@"ContactNumber"]]];
                
            }
        }
        //self.viewAddEditDetail.backgroundColor = [UIColor grayColor];
        
        CGRect f = self.btnSave.frame;
        f.origin.x = self.viewAddEditDetail.frame.origin.x + 15;
        f.origin.y = self.viewAddEditDetail.frame.origin.y + self.viewAddEditDetail.frame.size.height + 10;
        self.btnSave.frame = f;
        
        f = self.btnViewMyId.frame;
        f.origin.x =self.btnSave.frame.origin.x + self.btnSave.frame.size.width + 10;
        f.origin.y = self.viewAddEditDetail.frame.origin.y + self.viewAddEditDetail.frame.size.height + 10;
        self.btnViewMyId.frame = f;
        
    }
    else if(self.flagForID == 2)
    {
        // Company ID Card
        
        self.btnAddEdit.hidden = YES;
        self.btnSave.hidden = NO;
        self.btnViewMyId.hidden = NO;
        
        self.viewDetail.hidden=YES;
        self.viewAddEditDetail.hidden= YES;
        self.viewCompanyIDDetail.hidden = YES;
        self.viewCompanyAddEditDetail.hidden = NO;
        
        [self.btnSave setTitle:@"Save" forState:UIControlStateNormal];
        
        [self.btnViewMyId setTitle:@"View ID Card" forState:UIControlStateNormal];
    
        CGRect f = self.btnSave.frame;
         f.origin.x = self.viewCompanyAddEditDetail.frame.origin.x + 15;
        f.origin.y = self.viewCompanyAddEditDetail.frame.origin.y + self.viewCompanyAddEditDetail.frame.size.height + 10;
        self.btnSave.frame = f;

        f = self.btnViewMyId.frame;
        f.origin.x = self.btnSave.frame.origin.x + self.btnSave.frame.size.width + 5;
        f.origin.y = self.viewCompanyAddEditDetail.frame.origin.y + self.viewCompanyAddEditDetail.frame.size.height + 10 ;
        self.btnViewMyId.frame = f;
        
        self.COMPANY_lblTakePhoto.hidden= NO;
        
        if([arrCompanyDetail count] > 0)
        {
            if([[arrCompanyDetail objectAtIndex:0] count] > 0)
            {
                
                ICECompanyID = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail objectAtIndex:0] objectForKey:@"ICECompanyID"]];
                
                if(![[[Singleton sharedSingleton] ISNSSTRINGNULL: [[arrCompanyDetail objectAtIndex:0]  objectForKey:@"Photo"]] isEqualToString:@""])
                {
                    self.COMPANY_lblTakePhoto.hidden= YES;
                    
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
                    dispatch_async(queue, ^{
                        NSData *imageData;
                        UIImage *image;
                        
                        NSString *imgStr =[[arrCompanyDetail objectAtIndex:0]  objectForKey:@"Photo"];
                        if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:imgStr] isEqualToString:@""])
                        {
                            NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, imgStr];
                            
                            image =  [[Singleton sharedSingleton] getImageFromCache:[imageName lastPathComponent]];
                            
                            if(image != nil)
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [self.COMPANY_btnCompanyLogo setBackgroundImage:image forState:UIControlStateNormal];
                                    [[Singleton sharedSingleton] setstrImgEncoded:[[Singleton sharedSingleton] encodeToBase64String:image]];
                                    [[Singleton sharedSingleton] setstrImgFilename:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail objectAtIndex:0]  objectForKey:@"OriginalName"]]];
                                    
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
                                
                                [[Singleton sharedSingleton] saveImageInCache:image ImgName:[[arrCompanyDetail objectAtIndex:0]  objectForKey:@"Photo"]];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    if(image == nil)
                                    {
                                        [self.COMPANY_btnCompanyLogo setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
                                        
                                    }
                                    
                                    else{
                                        
                                        [self.COMPANY_btnCompanyLogo setBackgroundImage:image forState:UIControlStateNormal];
                                        [[Singleton sharedSingleton] setstrImgEncoded:[[Singleton sharedSingleton] encodeToBase64String:image]];
                                        
                                        [[Singleton sharedSingleton] setstrImgFilename:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail objectAtIndex:0]  objectForKey:@"OriginalName"]]];
                                    }
                                });
                            }
                        }
                        
                    });
                }
                
                NSString *d =  [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL: [[arrCompanyDetail objectAtIndex:0] objectForKey:@"StreetLine1"]]];
                if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:d] isEqualToString:@""])
                {
                    self.COMPANY_txtAddress.text = [NSString stringWithFormat:@"%@", d];
                     self.COMPANY_txtAddress.textColor = [UIColor blackColor];
                }
               
                
                self.COMPANY_txtIdNumber.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail objectAtIndex:0] objectForKey:@"IDNumber"]]];
                
                self.COMPANY_txtCompanyName.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail objectAtIndex:0] objectForKey:@"StoreName"]]];
                
                self.COMPANY_txtWebsite.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail  objectAtIndex:0] objectForKey:@"Website"]]];
                
                self.COMPANY_txtvatNumber.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail objectAtIndex:0] objectForKey:@"VatNumber"]]];
                
                self.COMPANY_txtPostalCode.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail objectAtIndex:0] objectForKey:@"PostalCode"]]];
                
                self.COMPANY_txtPhoneNo.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail objectAtIndex:0] objectForKey:@"Phone"]]];
            }
        }
        
    }
    else if(self.flagForID == 3)
    {
        if([[[ Singleton sharedSingleton] getarrICEMeditcation] count] > 0)
        {
            NSString *b = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEMeditcation objectAtIndex:0] objectForKey:@"BloodType"]];
            if(![b isEqualToString:@""])
            {
                [self.ICEMEDITCATION_Add_btnBloodType setTitle:[NSString stringWithFormat:@"%@",b] forState:UIControlStateNormal];
            }
            
           // self.ICEMEDITCATION_Add_txtBloodType.text = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEMeditcation objectAtIndex:0] objectForKey:@"BloodType"]]];
            
            self.ICEMEDITCATION_Add_txtChronic.text = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEMeditcation objectAtIndex:0] objectForKey:@"ChronicDisease"]]];
            
            self.ICEMEDITCATION_Add_txtContratication.text = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEMeditcation objectAtIndex:0]  objectForKey:@"Contratications"]]];
            
            self.ICEMEDITCATION_Add_txtAllergies.text = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEMeditcation objectAtIndex:0]  objectForKey:@"Allergies"]]];
        }
        
        [self.view addSubview:self.viewICEMeditcationAddEdit];
    }
}


- (IBAction)btnViewMyIDClicked:(id)sender
{
    pickerBloodType.hidden = YES;
    self.picker_DOB.hidden = YES;
    self.pickerCountry.hidden =YES;
    self.pickerCountryIpad.hidden = YES;

    [self.view endEditing:YES];
    if(self.flagForID == 1)
    {
       if([[[Singleton sharedSingleton] getarrICEIDCardDetail] count] > 0)
        {
            arrICEIDCardDetail = [[NSMutableArray alloc] init];
            
            [arrICEIDCardDetail addObject:[[Singleton sharedSingleton] getarrICEIDCardDetail]  ];
            [self displayMYIDCardDetailView];
        }
        else
        {
            [self getMYIDCardDetail];
        }
    }
    else if(self.flagForID == 2)
    {
        if([[[Singleton sharedSingleton] getarrCompanyDetail] count] > 0)
        {
            arrCompanyDetail = [[NSMutableArray alloc] init];
            
            [arrCompanyDetail addObject:[[Singleton sharedSingleton] getarrCompanyDetail]  ];
              [self btnCompanyIDCliked:nil];
        }
        else
        {
             [self btnCompanyIDCliked:nil];
        }
        
//        [self btnCompanyIDCliked:nil];

    }
    else if(self.flagForID == 3)
    {
       
        if([[[Singleton sharedSingleton] getarrICEMeditcation] count] > 0)
        {
            arrICEMeditcation = [[NSMutableArray alloc] init];
            [arrICEMeditcation addObject:[[Singleton sharedSingleton] getarrICEMeditcation] ];
            [self filleupICEMeditcationDetail];            
        }
        else
        {
            [self getICEMeditcationDetail];
        }
    }
}

- (IBAction)btnSaveClicked:(id)sender {
    
    pickerBloodType.hidden = YES;
    self.picker_DOB.hidden = YES;
    self.pickerCountry.hidden =YES;
    self.pickerCountryIpad.hidden = YES;

    [self.view endEditing:YES];
    
    if(self.flagForID == 1)
    {
        [self saveMyIDCardDetail];
    }
    else if(self.flagForID == 2)
    {
        [self saveCompanyDetail];
        
    }
    else if(self.flagForID == 3)
    {
        [self.btnICESave setTitle:@"Save" forState:UIControlStateNormal];
        self.ICECONTACT_name.text=@"";
        self.ICECONTACT_phoneno.text=@"";
        [self.ICECONTACT_name becomeFirstResponder];
        [self.view addSubview:self.viewICEAddContact];
    }
}

#pragma mark ICE SAVE BUTTON

- (IBAction)btnICESaveClicked:(id)sender {
    pickerBloodType.hidden = YES;
    self.picker_DOB.hidden = YES;
    self.pickerCountry.hidden =YES;
    self.pickerCountryIpad.hidden = YES;

        [self.view endEditing:YES];
    [self AddICEContactDetail];
   
}
- (IBAction)btnICEMeditcationSaveClicked:(id)sender
{
    pickerBloodType.hidden = YES;
    self.picker_DOB.hidden = YES;
    self.pickerCountry.hidden =YES;
    self.pickerCountryIpad.hidden = YES;

        [self.view endEditing:YES];
    [self saveICEMditcationDetail];
    
//    [self.viewICEMeditcationAddEdit removeFromSuperview];
//    
//    self.viewDetail.hidden=YES;
//    self.viewAddEditDetail.hidden= YES;
//    self.viewCompanyIDDetail.hidden = YES;
//    self.viewCompanyAddEditDetail.hidden = YES;
//    self.viewICEDetail.hidden = YES;
//    self.viewICEMeditcationDetail.hidden=NO;
//    
//    self.btnAddEdit.hidden = NO;
//    self.btnSave.hidden = YES;
//    self.btnViewMyId.hidden = YES;
//    
//    CGRect f = self.btnAddEdit.frame;
//    f.origin.y = self.viewICEMeditcationDetail.frame.origin.y + self.viewICEMeditcationDetail.frame.size.height + 10;
//    self.btnAddEdit.frame = f;
//    [self.btnAddEdit setTitle:@"Edit Meditcation" forState:UIControlStateNormal];
}

#pragma mark COUNTRY & GENDER & Profile Pic
-(void)selectCountryAfterLoad
{
    NSString *cName = [self.MYID_ADD_btnCountry.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(IS_IPAD)
    {
        self.pickerCountryIpad.hidden = NO;
        //country
        self.btnCountryDone.tag = 1;
        [self.pickerCountryIpad reloadAllComponents];
       
        if(![cName isEqualToString:@"Select Country"])
        {
            NSArray *valArray = [[[Singleton sharedSingleton] getarrCountryList]  valueForKey:@"CountryName"];
            if([valArray count] > 0)
            {
                
                NSUInteger index = [[valArray objectAtIndex:0] indexOfObject:cName];
                @try {
                    [self.pickerCountryIpad selectRow:index inComponent:0 animated:YES];
                }
                @catch (NSException *exception) {
                    [self.pickerCountryIpad selectRow:0 inComponent:0 animated:YES];
                }
            }
        }

//        [self.pickerCountryIpad selectRow:0 inComponent:0 animated:YES];
        
    }
    else
    {
        
        [self.view addSubview: self.viewCountry];
        //country
        self.btnCountryDone.tag = 1;
        [self.pickerCountry reloadAllComponents];
        self.pickerCountry.hidden = NO;
        
        if(![cName isEqualToString:@"Select Country"])
        {
            NSArray *valArray = [[[Singleton sharedSingleton] getarrCountryList]  valueForKey:@"CountryName"];
            if([valArray count] > 0)
            {
                NSLog(@"selected country : %@", cName);

                NSUInteger index = [valArray indexOfObject:cName];
                @try {
                    [self.pickerCountry selectRow:index inComponent:0 animated:YES];
                }
                @catch (NSException *exception) {
                    [self.pickerCountry selectRow:0 inComponent:0 animated:YES];
                }
            }
        }
       
    }
  
}
-(void)selectStateAfterLoad
{
    NSString *sName =[self.MYID_ADD_btnState.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(IS_IPAD)
    {
        
        self.pickerCountryIpad.hidden= NO;
        self.pickerCountry.hidden= NO;
        self.btnCountryDone.tag = 2;
        [self.pickerCountryIpad reloadAllComponents];
     
  
        
        if(![sName isEqualToString:@"Select State"])
        {
            NSLog(@"selected stat\e : %@",sName);
            
            NSArray *valArray = [[[Singleton sharedSingleton] getarrStateList]  valueForKey:@"StateName"];
            if([valArray count] > 0)
            {
                NSUInteger index = [valArray indexOfObject:sName];
                @try {
                    [self.pickerCountryIpad selectRow:index inComponent:0 animated:YES];
                }
                @catch (NSException *exception) {
                    [self.pickerCountryIpad selectRow:0 inComponent:0 animated:YES];
                }
            }
        }

        
    }
    else
    {
        self.btnCountryDone.tag = 2;
        [self.pickerCountry reloadAllComponents];
        
        if(![sName isEqualToString:@"Select State"])
        {
            NSArray *valArray = [[[Singleton sharedSingleton] getarrStateList]  valueForKey:@"StateName"];
            if([valArray count] > 0)
            {
                NSUInteger index = [valArray indexOfObject:sName];
                @try {
                    [self.pickerCountry selectRow:index inComponent:0 animated:YES];
                }
                @catch (NSException *exception) {
                    [self.pickerCountry selectRow:0 inComponent:0 animated:YES];
                }
            }
        }
        self.pickerCountry.hidden = NO;
        [self.view addSubview: self.viewCountry];
    }
}
- (IBAction)btnCountryClicked:(id)sender {
    
    UIButton *b = (UIButton*)sender;
    [self.view endEditing:YES];
    
    if(b.tag == 1)
    {
        if( [[[Singleton sharedSingleton] getarrCountryList] count] > 0)
        {
            [self selectCountryAfterLoad];
        }
        else
        {
            [self startActivity];
            [[Singleton sharedSingleton] getCountryList];
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to get Country List" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
        }        
    }
    else if(b.tag == 2)
    {
        if( [[[Singleton sharedSingleton] getarrStateList] count] > 0)
        {
            [self selectStateAfterLoad];
        }
        else
        {
            [self startActivity];
            [[Singleton sharedSingleton] getStateList: countryID];
        }
       
        //state
      
    }
    
  /*  if( [[[Singleton sharedSingleton] getarrCountryList] count] > 0)
    {
        
        [self.view addSubview: self.viewCountry];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to get Country List" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }*/
}
-(IBAction)ICEMedictionBloodTypeClicked:(id)sender
{
    if(IS_IPAD)
    {
        self.btnCountryDone.tag = 3;
        pickerBloodType.hidden= NO;
       
        [pickerBloodType reloadAllComponents];
        //            [self.pickerCity selectRow:[stateId intValue] inComponent:0 animated:YES];
        [pickerBloodType selectRow:0 inComponent:0 animated:YES];
    }
    else
    {
        self.btnCountryDone.tag = 3;
        pickerBloodType.hidden= NO;
        
        [pickerBloodType reloadAllComponents];
        //            [self.pickerCity selectRow:[stateId intValue] inComponent:0 animated:YES];
        [pickerBloodType selectRow:0 inComponent:0 animated:YES];
    }
}
- (IBAction)btnCountryDoneClicked:(id)sender {
    [self.viewCountry removeFromSuperview];
}
-(IBAction)btnMaleClicked
{
    [self.view endEditing:YES];
     [self setSelectedGenderButton:self.MYID_ADD_btnMale];
}
-(IBAction)btnFemaleClicked
{
    [self.view endEditing:YES];
     [self setSelectedGenderButton:self.MYID_ADD_btnFemale];
}
-(IBAction)btnOtherClicked
{
    [self.view endEditing:YES];
    [self setSelectedGenderButton:self.MYID_ADD_btnOther];
}
-(void)setSelectedGenderButton:(UIButton *)radioButton
{
    UIImage *Checkimage = [UIImage imageNamed:@"check-box-select.png"];
    UIImage *Uncheckimage = [UIImage imageNamed:@"check-box.png"];
   
    if(radioButton == self.MYID_ADD_btnMale){
        [self.MYID_ADD_btnMale setBackgroundImage:Checkimage forState:UIControlStateNormal];
        [self.MYID_ADD_btnMale setBackgroundImage:Checkimage forState:UIControlStateSelected];
        [self.MYID_ADD_btnMale setBackgroundImage:Checkimage forState:UIControlStateHighlighted];
        self.MYID_ADD_btnMale.adjustsImageWhenHighlighted = YES;
        
        [self.MYID_ADD_btnFemale setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
        [self.MYID_ADD_btnOther setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
        
//        self.MYID_ADD_btnMale.enabled = NO;
//        self.MYID_ADD_btnFemale.enabled = YES;
//        self.MYID_ADD_btnOther.enabled = YES;
        gender=@"Male";
    }
    else if(radioButton == self.MYID_ADD_btnFemale){
        [self.MYID_ADD_btnFemale setBackgroundImage:Checkimage forState:UIControlStateNormal];
        [self.MYID_ADD_btnFemale setBackgroundImage:Checkimage forState:UIControlStateSelected];
        [self.MYID_ADD_btnFemale setBackgroundImage:Checkimage forState:UIControlStateHighlighted];
        self.MYID_ADD_btnFemale.adjustsImageWhenHighlighted = YES;
        
        [self.MYID_ADD_btnMale setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
        [self.MYID_ADD_btnOther setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
        
//        self.MYID_ADD_btnMale.enabled = YES;
//        self.MYID_ADD_btnOther.enabled = YES;
//        self.MYID_ADD_btnFemale.enabled = NO;
        gender=@"Female";
    }
    else if(radioButton == self.MYID_ADD_btnOther){
        [self.MYID_ADD_btnOther setBackgroundImage:Checkimage forState:UIControlStateNormal];
        [self.MYID_ADD_btnOther setBackgroundImage:Checkimage forState:UIControlStateSelected];
        [self.MYID_ADD_btnOther setBackgroundImage:Checkimage forState:UIControlStateHighlighted];
        self.MYID_ADD_btnOther.adjustsImageWhenHighlighted = YES;
        
        [self.MYID_ADD_btnMale setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
        [self.MYID_ADD_btnFemale setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
        
//        self.MYID_ADD_btnMale.enabled = YES;
//        self.MYID_ADD_btnFemale.enabled = YES;
//        self.MYID_ADD_btnOther.enabled = NO;

        gender=@"Other";
    }
    
}

//- (IBAction)MYIDImgIconClicked:(id)sender {
//    [[Singleton sharedSingleton]  CameraClicked:self.view];
//}

#pragma  mark **** ADD/VIEW ICE MY ID CARD
-(void)saveMyIDCardDetail
{
    [self.view endEditing:YES];
    self.pickerCountryIpad.hidden=YES;
    
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
    }
    else
    {
       
        //Parameter :CountryID, IdName,IdNumber,ContactNumber, DOB(MM-dd-yyyy), Sex , Surname, GivenName, FamilyName, ParentName, UserId


        NSString * idName =[[Singleton sharedSingleton] ISNSSTRINGNULL:[self.MYID_ADD_txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] ;
         NSString * idNumber =[[Singleton sharedSingleton] ISNSSTRINGNULL:[self.MYID_ADD_IDNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] ;
        NSString *dob = [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.MYID_ADD_btnDOB.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] ;
        NSString * surname = [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.MYID_ADD_txtSurname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSString * givenName = [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.MYID_ADD_txtGivenName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSString * parentName =  [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.MYID_ADD_txtparentName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSString * familyName =  [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.MYID_ADD_txtFamilyName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSString * number =  [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.MYID_ADD_txtPhoneno.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        countryID = [[Singleton sharedSingleton] ISNSSTRINGNULL:countryID];
        stateID = [[Singleton sharedSingleton] ISNSSTRINGNULL:stateID];
        
        
        //check birth year -
        NSString *d =  [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL: self.MYID_ADD_btnDOB.titleLabel.text]];
        int age=0;
        if(![d isEqualToString:@""])
        {
            //            NSString *a = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ConvertMilliSecIntoDate:d]];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            dateFormatter.dateFormat = @"dd MMMM yyyy";
            NSDate *date = [dateFormatter dateFromString:d];
            
            dateFormatter.dateFormat = @"MMM d, yyyy";
            // add this check and set
            if (date == nil) {
                date = [NSDate date];
            }
            [self.picker_DOB setDate:date];
            NSDate *selectedDate= [self.picker_DOB date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy"];//yyyy-MM-dd
            NSString *selectedYear = [NSString stringWithFormat:@"%@", [formatter stringFromDate:selectedDate]];
            NSString *CurrentYear = [NSString stringWithFormat:@"%@", [formatter stringFromDate:[NSDate date]]];
            age = [CurrentYear intValue] - [selectedYear intValue];
            NSLog(@"Current Age : %d", age);
        }
        
               
        if([idName isEqualToString:@""] || [dob isEqualToString:@""] || [surname isEqualToString:@""] || [parentName isEqualToString:@""] || [familyName isEqualToString:@""] || [countryID isEqualToString:@""] || [gender isEqualToString:@""] || [givenName isEqualToString:@""] || [number isEqualToString:@""] || [idNumber isEqualToString:@""])
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_EMPTY_DATA message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else if(IS_IPAD &&  [stateID isEqualToString:@""] )
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_EMPTY_DATA message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else if(number.length < 4)
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Mobile length should be atleast 4 or more" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else if(age < 10)
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Minimum age should be 10 years" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
            if(![ICECardId isEqualToString:@""])
            {
                [dict setValue:ICECardId forKey:@"ICECardId"];
            }
            [dict setValue:userId forKey:@"UserId"];
            [dict setValue:idName forKey:@"IdName"];
            [dict setValue:dob forKey:@"DOB"];
            [dict setValue:surname forKey:@"Surname"];
            [dict setValue:parentName forKey:@"ParentName"];
            [dict setValue:familyName forKey:@"FamilyName"];
            [dict setValue:gender forKey:@"Sex"];
            [dict setValue:givenName forKey:@"GivenName"];
            [dict setValue:countryID forKey:@"CountryID"];
            [dict setValue:idNumber forKey:@"IdNumber"];
            [dict setValue:number forKey:@"ContactNumber"];
            [dict setValue:stateID forKey:@"StateId"];
     
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 NSLog(@"Save ID CARD Info  :  %@ -- ", dict);
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
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"message"]  message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alert show];
                         if([dict objectForKey:@"data"] > 0)
                         {
                             [[Singleton sharedSingleton] setarrICEIDCardDetail:[dict objectForKey:@"data"]];
                             if([[[Singleton sharedSingleton] getarrICEIDCardDetail] count] > 0)
                             {
                                 arrICEIDCardDetail = [[NSMutableArray alloc] init];
                                 
                                 [arrICEIDCardDetail addObject:[[Singleton sharedSingleton] getarrICEIDCardDetail]  ];
                                 [self displayMYIDCardDetailView];
                             }
                         }
                         
//                         [self getMYIDCardDetail];
     
                     }
                       [self stopActivity];
                 }
                 else
                 {
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                 }
                 
               
                 
             } :@"ICE/AddICECard" data:dict];
        }
    }
}
-(void)getMYIDCardDetail
{
    [self.view endEditing:YES];
    self.pickerCountryIpad.hidden = YES;
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
        
        
        self.viewDetail.hidden = YES;
        self.viewAddEditDetail.hidden=YES;
        self.viewCompanyIDDetail.hidden = YES;
        self.viewCompanyAddEditDetail.hidden = YES;
        self.viewICEDetail.hidden = YES;
        self.viewICEMeditcationDetail.hidden = YES;
        
        self.btnViewMyId.hidden = YES;
        self.btnSave.hidden = YES;
        self.btnAddEdit.hidden = NO;
        
        CGRect f = self.btnAddEdit.frame;
        f.origin.y = self.viewMyIDCard.frame.origin.y + self.viewMyIDCard.frame.size.height + 10;
        self.btnAddEdit.frame = f;
        [self.btnAddEdit setTitle:@"Add ID Info" forState:UIControlStateNormal];
        
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
                 [self stopActivity];
                 
                 NSLog(@"GET ID CARD Info  :  %@ -- ", dict);
                 if (dict)
                 {
                     Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                     if (!strCode)
                     {
                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         if([[dict objectForKey:@"message"] isEqualToString:@"Fill Your Profile first."])
                         {
                              alt.tag = 14;
                         }
                         [alt show];
                         
                         [self displayMYIDCardAddEditView];
                     }
                     else
                     {
                         arrICEIDCardDetail = [[NSMutableArray alloc] init];
                         [arrICEIDCardDetail addObject:[dict objectForKey:@"data"]];
                         
                         [[Singleton sharedSingleton] setarrICEIDCardDetail:[dict objectForKey:@"data"]];
                         
                         if([arrICEIDCardDetail count] > 0)
                         {
                             if([[arrICEIDCardDetail objectAtIndex:0]count] > 0)
                             {
                                 if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"IdName"]] isEqualToString:@""])
                                 {
                                       [self displayMYIDCardDetailView];
                                 }
                                 else
                                 {
                                     [self displayMYIDCardAddEditView];
                                 }
                             }
                         }
                     }
                 }
                 else
                 {
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     
                     [self displayMYIDCardAddEditView];
                 }
             } :@"ICE/GetICECard" data:dict];
        
    }
}
-(void)displayMYIDCardAddEditView
{
    self.viewDetail.hidden = YES;
    self.viewAddEditDetail.hidden=YES;
    self.viewCompanyIDDetail.hidden = YES;
    self.viewCompanyAddEditDetail.hidden = YES;
    self.viewICEDetail.hidden = YES;
    self.viewICEMeditcationDetail.hidden = YES;
    
    self.btnViewMyId.hidden = YES;
    self.btnSave.hidden = YES;
    self.btnAddEdit.hidden = NO;
    
    CGRect f = self.btnAddEdit.frame;
    f.origin.y = self.viewMyIDCard.frame.origin.y + self.viewMyIDCard.frame.size.height + 10;
    self.btnAddEdit.frame = f;
    [self.btnAddEdit setTitle:@"Add ID Info" forState:UIControlStateNormal];
}
-(void)displayMYIDCardDetailView
{
    self.viewDetail.hidden = NO;
    self.viewAddEditDetail.hidden=YES;
    self.viewCompanyIDDetail.hidden = YES;
    self.viewCompanyAddEditDetail.hidden = YES;
    self.viewICEDetail.hidden = YES;
    self.viewICEMeditcationDetail.hidden = YES;
    
    self.btnViewMyId.hidden = YES;
    self.btnSave.hidden = YES;
    self.btnAddEdit.hidden = NO;
    CGRect f = self.btnAddEdit.frame;
    f.origin.y = self.viewDetail.frame.origin.y + self.viewDetail.frame.size.height + 5;
    self.btnAddEdit.frame = f;
    [self.btnAddEdit setTitle:@"Edit ID Info" forState:UIControlStateNormal];
    
    //--------------
    
    //NSLog(@"arrICEContactDetail count - %d", [arrICEIDCardDetail count]);
    
    if([arrICEIDCardDetail count] > 0)
    {
        if([[arrICEIDCardDetail objectAtIndex:0] count] > 0)
        {
            ICECardId = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"ICECardId"]];

            //CountryPhoto
            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0]  objectForKey:@"CountryPhoto"]] isEqualToString:@""])
            {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
                dispatch_async(queue, ^{
                    
                    NSData *imageData;
                    UIImage *image;
                    
                    NSString *imgStr =[[arrICEIDCardDetail objectAtIndex:0]  objectForKey:@"CountryPhoto"];
                    if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:imgStr] isEqualToString:@""])
                    {
                        //Country Logo
                        NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, imgStr];
                        image =  [[Singleton sharedSingleton] getImageFromCache:[imageName lastPathComponent]];
                        if(image != nil)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [self.MYID_ADD_CountryLogo setBackgroundImage:image forState:UIControlStateNormal];
                                
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
                            
                            [[Singleton sharedSingleton] saveImageInCache:image ImgName:imgStr];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if(image == nil)
                                    
                                {
                                    
                                    [self.MYID_ADD_CountryLogo setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
                                    
                                }
                                
                                else{
                                    
                                    [self.MYID_ADD_CountryLogo setBackgroundImage:image forState:UIControlStateNormal];
                                    
                                }
                                
                            });
                        }

                    }
                    
                });

            }
            else
            {
                  [self.MYID_ADD_CountryLogo setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
            }
            
            //profile Pic
            NSString *imgStr1 =[[arrICEIDCardDetail  objectAtIndex:0] objectForKey:@"Photo"];
            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:imgStr1] isEqualToString:@""])
            {
                UIImage *image1;
                NSData *imageData1;
                NSString *imageName1 = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, imgStr1];
                image1 =  [[Singleton sharedSingleton] getImageFromCache:[imageName1 lastPathComponent]];
                if(image1 != nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if(image1 == nil)
                        {
                            [self.MYID_VIEW_btnprofilePic setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
                        }
                        else{
                            [self.MYID_VIEW_btnprofilePic setBackgroundImage:image1 forState:UIControlStateNormal];
                        }
                        
                    });
                }
                else
                {
                    NSURL *imageURL =[NSURL URLWithString:imageName1];
                    if(imageData1 == nil)
                    {
                        imageData1 = [[NSData alloc] init];
                    }
                    imageData1 = [NSData dataWithContentsOfURL:imageURL];
                    //        NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    image1 = [UIImage imageWithData:imageData1];
                    
                    //  /Upload/UserCard/bb1f9253-ae44-44a1-8427-94d1a0e71dfc/bb1f9253-ae44-44a1-8427-94d1a0e71dfc_06102014521AM.png
                    
                    [[Singleton sharedSingleton] saveImageInCache:image1 ImgName:imgStr1];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.MYID_VIEW_btnprofilePic setBackgroundImage:image1 forState:UIControlStateNormal];
                        
                    });
                }
            }
            
            //DOB
            NSString *d =  [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL: [[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"DOB"]]];
            if(![d isEqualToString:@""])
            {
                self.MYID_VIEW_DOB.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ConvertMilliSecIntoDate:d]];
            }
            else
            {
                self.MYID_VIEW_DOB.text=@"";
            }
            //IdNumber
            self.MYID_VIEW_IDNumber.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"IdNumber"]]];
            //CountryName
            NSString *c = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"CountryName"]];
            if(![c isEqualToString:@""])
            {
                self.MYID_VIEW_lblCountry.text = [NSString stringWithFormat:@"Republic of %@", c];
              
            }
            else
            {
                 self.MYID_VIEW_lblCountry.text = [NSString stringWithFormat:@"%@", c];
            }
            //StateName
            NSString *s = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"StateName"]];
            if(![s isEqualToString:@""])
            {
                self.MYID_VIEW_lblState.text = [NSString stringWithFormat:@"%@", s];
              
            }
            else
            {
                self.MYID_VIEW_lblState.text = [NSString stringWithFormat:@"%@", s];
            }

            self.MYID_VIEW_lblFamilyname.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"FamilyName"]]];
            self.MYID_VIEW_lblGender.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail  objectAtIndex:0] objectForKey:@"Sex"]]];
            self.MYID_VIEW_lblGivenName.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"GivenName"]]];
            self.MYID_VIEW_lblIDName.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"IdName"]]];
            self.MYID_VIEW_lblSurname.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"Surname"]]];
            self.MYID_VIEW_ParentName.text = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL: [[arrICEIDCardDetail  objectAtIndex:0] objectForKey:@"ParentName"]]];
            self.MYID_VIEW_lblContactNumber.text = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL: [[arrICEIDCardDetail  objectAtIndex:0] objectForKey:@"ContactNumber"]]];
        }
    }
}
-(IBAction)btnDoneDOBClicked:(id)sender
{
    NSDate *date=[self.picker_DOB date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMMM yyyy"];//yyyy-MM-dd
    [self.MYID_ADD_btnDOB setTitle:[NSString stringWithFormat:@" %@",[formatter stringFromDate:date]] forState:UIControlStateNormal];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    MYIDStrDOB = [formatter stringFromDate:date];
    NSLog(@" Selected Date : %@", self.MYID_ADD_btnDOB.titleLabel.text);
    
    [self.view_DOB removeFromSuperview];
}

- (IBAction)btnDOBClicked:(id)sender {

    [self.view endEditing:YES];
    self.pickerCountryIpad.hidden=YES;
    
    if([arrICEIDCardDetail count] > 0)
    {
        if([[arrICEIDCardDetail objectAtIndex:0] count] > 0)
        {
//            NSString *d =  [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL: [[arrICEIDCardDetail objectAtIndex:0] objectForKey:@"DOB"]]];
            NSString *d =  [NSString stringWithFormat:@"%@",self.MYID_ADD_btnDOB.titleLabel.text];
            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:d] isEqualToString:@""] && ![[d stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"Select DOB"])
            {
              // NSString *a = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ConvertMilliSecIntoDate:d]];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                dateFormatter.dateFormat = @"dd MMMM yyyy";
                NSDate *date = [dateFormatter dateFromString:d];
                dateFormatter.dateFormat = @"MMM d, yyyy";
                // add this check and set
                if (date == nil) {
                    date = [NSDate date];
                }
                [self.picker_DOB setDate:date];
               self.picker_DOB.hidden = NO;
            }
        }
    }
    [self.view addSubview:self.view_DOB];
    self.picker_DOB.hidden = NO;
}


#pragma mark --------- ADD / EDIT ICE COMPENY DETAIL ---------
-(void)saveCompanyDetail
{
    
    [self.view endEditing:YES];
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
    }
    else
    {
      
        //Parameter :ICECompanyID,StoreName,IDNumber,VatNumber,Photo,OriginalName, Phone, Website, StreetLine1,(StreetLine2,StateID,CountryID -- removed),PostalCode,UserId

        
        NSString * idName =[[Singleton sharedSingleton] ISNSSTRINGNULL:[self.COMPANY_txtCompanyName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] ;
        NSString * idNumber =[[Singleton sharedSingleton] ISNSSTRINGNULL:[self.COMPANY_txtIdNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] ;
        NSString *phoneno = [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.COMPANY_txtPhoneNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] ;
        NSString * website = [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.COMPANY_txtWebsite.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSString * vatNumber = [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.COMPANY_txtvatNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSString * postalCode =  [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.COMPANY_txtPostalCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSString * address =  [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.COMPANY_txtAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSString *Photo = [[Singleton sharedSingleton] getstrImgEncoded];
        NSString *OriginalName = [[Singleton sharedSingleton] getstrImgFilename];
         
        if([idName isEqualToString:@""] || [idNumber isEqualToString:@""] || [phoneno isEqualToString:@""] || [website isEqualToString:@""] || [vatNumber isEqualToString:@""] || [postalCode isEqualToString:@""] || [address isEqualToString:@""] || [Photo isEqualToString:@""] || [OriginalName isEqualToString:@""])
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_EMPTY_DATA message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else if(phoneno.length < 4)
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Mobile length should be atleast 4 or more" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else if(![[Singleton sharedSingleton] validateUrlWithString:website])
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Please Enter Correct Format of Website" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else if(postalCode.length <= 3)
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"PostalCode length should be atleast 3 or more" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
            if(![ICECompanyID isEqualToString:@""])
            {
                [dict setValue:ICECompanyID forKey:@"ICECompanyID"];
            }
            [dict setValue:userId forKey:@"UserId"];
            [dict setValue:idName forKey:@"StoreName"];
            [dict setValue:idNumber forKey:@"IDNumber"];
            [dict setValue:vatNumber forKey:@"VatNumber"];
            [dict setValue:Photo forKey:@"Photo"];
            [dict setValue:OriginalName forKey:@"OriginalName"];
            [dict setValue:phoneno forKey:@"Phone"];
            [dict setValue:website forKey:@"Website"];
            [dict setValue:address forKey:@"StreetLine1"];
            [dict setValue:postalCode forKey:@"PostalCode"];
           
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 NSLog(@"Save ID CARD Info  :  %@ -- ", dict);
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
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"message"]  message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alert show];
                         
                         if([dict objectForKey:@"data"] > 0)
                         {
                             [[Singleton sharedSingleton] setarrCompanyDetail:[dict objectForKey:@"data"]];
                             if([[[Singleton sharedSingleton] getarrCompanyDetail] count] > 0)
                             {
                                 arrCompanyDetail = [[NSMutableArray alloc] init];
                                 
                                 [arrCompanyDetail addObject:[[Singleton sharedSingleton] getarrCompanyDetail]  ];
                                 [self displayCompanyDetailView];
                             }
                         }
//                         [self getCompanyDetail];
                         
                     }
                     //Remove Common Photo Encodeed and Filename
                     [[Singleton sharedSingleton] setStrImgEncoded:@""];
                     [[Singleton sharedSingleton] setstrImgFilename:@""];
                     [self stopActivity];
                 }
                 else
                 {
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                 }
                                  
             } :@"ICE/AddICECompany" data:dict];
        }
    }
}
-(void)getCompanyDetail
{
    [self.view endEditing:YES];
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
        
        [self displayCompanyAddEdit];
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
             NSLog(@"GET COMPANY Info  :  %@ -- ", dict);
             if (dict)
             {
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                     [alt show];
                   
                    [self displayCompanyAddEdit];
                 }
                 else
                 {
                     arrCompanyDetail = [[NSMutableArray alloc] init];
                     [arrCompanyDetail addObject:[dict objectForKey:@"data"]];
                     
                     [[Singleton sharedSingleton] setarrCompanyDetail:[dict objectForKey:@"data"]];
                     
                     if([arrCompanyDetail count] > 0)
                     {
                         if([[arrCompanyDetail objectAtIndex:0]count] > 0)
                         {
//                             if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail objectAtIndex:0] objectForKey:@"StoreName"]] isEqualToString:@""])
                             if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail objectAtIndex:0] objectForKey:@"IDNumber"]] isEqualToString:@""])
                             {
                                 [self displayCompanyDetailView];
                             }
                             else
                             {
                                 [self displayCompanyAddEdit];
                             }
                         }
                     }
                 }
             }
             else
             {
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
                 
                 [self displayCompanyAddEdit];
             }
             [self stopActivity];
             
         } :@"ICE/GetICECompany" data:dict];
    }
}

-(void)displayCompanyDetailView
{
    self.flagForID =2;
    [self.viewMyIDCard setBackgroundColor:NORMALBGCOLOR];
    [self.viewCompanyID setBackgroundColor:SELECTEDBGCOLOR];
    [self.viewICEID setBackgroundColor:NORMALBGCOLOR];
    
    self.viewDetail.hidden = YES;
    self.viewAddEditDetail.hidden=YES;
    self.viewCompanyIDDetail.hidden = NO;
    self.viewCompanyAddEditDetail.hidden = YES;
    self.viewICEDetail.hidden = YES;
    self.viewICEMeditcationDetail.hidden = YES;
    
    self.btnViewMyId.hidden = YES;
    self.btnSave.hidden = YES;
    self.btnAddEdit.hidden = NO;
    CGRect f = self.btnAddEdit.frame;
    f.origin.y = self.viewCompanyIDDetail.frame.origin.y + self.viewCompanyIDDetail.frame.size.height + 10;
    self.btnAddEdit.frame = f;
    [self.btnAddEdit setTitle:@"Edit ID Info" forState:UIControlStateNormal];
    
    //------------------------
  
    if([arrCompanyDetail count] > 0)
    {
        if([[arrCompanyDetail objectAtIndex:0] count] > 0)
        {
           ICECompanyID = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail objectAtIndex:0] objectForKey:@"ICECompanyID"]];
     
            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail objectAtIndex:0]  objectForKey:@"Photo"]] isEqualToString:@""])
            {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
                dispatch_async(queue, ^{
                    
                    NSData *imageData;
                    UIImage *image;
                    NSString *imgStr =[[arrCompanyDetail objectAtIndex:0]  objectForKey:@"Photo"];
                    if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:imgStr] isEqualToString:@""])
                    {
                        NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, imgStr];
                        
                        image =  [[Singleton sharedSingleton] getImageFromCache:[imageName lastPathComponent]];
                        
                        if(image != nil)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                self.COMPANY_VIEW_logo.image = image;
                                
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
                            
                            [[Singleton sharedSingleton] saveImageInCache:image ImgName:imgStr];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if(image == nil)
                                {
                                    self.COMPANY_VIEW_logo.image =[UIImage imageNamed:@"defaultImage.png"];
                                }
                                else{
                                    self.COMPANY_VIEW_logo.image = image;
                                    
                                    [[Singleton sharedSingleton] setStrImgEncoded:[[Singleton sharedSingleton] encodeToBase64String:image]];
                                    
                                    [[Singleton sharedSingleton] setstrImgFilename:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail objectAtIndex:0]  objectForKey:@"OriginalName"]]];
                                }
                            });
                        }
                    }
                });
            }
            
            NSString *d =  [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL: [[arrCompanyDetail objectAtIndex:0] objectForKey:@"StreetLine1"]]];
             self.COMPANY_VIEW_lblAddress.text = [NSString stringWithFormat:@"%@", d];
            
            self.COMPANY_VIEW_lblIdNumber.text = [NSString stringWithFormat:@"%@", [[arrCompanyDetail objectAtIndex:0] objectForKey:@"IDNumber"]];
            
            self.COMPANY_VIEW_name.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail objectAtIndex:0] objectForKey:@"StoreName"]]];
            
            self.COMPANY_VIEW_lblWebsite.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail  objectAtIndex:0] objectForKey:@"Website"]]];
        
            self.COMPANY_VIEW_lblVatnumber.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail objectAtIndex:0] objectForKey:@"VatNumber"]]];
          
            self.COMPANY_VIEW_lblPostalCode.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail objectAtIndex:0] objectForKey:@"PostalCode"]]];
         
            self.COMPANY_VIEW_lblPhoneNo.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrCompanyDetail objectAtIndex:0] objectForKey:@"Phone"]]];
          
        }
    }
}
-(void)displayCompanyAddEdit
{
    self.flagForID =2;
    [self.viewMyIDCard setBackgroundColor:NORMALBGCOLOR];
    [self.viewCompanyID setBackgroundColor:SELECTEDBGCOLOR];
    [self.viewICEID setBackgroundColor:NORMALBGCOLOR];
    
    self.viewAddEditDetail.hidden = YES;
    self.viewDetail.hidden = YES;
    self.viewCompanyIDDetail.hidden = YES;
    self.btnViewMyId.hidden = YES;
    self.btnSave.hidden = YES;
    self.btnAddEdit.hidden = NO;
    self.viewICEDetail.hidden = YES;
    self.viewICEMeditcationDetail.hidden = YES;
    
    CGRect f = self.btnAddEdit.frame;
    f.origin.y = self.viewMyIDCard.frame.origin.y + self.viewMyIDCard.frame.size.height + 10;
    self.btnAddEdit.frame = f;
    [self.btnAddEdit setTitle:@"Add ID Info" forState:UIControlStateNormal];

}
-(IBAction)companyLogoClicked:(id)sender
{
    [self.view endEditing:YES];
    [[Singleton sharedSingleton] CameraClicked:self.view Control:self.COMPANY_btnCompanyLogo];
}


#pragma  mark  ******* ADD/VIEW ICE CONTACT *********

-(void)AddICEContactDetail
{
    [self.view endEditing:YES];
     if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
    }
    else
    {
        
        
//        Name, ContactNumber , Userid
        NSString * name =  [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.ICECONTACT_name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSString * number =  [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.ICECONTACT_phoneno.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        if([name isEqualToString:@""] || [number isEqualToString:@""] )
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_EMPTY_DATA message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else if(number.length < 4)
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Mobile length should be atleast 4 or more" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else
        {
            [self startActivity];
            self.btnICESave.userInteractionEnabled = NO;
            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
            NSString * userId ;
            if([st objectForKey:@"UserId"])
            {
                userId =  [st objectForKey:@"UserId"];
            }
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:userId forKey:@"UserId"];
            [dict setValue:name forKey:@"Name"];
            [dict setValue:number forKey:@"ContactNumber"];
            if(![ICEID isEqualToString:@""])
            {
                [dict setValue:ICEID forKey:@"ICEID"];
            }
            
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 NSLog(@"Save ICE CONTACT Info  :  %@ -- ", dict);
                 self.btnICESave.userInteractionEnabled = YES;
                 
                 if (dict)
                 {
                     Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                     if (!strCode)
                     {
                          [self stopActivity];
                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alt show];
                     }
                     else
                     {
                         [self getICEContactDetail];
                       
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"message"]  message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         alert.tag = 13;
                         [alert show];
                         [self stopActivity];
                     }
                 }
                 else
                 {
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     [self stopActivity];
                 }
             } :@"ICE/AddICEContact" data:dict];
        }
    }
}
-(void)getICEContactDetail
{
    [self.view endEditing:YES];
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
        
        self.tblviewICE.hidden = YES;
        self.viewICEDetail.hidden = YES;
        
        CGRect f = self.btnSave.frame;
        f.origin.y = self.viewMyIDCard.frame.origin.y + self.viewMyIDCard.frame.size.height + 10;
        self.btnSave.frame = f;
        
        f = self.btnViewMyId.frame;
        f.origin.x = self.btnSave.frame.origin.x + self.btnSave.frame.size.width +5 ;
        f.origin.y = self.viewMyIDCard.frame.origin.y + self.viewMyIDCard.frame.size.height + 10 ;
        self.btnViewMyId.frame = f;
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
             [self stopActivity];
             NSLog(@"GET ICE CONTACT Info  :  %@ -- ", dict);
             if (dict)
             {
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     
                     self.tblviewICE.hidden = YES;
                     self.viewICEDetail.hidden = YES;
                     
                     self.btnViewMyId.hidden = NO;
                     self.btnSave.hidden = NO;
                     
                     CGRect f = self.btnSave.frame;
                     f.origin.y = self.viewMyIDCard.frame.origin.y + self.viewMyIDCard.frame.size.height + 10;
                     self.btnSave.frame = f;
                     
                     f = self.btnViewMyId.frame;
                     f.origin.x = self.btnSave.frame.origin.x + self.btnSave.frame.size.width +5 ;
                     f.origin.y = self.viewMyIDCard.frame.origin.y + self.viewMyIDCard.frame.size.height + 10 ;
                     self.btnViewMyId.frame = f;
                   
                 }
                 else
                 {
                     if([[dict objectForKey:@"data"] count] > 0)
                     {
                         [[Singleton sharedSingleton] setarrICEContactDetail:[dict objectForKey:@"data"]];
                      
                         arrICEContactDetail = [[NSMutableArray alloc] init];
                         [arrICEContactDetail addObject:[dict objectForKey:@"data"]];
                         
                         self.tblviewICE.hidden = NO;
                         [self.tblviewICE reloadData];
                         
                          self.viewICEDetail.hidden = NO;
                         self.btnViewMyId.hidden = NO;
                         self.btnSave.hidden = NO;
                         
                         CGRect f = self.btnSave.frame;
                         f.origin.x = self.viewICEDetail.frame.origin.x + 10;
                         f.origin.y = self.viewICEDetail.frame.origin.y + self.viewICEDetail.frame.size.height + 5;
                         self.btnSave.frame = f;
                         
                         f = self.btnViewMyId.frame;
                         f.origin.x = self.btnSave.frame.origin.x + self.btnSave.frame.size.width +5 ;
                         f.origin.y = self.viewICEDetail.frame.origin.y + self.viewICEDetail.frame.size.height +5 ;
                         self.btnViewMyId.frame = f;
                     }
                     else
                     {
                         self.tblviewICE.hidden = YES;
                         self.btnViewMyId.hidden = NO;
                         self.btnSave.hidden = NO;
                         
                         
                         CGRect f = self.btnSave.frame;
                         f.origin.y = self.viewMyIDCard.frame.origin.y + self.viewMyIDCard.frame.size.height + 10;
                         self.btnSave.frame = f;
                         
                         f = self.btnViewMyId.frame;
                         f.origin.x = self.btnSave.frame.origin.x + self.btnSave.frame.size.width +5 ;
                         f.origin.y = self.viewMyIDCard.frame.origin.y + self.viewMyIDCard.frame.size.height + 10 ;
                         self.btnViewMyId.frame = f;
                     }
                 }
             }
             else
             {
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
             }
         } :@"ICE/GetICEContact" data:dict];
    }
}
-(IBAction)ICECancelClicked:(id)sender
{
    [self.viewICEAddContact removeFromSuperview];
}
#pragma  mark  **** ADD/VIEW MEDICAITON

-(void)getICEMeditcationDetail
{
    [self.view endEditing:YES];
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
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
             [self stopActivity];
             NSLog(@"GET ICE Meditcation Info  :  %@ -- ", dict);
             if (dict)
             {
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     
                     self.viewDetail.hidden=YES;
                     self.viewAddEditDetail.hidden= YES;
                     self.viewCompanyIDDetail.hidden = YES;
                     self.viewCompanyAddEditDetail.hidden = YES;
                     self.viewICEDetail.hidden = YES;
                     self.viewICEMeditcationDetail.hidden=YES;
                     
                     self.btnAddEdit.hidden = NO;
                     self.btnSave.hidden = YES;
                     self.btnViewMyId.hidden = YES;
                     
                     CGRect f = self.btnAddEdit.frame;
                     f.origin.y = self.viewICEID.frame.origin.y + self.viewICEID.frame.size.height + 10;
                     
                     self.btnAddEdit.frame = f;
                     [self.btnAddEdit setTitle:@"Add Meditcation" forState:UIControlStateNormal];
                     
                 }
                 else
                 {
                     if([[dict objectForKey:@"data"] count] > 0)
                     {
                         [[Singleton sharedSingleton] setarrICEMeditcation:[dict objectForKey:@"data"]];
                         arrICEMeditcation = [[NSMutableArray alloc] init];
                         [arrICEMeditcation addObject:[dict objectForKey:@"data"]];
                         
                         [self filleupICEMeditcationDetail];
                      }
                     else
                     {
                         self.viewDetail.hidden=YES;
                         self.viewAddEditDetail.hidden= YES;
                         self.viewCompanyIDDetail.hidden = YES;
                         self.viewCompanyAddEditDetail.hidden = YES;
                         self.viewICEDetail.hidden = YES;
                         self.viewICEMeditcationDetail.hidden=YES;
                         
                         self.btnAddEdit.hidden = NO;
                         self.btnSave.hidden = YES;
                         self.btnViewMyId.hidden = YES;
                         
                         CGRect f = self.btnAddEdit.frame;
                         f.origin.y = self.viewICEID.frame.origin.y + self.viewICEID.frame.size.height + 10;
                         self.btnAddEdit.frame = f;
                         [self.btnAddEdit setTitle:@"Add Meditcation" forState:UIControlStateNormal];
                     }
                 }
             }
             else
             {
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
             }
         } :@"ICE/GetICEMeditcation" data:dict];
    }
}
-(void)saveICEMditcationDetail
{
    pickerBloodType.hidden=YES;
    [self.view endEditing:YES];
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
    }
    else
    {
        
      
//        NSString * name =  [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.ICEMEDITCATION_lblname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
//        NSString * number =  [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.ICEMEDITCATION_lblnumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        NSString *bloodType = [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.ICEMEDITCATION_Add_btnBloodType.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
     //   NSString * bloodType =  [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.ICEMEDITCATION_Add_txtBloodType.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
          NSString * alergise =  [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.ICEMEDITCATION_Add_txtAllergies.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
          NSString * Chronic =  [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.ICEMEDITCATION_Add_txtChronic.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
          NSString * Contradication =  [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.ICEMEDITCATION_Add_txtContratication.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        if( [bloodType isEqualToString:@""] || [alergise isEqualToString:@""] || [Chronic isEqualToString:@""] || [Contradication isEqualToString:@""])
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_EMPTY_DATA message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
            if(![ICEMeditcationID isEqualToString:@""])
            {
                [dict setValue:ICEMeditcationID forKey:@"ICEMeditcationID"];
            }
            [dict setValue:bloodType forKey:@"BloodType"];
            [dict setValue:alergise forKey:@"Allergies"];
            [dict setValue:Chronic forKey:@"ChronicDisease"];
            [dict setValue:Contradication forKey:@"Contratications"];
         
            
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 [self stopActivity];
                 NSLog(@"SAVE ICE Meditcation Info  :  %@ -- ", dict);
                 if (dict)
                 {
                     Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                     if (!strCode)
                     {
                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alt show];
                         
                         [self btnICEIDClicked:nil];
//                         self.viewDetail.hidden=YES;
//                         self.viewAddEditDetail.hidden= YES;
//                         self.viewCompanyIDDetail.hidden = YES;
//                         self.viewCompanyAddEditDetail.hidden = YES;
//                         self.viewICEDetail.hidden = YES;
//                         self.viewICEMeditcationDetail.hidden=YES;
//                         
//                         self.btnAddEdit.hidden = NO;
//                         self.btnSave.hidden = YES;
//                         self.btnViewMyId.hidden = YES;
//                         
//                         CGRect f = self.btnAddEdit.frame;
//                         f.origin.y = self.viewICEID.frame.origin.y + self.viewICEID.frame.size.height + 10;
//                         self.btnAddEdit.frame = f;
//                         [self.btnAddEdit setTitle:@"Add Meditcation" forState:UIControlStateNormal];
                         
                     }
                     else
                     {
                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alt show];
                         
                         if([dict objectForKey:@"data"] > 0)
                         {
                             [[Singleton sharedSingleton] setarrICEMeditcation:[dict objectForKey:@"data"]];
                             if([[[Singleton sharedSingleton] getarrICEMeditcation] count] > 0)
                             {
                                 arrICEMeditcation = [[NSMutableArray alloc] init];
                                 
                                 [arrICEMeditcation addObject:[[Singleton sharedSingleton] getarrICEMeditcation]  ];
                                 [self filleupICEMeditcationDetail];
                             }
                         }
                         
                         [self.viewICEMeditcationAddEdit removeFromSuperview];
                         
//                         [self getICEMeditcationDetail];

                     }
                 }
                 else
                 {
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                 }
             } :@"ICE/AddICEMeditcation" data:dict];
        }
       
    }
}

-(void)filleupICEMeditcationDetail
{
    self.viewDetail.hidden=YES;
    self.viewAddEditDetail.hidden= YES;
    self.viewCompanyIDDetail.hidden = YES;
    self.viewCompanyAddEditDetail.hidden = YES;
    self.viewICEDetail.hidden = YES;
    self.viewICEMeditcationDetail.hidden=NO;
    
    self.btnAddEdit.hidden = NO;
    self.btnSave.hidden = YES;
    self.btnViewMyId.hidden = YES;
    
    
//    data =     {
//        Allergies = "aler...";
//        BloodType = "A +ve";
//        ChronicDisease = "chrno...";
//        Code = 0;
//        Contratications = "Contradication :";
//        ICEMeditcationID = "3e1beefc-22af-46c8-b69f-4415a1b3e049";
//        Message = "<null>";
//        UserId = "bb1f9253-ae44-44a1-8427-94d1a0e71dfc";
//    };
    
    
    ICEMeditcationID = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEMeditcation objectAtIndex:0] objectForKey:@"ICEMeditcationID"]]];
    
    if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEMeditcation objectAtIndex:0] objectForKey:@"Photo"]] isEqualToString:@""])
    {
        if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEMeditcation objectAtIndex:0] objectForKey:@"Photo"]] isEqualToString:@""])
        {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
            dispatch_async(queue, ^{
                NSData *imageData;
                UIImage *image;
                NSString *imgStr =[[arrICEMeditcation objectAtIndex:0] objectForKey:@"Photo"];
                if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:imgStr] isEqualToString:@""])
                {
                    NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, imgStr];
                    image =  [[Singleton sharedSingleton] getImageFromCache:[imageName lastPathComponent]];
                    
                    if(image != nil)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.ICEMEDITCATION_btnprofilepic setBackgroundImage:image forState:UIControlStateNormal];
                            
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
                        
                        [[Singleton sharedSingleton] saveImageInCache:image ImgName:[[arrICEMeditcation objectAtIndex:0] objectForKey:@"Photo"]];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if(image == nil)
                            {
                                
                                [self.ICEMEDITCATION_btnprofilepic setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
                            }
                            else{
                                
                                [self.ICEMEDITCATION_btnprofilepic setBackgroundImage:image forState:UIControlStateNormal];
                            }
                        });
                    }
                }
                
            });

        }
    }
   

    self.ICEMEDITCATION_lblname.text = [NSString stringWithFormat:@"%@ %@",[[Singleton sharedSingleton] ISNSSTRINGNULL: [[arrICEMeditcation objectAtIndex:0] objectForKey:@"FirstName"]], [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEMeditcation objectAtIndex:0] objectForKey:@"LastName"]]];
   
    self.ICEMEDITCATION_lblnumber.text = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEMeditcation objectAtIndex:0] objectForKey:@"ContactNumber"]]];
   
    
    self.ICEMEDITCATION_lblbloodType.text = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEMeditcation objectAtIndex:0] objectForKey:@"BloodType"]]];
    
    self.ICEMEDITCATION_lblalergise.text = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEMeditcation objectAtIndex:0]  objectForKey:@"Allergies"]]];

    CGRect ff = self.ICEMEDITCATION_lblalergise.frame;
    ff.size.height = ceilf([[Singleton sharedSingleton] heightOfTextForLabel:self.ICEMEDITCATION_lblalergise.text andFont:self.ICEMEDITCATION_lblalergise.font maxSize:CGSizeMake(self.ICEMEDITCATION_lblalergise.frame.size.width, 20000)].height);
    self.ICEMEDITCATION_lblalergise.frame = ff;
    
    
    self.ICEMEDITCATION_lblChronic.text = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEMeditcation objectAtIndex:0] objectForKey:@"ChronicDisease"]]];
     ff = self.ICEMEDITCATION_lblChronic.frame;
    ff.origin.y = self.ICEMEDITCATION_lblalergise.frame.origin.y + self.ICEMEDITCATION_lblalergise.frame.size.height + 2;
    ff.size.height = ceilf([[Singleton sharedSingleton] heightOfTextForLabel:self.ICEMEDITCATION_lblChronic.text andFont:self.ICEMEDITCATION_lblChronic.font maxSize:CGSizeMake(self.ICEMEDITCATION_lblChronic.frame.size.width, 20000)].height);
    self.ICEMEDITCATION_lblChronic.frame = ff;
    
    ff = self.ICEMEDITCATION_Label_chronic.frame;
    ff.origin.y = self.ICEMEDITCATION_lblChronic.frame.origin.y ;
    self.ICEMEDITCATION_Label_chronic.frame = ff;
    
    
    self.ICEMEDITCATION_lblContradication.text = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrICEMeditcation objectAtIndex:0]  objectForKey:@"Contratications"]]];
    ff = self.ICEMEDITCATION_lblContradication.frame;
    ff.origin.y =  self.ICEMEDITCATION_lblChronic.frame.origin.y + self.ICEMEDITCATION_lblChronic.frame.size.height + 2;
    ff.size.height = ceilf([[Singleton sharedSingleton] heightOfTextForLabel:self.ICEMEDITCATION_lblContradication.text andFont:self.ICEMEDITCATION_lblContradication.font maxSize:CGSizeMake(self.ICEMEDITCATION_lblContradication.frame.size.width, 20000)].height);
    self.ICEMEDITCATION_lblContradication.frame = ff;

    ff = self.ICEMEDITCATION_Label_contradication.frame;
    ff.origin.y = self.ICEMEDITCATION_lblContradication.frame.origin.y ;
    self.ICEMEDITCATION_Label_contradication.frame = ff;
    
    
    ff = self.viewICEMeditcationDetail.frame;
    if(IS_IPAD)
    {
        ff.size.height = self.ICEMEDITCATION_lblContradication.frame.origin.y + self.ICEMEDITCATION_lblContradication.frame.size.height + 45;
    }
    else
    {
         ff.size.height = self.ICEMEDITCATION_lblContradication.frame.origin.y + self.ICEMEDITCATION_lblContradication.frame.size.height + 10;
    }
    self.viewICEMeditcationDetail.frame = ff;
    
   ff = self.ICEMEDITCATION_btnBg.frame;
   if(IS_IPAD)
   {
       ff.size.height = self.ICEMEDITCATION_lblContradication.frame.origin.y + self.ICEMEDITCATION_lblContradication.frame.size.height - 120;
   }
    else
    {
         ff.size.height = self.ICEMEDITCATION_lblContradication.frame.origin.y + self.ICEMEDITCATION_lblContradication.frame.size.height - 80 ;
    }
    self.ICEMEDITCATION_btnBg.frame = ff;
    
//    ff= self.btnAddEdit.frame;
//    ff.origin.y = self.viewICEMeditcationDetail.frame.origin.y + self.viewICEMeditcationDetail.frame.size.height + 10;
//    self.btnAddEdit.frame = ff;
//    [self.btnAddEdit setTitle:@"Edit Meditcation" forState:UIControlStateNormal];

//    self.viewICEMeditcationDetail.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view-ice-id_old2.png"]];
   
//    [self.ICEMEDITCATION_btnBgTop setBackgroundImage:[UIImage imageNamed:@"view-ice-id-bg-top.png"] forState:UIControlStateNormal];
    if(IS_IPAD)
    {
        [self.ICEMEDITCATION_btnBgTop setBackgroundImage:[UIImage imageNamed:@"view-ice-id-top_iPad.png"] forState:UIControlStateNormal];
        
        [self.ICEMEDITCATION_btnBg setBackgroundImage:[UIImage imageNamed:@"view-ice-id-bottom1_iPad.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.ICEMEDITCATION_btnBgTop setBackgroundImage:[UIImage imageNamed:@"view-ice-id-top.png"] forState:UIControlStateNormal];
        
        [self.ICEMEDITCATION_btnBg setBackgroundImage:[UIImage imageNamed:@"view-ice-id-bottom1.png"] forState:UIControlStateNormal];
    }
   
    
    ff= self.btnAddEdit.frame;
    ff.origin.y = self.viewICEMeditcationDetail.frame.origin.y + self.viewICEMeditcationDetail.frame.size.height + 10;
    self.btnAddEdit.frame = ff;
    [self.btnAddEdit setTitle:@"Edit Meditcation" forState:UIControlStateNormal];

    
//    view-ice-id-bg-top.png
//    view-ice-id-bottom.png
    
}

//-------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 12)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(alertView.tag == 13)
    {
        [self.viewICEAddContact removeFromSuperview];
    }
    else if(alertView.tag == 14)
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
}

-(IBAction)ICEMedictionCancelClicked:(id)sender
{
    pickerBloodType.hidden=YES;
    [self.viewICEMeditcationAddEdit removeFromSuperview];
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
    
    if(theTextField == self.COMPANY_txtPostalCode)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS_ZIPCODE] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else if(theTextField == self.COMPANY_txtPhoneNo)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS_MOBILE] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else if(theTextField == self.MYID_ADD_txtPhoneno)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS_MOBILE] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else if(theTextField == self.ICECONTACT_phoneno)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS_MOBILE] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }

    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField==self.MYID_ADD_txtName)
    {
        [self.MYID_ADD_txtName resignFirstResponder];
        [self.MYID_ADD_txtSurname becomeFirstResponder];
    }
    else if (textField==self.MYID_ADD_txtSurname)
    {
        [self.MYID_ADD_txtSurname resignFirstResponder];
        [self.MYID_ADD_txtGivenName becomeFirstResponder];
    }
    else if (textField==self.MYID_ADD_txtGivenName)
    {
        [self.MYID_ADD_txtGivenName resignFirstResponder];
        [self.MYID_ADD_txtFamilyName becomeFirstResponder];
    }
    else if (textField==self.MYID_ADD_txtFamilyName)
    {
        [self.MYID_ADD_txtFamilyName resignFirstResponder];
        [self.MYID_ADD_txtparentName becomeFirstResponder];
//        self.MYID_ADD_scrollview.contentOffset=CGPointMake(0, 40);
    }
    else if (textField==self.MYID_ADD_txtparentName)
    {
        [self.MYID_ADD_txtparentName resignFirstResponder];
       [self.MYID_ADD_txtPhoneno becomeFirstResponder];
        if(!IS_IPAD)
        {
           self.MYID_ADD_scrollview.contentOffset=CGPointMake(0, 40);
        }
    }
    else if (textField==self.MYID_ADD_txtPhoneno)
    {
        [self.MYID_ADD_txtPhoneno resignFirstResponder];
        [self.MYID_ADD_IDNumber becomeFirstResponder];
        if(!IS_IPAD)
        {
            self.MYID_ADD_scrollview.contentOffset=CGPointMake(0, 90);
        }
    }
    else if (textField==self.MYID_ADD_IDNumber)
    {
        [self.MYID_ADD_IDNumber resignFirstResponder];
         self.MYID_ADD_scrollview.contentOffset=CGPointMake(0, 0);
    }
    else if(textField == self.COMPANY_txtCompanyName)
    {
        [self.COMPANY_txtCompanyName resignFirstResponder];
        [self.COMPANY_txtIdNumber becomeFirstResponder];
    }
    else if(textField == self.COMPANY_txtIdNumber)
    {
        [self.COMPANY_txtIdNumber resignFirstResponder];
        [self.COMPANY_txtPhoneNo becomeFirstResponder];
    }
    else if(textField == self.COMPANY_txtPhoneNo)
    {
        [self.COMPANY_txtPhoneNo resignFirstResponder];
        [self.COMPANY_txtWebsite becomeFirstResponder];
    }
    else if(textField == self.COMPANY_txtWebsite)
    {
        [self.COMPANY_txtWebsite resignFirstResponder];
        [self.COMPANY_txtvatNumber becomeFirstResponder];
    }
    else if(textField == self.COMPANY_txtvatNumber)
    {
        [self.COMPANY_txtvatNumber resignFirstResponder];
        [self.COMPANY_txtPostalCode  becomeFirstResponder];
    }
    else if(textField == self.COMPANY_txtPostalCode)
    {
        [self.COMPANY_txtPostalCode resignFirstResponder];
       
    }
    else if(textField == self.ICECONTACT_name)
    {
        [self.ICECONTACT_name resignFirstResponder];
        [self.ICECONTACT_phoneno becomeFirstResponder];
    }
    else if(textField == self.ICECONTACT_phoneno)
    {
        [self.ICECONTACT_phoneno resignFirstResponder];
    }
    else if(textField == self.ICEMEDITCATION_Add_txtAllergies)
    {
        [self.ICEMEDITCATION_Add_txtAllergies resignFirstResponder];
        [self.ICEMEDITCATION_Add_txtChronic becomeFirstResponder];
        
    }
    else if(textField == self.ICEMEDITCATION_Add_txtChronic)
    {
        [self.ICEMEDITCATION_Add_txtChronic resignFirstResponder];
        [self.ICEMEDITCATION_Add_txtContratication becomeFirstResponder];
        
    }
    else if(textField == self.ICEMEDITCATION_Add_txtContratication)
    {
        [self.ICEMEDITCATION_Add_txtContratication resignFirstResponder];
    }
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    pickerBloodType.hidden = YES;
    self.picker_DOB.hidden = YES;
    self.pickerCountry.hidden =YES;
    self.pickerCountryIpad.hidden = YES;
    
    if(!IS_IPAD)
    {
        if(textField == self.MYID_ADD_txtPhoneno)
        {
            self.MYID_ADD_scrollview.contentOffset=CGPointMake(0, 50);
        }
//        else if(textField == self.MYID_ADD_IDNumber)
//        {
//            self.MYID_ADD_scrollview.contentOffset=CGPointMake(0, 90);
//        }
    }
   
    return YES;
}
-(void)hideKeyboard
{
    pickerBloodType.hidden = YES;
    self.picker_DOB.hidden = YES;
    self.pickerCountry.hidden =YES;
    self.pickerCountryIpad.hidden = YES;
    
    
    if(!IS_IPAD)
    {
        CGRect f = self.tblviewICE.frame;
        f.size.height = 120;
        self.tblviewICE.frame = f;
    }
    
    self.MYID_ADD_scrollview.contentOffset=CGPointMake(0, 0);
    
    [self.MYID_ADD_IDNumber resignFirstResponder];
    [self.MYID_ADD_txtFamilyName resignFirstResponder];
    [self.MYID_ADD_txtGivenName resignFirstResponder];
    [self.MYID_ADD_txtName resignFirstResponder];
    [self.MYID_ADD_txtparentName resignFirstResponder];
    [self.MYID_ADD_txtPhoneno resignFirstResponder];
    [self.MYID_ADD_txtSurname resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    pickerBloodType.hidden = YES;
    self.MYID_ADD_scrollview.contentOffset=CGPointMake(0, 0);
    
    self.pickerCountryIpad.hidden = YES;
    
    [super touchesBegan:touches withEvent:event];
}
#pragma mark - UITEXTVIEW
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(!IS_IPAD)
    {
        self.COMPANY_scrollview.contentOffset=CGPointMake(0,80);
    }
    self.COMPANY_txtAddress.text = @"";
    self.COMPANY_txtAddress.textColor = [UIColor blackColor];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.COMPANY_scrollview.contentOffset=CGPointMake(0, 0);
    [self.COMPANY_txtAddress resignFirstResponder];
    if(self.COMPANY_txtAddress.text.length == 0)
    {
        self.COMPANY_txtAddress.textColor = [UIColor lightGrayColor];
        self.COMPANY_txtAddress.text = @"Address";
        
    }
    return YES;
}

#pragma mark UIPICKER methods

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
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
    
//    label.text = [NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"CountryName"]];
    
    if(self.btnCountryDone.tag == 1)
    {
        label.text = [NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"CountryName"]];
    }
    else if(self.btnCountryDone.tag == 2)
    {
        label.text = [NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"StateName"]];
    }
    else if(self.btnCountryDone.tag == 3)
    {
        //blood type
        label.text = [NSString stringWithFormat:@"  %@", [arrBloodType objectAtIndex:row]];
        [self.ICEMEDITCATION_Add_btnBloodType setTitle:[NSString stringWithFormat:@"  %@", [arrBloodType objectAtIndex:0]] forState:UIControlStateNormal];
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
//    return [[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] count];
    if(self.btnCountryDone.tag == 1)
    {
        return [[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] count];
    }
    else if(self.btnCountryDone.tag == 2)
    {
        return [[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0] count];
    }
    else if(self.btnCountryDone.tag == 3)
    {
        return [arrBloodType count];
    }
    return 0;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
//    return [NSString stringWithFormat:@"  %@", [[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] objectAtIndex:row]];
    
    if(self.btnCountryDone.tag == 1)
    {
        return  [NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"CountryName"]];
    }
    else if(self.btnCountryDone.tag == 2)
    {
        return [NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"StateName"]];
    }
    else if(self.btnCountryDone.tag == 3)
    {
        return [NSString stringWithFormat:@"  %@", [arrBloodType objectAtIndex:row]];
    }
    return @"";
}
// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    [self.MYID_ADD_btnCountry setTitle:[NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"CountryName"]] forState:UIControlStateNormal];
//    countryID =[NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"CountryId"]];
    
    if(self.btnCountryDone.tag == 1)
    {
        [self.MYID_ADD_btnCountry setTitle:[NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"CountryName"]] forState:UIControlStateNormal];
        
       // countryId = [NSString stringWithFormat:@"%d", row]; //[[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"CountryId"];
        
        countryID = [NSString stringWithFormat:@" %@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"CountryId"]]; //[[Singleton sharedSingleton] getCountryIdFromIndexId:self.btnCountry.titleLabel.text];
        
        self.MYID_ADD_btnState.enabled = NO;
        stateID=@"";
        [self.MYID_ADD_btnState setTitle:@"  Select State" forState:UIControlStateNormal];
        [self startActivity];
        [[Singleton sharedSingleton] getStateList: countryID];
    }
    else if(self.btnCountryDone.tag == 2)
    {
        [self.MYID_ADD_btnState setTitle:[NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"StateName"] ] forState:UIControlStateNormal];
        
       // stateId = [NSString stringWithFormat:@"%d", row]; //[[[[[Singleton sharedSingleton] arrStateList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"StateID"];
        
        stateID = [NSString stringWithFormat:@" %@", [[[[[Singleton sharedSingleton] arrStateList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"StateID"]];
        
    }
    else if(self.btnCountryDone.tag == 3)
    {
        [self.ICEMEDITCATION_Add_btnBloodType setTitle:[NSString stringWithFormat:@"%@", [arrBloodType objectAtIndex:row]] forState:UIControlStateNormal];
    }
}

#pragma mark TableView Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([arrICEContactDetail count] > 0)
    {
        return [[arrICEContactDetail objectAtIndex:0] count];
    }
    else
    {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPAD)
    {
        return 50;
    }
    else
    {
        return 35;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    if(IS_IPAD)
    {
        simpleTableIdentifier = @"ICEcell_iPad";
    }
    else
    {
        simpleTableIdentifier = @"ICEcell";
    }
        
    ICEcell *cell = (ICEcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    cell.lblname.text = [NSString stringWithFormat:@"%@", [[[arrICEContactDetail objectAtIndex:0]objectAtIndex:indexPath.row] objectForKey:@"Name"]];
    NSLog(@"indexPath.row+1 : %d", indexPath.row+1);
    NSLog(@"indexPath.row+1 2 : %@", [NSString stringWithFormat:@"%d", indexPath.row+1]);

    cell.lblSr.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
    NSLog(@"indexPath.row+1 3 : %@", cell.lblSr.text);

    cell.btnNumber.tag = indexPath.row;
    [cell.btnNumber addTarget:self action:@selector(phoneNumberClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
-(void)phoneNumberClicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSString *number = [[[arrICEContactDetail objectAtIndex:0]objectAtIndex:btn.tag] objectForKey:@"ContactNumber"];
    [[Singleton sharedSingleton] CALLPhoneNumberProgrammatically:number];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[[ Singleton sharedSingleton] getarrICEContactDetail] count] > 0)
    {
        self.ICECONTACT_name.text =  [NSString stringWithFormat:@"%@", [[[arrICEContactDetail objectAtIndex:0]objectAtIndex:indexPath.row] objectForKey:@"Name"]];
      
        self.ICECONTACT_phoneno.text =  [[[arrICEContactDetail objectAtIndex:0]objectAtIndex:indexPath.row] objectForKey:@"ContactNumber"];
        
        [self.btnICESave setTitle:@"Save" forState:UIControlStateNormal];
        
    }
    ICEID = [NSString stringWithFormat:@"%@", [[[arrICEContactDetail objectAtIndex:0]objectAtIndex:indexPath.row] objectForKey:@"ICEID"]];
    
    [self.ICECONTACT_name becomeFirstResponder];
    [self.view addSubview:self.viewICEAddContact];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)viewWillDisappear:(BOOL)animated
{
   //[[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
