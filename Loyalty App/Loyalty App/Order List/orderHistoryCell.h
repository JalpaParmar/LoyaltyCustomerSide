//
//  RewardCell.h
//  Loyalty App
//
//  Created by Amit Parmar on 19/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderHistoryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblOrderType, *lblOrderStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderDate, *lblOrderTime;
@property (strong, nonatomic) IBOutlet UILabel *lblStoreName;
@property (strong, nonatomic) IBOutlet UILabel *lblStoreAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderTOtal;
@property (strong, nonatomic) IBOutlet UIButton *btnReview, *btnReceipt, *btnTimeIcon, *btnTimeIcon1;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPerson;


@end
