//
//  ProfileDetailViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ProfileDetailViewController : UIViewController
{
    AppDelegate *app;
    NSString *countryId, *stateId, *countryDBID, *stateDBID, *strDOB;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    NSMutableArray *arrProfileData;
    IBOutlet UIView *viewCustomerQRCode;
    IBOutlet UILabel *lblCustomerId;
    IBOutlet UIImageView *imgQRCode;
}
//View Profile

@property (strong, nonatomic) IBOutlet UILabel *lblFullname;
@property (strong, nonatomic) IBOutlet UILabel *lblContactNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblDOB;
@property (strong, nonatomic) IBOutlet UILabel *lblCompanyname;
@property (strong, nonatomic) IBOutlet UILabel *lblEmailID;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnProfileforView;



// Add Profile
@property (strong, nonatomic) IBOutlet UIButton *btnProfile;
@property (strong, nonatomic) IBOutlet UIButton *btnDOB;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstname;
@property (strong, nonatomic) IBOutlet UITextField *txtlastname;
@property (strong, nonatomic) IBOutlet UITextField *txtContactnumber;
//@property (strong, nonatomic) IBOutlet UITextField *txtDOB;
@property (strong, nonatomic) IBOutlet UITextField *txtCompanyName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmailID;
@property (strong, nonatomic) IBOutlet UITextField *txtStreetLine1;
@property (strong, nonatomic) IBOutlet UIView *viewAddProfile;
@property (strong, nonatomic) IBOutlet UIView *viewFilledUpProfile;
@property (strong, nonatomic) IBOutlet UITextField *txtStreetLine2;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtZipCode;
@property (strong, nonatomic) IBOutlet UIButton *btnState;
@property (strong, nonatomic) IBOutlet UIButton *btnCountry;
@property (strong, nonatomic) IBOutlet UIView *viewCountryState;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerCountryState;
@property (strong, nonatomic) IBOutlet UIButton *btnDoneCountryState;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UIDatePicker *pickerDate;
@property (nonatomic, strong) NSMutableData *imageData;
@property (strong, nonatomic) IBOutlet UIButton *backEditButton;

- (IBAction)btnDoneCountryStateClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnEditProfile;
- (IBAction)btnEditProfileClicked:(id)sender;
- (IBAction)btnProfilePicClicked:(id)sender;
- (IBAction)btnStateClicked:(id)sender;
- (IBAction)btnCountryClicked:(id)sender;
- (IBAction)btnDOBClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleProfile;

@end
