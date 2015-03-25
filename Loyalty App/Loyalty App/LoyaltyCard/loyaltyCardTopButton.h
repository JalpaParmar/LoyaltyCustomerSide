//
//  BarButton.h
//  Loyalty App
//
//  Created by Amit Parmar on 17/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class loyaltyCardTopButton;

@interface loyaltyCardTopButton : UIView
{
    AppDelegate *app;
}
    @property(strong,nonatomic)UIButton *btnMyCard;
    @property(strong,nonatomic)UIButton *btnICEInfo;
    @property(strong,nonatomic)UIButton *btnNewProgram;
    @property(strong,nonatomic)UIButton *btnLoyaltyProgram;

-(void)MyCardClicked;
-(void)ICEInfoClicked;
-(void)NewProgramClicked;
-(void)LoyaltyProgramClicked;


@end
