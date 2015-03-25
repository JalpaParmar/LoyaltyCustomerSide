//
//  InfoWindowView.m
//  Loyalty App
//
//  Created by Ntech Technologies on 8/20/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "InfoWindowView.h"
#import "RestaDetailView.h"
#import "Singleton.h"
#import "LRouteController.h"

@implementation InfoWindowView
@synthesize btnCall, btnCallNumber, btnRestaurantIcon, lblRestaurantAddress, lblRestaurantName, lblRestaurantPhoneNo, sourceLat, sourceLong, destinationLat, destinationLong, mapView_, btnGetDirection ;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self andSubViews:YES];
    self._polyline.map = nil;
        
    }
    return self;
}

-(IBAction)callToRestaurant:(id)sender
{
    NSLog(@"CALL CLICKED : %@", self.callNumber);
    [[Singleton sharedSingleton] CALLPhoneNumberProgrammatically:self.callNumber];
}
-(IBAction)GetDirection:(id)sender
{
     [self showLines];
    
    
//    NSString *googleMapUrlString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%@,%@&daddr=%@,%@", sourceLat, sourceLong, destinationLat, destinationLong];
    
    //http://maps.google.com/?saddr=34.052222,-118.243611&daddr=37.322778,-122.031944
    
   
//    NSString *googleMapUrlString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%@,%@&daddr=%@,%@",  sourceLat, sourceLong, destinationLat, destinationLong];
//
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapUrlString]];
}
- (void)showLines
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setValue:[NSString stringWithFormat:@"%f~%f", destinationLat.doubleValue, destinationLong.doubleValue] forKey:@"LatLong"];
    [arr addObject:dict1];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"%f~%f", sourceLat.doubleValue, sourceLong.doubleValue] forKey:@"LatLong"];
    [arr addObject:dict];
    
//    
//    destinationLat = [NSString stringWithFormat:@"19.0176147"];
//    destinationLong = [NSString stringWithFormat:@"72.8561644"];
//    
    if(destinationLat.doubleValue == 0.000000 && destinationLong.doubleValue == 0.000000)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Enable Location Service for Get Direction" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [[Singleton sharedSingleton] drawPathBetweenLocations:arr GMSGOOGLEMAP:mapView_];
                
    }
}
-(void)removePolyLinesManullayFromInfoWindow
{
    self._polyline = nil;
}


- (IBAction)GoTODetailPage:(id)sender {
    
    btnDetail1.userInteractionEnabled = NO;
    btnDetail2.userInteractionEnabled = NO;
    btnDetail3.userInteractionEnabled = NO;
    
    // get restaurant Detail
    
    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
//        [self startActivity];
      
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.restaurantId forKey:@"RestaurantId"];
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Restaurant Detail - %@ -- ", dict);
             if (dict)
             {
//                 [self stopActivity];
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                 }
                 else
                 {
                     if([dict objectForKey:@"data"])
                     {
                         NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
                         [arrTemp addObject:[dict objectForKey:@"data"] ];
                         
                         if([arrTemp count] > 0)
                         {
                             [[Singleton sharedSingleton] setarrRestaurantList:[arrTemp objectAtIndex:0]];
                         }
                         
                        // [[Singleton sharedSingleton] setarrRestaurantList:[dict objectForKey:@"data"]];
                     }
                     
                     btnDetail1.userInteractionEnabled = YES;
                     btnDetail2.userInteractionEnabled = YES;
                     btnDetail3.userInteractionEnabled = YES;
                     
                     RestaDetailView *detail;
                     if (IS_IPHONE_5)
                     {
                         detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView-5" bundle:nil];
                     }
                     else if(IS_IPAD)
                     {
                         detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView_iPad" bundle:nil];
                     }
                     else
                     {
                         detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView" bundle:nil];
                     }
                     detail._fromWhere = @"FromRestaurant";
                     detail.IS_PUSHNOTIFICATION = FALSE;
                     [[Singleton sharedSingleton] setIndexId:0];
                     AppDelegate *app = APP;
                     [app.navObj  pushViewController:detail animated:YES];
                 }
                 
             }
             else
             {
//                 [self stopActivity];
             }
         } :@"Restaurant/GetRestaurantDetails" data:dict];
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
