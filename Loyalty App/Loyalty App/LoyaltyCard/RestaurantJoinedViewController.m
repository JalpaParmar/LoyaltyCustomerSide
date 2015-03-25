//
//  RestaurantJoinedViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 8/13/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "RestaurantJoinedViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RestaDetailView.h"
#import "Singleton.h"

@interface RestaurantJoinedViewController ()
@end

@implementation RestaurantJoinedViewController

@synthesize arrRestaurantJoinDetail, joinIndexId, _fromDetail;

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
    
    app = APP;
    [self.view addSubview:[app setFooterPart]];
    NSLog(@"app._flagMainBtn : %d", app._flagMainBtn);
//    if(app._flagMainBtn == 3)
//    {
        app._flagMainBtn = 3;
//    }
//    else
//    {
//        app._flagMainBtn = 2;
//    }
    
//    self.lblTitleMyCard.font = FONT_centuryGothic_35;
//    self.lblTitleRestaurantJoined.font = FONT_centuryGothic_35;
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    
    self.btnJoin.layer.cornerRadius = 5.0;
    self.btnJoin.clipsToBounds = YES;
    
    self.btnRestaurantDetail.layer.cornerRadius = 5.0;
    self.btnRestaurantDetail.clipsToBounds = YES;
    
    self.viewForOffer.layer.cornerRadius = 5.0;
    self.viewForOffer.clipsToBounds = YES;
    
    self.btnCustomerQRCode.layer.cornerRadius = 5.0;
    self.btnCustomerQRCode.clipsToBounds = YES;
    
    [self.view addSubview:[app setMyLoyaltyTopPart]];
    
    self.viewForDetail.borderType = BorderTypeDashed;
    self.viewForDetail.dashPattern = 4;
    self.viewForDetail.spacePattern = 4;
    self.viewForDetail.borderWidth = 1;
    self.viewForDetail.cornerRadius = 10;
    
    if(app._flagMainBtn == 3)
    {
        if(app._flagMyLoyaltyTopButtons == 3)
        {
            app._flagMyLoyaltyTopButtons = 3;
            self.viewForOffer.hidden = YES;
            
            CGRect f = self.viewForDetail.frame;
            if(IS_IPAD)
            {
                f.origin.y = self.imgRestaurantIcon.frame.origin.y + self.imgRestaurantIcon.frame.size.height + 40;
            }
            else
            {
                f.origin.y = self.imgRestaurantIcon.frame.origin.y + self.imgRestaurantIcon.frame.size.height + 20;
            }
            self.viewForDetail.frame = f;
            
            f = self.btnJoin.frame;
            if(IS_IPAD)
            {
                f.origin.y = self.viewForDetail.frame.origin.y + self.viewForDetail.frame.size.height + 20;
            }
            else
            {
                 f.origin.y = self.viewForDetail.frame.origin.y + self.viewForDetail.frame.size.height + 40;
            }
            self.btnJoin.frame = f;
            
            f = self.btnRestaurantDetail.frame;
            if(IS_IPAD)
            {
                f.origin.y = self.viewForDetail.frame.origin.y + self.viewForDetail.frame.size.height + 20;
            }
            else
            {
                 f.origin.y = self.viewForDetail.frame.origin.y + self.viewForDetail.frame.size.height + 40;
            }
            self.btnRestaurantDetail.frame = f;
            
            self.btnCustomerQRCode.hidden = YES;
        }
        else if (app._flagMyLoyaltyTopButtons == 4)
        {
            app._flagMyLoyaltyTopButtons = 4;
            self.btnJoin.hidden = YES;
            
            CGRect f = self.btnRestaurantDetail.frame;
            if(IS_IPAD)
            {
                f.origin.x = self.viewForDetail.frame.origin.x + 25;
            }
            else{
                f.origin.x = self.viewForDetail.frame.origin.x + 5;
            }
            self.btnRestaurantDetail.frame = f;
            
            self.viewForOffer.hidden = NO;
            self.btnCustomerQRCode.hidden = NO  ;
        }
    }
    else
    {
        
    }
    
    [self setRestaurantJoinDetail];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
   
}
#pragma mark Button Click Event
-(void)setRestaurantJoinDetail
{
    
    if([_fromDetail isEqualToString:@"NewProgram"])
    {
        if([arrRestaurantJoinDetail count] > 0)
        {
            //Restaurant Name
            self.lblRestaurantName.text = [NSString stringWithFormat:@"%@", [[arrRestaurantJoinDetail  objectAtIndex:joinIndexId] objectForKey:@"StoreName"]];
            
            //Address
            self.lblRestaurantAddress.text = [NSString stringWithFormat:@"%@, %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrRestaurantJoinDetail  objectAtIndex:joinIndexId] objectForKey:@"StreetLine1"]], [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrRestaurantJoinDetail objectAtIndex:joinIndexId] objectForKey:@"StreetLine2"]]];
            
            //Distance
            //Distance
            double lat, lon;
            @try {
                lat =[[[arrRestaurantJoinDetail  objectAtIndex:joinIndexId] objectForKey:@"Latidute"] doubleValue];
                lon = [[[arrRestaurantJoinDetail objectAtIndex:joinIndexId] objectForKey:@"Longitude"] doubleValue];
            }
            @catch (NSException *exception) {
                lat =  0;
                lon =  0;
            }
            NSString *distacne = [[Singleton sharedSingleton] getDistanceBetweenLocations:lat Lon:lon Aontherlat:app.lat AnotheLong:app.lon];
            self.lblRestaurantDistance.text = [NSString stringWithFormat:@"%@", distacne];
          
            
            self.lblPurchasedQty.text = [NSString stringWithFormat:@"%@", [[arrRestaurantJoinDetail objectAtIndex:joinIndexId] objectForKey:@"rPurchasedQty"]];
            self.lblRewardQty.text = [NSString stringWithFormat:@"%@", [[arrRestaurantJoinDetail objectAtIndex:joinIndexId] objectForKey:@"rFreeQty"]];
            
            //JoinDate = "/Date(1408365730630)/";
            //Start Date
            NSString *str = [NSString stringWithFormat:@"%@", [[arrRestaurantJoinDetail objectAtIndex:joinIndexId] objectForKey:@"rStartDate"]];
            NSString *strStartDate=@"";
            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str] isEqualToString:@""])
            {
                strStartDate = [[Singleton sharedSingleton] ConvertMilliSecIntoDate:str Format:@"dd-MMMM-yyyy"];
            }
            self.lblStartDate.text = [NSString stringWithFormat:@"%@", strStartDate];
            
            
//            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str] isEqualToString:@""])
//            {
//                str = [str substringToIndex:[str length]- 2];
//                NSArray *arr2 = [str componentsSeparatedByString:@"("];
//                NSDate *StartDate;
//                
//                if(  [arr2 count] > 0)
//                {
//                    str = [arr2 objectAtIndex:1];
//                    StartDate = [NSDate dateWithTimeIntervalSince1970:[[arr2 objectAtIndex:1] doubleValue]/1000];
//                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//                    [format setDateFormat:@"dd-MMMM-yyyy"];
//                    strStartDate = [format stringFromDate:StartDate];
//                }
//            }
//            self.lblStartDate.text = [NSString stringWithFormat:@"%@", strStartDate];
            
            
            //End Date
            NSString *str1 = [NSString stringWithFormat:@"%@", [[arrRestaurantJoinDetail objectAtIndex:joinIndexId] objectForKey:@"rEndDate"]];
            NSString *strEndDate=@"";
            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str1] isEqualToString:@""])
            {
                strEndDate = [[Singleton sharedSingleton] ConvertMilliSecIntoDate:str1 Format:@"dd-MMMM-yyyy"];
            }
            self.lblEndDate.text = [NSString stringWithFormat:@"%@", strEndDate];
            
            
//            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str1] isEqualToString:@""])
//            {
//                str1 = [str1 substringToIndex:[str1 length]- 2];
//                NSArray *arr3 = [str1 componentsSeparatedByString:@"("];
//                NSDate *EndDate;
//                if(arr3 != nil && [arr3 count] > 0)
//                {
//                    str1 = [arr3 objectAtIndex:1];
//                    EndDate = [NSDate dateWithTimeIntervalSince1970:[[arr3 objectAtIndex:1] doubleValue]/1000];
//                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//                    [format setDateFormat:@"dd-MMMM-yyyy"];
//                    strEndDate = [format stringFromDate:EndDate];
//                }
//            }
//            self.lblEndDate.text = [NSString stringWithFormat:@"%@", strEndDate];
            
   
            self.imgRestaurantIcon.image = [UIImage imageNamed:@"defaultImage.png"];
            
            // Restaurant Icon
            NSMutableArray * arrImg;
            arrImg  = [[arrRestaurantJoinDetail objectAtIndex:joinIndexId] objectForKey:@"ImagesList"];
           if([arrImg count] > 0)
           {
               dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
               dispatch_async(queue, ^{
                   
                   NSData *imageData;
                   UIImage *image;
                   NSString *imgStr = [[arrImg objectAtIndex:0] objectForKey:@"UploadPath"];
                   if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:imgStr] isEqualToString:@""])
                   {
                       NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, imgStr];
                       
                       image =  [[Singleton sharedSingleton] getImageFromCache:[imageName lastPathComponent]];
                       
                       if(image != nil)
                       {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               self.imgRestaurantIcon.image = image;
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
                           
                           [[Singleton sharedSingleton] saveImageInCache:image ImgName: imgStr];
                           dispatch_async(dispatch_get_main_queue(), ^{
                               if(image == nil)
                               {
                                   self.imgRestaurantIcon.image = [UIImage imageNamed:@"defaultImage.png"];
                               }
                               else{
                                   self.imgRestaurantIcon.image = image;
                               }
                               
                           });
                       }
                   }
                   
               });

           }
            
//                dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.myCompanyName.imagegrabber.bgqueue", NULL);
//                dispatch_async(backgroundQueue, ^(void) {
//                    
//                    
//                    NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, [[arrImg objectAtIndex:0] objectForKey:@"UploadPath"]];
//                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
//                    
//                    // Update UI on main thread
//                    dispatch_async(dispatch_get_main_queue(), ^(void) {
//                        self.imgRestaurantIcon.image = image;
//                        
//                        if(image == nil)
//                        {
//                            self.imgRestaurantIcon.image = [UIImage imageNamed:@"defaultImage.png"];
//                        }
//                        else{
//                            self.imgRestaurantIcon.image = image;
//                        }
//                    } );
//                    
//                });
            //}
        }
        
    }
    else if([_fromDetail isEqualToString:@"LoyaltyProgram"])
    {
        
        //Restaurant Name
        self.lblRestaurantName.text = [NSString stringWithFormat:@"%@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"StoreName"]];
        
        //Address
        self.lblRestaurantAddress.text = [NSString stringWithFormat:@"%@, %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"StreetLine1"]], [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"StreetLine2"]]];
        
        //Distance
        double lat =  [[[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"Latidute"] doubleValue];
        double lon = [[[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"Longitude"] doubleValue];
        NSString *distacne = [[Singleton sharedSingleton] getDistanceBetweenLocations:lat Lon:lon Aontherlat:app.lat AnotheLong:app.lon];
        self.lblRestaurantDistance.text = [NSString stringWithFormat:@"%@", distacne];
        
        
        //offer title
        NSArray *arr = [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"PurchaseItemName"];
        NSString *p = @"";
        if([arr count] > 0)
        {
            p = [arr objectAtIndex:0];
        }
        NSArray *arr1 = [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"FreeItemName"];
        NSString *f = @"";
        if([arr1 count] > 0)
        {
            f = [arr1 objectAtIndex:0];
        }
        
        NSString *offer = [NSString stringWithFormat:@"Buy %@ %@ Get %@ %@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"PurchaseQty"], p, [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"FreeQty"], f];
        self.lblOfferTitle.text = offer;
        
        CGRect ff = self.lblOfferTitle.frame;
        ff.size.height = ceilf([[Singleton sharedSingleton] heightOfTextForLabel:self.lblOfferTitle.text andFont:self.lblOfferTitle.font maxSize:CGSizeMake(self.lblOfferTitle.frame.size.width, 200000)].height);
        self.lblOfferTitle.frame = ff;
        
        
        //PurchaseQty
        int countPurchaseQty = [[[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"PurchaseQty"]intValue];
//        [[[self.arrRewardList objectAtIndex:indexPath.row]objectForKey:@"PurchaseQty"] intValue];
        int countFreeQty =  [[[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"FreeQty"]intValue];
//        [[[self.arrRewardList objectAtIndex:indexPath.row]objectForKey:@"FreeQty"] intValue];
        
        //TotalPurchase
        int totalPItem;
        NSString *totalPurchaseItem = [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"TotalPurchase"];
//        [[self.arrRewardList objectAtIndex:i]objectForKey:@"TotalPurchase"];
        @try {
            totalPurchaseItem = [[Singleton sharedSingleton] ISNSSTRINGNULL:totalPurchaseItem];
            if([totalPurchaseItem isEqualToString:@""])
            {
                totalPItem = 0;
            }
            else
            {
                totalPItem = [totalPurchaseItem intValue];
            }
        }
        @catch (NSException *exception) {
            totalPItem = [totalPurchaseItem intValue];
        }

        
        //TotalFree
        int totalFItem;
        NSString *totalFreeItem = [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"TotalFree"];
//        [[self.arrRewardList objectAtIndex:indexPath.row]objectForKey:@"TotalFree"];
        @try {
            totalFreeItem = [[Singleton sharedSingleton] ISNSSTRINGNULL:totalFreeItem];
            if([totalFreeItem isEqualToString:@""])
            {
                totalFItem = 0;
            }
            else
            {
                totalFItem = [totalFreeItem intValue];
            }
            
        }
        @catch (NSException *exception) {
            totalFItem = [totalFreeItem intValue];
        }

        
        self.viewArrayOfbtnRedeem.hidden = YES;
        self.btnRedeem.hidden = YES;
        
        self.btnRedeem.layer.cornerRadius = 5.0;
        self.btnRedeem.clipsToBounds = YES;
        self.btnUsed.layer.cornerRadius = 5.0;
        self.btnUsed.clipsToBounds = YES;
        
        self.btnRedeem.tag = joinIndexId;
        self.btnUsed.tag = joinIndexId;
        
        [self.btnUsed addTarget:self action:@selector(btnUsedClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnRedeem addTarget:self action:@selector(btnRedeemClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        int cx=5;
        for(int i=0; i<countPurchaseQty; i++)
        {
            CGRect f = CGRectMake(cx, 2, 20, 20);
            UIButton *btn = [self createArrayOfButton:f];
            [self.viewArrayOfbtnUsed addSubview:btn];
            if(totalPItem > i)
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"redem-dark.png"] forState:UIControlStateNormal];
            }
            cx += 25;
        }
        
        cx=5;
        if(totalPItem == countPurchaseQty)
        {
            for(int j=0; j<countFreeQty; j++)
            {
                self.viewArrayOfbtnRedeem.hidden = NO;
                self.btnRedeem.hidden = NO;
                CGRect f = CGRectMake(cx, 2, 20, 20);
                UIButton *btn = [self createArrayOfButton:f];
                [self.viewArrayOfbtnRedeem addSubview:btn];
                
                if(totalFItem > j)
                {
                    [btn setBackgroundImage:[UIImage imageNamed:@"redem-dark.png"] forState:UIControlStateNormal];
                }
                cx += 25;
            }
        }

        //check all items are used, then change layout of used button and stop user interaction
//        if(countPurchaseQty == totalPItem)
//        {
//            self.btnUsed.backgroundColor = [UIColor clearColor];
//            self.btnUsed.titleLabel.textColor = [UIColor blackColor];
//            [self.btnUsed setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [self.btnUsed setTitle:@"Used" forState:UIControlStateNormal];
//            self.btnUsed.userInteractionEnabled = NO;
//            self.btnUsed.enabled = NO;
//        }
//        else
//        {
//            self.btnUsed.userInteractionEnabled = YES;
//            self.btnUsed.enabled = YES;
//        }
        //check all items are Redeem, then change layout of Redeem button and stop user interaction
        
//        if(countFreeQty == totalFItem)
//        {
//            self.btnRedeem.backgroundColor = [UIColor clearColor];
//            self.btnRedeem.titleLabel.textColor = [UIColor blackColor];
//            [self.btnRedeem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [self.btnRedeem setTitle:@"Redeem" forState:UIControlStateNormal];
//            self.btnRedeem.userInteractionEnabled = NO;
//            self.btnRedeem.enabled = NO;
//        }
//        else
//        {
//            self.btnRedeem.userInteractionEnabled = YES;
//            self.btnRedeem.enabled = YES;
//        }
       
        
        self.btnUsed.backgroundColor = [UIColor clearColor];
        self.btnUsed.titleLabel.textColor = [UIColor blackColor];
        [self.btnUsed setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if(self.btnRedeem.hidden)
        {
            [self.btnUsed setTitle:@"Use" forState:UIControlStateNormal];
        }
        else
        {
            [self.btnUsed setTitle:@"Used" forState:UIControlStateNormal];
        }
        self.btnUsed.userInteractionEnabled = NO;
        self.btnUsed.enabled = NO;
        
        self.btnRedeem.backgroundColor = [UIColor clearColor];
        self.btnRedeem.titleLabel.textColor = [UIColor blackColor];
        [self.btnRedeem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnRedeem setTitle:@"Redeem" forState:UIControlStateNormal];
        self.btnRedeem.userInteractionEnabled = NO;
        self.btnRedeem.enabled = NO;
        
        if(IS_IPAD)
        {
            
            ff = self.viewArrayOfbtnUsed.frame;
            ff.origin.y = self.lblOfferTitle.frame.origin.y + self.lblOfferTitle.frame.size.height + 15;
            self.viewArrayOfbtnUsed.frame = ff;
            
            ff = self.btnUsed.frame;
            ff.origin.y = self.lblOfferTitle.frame.origin.y + self.lblOfferTitle.frame.size.height + 15;
            self.btnUsed.frame = ff;
            
            ff = self.viewArrayOfbtnRedeem.frame;
            ff.origin.y = self.viewArrayOfbtnUsed.frame.origin.y + self.viewArrayOfbtnUsed.frame.size.height + 15;
            self.viewArrayOfbtnRedeem.frame = ff;
            
            ff = self.btnRedeem.frame;
            ff.origin.y = self.viewArrayOfbtnUsed.frame.origin.y + self.viewArrayOfbtnUsed.frame.size.height + 15;
            self.btnRedeem.frame = ff;
            
            ff = self.viewForOffer.frame;
            ff.size.height = self.viewArrayOfbtnRedeem.frame.origin.y + self.viewArrayOfbtnRedeem.frame.size.height + 15;
            self.viewForOffer.frame = ff;
            
            if(self.viewArrayOfbtnRedeem.hidden)
            {
                CGRect f = self.viewForOffer.frame;
                f.size.height = f.size.height - 32;
                self.viewForOffer.frame = f;
            }
            
            ff = self.btnCustomerQRCode.frame;
            ff.origin.y =  self.viewForOffer.frame.origin.y +  self.viewForOffer.frame.size.height + 20;
            self.btnCustomerQRCode.frame = ff;
            
            ff = self.viewForDetail.frame;
            ff.origin.y =  self.btnCustomerQRCode.frame.origin.y +  self.btnCustomerQRCode.frame.size.height + 20;
            self.viewForDetail.frame = ff;
            
            ff = self.btnRestaurantDetail.frame;
            ff.origin.y =  self.viewForDetail.frame.origin.y +  self.viewForDetail.frame.size.height + 20;
            self.btnRestaurantDetail.frame = ff;
        }
        else
        {
            
            ff = self.viewArrayOfbtnUsed.frame;
            ff.origin.y = self.lblOfferTitle.frame.origin.y + self.lblOfferTitle.frame.size.height + 5;
            self.viewArrayOfbtnUsed.frame = ff;
            
            ff = self.btnUsed.frame;
            ff.origin.y = self.lblOfferTitle.frame.origin.y + self.lblOfferTitle.frame.size.height + 5;
            self.btnUsed.frame = ff;
            
            ff = self.viewArrayOfbtnRedeem.frame;
            ff.origin.y = self.viewArrayOfbtnUsed.frame.origin.y + self.viewArrayOfbtnUsed.frame.size.height + 5;
            self.viewArrayOfbtnRedeem.frame = ff;
            
            ff = self.btnRedeem.frame;
            ff.origin.y = self.viewArrayOfbtnUsed.frame.origin.y + self.viewArrayOfbtnUsed.frame.size.height + 5;
            self.btnRedeem.frame = ff;
            
            ff = self.viewForOffer.frame;
            ff.size.height = self.viewArrayOfbtnRedeem.frame.origin.y + self.viewArrayOfbtnRedeem.frame.size.height + 5;
            self.viewForOffer.frame = ff;
            
            if(self.viewArrayOfbtnRedeem.hidden)
            {
                CGRect f = self.viewForOffer.frame;
                f.size.height = f.size.height - 32;
                self.viewForOffer.frame = f;
            }
            
            ff = self.btnCustomerQRCode.frame;
            ff.origin.y =  self.viewForOffer.frame.origin.y +  self.viewForOffer.frame.size.height + 10;
            self.btnCustomerQRCode.frame = ff;
            
            ff = self.viewForDetail.frame;
            ff.origin.y =  self.btnCustomerQRCode.frame.origin.y +  self.btnCustomerQRCode.frame.size.height + 10;
            self.viewForDetail.frame = ff;
            
            ff = self.btnRestaurantDetail.frame;
            ff.origin.y =  self.viewForDetail.frame.origin.y +  self.viewForDetail.frame.size.height + 10;
            self.btnRestaurantDetail.frame = ff;
        }
        
        //----- VIEW DETAIL ------
        //PurchaseQty
        self.lblPurchasedQty.text = [NSString stringWithFormat:@"%@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"PurchaseQty"]];
        
        
        //FreeQty
        self.lblRewardQty.text = [NSString stringWithFormat:@"%@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"FreeQty"]];
        
        
        //JoinDate = "/Date(1408365730630)/";
        //Start Date
        NSString *str = [NSString stringWithFormat:@"%@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId]objectForKey:@"StartDate"]];
        NSString *strStartDate=@"";
        if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str] isEqualToString:@""])
        {
            strStartDate = [[Singleton sharedSingleton] ConvertMilliSecIntoDate:str Format:@"dd-MMMM-yyyy"];
        }
        self.lblStartDate.text = [NSString stringWithFormat:@"%@", strStartDate];
        
        
//        if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str] isEqualToString:@""])
//        {
//            str = [str substringToIndex:[str length]- 2];
//            NSArray *arr2 = [str componentsSeparatedByString:@"("];
//            NSDate *StartDate;
//            
//            if(  [arr2 count] > 0)
//            {
//                str = [arr2 objectAtIndex:1];
//                StartDate = [NSDate dateWithTimeIntervalSince1970:[[arr2 objectAtIndex:1] doubleValue]/1000];
//                NSDateFormatter *format = [[NSDateFormatter alloc] init];
//                [format setDateFormat:@"dd-MMMM-yyyy"];
//                strStartDate = [format stringFromDate:StartDate];
//            }
//        }
//        self.lblStartDate.text = [NSString stringWithFormat:@"%@", strStartDate];
        
        
        //End Date
        NSString *str1 = [NSString stringWithFormat:@"%@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId]objectForKey:@"EndDate"]];
        NSString *strEndDate=@"";
        if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str1] isEqualToString:@""])
        {
            strEndDate = [[Singleton sharedSingleton] ConvertMilliSecIntoDate:str1 Format:@"dd-MMMM-yyyy"];
        }
        self.lblEndDate.text = [NSString stringWithFormat:@"%@", strEndDate];
        
        
//        if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str1] isEqualToString:@""])
//        {
//            str1 = [str1 substringToIndex:[str1 length]- 2];
//            NSArray *arr3 = [str1 componentsSeparatedByString:@"("];
//            NSDate *EndDate;
//            if(arr3 != nil && [arr3 count] > 0)
//            {
//                str1 = [arr3 objectAtIndex:1];
//                EndDate = [NSDate dateWithTimeIntervalSince1970:[[arr3 objectAtIndex:1] doubleValue]/1000];
//                NSDateFormatter *format = [[NSDateFormatter alloc] init];
//                [format setDateFormat:@"dd-MMMM-yyyy"];
//                strEndDate = [format stringFromDate:EndDate];
//            }
//        }
//        self.lblEndDate.text = [NSString stringWithFormat:@"%@", strEndDate];
        
        // Restaurant Icon
        NSMutableArray * arrImg;
        arrImg  = [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"ImagesList"];

        self.imgRestaurantIcon.image = [UIImage imageNamed:@"defaultImage.png"];
        
        if([arrImg count] > 0)
        {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
            dispatch_async(queue, ^{
                
                NSData *imageData;
                UIImage *image;
                
                NSString *imgStr = [[arrImg objectAtIndex:0] objectForKey:@"UploadPath"];
                if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:imgStr] isEqualToString:@""])
                {
                    NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, imgStr];
                    image =  [[Singleton sharedSingleton] getImageFromCache:[imageName lastPathComponent]];
                    
                    if(image != nil)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.imgRestaurantIcon.image = image;
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
                        
                        [[Singleton sharedSingleton] saveImageInCache:image ImgName: [[arrImg objectAtIndex:0] objectForKey:@"UploadPath"]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(image == nil)
                            {
                                self.imgRestaurantIcon.image = [UIImage imageNamed:@"defaultImage.png"];
                            }
                            else{
                                self.imgRestaurantIcon.image = image;
                            }
                            
                        });
                    }
                }
                
            });
            
        }
       

        
        // QR CODE
        dispatch_queue_t backgroundQueue1  = dispatch_queue_create("com.myCompanyName.imagegrabber.bgqueue", NULL);
        dispatch_async(backgroundQueue1, ^(void) {
  
            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
            if([st objectForKey:@"UfId"])
            {
                   self.lblCustomerId.text = [NSString stringWithFormat:@"%@", [st objectForKey:@"UfId"]];
            }
            else
            {
                self.lblCustomerId.text = [NSString stringWithFormat:@"%@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"UserId"]];
            }
         
            
            
            // QRCode Image
            self.btnQRCodeImage.userInteractionEnabled = NO;
            NSString *imageName = [NSString stringWithFormat:@"https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=%@&choe=UTF-8", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"UserId"]];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                if(image == nil)
                {
                    [self.btnQRCodeImage setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
                }
                else
                {
                    [self.btnQRCodeImage setBackgroundImage:image forState:UIControlStateNormal];
                }
            });
        });
        
        NSLog(@"--%f", self.btnRestaurantDetail.frame.origin.y);
        self.scrollView.contentSize = CGSizeMake(0, self.btnRestaurantDetail.frame.origin.y+self.btnRestaurantDetail.frame.size.height + 30);
        
    }
    
    
    //    //new update - in - new program
    //    if([arrRestaurantJoinDetail count] > 0)
    //    {
    //         //Restaurant Name
    //            self.lblRestaurantName.text = [NSString stringWithFormat:@"%@", [[arrRestaurantJoinDetail  objectAtIndex:joinIndexId] objectForKey:@"rStoreName"]];
    //
    //            //Address
    //            self.lblRestaurantAddress.text = [NSString stringWithFormat:@"%@, %@", [[arrRestaurantJoinDetail  objectAtIndex:joinIndexId] objectForKey:@"rStoreName1"], [[arrRestaurantJoinDetail objectAtIndex:joinIndexId] objectForKey:@"rStoreName2"]];
    //
    //            //Distance
    //            double lat =  [[[arrRestaurantJoinDetail  objectAtIndex:joinIndexId] objectForKey:@"rLatitude"] doubleValue];
    //            double lon = [[[arrRestaurantJoinDetail objectAtIndex:joinIndexId] objectForKey:@"rLongitude"] doubleValue];
    //            NSString *distacne = [[Singleton sharedSingleton] getDistanceBetweenLocations:lat Lon:lon];
    //            self.lblRestaurantDistance.text = [NSString stringWithFormat:@"%@", distacne];
    //           self.lblPurchasedQty.text = [NSString stringWithFormat:@"%@", [[arrRestaurantJoinDetail objectAtIndex:joinIndexId] objectForKey:@"rPurchasedQty"]];
    //           self.lblRewardQty.text = [NSString stringWithFormat:@"%@", [[arrRestaurantJoinDetail objectAtIndex:joinIndexId] objectForKey:@"rFreeQty"]];
    //
    //            //JoinDate = "/Date(1408365730630)/";
    //            //Start Date
    //            NSString *str = [NSString stringWithFormat:@"%@", [[arrRestaurantJoinDetail objectAtIndex:joinIndexId] objectForKey:@"rStartDate"]];
    //            NSString *strStartDate=@"";
    //            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str] isEqualToString:@""])
    //            {
    //                str = [str substringToIndex:[str length]- 2];
    //                NSArray *arr2 = [str componentsSeparatedByString:@"("];
    //                NSDate *StartDate;
    //
    //                if(  [arr2 count] > 0)
    //                {
    //                    str = [arr2 objectAtIndex:1];
    //                    StartDate = [NSDate dateWithTimeIntervalSince1970:[[arr2 objectAtIndex:1] doubleValue]/1000];
    //                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //                    [format setDateFormat:@"dd-MMMM-yyyy"];
    //                    strStartDate = [format stringFromDate:StartDate];
    //                }
    //            }
    //            self.lblStartDate.text = [NSString stringWithFormat:@"%@", strStartDate];
    //
    //
    //            //End Date
    //            NSString *str1 = [NSString stringWithFormat:@"%@", [[arrRestaurantJoinDetail objectAtIndex:joinIndexId] objectForKey:@"rEndDate"]];
    //            NSString *strEndDate=@"";
    //            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str1] isEqualToString:@""])
    //            {
    //                str1 = [str1 substringToIndex:[str1 length]- 2];
    //                NSArray *arr3 = [str1 componentsSeparatedByString:@"("];
    //                NSDate *EndDate;
    //                if(arr3 != nil && [arr3 count] > 0)
    //                {
    //                    str1 = [arr3 objectAtIndex:1];
    //                    EndDate = [NSDate dateWithTimeIntervalSince1970:[[arr3 objectAtIndex:1] doubleValue]/1000];
    //                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //                    [format setDateFormat:@"dd-MMMM-yyyy"];
    //                    strEndDate = [format stringFromDate:EndDate];
    //                }
    //            }
    //            self.lblEndDate.text = [NSString stringWithFormat:@"%@", strEndDate];
    //
    //
    //            // Detail view and offer view
    ////            NSMutableArray *arrOffer = [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId]objectForKey:@"LoyaltyBogolist"];
    ////            if([arrOffer count] > 0)
    ////            {
    ////                //PurchaseQty
    ////                self.lblPurchasedQty.text = [NSString stringWithFormat:@"%@", [[arrOffer objectAtIndex:0] objectForKey:@"PurchaseQty"]];
    ////
    ////                //FreeQty
    ////                self.lblRewardQty.text = [NSString stringWithFormat:@"%@", [[arrOffer objectAtIndex:0] objectForKey:@"FreeQty"]];
    ////
    ////                //JoinDate = "/Date(1408365730630)/";
    ////                //Start Date
    ////                NSString *str = [NSString stringWithFormat:@"%@", [[arrOffer objectAtIndex:0] objectForKey:@"StartDate"]];
    ////                NSString *strStartDate=@"";
    ////                if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str] isEqualToString:@""])
    ////                {
    ////                    str = [str substringToIndex:[str length]- 2];
    ////                    NSArray *arr2 = [str componentsSeparatedByString:@"("];
    ////                    NSDate *StartDate;
    ////
    ////                    if(  [arr2 count] > 0)
    ////                    {
    ////                        str = [arr2 objectAtIndex:1];
    ////                        StartDate = [NSDate dateWithTimeIntervalSince1970:[[arr2 objectAtIndex:1] doubleValue]/1000];
    ////                        NSDateFormatter *format = [[NSDateFormatter alloc] init];
    ////                        [format setDateFormat:@"dd-MMMM-yyyy"];
    ////                        strStartDate = [format stringFromDate:StartDate];
    ////                    }
    ////                }
    ////                self.lblStartDate.text = [NSString stringWithFormat:@"%@", strStartDate];
    ////
    ////
    ////                //End Date
    ////                NSString *str1 = [NSString stringWithFormat:@"%@", [[arrOffer objectAtIndex:0] objectForKey:@"EndDate"]];
    ////                NSString *strEndDate=@"";
    ////                if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str1] isEqualToString:@""])
    ////                {
    ////                    str1 = [str1 substringToIndex:[str1 length]- 2];
    ////                    NSArray *arr3 = [str1 componentsSeparatedByString:@"("];
    ////                    NSDate *EndDate;
    ////                    if(arr3 != nil && [arr3 count] > 0)
    ////                    {
    ////                        str1 = [arr3 objectAtIndex:1];
    ////                        EndDate = [NSDate dateWithTimeIntervalSince1970:[[arr3 objectAtIndex:1] doubleValue]/1000];
    ////                        NSDateFormatter *format = [[NSDateFormatter alloc] init];
    ////                        [format setDateFormat:@"dd-MMMM-yyyy"];
    ////                        strEndDate = [format stringFromDate:EndDate];
    ////                    }
    ////                }
    ////                self.lblEndDate.text = [NSString stringWithFormat:@"%@", strEndDate];
    ////            }
    ////            else
    ////            {
    ////
    ////                //offer title
    ////                NSArray *arr = [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"PurchaseItemName"];
    ////                NSString *p = @"";
    ////                if([arr count] > 0)
    ////                {
    ////                    p = [arr objectAtIndex:0];
    ////                }
    ////                NSArray *arr1 = [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"FreeItemName"];
    ////                NSString *f = @"";
    ////                if([arr1 count] > 0)
    ////                {
    ////                    f = [arr1 objectAtIndex:0];
    ////                }
    ////
    ////                NSString *offer = [NSString stringWithFormat:@"Buy %@ %@ Get %@ %@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"PurchaseQty"], p, [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"FreeQty"], f];
    ////                self.lblOfferTitle.text = offer;
    ////
    ////
    ////                //PurchaseQty
    ////                self.lblPurchasedQty.text = [NSString stringWithFormat:@"%@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"PurchaseQty"]];
    ////
    ////
    ////                //FreeQty
    ////                self.lblRewardQty.text = [NSString stringWithFormat:@"%@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"FreeQty"]];
    ////
    ////
    ////                //JoinDate = "/Date(1408365730630)/";
    ////                //Start Date
    ////                NSString *str = [NSString stringWithFormat:@"%@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId]objectForKey:@"StartDate"]];
    ////                NSString *strStartDate=@"";
    ////                if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str] isEqualToString:@""])
    ////                {
    ////                    str = [str substringToIndex:[str length]- 2];
    ////                    NSArray *arr2 = [str componentsSeparatedByString:@"("];
    ////                    NSDate *StartDate;
    ////
    ////                    if(  [arr2 count] > 0)
    ////                    {
    ////                        str = [arr2 objectAtIndex:1];
    ////                        StartDate = [NSDate dateWithTimeIntervalSince1970:[[arr2 objectAtIndex:1] doubleValue]/1000];
    ////                        NSDateFormatter *format = [[NSDateFormatter alloc] init];
    ////                        [format setDateFormat:@"dd-MMMM-yyyy"];
    ////                        strStartDate = [format stringFromDate:StartDate];
    ////                    }
    ////                }
    ////                self.lblStartDate.text = [NSString stringWithFormat:@"%@", strStartDate];
    ////
    ////
    ////                //End Date
    ////                NSString *str1 = [NSString stringWithFormat:@"%@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId]objectForKey:@"EndDate"]];
    ////                NSString *strEndDate=@"";
    ////                if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str1] isEqualToString:@""])
    ////                {
    ////                    str1 = [str1 substringToIndex:[str1 length]- 2];
    ////                    NSArray *arr3 = [str1 componentsSeparatedByString:@"("];
    ////                    NSDate *EndDate;
    ////                    if(arr3 != nil && [arr3 count] > 0)
    ////                    {
    ////                        str1 = [arr3 objectAtIndex:1];
    ////                        EndDate = [NSDate dateWithTimeIntervalSince1970:[[arr3 objectAtIndex:1] doubleValue]/1000];
    ////                        NSDateFormatter *format = [[NSDateFormatter alloc] init];
    ////                        [format setDateFormat:@"dd-MMMM-yyyy"];
    ////                        strEndDate = [format stringFromDate:EndDate];
    ////                    }
    ////                }
    ////                self.lblEndDate.text = [NSString stringWithFormat:@"%@", strEndDate];
    ////            }
    //
    //
    //            // Restaurant Icon
    //            NSMutableArray * arrImg;
    //            arrImg  = [[arrRestaurantJoinDetail objectAtIndex:joinIndexId] objectForKey:@"ImagesList"];
    //
    //            for(int i=0; i<[arrImg count]; i++)
    //            {
    //                self.imgRestaurantIcon.image = [UIImage imageNamed:@"defaultImage.png"];
    //
    //                dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.myCompanyName.imagegrabber.bgqueue", NULL);
    //                dispatch_async(backgroundQueue, ^(void) {
    //                    NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, [[arrImg objectAtIndex:i] objectForKey:@"UploadPath"]];
    //                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
    //
    //                    // Update UI on main thread
    //                    dispatch_async(dispatch_get_main_queue(), ^(void) {
    //                        self.imgRestaurantIcon.image = image;
    //
    //                        if(image == nil)
    //                        {
    //                            self.imgRestaurantIcon.image = [UIImage imageNamed:@"defaultImage.png"];
    //                        }
    //                        else{
    //                            self.imgRestaurantIcon.image = image;
    //                        }
    //                    } );
    //
    //                });
    //            }
    //
    //    }
    
    
    //    if([arrRestaurantJoinDetail count] > 0)
    //    {
    //        if([[arrRestaurantJoinDetail objectAtIndex:0] count]> 0)
    //        {
    //            //Restaurant Name
    //            self.lblRestaurantName.text = [NSString stringWithFormat:@"%@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"StoreName"]];
    //
    //            //Address
    //            self.lblRestaurantAddress.text = [NSString stringWithFormat:@"%@, %@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"StreetLine1"], [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"StreetLine2"]];
    //
    //            //Distance
    //            double lat =  [[[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"Latidute"] doubleValue];
    //            double lon = [[[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"Longitude"] doubleValue];
    //            NSString *distacne = [[Singleton sharedSingleton] getDistanceBetweenLocations:lat Lon:lon];
    //            self.lblRestaurantDistance.text = [NSString stringWithFormat:@"%@", distacne];
    //
    //
    //            // Detail view and offer view
    //            NSMutableArray *arrOffer = [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId]objectForKey:@"LoyaltyBogolist"];
    //            if([arrOffer count] > 0)
    //            {
    //                //PurchaseQty
    //                self.lblPurchasedQty.text = [NSString stringWithFormat:@"%@", [[arrOffer objectAtIndex:0] objectForKey:@"PurchaseQty"]];
    //
    //                //FreeQty
    //                self.lblRewardQty.text = [NSString stringWithFormat:@"%@", [[arrOffer objectAtIndex:0] objectForKey:@"FreeQty"]];
    //
    //                //JoinDate = "/Date(1408365730630)/";
    //                //Start Date
    //                NSString *str = [NSString stringWithFormat:@"%@", [[arrOffer objectAtIndex:0] objectForKey:@"StartDate"]];
    //                NSString *strStartDate=@"";
    //                if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str] isEqualToString:@""])
    //                {
    //                    str = [str substringToIndex:[str length]- 2];
    //                    NSArray *arr2 = [str componentsSeparatedByString:@"("];
    //                    NSDate *StartDate;
    //
    //                    if(  [arr2 count] > 0)
    //                    {
    //                        str = [arr2 objectAtIndex:1];
    //                        StartDate = [NSDate dateWithTimeIntervalSince1970:[[arr2 objectAtIndex:1] doubleValue]/1000];
    //                        NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //                        [format setDateFormat:@"dd-MMMM-yyyy"];
    //                        strStartDate = [format stringFromDate:StartDate];
    //                    }
    //                }
    //                self.lblStartDate.text = [NSString stringWithFormat:@"%@", strStartDate];
    //
    //
    //                //End Date
    //                NSString *str1 = [NSString stringWithFormat:@"%@", [[arrOffer objectAtIndex:0] objectForKey:@"EndDate"]];
    //                NSString *strEndDate=@"";
    //                if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str1] isEqualToString:@""])
    //                {
    //                    str1 = [str1 substringToIndex:[str1 length]- 2];
    //                    NSArray *arr3 = [str1 componentsSeparatedByString:@"("];
    //                    NSDate *EndDate;
    //                    if(arr3 != nil && [arr3 count] > 0)
    //                    {
    //                        str1 = [arr3 objectAtIndex:1];
    //                        EndDate = [NSDate dateWithTimeIntervalSince1970:[[arr3 objectAtIndex:1] doubleValue]/1000];
    //                        NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //                        [format setDateFormat:@"dd-MMMM-yyyy"];
    //                        strEndDate = [format stringFromDate:EndDate];
    //                    }
    //                }
    //                self.lblEndDate.text = [NSString stringWithFormat:@"%@", strEndDate];
    //            }
    //            else
    //            {
    //
    //                //offer title
    //                NSArray *arr = [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"PurchaseItemName"];
    //                NSString *p = @"";
    //                if([arr count] > 0)
    //                {
    //                    p = [arr objectAtIndex:0];
    //                }
    //                NSArray *arr1 = [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"FreeItemName"];
    //                NSString *f = @"";
    //                if([arr1 count] > 0)
    //                {
    //                    f = [arr1 objectAtIndex:0];
    //                }
    //
    //                NSString *offer = [NSString stringWithFormat:@"Buy %@ %@ Get %@ %@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"PurchaseQty"], p, [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"FreeQty"], f];
    //                self.lblOfferTitle.text = offer;
    //
    //
    //                //PurchaseQty
    //                self.lblPurchasedQty.text = [NSString stringWithFormat:@"%@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"PurchaseQty"]];
    //
    //
    //                //FreeQty
    //                self.lblRewardQty.text = [NSString stringWithFormat:@"%@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"FreeQty"]];
    //
    //
    //                //JoinDate = "/Date(1408365730630)/";
    //                //Start Date
    //                NSString *str = [NSString stringWithFormat:@"%@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId]objectForKey:@"StartDate"]];
    //                NSString *strStartDate=@"";
    //                if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str] isEqualToString:@""])
    //                {
    //                    str = [str substringToIndex:[str length]- 2];
    //                    NSArray *arr2 = [str componentsSeparatedByString:@"("];
    //                    NSDate *StartDate;
    //
    //                    if(  [arr2 count] > 0)
    //                    {
    //                        str = [arr2 objectAtIndex:1];
    //                        StartDate = [NSDate dateWithTimeIntervalSince1970:[[arr2 objectAtIndex:1] doubleValue]/1000];
    //                        NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //                        [format setDateFormat:@"dd-MMMM-yyyy"];
    //                        strStartDate = [format stringFromDate:StartDate];
    //                    }
    //                }
    //                self.lblStartDate.text = [NSString stringWithFormat:@"%@", strStartDate];
    //
    //
    //                //End Date
    //                NSString *str1 = [NSString stringWithFormat:@"%@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId]objectForKey:@"EndDate"]];
    //                NSString *strEndDate=@"";
    //                if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str1] isEqualToString:@""])
    //                {
    //                    str1 = [str1 substringToIndex:[str1 length]- 2];
    //                    NSArray *arr3 = [str1 componentsSeparatedByString:@"("];
    //                    NSDate *EndDate;
    //                    if(arr3 != nil && [arr3 count] > 0)
    //                    {
    //                        str1 = [arr3 objectAtIndex:1];
    //                        EndDate = [NSDate dateWithTimeIntervalSince1970:[[arr3 objectAtIndex:1] doubleValue]/1000];
    //                        NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //                        [format setDateFormat:@"dd-MMMM-yyyy"];
    //                        strEndDate = [format stringFromDate:EndDate];
    //                    }
    //                }
    //                self.lblEndDate.text = [NSString stringWithFormat:@"%@", strEndDate];
    //            }
    //
    //
    //            // Restaurant Icon
    //            NSMutableArray * arrImg;
    //            arrImg  = [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"ImagesList"];
    //
    //            for(int i=0; i<[arrImg count]; i++)
    //            {
    //                self.imgRestaurantIcon.image = [UIImage imageNamed:@"defaultImage.png"];
    //
    //                dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.myCompanyName.imagegrabber.bgqueue", NULL);
    //                dispatch_async(backgroundQueue, ^(void) {
    //                    NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, [[arrImg objectAtIndex:i] objectForKey:@"UploadPath"]];
    //                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
    //
    //                    // Update UI on main thread
    //                    dispatch_async(dispatch_get_main_queue(), ^(void) {
    //                        self.imgRestaurantIcon.image = image;
    //
    //                        if(image == nil)
    //                        {
    //                            self.imgRestaurantIcon.image = [UIImage imageNamed:@"defaultImage.png"];
    //                        }
    //                        else{
    //                            self.imgRestaurantIcon.image = image;
    //                        }
    //                    } );
    //
    //                });
    //            }
    //        }
    //    }
}

-(UIButton*)createArrayOfButton:(CGRect )frame
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"redem-light.png"] forState:UIControlStateNormal];
    btn.frame = frame;
    return btn;
}
-(void)btnUsedClicked:(id)sender
{
    UIButton *btn=  (UIButton*)sender;
    [self saveRewardsOfUser:btn.tag CallFrom:@"Used"];
}
-(void)btnRedeemClicked:(id)sender
{
    UIButton *btn =  (UIButton*)sender;
    [self saveRewardsOfUser:btn.tag CallFrom:@"Redeem"];
}
- (IBAction)btnbackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)saveRewardsOfUser:(int)tag CallFrom:(NSString*)callFrm
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
        [self startActivity];
        //UserId,ProgramId,ItemId
        //        while Use Btn PurchaseItemID
        //            N 4 Redeem FreeItemId
        
        NSString *iteId;
        if([callFrm isEqualToString:@"Used"])
        {
            iteId =  [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"PurchaseItemId"];
            //[[self.arrRewardList objectAtIndex:tag] objectForKey:@"PurchaseItem"];
        }
        else if([callFrm isEqualToString:@"Redeem"])
        {
            iteId =  [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"FreeItemId"];
            //[[self.arrRewardList objectAtIndex:tag] objectForKey:@"FreeItem"];
        }
        
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        NSString * userId ;
        if([st objectForKey:@"UserId"])
        {
            userId =  [st objectForKey:@"UserId"];
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:userId forKey:@"UserId"];
//        [dict setValue:[[self.arrRewardList objectAtIndex:tag] objectForKey:@"ProgramId"] forKey:@"ProgramId"];
        [dict setValue: [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"ProgramId"] forKey:@"ProgramId"];

        [dict setValue:iteId forKey:@"ItemId"];
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Save Reward offer List - - %@ -- ", dict);
             
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
                     if([[dict objectForKey:@"data"] count] > 0)
                     {
                         //[self.arrRewardList addObject:[dict objectForKey:@"data"]];
//                         self.arrRestaurantJoinDetail = [[NSMutableArray alloc] initWithObjects:, nil];
//                      //   TotalPurchase, TotalFree
//                         
//                          iteId =  [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"PurchaseItemId"];
//                         
                         
                         NSString *tp  = [[[dict objectForKey:@"data"] objectAtIndex:joinIndexId] objectForKey:@"TotalPurchase"];
                         NSString *tf  = [[[dict objectForKey:@"data"] objectAtIndex:joinIndexId] objectForKey:@"TotalFree"];
                         
                         NSMutableArray *tempArr = [[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId];
                         [tempArr setValue:tp forKey:@"TotalPurchase"];
                         [tempArr setValue:tf forKey:@"TotalFree"];
                         [[arrRestaurantJoinDetail objectAtIndex:0] replaceObjectAtIndex:joinIndexId withObject:tempArr];
                         
                     }
                     [self setRestaurantJoinDetail];
                     
//                     [self getDynamicHeightofLabels];
//                     self.tblReward.hidden = NO;
//                     [self.tblReward reloadData];
                 }
                 [self stopActivity];
             }
             else
             {
//                 [self.arrRewardList removeAllObjects];
//                 self.tblReward.hidden = NO;
//                 [self.tblReward reloadData];
                 
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
                 [self stopActivity];
             }
         } :@"Offers/SaveRewards" data:dict];
    }
}
- (IBAction)btnRestaurantDetailClicked:(id)sender {
    
    
    RestaDetailView *detail;
    if (IS_IPHONE_5)
    {
        detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView-5" bundle:nil];
    }
    else if(IS_IPAD)
    {
        detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView_iPad" bundle:nil];
    }
    else
    {
        detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView" bundle:nil];
    }
    detail._fromWhere = @"FromRestaurantJoin";
    detail.IS_PUSHNOTIFICATION = FALSE;
    if([_fromDetail isEqualToString:@"NewProgram"])
    {
        [[Singleton sharedSingleton] setarrRestaurantList:arrRestaurantJoinDetail ];
    }
    else if([_fromDetail isEqualToString:@"LoyaltyProgram"])
    {
        [[Singleton sharedSingleton] setarrRestaurantList:[arrRestaurantJoinDetail objectAtIndex:0]];
    }
    [[Singleton sharedSingleton] setIndexId:joinIndexId];
 
    [self.navigationController pushViewController:detail animated:YES];
    
}
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
- (IBAction)btnJoinClicked:(id)sender {
    
    if(app._skipRegister == 1)
    {
        [[Singleton sharedSingleton] errorLoginFirst];
    }
    else
    {
        if([self.btnJoin.titleLabel.text isEqualToString:@"Joined"])
        {
            UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:@"This program have already joined" message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [altMsg show];
        }
        else
        {
            if ([[Singleton sharedSingleton] connection]==0)
            {
                UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [altMsg show];
            }
            else
            {
                [self startActivity];
                NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
                NSString * userId ;
                if([st objectForKey:@"UserId"])
                {
                    userId =  [st objectForKey:@"UserId"];
                }
                
                NSString *programId;
                //        NSMutableArray *arrOffer = [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId]objectForKey:@"LoyaltyBogolist"];
                //        if([arrOffer count] > 0)
                //        {
                //            programId = [NSString stringWithFormat:@"%@", [[arrOffer objectAtIndex:0]objectForKey:@"ProgramId"]];
                //        }
                //        else
                //        {
                //            programId = [NSString stringWithFormat:@"%@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId]objectForKey:@"ProgramId"]];
                //        }
                
                
                programId = [NSString stringWithFormat:@"%@", [[arrRestaurantJoinDetail objectAtIndex:joinIndexId] objectForKey:@"ProgramId"]];
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:programId  forKey:@"ProgramId"];
                [dict setValue:userId forKey:@"UserId"];
                
                [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
                 {
                     NSLog(@"Join New program  :  %@ -- ", dict);
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
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"message"]  message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                             [alert show];
                             
                             [self.btnJoin setTitle:@"Joined" forState:UIControlStateNormal];
                             
                             [Singleton sharedSingleton].flagJoinFromDetail = 1;
                             
                             //[self.navigationController popViewControllerAnimated:YES];
                         }
                         [self stopActivity];
                     }
                     else
                     {
                         UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alt show];
                     }
                 } :@"Offers/AddJoinProgram" data:dict];
            }
        }
        
       
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//   
//}
- (IBAction)btnCustomerQRCodeClicked:(id)sender
{
    
    NSString *userId=@"";
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    if([st objectForKey:@"UserId"])
    {
        userId = [st objectForKey:@"UserId"];
    }
    if([st objectForKey:@"UfId"])
    {
        self.lblCustomerId.text = [NSString stringWithFormat:@"%@", [st objectForKey:@"UfId"]];
    }
    else
    {
        self.lblCustomerId.text = [NSString stringWithFormat:@"%@", [[[arrRestaurantJoinDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"UserId"]];
    }

    //self.btnCustomerQRCode.hidden = YES;
  
    [self.btnQRCodeImage setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
    
    if(IS_IPAD)
    {
        [self.view addSubview:self.btnBG];
        
        [self.viewCustomerQRCode setFrame:CGRectMake(0, 300, self.viewCustomerQRCode.frame.size.width, self.viewCustomerQRCode.frame.size.height)];
        
        [self.view addSubview:self.viewCustomerQRCode];
        
    }
    else
    {
        [self.view addSubview:self.btnBG];
        if (IS_IPHONE_5)
        {
            [self.viewCustomerQRCode setFrame:CGRectMake(0, 100, self.viewCustomerQRCode.frame.size.width, self.viewCustomerQRCode.frame.size.height)];
        }
        else
        {
            [self.viewCustomerQRCode setFrame:CGRectMake(0, 70, self.viewCustomerQRCode.frame.size.width, self.viewCustomerQRCode.frame.size.height)];
        }
        [self.view addSubview:self.viewCustomerQRCode];
    }
    
    // QR CODE
    dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.myCompanyName.imagegrabber.bgqueue", NULL);
    dispatch_async(backgroundQueue, ^(void) {
        
        // QRCode Image
        self.btnQRCodeImage.userInteractionEnabled = NO;
        NSString *imageName = [NSString stringWithFormat:@"https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=%@&choe=UTF-8",    [NSString stringWithFormat:@"%@", userId]];
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if(image == nil)
            {
                [self.btnQRCodeImage setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
            }
            else
            {
                [self.btnQRCodeImage setBackgroundImage:image forState:UIControlStateNormal];
            }
        });
    });

}

- (IBAction)btnCloseClicked:(id)sender {
    
   // self.btnCustomerQRCode.hidden = NO;
    [self.btnBG removeFromSuperview];
    [self.viewCustomerQRCode removeFromSuperview];
}
@end
