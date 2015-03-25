//
//  MyrewardView.h
//  Loyalty App
//
//  Created by Amit Parmar on 19/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MyrewardView : UIViewController
{
    UITableView *tblReward;
    AppDelegate *app;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    NSString *fromWhere, *RestaurantId;
}
@property (nonatomic, strong) NSMutableArray *arrRewardList;
@property (strong, nonatomic) IBOutlet UITableView *tblReward;
@property (strong, nonatomic) IBOutlet UILabel *lblPoints;
@property (strong, nonatomic) IBOutlet UIButton *btnBgPoints;
@property (strong, nonatomic) IBOutlet UILabel *lblFullname;
@property (strong, nonatomic) IBOutlet UIView *viewSeparator;
@property (strong, nonatomic)  NSString *fromWhere, *RestaurantId;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleRewardList;


- (IBAction)btnBackClick:(id)sender;
@end
