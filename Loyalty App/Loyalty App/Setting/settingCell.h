//
//  settingCell.h
//  Loyalty App
//
//  Created by Ntech Technologies on 8/11/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingCell : UITableViewCell
{
    
    IBOutlet UIButton *btnSwitch;
    IBOutlet UISwitch *switchOnOff;
    IBOutlet UILabel *lblSettingName;
}
@property (nonatomic, strong) IBOutlet UISwitch *switchOnOff;
@property (nonatomic, strong) IBOutlet UILabel *lblSettingName;
@property (nonatomic, strong) IBOutlet UIButton *btnSwitch;


@end
