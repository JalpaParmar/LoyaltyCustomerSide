//
//  programCell.m
//  Loyalty App
//
//  Created by Ntech Technologies on 8/13/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "programCell.h"
#import "Singleton.h"

@implementation programCell
@synthesize  lblDistance, lblJoinedDate, lblOfferDetail, lblRestaurantName, btnJoin, btnMore, btnRate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.contentView andSubViews:YES];
        lblDistance.font = [UIFont fontWithName:@"OpenSans-Light" size:lblDistance.font.pointSize];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.btnJoin.selected = NO;
    self.btnRate.selected = NO;
    // Configure the view for the selected state
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.btnJoin.highlighted = NO;
    self.btnRate.highlighted = NO;
}
- (IBAction)btnJoinClicked:(id)sender {
}
- (IBAction)btnMoreClicked:(id)sender {
}
@end
