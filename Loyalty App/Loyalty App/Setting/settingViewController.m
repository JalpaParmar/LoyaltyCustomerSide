//
//  settingViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "settingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "settingCell.h"
#import "Singleton.h"

@interface settingViewController ()
@end

@implementation settingViewController

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
    [self.view addSubview:[app setFooterPart]];
    app._flagMainBtn = 0; //2;
    
//     self.lblTitleSetting.font = FONT_centuryGothic_35;
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    
     self.btnLogout.hidden = YES;
    
    self.btnLogout.layer.cornerRadius = 5.0;
    self.btnLogout.clipsToBounds = YES;
    
    self.arrSettingKey = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"PushNotification",@"NewRestaurant", @"NewLoyaltyProgram", @"Chat", nil]];
    self.tblSetting.hidden = YES;
    
    [self GetSetSettingServer:@"" SettingTag:0];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark UITABLEVIEW DELEGATE METHODS

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;// [self.arrSetting count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    if(IS_IPAD)
    {
        simpleTableIdentifier = @"settingCell_iPad";
    }
    else
    {
        simpleTableIdentifier = @"settingCell";
    }
    
    settingCell *cell = (settingCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
        //data: {
        //SettingId: "00000000-0000-0000-0000-000000000000"
        //UserId: null
        //PushNotification: false
        //NewRestaurant: false
        //NewLoyaltyProgram: false
        //Chat: false
        //Status: false
        //Code: 0
        //Message: null
        //}
    
    if([self.arrSetting count] > 0)
    {
       
        
//        Chat = 0;
//        Code = 0;
//        Message = "<null>";
//        NewLoyaltyProgram = 0;
//        NewRestaurant = 0;
//        PushNotification = 0;
//        SettingId = "00000000-0000-0000-0000-000000000000";
//        Status = 0;
//        UserId = "<null>";
//        
        cell.btnSwitch.tag = indexPath.row;
        if(indexPath.row == 0)
        {
            if([[[self.arrSetting objectAtIndex:0] objectForKey:@"PushNotification"] intValue] == 1)
            {
                cell.btnSwitch.selected = YES;
                [cell.btnSwitch setBackgroundImage:[UIImage imageNamed:@"swich-on.png"] forState:UIControlStateNormal];
                P=@"TRUE";
            }
            else
            {
                cell.btnSwitch.selected = NO;
                [cell.btnSwitch setBackgroundImage:[UIImage imageNamed:@"swich-off.png"] forState:UIControlStateNormal];
                P=@"FALSE";
            }
             cell.lblSettingName.text = [NSString stringWithFormat:@"Push Notification" ];
        }
        else if(indexPath.row == 1)
        {
            
            if([[[self.arrSetting objectAtIndex:0] objectForKey:@"NewRestaurant"] intValue] == 1)
            {
                cell.btnSwitch.selected = YES;
                 [cell.btnSwitch setBackgroundImage:[UIImage imageNamed:@"swich-on.png"] forState:UIControlStateNormal];
                R=@"TRUE";
            }
            else
            {
                cell.btnSwitch.selected = NO;
                 [cell.btnSwitch setBackgroundImage:[UIImage imageNamed:@"swich-off.png"] forState:UIControlStateNormal];
                R=@"FALSE";
            }
          
             cell.lblSettingName.text = [NSString stringWithFormat:@"New Restaurant"];
            
        }
        else if(indexPath.row == 2)
        {
            if([[[self.arrSetting objectAtIndex:0] objectForKey:@"NewLoyaltyProgram"] intValue] == 1)
            {
                cell.btnSwitch.selected = YES;
                 [cell.btnSwitch setBackgroundImage:[UIImage imageNamed:@"swich-on.png"] forState:UIControlStateNormal];
                L=@"TRUE";
            }
            else
            {
                cell.btnSwitch.selected = NO;
                 [cell.btnSwitch setBackgroundImage:[UIImage imageNamed:@"swich-off.png"] forState:UIControlStateNormal];
                L=@"FALSE";
            }
             cell.lblSettingName.text = [NSString stringWithFormat:@"New Loyalty Program"];
            
        }
        else if(indexPath.row == 3)
        {
            if([[[self.arrSetting objectAtIndex:0] objectForKey:@"Chat"] intValue] == 1)
            {
                cell.btnSwitch.selected = YES;
                 [cell.btnSwitch setBackgroundImage:[UIImage imageNamed:@"swich-on.png"] forState:UIControlStateNormal];
                C=@"TRUE";
            }
            else
            {
                cell.btnSwitch.selected = NO;
                 [cell.btnSwitch setBackgroundImage:[UIImage imageNamed:@"swich-off.png"] forState:UIControlStateNormal];
                C=@"FALSE";
            }
             cell.lblSettingName.text = [NSString stringWithFormat:@"Chat"];
        }
        [cell.btnSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}
#pragma mark UIBUTTON CLICK EVENT
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
-(void)changeSwitch:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSString *IS_SELECTED;
    if(btn.selected)
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"swich-off.png"] forState:UIControlStateNormal];
        btn.selected = NO;
        IS_SELECTED=@"FALSE";
        
        switch (btn.tag) {
            case 0:
                P=@"FALSE";
                break;
            case 1:
                R=@"FALSE";
                break;
            case 2:
                L=@"FALSE";
                break;
            case 3:
                C=@"FALSE";
                break;
            default:
                break;
        }
        
    }
    else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"swich-on.png"] forState:UIControlStateNormal];
        btn.selected = YES;
        IS_SELECTED = @"TRUE";
        
        switch (btn.tag) {
            case 0:
                P=@"TRUE";
                break;
            case 1:
                R=@"TRUE";
                break;
            case 2:
                L=@"TRUE";
                break;
            case 3:
                C=@"TRUE";
                break;
            default:
                break;
        }
    }
  
    [self GetSetSettingServer:IS_SELECTED SettingTag:btn.tag];
}
-(void)GetSetSettingServer:(NSString*)IS_SELECTED SettingTag:(int)tag
{
    NSString *str = [NSString stringWithFormat:@"%@", [self.arrSettingKey objectAtIndex:tag]];

    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
        [self startActivity];
        NSString *strURL;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        NSString * userId ;
        if([st objectForKey:@"UserId"])
        {
            userId =  [st objectForKey:@"UserId"];
        }
        [dict setValue:userId forKey:@"UserId"];
       
        if([IS_SELECTED isEqualToString:@""])
        {
            //get
            strURL=@"User/Settings";
        }
        else
        {
            // send
            strURL=@"User/SaveSettings";
            [dict setValue:IS_SELECTED forKey:str];
            
            for(int i=0; i<[self.arrSettingKey count]; i++)
            {
                
                if(i != tag)
                {
                    switch (i) {
                        case 0:
                             [dict setValue:P forKey:[NSString stringWithFormat:@"%@", [self.arrSettingKey objectAtIndex:i]]];
                            break;
                        case 1:
                            [dict setValue:R forKey:[NSString stringWithFormat:@"%@", [self.arrSettingKey objectAtIndex:i]]];
                            break;
                        case 2:
                            [dict setValue:L forKey:[NSString stringWithFormat:@"%@", [self.arrSettingKey objectAtIndex:i]]];
                            break;
                        case 3:
                            [dict setValue:C forKey:[NSString stringWithFormat:@"%@", [self.arrSettingKey objectAtIndex:i]]];
                            break;
                        default:
                            break;
                    }
                    
//                    if([IS_SELECTED isEqualToString:@"TRUE"])
//                    {
//                        [dict setValue:@"FALSE" forKey:[NSString stringWithFormat:@"%@", [self.arrSettingKey objectAtIndex:i]]];
//                    }
//                    else
//                    {
//                        [dict setValue:@"TRUE" forKey:[NSString stringWithFormat:@"%@", [self.arrSettingKey objectAtIndex:i]]];
//                    }
//                    NSLog(@" %d -----  %@",i, dict);
                }
            }
        }
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Setting - - %@ -- ", dict);
             if (dict)
             {
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                 }
                 else
                 {
                    
                  
                     
                     if([IS_SELECTED isEqualToString:@""])
                     {
                         if([dict objectForKey:@"data"])
                         {
                             self.arrSetting = [[NSMutableArray alloc] initWithObjects:[dict objectForKey:@"data"], nil];
                             if([self.arrSetting count] > 0)
                             {
                                 self.tblSetting.hidden = NO;
                                 [self.tblSetting reloadData];
                                 
                                 self.btnLogout.hidden = NO;
                                 
                                 @try {
                                     if([[[self.arrSetting objectAtIndex:0] objectForKey:@"Chat"] intValue] == 1)
                                     {
                                         [[Singleton sharedSingleton] setstrLoginUserChat:@"1"];
                                     }
                                     else
                                     {
                                         [[Singleton sharedSingleton] setstrLoginUserChat:@"0"];
                                     }
                                 }
                                 @catch (NSException *exception) {
                                     [[Singleton sharedSingleton] setstrLoginUserChat:@"0"];
                                 }
                                  NSLog(@"-- seting - %@", [[Singleton sharedSingleton] getstrLoginUserChat]);
                             }
                         }
                     }
                     else
                     {
                         @try {
                             if([[[self.arrSetting objectAtIndex:0] objectForKey:@"Chat"] intValue] == 1)
                             {
                                 [[Singleton sharedSingleton] setstrLoginUserChat:@"0"];
                             }
                             else
                             {
                                 [[Singleton sharedSingleton] setstrLoginUserChat:@"1"];
                             }
                         }
                         @catch (NSException *exception) {
                             [[Singleton sharedSingleton] setstrLoginUserChat:@"0"];
                         }
                         NSLog(@"-- seting - %@", [[Singleton sharedSingleton] getstrLoginUserChat]);

                         
                         //UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         //[alt show];
                     }
                     
                 }
                 [self stopActivity];
             }
             else
             {
                 UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
                 [self stopActivity];
             }
         } :strURL data:dict];
    }
}
- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLogoutClicked:(id)sender
{
    [[Singleton sharedSingleton] CallLogoutGlobally];
    
}
@end
