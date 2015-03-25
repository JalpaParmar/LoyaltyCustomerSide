//
//  addOrderViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 7/23/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface OrderDetailViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>
{
    AppDelegate *app;
    NSMutableArray *arrOrderDetail;
    NSArray *arrHeaderText;
    int globalTotalQty, deleteIndexFlag;
    float globalTotalPrice;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    NSString *OrderStatus, *_fromWhere, *strURL, *selectedOrderId, *globalQty, *orderDetailId, *currncySign, *deleteItemId;
    BOOL IS_CHANGED;
    IBOutlet UIButton *btnAddOrder, *btnSave, *btnCancel, *btnBGBack;
    IBOutlet UITextField *txtCQty, *txtNQty;
    IBOutlet UIView *viewEditQty, *viewEditeBoard;
    
    NSMutableArray *arrRedeemPoints;
    int flag_updateQty_fromWhere;
    
    float tax;
}
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UILabel *lblPoints, *lbltextPoints;
@property (strong, nonatomic) IBOutlet UIButton *btnBgPoints;
@property(nonatomic, strong) NSString  *_fromWhere, *selectedOrderId;
@property (strong, nonatomic) IBOutlet UIView *viewFooterTotalOrder;
@property (strong, nonatomic) IBOutlet UITableView *tblOrderDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalItem;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscounts;
@property (strong, nonatomic) IBOutlet UILabel *lblTax;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (strong, nonatomic) IBOutlet UIView *viewFooterButton;
@property (strong, nonatomic) IBOutlet UIButton *btnHold;
@property (strong, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UIButton *btnCancle;
- (IBAction)btnSendClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblNoOrderDetail;
-(void)startActivity;
-(void)stopActivity;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleOrderDetail;

- (IBAction)btnSaveClicked:(id)sender;
- (IBAction)btnCancelClicked:(id)sender;
- (IBAction)hideParentView:(id)sender;


@end
