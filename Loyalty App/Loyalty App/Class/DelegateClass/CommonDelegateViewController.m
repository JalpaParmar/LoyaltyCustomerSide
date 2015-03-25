//
//  settingViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "CommonDelegateViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "settingCell.h"
#import "Singleton.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLAvailability.h>
@interface CommonDelegateViewController ()<GMSMapViewDelegate,CLLocationManagerDelegate>
{
    CLGeocoder *geocoder;
}
@end
@implementation NSArray(SPFoundationAdditions)
- (id)onlyObject
{
    return [self count] == 1 ? [self objectAtIndex:0] : nil;
}
@end
@implementation CommonDelegateViewController

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
//    [self.view addSubview:[app setFooterPart]];
//    app._flagMainBtn = 0; //2;
    
   [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    IS_FIRST = true;
    arrLocation = [[NSMutableArray alloc] init];
    self.btnSubmit.layer.cornerRadius = 5.0;
    self.btnSubmit.clipsToBounds = YES;
    
    self.btnCancel.layer.cornerRadius = 5.0;
    self.btnCancel.clipsToBounds = YES;
    
    self.btnSubmit.layer.cornerRadius = 5.0;
    self.btnSubmit.clipsToBounds = YES;
    
    btnCountry.enabled = NO;
    btnState.enabled = NO;
    btnCity.enabled = NO;
    
    viewBack.layer.cornerRadius = 5.0;
    viewBack.clipsToBounds=YES;
    viewBack.layer.borderColor = [UIColor lightGrayColor].CGColor;
    viewBack.layer.borderWidth=1.0;
    
    tblLocationList.tableFooterView = [[UIView alloc] init];
    
    self.view.userInteractionEnabled = YES;
    
    arrRange = [NSArray arrayWithObjects:@"10KM",@"50KM",@"100KM",@"500KM",@"1000KM", nil];
    arrRangeOnlyNumber = [NSArray arrayWithObjects:@"10",@"50",@"100",@"500",@"1000", nil];
    
    
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectedRange"];

    
    //**** set old parameter
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userSearchedArea"])
    {
        txtLocation.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userSearchedArea"]];
    }
    else
    {
        txtLocation.text=@"";
    }
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedRange"])
    {
          [btnSelectRange setTitle:[NSString stringWithFormat:@"%@",  [[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedRangeButtonTitle"]] forState:UIControlStateNormal];
        
        if(![btnSelectRange.titleLabel.text isEqualToString:@"Select Range"])
        {
             if([arrRange count] > 0)
            {
                NSUInteger index = [arrRange indexOfObject:btnSelectRange.titleLabel.text];
                @try {
                    [pickerRange selectRow:index inComponent:0 animated:YES];
                }
                @catch (NSException *exception) {
                    [pickerRange selectRow:0 inComponent:0 animated:YES];
                }
            }
        }
        else
        {
            [btnSelectRange setTitle:[NSString stringWithFormat:@"%@",  [arrRange objectAtIndex:2]] forState:UIControlStateNormal];
            [pickerRange selectRow:2 inComponent:0 animated:YES];
        }
    }
    else
    {
          [btnSelectRange setTitle:[NSString stringWithFormat:@"%@",  [arrRange objectAtIndex:2]] forState:UIControlStateNormal];
           [pickerRange selectRow:2 inComponent:0 animated:YES];
    }
    
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    NSDictionary *userLoc=[st objectForKey:@"userLocation"];
    NSLog(@"lat %@",[userLoc objectForKey:@"lat"]);
    NSLog(@"long %@",[userLoc objectForKey:@"long"]);
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
   /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GettingCityList) name:@"GettingCityList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GettingCountryList) name:@"GettingCountryList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GettingStateList) name:@"GettingStateList" object:nil];
   
    if([[[Singleton sharedSingleton] getarrCountryList] count] <= 0)
    {
        [self startActivity];
        [[Singleton sharedSingleton] getCountryList];
    }
    else{
        [self stopActivity];
        if([[[Singleton sharedSingleton] getarrCountryList] count] > 0)
        {
            btnCountry.enabled = YES;
        }
        else
        {
            btnCountry.enabled = NO;
        }
    }
    [self setCountryNCallState];
    [self setStateNCallCity];
    [self setCity];
    */
    
    
}
-(void)GettingCountryList
{
    [self stopActivity];
    if([[[Singleton sharedSingleton] getarrCountryList] count] > 0)
    {
        btnCountry.enabled = YES;
    }
    else
    {
        btnCountry.enabled = NO;
    }
}
-(void)GettingStateList
{
    [self stopActivity];
    if([[[Singleton sharedSingleton] getarrStateList] count] > 0)
    {
        btnState.enabled = YES;
    }
    else
    {
        btnState.enabled = NO;
        [btnState setTitle:@"Select State" forState:UIControlStateNormal];
    }
    
}
-(void)GettingCityList
{
    [self stopActivity];
    if([[[Singleton sharedSingleton] getarrCityList] count] > 0)
    {
        btnCity.enabled = YES;
    }
    else
    {
        btnCity.enabled = NO;
        [btnCity setTitle:@"Select City" forState:UIControlStateNormal];
    }
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

-(void)setCountryNCallState
{
     if([[[Singleton sharedSingleton] getarrCountryList] count] > 0)
     {
         NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
         if([st objectForKey:@"UserSelectedCountry"])
         {
             btnCountry.enabled=YES;
             
             [btnCountry setTitle:@"Select Country" forState:UIControlStateNormal];
             
             @try {
                 
                 [btnCountry setTitle:[NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:[[Singleton sharedSingleton].countryId intValue]] objectForKey:@"CountryName"]] forState:UIControlStateNormal];
                 
                 [[Singleton sharedSingleton] setCountryDBID:[NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:[[Singleton sharedSingleton].countryId intValue]] objectForKey:@"CountryId"]]];
                 
             }
             @catch (NSException *exception)
             {
                 [btnCountry setTitle:[NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:0] objectForKey:@"CountryName"]] forState:UIControlStateNormal];
                 
                 [[Singleton sharedSingleton] setCountryDBID:[NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:0] objectForKey:@"CountryId"]]];
             }
             
             if([[[Singleton sharedSingleton] ISNSSTRINGNULL:btnCountry.titleLabel.text] isEqualToString:@""])
             {
                 [btnCountry setTitle:@"Select Country" forState:UIControlStateNormal];
             }
             
             
             [st setValue:[Singleton sharedSingleton].countryDBID forKey:@"UserSelectedCountry"];
             
             if([[Singleton sharedSingleton].countryId intValue] > 0)
             {
                 [self startActivity];
                 [[Singleton sharedSingleton] getStateList: [Singleton sharedSingleton].countryDBID];
             }
             //btnCountry.enabled=NO;
             
         }

     }
}
-(void)setStateNCallCity
{
     if([[[Singleton sharedSingleton] getarrStateList] count] > 0)
     {
         NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
         if([st objectForKey:@"UserSelectedState"])
         {
             btnState.enabled = YES;
             
             @try {
                 [btnState setTitle:[NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0]objectAtIndex:[[Singleton sharedSingleton].stateId intValue]] objectForKey:@"StateName"] ] forState:UIControlStateNormal];
                 
                 [[Singleton sharedSingleton] setStateDBID:[NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] arrStateList] objectAtIndex:0]objectAtIndex:[[Singleton sharedSingleton].stateId intValue]] objectForKey:@"StateID"]]];
                 
             }
             @catch (NSException *exception) {
                 [btnState setTitle:[NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0]objectAtIndex:0] objectForKey:@"StateName"] ] forState:UIControlStateNormal];
                 
                 [[Singleton sharedSingleton] setStateDBID:[NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] arrStateList] objectAtIndex:0]objectAtIndex:0] objectForKey:@"StateID"]]];
                 
             }
             
             
             if([[[Singleton sharedSingleton] ISNSSTRINGNULL:btnState.titleLabel.text] isEqualToString:@""])
             {
                 [btnState setTitle:@"Select State" forState:UIControlStateNormal];
                 btnState.enabled = NO;
             }
             
             
             [st setValue:[Singleton sharedSingleton].stateDBID forKey:@"UserSelectedState"];
             
             if([[Singleton sharedSingleton].stateId intValue] > 0)
             {
                 [self startActivity];
                 [[Singleton sharedSingleton] getCityList: [Singleton sharedSingleton].stateDBID];
             }
             
         }

     }
}
-(void)setCity
{
    if([[[Singleton sharedSingleton] getarrCityList] count] > 0)
    {
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        
        if([st objectForKey:@"UserSelectedCity"])
        {
            btnCity.enabled = YES;
            
            @try {
                [btnCity setTitle:[NSString stringWithFormat:@"%@", [[[[Singleton sharedSingleton] getarrCityList] objectAtIndex:0]objectAtIndex:[[Singleton sharedSingleton].cityId intValue]]] forState:UIControlStateNormal];
            }
            @catch (NSException *exception) {
                [btnCity setTitle:[NSString stringWithFormat:@"%@", [[[[Singleton sharedSingleton] getarrCityList] objectAtIndex:0]objectAtIndex:0]] forState:UIControlStateNormal];
            }
            
            
            
            if([[[Singleton sharedSingleton] ISNSSTRINGNULL:btnCity.titleLabel.text] isEqualToString:@""])
            {
                [btnCity setTitle:@"Select City" forState:UIControlStateNormal];
                btnCity.enabled = NO;
            }
            
            [st setValue:[Singleton sharedSingleton].cityDBID forKey:@"UserSelectedCity"];
            
        }
    }
}
- (IBAction)filterCitywiseClicked:(id)sender
{
    UIButton *b = (UIButton*)sender;
    self.pickerCity.hidden=NO;
    
    if(b.tag == 1)
    {
        NSLog(@"[Singleton sharedSingleton].countryId : %@", [Singleton sharedSingleton].countryId);
        //country
        self.btnSubmit.tag = 1;
        [self.pickerCity reloadAllComponents];
        [self.pickerCity selectRow:[[Singleton sharedSingleton].countryId intValue] inComponent:0 animated:YES];
       // [self.pickerCity selectRow:0 inComponent:0 animated:YES];
       // [btnState setTitle:@"  Select State" forState:UIControlStateNormal];
        
        [self setCountryNCallState];
    }
    else if(b.tag == 2)
    {
        if([[[Singleton sharedSingleton] getarrStateList] count] > 0)
        {
            NSLog(@"[Singleton sharedSingleton].stateId : %@", [Singleton sharedSingleton].stateId);
            //state
            self.btnSubmit.tag = 2;
            [self.pickerCity reloadAllComponents];
            @try {
                  [self.pickerCity selectRow:[[Singleton sharedSingleton].stateId intValue]  inComponent:0 animated:YES];
            }
            @catch (NSException *exception) {
                  [self.pickerCity selectRow:0  inComponent:0 animated:YES];
            }
          
            [self setStateNCallCity];
        }
        else
        {
            btnState.enabled = NO;
        }
    
        
    }
    else if(b.tag == 3)
    {
        if([[[Singleton sharedSingleton] getarrCityList] count] > 0)
        {
            NSLog(@"[Singleton sharedSingleton].cityId : %@", [Singleton sharedSingleton].cityId);
            //city
            self.btnSubmit.tag = 3;
            [self.pickerCity reloadAllComponents];
            @try {
                  [self.pickerCity selectRow:[[Singleton sharedSingleton].cityId intValue] inComponent:0 animated:YES];
            }
            @catch (NSException *exception) {
                  [self.pickerCity selectRow:0 inComponent:0 animated:YES];
            }
         
            [self setCity];
        }
        else
        {
            btnCity.enabled = NO;
        }
        
    }
}
-(IBAction)btnSubmitClicked:(id)sender
{
    if([[[Singleton sharedSingleton] ISNSSTRINGNULL:txtLocation.text] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Enter Area to Search" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [alert show];
    }
    else
    {
        
        id<CommonDelegateClass> delegate = self.delegate;
        
        NSMutableArray *arrSelectionValue = [[NSMutableArray alloc] init];
        [arrSelectionValue setValue:@"NO" forKey:@"BACK"];
        
        [delegate LocationSelectionDone:arrSelectionValue];
        
        //[self.navigationController popViewControllerAnimated:YES];
        

    }
}

- (IBAction)btnBackClick:(id)sender
{
    id<CommonDelegateClass> delegate = self.delegate;
    
    [delegate BackFromSelectionView];
    
   // [self.navigationController popViewControllerAnimated:YES];
}
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)btnSelectRangeClicked:(id)sender
{
    pickerRange.hidden=NO;
}
#pragma mark - UITEXTFIELD

- (IBAction)txtLocationEditChange:(id)sender
{
   
    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
        //[self startActivity];
        
        NSString *hostURL=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=true&key=AIzaSyDUg1gY-fxa05fbOz6EQIfNQDkPxxf3fbM",txtLocation.text];
        hostURL=[hostURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *url=[[NSURL alloc] initWithString:hostURL];
        //NSLog(@"Location Search URL:-----%@",url);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data,NSError *connectionError)
         {
             if ([data length]>0 && connectionError==nil)
             {
                 NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
                 //NSLog(@"%@",[dict objectForKey:@"predictions"]);
                 NSMutableArray *arrLocationTemp=[[NSMutableArray alloc] init];
                 arrLocationTemp=[dict objectForKey:@"predictions"];
                 //NSMutableArray *arrLocationList=[[NSMutableArray alloc] init];
                 [arrLocation removeAllObjects];
                 for (int index=0; index<[arrLocationTemp count]; index++)
                 {
                    // NSLog(@"%@",[[arrLocationTemp objectAtIndex:index] objectForKey:@"description"]);
                     [arrLocation addObject:[[arrLocationTemp objectAtIndex:index] objectForKey:@"description"]];
                 }
                 
                 //[arrLocation addObject:arrLocationList];
                 [tblLocationList reloadData];
                 //[self stopActivity];
             }
             else
             {
                 [Singleton showToastMessage:@"Couldn't find your location. Please try after some time."];
             }
         }];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    tblLocationList.hidden = NO;
    pickerRange.hidden = YES;
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [txtLocation resignFirstResponder];
    return YES;
}
#pragma mark - UITableView Delegate  -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrLocation count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [tableView setUserInteractionEnabled:YES];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    cell.textLabel.text = [arrLocation objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    txtLocation.text=[arrLocation objectAtIndex:indexPath.row];
    
    tblLocationList.hidden=YES;
    
    [self startActivity];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[self geocoder] geocodeAddressString:[arrLocation objectAtIndex:indexPath.row] completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error)
            {
                //block(nil, nil, error);
            } else
            {
                //NSLog(@"%@",placemarks);
//                NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
                
                CLPlacemark *placemark = [placemarks onlyObject];
                CLLocation *location=placemark.location;
                CLLocationCoordinate2D coordinate = [location coordinate];
//                [self setPlace:coordinate];
                NSLog(@"%f",coordinate.latitude);
                NSLog(@"%f",coordinate.longitude);
                
                NSNumber *lat = [NSNumber numberWithDouble:coordinate.latitude];
                NSNumber *lon = [NSNumber numberWithDouble:coordinate.longitude];
                NSDictionary *userLocation=@{@"lat":lat,@"long":lon};
                
                [[NSUserDefaults standardUserDefaults] setObject:userLocation forKey:@"userLocation"];
                [[NSUserDefaults standardUserDefaults] setObject:txtLocation.text forKey:@"userSearchedArea"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                [self stopActivity];
            }
        }];
    }];
    [txtLocation resignFirstResponder];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CLGeocoder *)geocoder
{
    if (!geocoder) {
        geocoder = [[CLGeocoder alloc] init];
    }
    return geocoder;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    pickerRange.hidden=YES;
    tblLocationList.hidden = YES;
    [super touchesBegan:touches withEvent:event];
}
#pragma mark UIPICKER methods


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label;
    
    if(IS_IPAD)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, pickerView.frame.size.width, 84)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:32];
    }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, pickerView.frame.size.width, 44)];
        label.font = [UIFont fontWithName:@"OpenSans-Light" size:20];
    }
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    
    label.text = [NSString stringWithFormat:@"  %@", [arrRange objectAtIndex:row]];
//    [btnSelectRange setTitle:[NSString stringWithFormat:@"%@",  [arrRange objectAtIndex:2]] forState:UIControlStateNormal];
    
    
    return label;
    
}
// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //    if([[Singleton sharedSingleton] getarrCityList].count > 0)
    //    {
    //        return [[[[Singleton sharedSingleton] getarrCityList] objectAtIndex:0] count];
    //    }
   /* if(self.btnSubmit.tag == 1)
    {
        return [[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] count];
    }
    else if(self.btnSubmit.tag == 2)
    {
        return [[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0] count];
    }
    else if(self.btnSubmit.tag == 3)
    {
        return [[[[Singleton sharedSingleton] getarrCityList] objectAtIndex:0] count];
    }*/
    
    return [arrRange count];
    
    return 0;
    //   return [[Singleton sharedSingleton] getarrCityList].count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(self.btnSubmit.tag == 1)
    {
        return  [NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"CountryName"]];
    }
    else if(self.btnSubmit.tag == 2)
    {
        return [NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"StateName"]];
    }
    else if(self.btnSubmit.tag == 3)
    {
        return [NSString stringWithFormat:@"  %@", [[[[Singleton sharedSingleton] getarrCityList] objectAtIndex:0] objectAtIndex:row]];
    }
    return @"";
    //  return  [NSString stringWithFormat:@"  %@", [[[[Singleton sharedSingleton] getarrCityList] objectAtIndex:0] objectAtIndex:row]];
}
// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
     [btnSelectRange setTitle:[NSString stringWithFormat:@"%@",  [arrRange objectAtIndex:row]] forState:UIControlStateNormal];

    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    [st setValue:[arrRangeOnlyNumber objectAtIndex:row] forKey:@"SelectedRange"];
    [st setValue:[arrRange objectAtIndex:row] forKey:@"SelectedRangeButtonTitle"];
    
    [st synchronize];
    
    //[self.btnCity setTitle:[NSString stringWithFormat:@"  %@", [[[[Singleton sharedSingleton] getarrCityList] objectAtIndex:0] objectAtIndex:row]] forState:UIControlStateNormal];
    
  /*  NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    
    if(self.btnSubmit.tag == 1)
    {
        [btnCountry setTitle:[NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"CountryName"]] forState:UIControlStateNormal];
       
        [[Singleton sharedSingleton] setCountryId:[NSString stringWithFormat:@"%d", row]];
        
       [[Singleton sharedSingleton] setCountryDBID:[NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:[[Singleton sharedSingleton].countryId intValue]] objectForKey:@"CountryId"]]];
        
        [st setValue:[Singleton sharedSingleton].countryDBID forKey:@"UserSelectedCountry"];
        [self startActivity];
        [[Singleton sharedSingleton] getStateList: [Singleton sharedSingleton].countryDBID];
        
        
        btnState.enabled = NO;
        btnCity.enabled = NO;
        [btnState setTitle:@"Select State" forState:UIControlStateNormal];
        [btnCity setTitle:@"Select City" forState:UIControlStateNormal];
//        [[Singleton sharedSingleton] setStateId:@"0"];
//        [[Singleton sharedSingleton] setCityId:@"0"];
        
    }
    else if(self.btnSubmit.tag == 2)
    {
        [btnState setTitle:[NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"StateName"]] forState:UIControlStateNormal];
        
        NSLog(@"State : %@", btnState.titleLabel.text);
        
        [[Singleton sharedSingleton] setStateId:[NSString stringWithFormat:@"%ld", (long)row]];
        
        [[Singleton sharedSingleton] setStateDBID:[NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] arrStateList] objectAtIndex:0]objectAtIndex:[[Singleton sharedSingleton].stateId intValue]] objectForKey:@"StateID"]]];
        
        [st setValue:[Singleton sharedSingleton].stateDBID forKey:@"UserSelectedState"];
        
        btnCity.enabled = NO;
        [btnCity setTitle:@"Select City" forState:UIControlStateNormal];
        
        [self startActivity];
        [[Singleton sharedSingleton] getCityList:[Singleton sharedSingleton].stateDBID];
    }
    else if(self.btnSubmit.tag == 3)
    {
        [btnCity setTitle:[NSString stringWithFormat:@"%@", [[[[Singleton sharedSingleton] getarrCityList] objectAtIndex:0]objectAtIndex:row] ] forState:UIControlStateNormal];
        [[Singleton sharedSingleton] setCityId:[NSString stringWithFormat:@"%d", row]];
        [[Singleton sharedSingleton] setCityDBID:btnCity.titleLabel.text];
        [st setValue:[Singleton sharedSingleton].cityDBID forKey:@"UserSelectedCity"];
    }
    [st synchronize];
   */
    
    
}
@end

