//
//  RestaCell.m
//  Loyalty App
//
//  Created by Amit Parmar on 18/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "HomeDelivery.h"
#import <QuartzCore/QuartzCore.h>
#import "Singleton.h"

@implementation HomeDelivery
@synthesize  lblAmnt, lblName, btnItemIcon, imgArrow; //imgHotel,lblAddress,lblAmnt,lblKM,lblName,lblTime,btnKm;

- (void)awakeFromNib
{
    // Initialization code

    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.contentView andSubViews:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    self.btnItemIcon.selected = NO;
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.btnItemIcon.highlighted = NO;
}
@end
