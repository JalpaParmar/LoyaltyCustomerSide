//
//  DashboardView.m
//  Loyalty App
//
//  Created by Amit Parmar on 18/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "DashboardView.h"
#import "Restaurants/RestaurantView.h"
#import "LoyaltyCard/MyLoyaltyCardView.h"
#import "Special Offer/SpecialOfferView.h"
#import "MyrewardView.h"
#import "MyAccountView.h"
#import "AppDelegate.h"
#import "settingViewController.h"
#import "notificationViewController.h"
#import "addRestaurantViewController.h"
#import "FavoriteViewController.h"
#import "Singleton.h"
#import "NewProgramViewController.h"
#import "ViewController.h"
#import "paymentViewController.h"
#import "ListViewController.h"
#import "HelpViewController.h"

@interface DashboardView ()
@end

@implementation DashboardView
@synthesize btnBar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
              
//        for (NSString *familyName in [UIFont familyNames]) {
//            for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
//                NSLog(@"%@", fontName);
//            }
//        }
//        
//        
//        for(NSString *fontfamilyname in [UIFont familyNames])
//        {
//            NSLog(@"Family:'%@'",fontfamilyname);
//            for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
//            {
//                NSLog(@"\tfont:'%@'",fontName);
//            }
//            NSLog(@"~~~~~~~~");
//        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    app = APP;
    [self.view addSubview:[app setFooterPart]];
    app._flagMainBtn = 2;
    
    app._flagFromLogout = 0;
    
    if(app._skipRegister == 1)
    {
        self.lblSetting.text=@"Login";
        [self.btnSetting setImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
    }
    
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
    
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Button Click Event


- (IBAction)btnFavoriteClicked:(id)sender {
    
    if(app._skipRegister == 1)
    {
        [[Singleton sharedSingleton] errorLoginFirst];
    }
    else
    {
        FavoriteViewController *favorite;
        if (IS_IPHONE_5)
        {
            favorite=[[FavoriteViewController alloc] initWithNibName:@"FavoriteViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            favorite=[[FavoriteViewController alloc] initWithNibName:@"FavoriteViewController_iPad" bundle:nil];
        }
        else
        {
            favorite=[[FavoriteViewController alloc] initWithNibName:@"FavoriteViewController" bundle:nil];
        }
        [self.navigationController pushViewController:favorite animated:YES];
    }
}

- (IBAction)btnNotificationClicked:(id)sender
{
    if(app._skipRegister == 1)
    {
        [[Singleton sharedSingleton] errorLoginFirst];
    }
    else
    {
        ListViewController *notification;
        if (IS_IPHONE_5)
        {
            notification=[[ListViewController alloc] initWithNibName:@"ListViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            notification=[[ListViewController alloc] initWithNibName:@"ListViewController_iPad" bundle:nil];
        }
        else
        {
            notification=[[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
        }
        [self.navigationController pushViewController:notification animated:YES];
    }
}

- (IBAction)btnSettingClicked:(id)sender {
    
    if(app._skipRegister == 1)
    {
        //[[Singleton sharedSingleton] errorLoginFirst];
        
        app._flagFromLogout = 1;
       
        NSUserDefaults *login=[NSUserDefaults standardUserDefaults];
        [login removeObjectForKey:@"userFirstName"];
        [login removeObjectForKey:@"userLastName"];
        [login removeObjectForKey:@"userMobileNo"];
        [login removeObjectForKey:@"UserId"];
        [login removeObjectForKey:@"userEMail"];
        [login synchronize];
        
        [FBSession.activeSession close];
        [FBSession.activeSession  closeAndClearTokenInformation];
        FBSession.activeSession=nil;
        
        [[Singleton sharedSingleton] resetAllArrayAndVariables];
        
        ViewController *view;
        if (IS_IPHONE_5)
        {
            view=[[ViewController alloc] initWithNibName:@"ViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            view=[[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
        }
        else
        {
            view=[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
        }
        [app.navObj pushViewController:view animated:YES];
        
    }
    else
    {
        settingViewController *setting;
        if (IS_IPHONE_5)
        {
            setting=[[settingViewController alloc] initWithNibName:@"settingViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            setting=[[settingViewController alloc] initWithNibName:@"settingViewController_iPad" bundle:nil];
        }
        else
        {
            setting=[[settingViewController alloc] initWithNibName:@"settingViewController" bundle:nil];
        }
        [self.navigationController pushViewController:setting animated:YES];
    }
    
}

- (IBAction)btnAddRestaurantClicked:(id)sender {
    
    
    if(app._skipRegister == 1)
    {
         [[Singleton sharedSingleton] errorLoginFirst];
    }
    else
    {
        addRestaurantViewController *addRest;
        if (IS_IPHONE_5)
        {
            addRest=[[addRestaurantViewController alloc] initWithNibName:@"addRestaurantViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            addRest=[[addRestaurantViewController alloc] initWithNibName:@"addRestaurantViewController_iPad" bundle:nil];
        }
        else
        {
            addRest=[[addRestaurantViewController alloc] initWithNibName:@"addRestaurantViewController" bundle:nil];
        }
        [self.navigationController pushViewController:addRest animated:YES];
    }
    
}

- (IBAction)btnRestauClick:(id)sender
{
    RestaurantView *restauView;
   
    if (IS_IPHONE_5)
    {
        restauView=[[RestaurantView alloc] initWithNibName:@"RestaurantView-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        restauView=[[RestaurantView alloc] initWithNibName:@"RestaurantView_iPad" bundle:nil];
    }
    else
    {
        restauView=[[RestaurantView alloc] initWithNibName:@"RestaurantView" bundle:nil];
    }
     restauView.fromDashboardFlag=1;
    [self.navigationController pushViewController:restauView animated:YES];
}

- (IBAction)btnCardClick:(id)sender
{
    if(app._skipRegister == 1)
    {
        NewProgramViewController *cardView;
        if (IS_IPHONE_5)
        {
            cardView=[[NewProgramViewController alloc] initWithNibName:@"NewProgramViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            cardView=[[NewProgramViewController alloc] initWithNibName:@"NewProgramViewController_iPad" bundle:nil];
        }
        else
        {
            cardView=[[NewProgramViewController alloc] initWithNibName:@"NewProgramViewController" bundle:nil];
        }
        [self.navigationController pushViewController:cardView animated:YES];
        
    }
    else
    {
        MyLoyaltyCardView *cardView;
        if (IS_IPHONE_5)
        {
            cardView=[[MyLoyaltyCardView alloc] initWithNibName:@"MyLoyaltyCardView-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            cardView=[[MyLoyaltyCardView alloc] initWithNibName:@"MyLoyaltyCardView_iPad" bundle:nil];
        }
        else
        {
            cardView=[[MyLoyaltyCardView alloc] initWithNibName:@"MyLoyaltyCardView" bundle:nil];
        }
        [self.navigationController pushViewController:cardView animated:YES];
    }
}

- (IBAction)btnOfferClick:(id)sender
{
    SpecialOfferView *offerView;
    if (IS_IPHONE_5)
    {
        offerView=[[SpecialOfferView alloc] initWithNibName:@"SpecialOfferView-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        offerView=[[SpecialOfferView alloc] initWithNibName:@"SpecialOfferView_iPad" bundle:nil];
    }
    else
    {
        offerView=[[SpecialOfferView alloc] initWithNibName:@"SpecialOfferView" bundle:nil];
    }
    [self.navigationController pushViewController:offerView animated:YES];
}

- (IBAction)btnMyrewardClick:(id)sender
{
    
    if(app._skipRegister == 1)
    {
       [[Singleton sharedSingleton] errorLoginFirst];
    }
    else
    {
        MyrewardView *rewardView;
        if (IS_IPHONE_5)
        {
            rewardView=[[MyrewardView alloc] initWithNibName:@"MyrewardView-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            rewardView=[[MyrewardView alloc] initWithNibName:@"MyrewardView_iPad" bundle:nil];
        }
        else
        {
            rewardView=[[MyrewardView alloc] initWithNibName:@"MyrewardView" bundle:nil];
        }
        rewardView.fromWhere = @"Dashboard";
        [self.navigationController pushViewController:rewardView animated:YES];
    }
    
}

- (IBAction)btnAccountClick:(id)sender
{
    
    if(app._skipRegister == 1)
    {
       [[Singleton sharedSingleton] errorLoginFirst];
    }
    else
    {
        MyAccountView *accView;
        if (IS_IPHONE_5)
        {
            accView=[[MyAccountView alloc] initWithNibName:@"MyAccountView-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            accView=[[MyAccountView alloc] initWithNibName:@"MyAccountView_iPad" bundle:nil];
        }
        else
        {
            accView=[[MyAccountView alloc] initWithNibName:@"MyAccountView" bundle:nil];
        }
        [self.navigationController pushViewController:accView animated:YES];
    }
}

-(IBAction)btnHelpClicked:(id)sender
{
    HelpViewController *payView;
    if (IS_IPHONE_5)
    {
        payView=[[HelpViewController alloc] initWithNibName:@"HelpViewController-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        payView=[[HelpViewController alloc] initWithNibName:@"HelpViewController_iPad" bundle:nil];
    }
    else
    {
        payView=[[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    }
    [self.navigationController pushViewController:payView animated:YES];
}
@end
