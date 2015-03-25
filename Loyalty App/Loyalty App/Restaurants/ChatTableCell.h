//
//  SMMessageViewTableCell.h
//  JabberClient
//
//  Created by cesarerocchi on 9/8/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChatTableCell : UITableViewCell {

IBOutlet 	UILabel	*senderAndTimeLabel;
IBOutlet 	UITextView *messageContentView;
IBOutlet	 UIImageView *bgImageView;
IBOutlet 	UIButton *btnProfilePic;
}

@property (nonatomic,strong) UILabel *senderAndTimeLabel;
@property (nonatomic,strong) UITextView *messageContentView;
@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIButton *btnProfilePic;

@end
