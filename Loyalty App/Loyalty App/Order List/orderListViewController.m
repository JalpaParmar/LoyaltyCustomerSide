//
//  orderListViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "orderListViewController.h"
#import "RestaCell.h"
#import "RestaDetailView.h"
#import "Singleton.h"
#import "orderHistoryCell.h"
#import "OrderDetailViewController.h"
#import "DeliveryOrderDetail.h"

#define NewProgram_WIDTH_IPAD 690
#define FONT_RESTAURANTNAME_IPAD [UIFont fontWithName:@"OpenSans-Light" size:17]// [UIFont systemFontOfSize:17]
#define FONT_ADDRESS_IPAD [UIFont fontWithName:@"OpenSans-Light" size:17]// [UIFont systemFontOfSize:17]

#define NewProgram_WIDTH_IPHONE 310
#define FONT_RESTAURANTNAME_IPHONE [UIFont fontWithName:@"OpenSans-Light" size:13]// [UIFont systemFontOfSize:13]
#define FONT_ADDRESS_IPHONE  [UIFont fontWithName:@"OpenSans-Light" size:13]//[UIFont systemFontOfSize:13]

#define DIFFERENCE_CELLSPACING 35 //30 //15

//#if IS_IPAD
//#define  TWO_UPPER_ROWS 50
//#else
//#define TWO_UPPER_ROWS 80

#define TWO_UPPER_ROWS (IS_IPAD ? 50 : 50)

@interface orderListViewController ()
@end

@implementation orderListViewController

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
   
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
//    self.lblTitleOrderHistory.font = FONT_centuryGothic_35;
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    
    self.tblOrderHistory.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tblOrderHistory.hidden = YES;
    [self.tblOrderHistory setBackgroundColor:[UIColor whiteColor]];
    [self.tblOrderHistory setUserInteractionEnabled:YES];

    self.arrOrderHistory = [[NSMutableArray alloc] init];
    strURL=@"User/OrderHistory";
    
    
    [self getOrderHistory];
}
-(void)viewWillAppear:(BOOL)animated
{
    
 /*   [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         // Rotate the spinner by M_PI_2 = PI/2 = 90 degrees
                         [self startActivity];
                         
                         // Change the background color
                         //                         self.refreshColorView.backgroundColor = [colorArray objectAtIndex:colorIndex];
                         //                         colorIndex = (colorIndex + 1) % colorArray.count;
                     }
                     completion:^(BOOL finished) {
                        [self stop];
                     }];
*/
    
     objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationPortrait	);
    
    app = APP;
    [self.view addSubview:[app setFooterPart]];
    app._flagMainBtn = 4;
}
#pragma mark UIBUTTON CLICK EVENT
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
-(void)getOrderHistory
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
        [dict setValue:userId forKey:@"UserId"];
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Order History List - - %@ -- ", dict);
              if (dict)
             {
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     
                     if([strURL isEqualToString:@"User/OrderHistory"])
                     {
                           [self.arrFood removeAllObjects];
                           [self.arrOrderHistory removeAllObjects];
                     }
                     else if([strURL isEqualToString:@"User/ReservationHistory"])
                     {
                           [self.arrReservation removeAllObjects];
                           [self.arrOrderHistory removeAllObjects];
                     }
                     
                     self.tblOrderHistory.hidden = NO;
                     [self.tblOrderHistory reloadData];
                 }
                 else
                 {
                     if([strURL isEqualToString:@"User/OrderHistory"])
                     {
                         if([[dict objectForKey:@"data"] count] > 0)
                         {
                             self.arrFood = [dict objectForKey:@"data"];
                         }
                         self.arrOrderHistory = self.arrFood;
                     }
                     else if([strURL isEqualToString:@"User/ReservationHistory"])
                     {
                         if([[dict objectForKey:@"data"] count] > 0)
                         {
                             self.arrReservation = [dict objectForKey:@"data"];
                         }
                         self.arrOrderHistory = self.arrReservation;
                     }
                     
                     
                     [self getDynamicHeightofLabels];
                  
                     self.tblOrderHistory.hidden = NO;
                     [self.tblOrderHistory reloadData];
                  }
                 [self stopActivity];
             }
             else
             {
                 if([strURL isEqualToString:@"User/OrderHistory"])
                 {
                     [self.arrFood removeAllObjects];
                     [self.arrOrderHistory removeAllObjects];
                 }
                 else if([strURL isEqualToString:@"User/ReservationHistory"])
                 {
                     [self.arrReservation removeAllObjects];
                     [self.arrOrderHistory removeAllObjects];
                 }
                 
                 self.tblOrderHistory.hidden = NO;
                 [self.tblOrderHistory reloadData];
                 
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
                 [self stopActivity];
             }
         } :strURL data:dict];
    }
}

-(void)getDynamicHeightofLabels
{
    NSLog(@"---- %d ----",  [self.arrOrderHistory count]);

    if([self.arrOrderHistory count] > 0)
    {
        for(int i=0; i<[self.arrOrderHistory count]; i++)
        {
            NSString *rName =[NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[self.arrOrderHistory objectAtIndex:i] objectForKey:@"StoreName"]]];
             //  rName = @"ksdfj  djsgkl dfkjds gjdfjgkld ldjflgkj dlfgjkldj gkldfjklgjdfkl gkldfjgkljdfklgjkldjfgkl dklfjgkldfjgkljdklfjgkldfjgkljdfk dklfjgkldfjgkljdfklgjkldfjgkldfj gkdfjklgjdklgjkldf gkljdkl";
            
            
            //Address
            NSString *strOffer = [NSString stringWithFormat:@"%@ %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[self.arrOrderHistory objectAtIndex:i] objectForKey:@"StreetLine1"]], [[Singleton sharedSingleton] ISNSSTRINGNULL:[[self.arrOrderHistory objectAtIndex:i] objectForKey:@"StreetLine2"]]];
            //  strOffer = @"ksdfj  djsgkl dfkjds gjdfjgkld ldjflgkj dlfgjkldj gkldfjklgjdfkl gkldfjgkljdfklgjkldjfgkl dklfjgkldfjgkljdklfjgkldfjgkljdfk dklfjgkldfjgkljdfklgjkldfjgkldfj gkdfjklgjdklgjkldf gkljdkl";
            
            float h;
            CGSize aSize;
            if(IS_IPAD)
                aSize = CGSizeMake(NewProgram_WIDTH_IPAD, 20000);
            else
                aSize = CGSizeMake(NewProgram_WIDTH_IPHONE, 20000);
            
            NSMutableArray *tempArr = [self.arrOrderHistory objectAtIndex:i];
            
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
            
            h = ceilf([[Singleton sharedSingleton]  heightOfTextForLabel:strOffer andFont:font maxSize:aSize].height);
            [tempArr setValue:[NSString stringWithFormat:@"%f", h] forKey:@"HeightOfAddress"];
           [self.arrOrderHistory  replaceObjectAtIndex:i withObject:tempArr];
        }
    }
}



- (IBAction)btnFoodReservationClicked:(id)sender {
    
    NSString *msg;
    UIButton *btn = (UIButton*)sender;
    
    if(btn.tag == 1)
    {
        [self.btnFood setBackgroundColor:[UIColor whiteColor]];
        [self.btnReservation setBackgroundColor:[UIColor lightGrayColor]];
        msg = [NSString stringWithFormat:@"Food Clicked"];
        strURL=@"User/OrderHistory";
    }
    else if(btn.tag == 2)
    {
        [self.btnFood setBackgroundColor:[UIColor lightGrayColor]];
        [self.btnReservation setBackgroundColor:[UIColor whiteColor]];
        msg = [NSString stringWithFormat:@"Reservation Clicked"];
        strURL=@"User/ReservationHistory";
    }
    [self getOrderHistory];
    
//    [self.tblOrderHistory reloadData];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    [alert show];
    
}

- (IBAction)btnBackClick:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark TableView Delegate Method
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(IS_IOS_8)
    {
    if ([self.tblOrderHistory respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tblOrderHistory setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tblOrderHistory respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tblOrderHistory setLayoutMargins:UIEdgeInsetsZero];
    }
//
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
    if([self.arrOrderHistory count] > 0)
    {
        return [self.arrOrderHistory count];
    }
    else
    {
        return 1;
    }
    return [self.arrOrderHistory count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 100;
    
    float h ;
    if([strURL isEqualToString:@"User/OrderHistory"])
    {
        if([self.arrOrderHistory count] > 0)
        {
            
            return [[[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue]
            +
            DIFFERENCE_CELLSPACING
            +
            [[[self.arrOrderHistory  objectAtIndex:indexPath.row] objectForKey:@"HeightOfAddress"] floatValue]
            +
            TWO_UPPER_ROWS ;
        }
        else
        {
            return 100;
        }
    }
    else if([strURL isEqualToString:@"User/ReservationHistory"])
    {
        h = 40;
        if([self.arrOrderHistory count] > 0)
        {
            return [[[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue]
            +
            DIFFERENCE_CELLSPACING
            +
            [[[self.arrOrderHistory  objectAtIndex:indexPath.row] objectForKey:@"HeightOfAddress"] floatValue]
            +
            TWO_UPPER_ROWS ;
        }
        else
        {
            return 40;
        }
    }
    h = 100;
    return h;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    
    if(IS_IPAD)
        simpleTableIdentifier = @"orderHistoryCell_iPad";
    else
        simpleTableIdentifier = @"orderHistoryCell";
    
    orderHistoryCell *cell = (orderHistoryCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if([self.arrOrderHistory count] == 0)
    {
        cell.lblOrderType.hidden = NO;
        cell.lblOrderDate.hidden  =YES;
        cell.btnReview.hidden = YES;
        cell.lblOrderTOtal.hidden = YES;
        cell.lblStoreAddress.hidden = YES;
        cell.lblStoreName.hidden = YES;
         cell.lblTotalPerson.hidden = YES;
        cell.btnReceipt.hidden=YES;
        cell.btnTimeIcon.hidden = YES;
        cell.lblOrderTime.hidden = YES;
        cell.lblOrderStatus.hidden = YES;
         cell.btnTimeIcon1.hidden=YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblOrderType.textAlignment = NSTextAlignmentCenter;
        if([strURL isEqualToString:@"User/OrderHistory"])
        {
           cell.lblOrderType.text = @"Didn't get any order history.";
        }
        else if([strURL isEqualToString:@"User/ReservationHistory"])
        {
            cell.lblOrderType.text = @"You have not done any reservation.";
        }
        cell.userInteractionEnabled = NO;
        self.tblOrderHistory.userInteractionEnabled = NO;
        self.tblOrderHistory.separatorStyle = UITableViewCellSeparatorStyleNone;
        CGRect f = cell.lblOrderType.frame;
        if(IS_IPAD)
        {
             f.size.width = 755;
        }
        else
        {
             f.size.width = 320;
        }
        cell.lblOrderType.frame = f;
    }
    else
    {
        cell.lblOrderType.hidden = NO;
        cell.lblOrderDate.hidden  =NO;
        cell.btnReview.hidden = NO;
        cell.lblOrderTOtal.hidden = NO;
        cell.lblStoreAddress.hidden = NO;
        cell.lblStoreName.hidden = NO;
        cell.btnTimeIcon.hidden = NO;
        cell.lblOrderTime.hidden = NO;
      
        cell.btnReview.layer.cornerRadius = 5.0;
        cell.btnReview.clipsToBounds = YES;
        
        cell.btnReceipt.layer.cornerRadius = 5.0;
        cell.btnReceipt.clipsToBounds = YES;
        

        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.lblOrderType.textAlignment = NSTextAlignmentLeft;
        self.tblOrderHistory.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        cell.userInteractionEnabled = YES;
        self.tblOrderHistory.userInteractionEnabled = YES;
        
        CGRect ff = cell.lblStoreName.frame;
        ff.size.height = [[[self.arrOrderHistory  objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue];
        cell.lblStoreName.frame = ff;
        
        ff = cell.lblStoreAddress.frame;
        ff.origin.y = cell.lblStoreName.frame.origin.y + cell.lblStoreName.frame.size.height + 3;
        ff.size.height = [[[self.arrOrderHistory  objectAtIndex:indexPath.row] objectForKey:@"HeightOfAddress"] floatValue];
        cell.lblStoreAddress.frame = ff;
        
        ff = cell.btnReceipt.frame;
        ff.origin.y = cell.lblStoreAddress.frame.origin.y;
        cell.btnReceipt.frame = ff;
        
        if([strURL isEqualToString:@"User/OrderHistory"])
        {
            
            //        Country = India;
            //        OrderDate = "/Date(1410757200000)/";
            //        OrderId = "4724673d-7f8b-4e42-b1a7-d363a8da2eff";
            //        OrderTotal = "<null>";
            //        OrderType = "Home Delivery";
            //        RestaurantId = "ef592442-2dd3-49c7-a550-d27189beeee8";
            //        State = Gujarat;
            //        StoreName = "Ntech - Amdavad";
            //        StreetLine1 = "Opp. VS Hospital";
            //        StreetLine2 = "Ashram Road,";
            //        ZipCode = 15032;
            
            cell.lblTotalPerson.hidden = YES;
            cell.btnReview.hidden  = NO;
            cell.lblOrderStatus.hidden = NO;
            cell.btnReceipt.hidden=NO;
             cell.btnTimeIcon1.hidden=YES;
            CGRect f = cell.lblOrderType.frame;
            if(IS_IPAD)
            {
                 f.size.width = 670;
            }
            else
            {
                 f.size.width = 250;
            }
           
            cell.lblOrderType.frame = f;
            
            cell.lblOrderType.text=[NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"OrderType"]]];
            
            NSString *str = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL: [[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"OrderDate"]]];
              NSString *strOrderDate=@"", *strOrderTime=@"";
            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str] isEqualToString:@""])
            {
                strOrderDate = [[Singleton sharedSingleton] ConvertMilliSecIntoDate:str Format:@"dd MMM yyyy"];
            }
            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str] isEqualToString:@""])
            {
                strOrderTime = [[Singleton sharedSingleton] ConvertMilliSecIntoDate:str Format:@"hh:mm a"];
            }
            
//            str = [str substringToIndex:[str length]- 2];
//            NSArray *arr = [str componentsSeparatedByString:@"("];
//            NSDate *joinDate;
//          
//            if([arr count] > 0)
//            {
//                str = [arr objectAtIndex:1];
//                joinDate = [NSDate dateWithTimeIntervalSince1970:[[arr objectAtIndex:1] doubleValue]/1000];
//                NSDateFormatter *format = [[NSDateFormatter alloc] init];
//                [format setDateFormat:@"dd MMM yyyy"];
//                strOrderDate = [format stringFromDate:joinDate];
//                [format setDateFormat:@"hh:mm a"];
//                strOrderTime = [format stringFromDate:joinDate];
//            }
            
            cell.lblOrderDate.text=[NSString stringWithFormat:@"Order Date: %@", strOrderDate];
            if(!IS_IPAD)
            {
                cell.lblOrderDate.text= [NSString stringWithFormat:@"Order Date: %@", strOrderDate];
                CGRect f = cell.lblOrderDate.frame;
                f.size.width = 160;
                cell.lblOrderDate.frame = f;
                
                f = cell.btnTimeIcon.frame;
                f.origin.x = cell.lblOrderDate.frame.origin.x + cell.lblOrderDate.frame.size.width + 2;
                cell.btnTimeIcon.frame = f;
                
                f = cell.lblOrderTime.frame;
                f.origin.x = cell.btnTimeIcon.frame.origin.x + cell.btnTimeIcon.frame.size.width + 2;
                cell.lblOrderTime.frame = f;
                
                 cell.lblOrderTime.text= [NSString stringWithFormat:@" %@", strOrderTime];
            }
            else
            {
                 cell.lblOrderTime.text= [NSString stringWithFormat:@"      %@", strOrderTime];
            }
            
            cell.lblOrderTOtal.text=[NSString stringWithFormat:@"Total: %@%.02f", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"CurrencySign"]], [[[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"OrderTotal"] floatValue]];
            
            
            cell.lblStoreName.text=[NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"StoreName"]]];
            cell.lblStoreAddress.text=[NSString stringWithFormat:@"%@ %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"StreetLine1"]], [[Singleton sharedSingleton] ISNSSTRINGNULL:[[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"StreetLine2"]]];
            
            //status
            cell.lblOrderStatus.text=[NSString stringWithFormat:@"Status:  %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"AdminOrderStatus"]]];
            
            
            //Rating
            cell.btnReview.tag=indexPath.row;
            NSString *rat = [[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"OrderRating"];
            @try {
                cell.btnReview.enabled = YES;
                cell.btnReview.userInteractionEnabled = YES;
                rat = [[Singleton sharedSingleton] ISNSSTRINGNULL:rat];
                if([rat isEqualToString:@""])
                {
                    [cell.btnReview setTitle:@"Review" forState:UIControlStateNormal];
                }
                else
                {
                    [cell.btnReview setTitle:[NSString stringWithFormat:@"%@", [[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"OrderRating"]] forState:UIControlStateNormal];
                    cell.btnReview.enabled = NO;
                    cell.btnReview.userInteractionEnabled = NO;
                }

            }
            @catch (NSException *exception) {
                 [cell.btnReview setTitle:[NSString stringWithFormat:@"%0.1f", [rat doubleValue]] forState:UIControlStateNormal];
                cell.btnReview.enabled = NO;
                cell.btnReview.userInteractionEnabled = NO;
            }
            
            [cell.btnReview addTarget:self action:@selector(btnReviewdClicked:) forControlEvents:UIControlEventTouchUpInside];
            
             cell.btnReceipt.tag=indexPath.row;
             [cell.btnReceipt addTarget:self action:@selector(btnReceiptClicked:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else if([strURL isEqualToString:@"User/ReservationHistory"])
        {
            
//            BookingDate = "/Date(1410843600000)/";
//            Country = India;
//            CreatedOn = "/Date(1410843600000)/";
//            EndTime =     {
//                Days = 0;
//                Hours = 15;
//                Milliseconds = 0;
//                Minutes = 50;
//                Seconds = 0;
//                Ticks = 570000000000;
//                TotalDays = "0.6597222222222222";
//                TotalHours = "15.83333333333333";
//                TotalMilliseconds = 57000000;
//                TotalMinutes = 950;
//                TotalSeconds = 57000;
//            };
//            HeightOfAddress = "15.000000";
//            HeightOfRestaurantName = "15.000000";
//            RestaurantId = "b11386ba-e31e-466c-879b-1de8f559cb31";
//            StartTime =     {
//                Days = 0;
//                Hours = 15;
//                Milliseconds = 0;
//                Minutes = 50;
//                Seconds = 0;
//                Ticks = 570000000000;
//                TotalDays = "0.6597222222222222";
//                TotalHours = "15.83333333333333";
//                TotalMilliseconds = 57000000;
//                TotalMinutes = 950;
//                TotalSeconds = 57000;
//            };
//            State = Gujarat;
//            StoreName = Honest;
//            StreetLine1 = Prahaladnagar;
//            StreetLine2 = "S G highway";
//            TableType = "Select Any Table";
//            TotalPersons = 5;
//            ZipCode = 381200;
            
            
            cell.lblTotalPerson.hidden = NO;
            cell.btnReview.hidden  =YES;
            cell.btnReceipt.hidden=YES;
            cell.lblOrderStatus.hidden = NO;
            
            CGRect f = cell.lblOrderType.frame;
            f.size.width = 200;
            cell.lblOrderType.frame = f;
            
            //Table Type
            cell.lblOrderType.text=[NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"TableType"]] ];
       
            // Person
            cell.lblTotalPerson.text=[NSString stringWithFormat:@"Person: %@", [[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"TotalPersons"]];
            
            //Booking Date & Time
            NSString *str = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton] ISNSSTRINGNULL: [[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"CreatedOn"]]];
            
            NSString *strOrderDate=@"", *strOrderTime=@"";
            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str] isEqualToString:@""])
            {
                strOrderDate = [[Singleton sharedSingleton] ConvertMilliSecIntoDate:str Format:@"dd MMM yyyy"];
            }
            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str] isEqualToString:@""])
            {
                strOrderTime = [[Singleton sharedSingleton] ConvertMilliSecIntoDate:str Format:@"hh:mm a"];
            }            
            if(IS_IPAD)
            {
                 cell.lblOrderDate.text= [NSString stringWithFormat:@"Reservation Date: %@", strOrderDate];
                 cell.lblOrderTime.text= [NSString stringWithFormat:@"      %@", strOrderTime];
            }
            else
            {
                 cell.lblOrderDate.text= [NSString stringWithFormat:@"Reservation Date: %@", strOrderDate];
                 CGRect f = cell.lblOrderDate.frame;
                 f.size.width = 190;
                cell.lblOrderDate.frame = f;
                
                f = cell.btnTimeIcon.frame;
                f.origin.x = cell.lblOrderDate.frame.origin.x + cell.lblOrderDate.frame.size.width + 2;
                cell.btnTimeIcon.frame = f;
                
                f = cell.lblOrderTime.frame;
                f.origin.x = cell.btnTimeIcon.frame.origin.x + cell.btnTimeIcon.frame.size.width + 2;
                cell.lblOrderTime.frame = f;
                
                 cell.lblOrderTime.text= [NSString stringWithFormat:@"%@", strOrderTime];
            }
            
            
            //Booking Time
//            NSMutableDictionary *arrStartTime = [[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"StartTime"];
//            NSMutableDictionary *arrEndTime = [[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"EndTime"];
//
            
//            //NSDate *sd;
//            if([arrStartTime count] > 0)
//            {
//                startTime = [NSString stringWithFormat:@"%@:%@", [arrStartTime objectForKey:@"Hours"], [arrStartTime objectForKey:@"Minutes"]];
//
////                NSDateFormatter *format = [[NSDateFormatter alloc] init];
////                [format setDateFormat:@"hh:mm a"];
////                sd = [format dateFromString:startTime];
//
//            }
//            if([arrEndTime count] > 0)
//            {
//                endTime = [NSString stringWithFormat:@"%@:%@", [arrEndTime objectForKey:@"Hours"], [arrEndTime objectForKey:@"Minutes"]];
//            }
            //
            
            NSString *startTime =  [[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"StartTime"];
            NSString *endTime = [[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"EndTime"];

            
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

            cell.btnTimeIcon1.hidden=NO;
            if(IS_IPAD)
            {
//                cell.lblOrderTOtal.text=[NSString stringWithFormat:@"%@ to %@", startTime, endTime];
                
                if([[[Singleton sharedSingleton] ISNSSTRINGNULL:startTime] isEqualToString:@""] && [[[Singleton sharedSingleton] ISNSSTRINGNULL:endTime] isEqualToString:@""])
                {
                    cell.lblOrderTOtal.text = [NSString stringWithFormat:@"Time not available"];
                }
                else if([[[Singleton sharedSingleton] ISNSSTRINGNULL:startTime]   isEqualToString:@""])
                {
                    cell.lblOrderTOtal.text = [NSString stringWithFormat:@"%@", startTime];
                }
                else if([[[Singleton sharedSingleton] ISNSSTRINGNULL:endTime] isEqualToString:@""])
                {
                    cell.lblOrderTOtal.text = [NSString stringWithFormat:@"%@", endTime];
                }
                else
                {
                    cell.lblOrderTOtal.text = [NSString stringWithFormat:@"%@ to %@", startTime, endTime];
                }
                
            }
            else
            {
//                 cell.lblOrderTOtal.text=[NSString stringWithFormat:@"Requested Date:  %@ to %@", startTime, endTime];
                
                if([[[Singleton sharedSingleton] ISNSSTRINGNULL:startTime] isEqualToString:@""] && [[[Singleton sharedSingleton] ISNSSTRINGNULL:endTime] isEqualToString:@""])
                {
                    cell.lblOrderTOtal.text = [NSString stringWithFormat:@"Time not available"];
                }
                else if([[[Singleton sharedSingleton] ISNSSTRINGNULL:startTime]   isEqualToString:@""])
                {
                    cell.lblOrderTOtal.text = [NSString stringWithFormat:@"Requested Date: %@", startTime];
                }
                else if([[[Singleton sharedSingleton] ISNSSTRINGNULL:endTime] isEqualToString:@""])
                {
                    //cell.lblOrderTOtal.text = [NSString stringWithFormat:@"%@", endTime];
                }
                else
                {
                    cell.lblOrderTOtal.text = [NSString stringWithFormat:@"Requested Date:  %@ to %@", startTime, endTime];

                }
                
            }
            
            
            
            //Store Name
            cell.lblStoreName.text=[NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"StoreName"]]];
            
            //Store Address
            cell.lblStoreAddress.text=[NSString stringWithFormat:@"%@ %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"StreetLine1"]], [[Singleton sharedSingleton] ISNSSTRINGNULL:[[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"StreetLine2"]]];
            
            // reservation status
//
            @try {
                if([[[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"ConfirmStatus"] boolValue])
                {
                    cell.lblOrderStatus.text = [NSString stringWithFormat:@"Status: Confirmed"];
                }
                else
                {
                    cell.lblOrderStatus.text = [NSString stringWithFormat:@"Status: Pending"];
                }
            }
            @catch (NSException *exception) {
                cell.lblOrderStatus.text = [NSString stringWithFormat:@"Status: Pending"];
            }
                       
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if([strURL isEqualToString:@"User/OrderHistory"])
    {
        
        OrderDetailViewController *detail;
        if (IS_IPHONE_5)
        {
            detail=[[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            detail=[[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController_iPad" bundle:nil];
        }
        else
        {
            detail=[[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
        }
        detail.selectedOrderId = [[self.arrOrderHistory objectAtIndex:indexPath.row] objectForKey:@"OrderId"];
        detail._fromWhere = @"FromOrderList";
        [self.navigationController pushViewController:detail animated:YES];

    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)btnReceiptClicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
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
    restauView.selectedOrderId = [[self.arrOrderHistory objectAtIndex:btn.tag] objectForKey:@"OrderId"];
    [self.navigationController pushViewController:restauView animated:YES];
}
-(void)btnReviewdClicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    index_Rating = btn.tag;
    
    NSIndexPath *ind = [NSIndexPath indexPathForRow:index_Rating inSection:0];
    orderHistoryCell *cell = (orderHistoryCell*)[self.tblOrderHistory cellForRowAtIndexPath:ind];
    [self.view addSubview:self.viewrating];
  
    DLStarRatingControl *customNumberOfStars;
    
    if(IS_IPAD)
    {
        // Custom Number of Stars
        customNumberOfStars = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(0, 320, 768, 153) andStars:5 isFractional:YES];
        customNumberOfStars.delegate = self;
        customNumberOfStars.backgroundColor = [UIColor whiteColor]; //[UIColor groupTableViewBackgroundColor];
        customNumberOfStars.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        customNumberOfStars.rating = 0;
        if(![cell.btnReview.titleLabel.text isEqualToString:@"Review"])
        {
            customNumberOfStars.rating = [cell.btnReview.titleLabel.text floatValue];
        }
        
        [self.viewrating addSubview:customNumberOfStars];
        
        self.lblrating.frame = CGRectMake(0, 8, 765, 30);
        self.lblrating.text=@"Add Review";
    }
    else
    {
        // Custom Number of Stars
        customNumberOfStars = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(0, 184, 320, 153) andStars:5 isFractional:YES];
        customNumberOfStars.delegate = self;
        customNumberOfStars.backgroundColor = [UIColor whiteColor]; //[UIColor groupTableViewBackgroundColor];
        customNumberOfStars.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        customNumberOfStars.rating = 0;
        if(![cell.btnReview.titleLabel.text isEqualToString:@"Review"])
        {
            customNumberOfStars.rating = [cell.btnReview.titleLabel.text floatValue];
        }
        
        [self.viewrating addSubview:customNumberOfStars];
        
        self.lblrating.frame = CGRectMake(0, 8, 320, 30);
         self.lblrating.text=@"Add Review";
    }
    [customNumberOfStars addSubview:self.lblrating];
    
}
#pragma mark -
#pragma mark Delegate implementation of NIB instatiated DLStarRatingControl

-(void)newRating:(DLStarRatingControl *)control :(float)rating
{
    if(rating > 0 )
    {
        self.lblrating.text = [NSString stringWithFormat:@"%0.1f star rating",rating];
        float rate = [[NSString stringWithFormat:@"%0.1f star rating",rating] floatValue];
        [self sendReviewOfOrder:rate];
    }
	
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.viewrating removeFromSuperview];
}
-(void)sendReviewOfOrder:(float)rate
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
        [self startActivity];
        //UserId,OrderId ,OrderRate
        
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        NSString * userId ;
        if([st objectForKey:@"UserId"])
        {
            userId =  [st objectForKey:@"UserId"];
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:userId forKey:@"UserId"];
        [dict setValue:[NSString stringWithFormat:@"%@", [[self.arrOrderHistory objectAtIndex:index_Rating] objectForKey:@"OrderId"]] forKey:@"OrderId"];
        [dict setValue:[NSNumber numberWithFloat:rate] forKey:@"OrderRate"];

        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Order Review List - - %@ -- ", dict);
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
                     NSIndexPath *ind = [NSIndexPath indexPathForRow:index_Rating inSection:0];
                     orderHistoryCell *cell = (orderHistoryCell*)[self.tblOrderHistory cellForRowAtIndexPath:ind];
                     [cell.btnReview setTitle:[NSString stringWithFormat:@"%.01f", rate] forState:UIControlStateNormal];
                     cell.btnReview.enabled = NO;
                     cell.btnReview.userInteractionEnabled = NO;
                     
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     alt.tag = 22;
                     [alt show];
                     
                    
                     
                 }
                 [self stopActivity];
             }
             else
             {
               UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
                 [self stopActivity];
             }
         } :@"User/AddRates" data:dict];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 22)
    {
        [self.viewrating removeFromSuperview];
    }
}
#pragma mark - ROTATE
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    //	(iOS 5)
//    //	Only allow rotation to portrait
//    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//- (BOOL)shouldAutorotate
//{
//    //	(iOS 6)
//    //	No auto rotating
//    return NO;
//}

//- (NSUInteger)supportedInterfaceOrientations
//{
//    //	(iOS 6)
//    //	Only allow rotation to portrait
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    //	(iOS 6)
//    //	Force to portrait
//    return UIInterfaceOrientationPortrait;
//}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//-(BOOL)shouldAutorotate
//{
//   // return NO;
//    if (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
//        //note that UIInterfaceOrientationIsPortrait(self.interfaceOrientation) will return yes for UIInterfaceOrientationPortraitUpsideDown
//        return NO;
//    }
//    else if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
//        //note that UIInterfaceOrientationIsPortrait(self.interfaceOrientation) will return yes for UIInterfaceOrientationPortraitUpsideDown
//        return YES;
//    }
//    else {
//        return NO;
//    }
//    
//}
//
//-(NSUInteger)supportedInterfaceOrientations {
//    
//        return UIInterfaceOrientationMaskPortrait;
//    
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    //Setting the orientation of the view.  Ive set it to portrait here.
//    
//    return UIInterfaceOrientationPortrait;
//    
//}
@end
