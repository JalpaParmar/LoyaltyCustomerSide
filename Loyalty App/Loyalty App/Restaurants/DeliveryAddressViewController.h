//
//  addOrderViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 7/23/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface DeliveryAddressViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    AppDelegate *app;
    NSString *countryId, *countryDBID, *stateDBID, *strURL, *email, *dob, *storeName, *cashMode, *CurrencyCode, *countryCodeISO2;
    CGPoint svos;
    NSMutableArray*arrProfileData;
    
    IBOutlet UITableView *tblLocationList;
    NSMutableArray *arrLocation;
    NSNumber *strLatitude;
    NSNumber *strLongitude;
    IBOutlet UILabel *lblLoading;
    BOOL IS_POSSIBLE_HOMEDELIVERY;
    BOOL IS_SELECT_CASHMODE;
    float res_minimuDistance;
    NSString *distance;
    
    IBOutlet UITextField *txtOTP;
    IBOutlet UIButton *btnOTPSend, *btnOTPResend;
    
    
}
@property (strong, nonatomic) IBOutlet UIButton *radioButton2;
@property (strong, nonatomic) IBOutlet UIButton *radioButton1;
@property (nonatomic, assign) NSString *currencyCode;
@property (nonatomic, assign) float orderTotal;
@property (nonatomic, strong) NSMutableArray *arrProfileData;
@property (strong, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIButton *btnDeliveredToAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UITextField *txtFirtname;
@property (strong, nonatomic) IBOutlet UITextField *txtLastname;

@property (strong, nonatomic) IBOutlet UITextField *txtAddress1;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress2;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtState;
@property (strong, nonatomic) IBOutlet UITextField *txtZipcode;
@property (strong, nonatomic) IBOutlet UIButton *btnCountry;
@property (strong, nonatomic) IBOutlet UITextField *txtphoneNumber;
@property (strong, nonatomic) IBOutlet UIView *viewNewAddress;
@property (strong, nonatomic) IBOutlet UIView *viewOldAddress;
@property (strong, nonatomic) IBOutlet UIView *viewAllButtons;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UIView *viewPickerCountry;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerCountry;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

//edit time

@property (strong, nonatomic) IBOutlet UITextField *txtEdit_fullname;
//@property (strong, nonatomic) IBOutlet UIButton *btnbackFullname;
@property (strong, nonatomic) IBOutlet UITextView *txtEdit_address;
@property (strong, nonatomic) IBOutlet UIButton *btnbackCity;
@property (strong, nonatomic) IBOutlet UITextField *txtEdit_phone;
@property (strong, nonatomic) IBOutlet UIButton *btnbackState;



- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnDeliveredClick:(id)sender;
- (IBAction)btnDoneClicked:(id)sender;

@end
