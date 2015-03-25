//
//  OfferCell.m
//  Loyalty App
//
//  Created by Amit Parmar on 19/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "OfferCell.h"
#import "Singleton.h"
#import <QuartzCore/QuartzCore.h>
@implementation OfferCell
@synthesize lblDistance, lblOfferName, lblRestName, lblShortOfferName, btnRating, btnStartRate, btnDiamond;

- (void)awakeFromNib
{
    // Initialization code
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.contentView andSubViews:YES];
    btnRating.layer.cornerRadius=5.0;
    btnRating.clipsToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    btnRating.selected = NO;

    // Configure the view for the selected state
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    btnRating.highlighted = NO;
}
@end
