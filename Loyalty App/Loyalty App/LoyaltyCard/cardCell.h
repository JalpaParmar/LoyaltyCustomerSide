//
//  cardCell.h
//  Loyalty App
//
//  Created by Amit Parmar on 19/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cardCell : UICollectionViewCell
{
    IBOutlet UILabel *lblBarcodeName;
    IBOutlet UIButton *btnbarcodeImg, *btnEdit;
    IBOutlet UIButton *btnBGMain;
    IBOutlet UIImageView *imgbarcodeImg;
}

@property (strong, nonatomic) IBOutlet UIButton *btnBGMain, *btnEdit;
@property (strong, nonatomic) IBOutlet UIButton *btnbarcodeImg;
@property (strong, nonatomic) IBOutlet UILabel *lblBarcodeName;
 @property (strong, nonatomic) IBOutlet UIImageView *imgbarcodeImg;
@end
