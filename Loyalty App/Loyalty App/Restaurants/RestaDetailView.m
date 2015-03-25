//
//  RestaDetailView.m
//  Loyalty App
//
//  Created by Amit Parmar on 18/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "RestaDetailView.h"
#import <QuartzCore/QuartzCore.h>
#import "OrderProcessViewController.h"
#import "ReservationDetailViewController.h"
#import "ReservationDetailViewController1.h"
#import "Singleton.h"
#import "RestaurantView.h"
#import "FavoriteViewController.h"
#import "specialOfferDetailViewController.h"
#import "RestaurantJoinedViewController.h"
#import "orderListViewController.h"
#import "chatViewController.h"
#import "mapViewController.h"
#import "settingViewController.h"
#import "RestaurantView.h"
#import "ASScroll.h"

#define Zoom_DEFAULTLEVEL 11
#define IPAD_XDISTANCE_TOPBUTTONS 30;
#define IPHONE_XDISTANCE_TOPBUTTONS 30;

@interface RestaDetailView ()
@end

@implementation RestaDetailView
@synthesize scrollView, _fromWhere, IS_PUSHNOTIFICATION, restaurantId_APNS;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
 
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.actIndicatorView_LoyaltyPoints.hidden = NO;
     [self.actIndicatorView_LoyaltyPoints startAnimating];
    app = APP;
    [self.view addSubview:[app setFooterPart]];
    app._flagMainBtn = 0; //2;
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];

    arrLocalRestaurantDetail = [[NSMutableArray alloc] init];
    NSLog(@"IS_PUSHNOTIFICATION : %hhd", IS_PUSHNOTIFICATION);
    if(IS_PUSHNOTIFICATION)
    {
        [self GoToRestaurantDetailPage:restaurantId_APNS];
    }
    else
    {
        indexId = [[Singleton sharedSingleton] getIndexId];
        NSLog(@"selected Index ID : %d", [[Singleton sharedSingleton] getIndexId]);
        NSLog(@"Res list Count: %lu", (unsigned long)[[[Singleton sharedSingleton] getarrRestaurantList] count]);
        arrLocalRestaurantDetail = [[Singleton sharedSingleton] getarrRestaurantList];
        
        [self setupInitailDetailView];
    }
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark SET VIEW
-(void)setupInitailDetailView
{
    
    //    IsHomeDelivery = 0;
    //    IsReservationAcceptance = 0;
    //    IsTakeAway = 0;
    //    IsTherePlaceForChildren = 0; //chat
    //    IsTherePlaceForSmoker = 0; //at res
    
    //chat
    if([[[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"IsTherePlaceForSmoker"] intValue] == 0)
    {
        self.btnChat.hidden = YES;
        self.lblChat.hidden=YES;
    }
    else
    {
        self.btnChat.hidden=NO;
        self.lblChat.hidden=NO;
    }
    
    //reservation
    if([[[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"IsReservationAcceptance"] intValue] == 0)
    {
        //        self.btnReservation.hidden = YES;
        
        // Final Code
        // show only 4 buttons
        //        CGRect f = self.btnCall.frame;
        //        f.origin.x = 30;
        //        self.btnCall.frame = f;
        //
        //        f = self.btnOrder.frame;
        //        f.origin.x = 100;
        //        self.btnOrder.frame = f;
        //
        //        f = self.btnFavorite.frame;
        //        f.origin.x = 170;
        //        self.btnFavorite.frame = f;
        //
        //        f = self.btnChat.frame;
        //        f.origin.x = 240;
        //        self.btnChat.frame = f;
        
        
        //temp code
        
        self.btnReservation.hidden = YES;
        self.lblReservation.hidden = YES;
        
        float a = self.view.frame.size.width/4;
        if(IS_IPAD)
        {
            
            
            if([[[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"IsTherePlaceForSmoker"] intValue] == 0)
            {
                a = a - 25;
            }
            else{
                a = a - 45; //IPAD_XDISTANCE_TOPBUTTONS;
            }
            
            CGRect f = self.btnCall.frame;
            f.origin.x = a;
            self.btnCall.frame = f;
            
            f = self.lblCall.frame;
            f.origin.x = self.btnCall.frame.origin.x - 20;
            self.lblCall.frame = f;
            
            
            f = self.btnOrder.frame;
            f.origin.x = a*2;
            self.btnOrder.frame = f;
            
            f = self.lblOrderNow.frame;
            f.origin.x = self.btnOrder.frame.origin.x - 20;
            self.lblOrderNow.frame = f;
            
            
            f = self.btnFavorite.frame;
            f.origin.x = a*3;
            self.btnFavorite.frame = f;
            
            f = self.lblFavorite.frame;
            f.origin.x = self.btnFavorite.frame.origin.x - 20;
            self.lblFavorite.frame = f;
            
            
            f = self.btnChat.frame;
            f.origin.x = a*4;
            self.btnChat.frame = f;
            
            f = self.lblChat.frame;
            f.origin.x = self.btnChat.frame.origin.x - 20;
            self.lblChat.frame = f;
            
        }
        else
        {
            if([[[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"IsTherePlaceForSmoker"] intValue] == 0)
            {
                CGRect f = self.btnCall.frame;
                f.origin.x = 60;//a;
                self.btnCall.frame = f;
                
                f = self.lblCall.frame;
                f.origin.x = self.btnCall.frame.origin.x - 20;
                self.lblCall.frame = f;
                
                
                f = self.btnOrder.frame;
                f.origin.x = 140; //a*2;
                self.btnOrder.frame = f;
                
                f = self.lblOrderNow.frame;
                f.origin.x = self.btnOrder.frame.origin.x - 20;
                self.lblOrderNow.frame = f;
                
                
                f = self.btnFavorite.frame;
                f.origin.x = 230;//a*3;
                self.btnFavorite.frame = f;
                
                f = self.lblFavorite.frame;
                f.origin.x = self.btnFavorite.frame.origin.x - 20;
                self.lblFavorite.frame = f;
            }
            else{
                CGRect f = self.btnCall.frame;
                f.origin.x = 30;//a;
                self.btnCall.frame = f;
                
                f = self.lblCall.frame;
                f.origin.x = self.btnCall.frame.origin.x - 20;
                self.lblCall.frame = f;
                
                
                f = self.btnOrder.frame;
                f.origin.x = 100; //a*2;
                self.btnOrder.frame = f;
                
                f = self.lblOrderNow.frame;
                f.origin.x = self.btnOrder.frame.origin.x - 20;
                self.lblOrderNow.frame = f;
                
                
                f = self.btnFavorite.frame;
                f.origin.x = 180;//a*3;
                self.btnFavorite.frame = f;
                
                f = self.lblFavorite.frame;
                f.origin.x = self.btnFavorite.frame.origin.x - 20;
                self.lblFavorite.frame = f;
                
                
                f = self.btnChat.frame;
                f.origin.x = 260;//a*4;
                self.btnChat.frame = f;
                
                f = self.lblChat.frame;
                f.origin.x = self.btnChat.frame.origin.x - 20;
                self.lblChat.frame = f;
            }
            
            
        }
        
        
        
        //        //temp - delete it
        //        CGRect f = self.btnCall.frame;
        //        f.origin.x = 30;
        //        self.btnCall.frame = f;
        //
        //        f = self.btnOrder.frame;
        //        f.origin.x = 90;
        //        self.btnOrder.frame = f;
        //
        //        f = self.btnReservation.frame;
        //        f.origin.x = 150;
        //        self.btnReservation.frame = f;
        //
        //        f = self.btnFavorite.frame;
        //        f.origin.x = 210;
        //        self.btnFavorite.frame = f;
        //
        //        f = self.btnChat.frame;
        //        f.origin.x = 265;
        //        self.btnChat.frame = f;
    }
    else if([[[Singleton sharedSingleton] getstrLoginUserChat] intValue] == 0)
    {
        //        self.btnChat.enabled = NO;
    }
    else
    {
        //temp code
        float a = self.view.frame.size.width/5;
        if(IS_IPAD)
        {
            if([[[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"IsTherePlaceForSmoker"] intValue] == 0)
            {
                a = a - 10;
            }
            else{
                a = a - IPAD_XDISTANCE_TOPBUTTONS;
            }
            
            CGRect f = self.btnCall.frame;
            f.origin.x =  a;
            self.btnCall.frame = f;
            
            f = self.lblCall.frame;
            f.origin.x = self.btnCall.frame.origin.x - 20;
            self.lblCall.frame = f;
            
            
            f = self.btnOrder.frame;
            f.origin.x = a*2;
            self.btnOrder.frame = f;
            
            f = self.lblOrderNow.frame;
            f.origin.x = self.btnOrder.frame.origin.x - 20;
            self.lblOrderNow.frame = f;
            
            f = self.btnReservation.frame;
            f.origin.x = a*3;
            self.btnReservation.frame = f;
            
            f = self.lblReservation.frame;
            f.origin.x = self.btnReservation.frame.origin.x - 20;
            self.lblReservation.frame = f;
            
            
            f = self.btnFavorite.frame;
            f.origin.x =  a*4;
            self.btnFavorite.frame = f;
            
            f = self.lblFavorite.frame;
            f.origin.x = self.btnFavorite.frame.origin.x - 20;
            self.lblFavorite.frame = f;
            
            f = self.btnChat.frame;
            f.origin.x = a*5;
            self.btnChat.frame = f;
            
            f = self.lblChat.frame;
            f.origin.x = self.btnChat.frame.origin.x - 20;
            self.lblChat.frame = f;
            
        }
        else
        {
            //a = a - 35; //IPHONE_XDISTANCE_TOPBUTTONS;
            
            CGRect f = self.btnCall.frame;
            f.origin.x = 20; // a;
            self.btnCall.frame = f;
            
            f = self.lblCall.frame;
            f.origin.x = self.btnCall.frame.origin.x - 20;
            self.lblCall.frame = f;
            
            
            f = self.btnOrder.frame;
            f.origin.x = 80; //a*2;
            self.btnOrder.frame = f;
            
            f = self.lblOrderNow.frame;
            f.origin.x = self.btnOrder.frame.origin.x - 20;
            self.lblOrderNow.frame = f;
            
            f = self.btnReservation.frame;
            f.origin.x = 150; //a*3;
            self.btnReservation.frame = f;
            
            f = self.lblReservation.frame;
            f.origin.x = self.btnReservation.frame.origin.x - 20;
            self.lblReservation.frame = f;
            
            
            f = self.btnFavorite.frame;
            f.origin.x =  215;//a*4;
            self.btnFavorite.frame = f;
            
            f = self.lblFavorite.frame;
            f.origin.x = self.btnFavorite.frame.origin.x - 20;
            self.lblFavorite.frame = f;
            
            f = self.btnChat.frame;
            f.origin.x = 275; //a*5;
            self.btnChat.frame = f;
            
            f = self.lblChat.frame;
            f.origin.x = self.btnChat.frame.origin.x - 15;
            self.lblChat.frame = f;
            
        }
        
        
        
        //final Code
        //show 5 buttons
        //        CGRect f = self.btnCall.frame;
        //        f.origin.x = 30;
        //        self.btnCall.frame = f;
        //
        //        f = self.btnOrder.frame;
        //        f.origin.x = 90;
        //        self.btnOrder.frame = f;
        //
        //        f = self.btnReservation.frame;
        //        f.origin.x = 150;
        //        self.btnReservation.frame = f;
        //
        //        f = self.btnFavorite.frame;
        //        f.origin.x = 210;
        //        self.btnFavorite.frame = f;
        //
        //        f = self.btnChat.frame;
        //        f.origin.x = 265;
        //        self.btnChat.frame = f;
    }
    
    self.btnMap.layer.cornerRadius = 5.0;
    self.btnMap.clipsToBounds = YES;
    
    self.btnRate.layer.cornerRadius = 5.0;
    self.btnRate.clipsToBounds = YES;
    self.btnRate.backgroundColor = [UIColor colorWithRed:86.0/255.0 green:190.0/255.0 blue:15.0/255.0 alpha:1];
    
    UIImage *fav = [UIImage imageNamed:@"favorite-active.png"];
    if([_fromWhere isEqualToString:@"FromFavorite"])
    {
        [self.btnFavorite setBackgroundImage:fav forState:UIControlStateNormal];
        
        [self performSelectorInBackground:@selector(getFavoriteOfRestaurant) withObject:nil];
        
    }
    else if([_fromWhere isEqualToString:@"FromRestaurant"])
    {
        [self performSelectorInBackground:@selector(getFavoriteOfRestaurant) withObject:nil];
        
        //FavRestaurantCreatedOn
        if([arrLocalRestaurantDetail count] > 0)
        {
            NSString *IsFav = [[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"FavRestaurantCreatedOn"];
            if([[[Singleton sharedSingleton] ISNSSTRINGNULL:IsFav] isEqualToString:@""])
            {
                [self.btnFavorite setBackgroundImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
            }
            else
            {
                [self.btnFavorite setBackgroundImage:fav forState:UIControlStateNormal];
            }
        }
        
    }
    else
    {
        [self performSelectorInBackground:@selector(getFavoriteOfRestaurant) withObject:nil];
    }
    
     [self performSelector:@selector(setUpMapView) withObject:nil];
    
    [self setupRestaurantAllDetails];
    
    [self setupDetailScrollView];
    
    
    [self performSelectorInBackground:@selector(setupHorizontalScrollView) withObject:nil];
    
    
    //Store Redeem Points
    @try {
        
        if([[[arrLocalRestaurantDetail objectAtIndex:[[Singleton sharedSingleton] getIndexId]] objectForKey:@"restaurantPoints"] count] > 0)
        {
            NSArray *arrPoints = [[arrLocalRestaurantDetail objectAtIndex:[[Singleton sharedSingleton] getIndexId]] objectForKey:@"restaurantPoints"];
            NSLog(@"arrPoints : %@", arrPoints);
            
            if([arrPoints count] > 0)
            {
                [Singleton sharedSingleton].globalRedeemPoints_flag = 1;
            }
        }
        else{
            [Singleton sharedSingleton].globalRedeemPoints_flag = 0;
        }
    }
    @catch (NSException *exception) {
        [Singleton sharedSingleton].globalRedeemPoints_flag = 0;
    }
    
    //Store globalHomeDeliveryDistance
    @try {
        
        [Singleton sharedSingleton].globalHomeDeliveryDistance = [[[arrLocalRestaurantDetail objectAtIndex:[[Singleton sharedSingleton] getIndexId]] objectForKey:@"HomeDeliveryDistance"] floatValue];
        
    }
    @catch (NSException *exception) {
        [Singleton sharedSingleton].globalHomeDeliveryDistance = [[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrLocalRestaurantDetail objectAtIndex:[[Singleton sharedSingleton] getIndexId]] objectForKey:@"HomeDeliveryDistance"]] floatValue];
    }
    if([Singleton sharedSingleton].globalHomeDeliveryDistance <= 0)
    {
        [Singleton sharedSingleton].globalHomeDeliveryDistance =0;
    }
}
-(void)setupRestaurantAllDetails
{
//    NSLog(@" COUNT : %d", [arrLocalRestaurantDetail count]);
    
    if([arrLocalRestaurantDetail count] > 0)
    {
        //distance
        
        //Distance
        double lat, lon;
        @try {
            lat = [[[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"Latidute"] doubleValue];
            lon = [[[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"Longitude"] doubleValue];
        }
        @catch (NSException *exception) {
            lat =  0;
            lon =  0;
        }
         distacne = [[Singleton sharedSingleton] getDistanceBetweenLocations:lat Lon:lon Aontherlat:app.lat AnotheLong:app.lon];
         self.lblRestaurantDistance.text = [NSString stringWithFormat:@"%@", distacne];
        
        //name
        self.lblRestaurantName.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"StoreName"]]];
       
        //address
        NSString *address =  [NSString stringWithFormat:@"%@, %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"StreetLine1"]], [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"StreetLine2"]]];
         address = [[address componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
        self.lblRestaurantAddress.text = address;
        
        self.lblRestaurantEmail.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"EMail"]]];
        self.lblRestaurantPhoneno.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"MobileNo"]]];
        
        self.lblRestaurantMinOrder.text = [NSString stringWithFormat:@"%@ %@ for Home Delivery",[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"CurrencySign"]],  [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"MinimumOrderDollar"]]];
      
        @try {
            [Singleton sharedSingleton].minimumOrder =  [ [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"MinimumOrderDollar"]] floatValue];
        }
        @catch (NSException *exception) {
            [Singleton sharedSingleton].minimumOrder =  0.0;
            

        }
      
        
        
        // Cuisines
//        restaurantCategory =             (
//                                          {
//                                              Attribute1 = "<null>";
//                                              MasterId = 45;
//                                              MasterName = Chinese;
//                                          },
//                                          {
//                                              Attribute1 = "<null>";
//                                              MasterId = 46;
//                                              MasterName = Italian;
//                                          },
//                                          {
//                                              Attribute1 = "<null>";
//                                              MasterId = 47;
//                                              MasterName = Kathiyawadi;
//                                          },
//                                          {
//                                              Attribute1 = "34c48038-7efd-421b-a1ef-c6d614176ace.jpeg";
//                                              MasterId = 53;
//                                              MasterName = Moktail;
//                                          }
//                                          );
        
        
        NSMutableArray *arr = [[NSMutableArray alloc]  init];
        [arr addObject:[[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"restaurantCategory"]];
        
        
        NSArray *aWordArray = [arr valueForKey:@"MasterName"];
        if([aWordArray count] > 0)
        {
            if([[aWordArray objectAtIndex:0] count] > 0)
            {
                self.lblRestaurantCuisines.text = [NSString stringWithFormat:@"%@", [[aWordArray objectAtIndex:0] componentsJoinedByString:@", "]];
                
                CGRect f = self.lblRestaurantCuisines.frame;
                f.size.height = [[Singleton sharedSingleton] getDynamicHeightofLabels:self.lblRestaurantCuisines.text SIZE:CGSizeMake(self.lblRestaurantCuisines.frame.size.width, 200000) FONT:self.lblRestaurantCuisines.font].height;
                self.lblRestaurantCuisines.frame = f;
                
                f = viewAfterMenus.frame;
                f.origin.y = self.lblRestaurantCuisines.frame.origin.y + self.lblRestaurantCuisines.frame.size.height + 3;
                viewAfterMenus.frame = f;
            }
        }
        if([arr count] <= 0 || [self.lblRestaurantCuisines.text isEqualToString:@""])
        {
            self.lblRestaurantCuisines.text=@"Category not available";
        }
        
        //Time
       NSString *search =   [[Singleton sharedSingleton] getCurrentDayName];//@"Monday";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"DayName matches %@ ", search];
        NSArray *array = [[[arrLocalRestaurantDetail objectAtIndex:indexId]objectForKey:@"timingmodel"] filteredArrayUsingPredicate: predicate];
        NSMutableArray *arrTime = [[NSMutableArray alloc] initWithArray:array];
        if([arrTime count] > 0)
        {
            NSString *startTime = [[Singleton sharedSingleton] removePostfixFromTime:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrTime objectAtIndex:0]  objectForKey:@"NoonStartTime"]]];
            NSString *endTime = [[Singleton sharedSingleton] removePostfixFromTime:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrTime objectAtIndex:0]  objectForKey:@"EveningEndTime"]]];
            
            //startTime
            NSString *selectedDateString=startTime; // @"04/03/2013 7pm";
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"HH:mm"];
            NSDate *date = [df dateFromString:selectedDateString];
            if(date == nil)
            {
                [df setDateFormat:@"HH:mm:ss"];
                date = [df dateFromString:selectedDateString];
            }
            [df setDateFormat:@"hh:mm a"];
            //NSLog(@"S TIME 12 HOUR ::: %@", [df stringFromDate:date]);
            startTime = [NSString stringWithFormat:@"%@", [df stringFromDate:date]];
            
            //endTime
            selectedDateString=endTime; // @"04/03/2013 7pm";
            df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"HH:mm"];
            date = [df dateFromString:selectedDateString];
            if(date == nil)
            {
                [df setDateFormat:@"HH:mm:ss"];
                date = [df dateFromString:selectedDateString];
            }
            [df setDateFormat:@"hh:mm a"];
            //NSLog(@"E  TIME 12 HOUR ::: %@", [df stringFromDate:date]);
            endTime = [NSString stringWithFormat:@"%@", [df stringFromDate:date]];
            
            if([[[Singleton sharedSingleton] ISNSSTRINGNULL:startTime] isEqualToString:@""] && [[[Singleton sharedSingleton] ISNSSTRINGNULL:endTime] isEqualToString:@""])
            {
                self.lblRestaurantTiming.text = [NSString stringWithFormat:@"Time not available"];
            }
            else if([[[Singleton sharedSingleton] ISNSSTRINGNULL:startTime]   isEqualToString:@""])
            {
                self.lblRestaurantTiming.text = [NSString stringWithFormat:@"%@", startTime];
            }
            else if([[[Singleton sharedSingleton] ISNSSTRINGNULL:endTime] isEqualToString:@""])
            {
                self.lblRestaurantTiming.text = [NSString stringWithFormat:@"%@", endTime];
            }
            else
            {
                self.lblRestaurantTiming.text = [NSString stringWithFormat:@"%@ to %@", startTime, endTime];
            }
            
        }
         else
         {
               self.lblRestaurantTiming.text = [NSString stringWithFormat:@"Time not available"];             
         }

        //rate
        //Rate
        if([[[arrLocalRestaurantDetail  objectAtIndex:indexId] objectForKey:@"restaurantRating"] count] > 0)
        {
            NSString *rRating=@"0";
            NSArray *arrRating = [[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"restaurantRating"];
            if([arrRating count] > 0)
            {
                rRating = [NSString stringWithFormat:@"   %@ ", [[Singleton sharedSingleton] getReviewFromGLobalArray:arrRating]];
                if([[rRating stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"0"])
                {
                    self.btnRate.hidden = YES;
                    btnStarRate.hidden = YES;
                }
            }
            [self.btnRate setTitle:rRating forState:UIControlStateNormal];
        }
        else
        {
            self.btnRate.hidden = YES;
            btnStarRate.hidden = YES;
//            [self.btnRate setTitle:[NSString stringWithFormat:@"   0"] forState:UIControlStateNormal];
        }
        
    
        //self.lblRestaurantCost.text = [NSString stringWithFormat:@"%@", [[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"MinimumOrderDollar"]];
    }
    else
    {
        // if go to direct on 3rd bottom button - My Loyalty
        
    }
}
-(void)setupDetailScrollView
{
//    [self.detailScrollview setBackgroundColor:[UIColor blackColor]];
    
    [self.detailScrollview setCanCancelContentTouches:NO];
    self.detailScrollview.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.detailScrollview.clipsToBounds = YES;
    self.detailScrollview.scrollEnabled = YES;
    self.detailScrollview.pagingEnabled = YES;
  
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in self.detailScrollview.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
 
    //scrollViewHeight = 250;
   [self.detailScrollview setContentSize:(CGSizeMake(0, scrollViewHeight+30))];
    
    CGFloat ViewHeight = 0.0f;
    for (UIView* view in viewAfterMenus.subviews)
    {
        ViewHeight += view.frame.size.height;
    }
    NSLog(@"Before : %@", NSStringFromCGRect(viewAfterMenus.frame));
  
    CGRect f = viewAfterMenus.frame;
    f.size.height = ViewHeight;
    viewAfterMenus.frame = f;
    NSLog(@"After : %@", NSStringFromCGRect(viewAfterMenus.frame));
}
- (void)setupHorizontalScrollView
{
    self.scrollView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
    //  [self.scrollView setBackgroundColor:[UIColor blackColor]];
    [scrollView setCanCancelContentTouches:NO];
    
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollView.clipsToBounds = YES;
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    
    //NSInteger tot=0;
    CGFloat cx;
    if (IS_IPAD)
    {
        cx = 10;
    }
    else
    {
        cx = 5;
    }
    
    
    //    NSLog(@"%d -", indexId);
    //    NSLog(@"%@ -", [[Singleton sharedSingleton] getarrFavoriteRestaurantList] );
    //    NSLog(@"%@ -", arrLocalRestaurantDetail );
    
//    NSMutableArray * arrImg;
    if([_fromWhere isEqualToString:@"FromFavorite"])
    {
        arrOfImages  = [[[[[Singleton sharedSingleton] getarrFavoriteRestaurantList] objectAtIndex:0]objectAtIndex:indexId] objectForKey:@"ImagesList"];
    }
    else
    {
        arrOfImages  = [[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"ImagesList"];
    }
    
    int count;
    if([arrOfImages count] > 0)
    {
        count = [arrOfImages count];
    }
    else
    {
        count = 1;
    }
    
    if(count > 5)
    {
        if(IS_IPAD)
        {
            CGRect f = scrollView.frame;
            f.origin.x = 50;
            f.size.width = 700;
            scrollView.frame = f;
        }
        else
        {
            //25,270
            CGRect f = scrollView.frame;
            f.origin.x = 45;
            f.size.width = 270;
            scrollView.frame = f;
        }
    }
    
    for(int i=0; i<count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"defaultImage.png"];
        imageView.tag = i;
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.clipsToBounds=YES;
            
        if([arrOfImages count] > 0)
        {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
            dispatch_async(queue, ^{
                NSData *imageData;
                UIImage *image;
                NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, [[arrOfImages objectAtIndex:i] objectForKey:@"UploadPath"]];
                NSLog(@" ZOOM OUT : %@ ", imageName);

                image =  [[Singleton sharedSingleton] getImageFromCache:[imageName lastPathComponent]];
                
                if(image != nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        imageView.image = image;
                    });
                }
                else
                {
                    NSURL *imageURL =[NSURL URLWithString:imageName];
                    if(imageData == nil)
                    {
                        imageData = [[NSData alloc] init];
                    }
                    imageData = [NSData dataWithContentsOfURL:imageURL];
                    //        NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    image = [UIImage imageWithData:imageData];
                    
                    //  /Upload/UserCard/bb1f9253-ae44-44a1-8427-94d1a0e71dfc/bb1f9253-ae44-44a1-8427-94d1a0e71dfc_06102014521AM.png
                    
                    [[Singleton sharedSingleton] saveImageInCache:image ImgName: [[arrOfImages objectAtIndex:i] objectForKey:@"UploadPath"]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if(image == nil)
                        {
                            imageView.image = [UIImage imageNamed:@"defaultImage.png"];
                        }
                        else{
                            imageView.image = image;
                        }
                    });
                }
            });
        }
        
        //        [imageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
        //        [imageView.layer setBorderWidth: 2.0];
        
        CGRect rect = imageView.frame;
        
        rect.origin.x = cx;
        
        
        if (IS_IPAD)
        {
            rect.size.height = 70;
            rect.size.width = 110;
            rect.origin.y = 10;
        }
        else
        {
            rect.size.height = 50;
            rect.size.width = 90;
            rect.origin.y = 10;
        }
        
        imageView.frame = rect;
        [scrollView addSubview:imageView];
        if (IS_IPAD)
        {
            cx += imageView.frame.size.width+10;
        }
        else
        {
            cx += imageView.frame.size.width+5;
        }
        
        // touch event
        [imageView setUserInteractionEnabled:TRUE];
        
        UITapGestureRecognizer *tapRecognizer;
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)] ;
        tapRecognizer.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:tapRecognizer];
        
    }
    
    [scrollView setContentSize:CGSizeMake(cx, [scrollView bounds].size.height)];
    
}
- (void)imageViewDidTapped:(UIGestureRecognizer *)aGesture
{
   
    ASScroll *asScroll;
    if(IS_IPAD)
    {
        asScroll = [[ASScroll alloc]initWithFrame:CGRectMake(0.0,0.0,768.0,620.0)]; //810
    }
    else
    {
        asScroll =[[ASScroll alloc]initWithFrame:CGRectMake(0.0,0.0,320.0,320.0)];
    }
  
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray * imagesArray = [[NSMutableArray alloc]init];
    
    for (int imageCount = 0; imageCount < [arrOfImages count]; imageCount++)
    {
        NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, [[arrOfImages objectAtIndex:imageCount] objectForKey:@"UploadPath"]];
        NSLog(@" ZOO IN : %@ ", imageName);
        [imagesArray addObject:imageName];
    }
    [asScroll setArrOfImages:imagesArray];
    [self.viewBGMap addSubview:asScroll];
    [asScroll setBackgroundColor:[UIColor whiteColor]];
    asScroll.btnSkip.hidden = YES;
    
    if(IS_IPAD)
    {
        [self.view addSubview:self.btnBG];
        [self.viewBGMap setFrame:CGRectMake(0, 180, self.viewBGMap.frame.size.width, self.viewBGMap.frame.size.height)];
        [self.view addSubview:self.viewBGMap];
    }
    else
    {
        [self.view addSubview:self.btnBG];
        if (IS_IPHONE_5)
        {
            [self.viewBGMap setFrame:CGRectMake(0, 100, self.viewBGMap.frame.size.width, self.viewBGMap.frame.size.height)];
        }
        else
        {
            [self.viewBGMap setFrame:CGRectMake(0, 70, self.viewBGMap.frame.size.width, self.viewBGMap.frame.size.height)];
        }
        [self.view addSubview:self.viewBGMap];

    }
    
    
//    CGRect   f = self.viewBGMap.frame;
//    
//    self.scrollViewLargeImg = [[UIScrollView alloc]initWithFrame:CGRectMake(f.origin.x, f.origin.y, f.size.width, f.size.height-20)];
//    self.scrollViewLargeImg.contentSize = CGSizeMake(self.scrollViewLargeImg.frame.size.width * arrOfImages.count,self.scrollViewLargeImg.frame.size.height);
//    [self.scrollViewLargeImg setDelegate:self];
//    [self.scrollViewLargeImg setCanCancelContentTouches:NO];
//    self.scrollViewLargeImg.showsVerticalScrollIndicator = NO;
//    self.scrollViewLargeImg.showsHorizontalScrollIndicator = NO;
//   self.scrollViewLargeImg.clipsToBounds = YES;
//    
//    self.scrollViewLargeImg.pagingEnabled = YES;
//    self.scrollViewLargeImg.contentSize = CGSizeMake(self.scrollViewLargeImg.frame.size.width * arrOfImages.count,self.scrollViewLargeImg.frame.size.height);
//    
//    
//    
////    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)aGesture;
////    UIImageView *tappedImageView = (UIImageView *)[tapGesture view];
//    // NSMutableArray * arrImg;
//    if([_fromWhere isEqualToString:@"FromFavorite"])
//    {
//        arrOfImages  = [[[[[Singleton sharedSingleton] getarrFavoriteRestaurantList] objectAtIndex:0]objectAtIndex:indexId] objectForKey:@"ImagesList"];
//    }
//    else
//    {
//        arrOfImages  = [[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"ImagesList"];
//    }
//    if([arrOfImages count] > 0)
//    {
//       UIImage *image;
//        for (int i =0; i<arrOfImages.count ; i++) {
//           
//            UIImageView * imageview = [[UIImageView alloc]init];
//            [imageview setContentMode:UIViewContentModeScaleAspectFit];
//            
//            imageview.frame = CGRectMake(0.0, 0.0,self.scrollViewLargeImg.frame.size.width , self.scrollViewLargeImg.frame.size.height);
//            [imageview setTag:i+1];
//            if (i !=0) {
//                imageview.alpha = 0;
//            }            
//            NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, [[arrOfImages objectAtIndex:i] objectForKey:@"UploadPath"]];
//            image =  [[Singleton sharedSingleton] getImageFromCache:[imageName lastPathComponent]];
//            imageview.image = image;
//            
//         /*   dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
//            dispatch_async(queue, ^{
//                NSData *imageData;
//                UIImage *image;
//                NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, [[arrOfImages objectAtIndex:i] objectForKey:@"UploadPath"]];
//                
//                image =  [[Singleton sharedSingleton] getImageFromCache:[imageName lastPathComponent]];
//                if(image != nil)
//                {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        imageview.image = image;
//                    });
//                }
//                else
//                {
//                    NSURL *imageURL =[NSURL URLWithString:imageName];
//                    if(imageData == nil)
//                    {
//                        imageData = [[NSData alloc] init];
//                    }
//                    imageData = [NSData dataWithContentsOfURL:imageURL];
//                    //        NSData *data = [NSData dataWithContentsOfURL:imageURL];
//                    image = [UIImage imageWithData:imageData];
//                    
//                    //  /Upload/UserCard/bb1f9253-ae44-44a1-8427-94d1a0e71dfc/bb1f9253-ae44-44a1-8427-94d1a0e71dfc_06102014521AM.png
//                    
//                    [[Singleton sharedSingleton] saveImageInCache:image ImgName: [[arrOfImages objectAtIndex:i] objectForKey:@"UploadPath"]];
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        if(image == nil)
//                        {
//                            imageview.image = [UIImage imageNamed:@"default-image350x350.png"];
//                        }
//                        else{
//                            imageview.image = image;
//                        }
//                    });
//                }
//            });
//          */
//            
//          [self.viewBGMap addSubview:imageview];
//        }
//    }
//    
//    if(IS_IPAD)
//    {
//        [self.view addSubview:self.btnBG];
//        [self.viewBGMap setFrame:CGRectMake(0, 180, self.viewBGMap.frame.size.width, self.viewBGMap.frame.size.height)];
//        [self.view addSubview:self.viewBGMap];
//        self.imgLargePhoto.hidden = YES;
//    }
//    else
//    {
//        [self.view addSubview:self.btnBG];
//        if (IS_IPHONE_5)
//        {
//            [self.viewBGMap setFrame:CGRectMake(0, 100, self.viewBGMap.frame.size.width, self.viewBGMap.frame.size.height)];
//        }
//        else
//        {
//            [self.viewBGMap setFrame:CGRectMake(0, 70, self.viewBGMap.frame.size.width, self.viewBGMap.frame.size.height)];
//        }
//        [self.view addSubview:self.viewBGMap];
//        
//        self.mapView1.hidden =YES;
//        self.imgLargePhoto.hidden = NO;
//    }
//     
// 
//    pageControl.numberOfPages = arrOfImages.count;
//    pageControl.currentPage = 0;
//    [pageControl setBackgroundColor:[UIColor darkGrayColor]];
//    pageControl.hidden = NO;
//    
//    [pageControl addTarget:self action:@selector(pgCntlChanged:)forControlEvents:UIControlEventValueChanged];
//    [self performSelector:@selector(startAnimatingScrl) withObject:nil afterDelay:3.0];
//    [self.viewBGMap addSubview:pageControl];
//    [self.viewBGMap addSubview:self.scrollViewLargeImg];
    
}
#pragma mark GET INFO DETAIL
- (void)GoToRestaurantDetailPage:(NSString*)rid
{
    
    // get restaurant Detail
    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
       [self startActivity];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:rid forKey:@"RestaurantId"];
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Restaurant Detail - %@ -- ", dict);
             if (dict)
             {
                                  [self stopActivity];
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                 }
                 else
                 {
                     if([dict objectForKey:@"data"])
                     {
                         NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
                         [arrTemp addObject:[dict objectForKey:@"data"] ];
                         
                         indexId = 0;
                         [arrLocalRestaurantDetail addObject:arrTemp];
                         [self setupInitailDetailView];
                         
//                         if([arrTemp count] > 0)
//                         {
//                             [[Singleton sharedSingleton] setarrRestaurantList:[arrTemp objectAtIndex:0]];
//                         }
                         // [[Singleton sharedSingleton] setarrRestaurantList:[dict objectForKey:@"data"]];
                     }
                 }
             }
             else
             {
                 UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
                 [self stopActivity];
             }
         } :@"Restaurant/GetRestaurantDetails" data:dict];
    }
}

-(void)getFavoriteOfRestaurant
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
        self.actIndicatorView_LoyaltyPoints.hidden = YES;
    }
    else
    {
         // [self startActivity];
            
            NSString * restaurantId = [[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"UserId"];
            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
            NSString * userId ;
            if([st objectForKey:@"UserId"])
            {
                userId =  [st objectForKey:@"UserId"];
            }
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:restaurantId forKey:@"RestaurantId"];
            [dict setValue:userId  forKey:@"UserId"];
            
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 NSLog(@"Fav  %@ -- ", dict);
                 
//                dispatch_async(dispatch_get_main_queue(), ^
//               {
                   if (dict)
                   {
                       //[self stopActivity];
                       
                       Boolean strData= [[[dict objectForKey:@"data"] objectForKey:@"IsFavourite"] boolValue];
                       @try {
                           redeemPoints = [[[dict objectForKey:@"data"]  objectForKey:@"TotalPoints"] floatValue];
                       }
                       @catch (NSException *exception) {
                           redeemPoints = 0 ;
                       }
                       dispatch_async(dispatch_get_main_queue(), ^
                        {
                            self.actIndicatorView_LoyaltyPoints.hidden = YES;
                            [self.actIndicatorView_LoyaltyPoints  stopAnimating];
                        });
                       
                       lblLoyaltyPoints.hidden=NO;
                       lblLoyaltyPoints.text = [NSString stringWithFormat:@"%.02f", redeemPoints];
                       
                       @try {
                           if([[[Singleton sharedSingleton] ISNSSTRINGNULL:lblLoyaltyPoints.text] isEqualToString:@""] || [[[Singleton sharedSingleton] ISNSSTRINGNULL:lblLoyaltyPoints.text] isEqualToString:@"0"] || [[[Singleton sharedSingleton] ISNSSTRINGNULL:lblLoyaltyPoints.text] isEqualToString:@"0.00"])
                           {
                               lblLoyaltyPoints.hidden=YES;
                               CGRect f = btnLoyaltyPointLink.frame;
                               f.origin.x = lblLoyaltyPoints.frame.origin.x;
                               btnLoyaltyPointLink.frame = f;
                           }
                       }
                       @catch (NSException *exception) {
                         
                       }
                       [Singleton sharedSingleton].globalTotalPoints = [lblLoyaltyPoints.text floatValue];
                     
                       //[[dict objectForKey:@"data"] boolValue];
                       UIImage *fav = [UIImage imageNamed:@"favorite-active.png"];
                       UIImage *unfav = [UIImage imageNamed:@"favorite.png"];
                       
                       if(strData)
                       {
                           IS_RESTAURANT_FAVORITE=TRUE;
                           [self.btnFavorite setBackgroundImage:fav forState:UIControlStateNormal];
                       }
                       else
                       {
                           IS_RESTAURANT_FAVORITE=FALSE;
                           [self.btnFavorite setBackgroundImage:unfav forState:UIControlStateNormal];
                       }
                       
                   }
                   else
                   {
                       UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                       [alt show];
                       // [self stopActivity];
                   }
//               });
             } :@"Restaurant/FavouriteRestaurantByUser" data:dict];
    }
}


#pragma mark BUTTON CLICK EVENT
-(void)startActivity
{
    [self.view addSubview:backgroundIndicatorView];
    [actIndicatorView startAnimating];
}
-(void)stopActivity
{
    [backgroundIndicatorView removeFromSuperview];
    [actIndicatorView stopAnimating];
}
- (IBAction)btnBackClick:(id)sender
{
    [UIView transitionWithView:self.navigationController.view
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                         [self.navigationController popViewControllerAnimated:NO];
                    }
                    completion:nil];
    
//    [self.navigationController popViewControllerAnimated:YES];
      
}

- (IBAction)favoriteClicked:(id)sender
{
   if(app._skipRegister == 1)
   {
       [[Singleton sharedSingleton] errorLoginFirst];
   }
    else
    {
        UIImage *fav = [UIImage imageNamed:@"favorite-active.png"];
        UIImage *unfav = [UIImage imageNamed:@"favorite.png"];
        
        if([self.btnFavorite.currentBackgroundImage isEqual:fav])
        {
            //already fav
            [self.btnFavorite setBackgroundImage:unfav forState:UIControlStateNormal];
        }
        else if([self.btnFavorite.currentBackgroundImage isEqual:unfav])
        {
            //already unfav
            [self.btnFavorite setBackgroundImage:fav forState:UIControlStateNormal];
        }
       
        if ([[Singleton sharedSingleton] connection]==0)
        {
            UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [altMsg show];
        }
        else
        {
            [self startActivity];
            
            NSString * restaurantId = [[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"UserId"];
            
            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
            NSString * userId ;
            if([st objectForKey:@"UserId"])
            {
                userId =  [st objectForKey:@"UserId"];
            }
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:restaurantId forKey:@"RestaurantId"];
            [dict setValue:userId  forKey:@"UserId"];
            
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 NSLog(@"Favorite MEssage : %@ -- ", dict);
                 
                 if (dict)
                 {
                     // [self stopActivity];
                     
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     
                 }
                 else
                 {
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     //[self stopActivity];
                 }
                 [self stopActivity];
             } :@"Restaurant/FavouriteToggle" data:dict];
        }
    }
}

- (IBAction)chatClicked:(id)sender
{
    if(app._skipRegister == 1)
    {
        [[Singleton sharedSingleton] errorLoginFirst];
    }
    else
    {
        
        if([[[Singleton sharedSingleton] getstrLoginUserChat] intValue] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Chat is disable now. To Enable, Go to Settings." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Settings", nil];
            alert.tag = 88;
            [alert show];
        }
        else
        {
            chatViewController *chat;
            if (IS_IPHONE_5)
            {
                chat=[[chatViewController alloc] initWithNibName:@"chatViewController-5" bundle:nil];
            }
            else if (IS_IPAD)
            {
                chat=[[chatViewController alloc] initWithNibName:@"chatViewController_iPad" bundle:nil];
            }
            else
            {
                chat=[[chatViewController alloc] initWithNibName:@"chatViewController" bundle:nil];
            }
            chat.restaurantId =  [[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"UserId"];
            [[Singleton sharedSingleton] setstrRestaurantForChat: [[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"UserId"]];
            [self.navigationController pushViewController:chat animated:YES];
        }
            
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 88)
    {
        if(buttonIndex == 1)
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
}
-(IBAction)phoneCallClicked:(id)sender
{
    NSString *mob =  [[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"MobileNo"];
    [[Singleton sharedSingleton] CALLPhoneNumberProgrammatically:mob];
     
}
-(IBAction)orderProcessClicked:(id)sender
{
    OrderProcessViewController *order;
    if (IS_IPHONE_5)
    {
        order=[[OrderProcessViewController alloc] initWithNibName:@"OrderProcessViewController-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        order=[[OrderProcessViewController alloc] initWithNibName:@"OrderProcessViewController_iPad" bundle:nil];
    }
    else
    {
        order=[[OrderProcessViewController alloc] initWithNibName:@"OrderProcessViewController" bundle:nil];
    }
    [self.navigationController pushViewController:order animated:YES];
}
- (IBAction)reservationClicked:(id)sender
{
   if(app._skipRegister == 1)
   {
       [[Singleton sharedSingleton] errorLoginFirst];
   }
    else
    {
        ReservationDetailViewController1 *detail;
        if (IS_IPHONE_5)
        {
            detail=[[ReservationDetailViewController1 alloc] initWithNibName:@"ReservationDetailViewController1-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            detail=[[ReservationDetailViewController1 alloc] initWithNibName:@"ReservationDetailViewController1_iPad" bundle:nil];
        }
        else
        {
            detail=[[ReservationDetailViewController1 alloc] initWithNibName:@"ReservationDetailViewController1" bundle:nil];
        }
        [self.navigationController pushViewController:detail animated:YES];
        
    }
}

#pragma mark Google map view
-(void)setUpMapView
{
//    if (nil == locationManager)
//        locationManager = [[CLLocationManager alloc] init];
//    
//    locationManager.delegate = self;
//    //Configure Accuracy depending on your needs, default is kCLLocationAccuracyBest
//    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;  //kCLLocationAccuracyBest
//    // Set a movement threshold for new events.
//  //  locationManager.distanceFilter = 10; // meters
//    [locationManager startUpdatingLocation];
    
    
    if([arrLocalRestaurantDetail count] > 0)
    {
        latitude  =  [[[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"Latidute"] doubleValue];
        longitude =  [[[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"Longitude"] doubleValue];
    }
    
    GMSCameraPosition *camera1 = [GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:Zoom_DEFAULTLEVEL];
    mapView_1 = [GMSMapView mapWithFrame:self.mapView1.bounds camera:camera1];
    mapView_1.delegate = self;
    mapView_1.settings.myLocationButton = YES;
    mapView_1.settings.compassButton = YES;
    
//    mapView_1.settings.consumesGesturesInView = YES;
//    mapView_1.settings.scrollGestures = NO;
//    mapView_1.settings.zoomGestures = NO;
//    mapView_1.settings.tiltGestures = NO;
    
    
    [self.mapView1 addSubview:mapView_1];
  
    [mapView_1 addObserver:self  forKeyPath:@"myLocation1" options:NSKeyValueObservingOptionNew  context:NULL];
//    if(!IS_IPAD)
//    {
        [mapView_1 addSubview:self.stepperZoom];
        [mapView_1 bringSubviewToFront:self.stepperZoom];
        self.stepperZoom.value = mapView_1.camera.zoom;
//    }
   
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude=latitude;
    coordinate.longitude=longitude;
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.title=  [NSString stringWithFormat:@"%@", [[arrLocalRestaurantDetail objectAtIndex:indexId] objectForKey:@"StoreName"]];
    marker.position = coordinate;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = mapView_1;
    [markers_1 addObject:marker];
 
    [[Singleton sharedSingleton] drawCircleAroundMe:coordinate GMSGOOGLEMAP:mapView_1];
    
    if(app.lat!=0 && app.lon!= 0)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
       
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        [dict1 setValue:[NSString stringWithFormat:@"%f~%f", app.lat, app.lon] forKey:@"LatLong"];
        [arr addObject:dict1];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[NSString stringWithFormat:@"%f~%f", latitude, longitude] forKey:@"LatLong"];
        [arr addObject:dict];
        
        [[Singleton sharedSingleton] drawPathBetweenLocations:arr GMSGOOGLEMAP:mapView_1];
    }
    
    [self didTapFitBounds];
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_1.myLocationEnabled = YES;
    });
    
}

#pragma mark - KVO updates
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_)
    {
        // CLLocationCoordinate2D coordinate;
        //coordinate.latitude=latitude;
        //coordinate.longitude=longitude;
        
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        __unused CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_1.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:Zoom_DEFAULTLEVEL];
        
        [[Singleton sharedSingleton] drawCircleAroundMe:location.coordinate GMSGOOGLEMAP:mapView_1];
        
    }
}
- (void)didTapFitBounds
{
   GMSCoordinateBounds *bounds;
    for (GMSMarker *marker in markers_1)
    {
        if (bounds == nil)
        {
            bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:marker.position coordinate:marker.position];
        }
        bounds = [bounds includingCoordinate:marker.position];
    }
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds
                                             withPadding:50.0f];
    [mapView_1 moveCamera:update];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Implement here if the view has registered KVO
   // self.mapView_.delegate = nil;
    
}
-(void)dealloc
{
    @try {
        [self.mapView1 removeObserver:self  forKeyPath:@"myLocation1"  context:NULL];
    }
    @catch (NSException *exception) {
        NSLog(@"------------- ERROR -------------");
        NSLog(@"MAP : %@", [exception description]);
    }
}

- (IBAction)btnMapClicked:(id)sender
{
    //Old
    [self setUpMapView];
}
- (IBAction)zoomIndexChanges:(UIStepper *)sender {
    
    int value = [sender value];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude=latitude;
    coordinate.longitude=longitude;
    
    mapView_1.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:value];
   
}
- (IBAction)hideParentView:(id)sender
{
    [self.btnBG removeFromSuperview];
    [self.viewBGMap removeFromSuperview];
}
@end
