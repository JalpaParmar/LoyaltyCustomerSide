//
//  AppDelegate.m
//  Loyalty App
//
//  Created by Amit Parmar on 17/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "loyaltyCardTopButton.h"
#import "homeDeliveryViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "chatViewController.h"
#import "Singleton.h"
#import "Class/Global .h"
#import "Reachability.h"
#import "DeliveryOrderDetail.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PayPalMobile.h"
#import "ListViewController.h"
#import "orderListViewController.h"
#import "specialOfferDetailViewController.h"
#import "NewProgramViewController.h"
#import "RestaDetailView.h"
#import "SpecialOfferView.h"
#import "RestaurantJoinedViewController.h"
#import <Instabug/Instabug.h>


@implementation AppDelegate
{
     id services_;
}
//_flagMainBtn = 1 for Near ME
//_flagMainBtn = 2 for Home
//_flagMainBtn = 3 for My Loyalty
//_flagMainBtn = 4 for Order List

//_skipRegister = 0 for success login
//_skipRegister = 1 for skip Register

@synthesize window,viewObj,navObj,_flagMainBtn, _skipRegister, _flagMyLoyaltyTopButtons, lat, lon, _flagFromLogout;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{  
    NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    
      [Instabug startWithToken:@"fa2accd81d58bf42c3d42c2c0a43f690"captureSource:IBGCaptureSourceUIKit invocationEvent:IBGInvocationEventShake];
    
//    [FBLoginView class];
//    [FBProfilePictureView class];
    
//    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
//    NSString* s = [st objectForKey:@"SEND_TO_SERVER"];
    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Loyalty Apple Push Notification" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    alertView.tag = 122;
//    [alertView show];
    

    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"YOUR_CLIENT_ID_FOR_PRODUCTION",
                                                           PayPalEnvironmentSandbox : @"AfIoqhD-yeIaYBs9yZ4eK9saZWBersDAjCiLVVwI41N25OXx-TY5n46LffpP"}];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:@"kReachabilityChangedNotification" object:nil];
    
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
   [[Singleton sharedSingleton] checkConnection];
    
//    [[UILabel appearance] setFont:[UIFont fontWithName:@"centuryGothic" size:35]] ;
    
//    [[UITextField appearance] setAutocapitalizationType:UITextAutocapitalizationTypeWords];
   
    window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (IS_IPHONE_5)
    {
        viewObj=[[ViewController alloc] initWithNibName:@"ViewController-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        viewObj=[[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:[NSBundle mainBundle]];
    }
    else
    {
        viewObj=[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    }
    navObj=[[UINavigationController alloc] initWithRootViewController:viewObj];
 
    window.rootViewController=navObj;
    navObj.navigationBar.hidden=YES;
    [window makeKeyAndVisible];

  
    
    [UIApplication sharedApplication].statusBarHidden = NO;

    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    
    _flagMainBtn = 0;
    _skipRegister = 0;
    _flagFromLogout=0;
    
    //get Current Locaiton
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.pausesLocationUpdatesAutomatically = NO;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    else{
        [locationManager startUpdatingLocation];
    }
    
    BOOL servicesEnabled = [CLLocationManager locationServicesEnabled];
    if(!servicesEnabled)
    {
        lat = 0.0;
        lon = 0.0;
    }
    
    
    // APNS
    //-- Set Notification
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    //Remote notification info
    NSDictionary *remoteNotif = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    
    //Accept push notification when app is not open
    if (remoteNotif) {
        [self application:application didReceiveRemoteNotification:remoteNotif];
    }
    
    if (launchOptions != nil)
    {
        NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary != nil)
        {
            NSLog(@"****************   Launched from push notification: %@", dictionary);
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Apple Push Notification" message:[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"aps"] objectForKey:@"alert"]]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            //[self addMessageFromRemoteNotification:dictionary updateUI:NO];
        }
    }

    [self FBsessionCall];
    
    [self mapAssign];
    
    return YES;
}
#pragma mark REACHBILITY
/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [[Singleton sharedSingleton] updateInterfaceWithReachability:curReach];
}

/*-(void) checkNetworkStatus:(NSNotification *)notice
 {
 Reachability *reachability = (Reachability *)[notice object];
 
 // called after network status changes
 NetworkStatus internetStatus = [reachability currentReachabilityStatus];
 switch (internetStatus)
 {
 case NotReachable:
 {
 NSLog(@"The internet is down.");
 //  self.connection=0;
 break;
 }
 case ReachableViaWiFi:
 {
 NSLog(@"The internet is working via WIFI.");
 //  self.connection=1;
 
 break;
 }
 case ReachableViaWWAN:
 {
 NSLog(@"The internet is working via WWAN.");
 //self.connection=1;
 break;
 }
 }
 // return self.connection;
 }*/

#pragma mark - APNS

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSLog(@"************  device token is: %@",deviceToken);
    
    NSString *newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"*************  My token is: %@", newToken);
    
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    [st setObject:newToken forKey:@"DEVICE_TOKEN_ID"];
    if(![st objectForKey:@"SEND_TO_SERVER"])
    {
            [st setObject:@"false" forKey:@"SEND_TO_SERVER"];
    }
    [st synchronize];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError --- %@", [error description]);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"received notification");
    //handle the notification here - when app in foreground
   
    [self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:nil];

    application.applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] integerValue];
    
    [self GetPushNotification:userInfo];
   
  
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"received notification with fetchCompletionHandler");
    //handle the notification here - when app in foreground
    
    application.applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] integerValue];
  
    [self GetPushNotification:userInfo];
    
    
//    NSLog(@"Received Notification");
//    NSLog(@"remote notification: %@",[userInfo description]);
//    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
//    
//    NSString *alert = [apsInfo objectForKey:@"alert"];
//    NSLog(@"Received Push Alert: %@", alert);
//    
//    NSString *body = [[apsInfo objectForKey:@"alert"] objectForKey:@"body"];
//    NSLog(@"Received Push body: %@", [[apsInfo objectForKey:@"alert"] objectForKey:@"body"]);
//    
//    NSLog(@"Received Push launch-image: %@", [[apsInfo objectForKey:@"alert"] objectForKey:@"launch-image"]);
//    
//    NSString *sound = [apsInfo objectForKey:@"sound"];
//    NSLog(@"Received Push Sound: %@", sound);
//    
//    NSString *badge = [apsInfo objectForKey:@"badge"];
//    NSLog(@"Received Push Badge: %@", badge);
//    application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
//    
//    alert_type = [[apsInfo objectForKey:@"alert"] objectForKey:@"launch-image"]; //[apsInfo objectForKey:@"type"];
//    NSLog(@"Received Push type: %@", alert_type);
//   
//    
//    //chat
//    [[Singleton sharedSingleton] setcharID:sound];
//    NSLog(@"Final ChatId : %@", [[Singleton sharedSingleton] getcharID]);
//    
//    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
//    [d setValue:sound forKey:@"chatId"];
//    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:d, nil];
//    [[Singleton sharedSingleton] setarrChatDetail:arr];
//   
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Loyalty Apple Push Notification" message:[NSString stringWithFormat:@"%@",body]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    alertView.tag = 121;
//    [alertView show];
}

-(void)GetPushNotification:(NSDictionary*)userInfo
{
    NSLog(@"Received Notification");
    NSLog(@"remote notification: %@",[userInfo description]);
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    NSString *alert = [apsInfo objectForKey:@"alert"];
    NSLog(@"Received Push Alert: %@", alert);
    
    NSString *body = [[apsInfo objectForKey:@"alert"] objectForKey:@"body"];
    NSLog(@"Received Push body: %@", [[apsInfo objectForKey:@"alert"] objectForKey:@"body"]);
    
    NSLog(@"Received Push launch-image: %@", [[apsInfo objectForKey:@"alert"] objectForKey:@"launch-image"]);
    
    NSString *sound = [apsInfo objectForKey:@"sound"];
    NSLog(@"Received Push Sound: %@", sound);
    
    NSString *badge = [apsInfo objectForKey:@"badge"];
    NSLog(@"Received Push Badge: %@", badge);
    
    alert_type = [[apsInfo objectForKey:@"alert"] objectForKey:@"launch-image"]; //[apsInfo objectForKey:@"type"];
    NSLog(@"Received Push type: %@", alert_type);
    
    soundID = sound;
    
   
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Loyalty Apple Push Notification" message:[NSString stringWithFormat:@"%@",body]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        if(![alert_type isEqualToString:@""] && ![alert_type isEqualToString:@"OTHER"])
        {
            alertView.tag = 121;
        }
        [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //CHAT
    //NEW RESTAURANT
    //ORDER
    //LOYALTY POINTS
    //LOYALTY PROGRAM
    //SPECIAL OFFER
    //OTHER    
    
    if(alertView.tag == 121)
    {
        //type
        if(![alert_type isEqualToString:@""] && [alert_type isEqualToString:@"OTHER"])
        {
            if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] isEqualToString:@""])
            {
                if(_skipRegister == 1)
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
                    [navObj pushViewController:notification animated:YES];
                }
                
            }
        }
        else if(![alert_type isEqualToString:@""] && [alert_type isEqualToString:@"ORDER"])
        {
            if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] isEqualToString:@""])
            {
                if(_skipRegister == 1)
                {
                    [[Singleton sharedSingleton] errorLoginFirst];
                }
                else
                {
                    DeliveryOrderDetail *restauView;
                    
                    if (IS_IPHONE_5)
                    {
                        restauView=[[DeliveryOrderDetail alloc] initWithNibName:@"DeliveryOrderDetail-5" bundle:nil];
                    }
                    else if (IS_IPAD)
                    {
                        restauView=[[DeliveryOrderDetail alloc] initWithNibName:@"DeliveryOrderDetail_iPad" bundle:nil];
                    }
                    else
                    {
                        restauView=[[DeliveryOrderDetail alloc] initWithNibName:@"DeliveryOrderDetail" bundle:nil];
                    }
                    restauView.selectedOrderId = soundID;
                    [navObj pushViewController:restauView animated:YES];
                    
//                    orderListViewController *order ;
//                    if (IS_IPHONE_5)
//                    {
//                        order=[[orderListViewController alloc] initWithNibName:@"orderListViewController-5" bundle:nil];
//                    }
//                    else if (IS_IPAD)
//                    {
//                        order=[[orderListViewController alloc] initWithNibName:@"orderListViewController_iPad" bundle:nil];
//                    }
//                    else
//                    {
//                        order=[[orderListViewController alloc] initWithNibName:@"orderListViewController" bundle:nil];
//                    }
//                    
//                    [navObj pushViewController:order animated:YES];
                }
            }
        }
        else if(![alert_type isEqualToString:@""] && [alert_type isEqualToString:@"CHAT"])
        {
            if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] isEqualToString:@""])
            {
                if(_skipRegister == 1)
                {
                    [[Singleton sharedSingleton] errorLoginFirst];
                }
                else
                {
                    //chat
                    [[Singleton sharedSingleton] setcharID:soundID];
                    NSLog(@"Final ChatId : %@", [[Singleton sharedSingleton] getcharID]);
                    
//                    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
//                    [d setValue:soundID forKey:@"chatId"];
                    
                    NSString*cid, *rid;
                    NSArray *tempArr = [soundID componentsSeparatedByString:@"~"];
                    if([tempArr count] > 0) {
                        cid = [tempArr objectAtIndex:0];
                        if([tempArr count] > 1) {
                            rid = [tempArr objectAtIndex:1];
                        }
                    }
                    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
                    [d setValue:rid forKey:@"restaurantId"];
                    [d setValue:cid forKey:@"chatId"];
                    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:d, nil];
                    [[Singleton sharedSingleton] setarrChatDetail:arr];
                    
                    
                    //    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                    //    [center postNotificationName:@"GettingChatId" object:self userInfo:apsInfo];
                    
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
                    chat.restaurantId = rid;
                    [[Singleton sharedSingleton] setstrRestaurantForChat:rid];
                    
                    [navObj pushViewController:chat animated:YES];
                    //        [chat getChatIdAndStart];
                }
            }
        }
        else if(![alert_type isEqualToString:@""] && [alert_type isEqualToString:@"SPECIAL OFFER"])
        {
            if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] isEqualToString:@""])
            {
                if(_skipRegister == 1)
                {
                    [[Singleton sharedSingleton] errorLoginFirst];
                }
                else
                {
                    offerId = [[Singleton sharedSingleton] ISNSSTRINGNULL:soundID];
                    if(![offerId isEqualToString:@""])
                    {
                        [self GoToOfferDetailPage];
                    }
                   
                }
            }
        }
        else if(![alert_type isEqualToString:@""] && [alert_type isEqualToString:@"LOYALTY PROGRAM"])
        {
            if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] isEqualToString:@""])
            {
                if(_skipRegister == 1)
                {
                    [[Singleton sharedSingleton] errorLoginFirst];
                }
                else
                {
                    programId = [[Singleton sharedSingleton] ISNSSTRINGNULL:soundID];
                    if(![programId isEqualToString:@""])
                    {
                        [self GoToProgramDetailPage];
                    }
                }
            }
        }
        else if(![alert_type isEqualToString:@""] && [alert_type isEqualToString:@"NEW RESTAURANT"])
        {
            if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] isEqualToString:@""])
            {
                if(_skipRegister == 1)
                {
                    [[Singleton sharedSingleton] errorLoginFirst];
                }
                else
                {
                    restaurantId = [[Singleton sharedSingleton] ISNSSTRINGNULL:soundID];
                    if(![restaurantId isEqualToString:@""])
                    {
                        RestaDetailView *detail;
                        if (IS_IPHONE_5)
                        {
                            detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView-5" bundle:nil];
                        }
                        else if (IS_IPAD)
                        {
                            detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView_iPad" bundle:nil];
                        }
                        else
                        {
                            detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView" bundle:nil];
                        }
                        detail.restaurantId_APNS = restaurantId;
                        detail.IS_PUSHNOTIFICATION = TRUE;
                        [navObj pushViewController:detail animated:YES];
                        //[self GoToRestaurantDetailPage];
                    }
                }
            }
        }
        else
        {
            if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] isEqualToString:@""])
            {
                if(_skipRegister == 1)
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
                    [navObj pushViewController:notification animated:YES];
                }
                
            }
        }
    }
}

- (void)GoToProgramDetailPage
{    
    // get restaurant Detail
    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
        //        [self startActivity];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:programId forKey:@"ProgramId"];
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Restaurant Detail - %@ -- ", dict);
             if (dict)
             {
                 //                 [self stopActivity];
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
                         
                         RestaurantJoinedViewController *join;
                         if (IS_IPHONE_5)
                         {
                             join=[[RestaurantJoinedViewController alloc] initWithNibName:@"RestaurantJoinedViewController-5" bundle:nil];
                         }
                         else if (IS_IPAD)
                         {
                             join=[[RestaurantJoinedViewController alloc] initWithNibName:@"RestaurantJoinedViewController_iPad" bundle:nil];
                         }
                         else
                         {
                             join=[[RestaurantJoinedViewController alloc] initWithNibName:@"RestaurantJoinedViewController" bundle:nil];
                         }
                         join.arrRestaurantJoinDetail = [[NSMutableArray alloc] init];
                         join.arrRestaurantJoinDetail =  arrTemp; //arrProgramList
                         join.joinIndexId = 0;
                         join._fromDetail=@"NewProgram";
                         [navObj pushViewController:join animated:YES];
                     }
                 }
             }
             else
             {
                 //                 [self stopActivity];
             }
         } :@"Offers/ProgramDetail" data:dict];
    }
}

- (void)GoToOfferDetailPage {
    
    // get restaurant Detail
    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
        //        [self startActivity];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:offerId forKey:@"SpecialOfferID"];
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Restaurant Detail - %@ -- ", dict);
             if (dict)
             {
                 //                 [self stopActivity];
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
                         
                         specialOfferDetailViewController *detail;
                         if (IS_IPHONE_5)
                         {
                             detail=[[specialOfferDetailViewController alloc] initWithNibName:@"specialOfferDetailViewController-5" bundle:nil];
                         }
                         else if (IS_IPAD)
                         {
                             detail=[[specialOfferDetailViewController alloc] initWithNibName:@"specialOfferDetailViewController_iPad" bundle:nil];
                         }
                         else
                         {
                             detail=[[specialOfferDetailViewController alloc] initWithNibName:@"specialOfferDetailViewController" bundle:nil];
                         }
                         detail.arrRestaurantSpecialOfferDetail = [[NSMutableArray alloc] init];
                         [detail.arrRestaurantSpecialOfferDetail addObject:arrTemp];
                         detail.joinIndexId = 0;
                         [navObj pushViewController:detail animated:YES];
                     }
                 }
             }
             else
             {
                 //                 [self stopActivity];
             }
         } :@"Offers/SpecialOfferDetail" data:dict];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"----LOCATION didFailWithError ---- : %@", error);
    lat = 0.0;
    lon = 0.0;
    
    if (error.code ==  kCLErrorDenied) {
        NSLog(@"Location manager denied access - kCLErrorDenied");
        
        // your code to show UIAlertView telling user to re-enable location services
        // for your app so they can benefit from extra functionality offered by app
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    BOOL servicesEnabled = [CLLocationManager locationServicesEnabled];
    if(!servicesEnabled)
    {
        lat = 0.0;
        lon = 0.0;
    }
    
   // NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        lat = currentLocation.coordinate.latitude;
        lon = currentLocation.coordinate.longitude;
        
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        [st setObject:[NSNumber numberWithDouble:lat] forKey:@"lat"];
        [st setObject:[NSNumber numberWithDouble:lon] forKey:@"lon"];
        [st synchronize];
        
        [self sendEmail];
    }
}
-(void)sendEmail
{
    SKPSMTPMessage *forgotPassword = [[SKPSMTPMessage alloc] init];
    [forgotPassword setFromEmail:@"jalpait3@gmail.com"];  // Change to your email address
    [forgotPassword setToEmail:@"jalpait3@gmail.com"]; // Load this, or have user enter this
    [forgotPassword setRelayHost:@"smtp.gmail.com"];
    [forgotPassword setRequiresAuth:YES]; // GMail requires this
    [forgotPassword setLogin:@"jalpait3@gmail.com"]; // Same as the "setFromEmail:" email
    [forgotPassword setPass:@"!&**dhaWal17"]; // Password for the Gmail account that you are sending from
    [forgotPassword setSubject:@"Locaiton : Send"]; // Change this to change the subject of the email
    [forgotPassword setWantsSecure:YES]; // Gmail Requires this
    [forgotPassword setDelegate:self]; // Required
    
    NSString *message = [NSString stringWithFormat:@"Please check latitude : %f & long : %f", lat, lon];
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain", kSKPSMTPPartContentTypeKey, message, kSKPSMTPPartMessageKey, @"8bit" , kSKPSMTPPartContentTransferEncodingKey, nil];
    
    [forgotPassword setParts:[NSArray arrayWithObjects:plainPart, nil]];
    [forgotPassword send];
}
- (void)messageSent:(SKPSMTPMessage *)message {
    NSLog(@"Message Sent");
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Reset" message:@"Check your email for your new password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error {
    NSLog(@"Message Failed With Error(s): %@", [error description]);
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error reseting your password. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    // if location services are on
    if([CLLocationManager locationServicesEnabled])
    {
        switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Determining your current location cannot be performed at this time because location services are enabled but restricted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            // do some error handling
            lat = 0.0;
            lon = 0.0;
        }
            break;
        default:{
            [locationManager startUpdatingLocation];
        }
            break;
    }
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Determining your current location cannot be performed at this time because location services are not enabled." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}
#pragma  mark MAP ASSIGN

-(void)mapAssign
{
    if ([GOOGLE_MAP_KEY length] == 0)
    {
        // Blow up if APIKey has not yet been set.
        NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
        NSString *format = @"Configure APIKey inside SDKDemoAPIKey.h for your "
        @"bundle `%@`, see README.GoogleMapsSDKDemos for more information";
        @throw [NSException exceptionWithName:@"SDKDemoAppDelegate"
                                       reason:[NSString stringWithFormat:format, bundleId]
                                     userInfo:nil];
    }
    [GMSServices provideAPIKey:GOOGLE_MAP_KEY];
    services_ = [GMSServices sharedServices];
    
    // Log the required open source licenses!  Yes, just NSLog-ing them is not
    // enough but is good for a demo.
    NSLog(@"Open source licenses:\n%@", [GMSServices openSourceLicenseInfo]);
    
}


//+(BarButton*)setFooterPart
//{
//    BarButton *btnBar;
//    if (IS_IPHONE_5)
//    {
//        btnBar=[[BarButton alloc] initWithFrame:CGRectMake(0, 513, 320, 55)];
//    }
//    else
//    {
//        if(IS_IOS_6)
//        {
//            btnBar=[[BarButton alloc] initWithFrame:CGRectMake(0, 405, 320, 55)];
//        }
//        else
//        {
//            btnBar=[[BarButton alloc] initWithFrame:CGRectMake(0, 425, 320, 55)];
//        }
//    }
//    
//    return btnBar;
//}
#pragma mark Extra methods
-(UIView*)setFooterPart
{
    BarButton *btnBar;
    if (IS_IPHONE_5)
    {
        btnBar=[[BarButton alloc] initWithFrame:CGRectMake(0, 513, 320, 55)];
    }
    else if (IS_IPAD)
    {
        if(IS_IOS_6)
        {
            btnBar=[[BarButton alloc] initWithFrame:CGRectMake(0, 895, 768, 110)];
        }
        else
        {
            btnBar=[[BarButton alloc] initWithFrame:CGRectMake(0, 915, 768, 110)];
        }
    }
    else
    {
        if(IS_IOS_6)
        {
            btnBar=[[BarButton alloc] initWithFrame:CGRectMake(0, 405, 320, 55)];
        }
        else
        {
            btnBar=[[BarButton alloc] initWithFrame:CGRectMake(0, 425, 320, 55)];
        }
    }
    
    return btnBar;
}

-(UIView*)setMyLoyaltyTopPart
{
    loyaltyCardTopButton *btnTop;
    if (IS_IPHONE_5)
    {
        btnTop=[[loyaltyCardTopButton alloc] initWithFrame:CGRectMake(0, 65, 320, 40)];
    }
    else if (IS_IPAD)
    {
        if (IS_IOS_6)
        {
            btnTop=[[loyaltyCardTopButton alloc] initWithFrame:CGRectMake(0, 45, 768, 55)];
        }
        else
        {
            btnTop=[[loyaltyCardTopButton alloc] initWithFrame:CGRectMake(0, 65, 768, 55)];
        }
    } 
    else
    {
        if(IS_IOS_6)
        {
            btnTop=[[loyaltyCardTopButton alloc] initWithFrame:CGRectMake(0, 33, 320, 30)]; //35
        }
        else
        {
            // old iphone-ipad but new ios -(NTech iPad)
            btnTop=[[loyaltyCardTopButton alloc] initWithFrame:CGRectMake(0, 50, 320, 30)];
        }
    }
    
    return btnTop;
}
#pragma mark FACEBOOK
-(void)FBsessionCall
{
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
    {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    else
    {
//        UIButton *btnLogin=[viewObj btnFaceBook];
//        [btnLogin setTitle:@"sign in with Facebook" forState:UIControlStateNormal];
    }
}
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    
    if (!error && state == FBSessionStateOpen)
    {
        
            [FBSession.activeSession close];
            [FBSession.activeSession closeAndClearTokenInformation];
            FBSession.activeSession=nil;
        
            
        ////NSLog(@"Session opened");
//        [viewObj userLoggedIn];
//        [[Singleton sharedSingleton] setFacebookSession:@"open"];
//        [viewObj makeRequestForUserData];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed)
    {
        ////NSLog(@"Session closed");
//        [[Singleton sharedSingleton] setFacebookSession:@"close"];
        [FBSession.activeSession close];
        [FBSession.activeSession  closeAndClearTokenInformation];
        FBSession.activeSession=nil;
        
        NSUserDefaults *login=[NSUserDefaults standardUserDefaults];
        [login removeObjectForKey:@"Username"];
        [login removeObjectForKey:@"Token"];
        [login removeObjectForKey:@"FBid"];
        
        return;
//        [viewObj userLoggedOut];
    }
    
    // Handle errors
    if (error)
    {
        ////NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES)
        {
//            [viewObj cancelFbLogin];
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            //            [self showMessage:alertText withTitle:alertTitle];
        }
        else
        {
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled)
            {
//                [viewObj cancelFbLogin];
                ////NSLog(@"User cancelled login");
            }
            else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession)
            {
//                [viewObj cancelFbLogin];
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                //                [self showMessage:alertText withTitle:alertTitle];
            }
            else
            {
//                [viewObj cancelFbLogin];
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                //                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
//        [viewObj userLoggedOut];
    }
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
     application.applicationIconBadgeNumber = 0;
   // [self FBsessionCall];
    
    // Logs 'install' and 'app activate' App Events.
//    [FBAppEvents activateApp];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{

    if(!IS_IPAD)
    {
        UIViewController *lastViewController = [[self.navObj viewControllers] lastObject];
        
        if([lastViewController isKindOfClass:[DeliveryOrderDetail class]]) {
           // NSLog(@"Luke I'm your father :%@ ", lastViewController);
            return UIInterfaceOrientationMaskLandscape;
            //        return (UIInterfaceOrientationMaskLandscapeLeft || UIInterfaceOrientationMaskLandscapeRight);
        }
        else {
           // NSLog(@"Sorry bro, somebody else is the parent : %@", lastViewController);
            return UIInterfaceOrientationMaskPortrait;
        }
    }
     else  return UIInterfaceOrientationMaskPortrait;
}

@end
