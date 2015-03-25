//
//  RewardCell.h
//  Loyalty App
//
//  Created by Amit Parmar on 19/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantName;
@property (strong, nonatomic) IBOutlet UILabel *lblSpecialOffer;
@property (strong, nonatomic) IBOutlet UIButton *btnOnlyUsed;
@property (strong, nonatomic) IBOutlet UIView *viewArrayOfBtnUsed;
@property (strong, nonatomic) IBOutlet UIView *viewArrayOfbtnRedeem;
@property (strong, nonatomic) IBOutlet UIButton *btnOnlyRedeem;


@end
