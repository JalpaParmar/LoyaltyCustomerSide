//
//  LoyaltyProgramViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 8/13/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "LoyaltyProgramViewController.h"
#import "programCell.h"
#import "RestaurantJoinedViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Singleton.h"

#define NewProgram_WIDTH_IPAD 670
#define NewProgram_WIDTH_IPHONE 230
#define FONT_RESTAURANTNAME_IPAD   [UIFont fontWithName:@"OpenSans-Light" size:20]//[UIFont boldSystemFontOfSize:20]
#define FONT_RESTAURANTNAME_IPHONE   [UIFont fontWithName:@"OpenSans-Light" size:17]//[UIFont boldSystemFontOfSize:17]
#define FONT_OFFERNAME_IPAD   [UIFont fontWithName:@"OpenSans-Light" size:15]//[UIFont systemFontOfSize:15]
#define FONT_OFFERNAME_IPHONE   [UIFont fontWithName:@"OpenSans-Light" size:13]//[UIFont systemFontOfSize:13]
#define JOIN_DATE_HEIGHT 35;
#define DIFFERENCE_CELLSPACING 30

@interface LoyaltyProgramViewController ()
@end

@implementation LoyaltyProgramViewController

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
    app._flagMainBtn = 3;
    
    [self.view addSubview:[app setMyLoyaltyTopPart]];
    app._flagMyLoyaltyTopButtons = 4;

    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    self.tblMyProgramList.allowsMultipleSelectionDuringEditing = NO;

    self.tblMyProgramList.hidden  =YES;
    self.tblMyProgramList.tableFooterView = [[UIView alloc] init];
    
    arrProgramList = [[NSMutableArray alloc] init];
    [self getMyLoyaltyProgramList:@"Offers/JoinProgramList"];
    
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
-(void)getMyLoyaltyProgramList:(NSString*)strURL
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
            if([strURL isEqualToString:@"Offers/JoinProgramList"])
            {
                
            }
            else if([strURL isEqualToString:@"Offers/RemoveJoinProgram"])
            {
                [dict setValue:ProgramId forKey:@"ProgramId"];
            }
        
            [dict setValue:userId forKey:@"UserId"];
        
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 NSLog(@"My Program List - - %@ -- ", dict);
                 
                 if (dict)
                 {
                     [self stopActivity];
                     Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                     if (!strCode)
                     {
                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alt show];
                         self.tblMyProgramList.hidden = NO;
                         [self.tblMyProgramList reloadData];
                     }
                     else
                     {
                         [arrProgramList removeAllObjects];
                         
                         if([[dict objectForKey:@"data"] count] > 0)
                         {
                             [arrProgramList addObject:[dict objectForKey:@"data"]];
                             
//                             for(int i=0; i<[[dict objectForKey:@"data"] count]; i++)
//                             {
//                                 [arrProgramList addObject: [[dict objectForKey:@"data"] objectAtIndex:i]];
//                             }
                         }
                         [self getDynamicHeightofLabels];
                         [[Singleton sharedSingleton] setarrRestaurantList:[dict objectForKey:@"data"]];
                         self.tblMyProgramList.hidden = NO;
                         [self.tblMyProgramList reloadData];
                     }
                 }
                 else
                 {
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     [self stopActivity];
                 }
             } :strURL data:dict];
        
    }
}
-(void)getDynamicHeightofLabels
{
    NSLog(@"---- %d ----",  [arrProgramList count]);
  
    if([arrProgramList count] > 0)
    {
        for(int i=0; i<[[arrProgramList objectAtIndex:0] count]; i++)
        {
            NSString *rName =[[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@", [[[arrProgramList objectAtIndex:0] objectAtIndex:i]objectForKey:@"StoreName"]]] ;
            //rName = @"ksdfj  djsgkl dfkjds gjdfjgkld ldjflgkj dlfgjkldj gkldfjklgjdfkl gkldfjgkljdfklgjkldjfgkl dklfjgkldfjgkljdklfjgkldfjgkljdfk dklfjgkldfjgkljdfklgjkldfjgkldfj gkdfjklgjdklgjkldf gkljdkl";
            
            
            //offer
            NSArray *p =  [[[arrProgramList objectAtIndex:0] objectAtIndex:i]objectForKey:@"PurchaseItemName"];// [NSArray arrayWithObject: [[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"PurchaseItemName"]];
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
            
            NSArray *f = [[[arrProgramList objectAtIndex:0] objectAtIndex:i]objectForKey:@"FreeItemName"];
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
            NSString *strOffer = [NSString stringWithFormat:@"Buy %@ %@ Get %@ %@ Free", [[[arrProgramList objectAtIndex:0] objectAtIndex:i]objectForKey:@"PurchaseQty"], pStr,[[[arrProgramList objectAtIndex:0] objectAtIndex:i]objectForKey:@"FreeQty"],  fStr];
         //   strOffer = @"ksdfj  djsgkl dfkjds gjdfjgkld ldjflgkj dlfgjkldj gkldfjklgjdfkl gkldfjgkljdfklgjkldjfgkl dklfjgkldfjgkljdklfjgkldfjgkljdfk dklfjgkldfjgkljdfklgjkldfjgkldfj gkdfjklgjdklgjkldf gkljdkl";
            
            
            float h;
            CGSize aSize;
            if(IS_IPAD)
                aSize = CGSizeMake(NewProgram_WIDTH_IPAD, 20000);
            else
                aSize = CGSizeMake(NewProgram_WIDTH_IPHONE, 20000);
            
            NSMutableArray *tempArr = [[arrProgramList objectAtIndex:0] objectAtIndex:i];
            
            UIFont *font;
            if(IS_IPAD)
                font = FONT_RESTAURANTNAME_IPAD;
            else
                font = FONT_RESTAURANTNAME_IPHONE;
            
            h = ceilf([[Singleton sharedSingleton] heightOfTextForLabel:rName andFont:font maxSize:aSize].height);
            [tempArr setValue:[NSString stringWithFormat:@"%f", h] forKey:@"HeightOfRestaurantName"];
            
            if(IS_IPAD)
                font = FONT_OFFERNAME_IPAD;
            else
                font = FONT_OFFERNAME_IPHONE;
            
            h = ceilf([[Singleton sharedSingleton] heightOfTextForLabel:strOffer andFont:font maxSize:aSize].height);
            [tempArr setValue:[NSString stringWithFormat:@"%f", h] forKey:@"HeightOfOfferName"];
            [tempArr setValue:strOffer forKey:@"ProgramFullName"];
            [[arrProgramList objectAtIndex:0] replaceObjectAtIndex:i withObject:tempArr];
        }
    }
}

- (IBAction)btnbackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark TableView Delegate Method
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(IS_IOS_8)
    {
    if ([self.tblMyProgramList respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tblMyProgramList setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tblMyProgramList respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tblMyProgramList setLayoutMargins:UIEdgeInsetsZero];
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
    CGFloat rotationAngleDegrees = 40; //90
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    CGPoint offsetPositioning = CGPointMake(-200, -20);
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    
    
    UIView *card = [cell contentView];
    card.layer.transform = transform;
    card.layer.opacity = 0.8;
    
    
    
    [UIView animateWithDuration:0.7f animations:^{
        card.layer.transform = CATransform3DIdentity;
        card.layer.opacity = 1;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([arrProgramList count] > 0)
    {
        return [[arrProgramList objectAtIndex:0] count];
    }
    else
    {
        return 1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    return 80;
    
    float h ;
    if([arrProgramList count] > 0)
    {
        NSLog(@"------ %f", ([[[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue] + 27 + [[[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfOfferName"] floatValue] + 30 ));
        if(IS_IPAD)
        {
            return [[[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue] + DIFFERENCE_CELLSPACING + [[[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfOfferName"] floatValue] + JOIN_DATE_HEIGHT + 5;
            
        }
        else
        {
             return [[[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue] + DIFFERENCE_CELLSPACING + [[[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfOfferName"] floatValue] + JOIN_DATE_HEIGHT ;
        }
       
    }
    else
    {
        return 90;
    }
    
    return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    
    if(IS_IPAD)
        simpleTableIdentifier = @"programCell_iPad";
    else
        simpleTableIdentifier = @"programCell";
    
    
    programCell *cell = (programCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.btnJoin.hidden=YES;
    cell.btnRate.layer.cornerRadius=5.0;
    cell.btnRate.clipsToBounds=YES;
    cell.btnMore.hidden =YES;
    cell.btnMore.layer.cornerRadius=5.0;
    cell.btnMore.clipsToBounds=YES;
    
    if([arrProgramList count] == 0)
    {
//        cell.textLabel.hidden = NO;
//        cell.textLabel.text = @"No program Found.";
        
        CGRect f = cell.lblRestaurantName.frame;
        f.size.width = self.view.frame.size.width;
        cell.lblRestaurantName.frame = f;
        
        cell.lblRestaurantName.text = @"No program Found.";
        cell.lblRestaurantName.textAlignment = NSTextAlignmentCenter;
        
        cell.lblOfferDetail.hidden = YES;
        cell.lblJoinedDate.hidden = YES;
        cell.lblDistance.hidden = YES;
        cell.btnRate.hidden = YES;
        cell.btnMore.hidden =YES;
        
        self.tblMyProgramList.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tblMyProgramList.userInteractionEnabled = NO;
    }
    else
    {
        CGRect ff = cell.lblRestaurantName.frame;
        ff.size.height = [[[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue];
        ff.size.width = self.view.frame.size.width - 100;
        cell.lblRestaurantName.frame = ff;
        
        ff = cell.lblOfferDetail.frame;
        ff.origin.y = cell.lblRestaurantName.frame.origin.y + cell.lblRestaurantName.frame.size.height + 5;
        ff.size.height = [[[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfOfferName"] floatValue];
        cell.lblOfferDetail.frame = ff;
        
        ff = cell.lblJoinedDate.frame;
        ff.origin.y = cell.lblOfferDetail.frame.origin.y + cell.lblOfferDetail.frame.size.height + 5;
        cell.lblJoinedDate.frame = ff;

        ff = cell.lblDistance.frame;
        ff.origin.y = cell.lblOfferDetail.frame.origin.y;
        cell.lblDistance.frame = ff;
        
        ff = cell.btnRate.frame;
        ff.origin.y = cell.lblRestaurantName.frame.origin.y;
        cell.btnRate.frame = ff;
        
        ff = cell.btnMore.frame;
        ff.origin.x = cell.lblOfferDetail.frame.origin.x;
        ff.origin.y = cell.lblOfferDetail.frame.origin.y + cell.lblOfferDetail.frame.size.height + 5;
        cell.btnMore.frame = ff;
        
        cell.lblOfferDetail.hidden = NO;
        cell.lblJoinedDate.hidden = NO;
        cell.lblDistance.hidden = NO;
        cell.btnRate.hidden = NO;
        cell.btnMore.hidden =NO;
        
        cell.lblRestaurantName.textAlignment = NSTextAlignmentLeft;
         self.tblMyProgramList.userInteractionEnabled = YES;
        
        self.tblMyProgramList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        //StoreName
        cell.lblRestaurantName.text = [NSString stringWithFormat:@"%@", [[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"StoreName"]];
        
        //offer
        cell.lblOfferDetail.text = [NSString stringWithFormat:@"%@", [[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"ProgramFullName"]];;
        
        
        //rating
        NSString *rRating;
        NSArray *arrRating =[ [[arrProgramList objectAtIndex:0]  objectAtIndex:indexPath.row] objectForKey:@"restaurantRating"];
        if([arrRating count] > 0)
        {
            rRating = [[Singleton sharedSingleton] getReviewFromGLobalArray:arrRating];
            if([[rRating stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"0"])
            {
                cell.btnRate.hidden = YES;
                cell.btnStart.hidden=YES;
            }
            [cell.btnRate setTitle:[NSString stringWithFormat:@"  %@", rRating]  forState:UIControlStateNormal];
           
            
        }else
        {
            cell.btnRate.hidden = YES;
            cell.btnStart.hidden=YES;
//            [cell.btnRate setTitle:@"0"  forState:UIControlStateNormal];
            
        }
        
        
        
//        [cell.btnRate setTitle:[NSString stringWithFormat:@"%@", [[[[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"restaurantRating"] objectAtIndex:0] objectForKey:@"OrderRating"]] forState:UIControlStateNormal];
        
        
        //Distance
        //Distance
        double lat, lon;
        @try {
            lat = [[[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"Latidute"] doubleValue];
            lon =  [[[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"Longitude"] doubleValue];
            
        }
        @catch (NSException *exception) {
            lat =  0;
            lon =  0;
        }
        NSString *distacne = [[Singleton sharedSingleton] getDistanceBetweenLocations:lat Lon:lon Aontherlat:app.lat AnotheLong:app.lon];
        cell.lblDistance.text =[NSString stringWithFormat:@"%@",distacne];
        
        
        //JoinDate = "/Date(1408365730630)/";
        NSString *str = [NSString stringWithFormat:@"%@", [[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"EndDate"]];
        NSString *strJoinDate=@"";
        if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str] isEqualToString:@""])
        {
            strJoinDate = [[Singleton sharedSingleton] ConvertMilliSecIntoDate:str Format:@"dd MMMM yyyy"];
        }
        cell.lblJoinedDate.text = [NSString stringWithFormat:@"End Date  %@", strJoinDate];

//        str = [str substringToIndex:[str length]- 2];
//        NSArray *arr = [str componentsSeparatedByString:@"("];
//        NSDate *joinDate;
//        NSString *strJoinDate=@"";
//        if([arr count] > 0)
//        {
//            str = [arr objectAtIndex:1];
//            joinDate = [NSDate dateWithTimeIntervalSince1970:[[arr objectAtIndex:1] doubleValue]/1000];
//            NSDateFormatter *format = [[NSDateFormatter alloc] init];
//            [format setDateFormat:@"dd MMMM yyyy"];
//            strJoinDate = [format stringFromDate:joinDate];
//       }
//        cell.lblJoinedDate.text = [NSString stringWithFormat:@"End Date  %@", strJoinDate];

        //More
        cell.btnMore.tag = indexPath.row;
        [cell.btnMore addTarget:self action:@selector(moreClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [swipeLeft setDirection:(UISwipeGestureRecognizerDirectionLeft )];
        [cell addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture_right:)];
        [swipeRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [cell addGestureRecognizer:swipeRight];

        
    }
      [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:cell.contentView andSubViews:YES];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantJoinedViewController *join;
    if (IS_IPHONE_5)
    {
        join=[[RestaurantJoinedViewController alloc] initWithNibName:@"RestaurantJoinedViewController-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        join=[[RestaurantJoinedViewController alloc] initWithNibName:@"RestaurantJoinedViewController_iPad" bundle:nil];
    }
    else
    {
        join=[[RestaurantJoinedViewController alloc] initWithNibName:@"RestaurantJoinedViewController" bundle:nil];
    }
    join.arrRestaurantJoinDetail = arrProgramList;
//    join.arrRestaurantJoinDetail = [arrProgramList objectAtIndex:0] ;
    join.joinIndexId = indexPath.row;
    join._fromDetail=@"LoyaltyProgram";
    [self.navigationController pushViewController:join animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
   
        //Offers/RemoveJoinProgram
        ProgramId = [NSString stringWithFormat:@"%@", [[[arrProgramList objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"ProgramId"]];
        [self getMyLoyaltyProgramList:@"Offers/RemoveJoinProgram"];
        
        
//        [tableView beginUpdates];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [tableView endUpdates];
        
    }
}
-(void)moreClicked:(id)sender
{
    UIButton *b = (UIButton*)sender;
    RestaurantJoinedViewController *join;
    if (IS_IPHONE_5)
    {
        join=[[RestaurantJoinedViewController alloc] initWithNibName:@"RestaurantJoinedViewController-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        join=[[RestaurantJoinedViewController alloc] initWithNibName:@"RestaurantJoinedViewController_iPad" bundle:nil];
    }
    else
    {
        join=[[RestaurantJoinedViewController alloc] initWithNibName:@"RestaurantJoinedViewController" bundle:nil];
    }
    join.arrRestaurantJoinDetail = arrProgramList;
    //    join.arrRestaurantJoinDetail = [arrProgramList objectAtIndex:0] ;
    join.joinIndexId = b.tag;
    join._fromDetail=@"LoyaltyProgram";
    [self.navigationController pushViewController:join animated:YES];
   
}
-(void)handleGesture_right : (UIGestureRecognizer *)gec
{
    if (gec.state == UIGestureRecognizerStateEnded)
    {
        //        IS_ShowDeleteBtn =0;
        UITableViewCell *cell = (UITableViewCell *)gec.view;
        UITapGestureRecognizer *deleteCell = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(DeleteProgram:)];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(cell.frame.size.width+5, 10, 25, 25);
        [btn1 addGestureRecognizer:deleteCell];
        //[btn1 setBackgroundColor:[UIColor blackColor]];
        //[btn1 setTitle:@"Delete" forState:UIControlStateNormal];
        [btn1 setBackgroundColor:[UIColor redColor]];
        [btn1 setTitle:@"Delete" forState:UIControlStateNormal];
        btn1.titleLabel.textColor = [UIColor whiteColor];
        btn1.userInteractionEnabled = YES;

        [btn1 addTarget:self action:@selector(DeleteProgram:) forControlEvents:UIControlEventTouchUpInside];
        [cell bringSubviewToFront:btn1];
        

        
     
        [UIView animateWithDuration:0.5
                         animations:^(void){
                             //[cell addSubview:imgDelete];
                             [btn1 removeFromSuperview];
                           
                             CGRect f = cell.frame;
                             f.origin.x = 0;
                             f.size.width = 768;
                             cell.frame = f;
                             
                         }completion:nil];
        
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}
-(void)handleGesture : (UIGestureRecognizer *)gec
{
    if (gec.state == UIGestureRecognizerStateEnded)
    {
        //        IS_ShowDeleteBtn=1;
        UITableViewCell *cell = (UITableViewCell *)gec.view;
        UITapGestureRecognizer *deleteCell = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
        deleteCell.numberOfTapsRequired = 1;
        deleteCell.cancelsTouchesInView = NO;
        self.tblMyProgramList.canCancelContentTouches = NO;
        
        CGPoint swipeLocation = [gec locationInView:self.tblMyProgramList];
        NSIndexPath *swipedIndexPath = [self.tblMyProgramList indexPathForRowAtPoint:swipeLocation];
        //        UITableViewCell* swipedCell = [tblOrderDetail cellForRowAtIndexPath:swipedIndexPath];
        
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(cell.frame.size.width, cell.frame.origin.y, 90, cell.frame.size.height);
        [btn1 addGestureRecognizer:deleteCell];
        //[btn1 setBackgroundColor:[UIColor blackColor]];
        //[btn1 setTitle:@"Delete" forState:UIControlStateNormal];
        [btn1 setBackgroundColor:[UIColor redColor]];
        [btn1 setTitle:@"Delete" forState:UIControlStateNormal];
        btn1.titleLabel.textColor = [UIColor whiteColor];
        btn1.userInteractionEnabled = YES;
        btn1.tag = swipedIndexPath.row;
        [btn1 addTarget:self action:@selector(DeleteProgram:) forControlEvents:UIControlEventTouchUpInside];
        [cell bringSubviewToFront:btn1];
      
        [UIView animateWithDuration:0.5
                         animations:^(void){
                             //[cell addSubview:imgDelete];
                             [cell addSubview:btn1];
                            
                             CGRect f = cell.frame;
                             f.origin.x = -90;
                             f.size.width = 768;
                             cell.frame = f;
                         }completion:nil];
    }
}

-(IBAction)DeleteProgram:(id)sender
{
    UIButton *b = (UIButton*)sender;
    //Offers/RemoveJoinProgram
    ProgramId = [NSString stringWithFormat:@"%@", [[[arrProgramList objectAtIndex:0] objectAtIndex:b.tag]objectForKey:@"ProgramId"]];
    [self getMyLoyaltyProgramList:@"Offers/RemoveJoinProgram"];
}
-(void)actionTap:(id)sender
{
    //delete order
    
    /*
     strURL=@"Order/DeleteOrder";
     [self getOrderDetail];
     
     if([arrOrderDetail count] > 0)
     {
     if([[arrOrderDetail objectAtIndex:0] count] > 0)
     {
     if([[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"])
     {
     NSMutableArray *arr = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
     [arr removeObjectAtIndex:Con_Id];
     }
     }
     }
     NSLog(@" ****  %@", arrOrderDetail);
     if([arrOrderDetail count] > 0)
     {
     NSArray * tempArr = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
     if([tempArr count] <= 0)
     {
     BackButton
     }
     }
     */
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
