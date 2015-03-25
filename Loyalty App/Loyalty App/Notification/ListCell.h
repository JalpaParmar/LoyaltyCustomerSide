//
//  MyAccountCell.h
//  Loyalty App
//
//  Created by Ntech Technologies on 8/12/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIButton *btnIcon, *btnArrow, *btnNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnbackground;

@end
