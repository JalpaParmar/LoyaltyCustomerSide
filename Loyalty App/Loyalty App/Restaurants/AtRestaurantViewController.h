//
//  AtRestaurantViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 7/22/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AtRestaurantViewController : UIViewController
{
    AppDelegate *app;
    NSArray *_pickerTableNoData;
    int indexId;
    NSMutableArray *arrTableList;
    NSMutableArray *arrName, *arrIcons;
    NSString *TableId, *callId;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    BOOL IS_Order_StartDelete;
    IBOutlet UILabel *lblTableName,* lblCancelCall;
    IBOutlet UIButton *btnBackCallWaiter, *btnBackCancelCall, *btnIconCallWaiter, *btnIconCancelCall;
    
    
}
@property (strong, nonatomic) IBOutlet UITableView *tblAtRestaurant;

@property (strong, nonatomic) IBOutlet UITextField *txtPincode;
@property (strong, nonatomic) IBOutlet UIButton  *btnCancel; //*btnSubmit,
@property (strong, nonatomic) IBOutlet UIView *viewPincode;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerTableNo;
- (IBAction)TableNoClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnTableNo;
@property (strong, nonatomic) IBOutlet UIView *viewTableNo;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmitTableNo;


- (IBAction)btnBackClick:(id)sender;
- (IBAction)submitTableNoClicked:(id)sender;

//- (IBAction)submitPincodeClicked:(id)sender;
- (IBAction)callWaiterClicked:(id)sender;
- (IBAction)CancelcallWaiterClicked:(id)sender;

//- (IBAction)billPleaseClicked:(id)sender;
//- (IBAction)makeBillWithoutWaiterClicked:(id)sender;

@end
