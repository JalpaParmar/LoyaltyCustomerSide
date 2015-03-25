//
//  NewProgramViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 8/13/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "NewProgramViewController.h"
#import "programCell.h"
#import "RestaurantJoinedViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Singleton.h"

//iPad
#define NewProgram_WIDTH_IPAD 670
#define FONT_RESTAURANTNAME_IPAD   [UIFont fontWithName:@"OpenSans-Light" size:20]//[UIFont boldSystemFontOfSize:20]
#define FONT_OFFERNAME_IPAD  [UIFont fontWithName:@"OpenSans-Light" size:15]// [UIFont systemFontOfSize:15]

//Iphone
#define NewProgram_WIDTH_IPHONE 230
#define FONT_RESTAURANTNAME_IPHONE   [UIFont fontWithName:@"OpenSans-Light" size:17]//[UIFont boldSystemFontOfSize:17]
#define FONT_OFFERNAME_IPHONE   [UIFont fontWithName:@"OpenSans-Light" size:13]//[UIFont systemFontOfSize:13]

#define JOIN_BUTTON_HEIGHT 35;
#define DIFFERENCE_CELLSPACING 30


@interface NewProgramViewController ()
@end

@implementation NewProgramViewController

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
    app._flagMainBtn = 3;
    
    [self.view addSubview:[app setMyLoyaltyTopPart]];
    app._flagMyLoyaltyTopButtons = 3;

//    self.lblTitleMyCard.font = FONT_centuryGothic_35;
//    self.lblTitleNewProgram.font = FONT_centuryGothic_35;

    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    [Singleton sharedSingleton].flagJoinFromDetail = 0;
    
    btnNearBySearch.layer.cornerRadius = 5.0;
    btnNearBySearch.clipsToBounds = YES;

    btnFilterBySearch.layer.cornerRadius = 5.0;
    btnFilterBySearch.clipsToBounds = YES;
    
//    if(!IS_IPAD)
//    {
//        btnFilterBySearch.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        btnFilterBySearch.titleLabel.textAlignment = NSTextAlignmentCenter;
//        
//        btnNearBySearch.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        btnNearBySearch.titleLabel.textAlignment = NSTextAlignmentCenter;
//        
//        [btnNearBySearch setTitle:@"Search Nearby" forState:UIControlStateNormal];
//        [btnFilterBySearch setTitle:@"Search By\nFilter" forState:UIControlStateNormal];
//    }
    
    self.tblProgramList.hidden=YES;
    self.tblProgramList.tableFooterView = [[UIView alloc] init];

    arrProgramList = [[NSMutableArray alloc] init];
    
    [self getProgramList];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
     if([Singleton sharedSingleton].flagJoinFromDetail == 1)
     {
          [self getProgramList];
     }    
}
#pragma mark Button Click Event
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
-(void)getProgramList
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
         [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
//        app.lat = 23.028713; //10.52;
//        app.lon = 72.506730; //12.22;
        
        
            [self startActivity];
            
            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
            NSString * userId ;
            if([st objectForKey:@"UserId"])
            {
                userId =  [st objectForKey:@"UserId"];
            }
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
            if(app.lat == 0 && app.lon == 0)
            {
                //gps off
                NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
                NSDictionary *userLoc=[st objectForKey:@"userLocation"];
                NSLog(@"lat %@",[userLoc objectForKey:@"lat"]);
                NSLog(@"long %@",[userLoc objectForKey:@"long"]);
                
                [dict setValue:[userLoc objectForKey:@"lat"]  forKey:@"Latidute"];
                [dict setValue:[userLoc objectForKey:@"long"]   forKey:@"Longitude"];
                if([st objectForKey:@"SelectedRange"])
                {
                    [dict setValue:[st objectForKey:@"SelectedRange"]   forKey:@"Range"];
                }
                else
                {
                    [dict setValue:@"100"  forKey:@"Range"];
                }
                
//                NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
//                if([st objectForKey:@"UserSelectedCountry"])
//                {
//                    [dict setValue:[st objectForKey:@"UserSelectedCountry"]   forKey:@"CountryId"];
//                }
//                if([st objectForKey:@"UserSelectedState"])
//                {
//                    [dict setValue:[st objectForKey:@"UserSelectedState"]   forKey:@"StateId"];
//                }
//                if([st objectForKey:@"UserSelectedCity"])
//                {
//                    [dict setValue:[st objectForKey:@"UserSelectedCity"]   forKey:@"City"];
//                }
                
            }
            else
            {
                if(btnFilterBySearch.tag == 1111)
                {
                    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
                    NSDictionary *userLoc=[st objectForKey:@"userLocation"];
                    NSLog(@"lat %@",[userLoc objectForKey:@"lat"]);
                    NSLog(@"long %@",[userLoc objectForKey:@"long"]);
                    
                    [dict setValue:[userLoc objectForKey:@"lat"]  forKey:@"Latidute"];
                    [dict setValue:[userLoc objectForKey:@"long"]   forKey:@"Longitude"];
                    if([st objectForKey:@"SelectedRange"])
                    {
                        [dict setValue:[st objectForKey:@"SelectedRange"]   forKey:@"Range"];
                    }
                    else
                    {
                        [dict setValue:@"100"  forKey:@"Range"];
                    }
                }
                else
                {
                    //just show rest list
                    [dict setValue:[NSNumber numberWithDouble:app.lat] forKey:@"Latidute"];
                    [dict setValue:[NSNumber numberWithDouble:app.lon]   forKey:@"Longitude"];
                     [dict setValue:@"100"  forKey:@"Range"];
                }
            }
        
            [dict setValue:userId forKey:@"UserId"];
        
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 NSLog(@"Program List - - %@ -- ", dict);
                 
                 if (dict)
                 {
                     [self stopActivity];
                     Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                     if (!strCode)
                     {
                         NSString *msg = [NSString stringWithFormat:@"%@", [dict objectForKey:@"message"]];
                         
                         if([msg rangeOfString:@"required"].location != NSNotFound)
                         {
                             UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                             [alt show];
                         }
                         else
                         {
                             [arrProgramList removeAllObjects];[arrBogoList removeAllObjects];
                             self.tblProgramList.hidden = NO;
                             [self.tblProgramList reloadData];
                         }
                         
                        
                     }
                     else
                     {
                         [arrProgramList removeAllObjects];
                         arrProgramList = [[NSMutableArray alloc] init];
                         if([[dict objectForKey:@"data"] count] > 0)
                         {
                             [arrProgramList addObject:[dict objectForKey:@"data"]];
                             
                             if([arrProgramList count] > 0)
                             {
                                 arrBogoList = [[NSMutableArray alloc] init];
                                 for(int i=0; i<[[arrProgramList  objectAtIndex:0] count]; i++)
                                 {
                                     NSArray *arrTemp  = [[[arrProgramList objectAtIndex:0] objectAtIndex:i] valueForKey:@"LoyaltyBogolist"];
                                     if([arrTemp count] > 0)
                                     {
                                         for(int i=0; i<[arrTemp count]; i++)
                                         {
                                             [arrBogoList addObject: [arrTemp objectAtIndex:i] ];
                                         }
                                     }
                                     //                                 if([arrBogoList count] > 0)
                                     //                                 {
                                     //                                     [arrBogoList addObject: [arrBogoList objectAtIndex:i]];
                                     //                                 }
                                     NSLog(@" ----- %d --- %@",  [arrBogoList  count], arrBogoList);
                                 }
                             }
                             
                          }
                         
                         [self getDynamicHeightofLabels];
                         
                         [[Singleton sharedSingleton] setarrRestaurantList:arrProgramList];
                         
                         [Singleton sharedSingleton].flagJoinFromDetail = 0;
                         
                         self.tblProgramList.hidden = NO;
                         [self.tblProgramList reloadData];
                     }
                     btnFilterBySearch.tag = 0;
                 }
                 else
                 {
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     [self stopActivity];
                 }
             } :@"Offers/ProgramList" data:dict];
       
    }
}
- (IBAction)btnbackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnFilterByClicked:(id)sender
{
    UIButton *b = (UIButton*)sender;
    if(b.tag == 0)
    {
        btnFilterBySearch.tag = 1111;
        CommonDelegateViewController *join;
        if (IS_IPHONE_5)
        {
            join=[[CommonDelegateViewController alloc] initWithNibName:@"CommonDelegateViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            join=[[CommonDelegateViewController alloc] initWithNibName:@"CommonDelegateViewController_iPad" bundle:nil];
        }
        else
        {
            join=[[CommonDelegateViewController alloc] initWithNibName:@"CommonDelegateViewController" bundle:nil];
        }
        join.delegate = self;
        [self.navigationController pushViewController:join animated:YES];
    }
    else
    {
        BOOL servicesEnabled = [CLLocationManager locationServicesEnabled];
        if(!servicesEnabled)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"\"Loyalty APP\" Would Like to Use Your Current Location" message:@"This will make it much easier for you to find out Restaurant nearby" delegate:self cancelButtonTitle:@"Don't Allow" otherButtonTitles:@"OK", nil];
            alert.tag = 15;
            [alert show];
        }
        else
        {
            [self getProgramList];
        }

    }
}
-(void)LocationSelectionDone:(NSMutableArray *)arrSelectionValue
{
    NSLog(@" *** LocationSelectionDone  called***");
    NSLog(@" *** arrSelectionValue : %@***", arrSelectionValue);
     [self.navigationController popViewControllerAnimated:YES];
    [self getProgramList];
}
-(void)BackFromSelectionView
{
    btnFilterBySearch.tag = 0;
    btnNearBySearch.tag = 1;

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getDynamicHeightofLabels
{
    NSLog(@"---- %lu ----",  (unsigned long)[arrBogoList count]);

    if([arrBogoList count] > 0)
    {
        for(int i=0; i<[arrBogoList count]; i++)
        {
            //   UserId - progrma list
           // RestaurantId - bogo list
            
            NSLog(@"----------");
            NSLog(@"%@", [arrProgramList objectAtIndex:0]);
            NSLog(@"----------");
            
            //StoreName
            NSString *search =  [[arrBogoList objectAtIndex:i] objectForKey:@"RestaurantId"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"UserId matches %@ ", search];
            NSArray *array = [[arrProgramList objectAtIndex:0] filteredArrayUsingPredicate: predicate];
            NSMutableArray *arrRestaurantDetail = [[NSMutableArray alloc] initWithArray:array];
             NSString *rName =[[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@", [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"StoreName"]]] ;
            NSString *rRating;
            NSArray *arrRating = [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"restaurantRating"];
            if([arrRating count] > 0)
            {
                rRating = [[Singleton sharedSingleton] getReviewFromGLobalArray:arrRating];
            }
          
            NSString *rLat =[NSString stringWithFormat:@"%@", [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"Latidute"]] ;
            NSString *rLon =[NSString stringWithFormat:@"%@", [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"Longitude"]] ;
             NSString *rSName1 =[NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrRestaurantDetail objectAtIndex:0] objectForKey:@"StreetLine1"]]] ;
             NSString *rSName2 =[NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrRestaurantDetail objectAtIndex:0] objectForKey:@"StreetLine2"]]] ;
            NSString *rCountry =[NSString stringWithFormat:@"%@", [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"Country"]] ;
            NSString *rCurrencySign =[NSString stringWithFormat:@"%@", [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"CurrencySign"]] ;
            NSString *rEMail =[NSString stringWithFormat:@"%@", [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"EMail"]] ;
            NSString *rIsHomeDelivery =[NSString stringWithFormat:@"%@", [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"IsHomeDelivery"]] ;
            NSString *rIsReservationAcceptance =[NSString stringWithFormat:@"%@", [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"IsReservationAcceptance"]] ;
            NSString *rIsTakeAway =[NSString stringWithFormat:@"%@", [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"IsTakeAway"]] ;
            NSString *rIsTherePlaceForChildren =[NSString stringWithFormat:@"%@", [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"IsTherePlaceForChildren"]] ;
            NSString *rIsTherePlaceForSmoker =[NSString stringWithFormat:@"%@", [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"IsTherePlaceForSmoker"]] ;
            NSString *rMinimumOrderDollar =[NSString stringWithFormat:@"%@", [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"MinimumOrderDollar"]] ;
            NSString *rMobileNo =[NSString stringWithFormat:@"%@", [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"MobileNo"]] ;
//             NSString *rState =[NSString stringWithFormat:@"%@", [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"State"]] ;
             NSString *rUserId =[NSString stringWithFormat:@"%@", [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"UserId"]] ;
            NSString *rZipCode =[NSString stringWithFormat:@"%@", [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"ZipCode"]];
            NSArray *rImageList = [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"ImagesList"] ;
             NSArray *rrestaurantCategory = [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"restaurantCategory"] ;
            NSArray *rtimingmodel = [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"timingmodel"] ;
             NSArray *rRatingArray = [[arrRestaurantDetail objectAtIndex:0] objectForKey:@"restaurantRating"] ;
            
             NSString *rSDate =[NSString stringWithFormat:@"%@", [[arrBogoList objectAtIndex:i] objectForKey:@"StartDate"]];
             NSString *rEDate =[NSString stringWithFormat:@"%@",[[arrBogoList objectAtIndex:i] objectForKey:@"EndDate"]] ;
            NSString *rPurchasedQty =[NSString stringWithFormat:@"%@",[[arrBogoList objectAtIndex:i] objectForKey:@"PurchaseQty"]] ;
            NSString *rFreeQty =[NSString stringWithFormat:@"%@", [[arrBogoList objectAtIndex:i] objectForKey:@"FreeQty"]];
            
            //Offer
            NSString *strOffer ;
             NSArray *p =  [[arrBogoList objectAtIndex:i] objectForKey:@"PurchaseItemName"];// [NSArray arrayWithObject: [[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"PurchaseItemName"]];
                NSString *pStr=@"";
                
                if(p== nil || p == [NSNull null])
                {
                    NSLog(@"nil");
                }
                else
                {
                    if([p count] > 0 )
                    {
                        pStr = [p objectAtIndex:0];
                    }
                }
                
                NSArray *f = [[arrBogoList objectAtIndex:i] objectForKey:@"FreeItemName"];
                NSString *fStr=@"";
                
                if(f == nil || f == [NSNull null])
                {
                    NSLog(@"nil");
                }
                else
                {
                    if([f count] > 0 )
                    {
                        fStr = [f objectAtIndex:0];
                    }
                }
                //            NSString *strOffer = [NSString stringWithFormat:@"Buy %@ %@ Get %@ %@ Free", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProgramList objectAtIndex:0] objectAtIndex:i]objectForKey:@"PurchaseQty"]], [[Singleton sharedSingleton] ISNSSTRINGNULL:pStr],[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrProgramList objectAtIndex:0] objectAtIndex:i]objectForKey:@"FreeQty"]],  [[Singleton sharedSingleton] ISNSSTRINGNULL:fStr]];
                
                strOffer = [NSString stringWithFormat:@"Buy %@ %@ Get %@ %@ Free", [[arrBogoList objectAtIndex:i] objectForKey:@"PurchaseQty"], [[Singleton sharedSingleton] ISNSSTRINGNULL:pStr], [[arrBogoList objectAtIndex:i] objectForKey:@"FreeQty"],  [[Singleton sharedSingleton] ISNSSTRINGNULL:fStr]];
            
            
            // strOffer = @"ksdfj  djsgkl dfkjds gjdfjgkld ldjflgkj dlfgjkldj gkldfjklgjdfkl gkldfjgkljdfklgjkldjfgkl dklfjgkldfjgkljdklfjgkldfjgkljdfk dklfjgkldfjgkljdfklgjkldfjgkldfj gkdfjklgjdklgjkldf gkljdkl";
            
            float h;
            CGSize aSize;
            if(IS_IPAD)
                aSize = CGSizeMake(NewProgram_WIDTH_IPAD, 20000);
            else
                aSize = CGSizeMake(NewProgram_WIDTH_IPHONE, 20000);
            
            NSMutableArray *tempArr = [arrBogoList  objectAtIndex:i];
            
            UIFont *font;
            if(IS_IPAD)
                font = FONT_RESTAURANTNAME_IPAD;
            else
                font = FONT_RESTAURANTNAME_IPHONE;
            
            h = ceilf([[Singleton sharedSingleton] heightOfTextForLabel:rName andFont:font maxSize:aSize].height);
            [tempArr setValue:rName forKey:@"StoreName"];
            [tempArr setValue:[NSString stringWithFormat:@"%f", h] forKey:@"HeightOfRestaurantName"];
            
            if(IS_IPAD)
                font = FONT_OFFERNAME_IPAD;
            else
                font = FONT_OFFERNAME_IPHONE;
            
            h = ceilf([[Singleton sharedSingleton] heightOfTextForLabel:strOffer andFont:font maxSize:aSize].height);
            [tempArr setValue:[NSString stringWithFormat:@"%f", MAX(h, 23)] forKey:@"HeightOfOfferName"];
            
             [tempArr setValue:strOffer forKey:@"ProgramFullName"];
             [tempArr setValue:rRating forKey:@"rRating"];
             [tempArr setValue:rLat forKey:@"Latidute"];
             [tempArr setValue:rLon forKey:@"Longitude"];
             [tempArr setValue:rSName1 forKey:@"StreetLine1"];
             [tempArr setValue:rSName2 forKey:@"StreetLine2"];
             [tempArr setValue:rSDate forKey:@"rStartDate"];
             [tempArr setValue:rEDate forKey:@"rEndDate"];
             [tempArr setValue:rPurchasedQty forKey:@"rPurchasedQty"];
             [tempArr setValue:rFreeQty forKey:@"rFreeQty"];
             [tempArr setValue:rImageList forKey:@"ImagesList"];
             [tempArr setValue:rrestaurantCategory forKey:@"restaurantCategory"];
            [tempArr setValue:rCountry forKey:@"Country"];
            [tempArr setValue:rCurrencySign forKey:@"CurrencySign"];
            [tempArr setValue:rEMail forKey:@"EMail"];
            [tempArr setValue:rUserId forKey:@"UserId"];
            [tempArr setValue:rtimingmodel forKey:@"timingmodel"];
            [tempArr setValue:rZipCode forKey:@"ZipCode"];
            [tempArr setValue:rMinimumOrderDollar forKey:@"MinimumOrderDollar"];
            [tempArr setValue:rMobileNo forKey:@"MobileNo"];
            [tempArr setValue:rRatingArray forKey:@"restaurantRating"];
            [tempArr setValue:rIsHomeDelivery forKey:@"IsHomeDelivery"];
            [tempArr setValue:rIsReservationAcceptance forKey:@"IsReservationAcceptance"];
            [tempArr setValue:rIsTakeAway forKey:@"IsTakeAway"];
            [tempArr setValue:rIsTherePlaceForChildren forKey:@"IsTherePlaceForChildren"];
            [tempArr setValue:rIsTherePlaceForSmoker forKey:@"IsTherePlaceForSmoker"];
            
            
            [arrBogoList  replaceObjectAtIndex:i withObject:tempArr];
        }
    }
    

}



-(void)joinProgramByUser:(id)sender;
{
    if(app._skipRegister == 1)
    {
        [[Singleton sharedSingleton] errorLoginFirst];
    }
    else
    {
        UIButton *btn = (UIButton*)sender;
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
            
            NSString *programID=@"" ;
//            NSMutableArray *arrOffer = [[[arrProgramList objectAtIndex:0] objectAtIndex:btn.tag]objectForKey:@"LoyaltyBogolist"];
//            if([arrOffer count] > 0)
//            {
//                programID =  [[arrOffer objectAtIndex:0] objectForKey:@"ProgramId"];
//            }
            programID = [[arrBogoList objectAtIndex:btn.tag] objectForKey:@"ProgramId"];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:programID forKey:@"ProgramId"];
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
                         
                         
                         NSIndexPath *indexpath = [NSIndexPath indexPathForItem:btn.tag inSection:0];
                         programCell *cell = (programCell*)[self.tblProgramList cellForRowAtIndexPath:indexpath];
                         [cell.btnJoin setTitle:@"Joined" forState:UIControlStateNormal];
                         
                         [arrBogoList removeObjectAtIndex:btn.tag];
                         [self.tblProgramList reloadData];
                         
//                         if([arrProgramList count] > 0)
//                         {
//                             if([[arrProgramList objectAtIndex:0] count] > 0)
//                             {
//                                 //RestaurantId - in arrbogolist
//                                 //userid - arrprogramlist
//                                 
//                                 NSString *bogoId = [[arrBogoList objectAtIndex:btn.tag] objectForKey:@"RestaurantId"];
//                                
//                                 for(int i=0; i<[[arrProgramList objectAtIndex:0] count]; i++)
//                                 {
//                                       NSString *programId = [[[arrProgramList objectAtIndex:0] objectAtIndex:i] objectForKey:@"UserId"];
//                                     if([programId isEqualToString:bogoId])
//                                     {
//                                        [[arrProgramList objectAtIndex:0] removeObjectAtIndex:i];
//                                         [self.tblProgramList reloadData];
//                                     }
//                                 }
//                                
//                             }
//                         }
//                         
//                         if([arrProgramList count] > 0)
//                         {
//                             arrBogoList = [[NSMutableArray alloc] init];
//                             for(int i=0; i<[[arrProgramList  objectAtIndex:0] count]; i++)
//                             {
//                                 NSArray *arrTemp  = [[[arrProgramList objectAtIndex:0] objectAtIndex:i] valueForKey:@"LoyaltyBogolist"];
//                                 if([arrTemp count] > 0)
//                                 {
//                                     for(int i=0; i<[arrTemp count]; i++)
//                                     {
//                                         [arrBogoList addObject: [arrTemp objectAtIndex:i] ];
//                                     }
//                                 }
//                                 
//                             }
//                         }
                         
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
#pragma mark TableView Delegate Method
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(IS_IOS_8)
    {
    if ([self.tblProgramList respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tblProgramList setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tblProgramList respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tblProgramList setLayoutMargins:UIEdgeInsetsZero];
    }
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IOS_8)
    {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    }
    CGFloat rotationAngleDegrees = 40; //90
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    CGPoint offsetPositioning = CGPointMake(-200, -20);
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    
    
    UIView *card = [cell contentView];
    card.layer.transform = transform;
    card.layer.opacity = 0.8;
    
    
    
    [UIView animateWithDuration:0.7f animations:^{
        card.layer.transform = CATransform3DIdentity;
        card.layer.opacity = 1;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([arrBogoList count] > 0)
    {
        return [arrBogoList count];
    }
    else
    {
        return 1;
    }
    return 0;
    
//    if([arrProgramList count] > 0)
//    {
//        return [[arrProgramList objectAtIndex:0]count];
//    }
//    else
//    {
//        return 1;
//    }
//    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 80;

    float h ;
    if([arrBogoList count] > 0)
    {
        NSLog(@"------ %f", ([[[arrBogoList objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue] + 27 + [[[arrBogoList objectAtIndex:indexPath.row] objectForKey:@"HeightOfOfferName"] floatValue] + 35) );
        
        return [[[arrBogoList objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue] + DIFFERENCE_CELLSPACING + [[[arrBogoList objectAtIndex:indexPath.row] objectForKey:@"HeightOfOfferName"] floatValue] + JOIN_BUTTON_HEIGHT + 20;
    }
    else
    {
        return 80;
    }
    
    
//    if([arrProgramList count] > 0)
//    {
//        if([[arrProgramList objectAtIndex:0] count] > 0)
//        {
//             return [[[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue] + DIFFERENCE_CELLSPACING + [[[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfOfferName"] floatValue] + JOIN_BUTTON_HEIGHT ;
//        }
//       
//    }
//    else
//    {
//        return 80;
//    }
    
    return h;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    
    if(IS_IPAD)
        simpleTableIdentifier = @"programCell_iPad";
    else
        simpleTableIdentifier = @"programCell";
    
    programCell *cell = (programCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    
    cell.btnMore.hidden = YES;
    cell.lblJoinedDate.hidden = YES;
    cell.btnMore.layer.cornerRadius=5.0;
    cell.btnMore.clipsToBounds=YES;
    cell.btnRate.layer.cornerRadius=5.0;
    cell.btnRate.clipsToBounds=YES;
    cell.btnJoin.layer.cornerRadius=5.0;
    cell.btnJoin.clipsToBounds=YES;
    
    if([arrBogoList count] == 0)
    {
        //        cell.textLabel.hidden = NO;
        //        cell.textLabel.text = @"No program Found.";
        
        CGRect f = cell.lblRestaurantName.frame;
        f.size.width = self.view.frame.size.width;
        cell.lblRestaurantName.frame = f;
        
        cell.lblRestaurantName.text = @"No program Found.";
        cell.lblRestaurantName.textAlignment = NSTextAlignmentCenter;
        
        cell.lblOfferDetail.hidden = YES;
        cell.lblDistance.hidden = YES;
        cell.btnRate.hidden = YES;
        cell.btnStart.hidden= YES;
        cell.btnJoin.hidden = YES;
        cell.btnMore.hidden = YES;
        
        self.tblProgramList.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tblProgramList.userInteractionEnabled = NO;
    }
    else
    {
        CGRect ff = cell.lblRestaurantName.frame;
        ff.size.height = [[[arrBogoList objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue];
        ff.size.width = self.view.frame.size.width - 100;
        cell.lblRestaurantName.frame = ff;
        
        ff = cell.lblOfferDetail.frame;
        ff.origin.y = cell.lblRestaurantName.frame.origin.y + cell.lblRestaurantName.frame.size.height + 5;
        ff.size.height = [[[arrBogoList objectAtIndex:indexPath.row] objectForKey:@"HeightOfOfferName"] floatValue];
        cell.lblOfferDetail.frame = ff;
      
        ff = cell.btnJoin.frame;
        ff.origin.y = cell.lblOfferDetail.frame.origin.y + cell.lblOfferDetail.frame.size.height + 5;
        cell.btnJoin.frame = ff;
        
        ff = cell.btnMore.frame;
        ff.origin.y = cell.lblOfferDetail.frame.origin.y + cell.lblOfferDetail.frame.size.height + 5;
        cell.btnMore.frame = ff;
        
        ff = cell.lblDistance.frame;
        ff.origin.y = cell.lblOfferDetail.frame.origin.y;
        cell.lblDistance.frame = ff;
        
        ff = cell.btnRate.frame;
        ff.origin.y = cell.lblRestaurantName.frame.origin.y;
        cell.btnRate.frame = ff;
  
        
        cell.lblOfferDetail.hidden = NO;
        cell.btnJoin.hidden = NO;
        cell.lblDistance.hidden = NO;
        cell.btnRate.hidden = NO;
        cell.btnStart.hidden=  NO;
        cell.btnMore.hidden = NO;
        
        cell.lblRestaurantName.textAlignment = NSTextAlignmentLeft;
       
        self.tblProgramList.userInteractionEnabled = YES;
        self.tblProgramList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        //StoreName
        cell.lblRestaurantName.text =[NSString stringWithFormat:@"%@", [[arrBogoList  objectAtIndex:indexPath.row]objectForKey:@"StoreName"]];

        //offer
        cell.lblOfferDetail.text = [NSString stringWithFormat:@"%@", [[arrBogoList objectAtIndex:indexPath.row]objectForKey:@"ProgramFullName"]];

        //rating
        @try {
            NSString *rat = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@", [[arrBogoList  objectAtIndex:indexPath.row]objectForKey:@"rRating"]] ];
            if(![rat isEqualToString:@""])
            {
                if([[rat stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"0"])
                {
                    cell.btnRate.hidden = YES;
                    cell.btnStart.hidden=YES;
                }
                [cell.btnRate setTitle:[NSString stringWithFormat:@"  %@", rat]  forState:UIControlStateNormal];
            }
            else
            {
                cell.btnRate.hidden = YES;
                cell.btnStart.hidden=YES;
//                 [cell.btnRate setTitle:@"0"  forState:UIControlStateNormal];
            }
        }
        @catch (NSException *exception) {
             [cell.btnRate setTitle:[NSString stringWithFormat:@"%@", [[arrBogoList  objectAtIndex:indexPath.row]objectForKey:@"rRating"]] forState:UIControlStateNormal];
        }
       
       

        //Distance
        double lat, lon;
        @try {
            lat =[[[arrBogoList objectAtIndex:indexPath.row]objectForKey:@"Latidute"] doubleValue];
            lon =  [[[arrBogoList  objectAtIndex:indexPath.row]objectForKey:@"Longitude"] doubleValue];
        }
        @catch (NSException *exception) {
            lat =  0;
            lon =  0;
        }
        NSString *distacne = [[Singleton sharedSingleton] getDistanceBetweenLocations:lat Lon:lon Aontherlat:app.lat AnotheLong:app.lon];
        cell.lblDistance.text =[NSString stringWithFormat:@"%@",distacne];

        //Join
        cell.btnJoin.tag = indexPath.row;
        [cell.btnJoin addTarget:self action:@selector(joinProgramByUser:) forControlEvents:UIControlEventTouchUpInside];
       
        
        //More
        cell.btnMore.tag = indexPath.row;
        [cell.btnMore addTarget:self action:@selector(moreClicked:) forControlEvents:UIControlEventTouchUpInside];
        

    }
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:cell.contentView andSubViews:YES];
    
     return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    join.arrRestaurantJoinDetail =  arrBogoList; //arrProgramList
    join.joinIndexId = indexPath.row;
    join._fromDetail=@"NewProgram";
    [self.navigationController pushViewController:join animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)moreClicked:(id)sender
{
    UIButton *b = (UIButton*)sender;
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
    join.arrRestaurantJoinDetail =  arrBogoList; //arrProgramList
    join.joinIndexId = b.tag;
    join._fromDetail=@"NewProgram";
    [self.navigationController pushViewController:join animated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
