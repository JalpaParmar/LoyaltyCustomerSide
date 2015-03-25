//
//  RestaDetailView.h
//  Loyalty App
//
//  Created by Amit Parmar on 18/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>

@interface RestaDetailView : UIViewController<GMSMapViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate>
{
    AppDelegate *app;
    NSString *distacne;
    int indexId;
    float redeemPoints;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;

    GMSMapView *mapView_1;
    NSMutableArray *markers_1;
    BOOL firstLocationUpdate_;
    CLLocationManager *locationManager;
    double latitude, longitude;
    BOOL IS_RESTAURANT_FAVORITE;
    IBOutlet   UIButton *btnStarRate, *btnLoyaltyPointLink;
    IBOutlet UILabel *lblLoyaltyPoints;
    IBOutlet UIView *viewAfterMenus;
    
    float previousTouchPoint;
    BOOL didEndAnimate;
    NSMutableArray *arrOfImages, *arrLocalRestaurantDetail;
    IBOutlet UIPageControl *pageControl;
}
@property (nonatomic, assign) NSString *restaurantId_APNS;
@property (nonatomic, assign) BOOL IS_PUSHNOTIFICATION;
@property (strong, nonatomic)  IBOutlet UIActivityIndicatorView *actIndicatorView_LoyaltyPoints;

@property (strong, nonatomic) IBOutlet UIButton *btnMap;
- (IBAction)btnMapClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnBG;
@property (strong, nonatomic) IBOutlet UIView *viewBGMap;
@property (strong, nonatomic) IBOutlet UIImageView *imgLargePhoto;

- (IBAction)hideParentView:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantName;

@property (strong, nonatomic) NSString *_fromWhere;
@property (strong, nonatomic) IBOutlet UIButton *btnReservation;
@property (strong, nonatomic) IBOutlet UIButton *btnFavorite;
@property (strong, nonatomic) IBOutlet UIButton *btnChat;
@property (strong, nonatomic) IBOutlet UIButton *btnOrder;
@property (strong, nonatomic) IBOutlet UIButton *btnCall;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *btnRate;
@property (strong, nonatomic) IBOutlet UIScrollView *detailScrollview;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewLargeImg;
@property (strong, nonatomic) IBOutlet UIView *lastViewSeparator;
@property (strong, nonatomic) IBOutlet UIView *viewDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantPhoneno;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantMinOrder;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantDistance;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantCuisines;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantTiming;
@property (strong, nonatomic) IBOutlet UILabel *lblRestaurantCost;
@property (strong, nonatomic) IBOutlet UIView *mapView1;
@property (strong, nonatomic) IBOutlet UILabel *lblCall;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderNow;
@property (strong, nonatomic) IBOutlet UILabel *lblReservation;
@property (strong, nonatomic) IBOutlet UILabel *lblFavorite;
@property (strong, nonatomic) IBOutlet UILabel *lblChat;



- (void)GoToRestaurantDetailPage:(NSString*)rid;
- (IBAction)favoriteClicked:(id)sender;
- (IBAction)chatClicked:(id)sender;

-(IBAction)phoneCallClicked:(id)sender;
-(IBAction)orderProcessClicked:(id)sender;
- (IBAction)btnBackClick:(id)sender;
- (IBAction)reservationClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleRestaurantDetails;

@property (strong, nonatomic) IBOutlet UIStepper *stepperZoom;
- (IBAction)zoomIndexChanges:(UIStepper *)sender;

@end
