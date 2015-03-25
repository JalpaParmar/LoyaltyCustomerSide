//
//  addRestaurantViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface addRestaurantViewController : UIViewController<UIAlertViewDelegate>
{
    AppDelegate *app;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    NSString *countryId, *stateId, *countryDBID, *stateDBID;
    IBOutlet UIButton *btnbackOfPicker;
}
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UITextField *txtFullName;
@property (strong, nonatomic) IBOutlet UIButton *btnCountry;
@property (strong, nonatomic) IBOutlet UIButton *btnState;
@property (strong, nonatomic) IBOutlet UITextField *txtStreetLine1;
@property (strong, nonatomic) IBOutlet UITextField *txtStreetLine2;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtZipcode;
@property (strong, nonatomic) IBOutlet UITextField *txtMobile;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlView;
@property (strong, nonatomic) IBOutlet UIView *viewCountryState;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerCountryState;
@property (strong, nonatomic) IBOutlet UIButton *btnDoneCountryState;

@property (strong, nonatomic) IBOutlet UIView *viewbackForm;

- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnSaveClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleAddRestaurant;

@end
