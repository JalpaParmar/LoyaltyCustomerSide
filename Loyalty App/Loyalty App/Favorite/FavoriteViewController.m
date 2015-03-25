//
//  FavoriteViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "FavoriteViewController.h"
#import "RestaCell.h"
#import "RestaDetailView.h"
#import "Singleton.h"

#define NewProgram_WIDTH_IPAD 690
#define FONT_RESTAURANTNAME_IPAD  [UIFont fontWithName:@"OpenSans-Light" size:20]//[UIFont boldSystemFontOfSize:20]
#define FONT_ADDRESS_IPAD  [UIFont fontWithName:@"OpenSans-Light" size:16] //[UIFont systemFontOfSize:16]

#define NewProgram_WIDTH_IPHONE 350
#define FONT_RESTAURANTNAME_IPHONE [UIFont fontWithName:@"OpenSans-Light" size:15]// [UIFont boldSystemFontOfSize:15]
#define FONT_ADDRESS_IPHONE  [UIFont fontWithName:@"OpenSans-Light" size:12]//[UIFont systemFontOfSize:12]

#define JOIN_BUTTON_HEIGHT 35;
#define DIFFERENCE_CELLSPACING 17

@interface FavoriteViewController ()
@end

@implementation FavoriteViewController

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
     app._flagMainBtn = 0; //2;
    
//    if(IS_IPAD)
//    {
////        self.lblTitleFavorite.font = FONT_centuryGothic_65;
//    }
//    else
//    {
//        self.lblTitleFavorite.font = FONT_centuryGothic_35;
//    }
//    
    
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    
    if ([self.tblView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tblView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.tblView setBackgroundColor:[UIColor whiteColor]];
    [self.tblView setUserInteractionEnabled:YES];
    
    self.tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tblView.hidden = YES;
    
    if(IS_IOS_6)
    {
        CGRect f = self.tblView.frame;
        f.size.height = 340;
        self.tblView.frame = f;
    }

    arrFavoriteRestaurantList = [[NSMutableArray alloc] init];
    
   
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getFavoriteRestaurantList];
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
-(void)getFavoriteRestaurantList
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
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
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:userId  forKey:@"UserId"];
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Favorite restaurant %@ -- ", dict);
             
             if (dict)
             {
                 [self stopActivity];
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     
                     [arrFavoriteRestaurantList removeAllObjects];
                     self.tblView.hidden = NO;
                     [self.tblView reloadData];
                 }
                 else
                 {
                     [arrFavoriteRestaurantList removeAllObjects];
                     
                     [arrFavoriteRestaurantList addObject:[dict objectForKey:@"data"] ];
                     [self getDynamicHeightofLabels];
                     [[Singleton sharedSingleton] setarrFavoriteRestaurantList:[dict objectForKey:@"data"] ];
                     [[Singleton sharedSingleton] setarrRestaurantList:[dict objectForKey:@"data"] ];
                     self.tblView.hidden = NO;
                     [self.tblView reloadData];
                 }
             }
             else
             {
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
                 [self stopActivity];
             }
         } :@"/Restaurant/FavoriteList" data:dict];
    }
}
-(void)getDynamicHeightofLabels
{
    NSLog(@"---- %d ----",  [arrFavoriteRestaurantList count]);
    
    if([arrFavoriteRestaurantList count] > 0)
    {
        for(int i=0; i<[[arrFavoriteRestaurantList objectAtIndex:0] count]; i++)
        {
            NSString *rName =[[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@", [[[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:i]objectForKey:@"StoreName"]]] ;
            // rName = @"ksdfj  djsgkl dfkjds gjdfjgkld ldjflgkj dlfgjkldj gkldfjklgjdfkl gkldfjgkljdfklgjkldjfgkl dklfjgkldfjgkljdklfjgkldfjgkljdfk dklfjgkldfjgkljdfklgjkldfjgkldfj gkdfjklgjdklgjkldf gkljdkl";
            
            
            
            //Address
            NSString *strOffer = [NSString stringWithFormat:@"%@, %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:i] objectForKey:@"StreetLine1"]], [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:i] objectForKey:@"StreetLine2"]]] ;
            
            // strOffer = @"ksdfj  djsgkl dfkjds gjdfjgkld ldjflgkj dlfgjkldj gkldfjklgjdfkl gkldfjgkljdfklgjkldjfgkl dklfjgkldfjgkljdklfjgkldfjgkljdfk dklfjgkldfjgkljdfklgjkldfjgkldfj gkdfjklgjdklgjkldf gkljdkl";
            
            float h;
            CGSize aSize;
            if(IS_IPAD)
                aSize = CGSizeMake(NewProgram_WIDTH_IPAD, 20000);
            else
                aSize = CGSizeMake(NewProgram_WIDTH_IPHONE, 20000);
            
            NSMutableArray *tempArr = [[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:i];
            
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
            [[arrFavoriteRestaurantList objectAtIndex:0] replaceObjectAtIndex:i withObject:tempArr];
        }
    }
}

- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TableView Delegate Method
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if(IS_IOS_8)
    {
        if ([self.tblView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tblView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        
        if ([self.tblView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tblView setLayoutMargins:UIEdgeInsetsZero];
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
    if([arrFavoriteRestaurantList count] > 0)
    {
        return [[arrFavoriteRestaurantList objectAtIndex:0] count];
    }
    else if([arrFavoriteRestaurantList count] == 0)
    {
        return 1;
    }
    return [arrFavoriteRestaurantList count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 80;
    
    float h ;
    if([arrFavoriteRestaurantList count] > 0)
    {
        return [[[[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue] + DIFFERENCE_CELLSPACING + [[[[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfAddress"] floatValue] + JOIN_BUTTON_HEIGHT ;
    }
    else
    {
        return 120;
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
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if([arrFavoriteRestaurantList count] == 0)
    {
        cell.lblName.textAlignment = NSTextAlignmentCenter;
        cell.lblName.text = @"No Restaurants in your favourite list";
        cell.lblAddress.hidden=YES;
        cell.lblAmnt.hidden = YES;
        cell.btnRate.hidden=YES;
        cell.lblKM.hidden=YES;
        cell.lblTime.hidden=YES;
        cell.btnStar.hidden = YES;
        cell.btnTimeIcon.hidden = YES;
        
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        tableView.userInteractionEnabled=NO;
        
        if(IS_IPAD)
        {
            CGRect f = cell.lblName.frame;
            f.size.width = 700;
            f.size.height = 50;
            cell.lblName.frame = f;
        }
        else
        {
            CGRect f = cell.lblName.frame;
            f.size.width = 310;
            cell.lblName.frame = f;
        }
    }
    else
    {
        if(IS_IPAD)
        {
            CGRect f = cell.lblName.frame;
            f.size.width = 700 - 60;
            cell.lblName.frame = f;
        }
        else
        {
            CGRect f = cell.lblName.frame;
            f.size.width = 320 - 45;
            cell.lblName.frame = f;
            
        }
     
        cell.lblName.textAlignment = NSTextAlignmentLeft;
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        tableView.userInteractionEnabled=YES;
        
        cell.lblAddress.hidden=NO;
        cell.lblAmnt.hidden = NO;
        cell.btnRate.hidden=NO;
        cell.lblKM.hidden=NO;
        cell.lblTime.hidden=NO;
        cell.btnStar.hidden = NO;
        cell.btnTimeIcon.hidden = NO;
        
        CGRect ff = cell.lblName.frame;
        ff.size.height = [[[[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue];
        cell.lblName.frame = ff;
        
        ff = cell.lblAddress.frame;
        ff.origin.y = cell.lblName.frame.origin.y + cell.lblName.frame.size.height + 5;
        ff.size.height = [[[[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfAddress"] floatValue];
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
        cell.lblName.text = [[[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"StoreName"];
        
        //Address
        cell.lblAddress.text = [NSString stringWithFormat:@"%@, %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"StreetLine1"]], [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"StreetLine2"]] ];
        
        //Rate
        if([[[[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"restaurantRating"] count] > 0)
        {
            NSString *rRating=@"0";
            NSArray *arrRating = [[[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"restaurantRating"];
            if([arrRating count] > 0)
            {
                rRating = [[Singleton sharedSingleton] getReviewFromGLobalArray:arrRating];
                if([[rRating stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"0"])
                {
                    cell.btnRate.hidden = YES;
                    cell.btnStar.hidden = YES;
                }
            }
            [cell.btnRate setTitle:[NSString stringWithFormat:@"  %@", rRating] forState:UIControlStateNormal];
        }
        else
        {
            cell.btnRate.hidden = YES;
            cell.btnStar.hidden = YES;
//            [cell.btnRate setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
        }

        
        //Min Amount
        if(IS_IPAD)
        {
            cell.lblAmnt.text =[NSString stringWithFormat:@"Min Order: %@ %@ for Home Delivery", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"CurrencySign"]], [[[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"MinimumOrderDollar"]];
        }
        else
        {
            cell.lblAmnt.text =[NSString stringWithFormat:@"Min Order: %@ %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"CurrencySign"]], [[[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"MinimumOrderDollar"]];
        }
       
        
        //Time
        NSString *search =   [[Singleton sharedSingleton] getCurrentDayName];//@"Monday";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"DayName matches %@ ", search];
        NSArray *array = [[[[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"timingmodel"] filteredArrayUsingPredicate: predicate];
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
            lat =  [[[[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"Latidute"] doubleValue];
            lon =  [[[[arrFavoriteRestaurantList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"Longitude"] doubleValue];

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
    [[Singleton sharedSingleton] setIndexId:indexPath.row];
    detail.IS_PUSHNOTIFICATION = FALSE;

    detail._fromWhere = @"FromFavorite";
    [self.navigationController pushViewController:detail animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
