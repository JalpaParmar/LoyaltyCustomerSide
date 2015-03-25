//
//  RewardCell.m
//  Loyalty App
//
//  Created by Amit Parmar on 19/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "orderHistoryCell.h"
#import "Singleton.h"

@implementation orderHistoryCell

- (void)awakeFromNib
{
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.contentView andSubViews:YES];
   
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.btnReview.backgroundColor = [UIColor blackColor];
    }
    else {
        self.btnReview.backgroundColor = [UIColor blackColor];
    }
    self.btnReview.selected  = NO;
    // Configure the view for the selected state
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.btnReview.backgroundColor = [UIColor blackColor];
    }
    else {
        self.btnReview.backgroundColor = [UIColor blackColor];
    }
    self.btnReview.highlighted=NO;
}

@end
