//
//  RestaCell.m
//  Loyalty App
//
//  Created by Amit Parmar on 18/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "RestaCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Singleton.h"

@implementation RestaCell
@synthesize imgHotel,lblAddress,lblAmnt,lblKM,lblName,lblTime,btnRate, btnStar, btnTimeIcon;

- (void)awakeFromNib
{
    // Initialization code
    self.btnRate.layer.cornerRadius = 5.0;
    self.btnRate.clipsToBounds = YES;
    
   [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.contentView andSubViews:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    self.btnRate.selected = NO;
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.btnRate.highlighted = NO;
}
@end
