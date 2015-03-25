//
//  BarButton.m
//  Loyalty App
//
//  Created by Amit Parmar on 17/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "loyaltyCardTopButton.h"
#import "DashboardView.h"
#import "AppDelegate.h"
#import "MyLoyaltyCardView.h"
#import "NewProgramViewController.h"
#import "LoyaltyProgramViewController.h"
#import "ICEInfoViewController.h"
#import "Singleton.h"

#define NORMALBGCOLOR [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]
#define SELECTEDBGCOLOR [UIColor colorWithRed:80.0/255.0 green:190.0/255.0 blue:15.0/255.0 alpha:1]

#define NORMALTEXTCOLOR [UIColor darkGrayColor]
#define SELECTEDTEXTCOLOR [UIColor whiteColor]


@implementation loyaltyCardTopButton
@synthesize  btnMyCard, btnICEInfo, btnNewProgram, btnLoyaltyProgram ;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        app = APP;
        [self baseInit];
        
        [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self andSubViews:YES];
   
        
        // Initialization code
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}
-(void)baseInit
{
    btnICEInfo=nil;
    btnLoyaltyProgram=nil;
    btnMyCard=nil;
    btnNewProgram=nil;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
   
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
    UIFont *f;
    int size;
    float h = 0;
    if (IS_IPHONE_5)
    {
        size= 13;
        h = 40;
        f = [UIFont fontWithName:@"OpenSans-Light" size:13];//[UIFont systemFontOfSize:13];
    }
    else if(IS_IPAD)
    {
        size =16;
        h = 60;
        f = [UIFont fontWithName:@"OpenSans-Light" size:16];//[UIFont systemFontOfSize:16];
    }
    else
    {
        size=11;
        f = [UIFont fontWithName:@"OpenSans-Light" size:11];//[UIFont systemFontOfSize:11];
        if(IS_IOS_6)
        {
            h = 30; //35
        }
        else
        {
            // old iphone-ipad but new ios -(NTech iPad)
            h = 30;
        }
    }
   
    
    if(IS_IPAD)
             btnMyCard =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 140, h)];
    else
            btnMyCard =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, h)];
   
    [btnMyCard setBackgroundColor:NORMALBGCOLOR];
    [btnMyCard setTitle:@"My Card" forState:UIControlStateNormal];
    [btnMyCard setTitleColor:NORMALTEXTCOLOR forState:UIControlStateNormal];
    btnMyCard.titleLabel.font = f;
    [btnMyCard addTarget:self action:@selector(MyCardClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnMyCard];
  if(app._flagMyLoyaltyTopButtons == 1)
    {
        [btnMyCard setBackgroundColor:SELECTEDBGCOLOR];
       [btnMyCard setTitleColor:SELECTEDTEXTCOLOR forState:UIControlStateNormal];
    }

    
    btnICEInfo=[UIButton buttonWithType:UIButtonTypeCustom];
    if(IS_IPAD)
        btnICEInfo.frame = CGRectMake(140, 0, 160, h);
    else
        btnICEInfo.frame = CGRectMake(55, 0, 50, h);
    
    [btnICEInfo setBackgroundColor:NORMALBGCOLOR];
    btnICEInfo.titleLabel.font = f;
    [btnICEInfo setTitle:@"ICE Info" forState:UIControlStateNormal];
    [btnICEInfo setTitleColor:NORMALTEXTCOLOR forState:UIControlStateNormal];
    [btnICEInfo addTarget:self action:@selector(ICEInfoClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnICEInfo];
    if(app._flagMyLoyaltyTopButtons == 2)
    {
        [btnICEInfo setBackgroundColor:SELECTEDBGCOLOR];
        [btnICEInfo setTitleColor:SELECTEDTEXTCOLOR forState:UIControlStateNormal];
    }

    btnNewProgram=[UIButton buttonWithType:UIButtonTypeCustom];
    if(IS_IPAD)
        btnNewProgram.frame = CGRectMake(300, 0, 210, h);
    else
        btnNewProgram.frame = CGRectMake(105, 0, 95, h);
    
    btnNewProgram.titleLabel.font = f;
    [btnNewProgram setBackgroundColor:NORMALBGCOLOR];
    [btnNewProgram setTitle:@"New Program" forState:UIControlStateNormal];
    [btnNewProgram setTitleColor:NORMALTEXTCOLOR forState:UIControlStateNormal];
    [btnNewProgram addTarget:self action:@selector(NewProgramClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnNewProgram];
    if(app._flagMyLoyaltyTopButtons == 3)
    {
        [btnNewProgram setBackgroundColor:SELECTEDBGCOLOR];
        [btnNewProgram setTitleColor:SELECTEDTEXTCOLOR forState:UIControlStateNormal];
     }

    btnLoyaltyProgram=[UIButton buttonWithType:UIButtonTypeCustom];
    if(IS_IPAD)
        btnLoyaltyProgram.frame = CGRectMake(510, 0, 260, h);
    else
        btnLoyaltyProgram.frame = CGRectMake(195, 0, 130, h);
    btnLoyaltyProgram.titleLabel.font = f;
    [btnLoyaltyProgram setBackgroundColor:NORMALBGCOLOR];
    [btnLoyaltyProgram setTitle:@"My LoyaltyProgram" forState:UIControlStateNormal];
    [btnLoyaltyProgram setTitleColor:NORMALTEXTCOLOR forState:UIControlStateNormal];
    [btnLoyaltyProgram addTarget:self action:@selector(LoyaltyProgramClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnLoyaltyProgram];
    if(app._flagMyLoyaltyTopButtons == 4)
    {
        [btnLoyaltyProgram setBackgroundColor:SELECTEDBGCOLOR];
        [btnLoyaltyProgram setTitleColor:SELECTEDTEXTCOLOR forState:UIControlStateNormal];
    }
 
}

-(void)MyCardClicked
{
   
    if(app._skipRegister == 1)
    {
        [[Singleton sharedSingleton] errorLoginFirst];
    }
    else
    {
        app._flagMainBtn = 3;
        app._flagMyLoyaltyTopButtons=1;
        
        MyLoyaltyCardView *card ;
        
        if (IS_IPHONE_5)
        {
            card=[[MyLoyaltyCardView alloc] initWithNibName:@"MyLoyaltyCardView-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            card=[[MyLoyaltyCardView alloc] initWithNibName:@"MyLoyaltyCardView_iPad" bundle:nil];
        }
        else
        {
            card=[[MyLoyaltyCardView alloc] initWithNibName:@"MyLoyaltyCardView" bundle:nil];
        }
        
        [app.navObj pushViewController:card animated:YES];
    }
   
    
}
-(void)ICEInfoClicked
{
    if(app._skipRegister == 1)
    {
        [[Singleton sharedSingleton] errorLoginFirst];
    }
    else
    {
        
    app._flagMainBtn =3;
    app._flagMyLoyaltyTopButtons=2;
    
  
    ICEInfoViewController *program ;
    
    if (IS_IPHONE_5)
    {
        program=[[ICEInfoViewController alloc] initWithNibName:@"ICEInfoViewController-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        program=[[ICEInfoViewController alloc] initWithNibName:@"ICEInfoViewController_iPad" bundle:nil];
    }
    else
    {
        program=[[ICEInfoViewController alloc] initWithNibName:@"ICEInfoViewController" bundle:nil];
    }
    
    [app.navObj pushViewController:program animated:NO];
    }
}
-(void)NewProgramClicked
{
   
    app._flagMainBtn = 3;
    app._flagMyLoyaltyTopButtons=3;
    
    NewProgramViewController *program ;
    
    if (IS_IPHONE_5)
    {
        program=[[NewProgramViewController alloc] initWithNibName:@"NewProgramViewController-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        program=[[NewProgramViewController alloc] initWithNibName:@"NewProgramViewController_iPad" bundle:nil];
    }
    else
    {
        program=[[NewProgramViewController alloc] initWithNibName:@"NewProgramViewController" bundle:nil];
    }
    
    [app.navObj pushViewController:program animated:YES];
}

-(void)LoyaltyProgramClicked
{
    if(app._skipRegister == 1)
    {
        [[Singleton sharedSingleton] errorLoginFirst];
    }
    else
    {
    app._flagMainBtn = 3;
    app._flagMyLoyaltyTopButtons=4;
    
    LoyaltyProgramViewController *program ;
    
    if (IS_IPHONE_5)
    {
        program=[[LoyaltyProgramViewController alloc] initWithNibName:@"LoyaltyProgramViewController-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        program=[[LoyaltyProgramViewController alloc] initWithNibName:@"LoyaltyProgramViewController_iPad" bundle:nil];
    }
    else
    {
        program=[[LoyaltyProgramViewController alloc] initWithNibName:@"LoyaltyProgramViewController" bundle:nil];
    }
    
    [app.navObj pushViewController:program animated:YES];
    }
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
