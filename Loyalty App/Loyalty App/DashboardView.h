//
//  DashboardView.h
//  Loyalty App
//
//  Created by Amit Parmar on 18/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarButton.h"
#import "AppDelegate.h"

@interface DashboardView : UIViewController
{
    BarButton *btnBar;
    AppDelegate *app;
}
@property(strong,nonatomic)BarButton *btnBar;
//
- (IBAction)btnFavoriteClicked:(id)sender;
//- (IBAction)btnNotificationClicked:(id)sender;
//- (IBAction)btnSettingClicked:(id)sender;
//- (IBAction)btnAddRestaurantClicked:(id)sender;

- (IBAction)btnRestauClick:(id)sender;
- (IBAction)btnCardClick:(id)sender;
- (IBAction)btnOfferClick:(id)sender;
- (IBAction)btnMyrewardClick:(id)sender;
- (IBAction)btnAccountClick:(id)sender;
- (IBAction)btnSettingClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblSetting;
@property (strong, nonatomic) IBOutlet UIButton *btnSetting;
@property (strong, nonatomic) IBOutlet UIButton *btnSettingBack;


@end
