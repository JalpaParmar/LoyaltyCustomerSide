//
//  MyLoyaltyCardView.h
//  Loyalty App
//
//  Created by Amit Parmar on 18/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addCardViewController.h"
#import "DBManager.h"
#import "addCardViewControllerNew.h"

@interface MyLoyaltyCardView : UIViewController <addCardViewControllerNewDelegate>
{
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    IBOutlet UICollectionView *collectionViewBarcode, *collectionViewCustomerCard;
    AppDelegate *app;
    NSMutableArray *arrMyIDCardDetail, *arrDiamondDetail;
    NSString *CardMasterId;
    NSData *imageData;
    IBOutlet UIButton *btnBG;
    UIImageView *imgLargeBarcode;
    IBOutlet UIView *viewSeparator;
    IBOutlet UIScrollView *scrollView;
}
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrCardInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblNoCards;
@property(strong,nonatomic)BarButton *btnBar;
@property(strong,nonatomic)IBOutlet UICollectionView *collectionViewBarcode;

- (IBAction)btnbackClick:(id)sender;
-(IBAction)AddViewBarcodeClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleMyCard;
@end
