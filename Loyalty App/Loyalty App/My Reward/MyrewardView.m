//
//  MyrewardView.m
//  Loyalty App
//
//  Created by Amit Parmar on 19/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "MyrewardView.h"
#import "RewardCell.h"
#import "Singleton.h"

#define NewProgram_WIDTH_IPAD 670
#define FONT_TEXTLABEL_IPAD  [UIFont fontWithName:@"OpenSans-Light" size:22] //[UIFont boldSystemFontOfSize:22]
#define FONT_DETAILTEXTLABEL_IPAD  [UIFont fontWithName:@"OpenSans-Light" size:18]//[UIFont systemFontOfSize:18]

#define NewProgram_WIDTH_IPHONE 300
#define FONT_TEXTLABEL_IPHONE  [UIFont fontWithName:@"OpenSans-Light" size:17]//[UIFont boldSystemFontOfSize:17]
#define FONT_DETAILTEXTLABEL_IPHONE  [UIFont fontWithName:@"OpenSans-Light" size:12]//[UIFont systemFontOfSize:12]

#define DIFFERENCE_CELLSPACING 48


@interface MyrewardView ()
@end

@implementation MyrewardView
@synthesize tblReward, fromWhere, RestaurantId;

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
    
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
//    self.lblTitleRewardList.font = FONT_centuryGothic_35;
   
    
    if([fromWhere isEqualToString:@"Dashboard"])
    {
        self.lblTitleRewardList.text=@"Reward List";
    }
    else if([fromWhere isEqualToString:@"HomeDelivery"])
    {
        self.lblTitleRewardList.text=@"Loyalty Points";
    }
    
    self.lblFullname.hidden = YES;
    self.lblPoints.hidden = YES;
    self.btnBgPoints.hidden = YES;
    
    self.btnBgPoints.layer.cornerRadius = 5.0;
    self.btnBgPoints.clipsToBounds = YES;
    
    self.arrRewardList = [[NSMutableArray alloc] init];
    
    self.tblReward.tableFooterView = [[UIView alloc] init];
    self.tblReward.hidden = YES;
   
    [self getRewardList];
    
    // Do any additional setup after loading the view from its nib.
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
-(void)getRewardList
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
        if([fromWhere isEqualToString:@"Dashboard"])
        {
            [dict setValue:userId forKey:@"UserId"];
        }
        else if([fromWhere isEqualToString:@"HomeDelivery"])
        {
            [dict setValue:RestaurantId forKey:@"RestaurantId"];
            [dict setValue:userId forKey:@"UserId"];
        }
        
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Reward offer List - - %@ -- ", dict);
             
             if (dict)
             {
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     if([self.arrRewardList count] == 0)
                     {
                         self.viewSeparator.hidden = YES;
                         CGRect f = self.tblReward.frame;
                         f.origin.y = 70;
                         self.tblReward.frame = f;
                     }
                     else
                     {
                         self.viewSeparator.hidden = NO;
                         CGRect f = self.tblReward.frame;
                         f.origin.y = self.viewSeparator.frame.origin.y+self.viewSeparator.frame.size.height+2;
                         self.tblReward.frame = f;
                     }
                     [self.arrRewardList removeAllObjects];
                     self.tblReward.hidden = NO;
                     [self.tblReward reloadData];
                 }
                 else
                 {
                     if([[dict objectForKey:@"data"] count] > 0)
                     {
                         //[self.arrRewardList addObject:[dict objectForKey:@"data"]];
                         self.arrRewardList = [dict objectForKey:@"data"];
                     }
                     [self getDynamicHeightofLabels];
                     [self setHeaderpartOfRewardList];
                     if([self.arrRewardList count] == 0)
                     {
                         self.viewSeparator.hidden = YES;
                         CGRect f = self.tblReward.frame;
                         f.origin.y = 70;
                         self.tblReward.frame = f;
                     }
                     else
                     {
                         self.viewSeparator.hidden = NO;
                         CGRect f = self.tblReward.frame;
                         f.origin.y = self.viewSeparator.frame.origin.y+self.viewSeparator.frame.size.height+2;
                         self.tblReward.frame = f;
                     }
                     self.tblReward.hidden = NO;
                     [self.tblReward reloadData];
                 }
                 [self stopActivity];
             }
             else
             {
                 [self.arrRewardList removeAllObjects];
                 self.tblReward.hidden = NO;
                 [self.tblReward reloadData];
                 
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
                 [self stopActivity];
             }
         } :@"Offers/RewardList" data:dict];
    }
}
-(void)saveRewardsOfUser:(int)tag CallFrom:(NSString*)callFrm
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
        [self startActivity];
        //UserId,ProgramId,ItemId
//        while Use Btn PurchaseItemID
//            N 4 Redeem FreeItemId
        
        NSString *iteId;
        if([callFrm isEqualToString:@"Used"])
        {
            iteId = [[self.arrRewardList objectAtIndex:tag] objectForKey:@"PurchaseItemId"];
        }
        else if([callFrm isEqualToString:@"Redeem"])
        {
            iteId = [[self.arrRewardList objectAtIndex:tag] objectForKey:@"FreeItemId"];
        }
        
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        NSString * userId ;
        if([st objectForKey:@"UserId"])
        {
            userId =  [st objectForKey:@"UserId"];
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:userId forKey:@"UserId"];
        [dict setValue:[[self.arrRewardList objectAtIndex:tag] objectForKey:@"ProgramId"] forKey:@"ProgramId"];
        [dict setValue:iteId forKey:@"ItemId"];
        [dict setValue:RestaurantId forKey:@"RestaurantId"];
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Save Reward offer List - - %@ -- ", dict);
             
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
                     if([[dict objectForKey:@"data"] count] > 0)
                     {
                         //[self.arrRewardList addObject:[dict objectForKey:@"data"]];
                         self.arrRewardList = [dict objectForKey:@"data"];
                     }
                     [self getDynamicHeightofLabels];
                     self.tblReward.hidden = NO;
                     [self.tblReward reloadData];
                 }
                 [self stopActivity];
             }
             else
             {
                 [self.arrRewardList removeAllObjects];
                 self.tblReward.hidden = NO;
                 [self.tblReward reloadData];
                 
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
                 [self stopActivity];
             }
         } :@"Offers/SaveRewards" data:dict];
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
-(void)setHeaderpartOfRewardList
{
    if([self.arrRewardList count] > 0)
    {
        self.lblFullname.hidden = NO;
//        self.lblPoints.hidden = NO;
//        self.btnBgPoints.hidden = NO;
        
        self.lblFullname.text = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@ %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[self.arrRewardList objectAtIndex:0] objectForKey:@"FirstName"]], [[Singleton sharedSingleton] ISNSSTRINGNULL:[[self.arrRewardList objectAtIndex:0] objectForKey:@"LastName"]]]];
        
//        self.lblPoints.text = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@", [[self.arrRewardList objectAtIndex:0] objectForKey:@"TotalPoints"]]];
    }
}
-(void)getDynamicHeightofLabels
{
    NSLog(@"---- %d ----",  [self.arrRewardList count]);
    
    if([self.arrRewardList count] > 0)
    {
        for(int i=0; i<[self.arrRewardList  count]; i++)
        {
            NSString *rName;
            NSArray *storenameArr = [[self.arrRewardList objectAtIndex:i] objectForKey:@"StoreName"];
            if([storenameArr count] > 0)
            {
                rName = [[Singleton sharedSingleton] ISNSSTRINGNULL:[storenameArr objectAtIndex:0]];
            }
           
            //  rName = @"ksdfj  djsgkl dfkjds gjdfjgkld ldjflgkj dlfgjkldj gkldfjklgjdfkl gkldfjgkljdfklgjkldjfgkl dklfjgkldfjgkljdklfjgkldfjgkljdfk dklfjgkldfjgkljdfklgjkldfjgkldfj gkdfjklgjdklgjkldf gkljdkl";
            
            
            //offer
            NSArray *p =  [[self.arrRewardList  objectAtIndex:i]objectForKey:@"PurchaseItemName"];
            NSString *pStr=@"";
            
            if(p== nil || p == [NSNull null])
            {
                NSLog(@"nil");
            }
            else
            {
                if([p count] > 0 )
                {
                    pStr = [p objectAtIndex:0];
                }
            }
            
            NSArray *f = [[self.arrRewardList  objectAtIndex:i]objectForKey:@"FreeItemName"];
            NSString *fStr=@"";
            
            if(f == nil || f == [NSNull null])
            {
                NSLog(@"nil");
            }
            else
            {
                if([f count] > 0 )
                {
                    fStr = [f objectAtIndex:0];
                }
            }
            
            NSString *strOffer = [NSString stringWithFormat:@"Buy %@ %@ Get %@ %@ Free", [[self.arrRewardList objectAtIndex:i]objectForKey:@"PurchaseQty"], pStr, [[self.arrRewardList objectAtIndex:i]objectForKey:@"FreeQty"],  fStr];
            
            //  strOffer = @"ksdfj  djsgkl dfkjds gjdfjgkld ldjflgkj dlfgjkldj gkldfjklgjdfkl gkldfjgkljdfklgjkldjfgkl dklfjgkldfjgkljdklfjgkldfjgkljdfk dklfjgkldfjgkljdfklgjkldfjgkldfj gkdfjklgjdklgjkldf gkljdkl";
            
            float h;
            CGSize aSize;
            if(IS_IPAD)
                aSize = CGSizeMake(NewProgram_WIDTH_IPAD, 20000);
            else
                aSize = CGSizeMake(NewProgram_WIDTH_IPHONE, 20000);
            
            NSMutableArray *tempArr = [self.arrRewardList objectAtIndex:i];
            
            UIFont *font;
            if(IS_IPAD)
                font = FONT_TEXTLABEL_IPAD;
            else
                font = FONT_TEXTLABEL_IPHONE;
            
            h = ceilf([[Singleton sharedSingleton] heightOfTextForLabel:rName andFont:font maxSize:aSize].height);
            [tempArr setValue:[NSString stringWithFormat:@"%f", h] forKey:@"HeightOfRestaurantName"];
            
            if(IS_IPAD)
                font = FONT_DETAILTEXTLABEL_IPAD;
            else
                font = FONT_DETAILTEXTLABEL_IPHONE;
            
            h = ceilf([[Singleton sharedSingleton]  heightOfTextForLabel:strOffer andFont:font maxSize:aSize].height);
            [tempArr setValue:[NSString stringWithFormat:@"%f", h] forKey:@"HeightOfOfferName"];
            [tempArr setValue:strOffer forKey:@"RewardFullName"];
            
            
            //Height of redeem
            //PurchaseQty
            int countPurchaseQty = [[[self.arrRewardList objectAtIndex:i]objectForKey:@"PurchaseQty"] intValue];
            
            
            //TotalPurchase
            int totalPItem;
            NSString *totalPurchaseItem = [[self.arrRewardList objectAtIndex:i]objectForKey:@"TotalPurchase"];
            @try {
                totalPurchaseItem = [[Singleton sharedSingleton] ISNSSTRINGNULL:totalPurchaseItem];
                if([totalPurchaseItem isEqualToString:@""])
                {
                    totalPItem = 0;
                }
                else
                {
                    totalPItem = [totalPurchaseItem intValue];
                }
                
            }
            @catch (NSException *exception) {
                totalPItem = [totalPurchaseItem intValue];
            }
           if(totalPItem >= countPurchaseQty)
           {
               h = 35;
           }
            else
            {
                h=0;
            }
            
            [tempArr setValue:[NSString stringWithFormat:@"%f", h] forKey:@"HeightOfRedeemName"];
            [tempArr setValue:[NSString stringWithFormat:@"%d", totalPItem] forKey:@"totalPItem"];
            [self.arrRewardList replaceObjectAtIndex:i withObject:tempArr];
        }
    }
}
#pragma mark TableView Delegate Method
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(IS_IOS_8)
    {
    if ([self.tblReward respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tblReward setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tblReward respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tblReward setLayoutMargins:UIEdgeInsetsZero];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.arrRewardList count] > 0)
    {
        return [self.arrRewardList count];
    }
    else
    {
        return  1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float h ;
    if([self.arrRewardList count] > 0)
    {
            return [[[self.arrRewardList  objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue] + DIFFERENCE_CELLSPACING + [[[self.arrRewardList  objectAtIndex:indexPath.row] objectForKey:@"HeightOfOfferName"] floatValue]
        + [[[self.arrRewardList  objectAtIndex:indexPath.row] objectForKey:@"HeightOfRedeemName"] floatValue];
    }
    else
    {
        return 50;
    }
    
    return h;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    if(IS_IPAD)
    {
         simpleTableIdentifier = @"RewardCell_iPad";
    }
    else
    {
        simpleTableIdentifier = @"RewardCell";
    }
    
    RewardCell *cell = (RewardCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if([self.arrRewardList count] == 0)
    {
        cell.lblRestaurantName.hidden = NO;
        cell.lblSpecialOffer.hidden  =YES;
        cell.btnOnlyUsed.hidden = YES;
        cell.btnOnlyRedeem.hidden = YES;
        cell.viewArrayOfBtnUsed.hidden = YES;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblRestaurantName.textAlignment = NSTextAlignmentCenter;
        cell.lblRestaurantName.text = @"Sorry, no rewards for you.";
        cell.userInteractionEnabled = NO;
        self.tblReward.userInteractionEnabled =  NO;
        self.tblReward.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        cell.lblRestaurantName.hidden = NO;
        cell.lblSpecialOffer.hidden  = NO;
        cell.btnOnlyUsed.hidden = NO;
        cell.btnOnlyUsed.hidden = NO;
        cell.viewArrayOfBtnUsed.hidden = NO;
        
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.lblRestaurantName.textAlignment = NSTextAlignmentLeft;
        self.tblReward.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        cell.userInteractionEnabled = YES;
        self.tblReward.userInteractionEnabled =  YES;
        
        CGRect ff = cell.lblRestaurantName.frame;
        ff.size.height = [[[self.arrRewardList  objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue];
         cell.lblRestaurantName.frame = ff;
        
        ff = cell.lblSpecialOffer.frame;
        ff.origin.y = cell.lblRestaurantName.frame.origin.y + cell.lblRestaurantName.frame.size.height + 3;
        ff.size.height = [[[self.arrRewardList objectAtIndex:indexPath.row] objectForKey:@"HeightOfOfferName"] floatValue];
        cell.lblSpecialOffer.frame = ff;
        
        ff = cell.viewArrayOfBtnUsed.frame;
        ff.origin.y = cell.lblSpecialOffer.frame.origin.y + cell.lblSpecialOffer.frame.size.height + 5;
       cell.viewArrayOfBtnUsed.frame = ff;
       
        ff = cell.btnOnlyUsed.frame;
        ff.origin.y = cell.lblSpecialOffer.frame.origin.y + cell.lblSpecialOffer.frame.size.height + 5;
        cell.btnOnlyUsed.frame = ff;
        
        NSArray *storenameArr = [[self.arrRewardList objectAtIndex:indexPath.row] objectForKey:@"StoreName"];
        if([storenameArr count] > 0)
        {
            cell.lblRestaurantName.text = [[Singleton sharedSingleton] ISNSSTRINGNULL:[storenameArr objectAtIndex:0]];
        }
        
        cell.lblSpecialOffer.text =  [[Singleton sharedSingleton] ISNSSTRINGNULL:[[self.arrRewardList objectAtIndex:indexPath.row] objectForKey:@"RewardFullName"]];
        
        
        //PurchaseQty
        int countPurchaseQty = [[[self.arrRewardList objectAtIndex:indexPath.row]objectForKey:@"PurchaseQty"] intValue];
         int countFreeQty = [[[self.arrRewardList objectAtIndex:indexPath.row]objectForKey:@"FreeQty"] intValue];
        
        //TotalPurchase
        int totalPItem = [[[self.arrRewardList objectAtIndex:indexPath.row]objectForKey:@"totalPItem"] intValue];
       
         //TotalFree
        int totalFItem;
        NSString *totalFreeItem = [[self.arrRewardList objectAtIndex:indexPath.row]objectForKey:@"TotalFree"];
        @try {
            totalFreeItem = [[Singleton sharedSingleton] ISNSSTRINGNULL:totalFreeItem];
            if([totalFreeItem isEqualToString:@""])
            {
                totalFItem = 0;
            }
            else
            {
                totalFItem = [totalFreeItem intValue];
            }
            
        }
        @catch (NSException *exception) {
            totalFItem = [totalFreeItem intValue];
        }

        
        cell.viewArrayOfbtnRedeem.hidden = YES;
        cell.btnOnlyRedeem.hidden = YES;
        
        cell.btnOnlyRedeem.layer.cornerRadius = 5.0;
        cell.btnOnlyRedeem.clipsToBounds = YES;
        cell.btnOnlyUsed.layer.cornerRadius = 5.0;
        cell.btnOnlyUsed.clipsToBounds = YES;
        
        cell.btnOnlyRedeem.tag = indexPath.row;
        cell.btnOnlyUsed.tag = indexPath.row;
        
        if([fromWhere isEqualToString:@"Dashboard"])
        {
          
        }
        else if([fromWhere isEqualToString:@"HomeDelivery"])
        {
            [cell.btnOnlyUsed addTarget:self action:@selector(btnUsedClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnOnlyRedeem addTarget:self action:@selector(btnRedeemClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        int cx=5;
        for(int i=0; i<countPurchaseQty; i++)
        {
            CGRect f = CGRectMake(cx, 2, 20, 20);
            UIButton *btn = [self createArrayOfButton:f];
            [cell.viewArrayOfBtnUsed addSubview:btn];
            
            if(totalPItem > i)
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"redem-dark.png"] forState:UIControlStateNormal];
            }
            else
            {
                
            }
            cx += 25;
        }
        
        if(totalPItem > 0)
        {
             [cell.btnOnlyUsed setTitle:@"Used" forState:UIControlStateNormal];
        }
        else
        {
            [cell.btnOnlyUsed setTitle:@"Use" forState:UIControlStateNormal];
        }
        
        
        cx=5;
        if(totalPItem == countPurchaseQty)
        {
            for(int j=0; j<countFreeQty; j++)
            {
                //NSLog(@" ---- %d", j);
                cell.viewArrayOfbtnRedeem.hidden = NO;
                cell.btnOnlyRedeem.hidden = NO;
                CGRect f = CGRectMake(cx, 2, 20, 20);
                UIButton *btn = [self createArrayOfButton:f];
                [cell.viewArrayOfbtnRedeem addSubview:btn];
                
                if(totalFItem > j)
                {
                    [btn setBackgroundImage:[UIImage imageNamed:@"redem-dark.png"] forState:UIControlStateNormal];
                }
                cx += 25;
            }
        }
        
        if([fromWhere isEqualToString:@"Dashboard"])
        {
                cell.btnOnlyUsed.backgroundColor = [UIColor whiteColor];
                cell.btnOnlyUsed.titleLabel.textColor = [UIColor blackColor];
                [cell.btnOnlyUsed setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                if(cell.btnOnlyRedeem.hidden)
//                {
//                    [cell.btnOnlyUsed setTitle:@"Use" forState:UIControlStateNormal];
//                }
//                else
//                {
//                    [cell.btnOnlyUsed setTitle:@"Used" forState:UIControlStateNormal];
//                }
                cell.btnOnlyUsed.userInteractionEnabled = NO;
                cell.btnOnlyUsed.enabled = NO;
           
                cell.btnOnlyRedeem.backgroundColor = [UIColor whiteColor];
                cell.btnOnlyRedeem.titleLabel.textColor = [UIColor blackColor];
                [cell.btnOnlyRedeem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [cell.btnOnlyRedeem setTitle:@"Redeem" forState:UIControlStateNormal];
                cell.btnOnlyRedeem.userInteractionEnabled = NO;
                cell.btnOnlyRedeem.enabled = NO;
           
        }
        else if([fromWhere isEqualToString:@"HomeDelivery"])
        {
            //check all items are used, then change layout of used button and stop user interaction
            if(countPurchaseQty == totalPItem)
            {
                cell.btnOnlyUsed.backgroundColor = [UIColor whiteColor];
                cell.btnOnlyUsed.titleLabel.textColor = [UIColor blackColor];
                [cell.btnOnlyUsed setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                if(cell.btnOnlyRedeem.hidden)
//                {
//                    [cell.btnOnlyUsed setTitle:@"Use" forState:UIControlStateNormal];
//                }
//                else
//                {
//                    [cell.btnOnlyUsed setTitle:@"Used" forState:UIControlStateNormal];
//                }
                
                cell.btnOnlyUsed.userInteractionEnabled = NO;
                cell.btnOnlyUsed.enabled = NO;
            }
            else
            {
                cell.btnOnlyUsed.userInteractionEnabled = YES;
                cell.btnOnlyUsed.enabled = YES;
            }
            //check all items are Redeem, then change layout of Redeem button and stop user interaction
            
            if(countFreeQty == totalFItem)
            {
                cell.btnOnlyRedeem.backgroundColor = [UIColor whiteColor];
                cell.btnOnlyRedeem.titleLabel.textColor = [UIColor blackColor];
                [cell.btnOnlyRedeem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [cell.btnOnlyRedeem setTitle:@"Redeem" forState:UIControlStateNormal];
                cell.btnOnlyRedeem.userInteractionEnabled = NO;
                cell.btnOnlyRedeem.enabled = NO;
            }
            else
            {
                cell.btnOnlyRedeem.userInteractionEnabled = YES;
                cell.btnOnlyRedeem.enabled = YES;
            }
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(UIButton*)createArrayOfButton:(CGRect )frame
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"redem-light.png"] forState:UIControlStateNormal];
    btn.frame = frame;
    return btn;
}
-(void)btnUsedClicked:(id)sender
{
    UIButton *btn=  (UIButton*)sender;
     [self saveRewardsOfUser:btn.tag CallFrom:@"Used"];
}
-(void)btnRedeemClicked:(id)sender
{
    UIButton *btn =  (UIButton*)sender;
    [self saveRewardsOfUser:btn.tag CallFrom:@"Redeem"];
}

@end
