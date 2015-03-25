//
//  RestaurantView.m
//  Loyalty App
//
//  Created by Amit Parmar on 18/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "RestaurantView.h"
#import "RestaCell.h"
#import "RestaDetailView.h"
#import "mapViewController.h"
#import "Singleton.h"
#import <CoreLocation/CoreLocation.h>
#import "DashboardView.h"

#define NewProgram_WIDTH_IPAD 735
#define FONT_RESTAURANTNAME_IPAD [UIFont fontWithName:@"OpenSans-Light" size:20]// [UIFont boldSystemFontOfSize:20]
#define FONT_ADDRESS_IPAD  [UIFont fontWithName:@"OpenSans-Light" size:17]//[UIFont systemFontOfSize:17]

#define NewProgram_WIDTH_IPHONE 350
#define FONT_RESTAURANTNAME_IPHONE [UIFont fontWithName:@"OpenSans-Light" size:15]// [UIFont boldSystemFontOfSize:15]
#define FONT_ADDRESS_IPHONE [UIFont fontWithName:@"OpenSans-Light" size:12]// [UIFont systemFontOfSize:12]

#define JOIN_BUTTON_HEIGHT 35;
#define DIFFERENCE_CELLSPACING 17

NSArray *arrCity;
@interface RestaurantView ()

@end

@implementation RestaurantView
@synthesize tblView, fromDashboardFlag, btnCity ;
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
   
    countryId=@"0";
    stateId=@"0";
    
    app = APP;
    [self.view addSubview:[app setFooterPart]];
    app._flagMainBtn = 0; //2;
    
     [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
    
    [Singleton sharedSingleton].IS_VISITED_MAP = FALSE;
    
    if(!IS_IPAD)
    {
        btnFilterBySearch.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btnFilterBySearch.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        btnNearBySearch.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btnNearBySearch.titleLabel.textAlignment = NSTextAlignmentCenter;
        
   //     [btnNearBySearch setTitle:@"Search Nearby" forState:UIControlStateNormal];
    //    [btnFilterBySearch setTitle:@"Search By\nFilter" forState:UIControlStateNormal];
    }
  
    
    
    arrRestaurantList=[[NSMutableArray alloc] init];
    arrCity=[[NSArray alloc] initWithObjects:@"Ahmedabad",@"Rajkot",@"Baroda",@"Surat", nil];
     self.tblView.hidden =  YES;
    if ([tblView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tblView setSeparatorInset:UIEdgeInsetsZero];
    }
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [tblView setBackgroundColor:[UIColor whiteColor]];
    [tblView setUserInteractionEnabled:YES];
    
    //IPAD CHANGE
    if(IS_IOS_6 && !IS_IPAD)
    {
        CGRect f = tblView.frame;
        f.size.height = 340;
        tblView.frame = f;
    }
    if (IS_IPAD && IS_IOS_6)
    {
        CGRect f = tblView.frame;
        f.size.height = 850;
        tblView.frame = f;
    }
    
    self.btnSubmit.layer.cornerRadius = 5.0;
    self.btnSubmit.clipsToBounds = YES;
    
    self.btnCancel.layer.cornerRadius = 5.0;
    self.btnCancel.clipsToBounds = YES;
    
    self.btnCityDone.layer.cornerRadius = 5.0;
    self.btnCityDone.clipsToBounds = YES;
   
    btnNearBySearch.layer.cornerRadius = 5.0;
    btnNearBySearch.clipsToBounds = YES;
    
    btnFilterBySearch.layer.cornerRadius = 5.0;
    btnFilterBySearch.clipsToBounds = YES;

    
    self.btnFilterList.tag = 0;
    
    [self.btnFilterList setBackgroundImage:[UIImage imageNamed:@"filter-icon.png"] forState:UIControlStateNormal];
    [self.btnFilterList setBackgroundImage:[UIImage imageNamed:@"filter-icon.png"] forState:UIControlStateHighlighted];
    [self.btnFilterList setBackgroundImage:[UIImage imageNamed:@"filter-icon.png"] forState:UIControlStateSelected];
    
    [self.btnMap setBackgroundImage:[UIImage imageNamed:@"pointer.png"] forState:UIControlStateNormal];
    [self.btnMap setBackgroundImage:[UIImage imageNamed:@"pointer.png"] forState:UIControlStateHighlighted];
    [self.btnMap setBackgroundImage:[UIImage imageNamed:@"pointer.png"] forState:UIControlStateSelected];
    
     [self.tblView setAllowsSelection:YES];
    
    _pickerCityData = @[@"Ahmedabad", @"Vadodara", @"Surat", @"Rajkot", @"Jamnagar", @"Junaghadh", @"Nadiad", @"Anand", @"Bhavanagar", @"Udaypur"];

    btnState.enabled = NO;
    btnCity.enabled = NO;
  
    BOOL servicesEnabled = [CLLocationManager locationServicesEnabled];
    if(!servicesEnabled)
    {
//        if([[[Singleton sharedSingleton] getarrCountryList] count] <= 0)
//        {
//            [self startActivity];
//            [[Singleton sharedSingleton] getCountryList];
//        }
       if(fromDashboardFlag == 1)
       {
           [self getRestaurantList];
       }
    }
    else
    {
        if([[[Singleton sharedSingleton] getarrRestaurantList] count] <= 0)
        {
          [self getRestaurantList];
        }
        else
        {
            [arrRestaurantList removeAllObjects];
            [arrRestaurantList addObject:[[Singleton sharedSingleton] getarrRestaurantList]];
//            [arrRestaurantList addObject:[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:0]];
            [self getDynamicHeightofLabels];
            
            if([arrRestaurantList count] > 0)
            {
                [[Singleton sharedSingleton] setarrRestaurantList:[arrRestaurantList objectAtIndex:0]];
            }
            
            [tblView reloadData];
            self.tblView.hidden =  NO;
        }
    }

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
//    NSLog(@"selected Index ID : %d", [[Singleton sharedSingleton] getIndexId]);
//    
//    NSLog(@"Res list Count: %lu", (unsigned long)[[[Singleton sharedSingleton] getarrRestaurantList] count]);
//    
//    NSLog(@"arrRestaurantList  Count: %lu", (unsigned long)[arrRestaurantList count]);
//    
//    if([arrRestaurantList count] < [[Singleton sharedSingleton] getIndexId])
//    {
//        [self getRestaurantList];
//    }
//
    
    if([[[Singleton sharedSingleton] getarrRestaurantList] count] < [[Singleton sharedSingleton] getIndexId])
    {
        [self getRestaurantList];
    }
    else
    {
//        [tblView reloadData];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GettingCityList) name:@"GettingCityList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GettingCountryList) name:@"GettingCountryList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GettingStateList) name:@"GettingStateList" object:nil];
    
}
-(void)GettingCountryList
{
    [self stopActivity];
    if([[[Singleton sharedSingleton] getarrCountryList] count] > 0)
    {
        btnCountry.enabled = YES;
    }
    else
    {
        btnCountry.enabled = NO;
    }
    
  
//    if([[[Singleton sharedSingleton] getarrCountryList] count] > 0)
//    {
//        [UIView transitionWithView:self.view
//                          duration:0.5
//                           options:UIViewAnimationOptionTransitionCurlDown
//                        animations:^ {
//                            
//                            self.viewFilter.hidden = NO;
//                            self.viewCity.hidden = YES;
//                            [self.view addSubview:self.viewFilter];
//                            
//                        }
//                        completion:nil];
//        
//        //[self.pickerCity reloadAllComponents];
//    }

}
-(void)GettingStateList
{
    [self stopActivity];
    if([[[Singleton sharedSingleton] getarrStateList] count] > 0)
    {
         btnState.enabled = YES;
    }
    else
    {
         btnState.enabled = NO;
    }
   
}
-(void)GettingCityList
{
    [self stopActivity];
    if([[[Singleton sharedSingleton] getarrStateList] count] > 0)
    {
        btnCity.enabled = YES;
    }
    else
    {
        btnCity.enabled = NO;
    }
    
   /* [self stopActivity];
    
    if([[[Singleton sharedSingleton] getarrCityList] count] > 0)
    {
        [UIView transitionWithView:self.view
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCurlDown
                        animations:^ {
                            
                            self.viewFilter.hidden = NO;
                            self.viewCity.hidden = YES;
                            [self.view addSubview:self.viewFilter];
                            
                        }
                        completion:nil];
        
        //[self.pickerCity reloadAllComponents];
    }*/
  
}
- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(alertView.tag == 11)
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

-(void)getRestaurantList
{
   if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
        
//        BOOL servicesEnabled = [CLLocationManager locationServicesEnabled];
//        if(!servicesEnabled)
//        {
//            
//        }
//        else
//        {
//            
//        }
        
            [self startActivity];
            NSLog(@"-- %ld", (long)btnFilterBySearch.tag);
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
       
//            if(![[self.btnCity.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"Select City"])
//            {
//                [dict setValue:[self.btnCity.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]   forKey:@"City"];
//            }
        
                // countryid ,stateid
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 NSLog(@" %@ -- ", dict);
                 if (dict)
                 {
                     tempFlag = btnFilterBySearch.tag;
                     btnFilterBySearch.tag = 0;
                     NSLog(@" %ld -- ", (long)self.btnFilterList.tag);
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
                             [arrRestaurantList removeAllObjects];
                             [tblView reloadData];
                             self.tblView.hidden =  NO;
                         }
                         
                     }
                     else
                     {
                          if([Singleton sharedSingleton].IS_VISITED_MAP && [[[Singleton sharedSingleton] getarrRestaurantList] count] < [[Singleton sharedSingleton] getIndexId])
                         {
                             [arrRestaurantList removeAllObjects];
                             [arrRestaurantList addObject:[dict objectForKey:@"data"] ];
                           
                             if([arrRestaurantList count] > 0)
                             {
                                 [[Singleton sharedSingleton] setarrRestaurantList:[arrRestaurantList objectAtIndex:0]];
                             }
                              [self getDynamicHeightofLabels];
                             NSLog(@"GLOBAL Restarent List Filleed up count ::: %lu ", (unsigned long)[[[Singleton sharedSingleton] getarrRestaurantList] count]);
                             
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
                             detail.IS_PUSHNOTIFICATION = FALSE;
                             detail._fromWhere = @"FromRestaurant";
                             //    [self.navigationController pushViewController:detail animated:YES];
                             
                             NSLog(@"Did Select arrRestaurantList  Count: %lu", (unsigned long)[arrRestaurantList count]);
                             
                             
                             [UIView transitionWithView:self.navigationController.view
                                               duration:0.75
                                                options:UIViewAnimationOptionTransitionFlipFromRight
                                             animations:^{
                                                 [self.navigationController pushViewController:detail animated:NO];
                                             }
                                             completion:nil];
                         }
                         else
                         {
                             NSLog(@"Restuarant List whole : %lu - %@",(unsigned long)[[dict objectForKey:@"data"] count], [dict objectForKey:@"data"]);
                             
                             [arrRestaurantList removeAllObjects];
                             [arrRestaurantList addObject:[dict objectForKey:@"data"] ];
                             [self getDynamicHeightofLabels];
                             
                             //                         [[Singleton sharedSingleton] setarrRestaurantList:[dict objectForKey:@"data"]];
                             if([arrRestaurantList count] > 0)
                             {
                                 [[Singleton sharedSingleton] setarrRestaurantList:[arrRestaurantList objectAtIndex:0]];
                             }
                             
                             NSLog(@"GLOBAL Restarent List Filleed up count : %lu ", (unsigned long)[[[Singleton sharedSingleton] getarrRestaurantList] count]);
                             
                             [tblView reloadData];
                             self.tblView.hidden =  NO;
                             
                         }
                     }
                     
                     [Singleton sharedSingleton].IS_VISITED_MAP = FALSE;
                     
                 }
                 else
                 {
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     [self stopActivity];
                 }
             } :@"Restaurant/NearestRestaurant" data:dict];
    }
}

-(void)getDynamicHeightofLabels
{
    NSLog(@"---- %d ----",  [arrRestaurantList count]);
    
    if([arrRestaurantList count] > 0)
    {
        for(int i=0; i<[[arrRestaurantList objectAtIndex:0] count]; i++)
        {
            NSString *rName =[[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@", [[[arrRestaurantList objectAtIndex:0] objectAtIndex:i]objectForKey:@"StoreName"]]] ;
          //  rName = @"ksdfj  djsgkl dfkjds gjdfjgkld ldjflgkj dlfgjkldj gkldfjklgjdfkl gkldfjgkljdfklgjkldjfgkl dklfjgkldfjgkljdklfjgkldfjgkljdfk dklfjgkldfjgkljdfklgjkldfjgkldfj gkdfjklgjdklgjkldf gkljdkl";
          
            
            //Address
             NSString *strOffer = [NSString stringWithFormat:@"%@, %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrRestaurantList objectAtIndex:0] objectAtIndex:i] objectForKey:@"StreetLine1"]], [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrRestaurantList objectAtIndex:0] objectAtIndex:i] objectForKey:@"StreetLine2"]]] ;

           //  strOffer = @"ksdfj  djsgkl dfkjds gjdfjgkld ldjflgkj dlfgjkldj gkldfjklgjdfkl gkldfjgkljdfklgjkldjfgkl dklfjgkldfjgkljdklfjgkldfjgkljdfk dklfjgkldfjgkljdfklgjkldfjgkldfj gkdfjklgjdklgjkldf gkljdkl";
            
            float h;
            CGSize aSize;
            if(IS_IPAD)
                aSize = CGSizeMake(NewProgram_WIDTH_IPAD, 20000);
            else
                aSize = CGSizeMake(NewProgram_WIDTH_IPHONE, 20000);
            
            NSMutableArray *tempArr = [[arrRestaurantList objectAtIndex:0] objectAtIndex:i];
            
            UIFont *font;
            if(IS_IPAD)
                font = FONT_RESTAURANTNAME_IPAD;
            else
                font = FONT_RESTAURANTNAME_IPHONE;
            
            h = ceilf([[Singleton sharedSingleton] heightOfTextForLabel:rName andFont:font maxSize:aSize].height);
            [tempArr setValue:[NSString stringWithFormat:@"%f", h] forKey:@"HeightOfRestaurantName"];
            
            if(IS_IPAD)
                font = FONT_ADDRESS_IPAD;
            else
                font = FONT_ADDRESS_IPHONE;
            
            h = ceilf([[Singleton sharedSingleton] heightOfTextForLabel:strOffer andFont:font maxSize:aSize].height);
            [tempArr setValue:[NSString stringWithFormat:@"%f", h] forKey:@"HeightOfAddress"];
            [tempArr setValue:strOffer forKey:@"ProgramFullName"];
            [[arrRestaurantList objectAtIndex:0] replaceObjectAtIndex:i withObject:tempArr];
        }
    }
}

#pragma mark TableView Delegate Method
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(IS_IOS_8)
    {
    if ([tblView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tblView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tblView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tblView setLayoutMargins:UIEdgeInsetsZero];
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
    if([arrRestaurantList count] > 0)
    {
         return [[arrRestaurantList objectAtIndex:0] count];
    }
    else
    {
        return  1;
    }
    return [arrRestaurantList count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (IS_IPAD)
//    {
//        return 80;
//    }
//    else
//    {
//        return 80;
//    }
    
    
    float h ;
    if([arrRestaurantList count] > 0)
    {          
        return [[[[arrRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue] + DIFFERENCE_CELLSPACING + [[[[arrRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfAddress"] floatValue] + JOIN_BUTTON_HEIGHT ;
    }
    else
    {
        return 80;
    }
    
    return h;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    if (IS_IPAD)
    {
        simpleTableIdentifier=@"RestaCell_iPad";
    }
    else
    {
        simpleTableIdentifier=@"RestaCell";
    }
    RestaCell *cell = (RestaCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if([arrRestaurantList count] == 0)
    {
        cell.lblName.textAlignment = NSTextAlignmentCenter;
        cell.lblName.text = @"Sorry, we did not found any restaurant near by you.";
        cell.lblAddress.hidden=YES;
        cell.lblAmnt.hidden = YES;
        cell.btnRate.hidden=YES;
        cell.lblKM.hidden=YES;
        cell.lblTime.hidden=YES;
        cell.btnStar.hidden =YES;
        cell.btnTimeIcon.hidden = YES;
        
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        tableView.userInteractionEnabled=NO;
        
        CGRect f = cell.lblName.frame;
        f.origin.y = 30;
        if(IS_IPAD)
        {
            f.size.width = 758;
            f.size.height = 80;
        }
        else
        {
            f.size.width = 310;
            f.size.height = 80;
        }
        cell.lblName.frame = f;
        
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        cell.lblName.textAlignment = NSTextAlignmentLeft;
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        tableView.userInteractionEnabled=YES;
        
        cell.lblAddress.hidden=NO;
        cell.lblAmnt.hidden = NO;
        cell.btnRate.hidden=NO;
        cell.lblKM.hidden=NO;
        cell.lblTime.hidden=NO;
        cell.btnStar.hidden =NO;
        
        CGRect ff = cell.lblName.frame;
        ff.origin.y = 9;
        ff.size.height = [[[[arrRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue];
        if(IS_IPAD)
        {
            ff.size.width = 675;
        }
        else
        {
            ff.size.width = 264;
        }
        cell.lblName.frame = ff;
        
        ff = cell.lblAddress.frame;
        ff.origin.y = cell.lblName.frame.origin.y + cell.lblName.frame.size.height + 5;
        ff.size.height = [[[[arrRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfAddress"] floatValue];
        cell.lblAddress.frame = ff;
        
        ff = cell.lblTime.frame;
        ff.origin.y = cell.lblAddress.frame.origin.y + cell.lblAddress.frame.size.height + 5;
        cell.lblTime.frame = ff;
        
        ff = cell.btnTimeIcon.frame;
        ff.origin.y = cell.lblTime.frame.origin.y + 4;
        cell.btnTimeIcon.frame = ff;
        
        ff = cell.lblAmnt.frame;
        ff.origin.y = cell.lblAddress.frame.origin.y + cell.lblAddress.frame.size.height + 5;
        cell.lblAmnt.frame = ff;
        
        ff = cell.btnRate.frame;
        ff.origin.y = cell.lblName.frame.origin.y;
        cell.btnRate.frame = ff;
        
        ff = cell.lblKM.frame;
        ff.origin.y = cell.lblTime.frame.origin.y ;
        cell.lblKM.frame = ff;
        
        //Res Name
        cell.lblName.text = [[[arrRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"StoreName"];
        
        //Address
        cell.lblAddress.text = [NSString stringWithFormat:@"%@, %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"StreetLine1"]], [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"StreetLine2"]]] ;
        
        //Rate
        if([[[[arrRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"restaurantRating"] count] > 0)
        {
            NSString *rRating=@"0";
            NSArray *arrRating = [[[arrRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"restaurantRating"];
            if([arrRating count] > 0)
            {
                rRating = [NSString stringWithFormat:@"   %@ ", [[Singleton sharedSingleton] getReviewFromGLobalArray:arrRating]];
                if([[rRating stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"0"])
                {
                     cell.btnRate.hidden = YES;
                    cell.btnStar.hidden =YES;
                }
            }
            [cell.btnRate setTitle:[NSString stringWithFormat:@"  %@", rRating] forState:UIControlStateNormal];
        }
        else
        {
            cell.btnRate.hidden = YES;
            cell.btnStar.hidden =YES;
//            [cell.btnRate setTitle:[NSString stringWithFormat:@"   0"] forState:UIControlStateNormal];
        }
        
        //Min Amount
        if(IS_IPAD)
        {
               cell.lblAmnt.text =[NSString stringWithFormat:@"Min Order: %@ %@ for Home Delivery", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"CurrencySign"]],  [[[arrRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"MinimumOrderDollar"]];
        }
        else
        {
               cell.lblAmnt.text =[NSString stringWithFormat:@"Min Order: %@ %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"CurrencySign"]],  [[[arrRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"MinimumOrderDollar"]];
        }
     
       
        //Time
        NSString *search =   [[Singleton sharedSingleton] getCurrentDayName];//@"Monday";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"DayName matches %@ ", search];
        NSArray *array = [[[[arrRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"timingmodel"] filteredArrayUsingPredicate: predicate];
        NSMutableArray *arrTime = [[NSMutableArray alloc] initWithArray:array];
        if([arrTime count] > 0)
        {
            NSString *startTime = [[Singleton sharedSingleton] removePostfixFromTime:[[arrTime objectAtIndex:0]  objectForKey:@"NoonStartTime"]];
            NSString *endTime = [[Singleton sharedSingleton] removePostfixFromTime:[[arrTime objectAtIndex:0]  objectForKey:@"EveningEndTime"]];
            
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
                cell.lblTime.text = [NSString stringWithFormat:@"Time not available"];
            }
            else if([[[Singleton sharedSingleton] ISNSSTRINGNULL:startTime]   isEqualToString:@""])
            {
                cell.lblTime.text = [NSString stringWithFormat:@"%@", startTime];
            }
            else if([[[Singleton sharedSingleton] ISNSSTRINGNULL:endTime] isEqualToString:@""])
            {
                cell.lblTime.text = [NSString stringWithFormat:@"%@", endTime];
            }
            else
            {
                cell.lblTime.text = [NSString stringWithFormat:@"%@ to %@", startTime, endTime];
            }
            
             cell.lblTime.text = [NSString stringWithFormat:@"       %@", cell.lblTime.text];
             cell.btnTimeIcon.hidden = NO;
            
       
            
        }
        else
        {
            cell.btnTimeIcon.hidden = YES;
            cell.lblTime.text = [NSString stringWithFormat:@"Time not available"];
        }
        
       
        
        
        //Distance
        double lat, lon;
        @try {
            lat =  [[[[arrRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"Latidute"] doubleValue];
            lon =  [[[[arrRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"Longitude"] doubleValue];
        }
        @catch (NSException *exception) {
            lat =  0;
            lon =  0;
        }
        NSString *distacne = [[Singleton sharedSingleton] getDistanceBetweenLocations:lat Lon:lon Aontherlat:app.lat AnotheLong:app.lon];
        cell.lblKM.text =[NSString stringWithFormat:@"%@",distacne];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    btnFilterBySearch.tag = tempFlag;
    [[Singleton sharedSingleton] setIndexId:(int)indexPath.row];
    
    NSLog(@" ---- didSelectRowAtIndexPath ----");
    NSLog(@"[Singleton sharedSingleton].IS_VISITED_MAP : %hhd", [Singleton sharedSingleton].IS_VISITED_MAP);
    NSLog(@"[[[Singleton sharedSingleton] getarrRestaurantList] count] : %lu", (unsigned long)[[[Singleton sharedSingleton] getarrRestaurantList] count]);
    NSLog(@"[[Singleton sharedSingleton] getIndexId] : %d", [[Singleton sharedSingleton] getIndexId]);
    
    if(  [Singleton sharedSingleton].IS_VISITED_MAP || [[[Singleton sharedSingleton] getarrRestaurantList] count] < [[Singleton sharedSingleton] getIndexId])
    {
        [self getRestaurantList];
    }
    else
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
        detail.IS_PUSHNOTIFICATION = FALSE;
        detail._fromWhere = @"FromRestaurant";
        //    [self.navigationController pushViewController:detail animated:YES];
        
      //  NSLog(@"Did Select arrRestaurantList  Count: %lu", (unsigned long)[arrRestaurantList count]);
        
        
        [UIView transitionWithView:self.navigationController.view
                          duration:0.75
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [self.navigationController pushViewController:detail animated:NO];
                        }
                        completion:nil];

    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 5.0f;
//}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *v = [UIView new];
//    [v setBackgroundColor:[UIColor clearColor]];
//    return v;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (IBAction)btnMapClick:(id)sender
{
    if([arrRestaurantList count] > 0)
    {
        mapViewController *map;
        if (IS_IPHONE_5)
        {
            map=[[mapViewController alloc] initWithNibName:@"mapViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            map=[[mapViewController alloc] initWithNibName:@"mapViewController_iPad" bundle:nil];
        }
        else
        {
            map=[[mapViewController alloc] initWithNibName:@"mapViewController" bundle:nil];
        }
        [self.navigationController pushViewController:map animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry, we did not found any restaurant near by you." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
  
}

/*- (IBAction)filterNearByClicked:(id)sender
{
    BOOL servicesEnabled = [CLLocationManager locationServicesEnabled];
    if(!servicesEnabled)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"\"Loyalty APP\" Would Like to Use Your Current Location" message:@"This will make it much easier for you to find out Restaurant nearby" delegate:self cancelButtonTitle:@"Don't Allow" otherButtonTitles:@"OK", nil];
        alert.tag = 15;
        [alert show];
        
    }
    else{
        [self getRestaurantList];
    }
}*/
/*- (IBAction)btnFilterClick:(id)sender
{
   
    self.btnFilterList.tag = 1111;
    if([[[Singleton sharedSingleton] getarrCountryList] count] <= 0)
    {
         [self startActivity];
        [[Singleton sharedSingleton] getCountryList];
    }
    else{
        [self stopActivity];
        if([[[Singleton sharedSingleton] getarrCountryList] count] > 0)
        {
            btnCountry.enabled = YES;
        }
        else
        {
            btnCountry.enabled = NO;
        }
        
        
        if([[[Singleton sharedSingleton] getarrCountryList] count] > 0)
        {
            [UIView transitionWithView:self.view
                              duration:0.5
                               options:UIViewAnimationOptionTransitionCurlDown
                            animations:^ {
                                
                                self.viewFilter.hidden = NO;
                                self.viewCity.hidden = YES;
                                [self.view addSubview:self.viewFilter];
                                
                            }
                            completion:nil];
            
            //[self.pickerCity reloadAllComponents];
        }

    }
    
   // [[Singleton sharedSingleton] getCityList];
   
}
*/
- (IBAction)btnFilterByClicked:(id)sender
{
    UIButton *b = (UIButton*)sender;
    NSLog(@"*-* %d", b.tag);
    if(b.tag == 0)
    {
        //search by filer
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
        //search newarby
        BOOL servicesEnabled = [CLLocationManager locationServicesEnabled];
        if(!servicesEnabled)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"\"Loyalty APP\" Would Like to Use Your Current Location" message:@"This will make it much easier for you to find out Restaurant nearby" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            alert.tag = 15;
            [alert show];
        }
        else
        {
            [self getRestaurantList];
        }
    }
}
-(void)LocationSelectionDone:(NSMutableArray *)arrSelectionValue
{
    NSLog(@" *** LocationSelectionDone  called***");
    NSLog(@" *** arrSelectionValue : %@***", arrSelectionValue);
     [self.navigationController popViewControllerAnimated:YES];
    [self getRestaurantList];
    
}
-(void)BackFromSelectionView
{
    btnFilterBySearch.tag = 0;
    btnNearBySearch.tag = 1;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 15)
    {
        if(buttonIndex == 0)
        {
            // NO clicked
            [self getRestaurantList];
        }
        else
        {
          // YES clicked
        }
    }
}
/*
- (IBAction)filterCancelClicked:(id)sender
{
    [self.viewFilter removeFromSuperview];
    
}*/
/*- (IBAction)filterSubmitClicked:(id)sender
{
    BOOL servicesEnabled = [CLLocationManager locationServicesEnabled];
    if(!servicesEnabled)
    {
        if(self.btnFilterList.tag == 1111)
        {
            
            [UIView transitionWithView:self.view
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionCurlUp
                                animations:^ {
                                    [self.viewFilter removeFromSuperview];
                                }
                                completion:nil];
                
                [self getRestaurantList];
        }
        else
        {
            DashboardView *dashBoard;
            if (IS_IPHONE_5)
            {
                dashBoard=[[DashboardView alloc] initWithNibName:@"DashboardView-5" bundle:nil];
            }
            else if (IS_IPAD)
            {
                dashBoard=[[DashboardView alloc] initWithNibName:@"DashboardView_iPad" bundle:nil];
            }
            else
            {
                dashBoard=[[DashboardView alloc] initWithNibName:@"DashboardView" bundle:nil];
            }
            [self.navigationController pushViewController:dashBoard animated:YES];
        }
       
      
    }
    else
    {
        [UIView transitionWithView:self.view
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCurlUp
                        animations:^ {
                            [self.viewFilter removeFromSuperview];
                        }
                        completion:nil];
        
        [self getRestaurantList];
    }
   
}
*/

- (IBAction)filterCitywiseClicked:(id)sender
{
    UIButton *b = (UIButton*)sender;
   
        if(b.tag == 1)
        {
            //country
            self.btnCityDone.tag = 1;
            [self.pickerCity reloadAllComponents];
//            [self.pickerCity selectRow:[countryId intValue] inComponent:0 animated:YES];
            [self.pickerCity selectRow:0 inComponent:0 animated:YES];
            [btnState setTitle:@"  Select State" forState:UIControlStateNormal];
            
        }
        else if(b.tag == 2)
        {
            //state
            self.btnCityDone.tag = 2;
            [self.pickerCity reloadAllComponents];
            //            [self.pickerCity selectRow:[stateId intValue] inComponent:0 animated:YES];
            [self.pickerCity selectRow:0 inComponent:0 animated:YES];
            
        }
        else if(b.tag == 3)
        {
            //state
            self.btnCityDone.tag = 3;
            [self.pickerCity reloadAllComponents];
            //            [self.pickerCity selectRow:[stateId intValue] inComponent:0 animated:YES];
            [self.pickerCity selectRow:0 inComponent:0 animated:YES];
            
        }
        self.viewCity.hidden = NO;
    
//        [UIView transitionWithView:self.view
//                          duration:0.5
//                           options:UIViewAnimationOptionTransitionCurlDown                   animations:^ {     }
//                        completion:nil];
    //}
    
   
    //self.pickerCity.hidden = NO;
    //self.btnToolbar.hidden = NO;
    [self.view endEditing:YES];
    
}
//- (IBAction)filterDoneClicked:(id)sender
//{
//    self.viewCity.hidden = YES;
//    
//}
//- (IBAction)doneCityPickerClicked:(id)sender
//{
//    self.viewCity.hidden = YES;
//}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField== self.txtArea)
    {
        [self.txtArea resignFirstResponder];
    }
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}
#pragma mark -
#pragma mark UIPICKER methods


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label;
    
    if(IS_IPAD)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, pickerView.frame.size.width, 84)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:32];
    }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, pickerView.frame.size.width, 44)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:20];
    }
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    
   // label.text = [NSString stringWithFormat:@"  %@", [[[[Singleton sharedSingleton] getarrCityList] objectAtIndex:0] objectAtIndex:row]];
    
   //  [self.btnCity setTitle:[NSString stringWithFormat:@"  %@", [[[[Singleton sharedSingleton] getarrCityList] objectAtIndex:0] objectAtIndex:0]] forState:UIControlStateNormal];
    
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    
    if(self.btnCityDone.tag == 1)
    {
        label.text = [NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"CountryName"]];
        
        [btnCountry setTitle:[NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:0] objectForKey:@"CountryName"]] forState:UIControlStateNormal];
        countryId = [NSString stringWithFormat:@"%d", row];
        
        countryDBID = [NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:[countryId intValue]] objectForKey:@"CountryId"]];
        
        [st setValue:countryDBID forKey:@"UserSelectedCountry"];
        
//        btnState.enabled = NO;
//        btnCity.enabled = NO;
//        [btnState setTitle:@"Select State" forState:UIControlStateNormal];
//        [btnCity setTitle:@"Select City" forState:UIControlStateNormal];
//        
//        [self startActivity];
//        [[Singleton sharedSingleton] getStateList: countryDBID];
    }
    else if(self.btnCityDone.tag == 2)
    {
        label.text = [NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"StateName"]];
        
        [btnState setTitle:[NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0]objectAtIndex:0] objectForKey:@"StateName"] ] forState:UIControlStateNormal];
        
        stateId = [NSString stringWithFormat:@"%d", row]; //[[[[[Singleton sharedSingleton] arrStateList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"StateID"];
        
        stateDBID = [NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] arrStateList] objectAtIndex:0]objectAtIndex:[stateId intValue]] objectForKey:@"StateID"]];
        
        [st setValue:stateDBID forKey:@"UserSelectedState"];
        
//        btnCity.enabled = NO;
//        [btnCity setTitle:@"Select City" forState:UIControlStateNormal];
//        
//        
//        [self startActivity];
//        [[Singleton sharedSingleton] getCityList:stateDBID];
    }
    else if(self.btnCityDone.tag == 3)
    {
        label.text = [NSString stringWithFormat:@"  %@", [[[[Singleton sharedSingleton] getarrCityList] objectAtIndex:0] objectAtIndex:row]];
        
        [btnCity setTitle:[NSString stringWithFormat:@"%@", [[[[Singleton sharedSingleton] getarrCityList] objectAtIndex:0]objectAtIndex:0]] forState:UIControlStateNormal];
         [st setValue:btnCity.titleLabel.text forKey:@"UserSelectedCity"];
    }
    [st synchronize];
    
    return label;
    
}
// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
//    if([[Singleton sharedSingleton] getarrCityList].count > 0)
//    {
//        return [[[[Singleton sharedSingleton] getarrCityList] objectAtIndex:0] count];
//    }
    if(self.btnCityDone.tag == 1)
    {
        return [[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] count];
    }
    else if(self.btnCityDone.tag == 2)
    {
        return [[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0] count];
    }
    else if(self.btnCityDone.tag == 3)
    {
        return [[[[Singleton sharedSingleton] getarrCityList] objectAtIndex:0] count];
    }
    return 0;
//   return [[Singleton sharedSingleton] getarrCityList].count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(self.btnCityDone.tag == 1)
    {
        return  [NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"CountryName"]];
    }
    else if(self.btnCityDone.tag == 2)
    {
        return [NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"StateName"]];
    }
    else if(self.btnCityDone.tag == 3)
    {
        return [NSString stringWithFormat:@"  %@", [[[[Singleton sharedSingleton] getarrCityList] objectAtIndex:0] objectAtIndex:row]];
    }
    return @"";
  //  return  [NSString stringWithFormat:@"  %@", [[[[Singleton sharedSingleton] getarrCityList] objectAtIndex:0] objectAtIndex:row]];
}
// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //[self.btnCity setTitle:[NSString stringWithFormat:@"  %@", [[[[Singleton sharedSingleton] getarrCityList] objectAtIndex:0] objectAtIndex:row]] forState:UIControlStateNormal];
  
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    
    if(self.btnCityDone.tag == 1)
    {
        [btnCountry setTitle:[NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"CountryName"]] forState:UIControlStateNormal];
        
        countryId = [NSString stringWithFormat:@"%d", row]; //[[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"CountryId"];
        
        countryDBID = [NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:[countryId intValue]] objectForKey:@"CountryId"]]; //[[Singleton sharedSingleton] getCountryIdFromIndexId:self.btnCountry.titleLabel.text];
        
        [st setValue:countryDBID forKey:@"UserSelectedCountry"];
        
        btnState.enabled = NO;
        btnCity.enabled = NO;
        [btnState setTitle:@"Select State" forState:UIControlStateNormal];
        [btnCity setTitle:@"Select City" forState:UIControlStateNormal];
        
        [self startActivity];
        [[Singleton sharedSingleton] getStateList: countryDBID];
    }
    else if(self.btnCityDone.tag == 2)
    {
        [btnState setTitle:[NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"StateName"] ] forState:UIControlStateNormal];
        
        stateId = [NSString stringWithFormat:@"%d", row]; //[[[[[Singleton sharedSingleton] arrStateList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"StateID"];
        
        stateDBID = [NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] arrStateList] objectAtIndex:0]objectAtIndex:[stateId intValue]] objectForKey:@"StateID"]];
        
        [st setValue:stateDBID forKey:@"UserSelectedState"];
        
        btnCity.enabled = NO;
        [btnCity setTitle:@"Select City" forState:UIControlStateNormal];
        
        
        [self startActivity];
        [[Singleton sharedSingleton] getCityList:stateDBID];
        
    }
    else if(self.btnCityDone.tag == 3)
    {
        [btnCity setTitle:[NSString stringWithFormat:@"%@", [[[[Singleton sharedSingleton] getarrCityList] objectAtIndex:0]objectAtIndex:row] ] forState:UIControlStateNormal];
        
//        cityId = [NSString stringWithFormat:@"%d", row]; //[[[[[Singleton sharedSingleton] arrStateList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"StateID"];
//        
//        cityDBID = [NSString stringWithFormat:@" %@", [[[[[Singleton sharedSingleton] getarrCityList] objectAtIndex:0]objectAtIndex:[cityId intValue]] objectForKey:@"CityId"]];
        
         [st setValue:btnCity.titleLabel.text forKey:@"UserSelectedCity"];
        
    }
    [st synchronize];
    
}
@end
