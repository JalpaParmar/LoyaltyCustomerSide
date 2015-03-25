//
//  mapViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 7/23/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"
#import "InfoWindowView.h"
#import "LRouteController.h"

@interface mapViewController : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate>
{
    LRouteController *_routeController;
    InfoWindowView *infoView;
    AppDelegate *app;
    GMSMapView *mapView_;
    NSMutableArray *markers_, *arrRestaurantList, *arrForRestaurantDetail;
    BOOL firstLocationUpdate_;
    CLLocationManager *locationManager;
    double latitude, longitude, popupLat, popupLong;
    IBOutlet UIView *mapView;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    NSString *_fromWhere;
    NSMutableArray *arrPath ;
    GMSMarker *marker;
    
    int Zoom_DEFAULTLEVEL;
    GMSMarker *_markerStart;
    GMSMarker *_markerFinish;
     GMSPolyline *_polyline;
    NSMutableArray *_coordinates;
    IBOutlet UIButton *btnRestaurant;
}
@property (nonatomic, strong) NSMutableArray *arrRestaurantList;
@property (nonatomic, strong) NSString *_fromWhere;
@property (nonatomic, strong)GMSMapView *mapView_;
@property BOOL markerTapped;
@property BOOL cameraMoving;
@property BOOL idleAfterMovement;


@property (nonatomic, strong) InfoWindowView* infoView;
- (IBAction)btnBackClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIStepper *stepperZoom;
- (IBAction)zoomIndexChanges:(UIStepper *)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleMap;
-(IBAction)btnRestaurantListClicked:(id)sender;

@end
