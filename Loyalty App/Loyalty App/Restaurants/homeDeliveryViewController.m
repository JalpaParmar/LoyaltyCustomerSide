//
//  homeDeliveryViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/22/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "homeDeliveryViewController.h"
#import "HomeDelivery.h"
#import "addOrderViewController.h"
#import "Singleton.h"
#import "OrderProcessViewController.h"
#import "HomeCategory.h"
#import "OrderDetailViewController.h"
#import "MyrewardView.h"

//Category iPhone
#define CATEGORY_WIDTH_IPHONE 102
#define FONT_CATEGORY_IPHONE [UIFont fontWithName:@"OpenSans-Light" size:13]
//Category iPad
#define CATEGORY_WIDTH_IPAD 174
#define FONT_CATEGORY_IPAD [UIFont fontWithName:@"OpenSans-Light" size:18]

//Item iPhone
#define ITEM_WIDTH_IPHONE 203
#define FONT_ITEM_IPHONE [UIFont fontWithName:@"OpenSans-Light" size:14]
//Item iPad
#define ITEM_WIDTH_IPAD 574
#define FONT_ITEM_IPAD [UIFont fontWithName:@"OpenSans-Light" size:18]



#define SHOW_MULTIPLE_SECTIONS		1		// If commented out, multiple sections with header and footer views are not shown

#define PORTRAIT_WIDTH				768
#define LANDSCAPE_HEIGHT			(1024-20)
#define HORIZONTAL_TABLEVIEW_HEIGHT	140
#define VERTICAL_TABLEVIEW_WIDTH	180
#define TABLE_BACKGROUND_COLOR		[UIColor clearColor]

#define BORDER_VIEW_TAG				10

#ifdef SHOW_MULTIPLE_SECTIONS
#define NUM_OF_CELLS			10
#define NUM_OF_SECTIONS			2
#else
#define NUM_OF_CELLS			21
#endif



@interface homeDeliveryViewController ()
@end

@implementation homeDeliveryViewController

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

   [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
    

    // register notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GoTobackFromNotification) name:@"GoTobackFromNotification" object:nil];
    
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    if([st objectForKey:@"IS_ORDER_START"])
    {
        NSString *IS_STARTED = [st objectForKey:@"IS_ORDER_START"];
        if([IS_STARTED isEqualToString:@"YES"])
        {
        }
        else
        {
            //Your Order is started - call webservice and set YES to IS_Order_StartDelete
            IS_Order_StartDelete  = YES;
            [[Singleton sharedSingleton] callOrderStartService:@"homeDeliveryViewController" OrderStatus:IS_Order_StartDelete TableId:@""];
        }
    }
    else
    {
        //Your Order is started - call webservice and set YES to IS_Order_StartDelete
        IS_Order_StartDelete  = YES;
        [[Singleton sharedSingleton] callOrderStartService:@"HD" OrderStatus:IS_Order_StartDelete TableId:@""];
    }
    
    
//       if([[[Singleton sharedSingleton] getarrOrderOfCurrentUser] count] <= 0)
//       {
//           self.btnOrderList.userInteractionEnabled = NO;
//           self.btnOrderList.enabled = NO;
//       }
        
    selectedRow = 0;

    if ([self.tblVW respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tblVW setSeparatorInset:UIEdgeInsetsZero];
    }
     self.tblVW.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tblVW.hidden=YES;
    
    if(IS_IOS_6)
    {
        CGRect f = self.tblVW.frame;
        f.size.height = 242;
        self.tblVW.frame = f;
    }
    
    indexId = [[Singleton sharedSingleton] getIndexId];
    arrCategoryList = [[NSMutableArray alloc] init];
    if([[[Singleton sharedSingleton] getarrRestaurantList] count] > 0)
    {
        [arrCategoryList addObject:[[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"restaurantCategory"]];
    }
 
    [self getDynamicHeightofLabels];
    
    [self setupHorizontalScrollView];
 
    NSLog(@"-- arrCategoryList --- %@", arrCategoryList);
    if([arrCategoryList count] > 0)
    {
        if([[arrCategoryList objectAtIndex:0] count] > 0)
        {
            [self getItemListOfSelectedCategory: 1];
//            [self  performSelectorInBackground:@selector(setupHorizontalScrollView) withObject:nil];
        }
    }
 }
-(void)viewWillAppear:(BOOL)animated
{
//    setarrOrderOfCurrentUser
    if([[[Singleton sharedSingleton] getarrOrderOfCurrentUser] count] > 0)
    {
        if([Singleton sharedSingleton].totalPriceInCart > 0){
            lblTotal.text = [NSString stringWithFormat:@"%@ %.02f",[[Singleton sharedSingleton] ISNSSTRINGNULL:[Singleton sharedSingleton].strCurrencySign], [Singleton sharedSingleton].totalPriceInCart];
        }
    }
}
-(void)GoTobackFromNotification
{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)setupHorizontalScrollView
{
    tblCategory  = [[UITableView alloc] init ]; //]WithFrame:CGRectMake(00, 0, 60, 480)];
    tblCategory.backgroundColor = [UIColor blackColor];
    [tblCategory setBackgroundColor:[UIColor blackColor]];
    tblCategory.backgroundView = [[UIView alloc] init];
    [tblCategory.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
    tblCategory.transform = CGAffineTransformMakeRotation(M_PI/-2);//(1.5707963); //
    tblCategory.showsVerticalScrollIndicator = NO;
    tblCategory.showsHorizontalScrollIndicator = NO;
    tblCategory.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[UITableViewCell appearance] setBackgroundColor:[UIColor clearColor]];
    if(IS_IPHONE_5)
    {
        //int h = 100;
       
        int highestNumber=0;
        for (int i=0; i<[[arrCategoryList objectAtIndex:0] count]; i++)
        {
           int theNumber = [[[[arrCategoryList objectAtIndex:0] objectAtIndex:i] objectForKey:@"HeightOfCategoryName"] intValue];
            if (theNumber  > highestNumber) {
                highestNumber = theNumber ;
                //numberIndex = [numberArray indexOfObject:theNumber];
            }
        }
        
        int h =highestNumber + 85;
        //190 is basic height of table
        //if h= 105 then y = 190
        
        int y=190;
        if(h <= 105)
        {
            //default y =190;
        }
        else
        {
            int d = h - 105;
            y = y + d;
        }
         tblCategory.frame = CGRectMake(0, y, 320, h); //y = 168 , 188
//         tblCategory.frame = CGRectMake(188, 0, 320, h);
    }
    else if(IS_IPAD)
    {
        int highestNumber=0;
        for (int i=0; i<[[arrCategoryList objectAtIndex:0] count]; i++)
        {
            int theNumber = [[[[arrCategoryList objectAtIndex:0] objectAtIndex:i] objectForKey:@"HeightOfCategoryName"] intValue];
            if (theNumber  > highestNumber) {
                highestNumber = theNumber ;
                //numberIndex = [numberArray indexOfObject:theNumber];
            }
        }
        
        int h =highestNumber + 130;
        tblCategory.frame = CGRectMake(0, 270, 768, h);
        
        //tblCategory.frame = CGRectMake(0, 250, 768, 155);
    }
    else
    {
        int highestNumber=0;
        for (int i=0; i<[[arrCategoryList objectAtIndex:0] count]; i++)
        {
            int theNumber = [[[[arrCategoryList objectAtIndex:0] objectAtIndex:i] objectForKey:@"HeightOfCategoryName"] intValue];
            if (theNumber  > highestNumber) {
                highestNumber = theNumber ;
                //numberIndex = [numberArray indexOfObject:theNumber];
            }
        }
        
        int h =highestNumber + 55;
        
        if(IS_IOS_6)
        {
            
             tblCategory.frame = CGRectMake(0, 175, 320, h);//h - 100//y=155
        }
        else
        {
             tblCategory.frame = CGRectMake(0, 185, 320, h); // y =165, h=100
        }
    }
        
   
//    tblCategory.rowHeight = 90.0;
    tblCategory.delegate = self;
    tblCategory.dataSource = self;
    [self.view addSubview:tblCategory];
    
    CGRect f = self.tblVW.frame;
    f.origin.y = tblCategory.frame.origin.y + tblCategory.frame.size.height + 4;
    self.tblVW.frame = f;
  
 }
-(void)getDynamicHeightofLabels
{
    NSLog(@"---- %d ----",  [arrCategoryList count]);
    
    if([arrCategoryList count] > 0)
    {
        for(int i=0; i<[[arrCategoryList objectAtIndex:0] count]; i++)
        {
            NSString *rName =[NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrCategoryList objectAtIndex:0]objectAtIndex:i] objectForKey:@"MasterName"]]];
            
            float h;
            CGSize aSize;
            if(IS_IPAD)
                aSize = CGSizeMake(CATEGORY_WIDTH_IPAD, 20000);
            else
                aSize = CGSizeMake(CATEGORY_WIDTH_IPHONE, 20000);
            
            UIFont *font;
            if(IS_IPAD)
                font = FONT_CATEGORY_IPAD;
            else
                font = FONT_CATEGORY_IPHONE;
            
            h = ceilf([[Singleton sharedSingleton] heightOfTextForLabel:rName andFont:font maxSize:aSize].height);
            NSMutableArray *tempArr = [[arrCategoryList objectAtIndex:0] objectAtIndex:i];
            [tempArr setValue:[NSString stringWithFormat:@"%f", h] forKey:@"HeightOfCategoryName"];
            [[arrCategoryList objectAtIndex:0] replaceObjectAtIndex:i withObject:tempArr];
        }
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
- (IBAction)btnOrderListClicked:(id)sender
{
    OrderDetailViewController *OrderDetail;
    if (IS_IPHONE_5)
    {
        OrderDetail=[[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        OrderDetail=[[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController_iPad" bundle:nil];
    }
    else
    {
        OrderDetail=[[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
    }
    OrderDetail._fromWhere=@"FromHomeDelivery";
    [self.navigationController pushViewController:OrderDetail animated:YES];
}

- (IBAction)btnLoyaltyPointsClicked:(id)sender
{
    MyrewardView *addOrder;
    if (IS_IPHONE_5)
    {
        addOrder=[[MyrewardView alloc] initWithNibName:@"MyrewardView-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        addOrder=[[MyrewardView alloc] initWithNibName:@"MyrewardView_iPad" bundle:nil];
    }
    else
    {
        addOrder=[[MyrewardView alloc] initWithNibName:@"MyrewardView" bundle:nil];
    }
    addOrder.fromWhere=@"HomeDelivery";
    addOrder.RestaurantId = [[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"UserId"];
    [self.navigationController pushViewController:addOrder animated:YES];
}
- (IBAction)btnBackClick:(id)sender
{
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    if([st objectForKey:@"OrderType"])
    {
        if(![[st objectForKey:@"OrderType"] isEqualToString:@"AT Restaurant"])
        {
            if([st objectForKey:@"IS_ORDER_START"])
            {
                NSString *IS_STARTED = [st objectForKey:@"IS_ORDER_START"];
                if([IS_STARTED isEqualToString:@"YES"])
                {
                    [[Singleton sharedSingleton] checkPendingOrderInArray];
                }
                else
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else
            {
                 [self.navigationController popViewControllerAnimated:YES];
            }
         }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
//    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
//    
//    if([st objectForKey:@"IS_ORDER_START"])
//    {
//        NSString *IS_STARTED = [st objectForKey:@"IS_ORDER_START"];
//        if([IS_STARTED isEqualToString:@"YES"])
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to cancel this order?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//            alert.tag = 18;
//            [alert show];
//        }
//    }
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(alertView.tag == 18)
//    {
//        if(buttonIndex == 1)
//        {
//            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
//            [st setObject:@"NO" forKey:@"IS_ORDER_START"];
//            [st synchronize];
//            
//            IS_Order_StartDelete  = NO;
//            [[Singleton sharedSingleton] callOrderStartService:self.class OrderStatus:IS_Order_StartDelete];
//            
//             [self.navigationController popViewControllerAnimated:YES];
//        }
//        else
//        {
//            
//        }
//    }
//}
-(void)categoryClicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    selectedRow = btn.tag-1;
    [tblCategory reloadData];
  
    
    // reload table as per category selected
    [self getItemListOfSelectedCategory:(int)btn.tag];
}
-(void)getItemListOfSelectedCategory:(int)selectedCategoryId
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
    }
    else
    {
        [self startActivity];
        
      //  RestaurantId,CategoryId
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        NSString * userId ;
        if([st objectForKey:@"UserId"])
        {
            userId =  [st objectForKey:@"UserId"];
        }
        NSString * restaurantId = [[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"UserId"];
        NSString *categoryId = [[[arrCategoryList objectAtIndex:0]objectAtIndex:selectedCategoryId-1] objectForKey:@"MasterId"];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:restaurantId forKey:@"RestaurantId"];
        [dict setValue:categoryId  forKey:@"CategoryId"];
        [dict setValue:userId  forKey:@"CustomerId"];
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Item List : %@ -- ", dict);
             if (dict)
             {
                 [self stopActivity];
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
//                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                     [alt show];
//                     arrItemList = [[NSMutableArray alloc] init];
                     
                     [arrItemList removeAllObjects];
                     self.tblVW.hidden = NO;
                     [self.tblVW reloadData];
                     
                 }
                 else
                 {
//                     data =     (
//                                 {
//                                     AvailableIndicator = 1;
//                                     CategoryId = 46;
//                                     CategoryName = "<null>";
//                                     CategoryStatus = "<null>";
//                                     CategoryType = "<null>";
//                                     Code = 0;
//                                     Currency = 18;
//                                     CurrencySign = "<null>";
//                                     FileId = "00000000-0000-0000-0000-000000000000";
//                                     Ingredients = "pasta ";
//                                     ItemId = "5577e00a-dc34-4e54-9d99-95801772bb56";
//                                     ItemName = "Italian Pasta";
//                                     MasterId = 0;
//                                     MasterName = "<null>";
//                                     MasterType = "<null>";
//                                     Message = "<null>";
//                                     MimeType = "<null>";
//                                     NewName = "<null>";
//                                     OriginalName = "<null>";
//                                     Photo = "<null>";
//                                     Price = 99;
//                                     ProductDescription = "chess pasta";
//                                     RestaurantId = "ef592442-2dd3-49c7-a550-d27189beeee8";
//                                     Status = "<null>";
//                                     UploadDate = "<null>";
//                                     UploadPath = "<null>";
//                                     UserId = "<null>";
//                                 }
                     @try {
                         NSArray *arr = [NSArray arrayWithObject:[dict objectForKey:@"data"]];
                         arrItemList = [[NSMutableArray alloc] initWithArray:arr];
                         
                         [[Singleton sharedSingleton] setarrItemListOfSelectedCategory:[dict objectForKey:@"data"]];
                         
                         if([arrItemList count] > 0)
                         {
                             [self getDynamicHeightofLabels_Items];
                             self.tblVW.hidden = NO;
                             [self.tblVW reloadData];
                             NSLog(@"done");
                         }
                     }
                     @catch (NSException *exception)
                     {
                         if([arrItemList count] > 0)
                         {
                             [self getDynamicHeightofLabels_Items];
                             self.tblVW.hidden = NO;
                             [self.tblVW reloadData];
                             NSLog(@"done");
                         }
                     }
                     
                 }
             }
             else
             {
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
                 [self stopActivity];
             }
         } :@"Restaurant/GetRestaurantItems" data:dict];
    }
}
-(void)getDynamicHeightofLabels_Items
{
    NSLog(@"---- %lu ----",  (unsigned long)[arrItemList count]);
    
    if([arrItemList count] > 0)
    {
        for(int i=0; i<[[arrItemList objectAtIndex:0] count]; i++)
        {
            NSString *rName =[NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrItemList objectAtIndex:0]objectAtIndex:i] objectForKey:@"ItemName"]]];
            
            float h;
            CGSize aSize;
            if(IS_IPAD)
                aSize = CGSizeMake(ITEM_WIDTH_IPAD, 20000);
            else
                aSize = CGSizeMake(ITEM_WIDTH_IPHONE, 20000);
            
            UIFont *font;
            if(IS_IPAD)
                font = FONT_ITEM_IPAD;
            else
                font = FONT_ITEM_IPHONE;
            
            h = ceilf([[Singleton sharedSingleton] heightOfTextForLabel:rName andFont:font maxSize:aSize].height);
            NSMutableArray *tempArr = [[arrItemList objectAtIndex:0] objectAtIndex:i];
            [tempArr setValue:[NSString stringWithFormat:@"%f", h] forKey:@"HeightOfItemName"];
            [[arrItemList objectAtIndex:0] replaceObjectAtIndex:i withObject:tempArr];
        }
    }
}
-(IBAction)SeachClicked:(id)sender
{
    
}
#pragma mark TextField Delegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField== self.txtSearch)
    {
        [self.txtSearch resignFirstResponder];
    }
    return YES;
}
#pragma mark TableView Delegate Method
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(IS_IOS_8)
    {
    if ([self.tblVW respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tblVW setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tblVW respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tblVW setLayoutMargins:UIEdgeInsetsZero];
    }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.tblVW)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tblVW)
    {
         if([arrItemList count] > 0)
        {
            if([[arrItemList objectAtIndex:0] count] > 0)
            {
                return [[arrItemList objectAtIndex:0] count];
            }
            else
            {
                return 1;
            }
        }
        else
        {
            return 1;
        }
        return [arrItemList count];
    }
    else if(tableView == tblCategory)
    {
        if([arrCategoryList count] > 0)
        {
            if([[arrCategoryList objectAtIndex:0] count] > 0)
            {
                return [[arrCategoryList objectAtIndex:0]  count];
            }
            else
            {
                return 1;
            }
        }
        return 1;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tblVW)
    {
       if(IS_IPAD)
       {
            return 55;
       }
        else
        {
            int h = [[[[arrItemList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfItemName"] intValue] + 10;
            
            return MAX(50,h);
            
//            return 50;
        }
    }
    else if(tableView == tblCategory)
    {
        if(IS_IPAD) 
            return 180;
        else
        {
//            NSLog(@"category  h : %f", ([[[[arrCategoryList objectAtIndex:0]objectAtIndex:indexPath.row] objectForKey:@"HeightOfCategoryName"] floatValue] /18) * 110);
            //  ([[[[arrCategoryList objectAtIndex:0]objectAtIndex:indexPath.row] objectForKey:@"HeightOfCategoryName"] floatValue] /18) * 110;
            return  [[[[arrCategoryList objectAtIndex:0]objectAtIndex:indexPath.row] objectForKey:@"HeightOfCategoryName"] floatValue]  + 85  ; // 85; //110;
        }
    }
    return 40;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tblVW)
    {
        
    }
    else if(tableView == tblCategory)
    {
  
        CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
        cell.transform = transform;

//        CGAffineTransform transform = CGAffineTransformMakeRotation(1.5707963);
//        cell.transform = transform;
        
        // horizontal table
        // -90 degrees rotation will move top of your tableview to the left
//        tblCategory.transform = CGAffineTransformMakeRotation(-M_PI_2);
        //Just so your table is not at a random place in your view
//        tblCategory.frame = CGRectMake(0,0, tblCategory.frame.size.width, tblCategory.frame.size.height);
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(tableView == self.tblVW)
    {
        static NSString *simpleTableIdentifier;
        if (IS_IPAD)
        {
            simpleTableIdentifier= @"HomeDelivery_iPad";
        }
        else
        {
            simpleTableIdentifier= @"HomeDelivery";
        }
        
        HomeDelivery *cell = (HomeDelivery *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
            if(IS_IPAD)
            {
                cell.textLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:20] ;//[UIFont systemFontOfSize:20];
            }
            else
            {
                cell.textLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:14]; //[UIFont systemFontOfSize:14];
            }
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        @try {
            if([arrItemList count] > 0)
            {
                if([[arrItemList objectAtIndex:0] count] > 0)
                {
                    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                    [self.tblVW setUserInteractionEnabled:YES];
                    cell.textLabel.hidden = YES;
                    cell.lblAmnt.hidden = NO;
                    cell.lblName.hidden = NO;
                    cell.btnItemIcon.hidden = NO;
                    cell.imgArrow.hidden = YES;
                    cell.lblName.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrItemList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"ItemName"]]];
                    
                    // [cell.lblName sizeToFit];
                    
                    CGRect f = cell.lblName.frame;
                    int h = [[[[arrItemList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfItemName"] intValue] ;
                    f.size.height = MAX(40,h);
                    cell.lblName.frame = f;
                    NSLog(@"cell.lblName.frame : %f", cell.lblName.frame.size.width);
                    
                    //CHANGE
                    
                    // CurrencySign =  "$"
                    
                    NSString *sign;
                    //                if([[[[arrItemList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"CurrencySigns"] count] > 0)
                    //                {
                    //                    sign = [[[[arrItemList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"CurrencySigns"] objectAtIndex:0];
                    //                }
                    //                else
                    //                {
                    //                    sign = @"";
                    //                }
                    
                    @try {
                        sign = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrItemList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"CurrencySign"]];
                    }
                    @catch (NSException *exception) {
                        sign=@"";
                    }
                    
                    cell.lblAmnt.text = [NSString stringWithFormat:@"%@%@", sign, [[[arrItemList objectAtIndex:0]objectAtIndex:indexPath.row] objectForKey:@"Price"]];
                    
                    [cell.btnItemIcon setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
                    cell.btnItemIcon.tag = indexPath.row+1;
                    
                    
                    //                NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, [[[arrItemList objectAtIndex:0]objectAtIndex:indexPath.row] objectForKey:@"Photo"]];
                    //                UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
                    //                if(img == nil)
                    //                {
                    //                    [cell.btnItemIcon setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
                    //                }
                    //                else{
                    //                    [cell.btnItemIcon setBackgroundImage:img forState:UIControlStateNormal];
                    //                }
                    
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
                    dispatch_async(queue, ^{
                        NSData *imageData;
                        UIImage *image;
                        NSString *imgStr = [[[arrItemList objectAtIndex:0]objectAtIndex:indexPath.row] objectForKey:@"Photo"];
                        
                        if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:imgStr] isEqualToString:@""])
                        {
                            NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, imgStr];
                            
                            image =  [[Singleton sharedSingleton] getImageFromCache:[imageName lastPathComponent]];
                            
                            if(image != nil)
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [cell.btnItemIcon setBackgroundImage:image  forState:UIControlStateNormal];
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
                                
                                @try {
                                    [[Singleton sharedSingleton] saveImageInCache:image ImgName: imgStr];
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        if(image == nil)
                                        {
                                            [cell.btnItemIcon setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
                                        }
                                        else{
                                            
                                            [cell.btnItemIcon setBackgroundImage:image forState:UIControlStateNormal];
                                        }
                                    });
                                    
                                }
                                @catch (NSException *exception) {
                                    [cell.btnItemIcon setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
                                    NSLog(@"ERR : %@", [exception description]);
                                }
                            }
                        }
                    });
                }
                else
                {
                    [self.tblVW setUserInteractionEnabled:NO];
                    cell.textLabel.hidden = NO;
                    cell.textLabel.text = [NSString stringWithFormat:@"No Item Found."];
                    cell.lblAmnt.hidden = YES;
                    cell.lblName.hidden = YES;
                    cell.btnItemIcon.hidden = YES;
                    cell.imgArrow.hidden = YES;
                    cell.btnItemIcon.hidden = YES;
                    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                }
            }
            else
            {
                [self.tblVW setUserInteractionEnabled:NO];
                cell.textLabel.hidden = NO;
                cell.textLabel.text = [NSString stringWithFormat:@"No Item Found."];
                cell.lblAmnt.hidden = YES;
                cell.lblName.hidden = YES;
                cell.btnItemIcon.hidden = YES;
                cell.imgArrow.hidden = YES;
                cell.btnItemIcon.hidden = YES;
                tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
        }
        @catch (NSException *exception) {
            [self.tblVW setUserInteractionEnabled:NO];
            cell.textLabel.hidden = NO;
            cell.textLabel.text = [NSString stringWithFormat:@"No Item Found."];
            cell.lblAmnt.hidden = YES;
            cell.lblName.hidden = YES;
            cell.btnItemIcon.hidden = YES;
            cell.imgArrow.hidden = YES;
            cell.btnItemIcon.hidden = YES;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
       
        return cell;
    }
    else if(tableView == tblCategory)
    {
        static NSString *simpleTableIdentifier;
        if (IS_IPAD)
        {
            simpleTableIdentifier= @"HomeCategory_iPad";
        }
        else
        {
            simpleTableIdentifier= @"HomeCategory";
        }
        
        HomeCategory *cell = (HomeCategory *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
       if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];           
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
        dispatch_async(queue, ^{
            NSData *imageData;
            UIImage *image;
         
            NSString *imgStr = [[[arrCategoryList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"Attribute1"];
           
            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:imgStr] isEqualToString:@""])
            {
                NSString *imageName = [NSString stringWithFormat:@"%@/%@", HOSTMEDIA, imgStr];
                image =  [[Singleton sharedSingleton] getImageFromCache:[imageName lastPathComponent]];
                
                if(image != nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [cell.btnCategoryIcon setBackgroundImage:image  forState:UIControlStateNormal];
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
                            [cell.btnCategoryIcon setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
                        }
                        else{
                            
                            [cell.btnCategoryIcon setBackgroundImage:image forState:UIControlStateNormal];
                        }
                    });
                }
            }
        });

        cell.lblcategoryname.text = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrCategoryList objectAtIndex:0]objectAtIndex:indexPath.row] objectForKey:@"MasterName"]]];
  
        CGRect f = cell.lblcategoryname.frame;
        f.size.height = [[[[arrCategoryList objectAtIndex:0]objectAtIndex:indexPath.row] objectForKey:@"HeightOfCategoryName"] floatValue];
        cell.lblcategoryname.frame = f;
        
        f = cell.imgArraow.frame;
        f.origin.y = cell.lblcategoryname.frame.origin.y + cell.lblcategoryname.frame.size.height + 1;
        cell.imgArraow.frame = f;
        
        cell.imgArraow.hidden = YES;
        if(selectedRow == indexPath.row)
        {
            cell.imgArraow.hidden = NO;
        }        
        cell.btnForClick.tag = indexPath.row+1;
        [cell.btnForClick addTarget:self action:@selector(categoryClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
  
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tblVW)
    {
        NSString *ii = [NSString stringWithFormat:@"%@",[[[arrItemList objectAtIndex:0]objectAtIndex:indexPath.row] objectForKey:@"ItemId"]];
        NSArray *valArray = [[[Singleton sharedSingleton] getarrOrderOfCurrentUser] valueForKey:@"ItemId"];
        if([valArray count] > 0)
        {
            NSUInteger index = [valArray indexOfObject:ii];
            if(index == NSNotFound) {
                NSLog(@"not found - so added");
                
                addOrderViewController *addOrder;
                if (IS_IPHONE_5)
                {
                    addOrder=[[addOrderViewController alloc] initWithNibName:@"addOrderViewController-5" bundle:nil];
                }
                else if (IS_IPAD)
                {
                    addOrder=[[addOrderViewController alloc] initWithNibName:@"addOrderViewController_iPad" bundle:nil];
                }
                else
                {
                    addOrder=[[addOrderViewController alloc] initWithNibName:@"addOrderViewController" bundle:nil];
                }
                //addOrder.itemIndexId = indexPath.row;
                [[Singleton sharedSingleton] setitemIndexId:indexPath.row];
                
                addOrder.itemIndexId = [[Singleton sharedSingleton] getitemIndexId];
                
                [self.navigationController pushViewController:addOrder animated:YES];
                
                
            }
            else
            {
                NSLog(@" found ");
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Edit an Quantity" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alert.tag = 87;
                [alert show];
                
            }
        }
        else
        {
            addOrderViewController *addOrder;
            if (IS_IPHONE_5)
            {
                addOrder=[[addOrderViewController alloc] initWithNibName:@"addOrderViewController-5" bundle:nil];
            }
            else if (IS_IPAD)
            {
                addOrder=[[addOrderViewController alloc] initWithNibName:@"addOrderViewController_iPad" bundle:nil];
            }
            else
            {
                addOrder=[[addOrderViewController alloc] initWithNibName:@"addOrderViewController" bundle:nil];
            }
            //addOrder.itemIndexId = indexPath.row;
            [[Singleton sharedSingleton] setitemIndexId:indexPath.row];
            
            addOrder.itemIndexId = [[Singleton sharedSingleton] getitemIndexId];
            
            [self.navigationController pushViewController:addOrder animated:YES];
        }
    }
  
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     if(alertView.tag == 87)
    {
        OrderDetailViewController *OrderDetail;
        if (IS_IPHONE_5)
        {
            OrderDetail=[[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            OrderDetail=[[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController_iPad" bundle:nil];
        }
        else
        {
            OrderDetail=[[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
        }
        OrderDetail._fromWhere=@"FromHomeDelivery";
        [self.navigationController pushViewController:OrderDetail animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{

}

@end
