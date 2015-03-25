//
//  RestaurantJoinedViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 8/13/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "specialOfferDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RestaDetailView.h"
#import "Singleton.h"

@interface specialOfferDetailViewController ()
@end

@implementation specialOfferDetailViewController
@synthesize arrRestaurantSpecialOfferDetail, joinIndexId;

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

//    self.lblTitleSpecialDetail.font = FONT_centuryGothic_35;
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
    
    self.btnRestaurantDetail.layer.cornerRadius = 5.0;
    self.btnRestaurantDetail.clipsToBounds = YES;
   
    self.viewForOffer.layer.cornerRadius = 5.0;
    self.viewForOffer.clipsToBounds = YES;
    
    self.viewForDetail.borderType = BorderTypeDashed;
    self.viewForDetail.dashPattern = 4;
    self.viewForDetail.spacePattern = 4;
    self.viewForDetail.borderWidth = 1;
    self.viewForDetail.cornerRadius = 10;
    
    [self setRestaurantSpecialOfferDetail];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark Button Click Event
-(void)setRestaurantSpecialOfferDetail
{

    if([arrRestaurantSpecialOfferDetail count] > 0)
    {
        if([[arrRestaurantSpecialOfferDetail objectAtIndex:0] count]> 0)
        {
            //QR Code
            NSString *s =[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrRestaurantSpecialOfferDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"SpecialOffer"]];
            self.lblQRCode.text = s;
            
            if([s isEqualToString:@""])
            {
                [self.btnQRCodeImage setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];                
                self.lblQRCode.text = @"QR Code Not available rightnow";
            }
            else
            {
                dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.myCompanyName.imagegrabber.bgqueue", NULL);
                dispatch_async(backgroundQueue, ^(void) {
                    
                    // QRCode Image
                    self.btnQRCodeImage.userInteractionEnabled = NO;
                    NSString *imageName = [NSString stringWithFormat:@"https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=%@&choe=UTF-8", s];
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        
                        if(image == nil)
                        {
                            [self.btnQRCodeImage setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
                        }
                        else
                        {
                            [self.btnQRCodeImage setBackgroundImage:image forState:UIControlStateNormal];
                        }
                    });
                    
                });
            }
            
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
            dispatch_async(queue, ^{
                
                NSData *imageData;
                UIImage *image;
                //Restaurant icon
                NSMutableArray* arrImg  = [[[arrRestaurantSpecialOfferDetail objectAtIndex:0]objectAtIndex:joinIndexId] objectForKey:@"ImagesList"];
                if([arrImg count] > 0)
                {
                    NSString *imgStr =[[arrImg objectAtIndex:0] objectForKey:@"UploadPath"];
                    if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:imgStr] isEqualToString:@""])
                    {
                        NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, imgStr];
                        
                        image =  [[Singleton sharedSingleton] getImageFromCache:[imageName lastPathComponent]];
                        
                        if(image != nil)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.imgRestaurantIcon.image = image;
                            });
                        }
                        else
                        {
                            NSURL *imageURL =[NSURL URLWithString:imageName];
                            if(imageData == nil)
                            {
                                imageData = [[NSData alloc] init];
                            }
                            imageData = [NSData dataWithContentsOfURL:imageURL];
                            //        NSData *data = [NSData dataWithContentsOfURL:imageURL];
                            image = [UIImage imageWithData:imageData];
                            
                            //  /Upload/UserCard/bb1f9253-ae44-44a1-8427-94d1a0e71dfc/bb1f9253-ae44-44a1-8427-94d1a0e71dfc_06102014521AM.png
                            
                            [[Singleton sharedSingleton] saveImageInCache:image ImgName: [[arrImg objectAtIndex:0] objectForKey:@"UploadPath"]];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if(image == nil)
                                {
                                    self.imgRestaurantIcon.image = [UIImage imageNamed:@"defaultImage.png"];
                                }
                                else
                                {
                                    self.imgRestaurantIcon.image = image;
                                }
                                
                            });
                        }

                    }
                }
                
            });
                          
            //Restaurant Name
            self.lblRestaurantName.text = [NSString stringWithFormat:@"%@", [[[arrRestaurantSpecialOfferDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"StoreName"]];
            
            //Address
            NSString*address =  [NSString stringWithFormat:@"%@, %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrRestaurantSpecialOfferDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"StreetLine1"]], [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrRestaurantSpecialOfferDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"StreetLine2"]]];
            self.lblRestaurantAddress.text = [[address componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
            
            //Distance
            double lat, lon;
            @try {
                lat =[[[[arrRestaurantSpecialOfferDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"Latidute"] doubleValue];
                lon =[[[[arrRestaurantSpecialOfferDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"Longitude"] doubleValue];
            }
            @catch (NSException *exception) {
                lat =  0;
                lon =  0;
            }
            NSString *distacne = [[Singleton sharedSingleton] getDistanceBetweenLocations:lat Lon:lon Aontherlat:app.lat AnotheLong:app.lon];
            self.lblRestaurantDistance.text = [NSString stringWithFormat:@"%@", distacne];
            
            //JoinDate = "/Date(1408365730630)/";
            //Start Date
            NSString *str = [NSString stringWithFormat:@"%@", [[[arrRestaurantSpecialOfferDetail objectAtIndex:0] objectAtIndex:joinIndexId]objectForKey:@"ExpiryDate"]];
             NSString *strStartDate=@"";
            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str] isEqualToString:@""])
            {
                strStartDate = [[Singleton sharedSingleton] ConvertMilliSecIntoDate:str Format:@"dd-MMMM-yyyy"];
            }
            self.lblExpiryDate.text = [NSString stringWithFormat:@"Expiry Date : %@", strStartDate];
            
//            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:str] isEqualToString:@""])
//            {
//                str = [str substringToIndex:[str length]- 2];
//                NSArray *arr2 = [str componentsSeparatedByString:@"("];
//                NSDate *StartDate;
//               
//                if(  [arr2 count] > 0)
//                {
//                    str = [arr2 objectAtIndex:1];
//                    StartDate = [NSDate dateWithTimeIntervalSince1970:[[arr2 objectAtIndex:1] doubleValue]/1000];
//                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//                    [format setDateFormat:@"dd-MMMM-yyyy"];
//                    strStartDate = [format stringFromDate:StartDate];
//                }
//             }
//            self.lblExpiryDate.text = [NSString stringWithFormat:@"Expiry Date : %@", strStartDate];
            
            BOOL checked;
            @try {
                NSString * s =  [[[arrRestaurantSpecialOfferDetail objectAtIndex:0] objectAtIndex:joinIndexId]objectForKey:@"Diamond"];
                checked = [s boolValue];
            }
            @catch (NSException *exception) {
                checked = false;
            }
            
            if(checked)
            {
                self.lblExpiryDate.hidden = YES;
                CGRect f = self.viewForDetail.frame;
                f.size.height = f.size.height - 30;
                self.viewForDetail.frame = f;
            }

            CGRect f = self.btnRestaurantDetail.frame;
            if(IS_IPAD)
            {
                f.origin.y = self.viewForDetail.frame.origin.y +self.viewForDetail.frame.size.height + 20;
            }
            else
            {
                f.origin.y = self.viewForDetail.frame.origin.y +self.viewForDetail.frame.size.height + 10;
            }
            self.btnRestaurantDetail.frame = f;
            
            NSArray *arr = [[[arrRestaurantSpecialOfferDetail objectAtIndex:0] objectAtIndex:joinIndexId]objectForKey:@"ItemNameTxt"];
            NSString *itemName;
            if([arr count] > 0)
            {
                itemName = [arr objectAtIndex:0];
            }
            NSString *strOffer = [NSString stringWithFormat:@"Get %@%% On %@", [[[arrRestaurantSpecialOfferDetail objectAtIndex:0] objectAtIndex:joinIndexId]objectForKey:@"Discount"], itemName];
            self.lblOffer.text = strOffer;
            
        }
    }
}
- (IBAction)btnbackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnRestaurantDetailClicked:(id)sender {
    
 
    RestaDetailView *detail;
    if (IS_IPHONE_5)
    {
        detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView_iPad" bundle:nil];
    }
    else
    {
        detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView" bundle:nil];
    }
    detail._fromWhere = @"FromSpecialOfferDetail";
    detail.IS_PUSHNOTIFICATION = FALSE;
    [[Singleton sharedSingleton] setarrRestaurantList:[arrRestaurantSpecialOfferDetail objectAtIndex:0]];
    [[Singleton sharedSingleton] setIndexId:joinIndexId];
    
////    int d = [[[[arrRestaurantSpecialOfferDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"UserId"] intValue];
//    NSString *d = [[[arrRestaurantSpecialOfferDetail objectAtIndex:0] objectAtIndex:joinIndexId] objectForKey:@"UserId"] ;
//    int dd = [d intValue];
//    
//    id someObject = [arrRestaurantSpecialOfferDetail objectAtIndex:0][dd]; // get some value
//    if([[[Singleton sharedSingleton] getarrRestaurantList] count] > 0)
//    {
//        NSUInteger originalIndex = [[[Singleton sharedSingleton] getarrRestaurantList] indexOfObject:someObject];
//        [[Singleton sharedSingleton] setIndexId:originalIndex];
//        
//        NSLog(@"originalIndex -- %d", originalIndex);
//    }
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
