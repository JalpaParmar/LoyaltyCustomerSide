//
//  NewProgramViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 8/13/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CommonDelegateViewController.h"

@protocol CommonDelegateClass;
@interface NewProgramViewController : UIViewController <CommonDelegateClass>
{
    AppDelegate *app;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    NSMutableArray *arrProgramList, *arrBogoList;
   IBOutlet  UIButton *btnNearBySearch, *btnFilterBySearch;
}
@property (strong, nonatomic) IBOutlet UITableView *tblProgramList;
- (IBAction)btnbackClick:(id)sender;
- (IBAction)btnFilterByClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleMyCard;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleNewProgram;
@end
