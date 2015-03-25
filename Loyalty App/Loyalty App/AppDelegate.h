//
//  AppDelegate.h
//  Loyalty App
//
//  Created by Amit Parmar on 17/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

//E7E1C087D407ACD061A8AD67ED2797E39A935E6E

#import <UIKit/UIKit.h>
#import "BarButton.h"
#import <CoreLocation/CoreLocation.h>
#import "SKPSMTPMessage.h"

@class ViewController;
@class BarButton;
@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, SKPSMTPMessageDelegate>
{
    CLLocationManager *locationManager;
    double lat, lon;
    NSString *alert_type, *restaurantId, *soundID, *programId, *offerId;
}
@property (assign, nonatomic)  double lat, lon;
@property (assign, nonatomic) int _skipRegister;
@property (assign, nonatomic) int _flagMainBtn, _flagMyLoyaltyTopButtons, _flagFromLogout;
@property (strong, nonatomic) UIWindow *window;
@property(strong, nonatomic)ViewController *viewObj;
@property(strong, nonatomic)UINavigationController *navObj;
//+(BarButton*)setFooterPart;
-(UIView*)setFooterPart;
-(UIView*)setMyLoyaltyTopPart;

@end
