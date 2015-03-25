//
//  BarButton.h
//  Loyalty App
//
//  Created by Amit Parmar on 17/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class BarButton;

@interface BarButton : UIView
{
    AppDelegate *app;
}
    @property(strong,nonatomic)UIButton *btnHome;
    @property(strong,nonatomic)UIButton *btnNearBy;
    @property(strong,nonatomic)UIButton *btnMyLoyality;
    @property(strong,nonatomic)UIButton *btnOrder;

-(void)nearMeClicked;
-(void)homeClicked;
-(void)loyaltyClicked;
-(void)oderListClicked;


@end
