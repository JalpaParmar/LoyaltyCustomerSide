//
//  RestaurantJoinedViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 8/13/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LBorderView.h"

@interface specialOfferDetailViewController : UIViewController
{
    AppDelegate *app;
    NSMutableArray *arrRestaurantSpecialOfferDetail;
    int joinIndexId;
}
@property (nonatomic, assign) int joinIndexId;
@property (nonatomic, strong) NSMutableArray *arrRestaurantSpecialOfferDetail;

@property (strong, nonatomic) IBOutlet UIButton *btnRestaurantDetail;

@property (strong, nonatomic) IBOutlet UIImageView *imgRestaurantIcon;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantDistance;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantName;

@property (strong, nonatomic) IBOutlet UIView *viewForOffer;

@property (strong, nonatomic) IBOutlet LBorderView *viewForDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblOffer;
@property (strong, nonatomic) IBOutlet UILabel *lblExpiryDate;
@property (strong, nonatomic) IBOutlet UIButton *btnQRCodeImage;
@property (strong, nonatomic) IBOutlet UILabel *lblQRCode;

- (IBAction)btnbackClick:(id)sender;
- (IBAction)btnRestaurantDetailClicked:(id)sender;
//- (IBAction)btnJoinClicked:(id)sender;
//@property (strong, nonatomic) IBOutlet UIImageView *imgQRCode;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleSpecialDetail;

@end
