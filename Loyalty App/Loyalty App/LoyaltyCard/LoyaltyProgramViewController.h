//
//  LoyaltyProgramViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 8/13/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LoyaltyProgramViewController : UIViewController
{
    AppDelegate *app;
    NSMutableArray *arrProgramList;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    NSString *ProgramId;
}
@property (strong, nonatomic) IBOutlet UILabel *lblTitleLoyaltyProgram;
@property (strong, nonatomic) IBOutlet UITableView *tblMyProgramList;
@property (strong, nonatomic) IBOutlet UILabel *lblTItleMyCard;
- (IBAction)btnbackClick:(id)sender;
@end
