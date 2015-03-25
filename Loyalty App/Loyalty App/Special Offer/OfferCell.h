//
//  OfferCell.h
//  Loyalty App
//
//  Created by Amit Parmar on 19/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferCell : UITableViewCell
{
    IBOutlet UILabel *lblRestName, *lblShortOfferName, *lblOfferName, *lblDistance;
    IBOutlet  UIButton *btnRating, *btnStartRate, *btnDiamond;
}
@property(strong,nonatomic)IBOutlet UILabel *lblRestName, *lblShortOfferName, *lblOfferName, *lblDistance;
@property(strong,nonatomic)IBOutlet  UIButton *btnRating, *btnStartRate, *btnDiamond;
@end
