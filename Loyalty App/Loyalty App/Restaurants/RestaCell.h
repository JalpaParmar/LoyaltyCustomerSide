//
//  RestaCell.h
//  Loyalty App
//
//  Created by Amit Parmar on 18/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaCell : UITableViewCell
{
    
    IBOutlet UIImageView *imgHotel;
    IBOutlet UIButton *btnStar;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblKM;
    IBOutlet UILabel *lblAmnt;
    IBOutlet UILabel *lblTime;
    IBOutlet UILabel *lblAddress;
    IBOutlet UIButton *btnRate, *btnTimeIcon;

}
@property(strong,nonatomic)IBOutlet UIImageView *imgHotel;
@property(strong,nonatomic)IBOutlet UILabel *lblName;
@property(strong,nonatomic)IBOutlet UILabel *lblKM;
@property(strong,nonatomic)IBOutlet UILabel *lblAmnt;
@property(strong,nonatomic)IBOutlet UILabel *lblTime;
@property(strong,nonatomic)IBOutlet UILabel *lblAddress;
@property(strong,nonatomic)IBOutlet UIButton *btnRate, *btnStar, *btnTimeIcon;

@end
