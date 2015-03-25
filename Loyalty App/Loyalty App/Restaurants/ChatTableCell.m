//
//  SMMessageViewTableCell.m
//  JabberClient
//
//  Created by cesarerocchi on 9/8/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import "ChatTableCell.h"
#import "Singleton.h"


@implementation ChatTableCell

@synthesize senderAndTimeLabel, messageContentView, bgImageView, btnProfilePic;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.contentView andSubViews:YES];
      
		
        btnProfilePic = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnProfilePic setBackgroundImage:[UIImage imageNamed:@"defaultImage"] forState:UIControlStateNormal];
        [self.contentView addSubview:btnProfilePic];
        
        
		bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:bgImageView];
		
        messageContentView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];

		messageContentView.backgroundColor = [UIColor clearColor];
        if(IS_IPAD)
        {
            messageContentView.font =  [UIFont fontWithName:@"OpenSans-Light" size:17]; //[UIFont systemFontOfSize:13];
        }
        else
        {
            messageContentView.font =  [UIFont fontWithName:@"OpenSans-Light" size:13]; //[UIFont systemFontOfSize:13];

        }
		messageContentView.editable = NO;
        messageContentView.textAlignment = NSTextAlignmentRight;
//		messageContentView.scrollEnabled = NO;
		[messageContentView sizeToFit];
		[self.contentView addSubview:messageContentView];
//        [self addSubview:messageContentView];
        
        senderAndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
        //		senderAndTimeLabel.textAlignment = NSTextAlignmentLeft;
		senderAndTimeLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:11]; //[UIFont systemFontOfSize:11.0];
		senderAndTimeLabel.textColor = [UIColor darkGrayColor];
        senderAndTimeLabel.numberOfLines = 2;
		[self.contentView addSubview:senderAndTimeLabel];
//        [self addSubview:senderAndTimeLabel];
    }
	
    return self;
	
}








@end
