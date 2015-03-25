        //
//  singelton.m
//  Loyalty App
//
//  Created by Ntech Technologies on 8/11/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "Reachability.h"
#import "Singleton.h"
#import "addOrderViewController.h"
#import "Base64.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "homeDeliveryViewController.h"
#import "OrderDetailViewController.h"
#import "DashboardView.h"
#import "ViewController.h"
#import "AtRestaurantViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "MyrewardView.h"
#import "RestaurantView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "RedeemOrderViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@implementation Singleton
@synthesize connection, arrRestaurantList, indexId, arrItemListOfSelectedCategory, arrTableList, arrFavoriteRestaurantList, arrOrderOfCurrentUser, itemIndexId, flagGoToDirectAddOrder, arrCountryList, strImgEncoded, strImgFilename, arrICEContactDetail, arrICEIDCardDetail, arrICEMeditcation, arrStateList, arrbarcodeCardDetail, arrCompanyDetail, flagJoinFromDetail, arrCityList, charID, arrProfileDetail, arrChatDetail, strRestaurantForChat, arrRedeemPoints, arrOrderDetail, countryId, stateId, cityId,  countryDBID,stateDBID, cityDBID, path, polyline, arrGmsPolyLines, globalTotalPoints, minimumOrder, arrEditQtyOfOrderItems, PaymentMode, strEnteredOTP, hostReachability, wifiReachability,arrDiamondDetail, acceptCreditCards, internetReachability;

+(Singleton*)sharedSingleton
{
    static Singleton* theInstance=nil;
    if (theInstance==nil)
    {
        theInstance=[[self alloc] init];
    }

    return theInstance;
}
+ (void)showToastMessage:(NSString *)message {
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    // duration in seconds
    int duration = 2;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}
-(UIToolbar*)AccessoryButtonsForNumPad:(id)self_
{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self_ action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self_ action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    return numberToolbar;
}
#pragma mark CHECKING INTERNET CONNECTION
-(void)checkConnection
{
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //Change the host name here to change the server you want to monitor.
    NSString *remoteHostName = @"www.apple.com";
   // NSString *remoteHostLabelFormatString = NSLocalizedString(@"Remote Host: %@", @"Remote host label format string");
    //self.remoteHostLabel.text = [NSString stringWithFormat:remoteHostLabelFormatString, remoteHostName];
    
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    [self.wifiReachability startNotifier];
    [self updateInterfaceWithReachability:self.wifiReachability];
    
//    Reachability *reach = [Reachability reachabilityWithHostName:@"www.google.com"];
////    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
//    // Start the notifier, which will cause the reachability object to retain itself!
//    [reach startNotifier];
//    
//    connection=1;
//    
//    
////    reach.reachableBlock = ^(Reachability*reach)
////    {
////        NSLog(@"REACHABLE!");
////        connection=1;
////    };
////    
////    reach.unreachableBlock = ^(Reachability*reach)
////    {
////        NSLog(@"UNREACHABLE!");
////        connection=0;
////    };
}


/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}
- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.hostReachability)
    {
        [self configureTextField:reachability];
        
//        NetworkStatus netStatus = [reachability currentReachabilityStatus];
//        BOOL connectionRequired = [reachability connectionRequired];
        
//        self.summaryLabel.hidden = (netStatus != ReachableViaWWAN);
//        NSString* baseLabelText = @"";
//        
//        if (connectionRequired)
//        {
//            baseLabelText = NSLocalizedString(@"Cellular data network is available.\nInternet traffic will be routed through it after a connection is established.", @"Reachability text if a connection is required");
//        }
//        else
//        {
//            baseLabelText = NSLocalizedString(@"Cellular data network is active.\nInternet traffic will be routed through it.", @"Reachability text if a connection is not required");
//        }
        //self.summaryLabel.text = baseLabelText;
    }
    
    if (reachability == self.internetReachability)
    {
        [self configureTextField:reachability];
    }
    
    if (reachability == self.wifiReachability)
    {
        [self configureTextField:reachability];
    }
}
- (void)configureTextField:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    //BOOL connectionRequired = [reachability connectionRequired];
//NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:        {
            
            connection = 0 ;
            
         //   statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
          //  imageView.image = [UIImage imageNamed:@"stop-32.png"] ;
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
          //  connectionRequired = NO;
            break;
        }
            
        case ReachableViaWWAN:        {
            
             connection = 1 ;
            
          //  statusString = NSLocalizedString(@"Reachable WWAN", @"");
          //  imageView.image = [UIImage imageNamed:@"WWAN5.png"];
            break;
        }
        case ReachableViaWiFi:        {
            
            connection = 1 ;
            
         //   statusString= NSLocalizedString(@"Reachable WiFi", @"");
          //  imageView.image = [UIImage imageNamed:@"Airport.png"];
            break;
        }
    }
    
//    if (connectionRequired)
//    {
//        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
//        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
//    }
//    textField.text= statusString;
}
-(NSInteger) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            self.connection=0;
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.connection=1;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self.connection=1;
            break;
        }
    }
    return self.connection;
}
#pragma mark UIALERTVIEW CLICK EVENTS

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate *app =  APP;
    if(alertView.tag == 11)
    {
        [app.navObj popViewControllerAnimated:YES];
    }
    else if(alertView.tag == 18)
    {
        if(buttonIndex == 1)
        {
            [[Singleton sharedSingleton] checkViewControllerExitsNRemove];
            
            
            // clicked Ok
            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
            [st setObject:@"NO" forKey:@"IS_ORDER_START"];
            [st synchronize];
            
            BOOL IS_Order_StartDelete  = NO;
            [[Singleton sharedSingleton] callOrderStartService:@"" OrderStatus:IS_Order_StartDelete TableId:@""];
            
//            [app.navObj.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GoTobackFromNotification" object:self userInfo:nil];
        }
        else
        {
            // clicked Cancel
        }
    }
    else if(alertView.tag == 90)
    {
//        NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
//        [Singleton sharedSingleton].strEnteredOTP = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[alertView textFieldAtIndex:0] text]]];
//        if( [[Singleton sharedSingleton].strEnteredOTP isEqualToString:@""])
//        {
//            IS_OTP_SUCCESS= FALSE;
//            [Singleton showToastMessage:@"Please enter OTP"];
//        }
//        else
//        {
//            if([strOTPServer isEqualToString:[[alertView textFieldAtIndex:0] text]])
//            {
//                IS_OTP_SUCCESS= TRUE;
//                [[Singleton sharedSingleton] sendSuccessTranscationToServer];
//            }
//            else
//            {
//                IS_OTP_SUCCESS= FALSE;
//                [Singleton showToastMessage:@"OTP does not match"];
//            }
//        }
    }
    else if(alertView.tag == 345)
    {
        if(buttonIndex == 0)
        {
            //no
        }
        else if(buttonIndex == 1)
        {
            //yes
            self.IS_IMAGE_INSTAED_BARCODE = TRUE;
            [[Singleton sharedSingleton] setStrImgEncoded:@""];
            [[Singleton sharedSingleton] setStrImgFilename:@""];
            
            if(self.IS_FIRST_SIDE)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GettingBarcodePhoto" object:nil];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GettingBarcodePhoto1" object:nil];
            }
            AppDelegate *app = APP;
            [app.navObj dismissViewControllerAnimated: YES completion: nil];
            
        }
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
//    if(alertView.tag == 90)
//    {
//        if(!IS_OTP_SUCCESS)
//        {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:alertOTPMsg message:@"Enter OTP" delegate:self cancelButtonTitle:@"Send OTP" otherButtonTitles:nil, nil];
//            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//            [[alert textFieldAtIndex:0] resignFirstResponder];
//            [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypePhonePad];
//            [[alert textFieldAtIndex:0] becomeFirstResponder];
//            alert.tag = 90;
//            [alert show];
//        }
//    }
}


#pragma mark PAYPAL
-(void)PayPalConfigOnDidLoad
{
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    
    // Setting the payPalShippingAddressOption property is optional.
    //
    // See PayPalConfiguration.h for details.
    
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    self.successView.hidden = YES;
    
    // use default environment, should be Production in real life
    self.environment = kPayPalEnvironment;
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
    
}
- (void)setPayPalEnvironment {
    self.environment = kPayPalEnvironment;
    [PayPalMobile preconnectWithEnvironment:self.environment];
}
-(void)PayPalCheckOutClicked:(NSMutableDictionary*)dict
{
//    AppDelegate *app = APP;
    
    NSString *orderID = [dict objectForKey:@"orderID"];
    orderID = [self splitOrderIDFromDash:orderID];
    NSString *totalPrice = [dict objectForKey:@"totalPrice"];
    NSString *currencyCode = @"USD"; //[dict objectForKey:@"currencyCode"];
    
    // Remove our last completed payment, just for demo purposes.
    //  self.resultText = nil;
    
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    PayPalItem *item1 = [PayPalItem itemWithName:@"Item 1"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:totalPrice]
                                    withCurrency:currencyCode
                                         withSku:@"0001"];
    PayPalItem *item2 = [PayPalItem itemWithName:@"Item 2"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"0.0"]
                                    withCurrency:currencyCode
                                         withSku:@"0002"];
//    PayPalItem *item3 = [PayPalItem itemWithName:@"Long-sleeve plaid shirt (mustache not included)"
//                                    withQuantity:1
//                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"0.0"]
//                                    withCurrency:currencyCode
//                                         withSku:@"Hip-00291"];
    
    NSArray *items = @[item1, item2];
    
//    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
    [nf setMinimumFractionDigits:2];
    [nf setMaximumFractionDigits:2];
    NSString *ns  = [nf stringFromNumber:subtotal];
    subtotal = [NSDecimalNumber decimalNumberWithString:ns];

    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal  withShipping:shipping   withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = currencyCode;
    payment.shortDescription = [NSString stringWithFormat:@"Order ID: %@", orderID];//@"Hipster clothing";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    
    self.acceptCreditCards = TRUE; // extra
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment  configuration:self.payPalConfig  delegate:self];
            if(paymentViewController == nil)
            {
                
            }
            else
            {
                [ROOTVIEW presentViewController:paymentViewController animated:YES completion:nil]
                ;
            }
        });
        
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^ {
            PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment  configuration:self.payPalConfig  delegate:self];
            if(paymentViewController == nil)
            {
                
            }
            else
            {
                [ROOTVIEW presentViewController:paymentViewController animated:YES completion:nil]
                ;
            }
        });
    }
    
  

}
#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
    [self showSuccess];
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [ROOTVIEW dismissViewControllerAnimated:YES completion:nil];
    //     [self.navigationController popViewControllerAnimated:YES];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
    self.successView.hidden = YES;
    [ROOTVIEW dismissViewControllerAnimated:YES completion:nil];
    //    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Helpers

- (void)showSuccess {
    [Singleton sharedSingleton].successView.hidden = NO;
    [Singleton sharedSingleton].successView.alpha = 1.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:2.0];
    [Singleton sharedSingleton].successView.alpha = 0.0f;
    [UIView commitAnimations];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);

    self.transcationID = [[completedPayment.confirmation objectForKey:@"response"] objectForKey:@"id"];
    [self sendSuccessTranscationToServer];
 
    
}
-(void)sendSuccessTranscationToServer
{
    AppDelegate *app = APP;
    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
        UIView *viewBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ROOTVIEW.view.frame.size.width, ROOTVIEW.view.frame.size.height)];
        [viewBack setBackgroundColor:[UIColor blackColor]];
        viewBack.alpha = 0.600000023841858;
        [ROOTVIEW.view addSubview:viewBack];
        
        UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.color = [UIColor colorWithRed:85.0/255.0 green:195.0/255.0 blue:15.0/255.0 alpha:1];
        activityView.center=ROOTVIEW.view.center;
        [activityView startAnimating];
        [ROOTVIEW.view addSubview:activityView];
        
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        NSString * OrderID, *UserId ;
        if([st objectForKey:@"OrderID"])
        {
            OrderID =  [st objectForKey:@"OrderID"];
        }
        if([st objectForKey:@"UserId"])
        {
            UserId =  [st objectForKey:@"UserId"];
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:OrderID forKey:@"OrderId"];
        [dict setValue:PaymentMode forKey:@"PaymentMode"];
        if([PaymentMode isEqualToString:@"ONLINE"])
        {
            [dict setValue:[NSString stringWithFormat:@"%@", self.transcationID]  forKey:@"TransactionId"];
        }
        else if([PaymentMode isEqualToString:@"COD"])
        {
             [dict setValue:[NSString stringWithFormat:@"%@", self.strEnteredOTP]  forKey:@"TransactionId"];
        }
         [dict setValue:[NSString stringWithFormat:@"%d", [Singleton sharedSingleton].globalEnteredRedeemPoints] forKey:@"RedeemPoint"];
         [dict setValue:UserId forKey:@"CustomerID"];
        
        if(self.globalRedeemPoints_flag == 1)
        {
            [dict setValue:@"TRUE" forKey:@"RestaurantPoint"];
        }
        else
        {
            [dict setValue:@"FALSE" forKey:@"RestaurantPoint"];
        }
      
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Transction OrderStatus  Detail - %@ -- ", dict);
             if (dict)
             {
                 [activityView removeFromSuperview];
                 [viewBack removeFromSuperview];
                 
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                 }
                 else
                 {
                     [Singleton sharedSingleton].globalEnteredRedeemPoints=0;
                     PaymentMode=@"";
                     self.globalRedeemPoints_flag=FALSE;
                     if([PaymentMode isEqualToString:@"ONLINE"])
                     {
                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alt show];
                     }
                     else
                     {
                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alt show];
                     }
                     
                         //send - mean completed order - remove all settings
                         [[[Singleton sharedSingleton] arrOrderOfCurrentUser] removeAllObjects];
                         
                         //save "delete order " in prefernece
                         NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
                         [st setObject:@"NO" forKey:@"IS_ORDER_START"];
                         [st setObject:@"" forKey:@"OrderID"];
                         [st synchronize];
                         
                         DashboardView *payView;
                         if (IS_IPHONE_5)
                         {
                             payView=[[DashboardView alloc] initWithNibName:@"DashboardView-5" bundle:nil];
                         }
                         else if (IS_IPAD)
                         {
                             payView=[[DashboardView alloc] initWithNibName:@"DashboardView_iPad" bundle:nil];
                         }
                         else
                         {
                             payView=[[DashboardView alloc] initWithNibName:@"DashboardView" bundle:nil];
                         }
                         [app.navObj pushViewController:payView animated:NO];
                                         
                 }
//                 [self stopActivity];
             }
             else
             {
                 [activityView removeFromSuperview];
                 [viewBack removeFromSuperview];
                 
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
//                 [self stopActivity];
             }
         } :@"User/OrderTransction" data:dict];
    }
}

#pragma mark SEND OTP TO USER

-(void)sendOTPToUser
{
//    [self startActivity];
    
    UIView *viewBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ROOTVIEW.view.frame.size.width, ROOTVIEW.view.frame.size.height)];
    [viewBack setBackgroundColor:[UIColor blackColor]];
    viewBack.alpha = 0.600000023841858;
    [ROOTVIEW.view addSubview:viewBack];
    
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.color = [UIColor colorWithRed:85.0/255.0 green:195.0/255.0 blue:15.0/255.0 alpha:1];
    activityView.center=ROOTVIEW.view.center;
    [activityView startAnimating];
    [ROOTVIEW.view addSubview:activityView];
    
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    NSString * OrderID, *userId, *userEmail ;
    if([st objectForKey:@"OrderID"])
    {
        OrderID =  [st objectForKey:@"OrderID"];
    }
    if([st objectForKey:@"UserId"])
    {
        userId =  [st objectForKey:@"UserId"];
    }
    if([st objectForKey:@"userEMail"])
    {
        userEmail = [st objectForKey:@"userEMail"];
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:userEmail forKey:@"Email"];
    [dict setValue:userId forKey:@"UserId"];
    [dict setValue:OrderID forKey:@"OrderId"];
    
    [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
     {
         NSLog(@"OTP  - - %@ -- ", dict);
         
         if (dict)
         {
             Boolean strCode=[[dict objectForKey:@"code"] boolValue];
             if (!strCode)
             {
                 UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
             }
             else
             {
                 alertOTPMsg = [dict objectForKey:@"message"];
                 self.strOTPServer = [NSString stringWithFormat:@"%@", [dict objectForKey:@"data"]];
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"OTPSend" object:nil];
                 
//                 dispatch_async(dispatch_get_main_queue(), ^
//                {
//                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"Enter OTP" delegate:self cancelButtonTitle:@"Send OTP" otherButtonTitles:nil, nil];
//                    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//                    [[alert textFieldAtIndex:0] resignFirstResponder];
//                    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypePhonePad];
//                    [[alert textFieldAtIndex:0] becomeFirstResponder];
//                    alert.tag = 90;
//                    [alert show];
//                });
                 
             }
             
             [activityView removeFromSuperview];
             [viewBack removeFromSuperview];
             
//             [self stopActivity];
         }
         else
         {
             UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alt show];
//             [self stopActivity];
             
             
             [activityView removeFromSuperview];
             [viewBack removeFromSuperview];
             
         }
     } :@"Data/SendOtp" data:dict];
}

#pragma mark EXTRA METHODS
-(NSString*)ISNSSTRINGNULL:(NSString*)str
{
    NSString *returnStr=@"";
   
    if([str isEqual:[NSNull null] ] || [str isEqualToString:@""] || [str isEqualToString:@"(null)"] || [str isEqualToString:@"<null>"] || [str isEqualToString:nil] || str == nil || [str isEqual:nil] )
    {
        returnStr = @"";
    }
    else
    {
        returnStr = str;
    }
    return returnStr;
}
-(NSString *)getCurrentDayName
{
    NSDateFormatter *format =[[NSDateFormatter alloc] init];
    [format setDateFormat:@"EEEE"];
    
    return  [format stringFromDate:[NSDate date]];
}
-(NSString*)getDistanceBetweenLocations:(double)lat Lon:(double)lon Aontherlat:(double)anotherLat AnotheLong:(double)anotherLong
{
    //AppDelegate *app =  APP; //app.lat //app.lon
 
    
//    anotherLat = 52.2217331;
//    anotherLong = 21.0387832;
//    
//    lat = 19.0176147;
//    lon = 72.8561644;
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:anotherLat longitude:anotherLong];
    
    if(anotherLat <= 0 && anotherLong <= 0)
    {
        return @"";
    }
    CLLocationDistance distance = [locB distanceFromLocation:locA];

    
    CLLocationDistance kilometers = distance / 1000.0;
    NSString *distanceString = [[NSString alloc] initWithFormat: @"%.02f", kilometers];
    NSString *s ;
   
    if([distanceString length] > 4)
    {
        s = [distanceString substringToIndex:[distanceString length] - 4];
        if([s isEqualToString:@"0.00"])
        {
            distanceString = @"0";
        }
    }
    
    if([distanceString isEqualToString:@"0.00"] || [distanceString isEqualToString:@"0.000000"])
    {
        distanceString = @"0";
    }
    
    distanceString = [NSString stringWithFormat:@"%@ KM", distanceString];
    return distanceString ;
}

-(NSString *)ConvertMilliSecIntoDate:(NSString *)str
{
    //JoinDate = "/Date(1408365730630)/";
    
 //   NSString *str = [NSString stringWithFormat:@"%@", [[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"JoinDate"]];
    
    str = [str substringToIndex:[str length]- 2];
    NSArray *arr = [str componentsSeparatedByString:@"("];
    NSDate *joinDate;
    NSString *strJoinDate=@"";
    if([arr count] > 0)
    {
        str = [arr objectAtIndex:1];
        joinDate = [NSDate dateWithTimeIntervalSince1970:[[arr objectAtIndex:1] doubleValue]/1000];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"dd MMMM yyyy"];
        strJoinDate = [format stringFromDate:joinDate];
    }
    return strJoinDate;
    
}
-(NSString *)ConvertMilliSecIntoDate:(NSString *)str Format:(NSString*)formt
{
    // OrderDate = "2015-01-26T08:38:47.173";
    
    NSString *strJoinDate=@"";
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'.'SSS'"];
    NSDate *date = [df dateFromString:str];
    
    if(date == nil)
    {
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        date = [df dateFromString:str];
    }
    [df setDateFormat:formt];
    strJoinDate = [df stringFromDate:date];
    
    return strJoinDate;
   
}
-(NSString*)getCountryIdFromIndexId:(NSString*)cName
{
        //CountryId
        NSString *countryId_=@"";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"CountryName matches %@ ", [cName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSArray *array = [[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] filteredArrayUsingPredicate: predicate];
        NSMutableArray *arrFindingIds = [[NSMutableArray alloc] initWithArray:array];
        NSLog(@"---- %@", arrFindingIds);
        if([arrFindingIds count] > 0)
        {
            countryId_ = [NSString stringWithFormat:@"%@", [[arrFindingIds objectAtIndex:0] objectForKey:@"CountryId"]];
        }
        return countryId_;

}
-(NSString*)getStateIdFromIndexId:(NSString*)sName
{
    
    //StateId
    NSString *stateId_;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"StateName matches %@ ", [sName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSArray *array = [[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0] filteredArrayUsingPredicate: predicate];
    NSMutableArray *arrFindingIds = [[NSMutableArray alloc] initWithArray:array];
    NSLog(@"---- %@", arrFindingIds);
    if([arrFindingIds count] > 0)
    {
        stateId_ = [NSString stringWithFormat:@"%@", [[arrFindingIds objectAtIndex:0] objectForKey:@"StateID"]];
    }
    return stateId_;
}
-(NSString*)removePostfixFromTime:(NSString*)time
{
    NSString *finalTime = time;
  if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:time] isEqualToString:@""])
  {
      if(time.length > 6)
      {
          NSString *t = [time substringFromIndex:[time length]-3];
          if([t isEqualToString:@":00"])
          {
              finalTime = [time substringToIndex:[time length]-3];
          }
          else
          {
              finalTime = time;
          }
      }
      
  }
    else
    {
        finalTime = [[Singleton sharedSingleton] ISNSSTRINGNULL:time];
    }
     return  finalTime;
}
-(CGSize)heightOfTextForLabel:(NSString *)aString andFont:(UIFont *)aFont maxSize:(CGSize)aSize
{
    // iOS7
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        CGSize sizeOfText = [aString boundingRectWithSize:aSize   options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)  attributes: [NSDictionary dictionaryWithObject:aFont  forKey:NSFontAttributeName] context: nil].size;
//        NSLog(@" IOS 7 : %@ : %f", aString, sizeOfText.height);
        return sizeOfText;
    }
    
    // iOS6
    CGSize textSize = [aString sizeWithFont:aFont  constrainedToSize: aSize lineBreakMode:NSLineBreakByWordWrapping];
//    NSLog(@" IOS 6 : %@ : %f", aString, textSize.height);
    return textSize;
}

-(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews
{
    if ([view isKindOfClass:[UILabel class]])
    {
        UILabel *lbl = (UILabel *)view;
        CGFloat fontSize = lbl.font.pointSize;
        [lbl setFont:[UIFont fontWithName:fontFamily size:fontSize]];
      //  NSLog(@" ------  %@ -----  %f ", lbl.text, lbl.font.pointSize);
    }

    if ([view isKindOfClass:[UIButton class]])
    {
        UIButton *btn = (UIButton *)view;
        CGFloat fontSize = btn.titleLabel.font.pointSize;
        btn.titleLabel.font = [UIFont fontWithName:fontFamily size:fontSize];
//        NSLog(@" ------  %@ -----  %f ", btn.titleLabel.text, btn.titleLabel.font.pointSize);
    }
    
    if ([view isKindOfClass:[UITextField class]])
    {
        UITextField *txt = (UITextField *)view;
        CGFloat fontSize = txt.font.pointSize;
        [txt setFont:[UIFont fontWithName:fontFamily size:fontSize]];
//        NSLog(@" ------  %@ -----  %f ", txt.text, txt.font.pointSize);
    }
    
    if (isSubViews)
    {
        for (UIView *sview in view.subviews)
        {
            [self setFontFamily:fontFamily forView:sview andSubViews:YES];
        }
    }
}
-(NSString*)getReviewFromGLobalArray:(NSArray*)arrRating
{
    NSString *rRating;
    NSString *strRate = [[arrRating objectAtIndex:0] objectForKey:@"OrderRating"];
    @try {
        double r =[strRate doubleValue];
        rRating = [NSString stringWithFormat:@"%.01f", r];
    }@catch (NSException *exception) {
        strRate = [[Singleton sharedSingleton] ISNSSTRINGNULL:strRate
                   ];
        if(![strRate isEqualToString:@""])
        {
            rRating = strRate;
        }
        else
        {
            rRating = @"0";
        }
    }
    
    return rRating;
}
-(void)CallLogoutGlobally
{
    AppDelegate *app =APP;
    app._flagFromLogout = 1;
    NSUserDefaults *login=[NSUserDefaults standardUserDefaults];
    [login removeObjectForKey:@"userFirstName"];
    [login removeObjectForKey:@"userLastName"];
    [login removeObjectForKey:@"userMobileNo"];
    [login removeObjectForKey:@"UserId"];
    [login removeObjectForKey:@"userEMail"];
    
    [login removeObjectForKey:@"UserSelectedCountry"];
    [login removeObjectForKey:@"UserSelectedState"];
    [login removeObjectForKey:@" UserSelectedCity"];
    
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

- (NSString *) substituteEmoticons : (NSString*)msg {
	
	//See http://www.easyapns.com/iphone-emoji-alerts for a list of emoticons available
	
	NSString *res = [msg stringByReplacingOccurrencesOfString:@":)" withString:@"\ue415"];
	res = [res stringByReplacingOccurrencesOfString:@":(" withString:@"\ue403"];
	res = [res stringByReplacingOccurrencesOfString:@";-)" withString:@"\ue405"];
	res = [res stringByReplacingOccurrencesOfString:@":-x" withString:@"\ue418"];
	
	return res;
	
}
- (NSString *) getCurrentTime {
    
	NSDate *nowUTC = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	return [dateFormatter stringFromDate:nowUTC];
	
}
-(void)resetAllArrayAndVariables
{
    
    //Reset all array
    [[[Singleton sharedSingleton] arrbarcodeCardDetail] removeAllObjects];
    [[[Singleton sharedSingleton] arrCompanyDetail] removeAllObjects];
    [[[Singleton sharedSingleton] arrICEContactDetail] removeAllObjects];
    [[[Singleton sharedSingleton] arrFavoriteRestaurantList] removeAllObjects];
    [[[Singleton sharedSingleton] arrICEIDCardDetail] removeAllObjects];
    [[[Singleton sharedSingleton] arrICEMeditcation] removeAllObjects];
    [[[Singleton sharedSingleton] arrItemListOfSelectedCategory] removeAllObjects];
    [[[Singleton sharedSingleton] arrOrderOfCurrentUser] removeAllObjects];
    [[[Singleton sharedSingleton] arrRestaurantList] removeAllObjects];
    [[[Singleton sharedSingleton] arrTableList] removeAllObjects];
    [[[Singleton sharedSingleton] arrICEContactDetail] removeAllObjects];
    [[[Singleton sharedSingleton] arrItemListOfSelectedCategory] removeAllObjects];
    [[[Singleton sharedSingleton] arrProfileDetail] removeAllObjects];
    [[[Singleton sharedSingleton] arrRedeemPoints] removeAllObjects];
    [[[Singleton sharedSingleton] arrOrderDetail] removeAllObjects];
    [[[Singleton sharedSingleton] arrDiamondDetail] removeAllObjects];
    [[[Singleton sharedSingleton] arrEditQtyOfOrderItems] removeAllObjects];
    [[[Singleton sharedSingleton] arrGmsPolyLines] removeAllObjects];
      
    //                         [[[Singleton sharedSingleton] arrCountryList] removeAllObjects];
    //                          [[[Singleton sharedSingleton] arrStateList] removeAllObjects];
    //                         [[[Singleton sharedSingleton] arrCityList] removeAllObjects];
    
    //Reset all Variable
    [Singleton sharedSingleton].flagGoToDirectAddOrder = 0;
    [Singleton sharedSingleton].flagJoinFromDetail=0;
    [Singleton sharedSingleton].indexId=0;
    [Singleton sharedSingleton].itemIndexId=0;
    [Singleton sharedSingleton].strImgEncoded=@"";
    [Singleton sharedSingleton].strImgFilename=@"";
    [Singleton sharedSingleton].charID=@"";
    
    //Reset all Preference
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    [st removeObjectForKey:@"UserId"];
    [st removeObjectForKey:@"OrderID"];
    [st removeObjectForKey:@"SecretKey"];
    [st removeObjectForKey:@"IS_ORDER_START"];
    [st removeObjectForKey:@"OrderType"];
    [st removeObjectForKey:@"userFirstName"];
    [st removeObjectForKey:@"userLastName"];
    [st removeObjectForKey:@"userMobileNo"];
    [st removeObjectForKey:@"userEMail"];
    [st removeObjectForKey:@"ICEContactDetail"];
    [st removeObjectForKey:@"ICEIDCardDetail"];
    [st removeObjectForKey:@"ICEMeditcation"];
    [st removeObjectForKey:@"BarcodeCardDetail"];
    [st removeObjectForKey:@"CompanyDetail"];
    [st removeObjectForKey:@"ProfileDetail"];
    
    NSLog(@"Profile --- %lu", (unsigned long)[[[Singleton sharedSingleton] getarrProfileDetail] count]);
    
    [st synchronize];
    
}
-(void)checkViewControllerExitsNRemove
{
    
    AppDelegate *app = APP;
    for (UIViewController *vc in app.navObj.viewControllers) {

        NSLog(@" -- nav contorl  : %@",  app.navObj.viewControllers);
        
        if ([vc isKindOfClass:[OrderDetailViewController class]]) {
            //It exists
            [app.navObj popViewControllerAnimated:NO];
        }
        if ([vc isKindOfClass:[addOrderViewController class]]) {
            //It exists
            [app.navObj popViewControllerAnimated:NO];
        }
         if ([vc isKindOfClass:[homeDeliveryViewController class]]) {
            //It exists
            [app.navObj popViewControllerAnimated:NO];
        }
        if ([vc isKindOfClass:[MyrewardView class]]) {
            //It exists
            [app.navObj popViewControllerAnimated:NO];
        }
        if ([vc isKindOfClass:[AtRestaurantViewController class]]) {
            //It exists
            [app.navObj popViewControllerAnimated:NO];
        }
        if ([vc isKindOfClass:[RedeemOrderViewController class]]) {
            //It exists
            [app.navObj popViewControllerAnimated:NO];
        }
    }
    
}
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
- (BOOL) validateUrlWithString: (NSString *) candidate {
    NSString *urlRegEx =  @"(www\\.)[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}
-(void)ReadTermsCondition_privacypolicy:terms WebView:(UIWebView*)webview
{
    //html
    NSString *htmlFile = @"<html><body> Hi </body></html>";[[NSBundle mainBundle] pathForResource:@"sample" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [webview loadHTMLString:htmlString baseURL:nil];
    
    //url
//    webview.delegate = self;
//    NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webview setScalesPageToFit:YES];
//    [webview loadRequest:request];
}

-(CGSize)getDynamicHeightofLabels:(NSString*)text SIZE:(CGSize)aSize FONT:(UIFont*)font
{
        NSLog(@"---- %@ ----",  text);
    
        CGSize size_;

    if(IS_IOS_6)
    {
        size_= [[Singleton sharedSingleton] heightOfTextForLabel:text andFont:font maxSize:aSize];
    }
    else
    {
       size_= [text boundingRectWithSize:aSize
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{
                                                 NSFontAttributeName : font
                                                 } context:nil].size;
    }
    return size_;
    
}
-(NSString*)splitOrderIDFromDash:(NSString*)OrderId
{
    NSArray *tempArr = [OrderId componentsSeparatedByString:@"-"];
    if([tempArr count] > 0)
    {
        OrderId = [tempArr objectAtIndex:0];
    }
    return OrderId;
}
#pragma mark IS_ORDER_STARTED_DELETING
-(void)checkPendingOrderInArray
{

    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    
    if([st objectForKey:@"IS_ORDER_START"])
    {
        NSString *IS_STARTED = [st objectForKey:@"IS_ORDER_START"];
        if([IS_STARTED isEqualToString:@"YES"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to cancel this order?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
            alert.tag = 18;
            [alert show];
        }
        else
        {
           
        }
    }

    
    //    if([[[Singleton sharedSingleton] getarrOrderOfCurrentUser] count] > 0)
    //    {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your order Payment is pending. Still you want to leave? If Yes, order will be discarded." message:@"" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    //        alert.tag = 10;
    //        [alert show];
    //    }
}

//-(void)callOrderStartService:(id)unknownTypeParameter OrderStatus:(BOOL)IS_Order_StartDelete TableId:(NSString*)TableId
-(void)callOrderStartService:(NSString*)unknownTypeParameter OrderStatus:(BOOL)IS_Order_StartDelete TableId:(NSString*)TableId
{
   if ([[Singleton sharedSingleton] connection]==0)
    {
        // [self stopActivity];
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
    }
    else
    {
//        AppDelegate *app = APP;
        Class classFromString;
        if(![unknownTypeParameter isEqualToString:@"Singleton"])
        {
             classFromString = NSClassFromString(unknownTypeParameter);
        }
        //  RestaurantId,CategoryId
        NSString *strServiceName=@"";
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        if(IS_Order_StartDelete)
        {
            strServiceName=@"User/OrderStart";
            
            // YES - Order start
            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
            NSString * userId, *OrderType ;
            if([st objectForKey:@"UserId"])
            {
                userId =  [st objectForKey:@"UserId"];
            }
            NSString * restaurantId = [[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"UserId"];
            
            if([st objectForKey:@"OrderType"])
            {
                OrderType =  [st objectForKey:@"OrderType"];
            }
            
            NSString *SecretKey;
            if([st objectForKey:@"SecretKey"])
            {
                SecretKey =  [st objectForKey:@"SecretKey"];
            }
            
            [dict setValue:restaurantId forKey:@"RestaurantId"];
            [dict setValue:userId forKey:@"CustomerID"];
            //Home Delivery, Take Away,AT Restaurant
            [dict setValue:OrderType forKey:@"OrderType"];
            [dict setValue:TableId forKey:@"Tableid"];
            
            if(classFromString == [AtRestaurantViewController class])
            {
                [dict setValue:SecretKey forKey:@"SecretKey"];
            }
        }
        else
        {
             strServiceName=@"User/DeleteOrder";
            
            //NO - Deleting Order
            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
            
            if([st objectForKey:@"OrderID"])
            {
                NSString *orderId = [st objectForKey:@"OrderID"];
                [dict setValue:orderId forKey:@"OrderId"];
            }
        }
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Order Start  : %@ -- ", dict);
             if (dict)
             {
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
            
                 if (!strCode)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     
                     if(classFromString == [AtRestaurantViewController class])
                     {
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"GoToMainPageFail" object:self userInfo:nil];
                     }
                 }
                 else
                 {
//                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                     [alt show];
                     
                     
                     if(IS_Order_StartDelete)
                     {
                         NSString *OrderID  =@"";
                         if(dict)
                         {
                             if([[[Singleton sharedSingleton] getarrOrderOfCurrentUser]  count] > 0)
                             {
                                 //getarrOrderOfCurrentUser
                                 NSLog(@"before Remove : %@", [[Singleton sharedSingleton] getarrOrderOfCurrentUser] );
                                 [[[Singleton sharedSingleton] arrOrderOfCurrentUser] removeAllObjects];
                                 NSLog(@"After Remove : %@", [[Singleton sharedSingleton] getarrOrderOfCurrentUser] );
                               //  [[Singleton sharedSingleton] setarrOrderOfCurrentUser:[NSArray arrayWithObjects:@"", nil]] ;
                               //  NSLog(@"After Remove : %@", [[Singleton sharedSingleton] getarrOrderOfCurrentUser] );
                             }
                         
                             if([[[Singleton sharedSingleton] getarrEditQtyOfOrderItems]  count] > 0)
                             {
                                 //getarrEditQtyOfOrderItems
                                 NSLog(@"before Remove arrEditQtyOfOrderItems : %@", [[Singleton sharedSingleton] getarrEditQtyOfOrderItems] );
                                 [[[Singleton sharedSingleton] arrEditQtyOfOrderItems] removeAllObjects];
                                 NSLog(@"After Remove arrEditQtyOfOrderItems : %@", [[Singleton sharedSingleton] getarrOrderOfCurrentUser] );
                                // [[Singleton sharedSingleton] setarrEditQtyOfOrderItems:[NSArray arrayWithObjects:nil, nil]] ;
                                // NSLog(@"After Remove arrEditQtyOfOrderItems : %@", [[Singleton sharedSingleton] getarrEditQtyOfOrderItems] );
                             }
                          
                             
                             
                              if([dict objectForKey:@"data"])
                             {
                                 if([[dict objectForKey:@"data"] count] > 0)
                                 {
                                     OrderID = [[dict objectForKey:@"data"]  objectForKey:@"OrderID"];
                                 }
                             }
                         }
                         
                         //save "order start" in prefernece
                         NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
                         [st setObject:@"YES" forKey:@"IS_ORDER_START"];
                         [st setObject:OrderID forKey:@"OrderID"];
                         [st synchronize];
                         
                         if(classFromString == [AtRestaurantViewController class])
                         {
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"GoToMainPage" object:self userInfo:nil];
                         }
                     }
                     else
                     {
                         [[[Singleton sharedSingleton] arrOrderOfCurrentUser] removeAllObjects];
                         
                         //save "delete order " in prefernece
                         NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
                         [st setObject:@"NO" forKey:@"IS_ORDER_START"];
                         [st setObject:@"" forKey:@"OrderID"];
                         [st synchronize];

                        if([arrRedeemPoints count] > 0)
                         {
                             [arrRedeemPoints removeAllObjects];
                         }
                         if([arrOrderDetail count] > 0)
                         {
                             [arrOrderDetail removeAllObjects];
                         }
                                                 
                         if(classFromString == [OrderDetailViewController class])
                         {
                           // call notification
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"GoToDashboardFromNotification" object:self userInfo:nil];                             
                         }
                         if(classFromString == [AtRestaurantViewController class])
                         {
                             
                         }
                         
//                         if(classFromString == [AtRestaurantViewController class])
//                         {
//                             [[NSNotificationCenter defaultCenter] postNotificationName:@"GoToMainPage" object:self userInfo:nil];
//                         }
                     }
                 }
//                 if(classFromString == [OrderDetailViewController class])
//                 {
//                     OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
//                     [orderDetail stopActivity];
//                 }
//                 else if(classFromString == [homeDeliveryViewController class])
//                 {
//                     homeDeliveryViewController *orderDetail = [[homeDeliveryViewController alloc] init];
//                     [orderDetail stopActivity];
//                 }

                
             }
             else
             {
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
//                 if(classFromString == [OrderDetailViewController class])
//                 {
//                     OrderDetailViewController *orderDetail = [[OrderDetailViewController alloc] init];
//                     [orderDetail stopActivity];
//                 }
//                 else if(classFromString == [homeDeliveryViewController class])
//                 {
//                     homeDeliveryViewController *orderDetail = [[homeDeliveryViewController alloc] init];
//                     [orderDetail stopActivity];
//                 }

             }
         } :strServiceName data:dict];
    }
}
#pragma mark GOOGLE MAP

-(void)drawCircleAroundMe:(CLLocationCoordinate2D)coordinate GMSGOOGLEMAP:(GMSMapView*)mapView_{
    
    //Draw Circle around me
    GMSCircle *circ = [GMSCircle circleWithPosition:coordinate radius:10000];
    circ.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.05];
    circ.strokeColor = [UIColor colorWithRed:1.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:0.8]; //[UIColor blackColor];
    circ.strokeWidth = 1;
    circ.map = mapView_;
    
}
-(void)drawPathBetweenLocations:(NSMutableArray*)arr GMSGOOGLEMAP:(GMSMapView*)mapView_
{
    if(arrGmsPolyLines == nil)
    {
        arrGmsPolyLines = [[NSMutableArray alloc] init];
    }
    _coordinates = [NSMutableArray new];
    path = [GMSMutablePath path];
    for(int i=0; i<[arr count]; i++)
    {
         [arrGmsPolyLines addObject:[arr objectAtIndex:i]];
        
        NSArray *temparr = [[[arr objectAtIndex:i] objectForKey:@"LatLong"] componentsSeparatedByString:@"~"];
        if([temparr count] > 1)
        {
             [path addLatitude:[[temparr objectAtIndex:0] doubleValue] longitude:[[temparr objectAtIndex:1] doubleValue]];
             [_coordinates addObject:[[CLLocation alloc] initWithLatitude:[[temparr objectAtIndex:0] doubleValue] longitude:[[temparr objectAtIndex:1] doubleValue]]];
        }
        //[path addLatitude:app.lat longitude:app.lon];
   }
    
//    polyline = [GMSPolyline polylineWithPath:path];
//    polyline.strokeColor = [UIColor redColor];
//    polyline.strokeWidth = 2.f;
//    polyline.map = mapView_;

    
//    [_coordinates addObject:[[CLLocation alloc] initWithLatitude:destinationLat.doubleValue longitude:destinationLong.doubleValue]];
//    [_coordinates addObject:[[CLLocation alloc] initWithLatitude:sourceLat.doubleValue longitude:sourceLong.doubleValue]];
 
   
    if ([arrGmsPolyLines count] > 1)
    {
        _routeController = [LRouteController new];
        self.polyline.map = nil;
        
//        _markerStart = [GMSMarker new];
//        _markerStart.title=@"Start";
//        _markerFinish = [GMSMarker new];
//        _markerFinish.title=@"Finish";
        
        [_routeController getPolylineWithLocations:_coordinates travelMode:TravelModeDriving andCompletitionBlock:^(GMSPolyline *polylinee, NSError *error) {
            
           dispatch_async(dispatch_get_main_queue(), ^
           {
               if (error)
               {
                   NSLog(@"%@", error);
               }
               else if (!polylinee)
               {
                   NSLog(@"No route");
                   [Singleton showToastMessage:@"Can not find route"];
//                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can not find route" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                   [alert show];
               }
               else
               {
//                   _markerStart.position = [[_coordinates objectAtIndex:0] coordinate];
//                   _markerStart.map = mapView_;
//
//                   _markerFinish.position = [[_coordinates lastObject] coordinate];
//                   _markerFinish.map = mapView_;
                  // _markerFinish.icon = [UIImage imageNamed:@"map-pointer_new.png"];
                   
                   self.polyline = polylinee;
                   self.polyline.strokeWidth = 3;
                   self.polyline.strokeColor = [UIColor redColor];
                   self.polyline.map = mapView_;
               }

           });
            
            
        }];
    }
   
    
    
    NSLog(@"*** S *** : %@", arrGmsPolyLines);
}

-(void)RemovePathBetweenLocations:(NSMutableArray*)arr GMSGOOGLEMAP:(GMSMapView*)mapView_
{
//    path = [GMSMutablePath path];
//    for(int i=0; i<[arr count]; i++)
//    {
//        NSArray *temparr = [[[arr objectAtIndex:i] objectForKey:@"LatLong"] componentsSeparatedByString:@"~"];
//        if([temparr count] > 1)
//        {
//            [path addLatitude:[[temparr objectAtIndex:0] doubleValue] longitude:[[temparr objectAtIndex:1] doubleValue]];
//        }
//        //[path addLatitude:app.lat longitude:app.lon];
//    }
//    
//    polyline = [GMSPolyline polylineWithPath:path];
 
   
   // [mapView_ removeFromSuperview];
    
    for(int i=0; i<[arrGmsPolyLines count]; i++)
    {
        NSArray *temparr = [[[arrGmsPolyLines objectAtIndex:i] objectForKey:@"LatLong"] componentsSeparatedByString:@"~"];
        if([temparr count] > 1)
        {
            [path addLatitude:[[temparr objectAtIndex:0] doubleValue] longitude:[[temparr objectAtIndex:1] doubleValue]];
        }
        polyline = [GMSPolyline polylineWithPath:path];
        
        polyline.map = nil;
        _coordinates = nil;
    }
    
    NSLog(@"*** S ***");
    NSLog(@"****** : %@", [[Singleton sharedSingleton] polyline].path);
    NSLog(@"****** : %@", [Singleton sharedSingleton].path);
}

#pragma mark UIACTTIONSHEET - PHOTO (CAMERA/GALLRY)
-(NSString*)getPathofImageStoreInDevice
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}
- (UIImage*)getImageFromCache:(NSString*)path_
{
    NSString *getImagePath = [[self getPathofImageStoreInDevice] stringByAppendingPathComponent:path_];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
}
- (IBAction)saveImageInCache:(UIImage*)image ImgName:(NSString*)name
{
    NSString *savedImagePath = [[self getPathofImageStoreInDevice] stringByAppendingPathComponent:[name lastPathComponent]];
    NSData *imageDataa = UIImagePNGRepresentation(image);
    [imageDataa writeToFile:savedImagePath atomically:NO];
    NSLog((@"pre writing to file"));
    if (![imageDataa writeToFile:savedImagePath atomically:NO])
    {
        NSLog((@"Failed to cache image data to disk"));
    }
    else
    {
        NSLog(@"the cachedImagedPath is %@",savedImagePath);
    }
}

- (void)CameraClicked:(UIView*)view Control:(UIButton *)btn
{
    NSLog(@"CameraClicked : %hhd", self.IS_IMAGE_INSTAED_BARCODE);
     AppDelegate *app = APP;
    self.IS_FIRST_SIDE = TRUE;
    if(app._flagMainBtn == 3 && app._flagMyLoyaltyTopButtons == 1 && btn.tag == 2 && !self.IS_IMAGE_INSTAED_BARCODE)
    {
        self. IS_FIRST_SIDE = FALSE;
        ZBarReaderController *reader = [ZBarReaderController new];
        reader.readerDelegate = self;
        reader.showsHelpOnFail=NO;
        if([ZBarReaderController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            reader.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        
        [reader.scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
        [app.navObj presentViewController: reader animated: YES completion: nil];        
    }
    else
    {
        if(self.IS_IMAGE_INSTAED_BARCODE){
              self.IS_FIRST_SIDE = FALSE; // mean 2nd part
        }
        else{
              self.IS_FIRST_SIDE = TRUE; //mean 1st part
        }
        
        if(IS_IOS_8)
        {
            AppDelegate *app =APP;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Select Photo" preferredStyle:UIAlertControllerStyleActionSheet];
            
            // Set the sourceView.
            alert.popoverPresentationController.sourceView = view;
            
            // Set the sourceRect.
            //  alert.popoverPresentationController.sourceRect = CGRectMake((btn.frame.origin.x + btn.frame.size.width)/2, btn.frame.origin.y + btn.frame.size.height, 10, 10);
            
            //Open Popup in Center of View
            alert.popoverPresentationController.sourceRect = CGRectMake(view.center.x, view.center.y, 10, 10);
            
            // Remove arrow from action sheet.
            [alert.popoverPresentationController setPermittedArrowDirections:0];
            
            // Create and add an Action.
            UIAlertAction *anAction = [UIAlertAction actionWithTitle:@"Take a new photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"Action Pressed Take a new photo");
                [self takeNewPhotoFromCamera];
            }];
            
            [alert addAction:anAction];
            
            // Create and add an Action.
            UIAlertAction *anAction1 = [UIAlertAction actionWithTitle:@"Choose from existing" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"Action Pressed Choose from existing ");
                [self choosePhotoFromExistingImages];
            }];
            
            [alert addAction:anAction1];
            
            // Create and add an Action.
            UIAlertAction *anAction2 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                NSLog(@"Action Pressed Cancel");
                [self CancelAlertActionForIOS8];
            }];
            
            [alert addAction:anAction2];
            
            // Show the Alert.
            [app.navObj presentViewController:alert animated:YES completion:nil];
            
        }
        else
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self cancelButtonTitle: @"Cancel" destructiveButtonTitle: nil otherButtonTitles:
                                          @"Take a new photo",
                                          @"Choose from existing", nil];
            // [actionSheet showInView:view];
            [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
            //    [actionSheet showInView:self.parentViewController.view];
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            break;
        case 1:
            [self choosePhotoFromExistingImages];
        default:
            break;
    }
}
- (void)takeNewPhotoFromCamera
{
    AppDelegate *app = APP;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        controller.delegate = self;
        
         [app.navObj presentViewController: controller animated: YES completion: nil];
//        [self.navigationController presentViewController: controller animated: YES completion: nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your device doesn't supported camera." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)choosePhotoFromExistingImages
{
    AppDelegate *app = APP;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        //controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
         controller.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
        
        controller.delegate = self;
        [app.navObj presentViewController: controller animated: YES completion: nil];
//        [self.navigationController presentViewController: controller animated: YES completion: nil];
    }
}
-(void)CancelAlertActionForIOS8
{
    
}
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    AppDelegate *app = APP;
    [app.navObj dismissViewControllerAnimated: YES completion: nil];
    UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
    
    //save original image into gallery
    // Save the new image (original or edited) to the Camera Roll
//    UIImageWriteToSavedPhotosAlbum (image, nil, nil , nil);
    
    if(app._flagMainBtn == 3 && app._flagMyLoyaltyTopButtons == 1 && self.IS_FIRST_SIDE)
    {
        [self savePhotoToiPhoneGallery:image];
    }
    else if(app._flagMainBtn == 3 && app._flagMyLoyaltyTopButtons == 1 && !self.IS_FIRST_SIDE)
    {
        
        // ADD: get the decode results
        id<NSFastEnumeration> results =
        [info objectForKey: ZBarReaderControllerResults];
        ZBarSymbol *symbol = nil;
        for(symbol in results)
            // EXAMPLE: just grab the first barcode
            break;
        
        NSLog(@"Barcode Result : %@", symbol.data);
        self.strBarcodeId = [NSString stringWithFormat:@"%@", symbol.data];
        // EXAMPLE: do something useful with the barcode data
        
        [self savePhotoToiPhoneGallery:image];
    }
    
    image = [self imageWithImage:image scaledToSize:CGSizeMake(300, 300)];
    [self setstrImgEncoded:[self encodeToBase64String:image]];
   
    NSURL *resourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
    if(resourceURL) {
        // it's a video: handle import
      //  [self doSomethingWith:resourceURL];
    } else {
        // it's a photo
        resourceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
   
         ALAssetsLibrary *assetLibrary = [ALAssetsLibrary new];
        
        [assetLibrary assetForURL:resourceURL
                      resultBlock:^(ALAsset *asset) {
                          // get data
                          ALAssetRepresentation *assetRep = [asset defaultRepresentation];
                          NSString *filename = [assetRep filename];
                          [self setstrImgFilename:filename];
                          NSLog(@"Filename From Library - %@", filename);
                          
                          [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                              NSInteger numberOfAssets = [group numberOfAssets];
                              
                              if (numberOfAssets > 0) {
                                  NSInteger lastIndex = numberOfAssets - 1;
                                  [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:lastIndex] options:0 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                      
                                      if([[[Singleton sharedSingleton] ISNSSTRINGNULL:filename] isEqualToString:@""])
                                      {
                                          //UIImage *thumbnail = [UIImage imageWithCGImage:[result thumbnail]];
                                          ALAssetRepresentation *assetRep = [result defaultRepresentation];
                                          NSLog(@"FileName From camera: %@", [assetRep filename]);
                                          NSString * filename1 = [assetRep filename];
                                          if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:filename1] isEqualToString:@""])
                                          {
                                              [self setstrImgFilename:filename1];
                                              
                                              if(app._flagMainBtn == 3 && app._flagMyLoyaltyTopButtons == 1 && self.IS_FIRST_SIDE)
                                              {
                                                  [self saveImageInCache:image ImgName:[[Singleton sharedSingleton] getstrImgFilename]];
                                              }
                                              else if(app._flagMainBtn == 3 && app._flagMyLoyaltyTopButtons == 1 && !self.IS_FIRST_SIDE)
                                              {
                                                  [self saveImageInCache:image ImgName:[[Singleton sharedSingleton] getstrImgFilename]];
                                              }
                                              
                                              if(self.IS_FIRST_SIDE)
                                              {
                                                  self.strFullPathOfImage = [NSString stringWithFormat:@"%@%@", [self getPathofImageStoreInDevice], [[Singleton sharedSingleton] getstrImgFilename] ];
                                                  NSLog(@"strFullPathOfImage : %@", self.strFullPathOfImage);
                                                  
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"GettingBarcodePhoto" object:nil];
                                              }
                                              else
                                              {
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"GettingBarcodePhoto1" object:nil];
                                              }
                                              
                                          }
                                      }
                                  }];
                              }
                          } failureBlock:^(NSError *error) {
                              NSLog(@"error: %@", error);
                          }];
                          
                          if(app._flagMainBtn == 3 && app._flagMyLoyaltyTopButtons == 1 && self.IS_FIRST_SIDE)
                          {
                              [self saveImageInCache:image ImgName:[[Singleton sharedSingleton] getstrImgFilename]];
                          }
                          else if(app._flagMainBtn == 3 && app._flagMyLoyaltyTopButtons == 1 && !self.IS_FIRST_SIDE)
                          {
                              [self saveImageInCache:image ImgName:[[Singleton sharedSingleton] getstrImgFilename]];
                          }
                          
                          if(self.IS_FIRST_SIDE)
                          {
                              self.strFullPathOfImage = [NSString stringWithFormat:@"%@%@", [self getPathofImageStoreInDevice], [[Singleton sharedSingleton] getstrImgFilename] ];
                              NSLog(@"strFullPathOfImage : %@", self.strFullPathOfImage);
                              
                              [[NSNotificationCenter defaultCenter] postNotificationName:@"GettingBarcodePhoto" object:nil];
                          }
                          else
                          {
                              [[NSNotificationCenter defaultCenter] postNotificationName:@"GettingBarcodePhoto1" object:nil];
                          }
                      }
                     failureBlock:^(NSError *error) {
                         NSLog(@"%@", error);
                     }];
        
        return;
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [[Singleton sharedSingleton] setStrImgEncoded:@""];
    [[Singleton sharedSingleton] setStrImgFilename:@""];
    
    if(self.IS_FIRST_SIDE)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GettingBarcodePhoto" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GettingBarcodePhoto1" object:nil];
    }
    AppDelegate *app = APP;
    [app.navObj dismissViewControllerAnimated: YES completion: nil];
    
}
- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry
{
    NSLog(@"No Barcode Detected : %hhd", retry);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No barcode detected. Do you want to add image without barcode?" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 345;
    [alert show];
}
-(NSArray*)getListOfImagesCaches:(NSString*)end
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:[self getPathofImageStoreInDevice] error:nil];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self ENDSWITH '%@'", end]];
    
    NSArray *onlyJPGs = [dirContents filteredArrayUsingPredicate:fltr];   
    return onlyJPGs;
}

#pragma mark  show images that are stored in document directory to iphone gallery
-(void)savePhotoToiPhoneGallery:(UIImage *)image
{
    
   self.library = [[ALAssetsLibrary alloc] init];
   [self.library saveImage:image toAlbum:@"Loyalty App" withCompletionBlock:^(NSError *error) {
        if (error!=nil) {
            NSLog(@"Big error: %@", [error description]);
        }
    }];
    
        //    NSURL *imageURL = receivedURL;
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void) savedPhotoImage:(UIImage *)image  didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                    message:@"This image has been saved to your photo album"
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    [alert show];
}

#pragma mark  ENCODE - DECODE IMAGEVIEW

- (NSString *)encodeToBase64String:(UIImage *)image {
    if(IS_IOS_6)
    {
         NSData* data = UIImageJPEGRepresentation(image, 1.0f);
         return [Base64 encode:data];
    }
    else
    {
//        NSLog(@" ***************************** ");
//        NSLog(@"%@", [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]);
//        NSLog(@" ***************************** ");
        
        return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
}
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData * data;
    if(IS_IOS_6)
    {
        data = [Base64 decode:strEncodeData ];;
        return [UIImage imageWithData:data];
    }
    else
    {
        NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
        return [UIImage imageWithData:data];
     }
}

#pragma mark CALL PROGRAMMATICALLY

-(void)CALLPhoneNumberProgrammatically:(NSString *)number
{
    number = [number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", number];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    if([[UIApplication sharedApplication] openURL:phoneURL])
    {
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Call not Supported by this Device" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
# pragma mark ERROR ALERT
-(void)errorFilledUpAllData
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ERROR_EMPTY_DATA message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)errorCheckTermsCondition
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ERROR_CHECK_TERMS message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)errorPasswordMismatch
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ERROR_PASSWORD_MISMATCH message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)errorInternetConnection
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag = 11;
    [alert show];
}
-(void)errorLoginFirst
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Login First" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];

}

#pragma Extra COMMON METHODS

#pragma mark WEBSERVICE for Difeerent task
-(void)getDataWithBlokc:(OnComplate)block :(NSString*)strUrl data:(NSDictionary*)dictData
{
    NSString *hostURL=[NSString stringWithFormat:@"%@%@",HOSTNAME, strUrl];
    hostURL = [hostURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL *url=[[NSURL alloc] initWithString:hostURL];
    NSLog(@"HOST URL ----: %@", hostURL);
    
    NSData *jsonData;
    NSString *jsonString;
    NSMutableURLRequest *request;
    
    if ([NSJSONSerialization isValidJSONObject:dictData])
    {
        jsonData=[NSJSONSerialization dataWithJSONObject:dictData options:0 error:nil];
        jsonString=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@", TOKEN] forHTTPHeaderField:@"LoyaltyToken"];

    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *dict=[[NSDictionary alloc] init];
         NSInteger httpStatus = [((NSHTTPURLResponse *)response) statusCode];
         NSLog(@"httpStatus inside block:%ld",(long)httpStatus);
         
        // NSLog(@"Authorization, %@, %@", [request valueForHTTPHeaderField:@"LoyaltyToken"], request.allHTTPHeaderFields);
    
        NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"got Login Data   %@" , myString);
         
         if ([data length]>0 && connectionError==nil)
         {
             dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&connectionError];
             
             block(dict);
         }
         else if (connectionError)
         {
             block(dict);
         }
     }];
}

-(void)getDataWithBlokc_GET:(OnComplate)block :(NSString*)strUrl
{
    NSString *hostURL=[NSString stringWithFormat:@"%@%@",HOSTNAME, strUrl];
    hostURL = [hostURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL *url=[[NSURL alloc] initWithString:hostURL];
    NSLog(@"HOST URL ----: %@", hostURL);
    
    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request addValue:[NSString stringWithFormat:@"%@", TOKEN] forHTTPHeaderField:@"LoyaltyToken"];
    
     [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *dict=[[NSDictionary alloc] init];
         NSInteger httpStatus = [((NSHTTPURLResponse *)response) statusCode];
         NSLog(@"httpStatus inside block:%ld",(long)httpStatus);
         
         // NSLog(@"Authorization, %@, %@", [request valueForHTTPHeaderField:@"LoyaltyToken"], request.allHTTPHeaderFields);
         
//         NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         //NSLog(@"got URL Data   %@" , myString);
         
         if ([data length]>0 && connectionError==nil)
         {
             dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&connectionError];
             
             block(dict);
         }
         else if (connectionError)
         {
             block(dict);
         }
     }];
}

-(void)getCountryList
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [altMsg show];
        [altMsg performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    }
    else
    {
//        if([[[Singleton sharedSingleton] getarrCountryList] count] > 0)
//        {
//
//        }
//        else
//        {
            [self getDataWithBlokc_GET:^(NSDictionary *dict)
             {
                 NSLog(@"Country List :  %@ -- ", dict);
                 
                 if (dict)
                 {
                     
                     Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                     if (!strCode)
                     {
                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alt show];
                         //[[NSNotificationCenter defaultCenter] postNotificationName:@"GettingCountryList" object:nil];
                     }
                     else
                     {
                         [[Singleton sharedSingleton] setarrCountryList:[dict objectForKey:@"data"]];
                         NSLog(@"Getting Country...!");
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"GettingCountryList" object:nil];
                     }
                 }
                 else
                 {
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                 }
             } :@"Data/CountryList"];
//        }
    }
}
-(void)getStateList:(NSString*)CID
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
    }
    else
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:CID forKey:@"countryId"];
        
        [self getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"%@", [dict objectForKey:@"data"]);
             
             if (dict)
             {
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     [[[Singleton sharedSingleton] arrStateList] removeAllObjects];
                     
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"GettingStateList" object:nil];
                 }
                 else
                 {
                     [[Singleton sharedSingleton] setarrStateList:[dict objectForKey:@"data"]];
                     NSLog(@"Getting State...!");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GettingStateList" object:nil];
                 }
             }
             else
             {
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
             }
         } :@"Data/StateList" data:dict];
    }
}
-(void)getCityList:(NSString*)SID
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    }
    else
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:SID forKey:@"stateId"];
        
        [self getDataWithBlokc:^(NSDictionary *dict)
         {
             //             NSLog(@"City List :  %@ -- ", dict);
             if (dict)
             {
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     [[[Singleton sharedSingleton] arrCityList] removeAllObjects];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"GettingCityList" object:nil];
                 }
                 else
                 {
                     //                    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:[dict objectForKey:@"data"], nil];
                     [[Singleton sharedSingleton] setarrCityList:[dict objectForKey:@"data"]];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"GettingCityList" object:nil];
                     //                     NSLog(@"Getting City...! : %d", [[[Singleton sharedSingleton] getarrCityList] count]);
                 }
             }
             else
             {
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
             }
         } :@"Data/GetCitysByState" data:dict];
    }
}
/*-(void)getCityList
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    }
    else
    {
        [self getDataWithBlokc_GET:^(NSDictionary *dict)
         {
//             NSLog(@"City List :  %@ -- ", dict);
             if (dict)
             {
                Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                   
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"GettingCityList" object:nil];
                 }
                 else
                 {
//                    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:[dict objectForKey:@"data"], nil];
                     [[Singleton sharedSingleton] setarrCityList:[dict objectForKey:@"data"]];
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"GettingCityList" object:nil];
//                     NSLog(@"Getting City...! : %d", [[[Singleton sharedSingleton] getarrCityList] count]);
                 }
             }
             else
             {
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
             }
         } :@"Data/GetCityList"];
    }
}*/
#pragma mark GETTER - SETTER Methods

-(void)setarrRestaurantList:(NSArray*)arr
{
    arrRestaurantList  = [[NSMutableArray alloc] init];
    arrRestaurantList = arr;
}
-(NSMutableArray*)getarrRestaurantList
{
    return arrRestaurantList;
}
-(void)setIndexId:(int)index
{
    indexId = index;
}
-(int)getIndexId
{
    return indexId;
}
-(void)setitemIndexId:(int)index
{
     itemIndexId = index;
}
-(int)getitemIndexId
{
    return itemIndexId;
}
-(void)setflagGoToDirectAddOrder:(int)index
{
    flagGoToDirectAddOrder = index;
}
-(int)getflagGoToDirectAddOrder
{
    return flagGoToDirectAddOrder;
}
-(void)setarrItemListOfSelectedCategory:(NSArray*)arr
{
    arrItemListOfSelectedCategory  = [[NSMutableArray alloc] init];
    [arrItemListOfSelectedCategory addObject:arr];
}
-(NSMutableArray*)getarrItemListOfSelectedCategory
{
    return arrItemListOfSelectedCategory;
}
-(void)setarrTableList:(NSArray*)arr
{
    arrTableList  = [[NSMutableArray alloc] init];
    [arrTableList addObject:arr];
}
-(NSMutableArray*)getarrTableList
{
     return arrTableList;
}
-(void)setarrFavoriteRestaurantList:(NSArray*)arr
{
    arrFavoriteRestaurantList  = [[NSMutableArray alloc] init];
    [arrFavoriteRestaurantList addObject:arr];
}
-(NSMutableArray*)getarrFavoriteRestaurantList
{
    return arrFavoriteRestaurantList;
}
-(void)setarrOrderOfCurrentUser:(NSArray*)arr
{
   if([arrOrderOfCurrentUser count] <=0 || arrOrderOfCurrentUser == nil)
   {
        arrOrderOfCurrentUser = [[NSMutableArray alloc] init];
   }
    if([arr count] > 0)
    {
          [arrOrderOfCurrentUser addObject:[arr  objectAtIndex:0]];
    }
    else
    {
          [arrOrderOfCurrentUser addObject:arr];
    }
   
}
-(NSMutableArray*)getarrOrderOfCurrentUser
{
    return arrOrderOfCurrentUser;
}
-(void)setarrCountryList:(NSArray*)arr
{
    arrCountryList  = [[NSMutableArray alloc] init];
    [arrCountryList addObject:arr];
}
-(NSMutableArray*)getarrCountryList
{
    return arrCountryList;
}
-(void)setarrStateList:(NSArray*)arr
{
    arrStateList  = [[NSMutableArray alloc] init];
    [arrStateList addObject:arr];
}
-(NSMutableArray*)getarrStateList
{
    return arrStateList;
}
-(void)setstrImgEncoded:(NSString*)str
{
    strImgEncoded = str;
}
-(NSString*)getstrImgEncoded
{
    return strImgEncoded;
}
-(void)setstrImgFilename:(NSString*)str
{
    strImgFilename = str;
}
-(NSString*)getstrImgFilename
{
    return strImgFilename;
}
-(void)setarrICEContactDetail:(NSArray*)arr
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *theData=[NSKeyedArchiver archivedDataWithRootObject:arr];
    [defaults setObject:theData forKey:@"ICEContactDetail"];
    [defaults synchronize];
//    NSLog(@"1--- %@", [defaults objectForKey:@"ICEContactDetail"]);
    
    NSData *theData1=[defaults dataForKey:@"ICEContactDetail"];
    if (theData1 != nil)
        arrICEContactDetail =(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:theData1];
//    NSLog(@"2--- %d", [arrICEContactDetail count]);
    
//    arrICEContactDetail  = [[NSMutableArray alloc] init];
//    [arrICEContactDetail addObject:arr];
}
-(NSMutableArray*)getarrICEContactDetail
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *theData1=[defaults dataForKey:@"ICEContactDetail"];
    if (theData1 != nil)
    {
        arrICEContactDetail =(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:theData1];
        return arrICEContactDetail;
    }
    else
    {
        return arrICEContactDetail;
    }

    
//    return arrICEContactDetail;
}
-(void)setarrICEIDCardDetail:(NSArray*)arr
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *theData=[NSKeyedArchiver archivedDataWithRootObject:arr];
    [defaults setObject:theData forKey:@"ICEIDCardDetail"];
    [defaults synchronize];
//    NSLog(@"1--- %@", [defaults objectForKey:@"ICEIDCardDetail"]);
    
    NSData *theData1=[defaults dataForKey:@"ICEIDCardDetail"];
    if (theData1 != nil)
        arrICEIDCardDetail =(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:theData1];
//    NSLog(@"2--- %d", [arrICEIDCardDetail count]);
    
//    arrICEIDCardDetail  = [[NSMutableArray alloc] init];
//    [arrICEIDCardDetail addObject:arr];
}
-(NSMutableArray*)getarrICEIDCardDetail
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *theData1=[defaults dataForKey:@"ICEIDCardDetail"];
    if (theData1 != nil)
    {
        arrICEIDCardDetail =(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:theData1];
        return arrICEIDCardDetail;
    }
    else
    {
        return arrICEIDCardDetail;
    }
}
-(void)setarrICEMeditcation:(NSArray*)arr
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *theData=[NSKeyedArchiver archivedDataWithRootObject:arr];
    [defaults setObject:theData forKey:@"ICEMeditcation"];
    [defaults synchronize];
//    NSLog(@"1--- %@", [defaults objectForKey:@"ICEMeditcation"]);
    
    NSData *theData1=[defaults dataForKey:@"ICEMeditcation"];
    if (theData1 != nil)
        arrICEMeditcation =(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:theData1];
//    NSLog(@"2--- %d", [arrICEMeditcation count]);
    
//    arrICEMeditcation  = [[NSMutableArray alloc] init];
//    [arrICEMeditcation addObject:arr];
}
-(NSMutableArray*)getarrICEMeditcation
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *theData1=[defaults dataForKey:@"ICEMeditcation"];
    if (theData1 != nil)
    {
        arrICEMeditcation =(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:theData1];
        return arrICEMeditcation;
    }
    else
    {
        return arrICEMeditcation;
    }
//    return arrICEMeditcation;
}
-(void)setarrbarcodeCardDetail:(NSArray*)arr
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *theData=[NSKeyedArchiver archivedDataWithRootObject:arr];
    [defaults setObject:theData forKey:@"BarcodeCardDetail"];
    [defaults synchronize];
//    NSLog(@"1--- %@", [defaults objectForKey:@"BarcodeCardDetail"]);
   
    NSData *theData1=[defaults dataForKey:@"BarcodeCardDetail"];
    if (theData1 != nil)
        arrbarcodeCardDetail =(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:theData1];
   NSLog(@"2--- %d", [arrbarcodeCardDetail count]);
    
}
-(NSMutableArray*)getarrbarcodeCardDetail
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *theData1=[defaults dataForKey:@"BarcodeCardDetail"];
    if (theData1 != nil)
    {
        arrbarcodeCardDetail =(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:theData1];
        return arrbarcodeCardDetail;
    }
    else
    {
        return arrbarcodeCardDetail;
    }
}
-(void)setarrDiamondDetail:(NSArray*)arr
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *theData=[NSKeyedArchiver archivedDataWithRootObject:arr];
    [defaults setObject:theData forKey:@"DiamondDetail"];
    [defaults synchronize];
  
    NSData *theData1=[defaults dataForKey:@"DiamondDetail"];
    if (theData1 != nil)
        arrDiamondDetail =(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:theData1];

}
-(NSMutableArray*)getarrDiamondDetail
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *theData1=[defaults dataForKey:@"DiamondDetail"];
    if (theData1 != nil)
    {
        arrDiamondDetail =(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:theData1];
        return arrDiamondDetail;
    }
    else
    {
        return arrDiamondDetail;
    }
}
-(void)setarrCompanyDetail:(NSArray*)arr
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *theData=[NSKeyedArchiver archivedDataWithRootObject:arr];
    [defaults setObject:theData forKey:@"CompanyDetail"];
    [defaults synchronize];
    
    NSData *theData1=[defaults dataForKey:@"CompanyDetail"];
    if (theData1 != nil)
        arrCompanyDetail =(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:theData1];
    
//    arrCompanyDetail  = [[NSMutableArray alloc] init];
//    [arrCompanyDetail addObject:arr];
}
-(NSMutableArray*)getarrCompanyDetail
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *theData1=[defaults dataForKey:@"CompanyDetail"];
    if (theData1 != nil)
    {
        arrCompanyDetail =(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:theData1];
        return arrCompanyDetail;
    }
    else
    {
        return arrCompanyDetail;
    }
    
//     return arrCompanyDetail;
}
-(void)setarrProfileDetail:(NSArray*)arr
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *theData=[NSKeyedArchiver archivedDataWithRootObject:arr];
    [defaults setObject:theData forKey:@"ProfileDetail"];
    [defaults synchronize];
    //    NSLog(@"1--- %@", [defaults objectForKey:@"BarcodeCardDetail"]);
    
    NSData *theData1=[defaults dataForKey:@"ProfileDetail"];
    if (theData1 != nil)
        arrProfileDetail =(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:theData1];
    
}
-(NSMutableArray*)getarrProfileDetail
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *theData1=[defaults dataForKey:@"ProfileDetail"];
    if (theData1 != nil)
    {
        arrProfileDetail =(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:theData1];
        return arrProfileDetail;
    }
    else
    {
        return arrProfileDetail;
    }
}

-(void)setarrCityList:(NSMutableArray*)arr
{
    arrCityList  = [[NSMutableArray alloc] initWithObjects:arr, nil];
}
-(NSMutableArray*)getarrCityList
{
     return arrCityList;
}
-(void)setcharID:(NSString*)str
{
     charID = str;
}
-(NSString*)getcharID
{
    return charID;
}
-(void)setarrChatDetail:(NSArray*)arr
{
    if(arrChatDetail == nil)
    {
        arrChatDetail = [[NSMutableArray alloc] init];
    }
    
//    if([arr count] > 0)
//    {
//        if([[arr objectAtIndex:0] count] > 0)
//        {
////            [arrChatDetail addObject:[arr objectAtIndex:0]];
//               arr = [arr objectAtIndex:0];
//        }
//    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *theData=[NSKeyedArchiver archivedDataWithRootObject:arr];
    [defaults setObject:theData forKey:@"ChatDetail"];
    [defaults synchronize];
   
    NSData *theData1=[defaults dataForKey:@"ChatDetail"];
    if (theData1 != nil)
        arrChatDetail = [NSKeyedUnarchiver unarchiveObjectWithData:theData1];
    
}
-(NSMutableArray*)getarrChatDetail
{
//    return arrChatDetail;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *theData1=[defaults dataForKey:@"ChatDetail"];
    if (theData1 != nil)
    {
        arrChatDetail =(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:theData1];
        return arrChatDetail;
    }
    else
    {
        return arrChatDetail;
    }
}
-(void)setarrRedeemPoints:(NSArray*)arr
{
    if(arrRedeemPoints == nil)
    {
        arrRedeemPoints = [[NSMutableArray alloc] init];
    }
    
    NSLog(@"before arrRedeemPoints : %@", arrRedeemPoints);
    
    if([arr count] > 0)
    {
        if([[arr objectAtIndex:0] count] > 0)
        {
            [arrRedeemPoints addObject: [arr objectAtIndex:0]];
        }
    }
   NSLog(@"Set Array Redeem : %@", arrRedeemPoints);
    
}
-(NSMutableArray*)getarrRedeemPoints
{
    return arrRedeemPoints;
}
-(void)setarrOrderDetail:(NSArray*)arr
{
//    if(arrOrderDetail == nil)
//    {
//        arrOrderDetail = [[NSMutableArray alloc] init];
//    }
    arrOrderDetail = [[NSMutableArray alloc] init];
    NSLog(@"before arrOrderDetail : %@", arrOrderDetail);
    
    if([arr count] > 0)
    {
        if([[arr objectAtIndex:0] count] > 0)
        {
            [arrOrderDetail addObject: [arr objectAtIndex:0]];
        }
    }
    NSLog(@"Set Array arrOrderDetail : %@", arrOrderDetail);

}
-(NSMutableArray*)getarrOrderDetail
{
     return arrOrderDetail;
}

-(void)setstrRestaurantForChat:(NSString*)str
{
    strRestaurantForChat = str;
}
-(NSString*)getstrRestaurantForChat
{
    return strRestaurantForChat;
}
-(void)setstrLoginUserChat:(NSString*)str
{
    strLoginUserChat = str;
}
-(NSString*)getstrLoginUserChat
{
    return strLoginUserChat;
}
-(void)setCountryId:(NSString *)c
{
    countryId = c;
}
-(void)setStateId:(NSString *)s
{
    stateId = s;
}
-(void)setCityId:(NSString *)ct
{
    cityId = ct;
}
-(void)setCountryDBID:(NSString *)cid
{
    countryDBID = cid;
}
-(void)setStateDBID:(NSString *)sid
{
    stateDBID = sid;
}
-(void)setCityDBID:(NSString *)ctid
{
    cityDBID = ctid;
}
-(void)setarrEditQtyOfOrderItems:(NSArray*)arr
{
    if(arrEditQtyOfOrderItems == nil)
    {
        arrEditQtyOfOrderItems = [[NSMutableArray alloc] init];
    }
    
    NSLog(@"before singleton : %@", arrEditQtyOfOrderItems);
    
    if([arr count] > 0)
    {
        if([[arr objectAtIndex:0] count] > 0)
        {
            [arrEditQtyOfOrderItems addObject: [arr objectAtIndex:0]];
        }
    }
    NSLog(@"Set Array arrEditQtyOfOrderItems : %@", arrEditQtyOfOrderItems);
    
}
-(NSMutableArray*)getarrEditQtyOfOrderItems
{
    return arrEditQtyOfOrderItems;
}
-(void)setPaymentMode:(NSString *)mode
{
    PaymentMode = mode;
}


@end