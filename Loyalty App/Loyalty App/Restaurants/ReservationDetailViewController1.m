//
//  ReservationDetailViewController1.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "ReservationDetailViewController1.h"
#import "Singleton.h"

@interface ReservationDetailViewController1 ()
@end

@implementation ReservationDetailViewController1

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark UITEXTFIELD DELEGATE - HIDE KEYBOARD

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.scrollvw.contentOffset=CGPointMake(0, 130);
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.scrollvw.contentOffset=CGPointMake(0, 0);
    return YES;
}

#pragma mark
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    IS_Validation_Start = FALSE;
    
    app = APP;
    [self.view addSubview:[app setFooterPart]];
    app._flagMainBtn = 0; //2;
    
//    self.lblTitleReservation.font = FONT_centuryGothic_35;
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    self.pickerDateTime.minimumDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    self.pickerDateTime.maximumDate =newDate;
    
    self.btnDateDone.layer.cornerRadius = 5.0;
    self.btnDateDone.clipsToBounds = YES;
    
    self.btnSave.layer.cornerRadius = 5.0;
    self.btnSave.clipsToBounds = YES;
    
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        [[UITableView appearanceWhenContainedIn:[UIDatePicker class], nil] setBackgroundColor:nil]; // for iOS 8
    } else {
        [[UITableViewCell appearanceWhenContainedIn:[UIDatePicker class], [UITableView class], nil] setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]]; // for iOS 7
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.scrollvw addGestureRecognizer:tapGesture];
    
    indexId = [[Singleton sharedSingleton] getIndexId];
    
    arrValidateTable = [[NSMutableArray alloc] init];
    [self startActivity];
    strURL =@"Data/TableTypeList";
    [self getTableList];
    
    [self.pickerDateTime addTarget:self action:@selector(updateLabelFromPicker:) forControlEvents:UIControlEventValueChanged];


    if(IS_IPAD)
    {
        viewBackForm.layer.cornerRadius = 5.0;
        viewBackForm.clipsToBounds = YES;
        viewBackForm.layer.borderColor = [UIColor lightGrayColor].CGColor;
        viewBackForm.layer.borderWidth = 1.0f;
        
    }
    
    ///Restaurant/TableBooking
    
    //Cancel & Done button for num pad
    UIToolbar *numberToolbar = [[Singleton sharedSingleton] AccessoryButtonsForNumPad:self];
    self.txtTotalPerson.inputAccessoryView = numberToolbar;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)cancelNumberPad{
    
    [self.txtTotalPerson resignFirstResponder];
    self.scrollvw.contentOffset=CGPointMake(0, 0);
    // self.txtContactnumber.text = @"";
}

-(void)doneWithNumberPad{
    //NSString *numberFromTheKeyboard = self.txtContactnumber.text;
    [self.txtTotalPerson resignFirstResponder];
    self.scrollvw.contentOffset=CGPointMake(0, 0);
}
#pragma  mart UIBUTTON CLICK
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
-(void)getTableList
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
    }
    else
    {
     
        NSString * restaurantId = [[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"UserId"];
         NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if([strURL isEqualToString:@"Data/TableTypeList"])
        {
             [self startActivity];
            
            self.btnSelecetTable.enabled = NO;
            [dict setValue:restaurantId forKey:@"RestaurantId"];
        }
        else if([strURL isEqualToString:@"Restaurant/ValidateWithTableAssignList"])
        {
             [dict setValue:restaurantId forKey:@"RestaurantId"];
             [dict setValue:selectDate forKey:@"BookingDate"];
        }
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Table List :  %@ -- ", dict);
             if (dict)
             {
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
                     [self stopActivity];
                     if([strURL isEqualToString:@"Data/TableTypeList"])
                     {
                         self.btnSelecetTable.enabled = YES;
                         
                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Failed to get Table List. You can not do any reservation. Please try after some time." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         alt.tag = 21;
                         [alt show];
                     }
                     else if([strURL isEqualToString:@"Restaurant/ValidateWithTableAssignList"])
                     {
                         IS_Validation_Start = FALSE;
                     }

                 }
                 else
                 {
                       [self stopActivity];
                     
                     if([strURL isEqualToString:@"Data/TableTypeList"])
                     {
                          self.btnSelecetTable.enabled = YES;
                         arrSelectTable =  [[NSMutableArray alloc] initWithObjects:[dict objectForKey:@"data"], nil];
                         [[Singleton sharedSingleton] setarrTableList:arrSelectTable];
                     }
                     else if([strURL isEqualToString:@"Restaurant/ValidateWithTableAssignList"])
                     {
                         IS_Validation_Start = FALSE;
                         arrValidateTable = [dict objectForKey:@"data"];
                     }                     
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
- (IBAction)updateLabelFromPicker:(id)sender {
    
     //self.label.text = [self.dateFormatter stringFromDate:self.picker.date];
    
    if (self.DateTime_Tag == 1)
    {
        //Date
        
        NSDate *date=[self.pickerDateTime date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]]; 
        [formatter setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd
        selectDate = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        
         [formatter setDateFormat:@"dd MMMM yyyy"];
        [self.btnSelectDate setTitle:[NSString stringWithFormat:@"  %@",[formatter stringFromDate:date]] forState:UIControlStateNormal];
        
        //Restaurant/ValidateWithTableAssignList
     
    }
    else if (self.DateTime_Tag == 2)
    {
        // Start Time
        NSDate *date=[self.pickerDateTime date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       
        [formatter setDateFormat:@"HH:mm"];//yyyy-MM-dd
        startTime = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        
        [formatter setDateFormat:@"hh:mm a"];
        [self.btnStartTime setTitle:[NSString stringWithFormat:@"  %@",[formatter stringFromDate:date]] forState:UIControlStateNormal];
        
        //NSLog(@" Start Time : %@", self.btnStartTime.titleLabel.text);
    }
    else if (self.DateTime_Tag == 3)
    {
        //End Time
        //datePick.datePickerMode = UIDatePickerModeTime;
        NSDate *date=[self.pickerDateTime date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];// 'hh:mm a'
        endTime = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        
        [formatter setDateFormat:@"hh:mm a"];
        [self.btnEndTime setTitle:[NSString stringWithFormat:@"  %@",[formatter stringFromDate:date]] forState:UIControlStateNormal];
        
        //NSLog(@" End Date : %@", self.btnEndTime.titleLabel.text);
    }
    else if(self.DateTime_Tag == 4)
    {
//        [UIView setAnimationsEnabled:NO];
//        //   [self.btnSelecetTable setTitle:[NSString stringWithFormat:@"%@", [arrSelectTable objectAtIndex:0]] forState:UIControlStateNormal];
//        
//        
//        
//        [UIView setAnimationsEnabled:YES];
//        NSLog(@" Selected Table  : %@", self.btnSelecetTable.titleLabel.text);
    }

    
   
}
/*
-(IBAction)btnDateDoneClick:(id)sender;
{
    
    
    if (self.DateTime_Tag == 1)
    {
        //Date
        
        NSDate *date=[self.pickerDateTime date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd
        [self.btnSelectDate setTitle:[NSString stringWithFormat:@"  %@",[formatter stringFromDate:date]] forState:UIControlStateNormal];
        
        NSLog(@" Selected Date : %@", self.btnSelectDate.titleLabel.text);
    }
    else if (self.DateTime_Tag == 2)
    {
        // Start Time
        NSDate *date=[self.pickerDateTime date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];//yyyy-MM-dd
        
         [self.btnStartTime setTitle:[NSString stringWithFormat:@"  %@",[formatter stringFromDate:date]] forState:UIControlStateNormal];
        
        NSLog(@" Start Time : %@", self.btnStartTime.titleLabel.text);
    }
    else if (self.DateTime_Tag == 3)
    {
        //End Time
        //datePick.datePickerMode = UIDatePickerModeTime;
        NSDate *date=[self.pickerDateTime date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];// 'hh:mm a'
        
        [self.btnEndTime setTitle:[NSString stringWithFormat:@"  %@",[formatter stringFromDate:date]] forState:UIControlStateNormal];
        
        NSLog(@" End Date : %@", self.btnEndTime.titleLabel.text);
    }
    else if(self.DateTime_Tag == 4)
    {
        [UIView setAnimationsEnabled:NO];
     //   [self.btnSelecetTable setTitle:[NSString stringWithFormat:@"%@", [arrSelectTable objectAtIndex:0]] forState:UIControlStateNormal];
        
        
        
        [UIView setAnimationsEnabled:YES];
        NSLog(@" Selected Table  : %@", self.btnSelecetTable.titleLabel.text);
    }
    
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp                  animations:^ {      [self.viewBG removeFromSuperview]; }
                    completion:nil];
    
}
*/

- (IBAction)selectDateTimeClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    UIButton *temp=(UIButton*)sender;
    
    if (temp.tag==1)
    {
        //Date
        self.pickerDateTime.datePickerMode = UIDatePickerModeDate;
        self.DateTime_Tag = 1;
       
        NSDate *date=[self.pickerDateTime date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        [formatter setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd
        selectDate = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        
        [formatter setDateFormat:@"dd MMMM yyyy"];
        [self.btnSelectDate setTitle:[NSString stringWithFormat:@"  %@",[formatter stringFromDate:date]] forState:UIControlStateNormal];

        IS_Validation_Start=TRUE;
        strURL=@"Restaurant/ValidateWithTableAssignList";
        [self performSelectorInBackground:@selector(getTableList) withObject:nil];
        
    }
    else if (temp.tag==2)
    {
        // Start Time
        self.pickerDateTime.datePickerMode = UIDatePickerModeTime;
        self.DateTime_Tag=2;
       
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH"];
        NSString *strStartTime = [formatter stringFromDate:[NSDate date]];
        
        int startHour = strStartTime.intValue + 1;
        
        NSDate *date1 = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
        NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date1];
        [components setHour: startHour];
        [formatter setDateFormat:@"mm"];
        [components setMinute: [[formatter stringFromDate:[NSDate date]] integerValue]];
        [components setSecond: 0];
        NSDate *startDate = [gregorian dateFromComponents: components];
        
        [self.pickerDateTime setDatePickerMode:UIDatePickerModeTime];
        [self.pickerDateTime setMinimumDate:startDate];
        [self.pickerDateTime setDate:startDate animated:YES];
        [self.pickerDateTime reloadInputViews];
        
        // Start Time
        NSDate *date=[self.pickerDateTime date];
      
        [formatter setDateFormat:@"hh:mm a"];
        NSLog(@"date : %@ : %@", date, [formatter stringFromDate:date]);
        [self.btnStartTime setTitle:[NSString stringWithFormat:@"  %@",[formatter stringFromDate:date]] forState:UIControlStateNormal];
        
        [formatter setDateFormat:@"HH:mm"];//yyyy-MM-dd
        startTime = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    }
    else if (temp.tag==3)
    {
        //End Time
        self.pickerDateTime.datePickerMode = UIDatePickerModeTime;
        self.DateTime_Tag=3;
        
        //End Time
        //datePick.datePickerMode = UIDatePickerModeTime;
        NSDate *date=[self.pickerDateTime date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"hh:mm a"];
        [self.btnEndTime setTitle:[NSString stringWithFormat:@"  %@",[formatter stringFromDate:date]] forState:UIControlStateNormal];
        
        [formatter setDateFormat:@"HH:mm"];// 'hh:mm a'
        endTime = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        
    }
    
    self.pickerDateTime.hidden = NO;
    self.pickerTable.hidden = YES;
    
//    CGRect frame =  self.btnDateDone.frame;
//    frame.origin.y = self.pickerDateTime.frame.origin.y + self.pickerDateTime.frame.size.height + 20;
//    self.btnDateDone.frame = frame;
    //self.viewBG.hidden = NO;
    
    //[self.view addSubview:self.viewBG];
    
    
//     [UIView transitionWithView:self.view
//                      duration:0.5
//                       options:UIViewAnimationOptionTransitionCurlDown                   animations:^ {
//                           
//                           self.pickerDateTime.hidden = NO;
//                           self.pickerTable.hidden = YES;
//                           
//                           CGRect frame =  self.btnDateDone.frame;
//                           frame.origin.y = self.pickerDateTime.frame.origin.y + self.pickerDateTime.frame.size.height + 20;
//                           self.btnDateDone.frame = frame;
//                           self.viewBG.hidden = NO;
//
//                           [self.view addSubview:self.viewBG];
//                        
//                         }
//                    completion:nil];
}


- (IBAction)selectTableClicked:(id)sender {
    
    @try {
        [self.view endEditing:YES];
        [self.txtTotalPerson resignFirstResponder];
        self.scrollvw.contentOffset = CGPointMake(0,0);
        
        if(![[[Singleton sharedSingleton]ISNSSTRINGNULL:selectDate ] isEqualToString:@""]&& ![[[Singleton sharedSingleton]ISNSSTRINGNULL:startTime ]  isEqualToString:@""] && ![[[Singleton sharedSingleton]ISNSSTRINGNULL:endTime ]  isEqualToString:@""])
        {
            if([arrSelectTable count] > 0)
            {
                // self.viewBG.hidden = NO;
                //[self.view addSubview:self.viewBG];
                self.pickerDateTime.hidden = YES;
                self.pickerTable.hidden = NO;
                [self.pickerTable reloadAllComponents];
                [self.pickerTable selectRow:0 inComponent:0 animated:YES];
                self.DateTime_Tag = 4;
                
            }
            else
            {
                UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Failed to get Table List" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alt show];
            }            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please First Select Date and Time" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"-- Error : %@", exception);
    }
    
}

- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnSaveClicked:(id)sender
{
    [self.view endEditing:YES];
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
    }
    else
    {
        //        BookingDate= 2014-08-12,StartTime= 17:00,EndTime= 20:00,TableType = Family,RestaurantId = EF592442-2DD3-49C7-A550-D27189BEEEE8,UserId = D56D9F15-A539-4384-A8E4-B5E6AB9C3688,TotalPersons=3
        
        NSString *tblName = [NSString stringWithFormat:@"%@", [self.btnSelecetTable.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:tblName] isEqualToString:@""] && ![[[Singleton sharedSingleton] ISNSSTRINGNULL:tblName] isEqualToString:@"Select Any Table"])
        {
            NSArray *arrTable = [tblName componentsSeparatedByString:@"-"];
            NSString * selectTable, *chairStr;
            int totalChair=0;
            if([arrTable count] > 0)
            {
                selectTable = [[Singleton sharedSingleton] ISNSSTRINGNULL:[arrTable objectAtIndex:0]];
                
                if([arrTable count] > 1)
                {
                    chairStr = [arrTable objectAtIndex:1] ;
                    NSArray *arr = [chairStr componentsSeparatedByString:@""];
                    if([arr count] > 0)
                    {
                        totalChair = [[arr objectAtIndex:0] intValue];
                    }
                }
            }
            
            selectDate =[[Singleton sharedSingleton] ISNSSTRINGNULL:selectDate];// [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.btnSelectDate.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            startTime = [[Singleton sharedSingleton] ISNSSTRINGNULL:startTime];//[[Singleton sharedSingleton] ISNSSTRINGNULL:[self.btnStartTime.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            endTime =[[Singleton sharedSingleton] ISNSSTRINGNULL:endTime];//[[Singleton sharedSingleton] ISNSSTRINGNULL:[self.btnEndTime.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] ;
            NSString * totalPerson = [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.txtTotalPerson.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            NSLog(@"selectTable : %@ ------- selectTable && TableId : %@", selectTable, tableId);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            NSDate *date1 = [formatter dateFromString:startTime];//[NSDate date];
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
            NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date1];
            [formatter setDateFormat:@"mm"];
            [components setMinute: [[formatter stringFromDate:date1] integerValue]+15];
            NSDate *startDate = [gregorian dateFromComponents: components];
            [formatter setDateFormat:@"HH:mm"];
            NSString *newStartTime = [formatter stringFromDate:startDate];
            
            if([endTime isEqualToString:@""] || [selectTable isEqualToString:@""] || [selectDate isEqualToString:@""] || [startTime isEqualToString:@""] || [totalPerson isEqualToString:@""] )
            {
                UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_EMPTY_DATA message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alt show];
                self.btnSave.enabled = true;
            }
            else if([startTime isEqualToString:endTime] || [newStartTime intValue] > [endTime intValue])
            {
                UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Your reservation should be for least 15 mins." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alt show];
                self.btnSave.enabled = true;
            }
            else if([totalPerson intValue] <= 0)
            {
                UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Please Enter Total Person. 0 Person not allowd." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alt show];
                self.btnSave.enabled = true;
            }
            else
            {
                if(IS_Validation_Start)
                {
                    UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:@"Please wait..! We are checking table is avaliable or not" message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [altMsg show];
                }
                else
                {
                    //getting validation array
                    if(arrValidateTable != [NSNull null] && [arrValidateTable count] > 0)
                    {
                        for(int i=0; i<[arrValidateTable count]; i++)
                        {
                            NSDictionary *arrStartTime = [[arrValidateTable objectAtIndex:i] objectForKey:@"StartTime"];
                            NSDictionary *arrEndTime = [[arrValidateTable objectAtIndex:i] objectForKey:@"EndTime"];
                            
                            int h = [[arrStartTime  objectForKey:@"Hours"] intValue];
                            if(h < 10)
                            {
                                h = [[NSString stringWithFormat:@"0%d", h] intValue];
                            }
                            int m = [[arrStartTime objectForKey:@"Minutes"] intValue];
                            if(m < 10)
                            {
                                m = [[NSString stringWithFormat:@"0%d", m] intValue];
                            }
                            NSString *compareStartTime = [NSString stringWithFormat:@"%d:%d", h, m];
                            
                            int hh = [[arrEndTime  objectForKey:@"Hours"] intValue];
                            if(hh < 10)
                            {
                                hh = [[NSString stringWithFormat:@"0%d", hh] intValue];
                            }
                            int mm = [[arrEndTime objectForKey:@"Minutes"] intValue];
                            if(mm < 10)
                            {
                                mm = [[NSString stringWithFormat:@"0%d", mm] intValue];
                            }
                            NSString *compareEndTime = [NSString stringWithFormat:@"%d:%d", hh, mm];
                            
                            NSLog(@"Selected Time : %@ to %@", startTime , endTime);
                            NSLog(@"Compare Time : %@ to %@", compareStartTime , compareEndTime);
                            
                            if([tableId isEqualToString:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrValidateTable objectAtIndex:i] objectForKey:@"TableId"]]])
                            {
                                if([startTime isEqualToString:compareStartTime] || ( startTime > compareStartTime && startTime < compareEndTime))
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"This table already booked on your selected time" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                    [alert show];
                                    return;
                                }
                            }
                        }
                    }
                    
                    self.btnSave.enabled = false;
                    [self startActivity];
                    NSString * restaurantId = [[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"UserId"];
                    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
                    NSString * userId ;
                    if([st objectForKey:@"UserId"])
                    {
                        userId =  [st objectForKey:@"UserId"];
                    }
                    //      NSString * totalPerson = self.btnEndTime.titleLabel.text;
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    [dict setValue:restaurantId forKey:@"RestaurantId"];
                    [dict setValue:userId forKey:@"UserId"];
                    [dict setValue:endTime forKey:@"EndTime"];
                    [dict setValue:tableType forKey:@"TableType"];
                    [dict setValue:tableId forKey:@"TableId"];
                    [dict setValue:selectDate forKey:@"BookingDate"];
                    [dict setValue:startTime forKey:@"StartTime"];
                    [dict setValue:totalPerson forKey:@"TotalPersons"];
                    
                    [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
                     {
                         NSLog(@"Reservation  :  %@ -- ", dict);
                         if (dict)
                         {
                             self.btnSave.enabled = true;
                             Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                             if (!strCode)
                             {
                                 UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                 [alt show];
                             }
                             else
                             {
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"message"]  message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                 alert.tag = 16;
                                 [alert show];
                             }
                             [self stopActivity];
                         }
                         else
                         {
                             UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                             [alt show];
                             [self stopActivity];
                         }
                     } :@"Restaurant/TableBooking" data:dict];
                }
            }
        }
        else{
             self.btnSave.enabled = true;
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_EMPTY_DATA message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alt show];
            self.btnSave.enabled = true;
        }
        //        }
    }
    
    
   
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 16)
    {
        if(buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else  if(alertView.tag == 21)
    {
        if(buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

#pragma mark - UITEXTFIELD
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.pickerDateTime.hidden= YES;
    self.pickerTable.hidden = YES;
    
    if(!IS_IPAD)
    {
        if (textField== self.txtTotalPerson)
        {
            
            self.scrollvw.contentOffset = CGPointMake(0,100);
        }

    }
       return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField== self.txtTotalPerson)
    {
        [self.txtTotalPerson resignFirstResponder];
        self.scrollvw.contentOffset = CGPointMake(0,0);
    }
    return YES;
}
//-(IBAction)hideKeyboard:(id)sender
-(void)hideKeyboard
{
     [self.txtTotalPerson resignFirstResponder];
     self.scrollvw.contentOffset = CGPointMake(0,0);
     self.pickerDateTime.hidden = YES;
     self.pickerTable.hidden = YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // allow backspace
    if (!string.length)
    {
        return YES;
    }
    
    if(textField == self.txtTotalPerson)
    {
        NSString * person = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS_ZIPCODE] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        if([string isEqualToString:filtered])
        {
            if([person intValue] > 50)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Maximum Total person can be 50" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                return NO;
            }
            else
            {
                
            }
        }
        return  [string isEqualToString:filtered];
        
    }
    
    
    return YES;
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
    
    NSString *chair;
    
    @try {
        chair =[NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL: [[[arrSelectTable objectAtIndex:0] objectAtIndex:0] objectForKey:@"TotalChairs"]]];
        if([chair isEqualToString:@"0"])
        {
            chair = @"0";
        }
    }
    @catch (NSException *exception) {
        chair =[NSString stringWithFormat:@"%@", [[[arrSelectTable objectAtIndex:0] objectAtIndex:0] objectForKey:@"TotalChairs"]];
        if([chair isEqualToString:@"0"])
        {
            chair = @"0";
        }
    }
   
  
    
    label.text = [NSString stringWithFormat:@"  %@ - %@ Chairs", [[[arrSelectTable objectAtIndex:0] objectAtIndex:row] objectForKey:@"TableName"],chair];
    
    // select defaulty first row
//    [self.btnSelecetTable setTitle:[NSString stringWithFormat:@"  %@ - %@ Chairs",[[Singleton sharedSingleton] ISNSSTRINGNULL: [[[arrSelectTable objectAtIndex:0] objectAtIndex:0] objectForKey:@"TableName"]], chair] forState:UIControlStateNormal];
//    
//    tableId = [NSString stringWithFormat:@"%@", [[[arrSelectTable objectAtIndex:0] objectAtIndex:0] objectForKey:@"TableId"]];
//    tableType = [NSString stringWithFormat:@"%@", [[[arrSelectTable objectAtIndex:0] objectAtIndex:0] objectForKey:@"TableType"]];
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
    if([arrSelectTable count] > 0)
    {
        return  [[arrSelectTable objectAtIndex:0] count];
    }
    return 0;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([arrSelectTable count] > 0)
    {
        @try {
             return  [NSString stringWithFormat:@"  %@ - %d Chairs", [[[arrSelectTable objectAtIndex:0] objectAtIndex:row] objectForKey:@"TableName"], [[[[arrSelectTable objectAtIndex:0] objectAtIndex:row] objectForKey:@"TotalChairs"] intValue]]; //[[[arrSelectTable objectAtIndex:0] objectAtIndex:row] objectForKey:@"TableName"];
        }
        @catch (NSException *exception) {
             return  [NSString stringWithFormat:@"  %@ - %d Chairs", [[[arrSelectTable objectAtIndex:0] objectAtIndex:row] objectForKey:@"TableName"], [[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[arrSelectTable objectAtIndex:0] objectAtIndex:row] objectForKey:@"TotalChairs"]] intValue]]; //[[[arrSelectTable objectAtIndex:0] objectAtIndex:row] objectForKey:@"TableName"];
        }
        
     
    }
    return  @"abc";
}
// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    @try {
          [self.btnSelecetTable setTitle:[NSString stringWithFormat:@"  %@ - %d Chairs", [[[arrSelectTable objectAtIndex:0] objectAtIndex:row] objectForKey:@"TableName"], [[[[arrSelectTable objectAtIndex:0] objectAtIndex:row] objectForKey:@"TotalChairs"] intValue]] forState:UIControlStateNormal];
    }
    @catch (NSException *exception) {
          [self.btnSelecetTable setTitle:[NSString stringWithFormat:@"  %@ - %@ Chairs", [[[arrSelectTable objectAtIndex:0] objectAtIndex:row] objectForKey:@"TableName"], [[Singleton sharedSingleton]ISNSSTRINGNULL:[[[arrSelectTable objectAtIndex:0] objectAtIndex:row] objectForKey:@"TotalChairs"]]] forState:UIControlStateNormal];
    }
   
  
    
    tableId = [NSString stringWithFormat:@"%@", [[[arrSelectTable objectAtIndex:0] objectAtIndex:row] objectForKey:@"TableId"]];
    tableType = [NSString stringWithFormat:@"%@", [[[arrSelectTable objectAtIndex:0] objectAtIndex:row] objectForKey:@"TableType"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
