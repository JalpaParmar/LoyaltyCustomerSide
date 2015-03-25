//
//  SpecialOfferView.m
//  Loyalty App
//
//  Created by Amit Parmar on 19/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "SpecialOfferView.h"
#import "OfferCell.h"
#import "Singleton.h"
#import "RestaurantJoinedViewController.h"
#import "specialOfferDetailViewController.h"


#define NewProgram_WIDTH_IPAD 666
#define FONT_TEXTLABEL_IPAD [UIFont fontWithName:@"OpenSans-Light" size:20]// [UIFont boldSystemFontOfSize:20]
#define FONT_DETAILTEXTLABEL_IPAD [UIFont fontWithName:@"OpenSans-Light" size:17]// [UIFont systemFontOfSize:17]

#define NewProgram_WIDTH_IPHONE 245
#define FONT_TEXTLABEL_IPHONE [UIFont fontWithName:@"OpenSans-Light" size:16]// [UIFont boldSystemFontOfSize:16]
#define FONT_DETAILTEXTLABEL_IPHONE [UIFont fontWithName:@"OpenSans-Light" size:14]// [UIFont systemFontOfSize:14]

#define DIFFERENCE_CELLSPACING  30 //25 //17


@interface SpecialOfferView ()
@end

@implementation SpecialOfferView
@synthesize tblOffer;
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

//    self.lblTitleSpecialOffer.font = FONT_centuryGothic_35;
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    btnNearBySearch.layer.cornerRadius = 5.0;
    btnNearBySearch.clipsToBounds = YES;
    
    btnFilterBySearch.layer.cornerRadius = 5.0;
    btnFilterBySearch.clipsToBounds = YES;

//    if(!IS_IPAD)
//    {
//        btnFilterBySearch.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        btnFilterBySearch.titleLabel.textAlignment = NSTextAlignmentCenter;
//        
//        btnNearBySearch.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        btnNearBySearch.titleLabel.textAlignment = NSTextAlignmentCenter;
//        
//        [btnNearBySearch setTitle:@"Search Nearby" forState:UIControlStateNormal];
//        [btnFilterBySearch setTitle:@"Search By\nFilter" forState:UIControlStateNormal];
//    }
    
    tblOffer.tableFooterView = [[UIView alloc] init];
    self.tblOffer.hidden = YES;
    
    arrSpecialOffer = [[NSMutableArray alloc] init];
    

    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    NSLog(@"UserId : %@", [st objectForKey:@"UserId"]);
   
    if(![st objectForKey:@"UserId"])
    {
        self.btnQRCodeSearch.hidden = YES;
    }
    else
    {
        self.btnQRCodeSearch.hidden = NO;
    }

    
    [self getSpecialOfferList];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark Button Click Event

- (IBAction)btnQRCodeClicked:(id)sender
{
//    UIButton *btn = (UIButton*)sender;
    
    NSString *userId=@"";
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    if([st objectForKey:@"UserId"])
    {
        userId = [st objectForKey:@"UserId"];
    }
    
    if([st objectForKey:@"UfId"])
    {
        self.lblQRCode.text = [NSString stringWithFormat:@"%@", [st objectForKey:@"UfId"]];
    }
    else
    {
      self.lblQRCode.text = [NSString stringWithFormat:@"%@", userId];
    }
    
    
    self.btnQRCode.userInteractionEnabled = NO;
    [self.btnQRCode setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
    // QR CODE
    dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.myCompanyName.imagegrabber.bgqueue", NULL);
    dispatch_async(backgroundQueue, ^(void) {
      
        // QRCode Image
     
        NSString *imageName = [NSString stringWithFormat:@"https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=%@&choe=UTF-8", userId];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if(image == nil)
            {
                [self.btnQRCode setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
            }
            else
            {
                [self.btnQRCode setBackgroundImage:image forState:UIControlStateNormal];
            }
        });
    });
    
    if(IS_IPAD)
    {
        [self.view addSubview:self.btnBG];
        
        [self.viewQRCode setFrame:CGRectMake(0, 300, self.viewQRCode.frame.size.width, self.viewQRCode.frame.size.height)];
        
        [self.view addSubview:self.viewQRCode];
        
    }
    else
    {
        [self.view addSubview:self.btnBG];
        if (IS_IPHONE_5)
        {
            [self.viewQRCode setFrame:CGRectMake(0, 100, self.viewQRCode.frame.size.width, self.viewQRCode.frame.size.height)];
        }
        else
        {
            [self.viewQRCode setFrame:CGRectMake(0, 70, self.viewQRCode.frame.size.width, self.viewQRCode.frame.size.height)];
        }
        [self.view addSubview:self.viewQRCode];
    }
}
- (IBAction)hideParentView:(id)sender
{
    [self.btnBG removeFromSuperview];
    [self.viewQRCode removeFromSuperview];
}
- (IBAction)btnCloseClicked:(id)sender {
    [self.btnBG removeFromSuperview];
    [self.viewQRCode removeFromSuperview];
}
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
-(void)getSpecialOfferList
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
       [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
//        app.lat = 10.52;
//        app.lon = 12.22;
//        app.lat = 23.028713; //10.52;
//        app.lon = 72.506740; //12.22;
        
            [self startActivity];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            if(app.lat == 0 && app.lon == 0)
            {
                //gps off
                NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
                NSDictionary *userLoc=[st objectForKey:@"userLocation"];
                NSLog(@"lat %@",[userLoc objectForKey:@"lat"]);
                NSLog(@"long %@",[userLoc objectForKey:@"long"]);
                
                [dict setValue:[userLoc objectForKey:@"lat"]  forKey:@"Latidute"];
                [dict setValue:[userLoc objectForKey:@"long"]   forKey:@"Longitude"];
                if([st objectForKey:@"SelectedRange"])
                {
                    [dict setValue:[st objectForKey:@"SelectedRange"]   forKey:@"Range"];
                }
                else
                {
                    [dict setValue:@"100"  forKey:@"Range"];
                }
                
//                NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
//                if([st objectForKey:@"UserSelectedCountry"])
//                {
//                    [dict setValue:[st objectForKey:@"UserSelectedCountry"]   forKey:@"CountryId"];
//                }
//                if([st objectForKey:@"UserSelectedState"])
//                {
//                    [dict setValue:[st objectForKey:@"UserSelectedState"]   forKey:@"StateId"];
//                }
//                if([st objectForKey:@"UserSelectedCity"])
//                {
//                    [dict setValue:[st objectForKey:@"UserSelectedCity"]   forKey:@"City"];
//                }
                
            }
            else
            {
                if(btnFilterBySearch.tag == 1111)
                {
                    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
                    NSDictionary *userLoc=[st objectForKey:@"userLocation"];
                    NSLog(@"lat %@",[userLoc objectForKey:@"lat"]);
                    NSLog(@"long %@",[userLoc objectForKey:@"long"]);
                    
                    [dict setValue:[userLoc objectForKey:@"lat"]  forKey:@"Latidute"];
                    [dict setValue:[userLoc objectForKey:@"long"]   forKey:@"Longitude"];
                    if([st objectForKey:@"SelectedRange"])
                    {
                        [dict setValue:[st objectForKey:@"SelectedRange"]   forKey:@"Range"];
                    }
                    else
                    {
                        [dict setValue:@"100"  forKey:@"Range"];
                    }
                }
                else
                {
                    //just show rest list
                    [dict setValue:[NSNumber numberWithDouble:app.lat] forKey:@"Latidute"];
                    [dict setValue:[NSNumber numberWithDouble:app.lon]   forKey:@"Longitude"];
                    [dict setValue:@"100"  forKey:@"Range"];
                }
            }
        
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 NSLog(@"Spcial offer List - - %@ -- ", dict);
                 
                 if (dict)
                 {
                     [self stopActivity];
                     Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                     if (!strCode)
                     {
                         NSString *msg = [NSString stringWithFormat:@"%@", [dict objectForKey:@"message"]];
                         
                         if([msg rangeOfString:@"required"].location != NSNotFound)
                         {
                             UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                             [alt show];
                         }
                         else
                         {
                             [arrSpecialOffer removeAllObjects];
                             self.tblOffer.hidden = NO;
                             [self.tblOffer reloadData];
                         }
                     }
                     else
                     {
                         arrSpecialOffer = [[NSMutableArray alloc] init];
                         if([[dict objectForKey:@"data"] count] > 0)
                         {
                             [arrSpecialOffer addObject:[dict objectForKey:@"data"]];
                         }
                     
                         [self getDynamicHeightofLabels];
                         self.tblOffer.hidden = NO;
                         [self.tblOffer reloadData];
                     }
                 }
                 else
                 {
                     [arrSpecialOffer removeAllObjects];
                     self.tblOffer.hidden = NO;
                     [self.tblOffer reloadData];
                     
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     [self stopActivity];
                 }
                 btnFilterBySearch.tag = 0;
             } :@"Offers/SpecialOffersList" data:dict];
        
    }
}
- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getDynamicHeightofLabels
{
    NSLog(@"---- %lu ----",  (unsigned long)[arrSpecialOffer count]);

    if([arrSpecialOffer count] > 0)
    {
        for(int i=0; i<[[arrSpecialOffer objectAtIndex:0] count]; i++)
        {
             NSString *rName =[[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@", [[[arrSpecialOffer objectAtIndex:0] objectAtIndex:i]objectForKey:@"StoreName"]]];
            //  rName = @"ksdfj  djsgkl dfkjds gjdfjgkld ldjflgkj dlfgjkldj gkldfjklgjdfkl gkldfjgkljdfklgjkldjfgkl dklfjgkldfjgkljdklfjgkldfjgkljdfk dklfjgkldfjgkljdfklgjkldfjgkldfj gkdfjklgjdklgjkldf gkljdkl";
            
            
            //offer
           NSArray *arr = [[[arrSpecialOffer objectAtIndex:0] objectAtIndex:i]objectForKey:@"ItemNameTxt"];
           NSString *itemName;
           if([arr count] > 0)
           {
               itemName = [arr objectAtIndex:0];
           }
           
          NSString *strShortOffer = [NSString stringWithFormat:@"%@", [[[arrSpecialOffer objectAtIndex:0] objectAtIndex:i]objectForKey:@"OfferName"]];
            
          NSString *strOffer = [NSString stringWithFormat:@"Get %@ %% On  %@", [[[arrSpecialOffer objectAtIndex:0] objectAtIndex:i]objectForKey:@"Discount"], [[Singleton sharedSingleton] ISNSSTRINGNULL:itemName]];
         //  strOffer = @"ksdfj  djsgkl dfkjds gjdfjgkld ldjflgkj dlfgjkldj gkldfjklgjdfkl gkldfjgkljdfklgjkldjfgkl dklfjgkldfjgkljdklfjgkldfjgkljdfk dklfjgkldfjgkljdfklgjkldfjgkldfj gkdfjklgjdklgjkldf gkljdkl";
            
            float h;
            CGSize aSize;
            if(IS_IPAD)
                aSize = CGSizeMake(NewProgram_WIDTH_IPAD, 20000);
            else
                aSize = CGSizeMake(NewProgram_WIDTH_IPHONE, 20000);
            
            NSMutableArray *tempArr = [[arrSpecialOffer objectAtIndex:0] objectAtIndex:i];
            
            //restan
            UIFont *font;
            if(IS_IPAD)
                font = FONT_TEXTLABEL_IPAD;
            else
                font = FONT_TEXTLABEL_IPHONE;
            
            h = [self heightOfTextForLabel:rName andFont:font maxSize:aSize];
            [tempArr setValue:[NSString stringWithFormat:@"%f", h] forKey:@"HeightOfRestaurantName"];
            
            //offer
            if(IS_IPAD)
                font = FONT_DETAILTEXTLABEL_IPAD;
            else
                font = FONT_DETAILTEXTLABEL_IPHONE;
           
            h = [self heightOfTextForLabel:strShortOffer andFont:font maxSize:aSize];
            [tempArr setValue:[NSString stringWithFormat:@"%f", h] forKey:@"HeightOfShortOfferName"];
            
            h = [self heightOfTextForLabel:strOffer andFont:font maxSize:aSize];
            [tempArr setValue:[NSString stringWithFormat:@"%f", h] forKey:@"HeightOfOfferName"];
            [tempArr setValue:strOffer forKey:@"ProgramFullName"];
            [[arrSpecialOffer objectAtIndex:0] replaceObjectAtIndex:i withObject:tempArr];
        }
    }
}

-(CGFloat)heightOfTextForLabel:(NSString *)aString andFont:(UIFont *)aFont maxSize:(CGSize)aSize
{
    // iOS7
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        CGSize sizeOfText = [aString boundingRectWithSize:aSize   options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)  attributes: [NSDictionary dictionaryWithObject:aFont  forKey:NSFontAttributeName] context: nil].size;
//        NSLog(@" IOS 7 : %@ : %f", aString, sizeOfText.height);
        return ceilf(sizeOfText.height);
    }
    
    // iOS6
    CGSize textSize = [aString sizeWithFont:aFont  constrainedToSize: aSize lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@" IOS 6 : %@ : %f", aString, textSize.height);
    return ceilf(textSize.height);
}
- (IBAction)btnFilterByClicked:(id)sender
{
    UIButton *b = (UIButton*)sender;
    if(b.tag == 0)
    {
        btnFilterBySearch.tag = 1111;
        CommonDelegateViewController *join;
        if (IS_IPHONE_5)
        {
            join=[[CommonDelegateViewController alloc] initWithNibName:@"CommonDelegateViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            join=[[CommonDelegateViewController alloc] initWithNibName:@"CommonDelegateViewController_iPad" bundle:nil];
        }
        else
        {
            join=[[CommonDelegateViewController alloc] initWithNibName:@"CommonDelegateViewController" bundle:nil];
        }
        join.delegate = self;
        [self.navigationController pushViewController:join animated:YES];
    }
    else
    {
        BOOL servicesEnabled = [CLLocationManager locationServicesEnabled];
        if(!servicesEnabled)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"\"Loyalty APP\" Would Like to Use Your Current Location" message:@"This will make it much easier for you to find out Restaurant nearby" delegate:self cancelButtonTitle:@"Don't Allow" otherButtonTitles:@"OK", nil];
            alert.tag = 15;
            [alert show];
        }
        else
        {
            [self getSpecialOfferList];
        }

    }
}
-(void)LocationSelectionDone:(NSMutableArray *)arrSelectionValue
{
    NSLog(@" *** LocationSelectionDone  called***");
    NSLog(@" *** arrSelectionValue : %@***", arrSelectionValue);
     [self.navigationController popViewControllerAnimated:YES];
    [self getSpecialOfferList];
}
-(void)BackFromSelectionView
{
    btnFilterBySearch.tag = 0;
    btnNearBySearch.tag = 1;

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark TableView Delegate Method
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(IS_IOS_8)
    {
    if ([self.tblOffer respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tblOffer setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tblOffer respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tblOffer setLayoutMargins:UIEdgeInsetsZero];
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
    if([arrSpecialOffer count] > 0)
    {
        return [[arrSpecialOffer objectAtIndex:0] count];
    }
    else
    {
        return  1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    return 80;
    
    float h ;
    if([arrSpecialOffer count] > 0)
    {
        if([[arrSpecialOffer objectAtIndex:0] count] > 0)
        {
            NSLog(@" %ld -- %f", (long)indexPath.row, [[[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue] + DIFFERENCE_CELLSPACING + [[[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfOfferName"] floatValue]);
            
            //90;
            return  [[[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue] + DIFFERENCE_CELLSPACING + [[[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfOfferName"] floatValue] + [[[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfShortOfferName"] floatValue] ;
        }
    }
    else
    {
        return 90;
    }
    
    return h;

}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        cell.textLabel.textColor=[UIColor colorWithRed:86.0/255.0 green:190.0/255.0 blue:15.0/255.0 alpha:1];
         cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        
       if(IS_IPAD)
       {
            cell.textLabel.font = [UIFont boldSystemFontOfSize:22];
            cell.detailTextLabel.font =  [UIFont systemFontOfSize:17];
       }
       else
       {
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
            cell.detailTextLabel.font =  [UIFont systemFontOfSize:14];
       }
       
        if([arrSpecialOffer count] == 0)
        {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        else{
          cell.textLabel.textAlignment = NSTextAlignmentLeft;  
        }
        
   }
    
    if([arrSpecialOffer count] == 0)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"No Special Offer found.";
        cell.userInteractionEnabled = NO;
        self.tblOffer.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
         cell.textLabel.textAlignment = NSTextAlignmentLeft;  
        self.tblOffer.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        cell.userInteractionEnabled = YES;
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"StoreName"]];
 
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@\n%@", [[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"OfferName"], [[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"ProgramFullName"]];
      
        BOOL checked;
        @try {
            checked = [[[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"Diamond"] boolValue];
        }
        @catch (NSException *exception) {
            checked = false;
        }
        
      
       UIImage *image = (checked) ? [UIImage imageNamed:@"diamond.png"] : [UIImage imageNamed:@"asdasd.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0.0, 0.0, 20, 20);
        button.frame = frame;
        [button setBackgroundImage:image forState:UIControlStateNormal];

        [button addTarget:self action:@selector(diamondButtonTapped:)  forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        cell.accessoryView = button;
        cell.accessoryView.hidden = NO;
        cell.accessoryView.userInteractionEnabled = YES;
        
        if([button.currentBackgroundImage isEqual:[UIImage imageNamed:@"asdasd.png"]])
        {
            cell.accessoryView.hidden = YES;
            cell.accessoryView.userInteractionEnabled = NO;
        }
        
    }
    return cell;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    if (IS_IPAD)
    {
        simpleTableIdentifier=@"OfferCell_iPad";
    }
    else
    {
        simpleTableIdentifier=@"OfferCell";
    }
    
    OfferCell *cell = (OfferCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if([arrSpecialOffer count] == 0)
    {
        cell.lblRestName.hidden=NO;
        cell.lblRestName.textAlignment = NSTextAlignmentCenter;
        cell.lblRestName.text = @"No Special Offer found.";
        cell.lblShortOfferName.hidden=YES;
        cell.btnRating.hidden=YES;
        cell.lblDistance.hidden=YES;
        cell.btnStartRate.hidden = YES;
        cell.lblOfferName.hidden=YES;
        cell.btnDiamond.hidden = YES;
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        tableView.userInteractionEnabled=NO;
        
        if(IS_IPAD)
        {
            CGRect f = cell.lblRestName.frame;
            f.size.width = 768;
            //f.size.height = 50;
            cell.lblRestName.frame = f;
        }
        else
        {
            CGRect f = cell.lblRestName.frame;
            f.size.width = 310;
            cell.lblRestName.frame = f;
        }
    }
    else
    {
        if(IS_IPAD)
        {
            CGRect f = cell.lblRestName.frame;
            f.size.width = 768 - 60;
            cell.lblRestName.frame = f;
        }
        else
        {
            CGRect f = cell.lblRestName.frame;
            f.size.width = 320 - 45;
            cell.lblRestName.frame = f;
            
        }
        
        cell.lblRestName.textAlignment = NSTextAlignmentLeft;
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        tableView.userInteractionEnabled=YES;
        
        cell.lblOfferName.hidden=NO;
        cell.lblRestName.hidden = NO;
        cell.btnRating.hidden=NO;
        cell.lblShortOfferName.hidden=NO;
        cell.lblDistance.hidden=NO;
        cell.btnStartRate.hidden = NO;

        CGRect ff = cell.lblRestName.frame;
        ff.size.height =[[[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfRestaurantName"] floatValue];
        cell.lblRestName.frame = ff;
        
        ff = cell.lblShortOfferName.frame;
        ff.origin.y = cell.lblRestName.frame.origin.y + cell.lblRestName.frame.size.height + 5;
        ff.size.height = [[[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfShortOfferName"] floatValue];
        cell.lblShortOfferName.frame = ff;
        
        ff = cell.lblOfferName.frame;
        ff.origin.y = cell.lblShortOfferName.frame.origin.y + cell.lblShortOfferName.frame.size.height + 5;
        ff.size.height = [[[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"HeightOfOfferName"] floatValue];
        cell.lblOfferName.frame = ff;
     
        ff = cell.btnRating.frame;
        ff.origin.y = cell.lblRestName.frame.origin.y;
        cell.btnRating.frame = ff;
        
        ff = cell.btnDiamond.frame;
        ff.origin.y = cell.lblShortOfferName.frame.origin.y;
        cell.btnDiamond.frame = ff;
        
        ff = cell.lblDistance.frame;
        ff.origin.y = cell.lblOfferName.frame.origin.y ;
        cell.lblDistance.frame = ff;
        
        
        //Res Name
        cell.lblRestName.text = [[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"StoreName"];
        
        //lblShortOfferName
        cell.lblShortOfferName.text = [NSString stringWithFormat:@"%@", [[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"OfferName"]] ;
        
        //lblOfferName
        cell.lblOfferName.text = [NSString stringWithFormat:@"%@", [[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"ProgramFullName"]] ;

        
        //Rate
        if([[[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"restaurantRating"] count] > 0)
        {
            NSString *rRating=@"0";
            NSArray *arrRating = [[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"restaurantRating"];
            if([arrRating count] > 0)
            {
                rRating = [[Singleton sharedSingleton] getReviewFromGLobalArray:arrRating];
                if([[rRating stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"0"])
                {
                    cell.btnRating.hidden = YES;
                    cell.btnStartRate.hidden = YES;
                }
            }
            [cell.btnRating setTitle:[NSString stringWithFormat:@"  %@", rRating] forState:UIControlStateNormal];
        }
        else
        {
            cell.btnRating.hidden = YES;
            cell.btnStartRate.hidden = YES;
            //            [cell.btnRate setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
        }
        
       
            BOOL checked=false;
            @try {
                checked = [[[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"Diamond"] boolValue];
            }
            @catch (NSException *exception) {
                checked = false;
            }
            if(checked)
            {
                 cell.btnDiamond.hidden = NO;
            }
            else{
                 cell.btnDiamond.hidden = YES;
            }
     
        //Distance
        double lat, lon;
        @try {
            lat =  [[[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"Latidute"] doubleValue];
            lon =  [[[[arrSpecialOffer objectAtIndex:0] objectAtIndex:indexPath.row]objectForKey:@"Longitude"] doubleValue];
            
        }
        @catch (NSException *exception) {
            lat =  0;
            lon =  0;
        }
        NSString *distacne = [[Singleton sharedSingleton] getDistanceBetweenLocations:lat Lon:lon Aontherlat:app.lat AnotheLong:app.lon];
        cell.lblDistance.text =[NSString stringWithFormat:@"%@",distacne];
    }
    return cell;
}

-(void)diamondButtonTapped:(id)sender
{
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 5.0f;
//}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *v = [UIView new];
//    [v setBackgroundColor:[UIColor clearColor]];
//    return v;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    specialOfferDetailViewController *detail;
    if (IS_IPHONE_5)
    {
        detail=[[specialOfferDetailViewController alloc] initWithNibName:@"specialOfferDetailViewController-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        detail=[[specialOfferDetailViewController alloc] initWithNibName:@"specialOfferDetailViewController_iPad" bundle:nil];
    }
    else
    {
        detail=[[specialOfferDetailViewController alloc] initWithNibName:@"specialOfferDetailViewController" bundle:nil];
    }
    detail.arrRestaurantSpecialOfferDetail = arrSpecialOffer;
    detail.joinIndexId = indexPath.row;
    [self.navigationController pushViewController:detail animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
