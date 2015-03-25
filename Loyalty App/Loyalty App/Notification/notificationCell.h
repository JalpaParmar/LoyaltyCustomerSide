//
//  settingCell.h
//  Loyalty App
//
//  Created by Ntech Technologies on 8/11/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface notificationCell : UITableViewCell
{
    IBOutlet UILabel *lblUserName;
     IBOutlet UILabel *lblNotification;
    IBOutlet UIView *viewSeparator;
     IBOutlet UILabel *lblTime;
}
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblNotification;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UIView *viewSeparator;


@end
