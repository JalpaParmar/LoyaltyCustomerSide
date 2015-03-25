//
//  addOrderViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 7/23/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface addOrderViewController : UIViewController
{
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    AppDelegate *app;
    NSArray *_pickerQtyData;
    int itemIndexId, indexId;
    float itemPrice, itemDiscount, itemTax;
    NSString *itemName, *itemPriceSign, *itemID;
    NSMutableArray *arrPlacedOrder;
}
@property (strong, nonatomic) IBOutlet UIImageView *imgRestaurantIcon;
@property (strong, nonatomic) IBOutlet UIView *viewItemDetail;

@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantName;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantTimeMinOrder;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantItemName;
@property (strong, nonatomic) IBOutlet UITableView *tblAddOrder;
@property (strong, nonatomic) IBOutlet UITextField *txtQtry;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantItemPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPrice;


@property (nonatomic, assign) int itemIndexId;
@property (strong, nonatomic) IBOutlet UIButton *btnDoneQty;
@property (strong, nonatomic) IBOutlet UIView *viewPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerQty;
@property (strong, nonatomic) IBOutlet UIButton *btnQty;
@property (strong, nonatomic) IBOutlet UIScrollView *scrllView;
@property (strong, nonatomic) IBOutlet UIButton *btnProceed;
@property (strong, nonatomic) IBOutlet UIButton *btnAddAniotherItem;
@property (strong, nonatomic) IBOutlet UITextView *txtareaSpecialRemark;
-(IBAction)QtyBtnClicked:(id)sender;
-(IBAction)QtybtnDoneClicked:(id)sender;

//-(IBAction)paymentNowClicked:(id)sender;
-(IBAction)addAnotherOrderClicked:(id)sender;
- (IBAction)btnBackClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleAddOrder;

@end
