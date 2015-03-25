//
//  programCell.h
//  Loyalty App
//
//  Created by Ntech Technologies on 8/13/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface programCell : UITableViewCell
{
    IBOutlet UILabel *lblRestaurantName;
    IBOutlet UILabel *lblOfferDetail;
    IBOutlet UIButton *btnRate;
    IBOutlet UIButton *btnJoin;
    IBOutlet UILabel *lblDistance;
    IBOutlet UILabel *lblJoinedDate;
    IBOutlet UIButton *btnMore;
}
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantName;
@property (strong, nonatomic) IBOutlet UILabel *lblOfferDetail;
@property (strong, nonatomic) IBOutlet UIButton *btnRate, *btnStart;
@property (strong, nonatomic) IBOutlet UIButton *btnJoin;
@property (strong, nonatomic) IBOutlet UILabel *lblDistance;
@property (strong, nonatomic) IBOutlet UILabel *lblJoinedDate;
- (IBAction)btnJoinClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnMore;
- (IBAction)btnMoreClicked:(id)sender;

@end
