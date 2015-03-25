//
//  addRestaurantViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "addRestaurantViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Singleton.h"


@interface addRestaurantViewController ()

@end

@implementation addRestaurantViewController

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
    
//     self.lblTitleAddRestaurant.font = FONT_centuryGothic_35;
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    
    //self.btnState.userInteractionEnabled = NO;
    self.btnState.enabled = NO;
    
  
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.scrlView addGestureRecognizer:tapGesture];
    
    stateId=@"";
    countryId=@"";
    
    self.btnSave.layer.cornerRadius = 5.0;
    self.btnSave.clipsToBounds = YES;
    
    self.btnCancel.layer.cornerRadius = 5.0;
    self.btnCancel.clipsToBounds = YES;
    
    self.btnDoneCountryState.layer.cornerRadius = 5.0;
    self.btnDoneCountryState.clipsToBounds = YES;
    
    
      if(IS_IPAD)
      {
          self.viewbackForm.layer.cornerRadius = 5.0;
          self.viewbackForm.clipsToBounds = YES;
          self.viewbackForm.layer.borderColor = [UIColor lightGrayColor].CGColor;
          self.viewbackForm.layer.borderWidth = 1.0f;

      }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GettingCountryList) name:@"GettingCountryList" object:nil];
    
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GettingStateList) name:@"GettingStateList" object:nil];
    
    self.btnState.enabled = NO;
    
    //Cancel & Done button for num pad
    UIToolbar *numberToolbar = [[Singleton sharedSingleton] AccessoryButtonsForNumPad:self];
    self.txtMobile.inputAccessoryView = numberToolbar;
    self.txtZipcode.inputAccessoryView = numberToolbar;
    // Do any additional setup after loading the view from its nib.
}
-(void)cancelNumberPad{
    
    [self.txtMobile resignFirstResponder];
    [self.txtZipcode resignFirstResponder];
    self.scrlView.contentOffset=CGPointMake(0, 0);
    // self.txtContactnumber.text = @"";
}

-(void)doneWithNumberPad{
    //NSString *numberFromTheKeyboard = self.txtContactnumber.text;
    [self.txtMobile resignFirstResponder];
    [self.txtZipcode resignFirstResponder];
    self.scrlView.contentOffset=CGPointMake(0, 0);
}
-(void)GettingCountryList
{
    [self stopActivity];
    btnbackOfPicker.hidden = NO;
    self.pickerCountryState.hidden = NO;
    countryId=@"0";
    self.btnDoneCountryState.tag = 1;
    [self.pickerCountryState reloadAllComponents];
    [self.pickerCountryState selectRow:0 inComponent:0 animated:YES];
    [self.btnState setTitle:@"  Select State" forState:UIControlStateNormal];
    stateDBID=@"";
    if(!IS_IPAD)
    {
        [self.view addSubview:self.viewCountryState];
    }
}
-(void)GettingStateList
{
    self.btnState.enabled = YES;
    [self stopActivity];
    if([[[Singleton sharedSingleton] getarrStateList] count]<=0)
    {
        self.btnState.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIBUUTON CLICKES

- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnSaveClicked:(id)sender {
    
    [self.view endEditing:YES];
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
    }
    else
    {
    
//        NSString *country =[[Singleton sharedSingleton] ISNSSTRINGNULL:[self.btnCountry.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] ;
//        
//        NSString *state = [NSString stringWithFormat:@"%@", [self.btnState.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
//        

        
     //CountryId
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"CountryName matches %@ ", country];
//        NSArray *array = [[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] filteredArrayUsingPredicate: predicate];
//        NSMutableArray *arrFindingIds = [[NSMutableArray alloc] initWithArray:array];
//        NSLog(@"---- %@", arrFindingIds);
//        if([arrFindingIds count] > 0)
//        {
//            country = [NSString stringWithFormat:@"%@", [[arrFindingIds objectAtIndex:0] objectForKey:@"CountryId"]];
//        }
//        
//        predicate = [NSPredicate predicateWithFormat:@"StateName matches %@ ", state];
//        array = [[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0] filteredArrayUsingPredicate: predicate];
//        arrFindingIds = [[NSMutableArray alloc] initWithArray:array];
//        NSLog(@"---- %@", arrFindingIds);
//        if([arrFindingIds count] > 0)
//        {
//            state = [NSString stringWithFormat:@"%@", [[arrFindingIds objectAtIndex:0] objectForKey:@"StateID"]];
//        }
        
        NSString * name = [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.txtFullName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        NSString * mobile = [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.txtMobile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        NSString * streetline1 = [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.txtStreetLine1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        NSString * streetline2 = [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.txtStreetLine2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        NSString * city = [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.txtCity.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        NSString * zipcode = [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.txtZipcode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        
        if(![[self.btnCountry.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"Select Country"])
        {
            countryDBID = [[Singleton sharedSingleton] getCountryIdFromIndexId:self.btnCountry.titleLabel.text];
        }
        else
        {
            countryDBID=@"";
        }
       countryDBID = [[Singleton sharedSingleton] ISNSSTRINGNULL:countryDBID];
        
        if(![[self.btnState.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"  Select State"])
        {
            stateDBID = [[Singleton sharedSingleton] getStateIdFromIndexId:self.btnState.titleLabel.text];
        }
        else
        {
            stateDBID=@"";
        }
        stateDBID = [[Singleton sharedSingleton] ISNSSTRINGNULL:stateDBID];
        
        NSLog(@"zipcode.length : %lu", (unsigned long)zipcode.length);
        NSLog(@"mobile.length : %lu", (unsigned long)mobile.length);
        
        if([name isEqualToString:@""] || [mobile isEqualToString:@""] || [streetline1 isEqualToString:@""] || [streetline2 isEqualToString:@""] || [city isEqualToString:@""]  || [zipcode isEqualToString:@""] || [countryDBID isEqualToString:@""] || [stateDBID isEqualToString:@""])
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_EMPTY_DATA message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else if(zipcode.length <= 3)
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Zipcode length should be atleast 3 or more" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
        }
        else if(mobile.length < 4)
        {
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Mobile length should be atleast 4 or more" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
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
            //:ParentUserId, RegistrationSource,MobileNo,StoreName,StreetLine1,StreetLine2,City,State,Country,ZipCode,Latidute,Longitude
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@"IOS" forKey:@"RegistrationSource"];
            [dict setValue:userId forKey:@"ParentUserId"];
            [dict setValue:name forKey:@"StoreName"];
            [dict setValue:mobile forKey:@"MobileNo"];
            [dict setValue:stateDBID forKey:@"State"];
            [dict setValue:countryDBID forKey:@"Country"];
            [dict setValue:streetline1 forKey:@"StreetLine1"];
            [dict setValue:streetline2 forKey:@"StreetLine2"];
            [dict setValue:city forKey:@"City"];
            [dict setValue:zipcode forKey:@"ZipCode"];
//            [dict setValue:@"23.121212" forKey:@"Latidute"];
//            [dict setValue:@"37.121212" forKey:@"Longitude"];
            
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 [self stopActivity];
                 NSLog(@"Add Restaurant  :  %@ -- ", dict);
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
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"message"]  message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         alert.tag = 14;
                         [alert show];
                     }
                 }
                 else
                 {
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                 }
             } :@"Restaurant/AddRestaurant" data:dict];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 14)
    {
        if(buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (buttonIndex == 1)
        {
            
        }
    }
}

-(void)getCountryList
{
    if([[[Singleton sharedSingleton] arrCountryList] count] <= 0)
    {
        [[Singleton sharedSingleton] getCountryList];
    }
    
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
- (IBAction)btnCountryClicked:(id)sender
{
    if([[[Singleton sharedSingleton] arrCountryList] count] <= 0)
    {
        [self startActivity];
        [[Singleton sharedSingleton] getCountryList];
    }
    else
    {
        btnbackOfPicker.hidden = NO;
        self.pickerCountryState.hidden = NO;
        countryId=@"0";
        self.btnDoneCountryState.tag = 1;
        [self.pickerCountryState reloadAllComponents];
        [self.pickerCountryState selectRow:0 inComponent:0 animated:YES];
        [self.btnState setTitle:@"  Select State" forState:UIControlStateNormal];
        stateDBID=@"";
        if(!IS_IPAD)
        {
            [self.view addSubview:self.viewCountryState];
        }
    }
  
}

- (IBAction)btnStateClicked:(id)sender
{
    if([[[Singleton sharedSingleton]  getarrStateList] count] > 0)
    {
        self.pickerCountryState.hidden = YES;
        stateId=@"0";
        self.btnDoneCountryState.tag = 2;
        [self.pickerCountryState reloadAllComponents];
        [self.pickerCountryState selectRow:0 inComponent:0 animated:YES];
        self.pickerCountryState.hidden = NO;
        if(!IS_IPAD)
        {
            [self.view addSubview:self.viewCountryState];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please wait Loading State..." message:@"" delegate:self cancelButtonTitle:@"" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)removeViewOfCountryState
{
    [self.viewCountryState removeFromSuperview];
    
}

- (IBAction)btnDoneCountryStateClicked:(id)sender
{
    [self performSelector:@selector(removeViewOfCountryState) withObject:nil afterDelay:0.2];
    
    UIButton *btn = (UIButton*)sender;
    if(btn.tag == 1)
    {
        //country
        NSLog(@"Selected Country index---- %@", countryId);
        
        [self.btnCountry setTitle:[NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:[countryId intValue]] objectForKey:@"CountryName"]] forState:UIControlStateNormal];
        
        // cId - is Country id in DB
        // Country id - is local varible contain index of array
        
        countryDBID = [[Singleton sharedSingleton] getCountryIdFromIndexId:self.btnCountry.titleLabel.text];
        
        [self startActivity];
        [[Singleton sharedSingleton] getStateList: countryDBID];
       // [self stopActivity];
       // self.btnState.enabled = YES;        
    }
    else if(btn.tag == 2)
    {
        //state
        NSLog(@"Selected State index---- %@", stateId);
        [self.btnState setTitle:[NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0]objectAtIndex:[stateId intValue]] objectForKey:@"StateName"] ] forState:UIControlStateNormal];
        
    }
}

#pragma mark -
#pragma mark UITextViewDelegate methods

-(void)hideKeyboard
{
    [self.txtFullName resignFirstResponder];
    [self.txtMobile resignFirstResponder];
    [self.txtCity resignFirstResponder];
    [self.txtFullName resignFirstResponder];
    [self.txtStreetLine1 resignFirstResponder];
    [self.txtStreetLine2 resignFirstResponder];
    [self.txtZipcode resignFirstResponder];
    
    self.scrlView.contentOffset=CGPointMake(0, 0);
    self.pickerCountryState.hidden = YES;
    btnbackOfPicker.hidden = YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.pickerCountryState.hidden = YES;
    btnbackOfPicker.hidden = YES;
    self.scrlView.contentOffset=CGPointMake(0, 40);
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.scrlView.contentOffset=CGPointMake(0, 0);
    return YES;
}
#pragma mark UiTextfield delegate Methods

#pragma mark TextField Delegate
- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString: (NSString *)string
{
    //return yes or no after comparing the characters
    
    
    // allow backspace
    if (!string.length)
    {
        return YES;
    }
    
    if(theTextField == self.txtZipcode)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS_ZIPCODE] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    else if(theTextField == self.txtMobile)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS_MOBILE] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    
    
   return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    btnbackOfPicker.hidden=YES;
    self.pickerCountryState.hidden=YES;
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if(!IS_IPAD)
    {
      
        if (textField==self.txtCity)
        {
            self.scrlView.contentOffset=CGPointMake(0, 40);
        }
        else if (textField==self.txtZipcode)
        {
            
            self.scrlView.contentOffset=CGPointMake(0, 70);
        }
        else if (textField==self.txtMobile)
        {
            self.scrlView.contentOffset=CGPointMake(0, 100);
        }
        
    }
  
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    if (textField==self.txtFullName)
    {
        [self.txtFullName resignFirstResponder];
    }
    else if (textField==self.txtStreetLine1)
    {
        [self.txtStreetLine1 resignFirstResponder];
        [self.txtStreetLine2 becomeFirstResponder];
    }
    else if (textField==self.txtStreetLine2)
    {
        [self.txtStreetLine2 resignFirstResponder];
        [self.txtCity becomeFirstResponder];
    }
    else if (textField==self.txtCity)
    {
        [self.txtCity resignFirstResponder];
        [self.txtZipcode becomeFirstResponder];
        if(!IS_IPAD)
        {
            self.scrlView.contentOffset=CGPointMake(0, 40);
        }
    }
    else if (textField==self.txtZipcode)
    {
        [self.txtZipcode resignFirstResponder];
        [self.txtMobile becomeFirstResponder];
        if(!IS_IPAD)
        {
            self.scrlView.contentOffset=CGPointMake(0, 80);
        }
    }
    else if (textField==self.txtMobile)
    {
        [self.txtMobile resignFirstResponder];
        if(!IS_IPAD)
        {
            self.scrlView.contentOffset=CGPointMake(0, 0);
        }
    }
    
    return YES;
}


#pragma mark -
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
    
    //BOOL ISLoadedState=false;
    if(self.btnDoneCountryState.tag == 1)
    {
        label.text = [NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"CountryName"]];
        
//         if(IS_IPAD)
//         {
//             if([self.btnCountry.titleLabel.text isEqualToString:@"  Select Country"])
//             {
//                 ISLoadedState = true;
//             }
//         }

        [self.btnCountry setTitle:[NSString stringWithFormat:@" %@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:0] objectForKey:@"CountryName"]] forState:UIControlStateNormal];
        countryId = [NSString stringWithFormat:@"%ld", (long)row];
        
        
//        if(IS_IPAD)
//        {
//            if(ISLoadedState)
//            {
//                ISLoadedState=false;
//                //getting State
//                [self startActivity];
//                // 0 index
//                countryDBID = [[Singleton sharedSingleton] getCountryIdFromIndexId:[[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:0] objectForKey:@"CountryName"]];
//                [[Singleton sharedSingleton] getStateList: countryDBID];
//            }
//        }
      
    }
    else if(self.btnDoneCountryState.tag == 2)
    {
         label.text = [NSString stringWithFormat:@"  %@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"StateName"]];
        
        [self.btnState setTitle:[NSString stringWithFormat:@" %@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"StateName"] ] forState:UIControlStateNormal];
        
        stateId = [NSString stringWithFormat:@"%ld", (long)row];
        
    }
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
    if(self.btnDoneCountryState.tag == 1)
    {
          return [[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] count];
    }
    else if(self.btnDoneCountryState.tag == 2)
    {
          return [[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0] count];
    }
    return 0;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"  %@", [[[[Singleton sharedSingleton] getarrCountryList] objectAtIndex:0] objectAtIndex:row]];
}
// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(self.btnDoneCountryState.tag == 1)
    {
        [self.btnCountry setTitle:[NSString stringWithFormat:@" %@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"CountryName"]] forState:UIControlStateNormal];
        [self.btnCountry setTitle:[NSString stringWithFormat:@" %@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"CountryName"]] forState:UIControlStateSelected];
        [self.btnCountry setTitle:[NSString stringWithFormat:@" %@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"CountryName"]] forState:UIControlStateHighlighted];
        
        NSLog(@"btn title 1 : %@", self.btnCountry.titleLabel.text);
        NSLog(@"btn title 2: %@", [[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"CountryName"]);
        
        countryId = [NSString stringWithFormat:@"%d", row]; //[[[[[Singleton sharedSingleton] arrCountryList] objectAtIndex:0] objectAtIndex:row] objectForKey:@"CountryId"];
        
        if(IS_IPAD)
        {
            //getting State
            [self startActivity];
            countryDBID = [[Singleton sharedSingleton] getCountryIdFromIndexId:self.btnCountry.titleLabel.text];
            [[Singleton sharedSingleton] getStateList: countryDBID];
        }
       
    }
    else if(self.btnDoneCountryState.tag == 2)
    {
        [self.btnState setTitle:[NSString stringWithFormat:@" %@", [[[[[Singleton sharedSingleton] getarrStateList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"StateName"] ] forState:UIControlStateNormal];
        
        stateId = [NSString stringWithFormat:@"%d", row]; //[[[[[Singleton sharedSingleton] arrStateList] objectAtIndex:0]objectAtIndex:row] objectForKey:@"StateID"];        
    }
}


@end
