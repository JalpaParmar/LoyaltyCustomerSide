//
//  addCardViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 8/13/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ZBarSDK.h"
#import "DBManager.h"

@protocol addCardViewControllerNewDelegate <NSObject>
-(void)loadAllCards;
-(void)loadData;
@end

@interface addCardViewControllerNew : UIViewController < UIImagePickerControllerDelegate, ZBarReaderDelegate>
{
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    AppDelegate *app;
    NSString *strImgEncoded, *strImgFilename, *CardMasterId, *strPathFirst, *strPathSecond;
    int indexId;
    IBOutlet UIView *viewbackForm;
    IBOutlet UILabel *lblTakePhoto, *lblTakePhoto1;
    IBOutlet UIImageView *imgBarcodeImg, *imgBarcodeImg1;
}
@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) id<addCardViewControllerNewDelegate> delegate;
@property(nonatomic, assign) int indexId;
@property (strong, nonatomic) IBOutlet UIButton *btnCamera;
@property (strong, nonatomic) IBOutlet UIButton *btnBarcodeImg, *btnBarcodeImg1;

@property (strong, nonatomic) IBOutlet UITextField *txtBarcodeName, *txtBarcodeID;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UILabel *lblAddCard;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

- (IBAction)btnSaveClicked:(id)sender;
- (IBAction)btnCameraClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleMyCard;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleAddCard;

@end
