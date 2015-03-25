//
//  settingViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@protocol CommonDelegateClass <NSObject>
-(void)LocationSelectionDone:(NSMutableArray*)arrSelectionValue;
-(void)BackFromSelectionView;
@end


@protocol CommonDelegateClass;
@interface CommonDelegateViewController : UIViewController<CommonDelegateClass>
{
    AppDelegate *app;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    IBOutlet UIButton *btnCountry, *btnState, *btnCity;
    NSString *countryId, *stateId, *cityId, *countryDBID, *stateDBID, *cityDBID;
    BOOL IS_FIRST;
    IBOutlet UIView *viewBack;
    IBOutlet UITextField *txtLocation;
    IBOutlet UITableView *tblLocationList;
       NSMutableArray *arrLocation;
    NSNumber *strLatitude;
    NSNumber *strLongitude;
    IBOutlet UIButton *btnSelectRange;
    IBOutlet UIPickerView *pickerRange;
    NSArray *arrRange, *arrRangeOnlyNumber;
}
- (IBAction)btnBackClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit, *btnCancel;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerCity;
@property (strong, nonatomic) IBOutlet UIButton *btnCityDone;

@property (nonatomic, strong) id<CommonDelegateClass> delegate;

-(IBAction)btnSubmitClicked:(id)sender;
-(IBAction)btnSelectRangeClicked:(id)sender;

@end
