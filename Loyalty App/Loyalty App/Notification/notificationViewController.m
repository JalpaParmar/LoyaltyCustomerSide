    //
//  notificationViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "notificationViewController.h"
#import "notificationCell.h"
#import "Singleton.h"

#define Msg_WIDTH_IPAD 730
#define Msg_WIDTH_IPHONE 300
#define  FONT_Msg_IPAD  [UIFont fontWithName:@"OpenSans-Light" size:16] //[UIFont systemFontOfSize:16]
#define FONT_Msg_IPHONE [UIFont fontWithName:@"OpenSans-Light" size:15]// [UIFont systemFontOfSize:15]
#define  DIFFERENCE_CELLSPACING 40+20
#define  DIFFERENCE_CELLSPACING_IPAD 40

@interface notificationViewController ()
@end

@implementation notificationViewController
@synthesize arrNotification,tblNotification, strUnseen;

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
    
    self.tblNotification.tableFooterView = [[UIView alloc] init];
    self.tblNotification.hidden=YES;
    
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
    
    if(![strUnseen isEqualToString:@""])
    {
        [self getNotificationList];
    }
    
    if([arrNotification count] > 0)
    {
        [self getDynamicHeightofLabels];
        tblNotification.hidden=NO;
        [tblNotification reloadData];
    }
}
#pragma mark Button Click Event
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

-(void)getNotificationList
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
//        [self startActivity];
        
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        NSString * userId ;
        if([st objectForKey:@"UserId"])
        {
            userId =  [st objectForKey:@"UserId"];
        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:userId  forKey:@"UserId"];
        [dict setValue:strUnseen  forKey:@"Type"];
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Notification %@ -- ", dict);
             
             if (dict)
             {
                 [self stopActivity];
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                 }
                 else
                 {                   
                 }
             }
             else
             {
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
                 [self stopActivity];
             }
         } :@"User/OpenNotification" data:dict];
    }
}

-(void)getDynamicHeightofLabels
{
    NSLog(@"---- %lu ----",  (unsigned long)[arrNotification count]);
    
    if([arrNotification count] > 0)
    {
        for(int i=0; i<[arrNotification count]; i++)
        {
            NSString *rName =[[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@", [[arrNotification objectAtIndex:i] objectForKey:@"Msg"]]] ;
           // rName = @"ksdfj  djsgkl dfkjds gjdfjgkld ldjflgkj dlfgjkldj gkldfjklgjdfkl gkldfjgkljdfklgjkldjfgkl dklfjgkldfjgkljdklfjgkldfjgkljdfk dklfjgkldfjgkljdfklgjkldfjgkldfj gkdfjklgjdklgjkldf gkljdkl";
//            if(i == 0)
//            {
//                rName = @"hi hello hows you, who r u? may i help you. no thnx. but whos you. hi hello hows you, who r u? may i help you. no thnx. but whos you. hi hello hows you, who r u? may i help you. no thnx. but whos you.";
//            }
            float h;
            CGSize aSize;
            if(IS_IPAD)
                aSize = CGSizeMake(Msg_WIDTH_IPAD, 20000);
            else
                aSize = CGSizeMake(Msg_WIDTH_IPHONE, 20000);
            
            NSMutableArray *tempArr = [arrNotification objectAtIndex:i];
            
            UIFont *font;
            if(IS_IPAD)
                font = FONT_Msg_IPAD;
            else
                font = FONT_Msg_IPHONE;
            
            h = ceilf([[Singleton sharedSingleton] heightOfTextForLabel:rName andFont:font maxSize:aSize].height);
            [tempArr setValue:[NSString stringWithFormat:@"%f", h] forKey:@"HeightOfMsgName"];
            
            [arrNotification replaceObjectAtIndex:i withObject:tempArr];
        }
    }
}
- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
-(IBAction)btnNotificationBtnClicked:(id)sender
{
    //NSString *msg;
    UIButton *btn = (UIButton*)sender;
    
    if(btn.tag == 1)
    {
        [self.btnNotification setBackgroundColor:[UIColor whiteColor]];
        [self.btnChat setBackgroundColor:[UIColor lightGrayColor]];
        
        if([arrParentNotification count] > 0)
        {
            arrNotification = [[NSMutableArray alloc] init];
            [arrNotification addObject:[[arrParentNotification objectAtIndex:0] objectForKey:@"Notification"]];
            if([arrNotification count] > 0)
            {
                if([[arrNotification objectAtIndex:0] count] > 0)
                {
                    arrNotification = [arrNotification objectAtIndex:0];
                }
                else
                {
                    [arrNotification removeAllObjects];
                }
            }
            [self getDynamicHeightofLabels];
            self.tblNotification.hidden = NO;
            [self.tblNotification reloadData];
        }
    }
    else if(btn.tag == 2)
    {
        [self.btnNotification setBackgroundColor:[UIColor lightGrayColor]];
        [self.btnChat setBackgroundColor:[UIColor whiteColor]];
        if([arrParentNotification count] > 0)
        {
            arrNotification = [[NSMutableArray alloc] init];
            [arrNotification addObject:[[arrParentNotification objectAtIndex:0] objectForKey:@"Chat"]];
            if([arrNotification count] > 0)
            {
                if([[arrNotification objectAtIndex:0] count] > 0)
                {
                    arrNotification = [arrNotification objectAtIndex:0];
                }
                else
                {
                    [arrNotification removeAllObjects];
                }
            }
            [self getDynamicHeightofLabels];
            self.tblNotification.hidden = NO;
            [self.tblNotification reloadData];
        }
    }
}*/
#pragma mark UITABLEVIEW DELEGATE METHODS
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(IS_IOS_8)
    {
    if ([self.tblNotification respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tblNotification setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tblNotification respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tblNotification setLayoutMargins:UIEdgeInsetsZero];
    }
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IOS_8)
    {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([arrNotification count] > 0)
    {
        return [arrNotification count]; // [[arrNotification objectAtIndex:0] count];
    }
    else
    {
        return 1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPAD)
    {
        if([arrNotification count] > 0)
        {
            return [[[arrNotification objectAtIndex:indexPath.row] objectForKey:@"HeightOfMsgName"] floatValue] + DIFFERENCE_CELLSPACING_IPAD;
        }
        else
        {
            return 50;
        }
    }
    else
    {
        if([arrNotification count] > 0)
        {
            return [[[arrNotification objectAtIndex:indexPath.row] objectForKey:@"HeightOfMsgName"] floatValue] + DIFFERENCE_CELLSPACING ;
        }
        else
        {
            return 50;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    if (IS_IPAD)
        simpleTableIdentifier= @"notificationCell_iPad";
    else
        simpleTableIdentifier=@"notificationCell";
    
    notificationCell *cell = (notificationCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
     if([arrNotification count] == 0)
     {
         cell.lblUserName.hidden = NO;
         cell.lblUserName.text=@"No Notification";
         cell.lblNotification.hidden=YES;
         cell.lblTime.hidden=YES;
         self.tblNotification.separatorStyle = UITableViewCellSeparatorStyleNone;
         
         cell.lblUserName.textAlignment = NSTextAlignmentCenter;
         
         if(IS_IPAD)
         {
             CGRect f = cell.lblUserName.frame;
             f.size.width = 768;
             f.size.height = 50;
             cell.lblUserName.frame = f;
         }
         else
         {
             CGRect f = cell.lblUserName.frame;
             f.size.width = 310;
             cell.lblUserName.frame = f;
         }
     }
    else
    {
        self.tblNotification.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        cell.lblUserName.textAlignment = NSTextAlignmentLeft;
        
        if(IS_IPAD)
        {
            CGRect f = cell.lblUserName.frame;
            f.size.width = 768 - 60;
            cell.lblUserName.frame = f;
        }
        else
        {
            CGRect f = cell.lblUserName.frame;
            f.size.width = 320 - 45;
            cell.lblUserName.frame = f;
        }
        
        cell.lblTime.hidden=NO;
        cell.lblUserName.hidden=NO;
        cell.lblNotification.hidden=NO;
        
        cell.lblNotification.numberOfLines=0;
        cell.lblNotification.lineBreakMode = NSLineBreakByWordWrapping;
        
        CGRect f = cell.lblNotification.frame;
        //    f.origin.y = cell.lblUserName.frame.origin.y + cell.lblUserName.frame.size.height + 2;
        f.size.height = [[[arrNotification objectAtIndex:indexPath.row] objectForKey:@"HeightOfMsgName"] floatValue];
        cell.lblNotification.frame = f;
        
        //    f = cell.viewSeparator.frame;
        //    f.origin.y = cell.lblNotification.frame.origin.y + cell.lblNotification.frame.size.height + 2;
        //    cell.viewSeparator.frame = f;
        
        cell.lblUserName.text = [NSString stringWithFormat:@"%@ %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrNotification objectAtIndex:indexPath.row] objectForKey:@"FirstName"]], [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrNotification objectAtIndex:indexPath.row] objectForKey:@"LastName"]]];
        cell.lblNotification.text =  [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrNotification objectAtIndex:indexPath.row] objectForKey:@"Msg"]]];
        
        //    if(indexPath.row == 0)
        //    {
        //         cell.lblNotification.text = @"hi hello hows you, who r u? may i help you. no thnx. but whos you. hi hello hows you, who r u? may i help you. no thnx. but whos you. hi hello hows you, who r u? may i help you. no thnx. but whos you.";
        //    }
        
        NSString *d = [[arrNotification objectAtIndex:indexPath.row] objectForKey:@"NotifyOn"];
        if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:d] isEqualToString:@""])
        {
//            NSString *strJoinDate=@"";
            cell.lblTime.text=[NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ConvertMilliSecIntoDate:d Format:@"dd MMM yyyy hh:mm a"]];
            
//            d = [d substringToIndex:[d length]- 2];
//            NSArray *arr = [d componentsSeparatedByString:@"("];
//            NSDate *joinDate;
//            NSString *strJoinDate=@"";
//            if([arr count] > 0)
//            {
//                d = [arr objectAtIndex:1];
//                joinDate = [NSDate dateWithTimeIntervalSince1970:[[arr objectAtIndex:1] doubleValue]/1000];
//                NSDateFormatter *format = [[NSDateFormatter alloc] init];
//                [format setDateFormat:@"dd MMM yyyy hh:mm a"];
//                strJoinDate = [format stringFromDate:joinDate];
//            }
//            cell.lblTime.text=[NSString stringWithFormat:@"%@", strJoinDate];
        }
    }
    
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
