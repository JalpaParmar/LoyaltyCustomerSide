//
//  BarButton.m
//  Loyalty App
//
//  Created by Amit Parmar on 17/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "BarButton.h"
#import "DashboardView.h"
#import "AppDelegate.h"
#import "MyLoyaltyCardView.h"
#import "mapViewController.h"
#import "orderListViewController.h"
#import "Singleton.h"
#import "NewProgramViewController.h"
#import "OrderDetailViewController.h"
#import "addOrderViewController.h"

@implementation BarButton
@synthesize btnHome,btnNearBy,btnMyLoyality,btnOrder;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        app = APP;
        [self baseInit];
        // Initialization code
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}
-(void)baseInit
{
    btnHome=nil;
    btnMyLoyality=nil;
    btnNearBy=nil;
    btnOrder=nil;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"footer-bg.png"]];
    self.backgroundColor = [UIColor whiteColor];
    
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
    
    //IPAD CHANGE
    if (IS_IPAD)
    {
        btnNearBy=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 192, 110)];
        [btnNearBy setBackgroundImage:[UIImage imageNamed:@"near_by_iPad.png"] forState:UIControlStateNormal];
        [btnNearBy setBackgroundImage:[UIImage imageNamed:@"near_by_active_iPad.png"] forState:UIControlStateHighlighted];
        [btnNearBy setBackgroundImage:[UIImage imageNamed:@"near_by_active_iPad.png"] forState:UIControlStateSelected];
    }
    else
    {
        btnNearBy=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 55)];
        [btnNearBy setBackgroundImage:[UIImage imageNamed:@"near_by.png"] forState:UIControlStateNormal];
        [btnNearBy setBackgroundImage:[UIImage imageNamed:@"near_by_active.png"] forState:UIControlStateHighlighted];
        [btnNearBy setBackgroundImage:[UIImage imageNamed:@"near_by_active.png"] forState:UIControlStateSelected];
        
    }
    
 
    [btnNearBy addTarget:self action:@selector(nearMeClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnNearBy];
    if(app._flagMainBtn == 1)
    {
        
        [btnNearBy setBackgroundImage:[UIImage imageNamed:@"near_by_active.png"] forState:UIControlStateNormal];
        
        if(IS_IPAD)
            [btnNearBy setBackgroundImage:[UIImage imageNamed:@"near_by_active_iPad.png"] forState:UIControlStateNormal];
        else
            [btnNearBy setBackgroundImage:[UIImage imageNamed:@"near_by_active.png"] forState:UIControlStateNormal];
    }

  
    
    
    UIImageView *imgLine=[[UIImageView alloc] initWithFrame:CGRectMake(80, 3, 2, 35)];
    imgLine.image=[UIImage imageNamed:@"footer-divider.png"];
    [self addSubview:imgLine];
    
    btnHome=[UIButton buttonWithType:UIButtonTypeCustom]; //  initWithFrame:CGRectMake(80, 0, 80, 55)];
    if (IS_IPAD)
    {
        btnHome.frame=CGRectMake(192, 0, 192, 110);
        [btnHome setBackgroundImage:[UIImage imageNamed:@"home_iPad.png"] forState:UIControlStateNormal];
        [btnHome setBackgroundImage:[UIImage imageNamed:@"home_active_iPad.png"] forState:UIControlStateHighlighted];
        [btnHome setBackgroundImage:[UIImage imageNamed:@"home_active_iPad.png"] forState:UIControlStateSelected];
    }
    else
    {
        btnHome.frame = CGRectMake(80, 0, 80, 55);
        [btnHome setBackgroundImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
        [btnHome setBackgroundImage:[UIImage imageNamed:@"home_active.png"] forState:UIControlStateHighlighted];
        [btnHome setBackgroundImage:[UIImage imageNamed:@"home_active.png"] forState:UIControlStateSelected];
    }
//    [btnHome setBackgroundImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
//    [btnHome setBackgroundImage:[UIImage imageNamed:@"home_active.png"] forState:UIControlStateHighlighted];
//    [btnHome setBackgroundImage:[UIImage imageNamed:@"home_active.png"] forState:UIControlStateSelected];
    [btnHome addTarget:self action:@selector(homeClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnHome];
    if(app._flagMainBtn == 2)
    {
         [btnHome setBackgroundImage:[UIImage imageNamed:@"home_active.png"] forState:UIControlStateNormal];
        if(IS_IPAD)
            [btnHome setBackgroundImage:[UIImage imageNamed:@"home_active_iPad.png"] forState:UIControlStateNormal];
        else
            [btnHome setBackgroundImage:[UIImage imageNamed:@"home_active.png"] forState:UIControlStateNormal];
    }
    
    UIImageView *imgLine1=[[UIImageView alloc] initWithFrame:CGRectMake(160, 3, 2, 35)];
    imgLine1.image=[UIImage imageNamed:@"footer-divider.png"];
    [self addSubview:imgLine1];
    
    if (IS_IPAD)
    {
        btnMyLoyality=[[UIButton alloc] initWithFrame:CGRectMake(384, 0, 192, 110)];
        [btnMyLoyality setBackgroundImage:[UIImage imageNamed:@"my-loyalty_iPad.png"] forState:UIControlStateNormal];
        [btnMyLoyality setBackgroundImage:[UIImage imageNamed:@"my-loyalty_active_iPad.png"] forState:UIControlStateSelected];
        [btnMyLoyality setBackgroundImage:[UIImage imageNamed:@"my-loyalty_active_iPad.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        btnMyLoyality=[[UIButton alloc] initWithFrame:CGRectMake(160, 0, 80, 55)];
        [btnMyLoyality setBackgroundImage:[UIImage imageNamed:@"my-loyalty.png"] forState:UIControlStateNormal];
        [btnMyLoyality setBackgroundImage:[UIImage imageNamed:@"my-loyalty_active.png"] forState:UIControlStateSelected];
        [btnMyLoyality setBackgroundImage:[UIImage imageNamed:@"my-loyalty_active.png"] forState:UIControlStateHighlighted];
    }

//    [btnMyLoyality setBackgroundImage:[UIImage imageNamed:@"my-loyalty.png"] forState:UIControlStateNormal];
//    [btnMyLoyality setBackgroundImage:[UIImage imageNamed:@"my-loyalty_active.png"] forState:UIControlStateSelected];
//    [btnMyLoyality setBackgroundImage:[UIImage imageNamed:@"my-loyalty_active.png"] forState:UIControlStateHighlighted];
    
    [btnMyLoyality addTarget:self action:@selector(loyaltyClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnMyLoyality];
    if(app._flagMainBtn == 3)
    {
        [btnMyLoyality setBackgroundImage:[UIImage imageNamed:@"my-loyalty_active.png"] forState:UIControlStateNormal];
        if (IS_IPAD)
            [btnMyLoyality setBackgroundImage:[UIImage imageNamed:@"my-loyalty_active_iPad.png"] forState:UIControlStateNormal];
        else
            [btnMyLoyality setBackgroundImage:[UIImage imageNamed:@"my-loyalty_active.png"] forState:UIControlStateNormal];
    }
    
    
    UIImageView *imgLine2=[[UIImageView alloc] initWithFrame:CGRectMake(240, 3, 2, 35)];
    imgLine2.image=[UIImage imageNamed:@"footer-divider.png"];
    [self addSubview:imgLine2];
    
    if (IS_IPAD)
    {
        btnOrder=[[UIButton alloc] initWithFrame:CGRectMake(576, 0, 192, 110)];
        [btnOrder setBackgroundImage:[UIImage imageNamed:@"order_list_iPad.png"] forState:UIControlStateNormal];
        [btnOrder setBackgroundImage:[UIImage imageNamed:@"order_list_active_iPad.png"] forState:UIControlStateHighlighted];
        [btnOrder setBackgroundImage:[UIImage imageNamed:@"order_list_active_iPad.png"] forState:UIControlStateSelected];
    }
    else
    {
        btnOrder=[[UIButton alloc] initWithFrame:CGRectMake(240, 0, 80, 55)];
        [btnOrder setBackgroundImage:[UIImage imageNamed:@"order_list.png"] forState:UIControlStateNormal];
        [btnOrder setBackgroundImage:[UIImage imageNamed:@"order_list_active.png"] forState:UIControlStateHighlighted];
        [btnOrder setBackgroundImage:[UIImage imageNamed:@"order_list_active.png"] forState:UIControlStateSelected];
        
    }
 
     [btnOrder addTarget:self action:@selector(oderListClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnOrder];
    if(app._flagMainBtn == 4)
    {
        [btnOrder setBackgroundImage:[UIImage imageNamed:@"order_list_active.png"] forState:UIControlStateNormal];
        if(IS_IPAD)
            [btnOrder setBackgroundImage:[UIImage imageNamed:@"order_list_active_iPad.png"] forState:UIControlStateNormal];
        else
            [btnOrder setBackgroundImage:[UIImage imageNamed:@"order_list_active.png"] forState:UIControlStateNormal];
    }
    
    
}
-(void)nearMeClicked
{
    app._flagMainBtn = 1;
//    [[Singleton sharedSingleton] checkPendingOrderInArray];
    [self checkPendingOrderInArray];
}
-(void)homeClicked
{
    app._flagMainBtn = 2;
    
//    [[Singleton sharedSingleton] checkPendingOrderInArray];
  
    [self checkPendingOrderInArray];
 
    
}
-(void)loyaltyClicked
{
    app._flagMainBtn = 3;
    
   // [[Singleton sharedSingleton] checkPendingOrderInArray];
    
    [self checkPendingOrderInArray];
    

}
-(void)oderListClicked
{
    app._flagMainBtn = 4;
     [self checkPendingOrderInArray];       
}

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
            switch (app._flagMainBtn) {
                case 3:
                    [self jumpToLoyaltyProgram];
                    break;
                case 4:
                    [self jumpToOrderList];
                    break;
                case 1:
                    [self jumpToNearBy];
                    break;
                case 2:
                    [self jumpToHome];
                    break;
                default:
                    break;
            }
        }
    }
    else
    {
        switch (app._flagMainBtn) {
            case 3:
                [self jumpToLoyaltyProgram];
                break;
            case 4:
                [self jumpToOrderList];
                break;
            case 1:
                [self jumpToNearBy];
                break;
            case 2:
                [self jumpToHome];
                break;
            default:
                break;
        }
    }


}
#pragma mark UIALERTVIEW CLICK EVENTS

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if(alertView.tag == 18)
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
            
            switch (app._flagMainBtn) {
                case 3:
                     [self jumpToLoyaltyProgram];
                    break;
                case 4:
                    [self jumpToOrderList];
                    break;
                case 1:
                    [self jumpToNearBy];
                    break;
                case 2:
                    [self jumpToHome];
                    break;
                default:
                    break;
            }
           
        }
        else
        {
            // clicked Cancel
        }
    }
    
}
-(void)jumpToLoyaltyProgram
{
    
    if(app._skipRegister == 1)
    {
        NewProgramViewController *cardView;
        if (IS_IPHONE_5)
        {
            cardView=[[NewProgramViewController alloc] initWithNibName:@"NewProgramViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            cardView=[[NewProgramViewController alloc] initWithNibName:@"NewProgramViewController_iPad" bundle:nil];
        }
        else
        {
            cardView=[[NewProgramViewController alloc] initWithNibName:@"NewProgramViewController" bundle:nil];
        }
        [app.navObj pushViewController:cardView animated:YES];
    }
    else
    {
        MyLoyaltyCardView *cardView;
        if (IS_IPHONE_5)
        {
            cardView=[[MyLoyaltyCardView alloc] initWithNibName:@"MyLoyaltyCardView-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            cardView=[[MyLoyaltyCardView alloc] initWithNibName:@"MyLoyaltyCardView_iPad" bundle:nil];
        }
        else
        {
            cardView=[[MyLoyaltyCardView alloc] initWithNibName:@"MyLoyaltyCardView" bundle:nil];
        }
        [app.navObj pushViewController:cardView animated:YES];
    }

}
-(void)jumpToOrderList
{
    if(app._skipRegister == 1)
    {
        [[Singleton sharedSingleton] errorLoginFirst];
    }
    else
    {
        orderListViewController *order ;
        if (IS_IPHONE_5)
        {
            order=[[orderListViewController alloc] initWithNibName:@"orderListViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            order=[[orderListViewController alloc] initWithNibName:@"orderListViewController_iPad" bundle:nil];
        }
        else
        {
            order=[[orderListViewController alloc] initWithNibName:@"orderListViewController" bundle:nil];
        }
        
        [app.navObj pushViewController:order animated:YES];
    }
}
-(void)jumpToHome
{
    DashboardView *dashboard;
    
    if (IS_IPHONE_5)
    {
        dashboard=[[DashboardView alloc] initWithNibName:@"DashboardView-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        dashboard=[[DashboardView alloc] initWithNibName:@"DashboardView_iPad" bundle:nil];
    }
    else
    {
        dashboard=[[DashboardView alloc] initWithNibName:@"DashboardView" bundle:nil];
    }
    [app.navObj pushViewController:dashboard animated:YES];
}
-(void)jumpToNearBy
{
    mapViewController *map ;
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
    [app.navObj pushViewController:map animated:YES];
}
@end
