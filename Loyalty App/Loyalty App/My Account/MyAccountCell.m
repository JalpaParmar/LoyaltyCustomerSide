//
//  MyAccountCell.m
//  Loyalty App
//
//  Created by Ntech Technologies on 8/12/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "MyAccountCell.h"
#import "Singleton.h"

@implementation MyAccountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.contentView andSubViews:YES];
   
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
