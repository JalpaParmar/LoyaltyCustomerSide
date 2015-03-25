//
//  RestaurantView.h
//  Loyalty App
//
//  Created by Amit Parmar on 18/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CommonDelegateViewController.h"

@protocol CommonDelegateClass;

@interface RestaurantView : UIViewController<CommonDelegateClass>
{
    UITableView *tblHotel;
    AppDelegate *app;
    NSArray *_pickerCityData;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    NSMutableArray *arrRestaurantList;
    IBOutlet UIButton *btnCountry, *btnState, *btnCity, *btnNearBySearch, *btnFilterBySearch;
    IBOutlet UITextField *txtCity;
    NSString *countryId, *stateId, *cityId, *countryDBID, *stateDBID, *cityDBID;
    int fromDashboardFlag, tempFlag;
}
@property(nonatomic, assign) int fromDashboardFlag;
@property (strong, nonatomic) IBOutlet UIToolbar *btnToolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnBarDone;
@property (strong, nonatomic) IBOutlet UIView *viewFilter;
@property (strong, nonatomic) IBOutlet UIButton *btnCity;
@property (strong, nonatomic) IBOutlet UITextField *txtArea;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit, *btnCancel;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerCity;
@property (strong, nonatomic) IBOutlet UIView *viewCity;
@property (strong, nonatomic) IBOutlet UIButton *btnCityDone;
@property (strong, nonatomic) IBOutlet UIButton *btnFilterList;
@property (strong, nonatomic) IBOutlet UIButton *btnMap;

@property(strong,nonatomic)IBOutlet UITableView *tblView;
//- (IBAction)btnFilterClick:(id)sender;
- (IBAction)btnBackClick:(id)sender;
- (IBAction)filterCitywiseClicked:(id)sender;
//- (IBAction)filterSubmitClicked:(id)sender;
//- (IBAction)filterCancelClicked:(id)sender;
//- (IBAction)filterNearByClicked:(id)sender;

//- (IBAction)doneCityPickerClicked:(id)sender;

- (IBAction)btnMapClick:(id)sender;
-(void)getRestaurantList;
@end
