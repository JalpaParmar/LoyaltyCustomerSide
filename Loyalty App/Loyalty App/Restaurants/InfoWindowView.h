//
//  InfoWindowView.h
//  Loyalty App
//
//  Created by Ntech Technologies on 8/20/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "LRouteController.h"

@interface InfoWindowView : UIView
{
    IBOutlet UIButton *btnCallNumber;
    IBOutlet UIButton *btnCall, *btnGetDirection;
    GMSMapView *mapView_;
    IBOutlet UIButton *btnDetail1, *btnDetail2, *btnDetail3;

    //GMSPolyline *_polyline;
    NSMutableArray *_coordinates;
    LRouteController *_routeController;
}

@property (nonatomic, strong)GMSPolyline *_polyline;
@property (nonatomic, strong) GMSMapView *mapView_;

@property (nonatomic, strong) NSString *callNumber, *restaurantId, *sourceLat, *sourceLong, *destinationLat, *destinationLong;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantName;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantPhoneNo;
@property (strong, nonatomic) IBOutlet UIButton *btnRestaurantIcon;
@property (strong, nonatomic) IBOutlet UIView *viewbackground;
@property (strong, nonatomic) IBOutlet UIButton *btnCall, *btnGetDirection;
@property (strong, nonatomic) IBOutlet UIButton *btnCallNumber;
- (IBAction)callToRestaurant:(id)sender;
- (IBAction)GoTODetailPage:(id)sender;
-(void)removePolyLinesManullayFromInfoWindow;
@end
