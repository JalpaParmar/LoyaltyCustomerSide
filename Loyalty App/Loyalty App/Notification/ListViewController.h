//
//  notificationViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ListViewController : UIViewController
{
    AppDelegate *app;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    NSMutableArray *arrNotification, *arrParentNotification;
}
@property (strong, nonatomic) IBOutlet UITableView *tblNotification;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleNotification;
@property (strong, nonatomic) IBOutlet UIButton *btnNotification, *btnChat;

- (IBAction)btnBackClick:(id)sender;
@end
