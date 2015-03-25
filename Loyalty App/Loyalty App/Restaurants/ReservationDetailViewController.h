//
//  ReservationDetailViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationDetailViewController : UIViewController
{
    NSArray *arrSelectTable;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollvw;

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
@property (strong, nonatomic) IBOutlet UIButton *btnSave;


-(IBAction)btnDateDoneClick:(id)sender;
- (IBAction)selectDateTimeClicked:(id)sender;
- (IBAction)selectTableClicked:(id)sender;
- (IBAction)btnSaveClicked:(id)sender;

- (IBAction)btnBackClick:(id)sender;


-(IBAction)DateTimeSelectClicked:(id)sender;
@end
