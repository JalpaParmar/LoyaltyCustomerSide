//
//  Global .h
//  Loyalty App
//
//  Created by Amit Parmar on 18/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#ifndef Loyalty_App_Global__h
#define Loyalty_App_Global__h
#define IS_IPHONE_5 ( [ [ UIScreen mainScreen ] bounds ].size.height == 568 )
#define IS_IPAD ( [ [ UIScreen mainScreen ] bounds ].size.height == 1024 )
//#define IS_IPAD  ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define IS_IOS_6  ( [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 )
#define IS_IOS_8  ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 )

#define  APP  (AppDelegate*)[[UIApplication sharedApplication] delegate]

#define ERROR_EMPTY_DATA @"Please Fill Up All Fields"
#define ERROR_CHECK_TERMS @"Please Check Terms and Condition"
#define ERROR_PASSWORD_MISMATCH @"Passwords are not match"
#define ERROR_MSG @"There is some problem. Please try after some time."
#define ERROR_CONNECTION @"Please Check Internet connection"

#define HOSTNAME @"http://lab.ntechcorporate.com/api/Loyalty/"
#define HOSTMEDIA @"http://lab.ntechcorporate.com"
#define TOKEN @"LoyaltyAPI:A618A39C-1888-4D40-B06E-2D2F4AF8638E"
#define GOOGLE_MAP_KEY @"AIzaSyBPZrSjmy5t2KCt4UzbZ2RIv-U4Af8Z2tk"

#define ROOTVIEW [[[UIApplication sharedApplication] keyWindow] rootViewController]
#define CashOnDelivery @"COD"
#define online @"ONLINE"
#define OrderType_ATRestaurant @"AT Restaurant"
#define OrderType_TakeAway @"Take Away"
#define OrderType_HomeDelivery @"Home Delivery"

//#define FONT_centuryGothic_35 [UIFont fontWithName:@"Century Gothic" size:35];
//#define FONT_centuryGothic_65 [UIFont fontWithName:@"Century Gothic" size:65];
//#define FONT_centuryGothic_20 [UIFont fontWithName:@"Century Gothic" size:20];
//#define FONT_centuryGothic_20BOLD [UIFont fontWithName:@"Century Gothic Bold" size:20];
//#define FONT_centuryGothic_21 [UIFont fontWithName:@"Century Gothic" size:21];
//#define FONT_centuryGothic_21BOLD [UIFont fontWithName:@"Century Gothic Bold" size:21];

#define GRAYCOLOR [UIColor colorWithRed:154.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1]

//#define FONT_centuryGothic_DIFFERENTSIZE(S) [UIFont fontWithName:@"GOTHIC" size:S];

#define ACCEPTABLE_CHARECTERS_MOBILE @"0123456789+"
#define ACCEPTABLE_CHARECTERS_ZIPCODE @"0123456789-"


// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
// - For testing, use PayPalEnvironmentNoNetwork.
#define kPayPalEnvironment PayPalEnvironmentSandbox

#define ORDER_NOTIFICATION @"Order"
#define POINTS_NOTIFICATION @"LoyaltyPoints"
#define LOYALTYPROGRAM_NOTIFICATION @"LoyaltyProgram"
#define OFFER_NOTIFICATION @"SpecialOffer"
#define NEWRESTAURANT_NOTIFICATION @"NewRestaurant"
#define CHAT_NOTIFICATION @"Chat"
#define OTHER_NOTIFICATION @"Other"

#endif
