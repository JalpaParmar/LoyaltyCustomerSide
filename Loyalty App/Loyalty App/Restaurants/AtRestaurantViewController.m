//
//  AtRestaurantViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/22/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "AtRestaurantViewController.h"
#import "homeDeliveryViewController.h"
#import "Singleton.h"
#import "MyAccountCell.h"


@interface AtRestaurantViewController ()
@end

@implementation AtRestaurantViewController

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
    // Do any additional setup after loading the view from its nib.
    
    app = APP;
    [self.view addSubview:[app setFooterPart]];
    app._flagMainBtn = 0;//2;
    
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
    
    self.btnCancel.layer.cornerRadius = 5.0;
    self.btnCancel.clipsToBounds = YES;
    
    self.btnSubmitTableNo.layer.cornerRadius = 5.0;
    self.btnSubmitTableNo.clipsToBounds = YES;
    
   _pickerTableNoData = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"];
    arrName= [[NSMutableArray alloc] initWithObjects: @"Bill Please", @"Make an order without waiter", @"Push Your Order", nil];
    arrIcons = [[NSMutableArray alloc] initWithObjects: @"bill-please.png", @"make_order-without_waiter.png",@"push.png", nil];
    
    indexId = [[Singleton sharedSingleton] getIndexId];
    //arrTableList = [[NSMutableArray alloc] init];
    
    self.tblAtRestaurant.tableFooterView = [[UIView alloc] init];
    self.tblAtRestaurant.scrollEnabled = NO;
    
    
    [self performSelectorInBackground:@selector(getTableList) withObject:nil];
 
    btnBackCancelCall.hidden=YES;
    btnIconCancelCall.hidden=YES;
    lblCancelCall.hidden=YES;
   
 }
-(void)viewWillAppear:(BOOL)animated
{
    
    // register notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GoTobackFromNotification) name:@"GoTobackFromNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OrderStartWithPincode) name:@"OrderStartWithPincode" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GoToMainPage) name:@"GoToMainPage" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GoToMainPageFail) name:@"GoToMainPageFail" object:nil];

}
-(void)GoToMainPageFail
{
    [self stopActivity];
}
-(void)GoToMainPage
{
    [self stopActivity];
    
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [UIView transitionWithView:self.view
                                         duration:0.3
                                          options:UIViewAnimationOptionTransitionCurlDown  animations:^ {
                                              
                                              [self.viewPincode removeFromSuperview];
                                              
                                          }
                                       completion:nil];
                   });
    
   
}
-(void)OrderStartWithPincode
{
//    self.txtPincode.text=@"";
//    self.pickerTableNo.hidden = YES;
//    self.btnTableNo.titleLabel.text = @"  Select Table No.";
//    [self.pickerTableNo selectRow:0 inComponent:0 animated:YES];
    [self openPinCodeView];
}
-(void)GoTobackFromNotification
{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark OPEN VIEWS FOR PINCODE & TABLE
-(void)openPinCodeView
{
    
    [UIView transitionWithView:self.view
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCurlDown                   animations:^ { [self.view addSubview:self.viewPincode]; }
                    completion:nil];

}
- (IBAction)submitPincodeClicked:(id)sender
{
//    if([self.txtPincode.text isEqualToString:@""])
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Enter Pincode" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//    else
//    {
//        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
//        [st setObject:self.txtPincode.text forKey:@"SecretKey"];
//        [st synchronize];
//        
//        [self.viewPincode removeFromSuperview];
//        
//        [UIView transitionWithView:self.view
//                          duration:0.3
//                           options:UIViewAnimationOptionTransitionCurlDown                   animations:^ { [self.view addSubview:self.viewTableNo]; }
//                        completion:nil];
//        
//        
//        [self.view addSubview:self.viewTableNo];
//    }
  
}

- (IBAction)submitTableNoClicked:(id)sender
{
     [self.view endEditing:YES];
    if([self.txtPincode.text isEqualToString:@""] && [[self.btnTableNo.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"Select Table No."])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ERROR_EMPTY_DATA message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([self.txtPincode.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Enter Pincode" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([[self.btnTableNo.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"Select Table No."])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Select Table" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [self startActivity];
        
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        [st setObject:self.txtPincode.text forKey:@"SecretKey"];
        [st synchronize];
        
        if([st objectForKey:@"IS_ORDER_START"])
        {
            NSString *IS_STARTED = [st objectForKey:@"IS_ORDER_START"];
            if([IS_STARTED isEqualToString:@"YES"])
            {
                [self stopActivity];
                [self.viewPincode removeFromSuperview];
            }
            else
            {
                //Your Order is started - call webservice and set YES to IS_Order_StartDelete
                IS_Order_StartDelete  = YES;
                [[Singleton sharedSingleton] callOrderStartService:@"AtRestaurantViewController" OrderStatus:IS_Order_StartDelete TableId: TableId];
            }
        }
        else
        {
            //Your Order is started - call webservice and set YES to IS_Order_StartDelete
            IS_Order_StartDelete  = YES;
            [[Singleton sharedSingleton] callOrderStartService:@"AtRestaurantViewController" OrderStatus:IS_Order_StartDelete TableId:TableId];
        }
       //
    }
    
}
- (IBAction)TableNoClicked:(id)sender
{
    [self.view endEditing:YES];
    if(self.pickerTableNo.hidden)
    {
//        self.pickerTableNo.hidden = NO;
        
        [UIView transitionWithView:self.view
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCurlDown                   animations:^ {   self.pickerTableNo.hidden = NO;}
                        completion:nil];
        
        //select by default first table name
        [self.btnTableNo setTitle:[NSString stringWithFormat:@"  %@ - %@ Chairs", [[[arrTableList objectAtIndex:0] objectAtIndex:0] objectForKey:@"TableType"], [[[arrTableList objectAtIndex:0] objectAtIndex:0] objectForKey:@"TotalChairs"]] forState:UIControlStateNormal];
        TableId = [[[arrTableList objectAtIndex:0] objectAtIndex:0] objectForKey:@"TableId"];
        
        lblTableName.text = [NSString stringWithFormat:@"Selected Table:  %@ - %@ Chairs", [[[arrTableList objectAtIndex:0] objectAtIndex:0] objectForKey:@"TableType"], [[[arrTableList objectAtIndex:0] objectAtIndex:0] objectForKey:@"TotalChairs"]];
        
    }
    
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
//        if([[[Singleton sharedSingleton] getarrTableList] count] > 0)
//        {
//            if([[[[Singleton sharedSingleton] getarrTableList] objectAtIndex:0]count] > 0)
//            {
//                arrTableList = [[NSMutableArray alloc] initWithObjects:[[[[Singleton sharedSingleton] getarrTableList] objectAtIndex:0] objectAtIndex:0], nil];
//            }
//        }
//        else
//        {
        
            [self startActivity];
            
            NSString * restaurantId = [[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"UserId"];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:restaurantId forKey:@"RestaurantId"];
            
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 NSLog(@"Table List :  %@ -- ", dict);
                 
                 if (dict)
                 {
                     Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                     if (!strCode)
                     {
                         //                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         //                         [alt show];
                         
                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Failed to get TableList" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         alt.tag = 17;
                         [alt show];
                         
                         [self stopActivity];
                     }
                     else
                     {
                         arrTableList =  [[NSMutableArray alloc] initWithObjects:[dict objectForKey:@"data"], nil]; // [NSArray arrayWithObjects:[[dict objectForKey:@"data"] objectAtIndex:0], nil];
                         
                         [[Singleton sharedSingleton] setarrTableList:arrTableList];
                        // NSLog(@"TABLE LIST COUNT : %d -- %@", [[[Singleton sharedSingleton] getarrTableList] count],  [[[Singleton sharedSingleton] getarrTableList] objectAtIndex:0]);
                         
                         [self stopActivity];
                         
                         [self openPinCodeView];
                         
                         //                         [self performSelector:@selector(openPinCodeView) withObject:nil afterDelay:0.1];
                         
                     }
                 }
                 else
                 {
                     [self stopActivity];
                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     
                 }
                 
             } :@"Data/TableTypeList" data:dict];
//        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UIBUTTON CLICK
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 17)
    {
        if(buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)btnBackClick:(id)sender
{
    
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
   
    if([st objectForKey:@"IS_ORDER_START"])
    {
        NSString *IS_STARTED = [st objectForKey:@"IS_ORDER_START"];
        if([IS_STARTED isEqualToString:@"YES"])
        {
            [[Singleton sharedSingleton] checkPendingOrderInArray];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
//    [[Singleton sharedSingleton] checkPendingOrderInArray];
    
//    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
//    
//    if([st objectForKey:@"IS_ORDER_START"])
//    {
//        NSString *IS_STARTED = [st objectForKey:@"IS_ORDER_START"];
//        if([IS_STARTED isEqualToString:@"YES"])
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to cancel this order?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//            alert.tag = 18;
//            [alert show];
//        }
//    }
    
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

-(void)sendNotificationToRestaurant
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
        [self startActivity];
        
        // OrderId, UserId,CallId
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        NSString * OrderID ;
        if([st objectForKey:@"OrderID"])
        {
            OrderID =  [st objectForKey:@"OrderID"];
        }
        
        NSString * userId ;
        if([st objectForKey:@"UserId"])
        {
            userId =  [st objectForKey:@"UserId"];
        }
        
        [dict setValue:OrderID forKey:@"OrderId"];
        [dict setValue:userId forKey:@"UserId"];
        [dict setValue:callId forKey:@"CallId"];
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Send to restaurant - %@ -- ", dict);
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
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     
                     if([callId isEqualToString:@"1"])
                     {
                         //EnableCancellCallControls
                         [self ShowCancellCallControls:YES];
                     }
                     else if([callId isEqualToString:@"3"])
                     {
                         //EnableCancellCallControls
                         [self ShowCancellCallControls:NO];
                     }
                 }
                 [self stopActivity];
             }
             else
             {
                 
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
                 [self stopActivity];
             }
         } :@"User/SendToRestaurant" data:dict];
    }
}
-(void)ShowCancellCallControls:(BOOL)Enable
{
    if(Enable)
    {
        btnIconCancelCall.hidden = NO;
        btnBackCancelCall.hidden=NO;
        lblCancelCall.hidden=NO;
    }
    else
    {
        btnIconCancelCall.hidden = YES;
        btnBackCancelCall.hidden=YES;
        lblCancelCall.hidden=YES;
    }
}
- (IBAction)callWaiterClicked:(id)sender
{
    callId = @"1";
    [self sendNotificationToRestaurant];
    
    
}
- (IBAction)CancelcallWaiterClicked:(id)sender
{
    callId = @"3";
    [self sendNotificationToRestaurant];
}
//- (IBAction)billPleaseClicked:(id)sender
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Wait Bill Will Coming Soon" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    [alert show];
//}
//- (IBAction)makeBillWithoutWaiterClicked:(id)sender
//{
//    homeDeliveryViewController *view;
//    if (IS_IPHONE_5)
//    {
//        view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController-5" bundle:nil];
//    }
//    else if (IS_IPAD)
//    {
//        view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController_iPad" bundle:nil];
//    }
//   else
//    {
//        view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController" bundle:nil];
//    }
//    [self.navigationController pushViewController:view animated:YES];
//    
//}
#pragma mark UITEXTFIELD DELEGATE - HIDE KEYBOARD
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField== self.txtPincode)
    {
        [self.txtPincode resignFirstResponder];
    }
    return YES;
}

#pragma mark TableView Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrName count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD)
    {
        return 80;
    }
    else
    {
        return 60;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier  ;
    if (IS_IPAD)
    {
        simpleTableIdentifier=@"MyAccountCell_iPad";
    }
    else
    {
        simpleTableIdentifier=@"MyAccountCell";
    }    MyAccountCell *cell = (MyAccountCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    if(indexPath.row == 0)
//    {
//        cell.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:166.0/255.0 blue:81.0/255.0 alpha:1];
//    }
    cell.lblName.text = [NSString stringWithFormat:@"%@", [arrName  objectAtIndex:indexPath.row]];
    [cell.btnIcon setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [arrIcons  objectAtIndex:indexPath.row]]] forState:UIControlStateNormal];
    
    
    if([cell.lblName.text isEqualToString:@"Call A Waiter"])
    {
        cell.btnbackground.tag = 1;
    }
    else if([cell.lblName.text isEqualToString:@"Bill Please"])
    {
        cell.btnbackground.tag = 2;
    }
    else if([cell.lblName.text isEqualToString:@"Make an order without waiter"])
    {
        cell.btnbackground.tag = 3;
    }
    else if([cell.lblName.text isEqualToString:@"Cancel a Call"])
    {
        cell.btnbackground.tag = 4;
    }
    else if([cell.lblName.text isEqualToString:@"Push Your Order"])
    {
        cell.btnbackground.tag = 5;
    }
    
    [cell.btnbackground addTarget:self action:@selector(buttonForOrderClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)buttonForOrderClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if(btn.tag == 1)
    {
        callId = @"1";
        [self sendNotificationToRestaurant];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Waiter Will Come Soon" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
    }
    else if(btn.tag == 2)
    {
         callId = @"2";
        [self sendNotificationToRestaurant];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bill Will Come Soon" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
    }
    else if(btn.tag == 3)
    {
        if([[[Singleton sharedSingleton] getarrRestaurantList] count] > 0)
        {
            if([[[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"restaurantCategory"] count] > 0)
            {
                homeDeliveryViewController *view;
                if (IS_IPHONE_5)
                {
                    view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController-5" bundle:nil];
                }
                else if (IS_IPAD)
                {
                    view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController_iPad" bundle:nil];
                }
                else
                {
                    view=[[homeDeliveryViewController alloc] initWithNibName:@"homeDeliveryViewController" bundle:nil];
                }
                [self.navigationController pushViewController:view animated:YES];
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Menu Not Available For Home Delivery" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }

        
    }
    else if(btn.tag == 4)
    {
        callId = @"3";
        [self sendNotificationToRestaurant];
        
    }
    else if(btn.tag == 5)
    {
        callId = @"4";
       [self sendNotificationToRestaurant];
    }
    
    
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
    
    label.text = [NSString stringWithFormat:@"  %@ - %@ Chairs", [[[arrTableList objectAtIndex:0] objectAtIndex:row] objectForKey:@"TableType"], [[[arrTableList objectAtIndex:0] objectAtIndex:row] objectForKey:@"TotalChairs"]];
    
 
    
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
    if([arrTableList count] > 0)
    {
        return  [[arrTableList objectAtIndex:0] count];
    }
    return 0;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([arrTableList count] > 0)
    {
        return  [NSString stringWithFormat:@"  %@ - %@ Chairs", [[[arrTableList objectAtIndex:0] objectAtIndex:row] objectForKey:@"TableType"], [[[arrTableList objectAtIndex:0] objectAtIndex:row] objectForKey:@"TotalChairs"]]; //[[[arrSelectTable objectAtIndex:0] objectAtIndex:row] objectForKey:@"TableType"];
    }
    return  @"abc";
}
// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.btnTableNo setTitle:[NSString stringWithFormat:@"  %@ - %@ Chairs", [[[arrTableList objectAtIndex:0] objectAtIndex:row] objectForKey:@"TableType"], [[[arrTableList objectAtIndex:0] objectAtIndex:row] objectForKey:@"TotalChairs"]] forState:UIControlStateNormal];
    TableId = [[[arrTableList objectAtIndex:0] objectAtIndex:row] objectForKey:@"TableId"];
    
    lblTableName.text = [NSString stringWithFormat:@"Selected Tabel:  %@ - %@ Chairs", [[[arrTableList objectAtIndex:0] objectAtIndex:row] objectForKey:@"TableType"], [[[arrTableList objectAtIndex:0] objectAtIndex:row] objectForKey:@"TotalChairs"]];
}

-(void)viewWillDisappear:(BOOL)animated
{
//    // register notification
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GoTobackFromNotification) name:@"GoTobackFromNotification" object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OrderStartWithPincode) name:@"OrderStartWithPincode" object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GoToMainPage) name:@"GoToMainPage" object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GoToMainPageFail) name:@"GoToMainPageFail" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
    
    
}

@end
