//
//  SpecialOfferView.h
//  Loyalty App
//
//  Created by Amit Parmar on 19/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CommonDelegateViewController.h"

@protocol CommonDelegateClass;

@interface SpecialOfferView : UIViewController <CommonDelegateClass>
{
    AppDelegate *app;
    UITableView *tblOffer;
    NSMutableArray *arrSpecialOffer;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    IBOutlet  UIButton *btnNearBySearch, *btnFilterBySearch;
}
@property (strong, nonatomic) IBOutlet UIButton *btnBG;
- (IBAction)hideParentView:(id)sender;
- (IBAction)btnFilterByClicked:(id)sender;

- (IBAction)btnQRCodeClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblQRCode;
@property (strong, nonatomic) IBOutlet UIButton *btnQRCode;


@property (strong, nonatomic) IBOutlet UITableView *tblOffer;
- (IBAction)btnBackClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *viewQRCode;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleSpecialOffer;
@property (strong, nonatomic) IBOutlet UIButton *btnQRCodeSearch;

@end
