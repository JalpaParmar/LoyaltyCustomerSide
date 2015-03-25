//
//  OrderProcessViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 7/22/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface OrderProcessViewController : UIViewController
{
    AppDelegate *app;
    int indexId;
    NSMutableArray * arrName, *arrIcons;
}
@property (strong, nonatomic) IBOutlet UITableView *tblOrderProcess;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleOrderProcess;

//-(IBAction)homeDeliveryClicked:(id)sender;
//-(IBAction)takeAwayClicked:(id)sender;
//-(IBAction)atRestaurantClicked:(id)sender;
- (IBAction)btnBackClick:(id)sender;
@end
