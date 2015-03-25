//
//  RewardCell.m
//  Loyalty App
//
//  Created by Amit Parmar on 19/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "RewardCell.h"
#import "Singleton.h"
@implementation RewardCell

- (void)awakeFromNib
{
    // Initialization code
    
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.contentView andSubViews:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
//    if (selected) {
//        self.btnOnlyUsed.backgroundColor = self.btnOnlyUsed.backgroundColor;
//        //[UIColor blackColor];
//        self.btnOnlyRedeem.backgroundColor = self.btnOnlyUsed.backgroundColor;
//
////        [UIColor blackColor];
//    }
//    else {
//        self.btnOnlyUsed.backgroundColor =  self.btnOnlyUsed.backgroundColor;
////        [UIColor blackColor];
//        self.btnOnlyRedeem.backgroundColor = self.btnOnlyRedeem.backgroundColor;
////        [UIColor blackColor];
//    }
    self.btnOnlyUsed.selected  = NO;
     self.btnOnlyRedeem.selected  = NO;
    // Configure the view for the selected state
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
//    if (highlighted) {
//        self.btnOnlyUsed.backgroundColor = self.btnOnlyUsed.backgroundColor;
////[UIColor blackColor];
//         self.btnOnlyRedeem.backgroundColor = self.btnOnlyRedeem.backgroundColor;
//    }
//    else {
//        self.btnOnlyUsed.backgroundColor = self.btnOnlyUsed.backgroundColor;
////[UIColor blackColor];
//         self.btnOnlyRedeem.backgroundColor = self.btnOnlyRedeem.backgroundColor;
//    }
    self.btnOnlyUsed.highlighted=NO;
     self.btnOnlyRedeem.highlighted=NO;
}

@end
