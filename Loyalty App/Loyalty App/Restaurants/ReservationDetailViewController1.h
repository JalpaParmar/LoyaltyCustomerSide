//
//  ReservationDetailViewController1.h
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ReservationDetailViewController1 : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray *arrSelectTable, *arrValidateTable;
    int indexId;
    AppDelegate *app;
    NSString *selectDate, *startTime, *endTime, *tableId, *tableType, *strURL;
    IBOutlet UIView *backgroundIndicatorView, *viewBackForm;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    BOOL IS_Validation_Start;
}
@property (strong, nonatomic) IBOutlet UIView *viewBG;
@property(nonatomic, assign) int DateTime_Tag;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectDate;
@property (strong, nonatomic) IBOutlet UIButton *btnStartTime;
@property (strong, nonatomic) IBOutlet UIButton *btnEndTime;
@property (strong, nonatomic) IBOutlet UIButton *btnSelecetTable;
@property (strong, nonatomic) IBOutlet UITextView *txtOtherReq;
@property (strong, nonatomic) IBOutlet UIDatePicker *pickerDateTime;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerTable;
@property (strong, nonatomic) IBOutlet UIButton *btnDateDone;
@property (strong, nonatomic) IBOutlet UITextField *txtTotalPerson;

@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollvw;


//-(IBAction)btnDateDoneClick:(id)sender;
- (IBAction)selectDateTimeClicked:(id)sender;

- (IBAction)selectTableClicked:(id)sender;
- (IBAction)btnSaveClicked:(id)sender;

- (IBAction)btnBackClick:(id)sender;
//-(IBAction)hideKeyboard:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleReservation;

@end
