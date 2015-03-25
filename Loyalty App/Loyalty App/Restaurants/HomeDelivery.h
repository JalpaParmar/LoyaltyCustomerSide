//
//  RestaCell.h
//  Loyalty App
//
//  Created by Amit Parmar on 18/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeDelivery : UITableViewCell
{
    
    IBOutlet UIImageView *imgArrow;
    IBOutlet UIButton *btnItemIcon;
//    IBOutlet UIImageView *imgHotel;
    IBOutlet UILabel *lblName;
//    IBOutlet UILabel *lblKM;
    IBOutlet UILabel *lblAmnt;
//    IBOutlet UILabel *lblTime;
//    IBOutlet UILabel *lblAddress;
//    IBOutlet UIButton *btnKm;
}
//@property(strong,nonatomic)IBOutlet UIImageView *imgHotel;
@property(strong,nonatomic)IBOutlet UILabel *lblName;
@property(strong,nonatomic)IBOutlet UIButton *btnItemIcon;
@property(strong,nonatomic)IBOutlet UIImageView *imgArrow;
//@property(strong,nonatomic)IBOutlet UILabel *lblKM;
@property(strong,nonatomic)IBOutlet UILabel *lblAmnt;
//@property(strong,nonatomic)IBOutlet UILabel *lblTime;
//@property(strong,nonatomic)IBOutlet UILabel *lblAddress;
//@property(strong,nonatomic)IBOutlet UIButton *btnKm;

@end
