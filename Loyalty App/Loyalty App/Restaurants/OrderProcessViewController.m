//
//  OrderProcessViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/22/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "OrderProcessViewController.h"
#import "homeDeliveryViewController.h"
#import "AtRestaurantViewController.h"
#import "Singleton.h"
#import "MyAccountCell.h"
#import "addOrderViewController.h"
#import "RestaDetailView.h"

@interface OrderProcessViewController ()
@end

@implementation OrderProcessViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
int countForRow;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    app = APP;
    [self.view addSubview:[app setFooterPart]];
    app._flagMainBtn = 0; //2;
    
      [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
    
    indexId = [[Singleton sharedSingleton] getIndexId];
    countForRow=0;
    
    [self.tblOrderProcess setAllowsSelection:YES];
    self.tblOrderProcess.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tblOrderProcess setScrollEnabled:NO];
    [self.tblOrderProcess setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
 
    //    IsHomeDelivery = 0;
    //    IsReservationAcceptance = 0;
    //    IsTakeAway = 0;
    //    IsTherePlaceForChildren = 0;
    //    IsTherePlaceForSmoker = 0;
    
 /*    if([[[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"IsHomeDelivery"] intValue] == 0 && [[[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"IsTakeAway"] intValue] == 0)
     {
        //2 button - take away and at restaurant
        countForRow = 1;
         arrName= [[NSMutableArray alloc] initWithObjects:@"AT Restaurant", nil];
         arrIcons = [[NSMutableArray alloc] initWithObjects:@"at-restaurant.png", nil];
     }
     else if([[[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"IsHomeDelivery"] intValue] == 0)
     {
         //2 button - take away and at restaurant
         countForRow = 2;
         arrName= [[NSMutableArray alloc] initWithObjects:@"Take Away", @"AT Restaurant",  nil];
         arrIcons = [[NSMutableArray alloc] initWithObjects:@"take-away.png", @"at-restaurant.png",  nil];
     }
    else if([[[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"IsTakeAway"] intValue] == 0)
    {
        //2 button - home delievery and at restaurant
        countForRow = 2;
        arrName= [[NSMutableArray alloc] initWithObjects:@"Home Delivery", @"AT Restaurant",  nil];
        arrIcons = [[NSMutableArray alloc] initWithObjects:@"home-dilevery.png", @"at-restaurant.png", nil];
    }
    else
    {
        // 3 buttons
        countForRow = 3;
        arrName= [[NSMutableArray alloc] initWithObjects:@"Home Delivery", @"Take Away", @"AT Restaurant", nil];
        arrIcons = [[NSMutableArray alloc] initWithObjects:@"home-dilevery.png", @"take-away.png", @"at-restaurant.png", nil];
    }
*/
    
    int homeD=0, takeA=0, atR=0;
    if([[[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"IsHomeDelivery"] intValue] == 0)
    {
        homeD=0;
    }
    else
    {
        homeD=1;
    }
    
    if([[[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"IsTakeAway"] intValue] == 0)
    {
        takeA=0;
    }
    else
    {
        takeA=1;
    }
    if([[[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"IsTherePlaceForChildren"] intValue] == 0)
    {
        atR=0;
    }
    else
    {
        atR=1;
    }
    
    if(homeD==1 && takeA==1 && atR==1)
    {
        //3 buttons
        // 3 buttons
        countForRow = 3;
        arrName= [[NSMutableArray alloc] initWithObjects:@"Home Delivery", @"Take Away", @"AT Restaurant", nil];
        arrIcons = [[NSMutableArray alloc] initWithObjects:@"home-dilevery.png", @"take-away.png", @"at-restaurant.png", nil];
    }
    else if(homeD==0 && takeA==0 && atR==0)
    {
        //0 buttons
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"There is No Option Available for Ordering" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag=16;
        [alert show];
    }
    else if(homeD==0 && takeA==1 && atR==1)
    {
        //2 buttons
        //2 button - take away and at restaurant
        countForRow = 2;
        arrName= [[NSMutableArray alloc] initWithObjects:@"Take Away", @"AT Restaurant",  nil];
        arrIcons = [[NSMutableArray alloc] initWithObjects:@"take-away.png", @"at-restaurant.png",  nil];
    }
    else if(homeD==1 && takeA==0 && atR==1)
    {
        //2 buttons
        //2 button - home delievery and at restaurant
        countForRow = 2;
        arrName= [[NSMutableArray alloc] initWithObjects:@"Home Delivery", @"AT Restaurant",  nil];
        arrIcons = [[NSMutableArray alloc] initWithObjects:@"home-dilevery.png", @"at-restaurant.png", nil];
    }
    else if(homeD==1 && takeA==1 && atR==0)
    {
        //2 buttons
        //2 button - take away and at restaurant
        countForRow = 2;
        arrName= [[NSMutableArray alloc] initWithObjects:@"Home Delivery", @"Take Away",  nil];
        arrIcons = [[NSMutableArray alloc] initWithObjects:@"home-dilevery.png", @"take-away.png",  nil];
    }
    else if(homeD==1 && takeA==0 && atR==0)
    {
        //1 button -home de
        countForRow = 1;
        arrName= [[NSMutableArray alloc] initWithObjects:@"Home Delivery", nil];
        arrIcons = [[NSMutableArray alloc] initWithObjects:@"home-dilevery.png", nil];
    }
    else if(homeD==0 && takeA==1 && atR==0)
    {
        //1 button -
        countForRow = 1;
        arrName= [[NSMutableArray alloc] initWithObjects:@"Take Away", nil];
        arrIcons = [[NSMutableArray alloc] initWithObjects:@"take-away.png", nil];
    }
    else if(homeD==0 && takeA==0 && atR==1)
    {
        //2 button - take away and at restaurant
        countForRow = 1;
        arrName= [[NSMutableArray alloc] initWithObjects:@"AT Restaurant", nil];
        arrIcons = [[NSMutableArray alloc] initWithObjects:@"at-restaurant.png", nil];
    }
    
    
    //Remove at later stage
//    countForRow = 3;
//    arrName= [[NSMutableArray alloc] initWithObjects:@"Home Delivery", @"Take Away", @"AT Restaurant", nil];
//    arrIcons = [[NSMutableArray alloc] initWithObjects:@"home-dilevery.png", @"take-away.png", @"at-restaurant.png", nil];

    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
//    [[Singleton sharedSingleton] checkPendingOrderInArray];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 16)
    {
        if(buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark TableView Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return countForRow;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD)
    {
        return 80;
    }
    else
    {
        return 65;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier  ;
    if (IS_IPAD)
    {
        simpleTableIdentifier=@"MyAccountCell_iPad";
    }
    else
    {
        simpleTableIdentifier=@"MyAccountCell";
    }
    MyAccountCell *cell = (MyAccountCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lblName.text = [NSString stringWithFormat:@"%@", [arrName  objectAtIndex:indexPath.row]];
    [cell.btnIcon setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [arrIcons  objectAtIndex:indexPath.row]]] forState:UIControlStateNormal];
    if([cell.lblName.text isEqualToString:OrderType_HomeDelivery])
    {
            cell.btnbackground.tag = 1;
    }
    else if([cell.lblName.text isEqualToString:OrderType_TakeAway])
    {
        cell.btnbackground.tag = 2;
        CGRect f = cell.btnIcon.frame;
        f.size.height = f.size.height + 5;
        cell.btnIcon.frame = f;
    }
    else if([cell.lblName.text isEqualToString:OrderType_ATRestaurant])
    {
        cell.btnbackground.tag = 3;
    }
    [cell.btnbackground addTarget:self action:@selector(buttonForOrderClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)buttonForOrderClicked:(id)sender
{
   if(app._skipRegister == 1)
   {
       [[Singleton sharedSingleton] errorLoginFirst];
   }
    else
    {
        UIButton *btn = (UIButton *)sender;
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        if(btn.tag == 1)
        {
            [st setValue:OrderType_HomeDelivery forKey:@"OrderType"];
            
            if([[[Singleton sharedSingleton] getarrRestaurantList] count] > 0)
            {
                if([[[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"restaurantCategory"] count] > 0)
                {
                    homeDeliveryViewController *view;
                    if (IS_IPHONE_5)
                    {
                        view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController-5" bundle:nil];
                    }
                    else if (IS_IPAD)
                    {
                        view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController_iPad" bundle:nil];
                    }
                    else
                    {
                        view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController" bundle:nil];
                    }
                    [self.navigationController pushViewController:view animated:YES];
                    
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Menu Not Available For Home Delivery" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            
            
        }
        else if(btn.tag == 2)
        {
            [st setValue:OrderType_TakeAway forKey:@"OrderType"];
            
            if([[[Singleton sharedSingleton] getarrRestaurantList] count] > 0)
            {
                if([[[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"restaurantCategory"] count] > 0)
                {
                    homeDeliveryViewController *view;
                    if (IS_IPHONE_5)
                    {
                        view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController-5" bundle:nil];
                    }
                    else if (IS_IPAD)
                    {
                        view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController_iPad" bundle:nil];
                    }
                    else
                    {
                        view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController" bundle:nil];
                    }
                    [self.navigationController pushViewController:view animated:YES];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Menu Not Available For Take Away" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
        }
        else if(btn.tag == 3)
        {
            [st setValue:OrderType_ATRestaurant forKey:@"OrderType"];
            AtRestaurantViewController *atRest;
            if (IS_IPHONE_5)
            {
                atRest=[[AtRestaurantViewController alloc] initWithNibName:@"AtRestaurantViewController-5" bundle:nil];
            }
            else if (IS_IPAD)
            {
                atRest=[[AtRestaurantViewController alloc] initWithNibName:@"AtRestaurantViewController_iPad" bundle:nil];
            }
            else
            {
                atRest=[[AtRestaurantViewController alloc] initWithNibName:@"AtRestaurantViewController" bundle:nil];
            }
            [self.navigationController pushViewController:atRest animated:YES];
            
        }
        [st synchronize];
    }
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    MyAccountCell *cell = (MyAccountCell*)[tableView cellForRowAtIndexPath:indexPath];
//    if(cell.btnbackground.tag == 1)
//    {
//        homeDeliveryViewController *view;
//        if (IS_IPHONE_5)
//        {
//            view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController-5" bundle:nil];
//        }
//        else
//        {
//            view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController" bundle:nil];
//        }
//        [self.navigationController pushViewController:view animated:YES];
//        
//
//    }
//    else if(cell.btnbackground.tag == 2)
//    {
//        homeDeliveryViewController *view;
//        if (IS_IPHONE_5)
//        {
//            view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController-5" bundle:nil];
//        }
//        else
//        {
//            view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController" bundle:nil];
//        }
//        [self.navigationController pushViewController:view animated:YES];
//        
//
//    }
//    else if(cell.btnbackground.tag == 3)
//    {
//        AtRestaurantViewController *atRest;
//        if (IS_IPHONE_5)
//        {
//            atRest=[[AtRestaurantViewController alloc] initWithNibName:@"AtRestaurantViewController-5" bundle:nil];
//        }
//        else
//        {
//            atRest=[[AtRestaurantViewController alloc] initWithNibName:@"AtRestaurantViewController" bundle:nil];
//        }
//        [self.navigationController pushViewController:atRest animated:YES];
//        
//
//    }
//
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

#pragma mark BUTTON CLICK EVENTS
- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
//    RestaDetailView *detail;
//    if (IS_IPHONE_5)
//    {
//        detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView-5" bundle:nil];
//    }
//    else
//    {
//        detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView" bundle:nil];
//    }
//    detail._fromWhere = @"OrderProcess";
//    [self.navigationController pushViewController:detail animated:YES];    
}
//-(IBAction)homeDeliveryClicked:(id)sender
//{
//    homeDeliveryViewController *view;
//    if (IS_IPHONE_5)
//    {
//        view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController-5" bundle:nil];
//    }
//    else
//    {
//        view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController" bundle:nil];
//    }
//    [self.navigationController pushViewController:view animated:YES];
//    
//
//}
//-(IBAction)takeAwayClicked:(id)sender
//{
//    homeDeliveryViewController *view;
//    if (IS_IPHONE_5)
//    {
//        view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController-5" bundle:nil];
//    }
//    else
//    {
//        view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController" bundle:nil];
//    }
//    [self.navigationController pushViewController:view animated:YES];
//    
//
//}
//-(IBAction)atRestaurantClicked:(id)sender
//{
//    AtRestaurantViewController *atRest;
//    if (IS_IPHONE_5)
//    {
//        atRest=[[AtRestaurantViewController alloc] initWithNibName:@"AtRestaurantViewController-5" bundle:nil];
//    }
//    else
//    {
//        atRest=[[AtRestaurantViewController alloc] initWithNibName:@"AtRestaurantViewController" bundle:nil];
//    }
//    [self.navigationController pushViewController:atRest animated:YES];
//    
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
