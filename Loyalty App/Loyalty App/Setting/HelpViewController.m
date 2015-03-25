//
//  MyAccountView.m
//  Loyalty App
//
//  Created by Amit Parmar on 19/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "HelpViewController.h"
#import "settingViewController.h"
#import "ViewController.h"
#import "MyAccountCell.h"
#import "ProfileDetailViewController.h"
#import "Singleton.h"
#import "ASScroll.h"

@interface HelpViewController ()
@end
  
@implementation HelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    app = APP;
//    [self.view addSubview:[app setFooterPart]];
//    app._flagMainBtn = 0; //2;
    
//     self.lblTitleResetPassword.font = FONT_centuryGothic_35;
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    
    ASScroll *asScroll;    
    if(IS_IPAD)
    {
        asScroll = [[ASScroll alloc]initWithFrame:CGRectMake(0.0,0.0,768.0,self.view.frame.size.height)];
//        asScroll = [[ASScroll alloc]initWithFrame:CGRectMake(0.0,65.0,768.0,920.0)]; //810
    }
    else
    {
        asScroll =[[ASScroll alloc]initWithFrame:CGRectMake(0.0,0.0,320.0,self.view.frame.size.height)];
//        asScroll =[[ASScroll alloc]initWithFrame:CGRectMake(0.0,65.0,320.0,460.0)];
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray * imagesArray = [[NSMutableArray alloc]init];
    int noOfImages = 13;
    for (int imageCount = 0; imageCount < noOfImages; imageCount++)
    {
        if(IS_IPAD)
        {
            [imagesArray addObject:[NSString stringWithFormat:@"a%d.png",imageCount+1]];
        }
        else
        {
            [imagesArray addObject:[NSString stringWithFormat:@"aa%d.png",imageCount+1]];
        }
    }
    [asScroll setArrOfImages:imagesArray];
    [self.view addSubview:asScroll];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    asScroll.pageControl.hidden = YES;    
    [asScroll.btnSkip addTarget:self action:@selector(btnSkipClicked) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}
-(void)btnSkipClicked
{
     [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark BUTTON CLICK EVENTS
-(void)startActivity
{
    [self.view addSubview:backgroundIndicatorView];
    [actIndicatorView startAnimating];
}
-(void)stopActivity
{
    [backgroundIndicatorView removeFromSuperview];
    [actIndicatorView stopAnimating];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
