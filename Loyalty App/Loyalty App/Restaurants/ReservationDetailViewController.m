//
//  ReservationDetailViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "ReservationDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ReservationDetailViewController ()
@end

@implementation ReservationDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark UITEXTFIELD DELEGATE - HIDE KEYBOARD
-(void)hideKeyboard
{
    [self.txtOtherReq resignFirstResponder];
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.btnSave.layer.cornerRadius = 5.0;
    self.btnSave.clipsToBounds = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
 //   [self.scrollvw addGestureRecognizer:tapGesture];
    
    arrSelectTable = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"];
}

-(IBAction)btnDateDoneClick:(id)sender;
{
    
   
    if (self.DateTime_Tag == 1)
    {
        //Date
        
        NSDate *date=[self.pickerDateTime date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy"];//yyyy-MM-dd
        self.btnSelectDate.titleLabel.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        NSLog(@" Selected Date : %@", self.btnSelectDate.titleLabel.text);
    }
    else if (self.DateTime_Tag == 2)
    {
        // Start Time
        NSDate *date=[self.pickerDateTime date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];//yyyy-MM-dd
        self.btnStartTime.titleLabel.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        NSLog(@" Start Time : %@", self.btnStartTime.titleLabel.text);
    }
    else if (self.DateTime_Tag == 3)
    {
        //End Time
        //datePick.datePickerMode = UIDatePickerModeTime;
        NSDate *date=[self.pickerDateTime date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];//yyyy-MM-dd
        self.btnEndTime.titleLabel.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        NSLog(@" End Date : %@", self.btnEndTime.titleLabel.text);
    }
    else if(self.DateTime_Tag == 4)
    {
        [UIView setAnimationsEnabled:NO];
        [self.btnSelecetTable setTitle:[NSString stringWithFormat:@"%@", [arrSelectTable objectAtIndex:0]] forState:UIControlStateNormal];
        [UIView setAnimationsEnabled:YES];
        NSLog(@" Selected Table  : %@", self.btnSelecetTable.titleLabel.text);
    }
    
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp                  animations:^ {      [self.viewBG removeFromSuperview]; }
                    completion:nil];

    
}
-(IBAction)DateTimeSelectClicked:(id)sender
{
    
}

- (IBAction)selectDateTimeClicked:(id)sender {
    
    UIButton *temp=(UIButton*)sender;
    
    if (temp.tag==1)
    {
        //Date
        self.pickerDateTime.datePickerMode = UIDatePickerModeDate;
        self.DateTime_Tag = 1;
    }
    else if (temp.tag==2)
    {
        // Start Time
        self.pickerDateTime.datePickerMode = UIDatePickerModeTime;
        self.DateTime_Tag=2;
    }
    else if (temp.tag==3)
    {
        //End Time
        self.pickerDateTime.datePickerMode = UIDatePickerModeTime;
        self.DateTime_Tag=3;
    }
    
    self.pickerDateTime.hidden = NO;
    self.pickerTable.hidden = YES;
    
    CGRect frame =  self.btnDateDone.frame;
    frame.origin.y = self.pickerDateTime.frame.origin.y + self.pickerDateTime.frame.size.height + 20;
    self.btnDateDone.frame = frame;
    
    [self.view endEditing:YES];
    
    if(self.viewBG.hidden)
    {
        [UIView transitionWithView:self.view
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCurlDown                   animations:^ {     [self.view addSubview:self.viewBG];  }
                        completion:nil];
    }
    
   
    
}


- (IBAction)selectTableClicked:(id)sender {
    
    
     [self.view endEditing:YES];
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCurlDown                   animations:^ {
                          
                           [self.view addSubview:self.viewBG];
                           self.pickerDateTime.hidden = YES;
                           self.pickerTable.hidden = NO;
                           self.DateTime_Tag = 4;}
                    completion:nil];
    
  
}

- (IBAction)btnSaveClicked:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your Reservation Detail Saved Successfully." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];

    
}

- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
