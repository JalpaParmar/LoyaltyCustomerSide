//
//  ReservationDetailViewController1.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "chatViewController.h"
#import "Singleton.h"
#import "ChatTableCell.h"

#define IPHONE_MESSGAE_WIDTH  195 //270
#define IPAD_MESSGAE_WIDTH 600 //680

@interface chatViewController ()
@end

@implementation chatViewController
//@synthesize restaurantId;

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
    // Do any additional setup after loading the view from its nib.
    
    
    
    app = APP;
    [self.view addSubview:[app setFooterPart]];
    app._flagMainBtn = 0; //2;
    
    flag_firstTime=0;
    
//    self.lblTitleReservation.font = FONT_centuryGothic_35;
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    
    btnEnd.layer.cornerRadius = 5.0;
    btnEnd.clipsToBounds = YES;
    
    btnSend.layer.cornerRadius = 5.0;
    btnSend.clipsToBounds = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [tblChat addGestureRecognizer:tapGesture];
    [tblChat setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    
//    timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self  selector:@selector(getChatFetch)  userInfo:nil  repeats:YES];

}
-(void)viewWillAppear:(BOOL)animated
{
   [self getChatIdAndStart];
    NSLog(@"tblChat.frame.size.height : %f", tblChat.frame.size.height);
    
}

-(void)getChatIdAndStart
{
    indexId = [[Singleton sharedSingleton] getIndexId];
 	arrChatList = [[NSMutableArray alloc ] init];
    
    NSLog(@"self.restaurantId  : %@", self.restaurantId);
    NSLog(@"self.restaurantId store : %@", [[Singleton sharedSingleton] getstrRestaurantForChat]);
    
    if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:[[Singleton sharedSingleton] getstrRestaurantForChat]] isEqualToString:@""])
    {
        self.restaurantId = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[Singleton sharedSingleton] getstrRestaurantForChat]];
    }

    NSLog(@"Chat Detail : %@", [[Singleton sharedSingleton] getarrChatDetail]);
    NSLog(@"Chat Detail count : %d", [[[Singleton sharedSingleton] getarrChatDetail] count]);
    
    
    NSString *cid, *rid;
    if([[[Singleton sharedSingleton] getarrChatDetail] count] > 0)
    {
        for(int i=0; i<[[[Singleton sharedSingleton] getarrChatDetail] count]; i++)
        {
//            NSArray *tempArr = [[[[[Singleton sharedSingleton] getarrChatDetail] objectAtIndex:i] objectForKey:@"chatId"] componentsSeparatedByString:@"~"];
//            if([tempArr count] > 0) {
//                cid = [tempArr objectAtIndex:0];
//                if([tempArr count] > 1) {
//                    rid = [tempArr objectAtIndex:1];
//                }
//            }
            
            cid = [[[[Singleton sharedSingleton] getarrChatDetail] objectAtIndex:i] objectForKey:@"chatId"];
            rid = [[[[Singleton sharedSingleton] getarrChatDetail] objectAtIndex:i] objectForKey:@"restaurantId"];
            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:cid] isEqualToString:@""])
            {
                chatId = cid;
            }
            
            int Flag_ChatFetch = 0;
            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:chatId] isEqualToString:@""])
            {
                if([[[Singleton sharedSingleton] getarrChatDetail] count] > 0)
                {
                    for(int i=0; i<[[[Singleton sharedSingleton] getarrChatDetail] count]; i++)
                    {
                        Flag_ChatFetch=1;
                        NSString *c = [[[[Singleton sharedSingleton] getarrChatDetail] objectAtIndex:i] objectForKey:@"chatId"];
                        NSString *r;
                        if([chatId isEqualToString:c])
                        {
                            r = [[[[Singleton sharedSingleton] getarrChatDetail] objectAtIndex:i] objectForKey:@"restaurantId"];
                            if([r isEqualToString:self.restaurantId])
                            {
                                Flag_ChatFetch=3;
                                [self getChatFetch];
                                break;
                            }
                        }
                    }
                }
            }
            else if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:self.restaurantId] isEqualToString:@""])
            {
                if([[[Singleton sharedSingleton] getarrChatDetail] count] > 0)
                {
                    for(int i=0; i<[[[Singleton sharedSingleton] getarrChatDetail] count]; i++)
                    {
                        Flag_ChatFetch=2;
                        NSString *r = [[[[Singleton sharedSingleton] getarrChatDetail] objectAtIndex:i] objectForKey:@"restaurantId"];
                        if([self.restaurantId isEqualToString:r])
                        {
                            Flag_ChatFetch=3;
                            chatId = [[[[Singleton sharedSingleton] getarrChatDetail] objectAtIndex:i] objectForKey:@"chatId"];
                            [self getChatFetch];
                            break;
                        }
                    }
                }
            }
            
        }
    }
      
    
    //call when only they contain only chatId or only rest Id
//    if(Flag_ChatFetch == 1 || Flag_ChatFetch == 2)
//    {
//        [self getChatFetch];
//    }
}
//-(void)GettingChatId:(NSNotification *)notification
//{
//    NSLog(@"**** GettingChatId **** ");
//    NSLog(@"%@", notification);
//    NSLog(@"%@", notification.userInfo);
//
//    NSDictionary *apsInfo = [notification.userInfo objectForKey:@"userInfo"];
//    
//    NSString *alert = [apsInfo objectForKey:@"alert"];
//    NSLog(@"Received Push Alert: %@", alert);
//    
//    NSString *sound = [apsInfo objectForKey:@"sound"];
//    NSLog(@"Received Push Sound: %@", sound);
//    
//    chatId = sound;
//    
////    NSLog(@"%@", [notification.object objectForKey:@"sound"]);
//}
#pragma mark - UIButton click event -
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
-(void)getChatStart
{
    [self.view endEditing:YES];
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
    }
    else
    {
        [self startActivity];
//        53)Chat
//        Url : /Data/Chat
//    Type: POST
//    Parameter: UserId,RestaurantId,Msg

        
        NSString *UserId;
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        if([st objectForKey:@"UserId"])
        {
            UserId = [st objectForKey:@"UserId"];
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:UserId forKey:@"UserId"];
        [dict setValue:self.restaurantId forKey:@"RestaurantId"];
        [dict setValue:txtMessage.text forKey:@"Msg"];
        if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:chatId] isEqualToString:@""])
        {
            if([[[Singleton sharedSingleton] getarrChatDetail] count] > 0)
            {
                for(int i=0; i<[[[Singleton sharedSingleton] getarrChatDetail] count]; i++)
                {
                    NSString *r = [[[[Singleton sharedSingleton] getarrChatDetail] objectAtIndex:i] objectForKey:@"restaurantId"];
                    if([self.restaurantId isEqualToString:r])
                    {
                        [dict setValue:chatId forKey:@"ChatId"];
                        break;
                    }
                }
            }
        }
        
//        else
//        {
//            [dict setValue:@"" forKey:@"ChatId"];
//        }
//        
//        [dict setValue:anotherUserId forKey:@"UserId"];
//        [dict setValue:UserId forKey:@"RestaurantUserId"];
//        [dict setValue:txtMessage.text forKey:@"Msg"];
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Chat Generate   %@ -- ", dict);
             
//             [self getChatFetch];
             
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
//                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                     [alt show];
                     
//                     Printing description of dict:
//                     {
//                         code = 1;
//                         data =     {
//                             AcceptFlag = "<null>";
//                             ChatId = "554e3d05-5512-47e2-b342-89dfb91a65fa";
//                             Code = 1001;
//                             ConversationId = "00000000-0000-0000-0000-000000000000";
//                             EndFlag = "<null>";
//                             EndOn = "<null>";
//                             EndedBy = "<null>";
//                             FirstName = "<null>";
//                             IsSenderRestaurant = 0;
//                             LastName = "<null>";
//                             Message = "Chat started successfully";
//                             Msg = "";
//                             RestaurantId = "00000000-0000-0000-0000-000000000000";
//                             RestaurantUserId = "ef592442-2dd3-49c7-a550-d27189beeee8";
//                             StartOn = "<null>";
//                             Status = "<null>";
//                             Time = "<null>";
//                             UserId = "13185f85-9f68-4b6f-89cb-d126dd1b0afd";
//                         };
//                         message = "Chat started successfully";
//                     }
                     
                     if([dict objectForKey:@"data"])
                     {
                         arrChatList = [dict objectForKey:@"data"];
                         chatId = [NSString stringWithFormat:@"%@", [[arrChatList objectAtIndex:0]objectForKey:@"ChatId"]];
                         [self getDynamicHeightofLabels];
                         [self updateContentInset];
                         [tblChat reloadData];

                         
                         NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
                         [d setValue:self.restaurantId forKey:@"restaurantId"];
                         [d setValue:chatId forKey:@"chatId"];
                         if([[[Singleton sharedSingleton] getarrChatDetail] count] > 0)
                         {

                             if([[[Singleton sharedSingleton] getarrChatDetail] containsObject:d])
                             {
                                 NSLog(@"Already contains");
                             }
                             else
                             {
                                 NSLog(@"Beofre [[Singleton sharedSingleton] getarrChatDetail]  : %@",[[Singleton sharedSingleton] getarrChatDetail] );
                                 NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                                 tempArr = [[Singleton sharedSingleton] getarrChatDetail];
                                 
                                 [tempArr addObject:d];
                                 [[Singleton sharedSingleton] setarrChatDetail:tempArr];
                                 NSLog(@"After [[Singleton sharedSingleton] getarrChatDetail]  : %@",[[Singleton sharedSingleton] getarrChatDetail] );
                             }
                             
//                             }
                         }
                         else
                         {
                             NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:d, nil];
                             [[Singleton sharedSingleton] setarrChatDetail:arr];
                         }
                         
                        

//                         [self getChatFetch];
                     }
                 }
                  [self stopActivity];
             }
             else
             {
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
                 [self stopActivity];
             }
         } :@"Data/Chat" data:dict];
    }
}
-(void)getChatFetch
{
    [self.view endEditing:YES];
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
    }
    else
    {
        if(flag_firstTime == 0)
        {
            [self startActivity];
        }
        
//        54)Fetch Chat
//        Url : /Data/FetchChat
//    Type: POST
//    Parameter: UserId

        
        NSString *UserId;
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        if([st objectForKey:@"UserId"])
        {
            UserId = [st objectForKey:@"UserId"];
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:UserId forKey:@"UserId"];
        [dict setValue:chatId forKey:@"ChatId"];
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Chat Fetch   %@ -- ", dict);
             
             if (dict)
             {
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
//                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                     [alt show];
                 }
                 else
                 {
//                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                     [alt show];
                     
//                     {
//                         code = 1;
//                         data =     (
//                                     {
//                                         AcceptFlag = "<null>";
//                                         ChatId = "e4fe4467-edcd-45ab-a54b-e6a3203c528e";
//                                         Code = 0;
//                                         ConversationId = "00000000-0000-0000-0000-000000000000";
//                                         EndFlag = "<null>";
//                                         EndOn = "<null>";
//                                         EndedBy = "<null>";
//                                         FirstName = "<null>";
//                                         IsSenderRestaurant = "<null>";
//                                         LastName = "<null>";
//                                         Message = ghjghj;
//                                         Msg = "<null>";
//                                         RestaurantId = "00000000-0000-0000-0000-000000000000";
//                                         RestaurantUserId = "00000000-0000-0000-0000-000000000000";
//                                         StartOn = "<null>";
//                                         Status = "<null>";
//                                         Time =             {
//                                             Days = 0;
//                                             Hours = 2;
//                                             Milliseconds = 840;
//                                             Minutes = 17;
//                                             Seconds = 57;
//                                             Ticks = 82778403261;
//                                             TotalDays = "0.09580833710763889";
//                                             TotalHours = "2.299400090583333";
//                                             TotalMilliseconds = "8277840.3261";
//                                             TotalMinutes = "137.964005435";
//                                             TotalSeconds = "8277.8403261";
//                                         };
//                                         UserId = "13185f85-9f68-4b6f-89cb-d126dd1b0afd";
//                                     }
//                                     );
//                         message = "Total 1 Notifications.";
//                     }
                     if([dict objectForKey:@"data"])
                     {
//                         arrChatList = [[NSMutableArray alloc] initWithObjects:[dict objectForKey:@"data"], nil];
                         arrChatList = [dict objectForKey:@"data"];
                         
                          chatId = [NSString stringWithFormat:@"%@", [[arrChatList objectAtIndex:0]objectForKey:@"ChatId"]];
                         
                         [self getDynamicHeightofLabels];
                         [self updateContentInset];
                         [tblChat reloadData];
                     }
                     
                 }
                 if(flag_firstTime == 0)
                 {
                      [self stopActivity];
                 }
                flag_firstTime = 1;
             }
             else
             {
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
                 [self stopActivity];
             }
         } :@"Data/FetchChat" data:dict];
    }
}
- (void)updateContentInset {
    NSInteger numRows=[self tableView:tblChat numberOfRowsInSection:0];
    CGFloat contentInsetTop=tblChat.bounds.size.height;
    for (int i=0;i<numRows;i++) {
        contentInsetTop-=[self tableView:tblChat heightForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        if (contentInsetTop<=0) {
            contentInsetTop=0;
            break;
        }
    }
    tblChat.contentInset = UIEdgeInsetsMake(contentInsetTop, 0, 0, 0);
}

-(void)getChatEnd
{
    [self.view endEditing:YES];
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
    }
    else
    {
        [self startActivity];
//        55)End Chat
//        Url : /Data/ChatEnd
//    Type: POST
//    Parameter: UserId,ChatId

        NSString *UserId;
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        if([st objectForKey:@"UserId"])
        {
            UserId = [st objectForKey:@"UserId"];
        }
        if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:chatId] isEqualToString:@""])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:UserId forKey:@"UserId"];
            [dict setValue:chatId forKey:@"ChatId"];
            
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 NSLog(@"Chat End   %@ -- ", dict);
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
                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         alt.tag = 13;
                         [alt show];
                         
                         
                         NSLog(@"before End Chat Detail : %@ ", [[Singleton sharedSingleton] getarrChatDetail]);
                         
                         if([[[Singleton sharedSingleton] getarrChatDetail] count] > 0)
                         {
                             for(int i=0; i<[[[Singleton sharedSingleton] getarrChatDetail] count]; i++)
                             {
                                 NSString *c = [[[[Singleton sharedSingleton] getarrChatDetail] objectAtIndex:i] objectForKey:@"chatId"];
                                
                                 if([chatId isEqualToString:c])
                                 {
                                     [[[Singleton sharedSingleton] arrChatDetail] removeObjectAtIndex:i];
                                 }
                             }
                         }
                         
                         NSMutableArray *tempArr = [[Singleton sharedSingleton] getarrChatDetail] ;
                         
                         NSArray *valArray = [[[Singleton sharedSingleton] getarrChatDetail] valueForKey:@"chatId"];
                         if([valArray count] > 0)
                         {
                             NSUInteger index = [valArray indexOfObject:chatId];
                             if(index != NSNotFound)
                             {
                                 NSLog(@"contans : %lu", (unsigned long)index);
                                 [tempArr removeObjectAtIndex:index];
                             }
                         }
                         
                         [[Singleton sharedSingleton]  setarrChatDetail:tempArr];
                         NSLog(@"After End Chat Detail : %@ ", [[Singleton sharedSingleton] getarrChatDetail]);
                         
                         if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:chatId] isEqualToString:@""])
                         {
                             chatId=@"";
                         }
                         //[self.navigationController popViewControllerAnimated:YES];
                     }
                     [self stopActivity];
                 }
                 else
                 {
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     [self stopActivity];
                 }
             } :@"Data/ChatEnd" data:dict];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry this chat is not exist." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [self stopActivity];
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 13)
    {
        if(buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (IBAction)btnSendClicked:(id)sender
{
     [self setTableKeyboardAfterMessageSend];
    
    NSString *arrChatListtr = txtMessage.text;
	
    if([arrChatListtr length] > 0) {
		
        // Send On server
        [self getChatStart];
 
		txtMessage.text = @"";
        [self setTableKeyboardAfterMessageSend];
   }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Enter any Message" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (IBAction)btnEndClicked:(id)sender
{

    [self setTableKeyboardAfterMessageSend];
    
    if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:chatId] isEqualToString:@""])
    {
        [self getChatEnd];
    }
}
- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getDynamicHeightofLabels
{
    NSLog(@"---- %lu ----",  (unsigned long)[arrChatList count]);
    
    if([arrChatList count] > 0)
    {
        for(int i=0; i<[arrChatList count]; i++)
        {
            NSString *msg = [[arrChatList objectAtIndex:i] objectForKey:@"Msg"];
            
            CGSize aSize, sizeDynamic;
            if(IS_IPAD)
                aSize = CGSizeMake(IPAD_MESSGAE_WIDTH, 20000);
            else
                aSize = CGSizeMake(IPHONE_MESSGAE_WIDTH, 20000);
            
            NSMutableArray *tempArr = [arrChatList objectAtIndex:i];
            
            UIFont *font;
            if(IS_IPAD)
                font = [UIFont fontWithName:@"OpenSans-Light" size:17];// [UIFont systemFontOfSize:17];
            else
                font =[UIFont fontWithName:@"OpenSans-Light" size:13];;// [UIFont systemFontOfSize:13];
            
            sizeDynamic = [[Singleton sharedSingleton] heightOfTextForLabel:msg andFont:font maxSize:aSize];
            [tempArr setValue:[NSString stringWithFormat:@"%@", NSStringFromCGSize(sizeDynamic)] forKey:@"sizeOfMessage"];
            
            [arrChatList  replaceObjectAtIndex:i withObject:tempArr];
        }
    }
}
#pragma mark -
#pragma mark Table view delegates

static CGFloat padding = 20.0;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([arrChatList count] > 0)
    {
        return [arrChatList count];
    }
    else
    {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = (NSDictionary *)[arrChatList objectAtIndex:indexPath.row];
    NSString *strSize = [dict objectForKey:@"sizeOfMessage"];
    CGSize sizeDynamic = CGSizeFromString(strSize);
    CGFloat height = sizeDynamic.height + 30 ;
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *s;
    s = (NSDictionary *) [arrChatList objectAtIndex:indexPath.row];
    NSLog(@" ArrChtaList : %@", s);
    CGSize sizeDynamic;
//    NSDate *joinDate;
    NSString *strJoinDate=@"";
    NSString *message;
    UIImage *bgImage = nil;
    
//    static NSString *CellIdentifier = @"MessageCellIdentifier";
//    ChatTableCell *cell = (ChatTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil) {
//        cell = [[ChatTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
//  }

    static NSString *CellIdentifier;
    
    CellIdentifier = [NSString stringWithFormat:@"MessageCellIdentifier %lu,%lu", (unsigned long)[indexPath indexAtPosition:0], (unsigned long)[indexPath indexAtPosition:1]];
    
    ChatTableCell *cell = (ChatTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[ChatTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
 
    if([arrChatList count] > 0)
    {
        NSString *UserId;
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        if([st objectForKey:@"UserId"])
        {
            UserId = [st objectForKey:@"UserId"];
        }
        NSString *sender;
        if([UserId isEqualToString:[s objectForKey:@"UserId"]])
        {
            sender = @"You";
        }
        
        //Message
        message = [s objectForKey:@"Msg"];
        NSLog(@"msg --- >  %@", message);
        
        //Time
        NSString *str = [NSString stringWithFormat:@"%@", [s objectForKey:@"Time"]];
        if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str] isEqualToString:@""])
        {
            strJoinDate = [[Singleton sharedSingleton] ConvertMilliSecIntoDate:str Format:@"MMM dd, yyyy hh:mm a"];
        }
        
//        str = [str substringToIndex:[str length]- 2];
//        NSArray *arr = [str componentsSeparatedByString:@"("];
//        
//        if([arr count] > 0)
//        {
//            str = [arr objectAtIndex:1];
//            joinDate = [NSDate dateWithTimeIntervalSince1970:[[arr objectAtIndex:1] doubleValue]/1000];
//            NSDateFormatter *format = [[NSDateFormatter alloc] init];
//            [format setDateFormat:@"MMM dd, yyyy hh:mm a"];
//            strJoinDate = [format stringFromDate:joinDate];
//        }
        
        CGSize size;
        if(IS_IPAD)
        {
            CGSize textSize = { 310.0, 20000.0 };
            size = [message sizeWithFont:[UIFont fontWithName:@"OpenSans-Light" size:13]
                       constrainedToSize:textSize
                           lineBreakMode:NSLineBreakByWordWrapping];
        }
        else
        {
            CGSize textSize = { 310.0, 20000.0 };
            size = [message sizeWithFont:[UIFont fontWithName:@"OpenSans-Light" size:13]
                       constrainedToSize:textSize
                           lineBreakMode:NSLineBreakByWordWrapping];
        }
        
        //	size.width += (padding/2);
        
        if(IS_IPAD)
            size.width = 700;
        else
            size.width = 280;
        
        //cell.messageContentView.text = message;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = NO;
        
        
        NSDictionary *dict = (NSDictionary *)[arrChatList objectAtIndex:indexPath.row];
        NSString *strSize = [dict objectForKey:@"sizeOfMessage"];
        sizeDynamic = CGSizeFromString(strSize);
        
        cell.messageContentView.backgroundColor = [UIColor clearColor];
        cell.messageContentView.font = [UIFont fontWithName:@"OpenSans-Light" size:13];// [UIFont systemFontOfSize:13];
        cell.messageContentView.editable = NO;
        cell.messageContentView.textAlignment = NSTextAlignmentRight;
        //		messageContentView.scrollEnabled = NO;
        [cell.messageContentView sizeToFit];
        
        if ([sender isEqualToString:@"You"])
        {
            
            //        // right aligned
            //        bgImage = [[UIImage imageNamed:@"aqua-right.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
            //
            //        if(IS_IPAD)
            //            [cell.messageContentView setFrame:CGRectMake(25,  2, IPAD_MESSGAE_WIDTH, sizeDynamic.height+padding+5)];
            //        else
            //            [cell.messageContentView setFrame:CGRectMake(25,  2, IPHONE_MESSGAE_WIDTH, sizeDynamic.height+padding+5)];
            //
            //        [cell.bgImageView setFrame:CGRectMake(20, 0, size.width+padding,  sizeDynamic.height+padding+5)];
            
            
            // right aligned
            bgImage = [[UIImage imageNamed:@"aqua-right.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
            [cell.bgImageView setFrame:CGRectMake(20, 0, size.width+padding,  sizeDynamic.height+padding+10)];
            
            [cell.senderAndTimeLabel setFrame:CGRectMake(28,  2, 70, 50)];
            [cell.senderAndTimeLabel setTextAlignment:NSTextAlignmentLeft];
            
            
            if(IS_IPAD)
                [cell.messageContentView setFrame:CGRectMake(cell.senderAndTimeLabel.frame.origin.x + cell.senderAndTimeLabel.frame.size.width +5,  6, IPAD_MESSGAE_WIDTH, sizeDynamic.height+padding+5)];
            else
                [cell.messageContentView setFrame:CGRectMake(cell.senderAndTimeLabel.frame.origin.x + cell.senderAndTimeLabel.frame.size.width +2,  6, IPHONE_MESSGAE_WIDTH, sizeDynamic.height+padding+5)];
            
            [cell.messageContentView setTextAlignment:NSTextAlignmentRight];
            
        }
        else
        {
            //        bgImage = [[UIImage imageNamed:@"aqua-gray.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
            //		if(IS_IPAD)
            //        {
            //            [cell.messageContentView setFrame:CGRectMake(25,  0, IPAD_MESSGAE_WIDTH, sizeDynamic.height+padding+5)];
            //        }
            //        else
            //        {
            //            [cell.messageContentView setFrame:CGRectMake(25,  0, IPHONE_MESSGAE_WIDTH, sizeDynamic.height+padding+5)];
            //        }
            //        [cell.bgImageView setFrame:CGRectMake(20, 0, size.width+padding,  sizeDynamic.height+padding+5)];
            
            
            //
            bgImage = [[UIImage imageNamed:@"aqua-gray.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
            [cell.bgImageView setFrame:CGRectMake(20, 0, size.width+padding,  sizeDynamic.height+padding+10)];
            
            //cell.messageContentView.text = message;
            if(IS_IPAD)
            {
                [cell.messageContentView setFrame:CGRectMake(50,  6, IPAD_MESSGAE_WIDTH, sizeDynamic.height+padding+5)];
            }
            else
            {
                [cell.messageContentView setFrame:CGRectMake(45,  6, IPHONE_MESSGAE_WIDTH, sizeDynamic.height+padding+5)];
            }
            [cell.messageContentView setTextAlignment:NSTextAlignmentLeft];
            
            
            [cell.senderAndTimeLabel setFrame:CGRectMake(cell.messageContentView.frame.origin.x+cell.messageContentView.frame.size.width+2,  2, 70, 50)];
            [cell.senderAndTimeLabel setTextAlignment:NSTextAlignmentRight];
            
        }
        cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@", strJoinDate]; //message; //
        
        cell.bgImageView.image = bgImage;
        
         cell.messageContentView.text = message; // [NSString stringWithFormat:@"%@", strJoinDate];; //
        
        NSLog(@"cell.messageContentView.text --- >  %@", cell.messageContentView.text);
    
    }
	   
	return cell;
}




#pragma mark UITEXTFIELD DELEGATE - HIDE KEYBOARD

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField== txtMessage)
    {
        CGRect _height=tblChat.frame;
        if(IS_IPAD)
        {
            _height.size.height=tblChat.frame.size.height-60;
            _height.origin.y=80;
            scrlPage.contentOffset=CGPointMake(0, 170);

            [tblChat setContentOffset:CGPointMake(0, 160)];
            
            
        }
        else if (IS_IPHONE_5)
        {
            _height.size.height=tblChat.frame.size.height-180;
            _height.origin.y=180;
            scrlPage.contentOffset=CGPointMake(0, 180);
            
            [tblChat setContentOffset:CGPointMake(0, 160)];
            
        }
        else
        {
            _height.size.height=tblChat.frame.size.height-176;
            _height.origin.y=176;
            scrlPage.contentOffset=CGPointMake(0, 170);
        }
        tblChat.frame=_height;
        if(tblChat.contentSize.height > (tblChat.frame.size.height-40))
        {
            CGPoint offset = CGPointMake(0, tblChat.contentSize.height - tblChat.frame.size.height);
            [tblChat setContentOffset:offset animated:YES];
        }
//        CGRect f = txtMessage.frame;
//        f.origin.y = tblChat.frame.origin.y + tblChat.frame.size.height + 10;
//        txtMessage.frame = f;
//        
//         f = btnSend.frame;
//        f.origin.y = tblChat.frame.origin.y + tblChat.frame.size.height + 10;
//        btnSend.frame = f;
        
    }
    return YES;
}
-(void)setTableKeyboardAfterMessageSend
{
    [txtMessage resignFirstResponder];
    scrlPage.contentOffset=CGPointMake(0, 0);
    
    CGRect _height=tblChat.frame;
    if(IS_IPAD)
    {
        NSLog(@"tblChat.frame.size.height : %f", tblChat.frame.size.height);
            _height.size.height=765;
            _height.origin.y=20;
        
        
//        _height.size.height=775;
//        _height.origin.y=20;
    }
    else if (IS_IPHONE_5)
    {
        _height.size.height=391;
        _height.origin.y=0;
    }
    else
    {
        _height.size.height=320;
        _height.origin.y=20;
    }
    
    
    tblChat.frame=_height;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField== txtMessage)
    {
        [self setTableKeyboardAfterMessageSend];
      
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField== txtMessage)
    {
        [self setTableKeyboardAfterMessageSend];
        
    }
}
//-(IBAction)hideKeyboard:(id)sender
-(void)hideKeyboard
{
    [self setTableKeyboardAfterMessageSend];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewWillDisappear:(BOOL)animated
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
}
@end
