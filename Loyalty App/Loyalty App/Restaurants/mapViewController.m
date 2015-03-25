//
//  mapViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/23/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "mapViewController.h"
#import "Singleton.h"
#import "InfoWindowView.h"
#import "RestaurantView.h"

//#define Zoom_DEFAULTLEVEL 11 // 11

@interface mapViewController ()
@property (strong, nonatomic) GMSMarker *currentlyTappedMarker;
@end

@implementation mapViewController
@synthesize infoView, mapView_, _fromWhere, arrRestaurantList;

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
    
    btnRestaurant.layer.cornerRadius=5.0;
    btnRestaurant.clipsToBounds=YES;
    
    Zoom_DEFAULTLEVEL = 11;
    arrPath = [[NSMutableArray alloc] init];
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
    
    self.markerTapped = NO;
    self.cameraMoving = NO;
    self.idleAfterMovement = NO;
    self.mapView_.delegate = self;
    
    btnRestaurant.hidden=YES;
    NSLog(@" MAP _fromWhere : %@", _fromWhere);
    
    if([_fromWhere isEqualToString:@"RestDetail"])
    {
        if([[[Singleton sharedSingleton] getarrRestaurantList] count] > 0)
        {
//            latitude  =  [[[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"Latidute"] doubleValue];
//            longitude =  [[[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"Longitude"] doubleValue];
            
            //arrRestaurantList = [[NSMutableArray alloc] initWithObjects:[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:[[Singleton sharedSingleton] indexId]], nil];
            
            
//            arrRestaurantList =  [[NSMutableArray alloc] init];
//            NSMutableArray *tempArr = [[NSMutableArray alloc] initWithObjects:[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:[[Singleton sharedSingleton] indexId]], nil];
//            [arrRestaurantList addObject:tempArr];
            
            [self setPinsOnmapView];
            
        }
    }
    else
    {
        if(app._flagMainBtn == 1)
        {
            // Called near Me
            arrRestaurantList=[[NSMutableArray alloc] init];
            [self getRestaurantList];
            
            btnRestaurant.hidden=NO;
            
        }
        else //if(app._flagMainBtn == 2)
        {
            // called from Restaurant Detail
            //        arrRestaurantList=[[NSMutableArray alloc] init];
            //        [self getRestaurantList];
            
            if([[[Singleton sharedSingleton] getarrRestaurantList] count] > 0)
            {
                arrRestaurantList = [[NSMutableArray alloc] initWithObjects:[[Singleton sharedSingleton] getarrRestaurantList], nil];
                [self setPinsOnmapView];
                //            [self didTapFitBounds];
            }
        }
        
    }
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
   [Singleton sharedSingleton].IS_VISITED_MAP = TRUE;
}

#pragma mark BUTTON CLICK EVENT
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
-(void)getRestaurantList
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
    }
    else
    {
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
            
            
//            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
//            if([st objectForKey:@"UserSelectedCountry"])
//            {
//                [dict setValue:[st objectForKey:@"UserSelectedCountry"]   forKey:@"CountryId"];
//            }
//            if([st objectForKey:@"UserSelectedState"])
//            {
//                [dict setValue:[st objectForKey:@"UserSelectedState"]   forKey:@"StateId"];
//            }
//            if([st objectForKey:@"UserSelectedCity"])
//            {
//                [dict setValue:[st objectForKey:@"UserSelectedCity"]   forKey:@"City"];
//            }
            
        }
        else
        {
                //just show rest list
                [dict setValue:[NSNumber numberWithDouble:app.lat] forKey:@"Latidute"];
                [dict setValue:[NSNumber numberWithDouble:app.lon]   forKey:@"Longitude"];
                [dict setValue:@"100"  forKey:@"Range"];
        }
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 NSLog(@" %@ -- ", dict);
                 
                 if (dict)
                 {
                     [self stopActivity];
                     Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                     if (!strCode)
                     {
                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alt show];
                         
                         [self setOnlyMapView];
                     }
                     else
                     {
                         [arrRestaurantList addObject:[dict objectForKey:@"data"] ];
//                         [[Singleton sharedSingleton] setarrRestaurantList:[dict objectForKey:@"data"]];
                         if([arrRestaurantList count] > 0)
                         {
                             [[Singleton sharedSingleton] setarrRestaurantList:[arrRestaurantList objectAtIndex:0]];
                         }
                         
                         [self setPinsOnmapView];
//                         [self didTapFitBounds];
                     }
                 }
                 else
                 {
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     [self stopActivity];
                 }
             } :@"Restaurant/NearestRestaurant" data:dict];
    }
}
- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnRestaurantListClicked:(id)sender
{
    RestaurantView *restauView;
    
    if (IS_IPHONE_5)
    {
        restauView=[[RestaurantView alloc] initWithNibName:@"RestaurantView-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        restauView=[[RestaurantView alloc] initWithNibName:@"RestaurantView_iPad" bundle:nil];
    }
    else
    {
        restauView=[[RestaurantView alloc] initWithNibName:@"RestaurantView" bundle:nil];
    }
    [self.navigationController pushViewController:restauView animated:YES];
}
-(void)setOnlyMapView
{
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    //Configure Accuracy depending on your needs, default is kCLLocationAccuracyBest
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;  //kCLLocationAccuracyBest
    
    // Set a movement threshold for new events.
  //  locationManager.distanceFilter = 10; // meters
    
    [locationManager startUpdatingLocation];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:Zoom_DEFAULTLEVEL];
    self.mapView_ = [GMSMapView mapWithFrame:mapView.bounds camera:camera];
    self.mapView_.delegate = self;
    self.mapView_.delegate = nil;
    self.mapView_.delegate = self;
    self.mapView_.settings.zoomGestures = YES;
    self.mapView_.settings.myLocationButton = YES;
    self.mapView_.settings.compassButton = YES;
    self.mapView_.mapType = kGMSTypeNormal;
    //   [mapView addSubview:self.mapView_];
    [mapView    insertSubview:self.mapView_ atIndex:0];
    
    // Listen to the myLocation property of GMSMapView.
    [self.mapView_ addObserver:self  forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew  context:NULL];
    
    [self.mapView_ addSubview:self.stepperZoom];
    [self.mapView_ bringSubviewToFront:self.stepperZoom];
    self.stepperZoom.value = self.mapView_.camera.zoom;
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mapView_.myLocationEnabled = YES;
    });

    
}


#pragma mark Google map view
//-(void)setUpMapView
//{
//    if (nil == locationManager)
//        locationManager = [[CLLocationManager alloc] init];
//    
//    locationManager.delegate = self;
//    //Configure Accuracy depending on your needs, default is kCLLocationAccuracyBest
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    
//    // Set a movement threshold for new events.
//    locationManager.distanceFilter = 10.0f; // meters
//    
//    [locationManager startUpdatingLocation];
//    
//    latitude = 35.702069;
//    longitude = 139.775327;
//    
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:14];
//    self.mapView_ = [GMSMapView mapWithFrame:mapView.bounds camera:camera];
//    self.mapView_.delegate = self;
//    self.mapView_.settings.myLocationButton = YES;
//    self.mapView_.settings.compassButton = YES;
//    [mapView addSubview:self.mapView_];
//    [self.mapView_ addObserver:self
//               forKeyPath:@"myLocation"
//                  options:NSKeyValueObservingOptionNew
//                  context:NULL];
//    
////    dispatch_async(dispatch_get_main_queue(), ^{
////        self.mapView_.myLocationEnabled = YES;
////    });
//    
//    
////    [self setPinsOnmapView];
//   
//    
////    [self didTapFitBounds];
//}
//- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
//{
//    NSLog(@" Snippet : %@",  marker.snippet);
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // your code
//        CGPoint point = [self.mapView_.projection pointForCoordinate:marker.position];
//        NSLog(@"- point.x : %f && point.y : %f", point.x, point.y);
//        
//        if( (point.x >= 150 || point.x <= 180) &&  (point.x >= 220 || point.y <= 330))
//        {
//            NSLog(@"hello");
//            NSLog(@"CALL CLICKED - %@", [[arrForRestaurantDetail objectAtIndex:0] objectForKey:@"MobileNo"]);
//        }
//    
//    });
//   
//    
//    GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate setTarget:marker.position];
//    [self.mapView_ animateWithCameraUpdate:cameraUpdate];
//    
//}



- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker1
{
//    NSLog(@"Set YES to all");
    // A marker has been tapped, so set that state flag
    self.markerTapped = YES;
    
//    NSLog(@"Old lat : %f", self.currentlyTappedMarker.position.latitude);
//    NSLog(@"old lon : %f", self.currentlyTappedMarker.position.longitude);
    
    // If a marker has previously been tapped and stored in currentlyTappedMarker, then nil it out
    if(self.currentlyTappedMarker) {
        self.currentlyTappedMarker = nil;
    }

    // make this marker our currently tapped marker
    self.currentlyTappedMarker = marker1;
    
    // if our custom info window is already being displayed, remove it and nil the object out
    if([self.infoView isDescendantOfView:self.view]) {
        [self.infoView removeFromSuperview];
        self.infoView = nil;
        
         [self removePolyLinesManullay];
        
    }
    
    /* animate the camera to center on the currently tapped marker, which causes
     mapView:didChangeCameraPosition: to be called */
//    NSLog(@"New lat : %f", marker.position.latitude);
//    NSLog(@"New lon : %f", marker.position.longitude);
   
//    CLLocationCoordinate2D coordinate;
//    coordinate.latitude=23.028713;
//    coordinate.longitude=72.508730;
    
    GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate setTarget:marker1.position];
//    GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate setTarget:coordinate];
    [self.mapView_ animateWithCameraUpdate:cameraUpdate];
    
    return YES;
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
   // marker.position = position.target;

//    int lastIndex = (int) [[arrRestaurantList objectAtIndex:0] count]-1;
//    CLLocationCoordinate2D coordinate;
//    coordinate.latitude=[[[[arrRestaurantList objectAtIndex:0] objectAtIndex:lastIndex]objectForKey:@"Latidute"] doubleValue];
//    coordinate.longitude=[[[[arrRestaurantList objectAtIndex:0] objectAtIndex:lastIndex]objectForKey:@"Longitude"] doubleValue];
//    
//    if([arrForRestaurantDetail count] > 0)
//    {
//        coordinate.latitude=[[[arrForRestaurantDetail objectAtIndex:0] objectForKey:@"Latidute"] doubleValue];
//        coordinate.longitude=[[[arrForRestaurantDetail objectAtIndex:0] objectForKey:@"Longitude"] doubleValue];
//    }
////    self.mapView_.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:value];
//
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    [dict setValue:[NSString stringWithFormat:@"%f~%f", app.lat,app.lon] forKey:@"LatLong"];
//    [arr addObject:dict];
//
//
//    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
//    [dict1 setValue:[NSString stringWithFormat:@"%f~%f", coordinate.latitude, coordinate.longitude] forKey:@"LatLong"];
//    [arr addObject:dict1];
//
//    
//    [[Singleton sharedSingleton] drawPathBetweenLocations:arr GMSGOOGLEMAP:mapView_];
    

    
    
//    NSLog(@" self.markerTapped : %@", self.markerTapped ? @"YES": @"No");
    
    /* if we got here after we've previously been idle and displayed our custom info window,
     then remove that custom info window and nil out the object */
    if(self.idleAfterMovement) {
        if([self.infoView isDescendantOfView:self.view]) {
            [self.infoView removeFromSuperview];
            self.infoView = nil;
            
             [self removePolyLinesManullay];
        }
    }
    
    // if we got here after a marker was tapped, then set the cameraMoving state flag to YES
    if(self.markerTapped) {
        self.cameraMoving = YES;
    }
}
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    
     NSLog(@" self.cameraMoving : %@", self.cameraMoving ? @"YES": @"No");
    
    /* if we got here and a marker was tapped and our animate method was called, then it means we're ready
     to show our custom info window */
    if(self.markerTapped && self.cameraMoving) {
        
        // reset our state first
        self.cameraMoving = NO;
        self.markerTapped = NO;
        self.idleAfterMovement = YES;
        
        infoView =  [[[NSBundle mainBundle] loadNibNamed:@"InfoWindowView" owner:self options:nil] objectAtIndex:0];
        infoView.clipsToBounds=YES;
        
        NSLog(@"**** TITLE : %@", self.currentlyTappedMarker.title);
        NSLog(@"**** ID : %@", self.currentlyTappedMarker.snippet);
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"UserId matches %@ ", self.currentlyTappedMarker.snippet];
         NSArray *array = [[arrRestaurantList objectAtIndex:0] filteredArrayUsingPredicate: predicate];
//         NSLog(@"--- O/p:  %@", array);
        

        arrForRestaurantDetail = [[NSMutableArray alloc] initWithArray:array];
        if([arrForRestaurantDetail count] > 0)
        {
            // [view.viewbackground setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"map-popup.png"]]];
            
            infoView.restaurantId = [NSString stringWithFormat:@"%@", [[arrForRestaurantDetail objectAtIndex:0] objectForKey:@"UserId"]];
            
            infoView.lblRestaurantName.text = self.currentlyTappedMarker.title;
            infoView.lblRestaurantAddress.text = [NSString stringWithFormat:@"%@, %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrForRestaurantDetail objectAtIndex:0] objectForKey:@"StreetLine1"]], [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrForRestaurantDetail objectAtIndex:0] objectForKey:@"StreetLine2"]]];
            infoView.sourceLat = [[arrForRestaurantDetail objectAtIndex:0] objectForKey:@"Latidute"];
            infoView.sourceLong = [[arrForRestaurantDetail objectAtIndex:0] objectForKey:@"Longitude"];
            
            popupLat = [[[arrForRestaurantDetail objectAtIndex:0] objectForKey:@"Latidute"] doubleValue];
            popupLong = [[[arrForRestaurantDetail objectAtIndex:0] objectForKey:@"Longitude"] doubleValue];
            NSLog(@" %f : %f", app.lat, app.lon);
            NSLog(@" %f : %f", popupLat, popupLong);
          
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSString stringWithFormat:@"%f~%f", popupLat, popupLong] forKey:@"LatLong"];
            [arrPath addObject:dict];
            
            NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
            [dict1 setValue:[NSString stringWithFormat:@"%f~%f", app.lat, app.lon] forKey:@"LatLong"];
            [arrPath addObject:dict1];
            NSLog(@" Open arrPath ---- %@", arrPath);
            
            infoView.destinationLat = [NSString stringWithFormat:@"%f", app.lat];
            infoView.destinationLong =  [NSString stringWithFormat:@"%f",  app.lon];
            infoView.btnGetDirection.hidden = NO;
            
            infoView.self.mapView_ = self.mapView_;
            
            [infoView.btnCallNumber setTitle:[NSString stringWithFormat:@"%@", [[arrForRestaurantDetail objectAtIndex:0] objectForKey:@"MobileNo"]] forState:UIControlStateNormal];
            
            infoView.callNumber = [NSString stringWithFormat:@"%@", [[arrForRestaurantDetail objectAtIndex:0] objectForKey:@"MobileNo"]];
         
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
            dispatch_async(queue, ^{
                NSData *imageData;
                UIImage *image;
                
                NSArray *arrImg  = [[arrForRestaurantDetail objectAtIndex:0] objectForKey:@"ImagesList"];
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
                                
                                [infoView.btnRestaurantIcon setBackgroundImage:image forState:UIControlStateNormal];
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
                                    [infoView.btnRestaurantIcon setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
                                }
                                else{
                                    [infoView.btnRestaurantIcon setBackgroundImage:image forState:UIControlStateNormal];
                                }
                            });
                        }
                    }
                }
                
            });
            
        /* pointForCoordinate: takes a lat/lng and converts it into that lat/lngs current equivalent screen point.
         We'll use this to offset the display of the bottom of the custom info window so it doesn't overlap
         the marker icon. */
            
        CGPoint markerPoint = [self.mapView_.projection pointForCoordinate:self.currentlyTappedMarker.position];
            if(IS_IPAD)
            {
                self.infoView.frame = CGRectMake(markerPoint.x - 150, markerPoint.y - 65, self.infoView.frame.size.width, self.infoView.frame.size.height);
            }
            else
            {
                self.infoView.frame = CGRectMake(13, markerPoint.y - 60, self.infoView.frame.size.width, self.infoView.frame.size.height);
            }
        }
        [self.view addSubview:self.infoView];
      
//        // create our custom info window UIView and set the color to blueish
//        self.infoView = [[UIView alloc] init];
//        self.infoView.backgroundColor = [UIColor colorWithRed:0.5 green:0.4 blue:0.8 alpha:1.0];
//        
//        /* pointForCoordinate: takes a lat/lng and converts it into that lat/lngs current equivalent screen point.
//         We'll use this to offset the display of the bottom of the custom info window so it doesn't overlap
//         the marker icon. */
//        CGPoint markerPoint = [self.mapView_.projection pointForCoordinate:self.currentlyTappedMarker.position];
//        self.infoView.frame = CGRectMake(20, markerPoint.y - 80, 280, 40);
//        
//        // Create a label and show the marker's title, just like the default info window does
//        UILabel *label = [[UILabel alloc] init];
//        label.frame = CGRectMake(10, 5, 200, 30);
//        label.textColor = [UIColor whiteColor];
//        label.text = @"Jalpa D";
//        [self.infoView addSubview:label];
//        
//        // Create a button and add a target - something we can't do with the default info window
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//        button.frame = CGRectMake(200, 5, 80, 30);
//        [button setTitle:@"Click" forState:UIControlStateNormal];
//        [button setTintColor:[UIColor whiteColor]];
//        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self.infoView addSubview:button];
//        
//        // add the completed custom info window to self.view
//        [self.view addSubview:self.infoView];
    }
}

/* If the map is tapped on any non-marker coordinate, reset the currentlyTappedMarker and remove our
 custom info window from self.view */
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"Remove if already open");
    if(self.currentlyTappedMarker) {
        self.currentlyTappedMarker = nil;
    }
    
    if([self.infoView isDescendantOfView:self.view]) {
        [self.infoView removeFromSuperview];
        self.infoView = nil;
        [self removePolyLinesManullay];
    }
}
-(void)removePolyLinesManullay
{

    
//    [[[Singleton sharedSingleton] path] removeAllCoordinates];
//    [Singleton sharedSingleton].polyline.map = nil;
//    [[Singleton sharedSingleton] RemovePathBetweenLocations:[[NSMutableArray alloc] init] GMSGOOGLEMAP:mapView_];
//    
//    [Singleton sharedSingleton].polyline.strokeColor = [UIColor clearColor];
    
    
}

-(void)setPinsOnmapView
{
   
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    //Configure Accuracy depending on your needs, default is kCLLocationAccuracyBest
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;  //kCLLocationAccuracyBest
    // Set a movement threshold for new events.
    //locationManager.distanceFilter = 10; // meters
    [locationManager startUpdatingLocation];
    
    
    latitude =[[[[arrRestaurantList objectAtIndex:0] objectAtIndex:[arrRestaurantList count]-1]objectForKey:@"Latidute"] doubleValue];
    longitude=[[[[arrRestaurantList objectAtIndex:0] objectAtIndex:[arrRestaurantList count]-1]objectForKey:@"Longitude"] doubleValue];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:Zoom_DEFAULTLEVEL];
    self.mapView_ = [GMSMapView mapWithFrame:mapView.bounds camera:camera];
    self.mapView_.delegate = self;
    self.mapView_.delegate = nil;
    self.mapView_.delegate = self;
    self.mapView_.userInteractionEnabled=YES;
     self.mapView_.myLocationEnabled = YES;
    self.mapView_.settings.zoomGestures = YES;
    self.mapView_.settings.myLocationButton = YES;
    self.mapView_.settings.compassButton = YES;
    self.mapView_.mapType = kGMSTypeNormal;
 //   [mapView addSubview:self.mapView_];
    [mapView    insertSubview:self.mapView_ atIndex:0];

    // Listen to the myLocation property of GMSMapView.
    [self.mapView_ addObserver:self  forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew  context:NULL];
    
    for(int i=0; i<[[arrRestaurantList  objectAtIndex:0] count]; i++)
    {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude=[[[[arrRestaurantList objectAtIndex:0] objectAtIndex:i]objectForKey:@"Latidute"] doubleValue];
        coordinate.longitude=[[[[arrRestaurantList objectAtIndex:0] objectAtIndex:i]objectForKey:@"Longitude"] doubleValue];
        marker = [[GMSMarker alloc] init];
        marker.title= [NSString stringWithFormat:@"%@",[[[arrRestaurantList objectAtIndex:0] objectAtIndex:i]objectForKey:@"StoreName"]];
        marker.position = coordinate;
        marker.appearAnimation = kGMSMarkerAnimationPop;
        //marker.opacity = 0.6;
        marker.infoWindowAnchor = CGPointMake(0.5f, 0.0f);
        marker.icon = [UIImage imageNamed:@"map-pointer_new.png"];
        marker.snippet = [NSString stringWithFormat:@"%@", [[[arrRestaurantList objectAtIndex:0] objectAtIndex:i]objectForKey:@"UserId"]];
        
        marker.map = self.mapView_;
        [markers_ addObject:marker];
        [self.mapView_ animateToLocation:marker.position];
        
        if(i == [[arrRestaurantList  objectAtIndex:0] count]-1)
        {
            [[Singleton sharedSingleton] drawCircleAroundMe:coordinate GMSGOOGLEMAP:self.mapView_];
        }
    }
    
    [self.mapView_ addSubview:self.stepperZoom];
    [self.mapView_ bringSubviewToFront:self.stepperZoom];
    self.stepperZoom.value = self.mapView_.camera.zoom;
    
    // Ask for My Location data after the map has already been added to the UI.
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.mapView_.myLocationEnabled = YES;
//    });
    
    if([_fromWhere isEqualToString:@"RestDetail"])
    {
        
         NSMutableArray *arr = [[NSMutableArray alloc] init];

        
        if(app.lat!=0 && app.lon!= 0)
        {
            NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
            [dict1 setValue:[NSString stringWithFormat:@"%f~%f", app.lat, app.lon] forKey:@"LatLong"];
            [arr addObject:dict1];
            
          
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSString stringWithFormat:@"%f~%f", latitude, longitude] forKey:@"LatLong"];
            [arr addObject:dict];
            
            [[Singleton sharedSingleton] drawPathBetweenLocations:arr GMSGOOGLEMAP:mapView_];
        }
        
    }
    
}
#pragma mark - KVO updates
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_)
    {
       // CLLocationCoordinate2D coordinate;
        //coordinate.latitude=latitude;
        //coordinate.longitude=longitude;
       
        // If the first location update has not yet been recieved, then jump to that
        // location.
        
        if([_fromWhere isEqualToString:@"RestDetail"])
        {
            firstLocationUpdate_ = YES;
            __unused CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
      //     self.mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:Zoom_DEFAULTLEVEL];
    
        //[[Singleton sharedSingleton] drawCircleAroundMe:location.coordinate GMSGOOGLEMAP:self.mapView_];
        }
        
    }
}
- (void)didTapFitBounds
{
    GMSCoordinateBounds *bounds;
    for (GMSMarker *marker1 in markers_)
    {
        if (bounds == nil)
        {
            bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:marker1.position   coordinate:marker1.position];
        }
        bounds = [bounds includingCoordinate:marker1.position];
    }
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds
                                             withPadding:50.0f];
    [self.mapView_ moveCamera:update];
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
//    if (location) {
//        [self.mapView_ animateToLocation:location.coordinate];
//    }

    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
            // Update your marker on your map using location.coordinate.latitude
            //and location.coordinate.longitude);
//        GMSCameraUpdate *locationUpdate = [GMSCameraUpdate setTarget:location.coordinate zoom:Zoom_DEFAULTLEVEL];
//        [self.mapView_ animateWithCameraUpdate:locationUpdate];
//        
//        [[Singleton sharedSingleton] drawCircleAroundMe:location.coordinate GMSGOOGLEMAP:self.mapView_];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Implement here if the view has registered KVO
 
   // self.mapView_.delegate = nil;


}
-(void)dealloc
{
   
    @try {
        [self.mapView_ removeObserver:self  forKeyPath:@"myLocation"  context:NULL];
    }
    @catch (NSException *exception) {
        NSLog(@"------------- ERROR MAP-------------");
        NSLog(@"MAP : %@", [exception description]);
    }
    
  
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)zoomIndexChanges:(UIStepper *)sender {

    int value = [sender value];
    
//    mapView_ = nil;
//    [self.mapView_ removeFromSuperview];
//    Zoom_DEFAULTLEVEL = value;
//    [self setPinsOnmapView];
    
    
    // right code
    
//        CGFloat currentZoom = self.mapView_.camera.zoom;
//        CGFloat newZoom = value + 1;
//    
//        CLLocationCoordinate2D coordinate;
//        coordinate.latitude=app.lat; // latitude;
//        coordinate.longitude=app.lon; //longitude;
    
    int lastIndex = (int) [[arrRestaurantList objectAtIndex:0] count]-1;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude=[[[[arrRestaurantList objectAtIndex:0] objectAtIndex:lastIndex]objectForKey:@"Latidute"] doubleValue];
    coordinate.longitude=[[[[arrRestaurantList objectAtIndex:0] objectAtIndex:lastIndex]objectForKey:@"Longitude"] doubleValue];
    
    if([arrForRestaurantDetail count] > 0)
    {
        coordinate.latitude=[[[arrForRestaurantDetail objectAtIndex:0] objectForKey:@"Latidute"] doubleValue];
        coordinate.longitude=[[[arrForRestaurantDetail objectAtIndex:0] objectForKey:@"Longitude"] doubleValue];
    }
    self.mapView_.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:value];
    
    
    if(self.markerTapped && self.cameraMoving)
    {
        // reset our state first
        self.cameraMoving = NO;
        self.markerTapped = NO;
        self.idleAfterMovement = YES;
    }
    
    if(self.currentlyTappedMarker) {
        self.currentlyTappedMarker = nil;
    }
    
    if([self.infoView isDescendantOfView:self.view]) {
        [self.infoView removeFromSuperview];
        self.infoView = nil;
        
        [self removePolyLinesManullay];
    }
    
    
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    [dict setValue:[NSString stringWithFormat:@"%f~%f", app.lat,app.lon] forKey:@"LatLong"];
//    [arr addObject:dict];
//    
//    
//    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
//    [dict1 setValue:[NSString stringWithFormat:@"%f~%f", coordinate.latitude, coordinate.longitude] forKey:@"LatLong"];
//    [arr addObject:dict1];
//    
//    [[Singleton sharedSingleton] drawPathBetweenLocations:arr GMSGOOGLEMAP:mapView_];
    
    
    // changes - but not done
    
//    int value = [sender value];
////    CGFloat currentZoom = self.mapView_.camera.zoom;
////    CGFloat newZoom = value + 1;
//    
////    CLLocationCoordinate2D coordinate;
////    coordinate.latitude=app.lat; // latitude;
////    coordinate.longitude=app.lon; //longitude;
//    
//    if([arrRestaurantList count] > 0)
//    {
//        int lastIndex = (int)([[arrRestaurantList objectAtIndex:0] count]-1);
//        CLLocationCoordinate2D coordinate;
//        coordinate.latitude=[[[[arrRestaurantList objectAtIndex:0] objectAtIndex:lastIndex]objectForKey:@"Latidute"] doubleValue];
//        coordinate.longitude=[[[[arrRestaurantList objectAtIndex:0] objectAtIndex:lastIndex]objectForKey:@"Longitude"] doubleValue];
//        
//      GMSCameraPosition *camera;
//        if([arrForRestaurantDetail count] > 0)
//        {
//            coordinate.latitude=[[[arrForRestaurantDetail objectAtIndex:0] objectForKey:@"Latidute"] doubleValue];
//            coordinate.longitude=[[[arrForRestaurantDetail objectAtIndex:0] objectForKey:@"Longitude"] doubleValue];
//           camera = [GMSCameraPosition cameraWithLatitude:[[[arrForRestaurantDetail objectAtIndex:0] objectForKey:@"Latidute"] doubleValue] longitude:[[[arrForRestaurantDetail objectAtIndex:0] objectForKey:@"Longitude"] doubleValue] zoom:Zoom_DEFAULTLEVEL];
//        }
//        else
//        {
//            coordinate.latitude=[[[[arrRestaurantList objectAtIndex:0] objectAtIndex:lastIndex]objectForKey:@"Latidute"] doubleValue];
//            coordinate.longitude=[[[[arrRestaurantList objectAtIndex:0] objectAtIndex:lastIndex]objectForKey:@"Longitude"] doubleValue];
//            camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:value];
//        }
//       
//        self.mapView_ = [GMSMapView mapWithFrame:mapView.bounds camera:camera];
//        self.mapView_.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:value];
//        [self.mapView_ animateToLocation:self.currentlyTappedMarker.position];
//        NSLog(@"marker.position zoom : %f : %f", marker.position.latitude, marker.position.longitude);
//        
//        
//        if(self.markerTapped && self.cameraMoving)
//        {
//            // reset our state first
//            self.cameraMoving = NO;
//            self.markerTapped = NO;
//            self.idleAfterMovement = YES;
//        }
//
//        if(self.currentlyTappedMarker) {
//            self.currentlyTappedMarker = nil;
//        }
//        
//        if([self.infoView isDescendantOfView:self.view]) {
//            [self.infoView removeFromSuperview];
//            self.infoView = nil;
//            
//            [self removePolyLinesManullay];
//        }
//        
//        
//    }
}


@end
