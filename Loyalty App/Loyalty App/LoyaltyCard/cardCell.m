//
//  cardCell.m
//  Loyalty App
//
//  Created by Amit Parmar on 19/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "cardCell.h"
#import "Singleton.h"
@implementation cardCell
@synthesize lblBarcodeName, btnbarcodeImg, btnBGMain, imgbarcodeImg, btnEdit;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        NSArray *arrayOfViews;
        
        if(IS_IPAD)
        {
            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"cardCell_iPad" owner:self options:nil];
        }
        else
        {
            arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"cardCell" owner:self options:nil];
        }
        
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
        [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.contentView andSubViews:YES];
        

        
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
