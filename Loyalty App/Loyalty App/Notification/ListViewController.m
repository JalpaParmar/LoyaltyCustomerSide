    //
//  notificationViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "ListViewController.h"
#import "Singleton.h"
#import "ListCell.h"
#import "notificationViewController.h"

#define Msg_WIDTH_IPAD 730
#define Msg_WIDTH_IPHONE 300
#define  FONT_Msg_IPAD  [UIFont fontWithName:@"OpenSans-Light" size:16] //[UIFont systemFontOfSize:16]
#define FONT_Msg_IPHONE [UIFont fontWithName:@"OpenSans-Light" size:15]// [UIFont systemFontOfSize:15]
#define  DIFFERENCE_CELLSPACING 40+20
#define  DIFFERENCE_CELLSPACING_IPAD 40

//(CHAT,NEW RESTAURANT,ORDER,LOYALTY POINTS,LOYALTY PROGRAM,    SPECIAL OFFER,OTHER)


#define ORDER_TAG 1
#define POINTS_TAG 2
#define LOYALTYPROGRAM_TAG 3
#define OFFER_TAG 4
#define NEWRESTAURANT_TAG 5
#define CHAT_TAG 6
#define OTHER_TAG 7


@interface ListViewController ()
@end

@implementation ListViewController

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
    
//    self.tblNotification.tableFooterView = [[UIView alloc] init];
//    self.tblNotification.hidden=YES;
    
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
    
    [self getNotificationList];
    
    // Do any additional setup after loading the view from its nib.
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
        [self startActivity];
        
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        NSString * userId ;
        if([st objectForKey:@"UserId"])
        {
            userId =  [st objectForKey:@"UserId"];
        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:userId  forKey:@"UserId"];
        
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
                     if([dict objectForKey:@"You do not have any notification."])
                     {
                         alt.tag = 20;
                     }
                     [alt show];
                     
                     [arrNotification removeAllObjects];
                     self.tblNotification.hidden = NO;
                     [self.tblNotification reloadData];
                 }
                 else
                 {
                     
                     arrParentNotification = [[NSMutableArray alloc] init];
                     [arrParentNotification addObject:[dict objectForKey:@"data"] ];
                     
                     if([arrParentNotification count] > 0)
                     {
                         arrNotification = [[NSMutableArray alloc] init];
 
                         
                         NSMutableDictionary *dictChild = [[NSMutableDictionary alloc] init];
                         [dictChild setValue:[NSNumber numberWithInt:[[[arrParentNotification objectAtIndex:0] objectForKey:@"UnseenOrder"] intValue]] forKey:ORDER_NOTIFICATION];
                          [arrNotification addObject:dictChild];
                         
                         NSMutableDictionary *dictChild11 = [[NSMutableDictionary alloc] init];
                         [dictChild11 setValue:[NSNumber numberWithInt:[[[arrParentNotification objectAtIndex:0] objectForKey:@"UnseenLoyaltyPoints"] intValue]] forKey:POINTS_NOTIFICATION];
                         [arrNotification addObject:dictChild11];
                         
                         
                         NSMutableDictionary *dictChild1 = [[NSMutableDictionary alloc] init];
                         [dictChild1 setValue:[NSNumber numberWithInt:[[[arrParentNotification objectAtIndex:0] objectForKey:@"UnseenLoyaltyProgram"] intValue]] forKey:LOYALTYPROGRAM_NOTIFICATION];
                         [arrNotification addObject:dictChild1];
                         
                         NSMutableDictionary *dictChild22 = [[NSMutableDictionary alloc] init];
                         [dictChild22 setValue:[NSNumber numberWithInt:[[[arrParentNotification objectAtIndex:0] objectForKey:@"UnseenSpecialOffer"] intValue]] forKey:OFFER_NOTIFICATION];
                         [arrNotification addObject:dictChild22];
                         
                         
                         NSMutableDictionary *dictChild2 = [[NSMutableDictionary alloc] init];
                         [dictChild2 setValue:[NSNumber numberWithInt:[[[arrParentNotification objectAtIndex:0] objectForKey:@"UnseenNewRestaurant"] intValue]] forKey:NEWRESTAURANT_NOTIFICATION];
                          [arrNotification addObject:dictChild2];
                         
                         NSMutableDictionary *dictChild3 = [[NSMutableDictionary alloc] init];
                         [dictChild3 setValue:[NSNumber numberWithInt:[[[arrParentNotification objectAtIndex:0] objectForKey:@"UnseenChat"] intValue]] forKey:CHAT_NOTIFICATION];
                          [arrNotification addObject:dictChild3];
                         
                         NSMutableDictionary *dictChild4 = [[NSMutableDictionary alloc] init];
                         [dictChild4 setValue:[NSNumber numberWithInt:[[[arrParentNotification objectAtIndex:0] objectForKey:@"UnseenOther"] intValue]] forKey:OTHER_NOTIFICATION];
                          [arrNotification addObject:dictChild4];
                         
                         //Order
                         //LoyaltyPoints
                         //NewRestaurant
                         //Other
                         //Chat
                       
                         self.tblNotification.hidden = NO;
                         [self.tblNotification reloadData];
                     }
                   
                 }
             }
             else
             {
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
                 [self stopActivity];
             }
         } :@"/User/Notification" data:dict];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 20)
    {
        [self.navigationController popViewControllerAnimated:YES];
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
//    return 6;
    if([arrNotification count] > 0)
    {
        return [arrNotification count]; // [[arrNotification objectAtIndex:0] count];
    }
    else
    {
        return 0;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPAD)
        return 80;
    else
        return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    if (IS_IPAD)
        simpleTableIdentifier= @"ListCell_iPad";
    else
        simpleTableIdentifier=@"ListCell";
    
    ListCell *cell = (ListCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.btnArrow.hidden = YES;
    
    switch (indexPath.row) {
        case 0:
            cell.lblName.text= @"Order";
            [cell.btnIcon setImage:[UIImage imageNamed:@"notification_order.png"] forState:UIControlStateNormal];
            
            if( [[[arrNotification objectAtIndex:indexPath.row] objectForKey:ORDER_NOTIFICATION] intValue] > 0)
            {
                [cell.btnNumber setTitle:[NSString stringWithFormat:@"%@", [[arrNotification objectAtIndex:indexPath.row] objectForKey:ORDER_NOTIFICATION]] forState:UIControlStateNormal];
                cell.btnNumber.hidden = NO;
            }
            else
            {
                cell.btnNumber.hidden = YES;
            }
            break;
        case 1:
            cell.lblName.text= @"Loyalty Points";
             [cell.btnIcon setImage:[UIImage imageNamed:@"notification_points.png"] forState:UIControlStateNormal];
            if( [[[arrNotification objectAtIndex:indexPath.row] objectForKey:POINTS_NOTIFICATION] intValue] > 0)
            {
                [cell.btnNumber setTitle: [NSString stringWithFormat:@"%@", [[arrNotification objectAtIndex:indexPath.row] objectForKey:POINTS_NOTIFICATION]]  forState:UIControlStateNormal];
                cell.btnNumber.hidden = NO;
            }
            else
            {
                cell.btnNumber.hidden = YES;
            }
            break;
        case 2:
            cell.lblName.text= @"Loyalty Program";
             [cell.btnIcon setImage:[UIImage imageNamed:@"notification_program.png"] forState:UIControlStateNormal];
            if( [[[arrNotification objectAtIndex:indexPath.row] objectForKey:LOYALTYPROGRAM_NOTIFICATION] intValue] > 0)
            {
                [cell.btnNumber setTitle:  [NSString stringWithFormat:@"%@", [[arrNotification objectAtIndex:indexPath.row] objectForKey:LOYALTYPROGRAM_NOTIFICATION]] forState:UIControlStateNormal];
                cell.btnNumber.hidden = NO;
            }
            else
            {
                cell.btnNumber.hidden = YES;
            }
            break;
        case 3:
            cell.lblName.text= @"Special Offer";
            [cell.btnIcon setImage:[UIImage imageNamed:@"notification_special_offer.png"] forState:UIControlStateNormal];
            if( [[[arrNotification objectAtIndex:indexPath.row] objectForKey:OFFER_NOTIFICATION] intValue] > 0)
            {
                [cell.btnNumber setTitle:  [NSString stringWithFormat:@"%@", [[arrNotification objectAtIndex:indexPath.row] objectForKey:OFFER_NOTIFICATION]] forState:UIControlStateNormal];
                 cell.btnNumber.hidden = NO;
            }
            else
            {
                cell.btnNumber.hidden = YES;
            }
            break;
        case 4:
            cell.lblName.text= @"New Restaurant Request";
            [cell.btnIcon setImage:[UIImage imageNamed:@"notification_new_restaurant.png"] forState:UIControlStateNormal];
            if( [[[arrNotification objectAtIndex:indexPath.row] objectForKey:NEWRESTAURANT_NOTIFICATION] intValue] > 0)
            {
                [cell.btnNumber setTitle:  [NSString stringWithFormat:@"%@", [[arrNotification objectAtIndex:indexPath.row] objectForKey:NEWRESTAURANT_NOTIFICATION]] forState:UIControlStateNormal];
                cell.btnNumber.hidden = NO;
            }
            else
            {
                cell.btnNumber.hidden = YES;
            }
            break;
        case 5:
            cell.lblName.text= @"Chat";
             [cell.btnIcon setImage:[UIImage imageNamed:@"notification_chat.png"] forState:UIControlStateNormal];
            if( [[[arrNotification objectAtIndex:indexPath.row] objectForKey:CHAT_NOTIFICATION] intValue] > 0)
            {
                [ cell.btnNumber setTitle: [NSString stringWithFormat:@"%@", [[arrNotification objectAtIndex:indexPath.row] objectForKey:CHAT_NOTIFICATION]] forState:UIControlStateNormal];
                cell.btnNumber.hidden = NO;
            }
            else
            {
                cell.btnNumber.hidden = YES;
            }
            break;
        case 6:
            cell.lblName.text= @"Other";
               [cell.btnIcon setImage:[UIImage imageNamed:@"notification_other.png"] forState:UIControlStateNormal];
            if( [[[arrNotification objectAtIndex:indexPath.row] objectForKey:OTHER_NOTIFICATION] intValue] > 0)
            {
                
                [cell.btnNumber setTitle: [NSString stringWithFormat:@"%@", [[arrNotification objectAtIndex:indexPath.row] objectForKey:OTHER_NOTIFICATION]] forState:UIControlStateNormal];
                cell.btnNumber.hidden = NO;
            }
            else
            {
                cell.btnNumber.hidden = YES;
            }
            break;
        default:
            break;
    }
    if([cell.btnNumber.titleLabel.text intValue] > 99)
    {
        CGRect f = cell.btnNumber.frame;
        f.size.width = 31;
        cell.btnNumber.frame = f;
    }
    else
    {
        
    }
    
    cell.btnNumber.layer.cornerRadius = 13.0;
    cell.btnNumber.clipsToBounds=YES;
    
    cell.btnbackground.tag = indexPath.row+1;
    [cell.btnbackground addTarget:self action:@selector(myAccountButtonClickedEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark BUTTON CLICK EVENTS
-(void)myAccountButtonClickedEvent:(id)sender
{
    NSLog(@"arrParentNotification : %d", [arrParentNotification count]);
    
    notificationViewController *notification;
    if (IS_IPHONE_5)
    {
        notification=[[notificationViewController alloc] initWithNibName:@"notificationViewController-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        notification=[[notificationViewController alloc] initWithNibName:@"notificationViewController_iPad" bundle:nil];
    }
    else
    {
        notification=[[notificationViewController alloc] initWithNibName:@"notificationViewController" bundle:nil];
    }
    notification.strUnseen=@"";
    UIButton *btn = (UIButton*)sender;
    ListCell *cell = (ListCell*)[self.tblNotification cellForRowAtIndexPath:[NSIndexPath indexPathForItem:btn.tag-1 inSection:0]];
    cell.btnNumber.hidden = YES;
    
    
    //                         UnseenChat = 5;
    //                         UnseenLoyaltyPoints = 0;
    //                         UnseenLoyaltyProgram = 0;
    //                         UnseenNewRestaurant = 9;
    //                         UnseenOrder = 21;
    //                         UnseenOther = 0;
    //                         UnseenSpecialOffer = 0;
    
    if(btn.tag == ORDER_TAG)
    {
        notification.arrNotification = [[arrParentNotification objectAtIndex:0] objectForKey:ORDER_NOTIFICATION] ;
        
        if( [[[arrNotification objectAtIndex:btn.tag-1] objectForKey:ORDER_NOTIFICATION] intValue] > 0)
        {
            notification.strUnseen=@"ORDER";
            NSMutableArray *arr = [arrNotification objectAtIndex:btn.tag-1];
            [arr setValue:@"0" forKey:ORDER_NOTIFICATION];
            [arrNotification replaceObjectAtIndex:btn.tag-1 withObject:arr];
        }
    }
    else if(btn.tag == POINTS_TAG)
    {
         notification.arrNotification = [[arrParentNotification objectAtIndex:0] objectForKey:POINTS_NOTIFICATION] ;
        
        if( [[[arrNotification objectAtIndex:btn.tag-1] objectForKey:POINTS_NOTIFICATION] intValue] > 0)
        {
            notification.strUnseen=@"LOYALTY POINTS";
        }
    }
    else if(btn.tag == LOYALTYPROGRAM_TAG)
    {
         notification.arrNotification = [[arrParentNotification objectAtIndex:0]  objectForKey:LOYALTYPROGRAM_NOTIFICATION] ;
       
        if( [[[arrNotification objectAtIndex:btn.tag-1] objectForKey:LOYALTYPROGRAM_NOTIFICATION] intValue] > 0)
        {
            notification.strUnseen=@"LOYALTY PROGRAM";
        }
    }
    else if(btn.tag == OFFER_TAG)
    {
        notification.arrNotification = [[arrParentNotification objectAtIndex:0]  objectForKey:OFFER_NOTIFICATION] ;
        
        if( [[[arrNotification objectAtIndex:btn.tag-1] objectForKey:OFFER_NOTIFICATION] intValue] > 0)
        {
            notification.strUnseen=@"SPECIAL OFFER";
        }
    }
    else if(btn.tag == NEWRESTAURANT_TAG)
    {
        notification.arrNotification = [[arrParentNotification objectAtIndex:0] objectForKey:NEWRESTAURANT_NOTIFICATION] ;        
        if( [[[arrNotification objectAtIndex:btn.tag-1] objectForKey:NEWRESTAURANT_NOTIFICATION] intValue] > 0)
        {
            notification.strUnseen=@"NEW RESTAURANT";            
            NSMutableArray *arr = [arrNotification objectAtIndex:btn.tag-1];
            [arr setValue:@"0" forKey:NEWRESTAURANT_NOTIFICATION];
            [arrNotification replaceObjectAtIndex:btn.tag-1 withObject:arr];
        }
    }
    else if(btn.tag == CHAT_TAG)
    {
         notification.arrNotification = [[arrParentNotification objectAtIndex:0]  objectForKey:CHAT_NOTIFICATION] ;
        
        if( [[[arrNotification objectAtIndex:btn.tag-1] objectForKey:CHAT_NOTIFICATION] intValue] > 0)
        {
            notification.strUnseen=@"CHAT";
        }
    }
    else if(btn.tag == OTHER_TAG)
    {
         notification.arrNotification = [[arrParentNotification objectAtIndex:0]  objectForKey:OTHER_NOTIFICATION] ;
        
        if( [[[arrNotification objectAtIndex:btn.tag-1] objectForKey:OTHER_NOTIFICATION] intValue] > 0)
        {
            notification.strUnseen=@"OTHER";
        }
    }
    if([notification.arrNotification count] > 0)
    {
        [self.navigationController pushViewController:notification animated:YES];
    }
    else
    {
        [Singleton showToastMessage:@"You have no notificaiton"];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
