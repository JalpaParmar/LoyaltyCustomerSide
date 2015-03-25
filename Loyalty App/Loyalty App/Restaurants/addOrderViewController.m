//
//  addOrderViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/23/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "addOrderViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "paymentViewController.h"
#import "homeDeliveryViewController.h"
#import "HomeDelivery.h"
#import "Singleton.h"
#import "OrderDetailViewController.h"
#import "OrderProcessViewController.h"

@interface addOrderViewController ()
@end

@implementation addOrderViewController
@synthesize itemIndexId;

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
 
//    self.lblTitleAddOrder.font = FONT_centuryGothic_35;
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    
//    self.btnProceed.layer.cornerRadius = 5.0;
//    self.btnProceed.clipsToBounds = YES;
    
    self.btnAddAniotherItem.layer.cornerRadius = 5.0;
    self.btnAddAniotherItem.clipsToBounds = YES;

    [self.view setUserInteractionEnabled:YES];
    [self.scrllView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.scrllView addGestureRecognizer:tapGesture];

//    self.btnDoneQty.layer.cornerRadius = 5.0f;
//    self.btnDoneQty.clipsToBounds = YES;
//     _pickerQtyData = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"];
    
    indexId = [[Singleton sharedSingleton] getIndexId];

    if([[[[Singleton sharedSingleton] getarrItemListOfSelectedCategory] objectAtIndex:0] count] > 0)
    {
      
        
        itemID = [NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] getarrItemListOfSelectedCategory] objectAtIndex:0] objectAtIndex:itemIndexId] objectForKey:@"ItemId"]];
        
        itemName = [NSString stringWithFormat:@"%@", [[[[[Singleton sharedSingleton] getarrItemListOfSelectedCategory] objectAtIndex:0] objectAtIndex:itemIndexId] objectForKey:@"ItemName"]];
        
        itemPrice = [[[[[[Singleton sharedSingleton] getarrItemListOfSelectedCategory] objectAtIndex:0] objectAtIndex:itemIndexId] objectForKey:@"Price"] floatValue];
     
        @try {
            itemPriceSign = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[[[[Singleton sharedSingleton] getarrItemListOfSelectedCategory] objectAtIndex:0] objectAtIndex:itemIndexId] objectForKey:@"CurrencySign"]];
        }
        @catch (NSException *exception) {
            itemPriceSign=@"";
        }
        
        @try {
            itemDiscount = [[[[[[Singleton sharedSingleton] getarrItemListOfSelectedCategory] objectAtIndex:0] objectAtIndex:itemIndexId] objectForKey:@"Discount"] floatValue];;
        }
        @catch (NSException *exception) {
            itemDiscount=0;
        }
        
        @try {
            itemTax = [[[[[[Singleton sharedSingleton] getarrItemListOfSelectedCategory] objectAtIndex:0] objectAtIndex:itemIndexId] objectForKey:@"Discount"] floatValue];;
        }
        @catch (NSException *exception) {
            itemTax=0;
        }
        
    }
    
    self.lblRestaurantItemName.text = itemName;
    self.lblRestaurantItemPrice.text = [NSString stringWithFormat:@"%@%.02f", itemPriceSign,itemPrice];
    
    float total =  1 * itemPrice;
    self.lblTotalPrice.text = [NSString stringWithFormat:@"%@%.02f",itemPriceSign, total];

    //Cancel & Done button for num pad
    UIToolbar *numberToolbar = [[Singleton sharedSingleton] AccessoryButtonsForNumPad:self];
    self.txtQtry.inputAccessoryView = numberToolbar;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)cancelNumberPad{
    
    [self.txtQtry resignFirstResponder];
    self.scrllView.contentOffset=CGPointMake(0, 0);
    // self.txtContactnumber.text = @"";
}

-(void)doneWithNumberPad{
    //NSString *numberFromTheKeyboard = self.txtContactnumber.text;
    [self.txtQtry resignFirstResponder];
    self.scrllView.contentOffset=CGPointMake(0, 0);
}
-(void)viewWillAppear:(BOOL)animated
{
    
//    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
//    if([st objectForKey:@"IS_ORDER_START"])
//    {
//        NSString *IS_STARTED = [st objectForKey:@"IS_ORDER_START"];
//        if([IS_STARTED isEqualToString:@"YES"])
//        {
//        }
//        else
//        {
//            OrderProcessViewController *order;
//            if (IS_IPHONE_5)
//            {
//                order=[[OrderProcessViewController alloc] initWithNibName:@"OrderProcessViewController-5" bundle:nil];
//            }
//            else if (IS_IPAD)
//            {
//                order=[[OrderProcessViewController alloc] initWithNibName:@"OrderProcessViewController_iPad" bundle:nil];
//            }
//            else
//            {
//                order=[[OrderProcessViewController alloc] initWithNibName:@"OrderProcessViewController" bundle:nil];
//            }
//            [self.navigationController pushViewController:order animated:YES];
//        }
//    }
}
#pragma mark UIBUTTON CLICKED
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

- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
 
}
//-(IBAction)paymentNowClicked:(id)sender
//{
//    
//    paymentViewController *view;
//    if (IS_IPHONE_5)
//    {
//        view=[[paymentViewController alloc] initWithNibName:@"paymentViewController-5" bundle:nil];
//    }
//    else if (IS_IPAD)
//    {
//        view=[[paymentViewController alloc] initWithNibName:@"paymentViewController_iPad" bundle:nil];
//    }
//    else
//    {
//        view=[[paymentViewController alloc] initWithNibName:@"paymentViewController" bundle:nil];
//    }
//    [self.navigationController pushViewController:view animated:YES];
//    
//    
//  
//}
-(IBAction)addAnotherOrderClicked:(id)sender
{
    
    NSString *ii =itemID;
    NSArray *valArray = [[[Singleton sharedSingleton] getarrOrderOfCurrentUser] valueForKey:@"ItemId"];
    if([valArray count] > 0)
    {
        NSUInteger index = [valArray indexOfObject:ii];
        if(index == NSNotFound) {
            NSLog(@"not found - so added");
            
            if([[[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtQtry.text] isEqualToString:@""] )
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Enter Quantity" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if([self.txtQtry.text isEqualToString:@"0"]|| [self.txtQtry.text isEqualToString:@"00"] || [self.txtQtry.text isEqualToString:@"000"] || [self.txtQtry.text isEqualToString:@"0000"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Enter Quantity. 0 not allowed." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                self.btnAddAniotherItem.userInteractionEnabled  =NO;
                
                //Add first order
                NSString * restaurantId = [[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"UserId"];
                int categoryId =   [[[[[[Singleton sharedSingleton] getarrItemListOfSelectedCategory] objectAtIndex:0] objectAtIndex:itemIndexId] objectForKey:@"CategoryId"] intValue];
                NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
                NSString * userId ;
                if([st objectForKey:@"UserId"])
                {
                    userId =  [st objectForKey:@"UserId"];
                }
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
              
                [dict setValue:itemID forKey:@"ItemId"];
                [dict setValue:itemName forKey:@"ItemName"];
                [dict setValue:self.txtQtry.text forKey:@"Qty"];
                [dict setValue:self.txtareaSpecialRemark.text forKey:@"SpecialRemark"];
                [dict setValue:[NSString stringWithFormat:@"%@%.02f", itemPriceSign,itemPrice] forKey:@"Price"];
                [dict setValue:[NSString stringWithFormat:@"%@", self.lblTotalPrice.text] forKey:@"Totalprice"];
                [dict setValue:restaurantId forKey:@"RestaurantId"];
                [dict setValue:[NSString stringWithFormat:@"%d",categoryId] forKey:@"CategoryId"];
                [dict setValue:userId forKey:@"UserId"];
                
                [[Singleton sharedSingleton] setarrOrderOfCurrentUser:[NSArray arrayWithObject:dict]];
                NSLog(@"YOUR ORDER SAVED : %@",  [[Singleton sharedSingleton] getarrOrderOfCurrentUser]);
                [self saveOrderDetail];
            }
        }
        else
        {
            NSLog(@" found ");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Edit an Quantity" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag = 87;
            [alert show];
        }
    }
    else
    {
        if([[[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtQtry.text] isEqualToString:@""] )
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Enter Quantity" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if([self.txtQtry.text isEqualToString:@"0"]|| [self.txtQtry.text isEqualToString:@"00"] || [self.txtQtry.text isEqualToString:@"000"] || [self.txtQtry.text isEqualToString:@"0000"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Enter Quantity. 0 not allowed." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            self.btnAddAniotherItem.userInteractionEnabled  =NO;
            
            //Add first order
            NSString * restaurantId = [[[[Singleton sharedSingleton] getarrRestaurantList] objectAtIndex:indexId] objectForKey:@"UserId"];
            int categoryId =   [[[[[[Singleton sharedSingleton] getarrItemListOfSelectedCategory] objectAtIndex:0] objectAtIndex:itemIndexId] objectForKey:@"CategoryId"] intValue];
            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
            NSString * userId ;
            if([st objectForKey:@"UserId"])
            {
                userId =  [st objectForKey:@"UserId"];
            }
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
           
            [dict setValue:itemID forKey:@"ItemId"];
            [dict setValue:itemName forKey:@"ItemName"];
            [dict setValue:self.txtQtry.text forKey:@"Qty"];
            [dict setValue:self.txtareaSpecialRemark.text forKey:@"SpecialRemark"];
            [dict setValue:[NSString stringWithFormat:@"%@%.02f", itemPriceSign,itemPrice] forKey:@"Price"];
          
            [dict setValue:[NSString stringWithFormat:@"%@", self.lblTotalPrice.text] forKey:@"Totalprice"];
            [dict setValue:restaurantId forKey:@"RestaurantId"];
            [dict setValue:[NSString stringWithFormat:@"%d",categoryId] forKey:@"CategoryId"];
            [dict setValue:userId forKey:@"UserId"];
          
            [[Singleton sharedSingleton] setarrOrderOfCurrentUser:[NSArray arrayWithObject:dict]];
            NSLog(@"YOUR ORDER SAVED : %@",  [[Singleton sharedSingleton] getarrOrderOfCurrentUser]);
            [self saveOrderDetail];
        }
    }
}
-(void)saveOrderDetail
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
        [self startActivity];
     
        //OrderId, ItemId,ItemQty,Remarks - ( Optional )

        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        NSString * OrderID ;
        if([st objectForKey:@"OrderID"])
        {
            OrderID =  [st objectForKey:@"OrderID"];
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:OrderID forKey:@"OrderID"];
        int count = [[[Singleton sharedSingleton] getarrOrderOfCurrentUser] count];
        if([[[Singleton sharedSingleton] getarrOrderOfCurrentUser] count] > 0)
        {
            [dict setValue:[[[[Singleton sharedSingleton] getarrOrderOfCurrentUser] objectAtIndex:count-1] objectForKey:@"ItemId"] forKey:@"ItemId"];
            [dict setValue:[[[[Singleton sharedSingleton] getarrOrderOfCurrentUser] objectAtIndex:count-1] objectForKey:@"Qty"] forKey:@"ItemQty"];
            [dict setValue:[[[[Singleton sharedSingleton] getarrOrderOfCurrentUser] objectAtIndex:count-1] objectForKey:@"SpecialRemark"] forKey:@"Remarks"];
            [dict setValue:@"false" forKey:@"Editable"];
        }
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Save Order Detail  - - %@ -- ", dict);
            self.btnAddAniotherItem.userInteractionEnabled  = YES;
             if (dict)
             {
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     
                     if([[[Singleton sharedSingleton] getarrOrderOfCurrentUser] count]> 0)
                     {
                         [[[Singleton sharedSingleton] getarrOrderOfCurrentUser] removeObjectAtIndex:[[[Singleton sharedSingleton] getarrOrderOfCurrentUser] count]-1];
                     }
                     
                 }
                 else
                 {
                     //GrandTotal
                     //Tax
                     NSMutableArray *tempArr = [[NSMutableArray alloc] initWithObjects:dict, nil];
                     float GrandTotal = [[[[tempArr objectAtIndex:0] objectForKey:@"data"] objectForKey:@"GrandTotal"] floatValue];
                     float Tax =  [[[[tempArr objectAtIndex:0] objectForKey:@"data"] objectForKey:@"Tax"] floatValue]; 
                     
                     float newTotal = (GrandTotal * Tax)/100;
                     newTotal = newTotal + GrandTotal;
                     [Singleton sharedSingleton].totalPriceInCart = newTotal;
                     [Singleton sharedSingleton].strCurrencySign = itemPriceSign;
                     
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     alt.tag = 19;
                     [alt show];
                 }

                 [self stopActivity];
             }
             else
             {
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
                 [self stopActivity];
             }
         } :@"User/SaveOrderDetail" data:dict];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 19)
    {
        [self.navigationController popViewControllerAnimated:YES];
        
//        if(buttonIndex == 0)
//        {
//            OrderDetailViewController *OrderDetail;
//            if (IS_IPHONE_5)
//            {
//                OrderDetail=[[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController-5" bundle:nil];
//            }
//            else if (IS_IPAD)
//            {
//                OrderDetail=[[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController_iPad" bundle:nil];
//            }
//            else
//            {
//                OrderDetail=[[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
//            }
//            OrderDetail._fromWhere=@"FromHomeDelivery";
//            [self.navigationController pushViewController:OrderDetail animated:YES];
//            
//             //[self.navigationController popViewControllerAnimated:YES];
//        }
    }
    else if(alertView.tag == 87)
    {
        OrderDetailViewController *OrderDetail;
        if (IS_IPHONE_5)
        {
            OrderDetail=[[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            OrderDetail=[[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController_iPad" bundle:nil];
        }
        else
        {
            OrderDetail=[[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
        }
        OrderDetail._fromWhere=@"FromHomeDelivery";
        [self.navigationController pushViewController:OrderDetail animated:YES];
    }
}
#pragma mark -
#pragma mark UIPICKER methods

-(IBAction)QtyBtnClicked:(id)sender
{
    self.viewPicker.hidden = NO;
    
}
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
    
    label.text = [NSString stringWithFormat:@"  %d", row+1];
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
    return _pickerQtyData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerQtyData[row];
}
// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.btnQty setTitle:[NSString stringWithFormat:@"  %@", [_pickerQtyData objectAtIndex:row]] forState:UIControlStateNormal];
}
-(IBAction)QtybtnDoneClicked:(id)sender
{
      self.viewPicker.hidden = YES;
}
#pragma mark TableView Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([arrPlacedOrder count] > 0)
    {
        if([[arrPlacedOrder objectAtIndex:0] count] > 0)
        {
            return [[arrPlacedOrder objectAtIndex:0] count];
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    
    if(IS_IPAD)
        simpleTableIdentifier = @"HomeDelivery_iPad";
    else
        simpleTableIdentifier = @"HomeDelivery";
    
    
    HomeDelivery *cell = (HomeDelivery *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
//        CGRect f = cell.lblName.frame;
//        f.origin.x = 10;
//        f.size.width = f.size.width + 50;
//        cell.lblName.frame = f;
        
        CGRect f = cell.lblAmnt.frame;
        f.origin.x = f.origin.x - 10;
        f.size.width = f.size.width + 40;
        cell.lblAmnt.frame = f;

        cell.lblName.font = [UIFont systemFontOfSize:18];
        cell.lblAmnt.font = [UIFont systemFontOfSize:18];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
   
    dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.myCompanyName.imagegrabber.bgqueue", NULL);
    dispatch_async(backgroundQueue, ^(void) {
        
        NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA,[NSString stringWithFormat:@"%@", [[[arrPlacedOrder objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"Photo"]]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
        
        // Update UI on main thread
        dispatch_async(dispatch_get_main_queue(), ^(void) {
                if(image == nil)
                {
                    [cell.btnItemIcon setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
                }
                else
                {
                    [cell.btnItemIcon setBackgroundImage:image forState:UIControlStateNormal];
                }
        });
    });
    
    cell.imgArrow.hidden = YES;
    cell.lblName.text = [NSString stringWithFormat:@"%@", [[[arrPlacedOrder objectAtIndex:0] objectAtIndex:indexPath.row] objectForKey:@"ItemName"]];
    cell.lblAmnt.text = [NSString stringWithFormat:@"%@x%@",[[[arrPlacedOrder objectAtIndex:0]objectAtIndex:indexPath.row] objectForKey:@"Qty"], [[[arrPlacedOrder objectAtIndex:0]objectAtIndex:indexPath.row] objectForKey:@"Price"]];
    
    
    //cell.lblAmnt.backgroundColor = [UIColor greenColor];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
#pragma mark -
#pragma mark UITextViewDelegate methods

-(void)hideKeyboard
{
    [self.txtareaSpecialRemark resignFirstResponder];
    [self.txtQtry resignFirstResponder];
    self.scrllView.contentOffset=CGPointMake(0, 0);
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
  
    
        NSString * qty = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS_ZIPCODE] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
        if([string isEqualToString:filtered])
        {
            if([qty intValue] <= 0)
            {
                //0, 00, 000, 0000 ....
                
                if([qty isEqualToString:@"0"] || [qty isEqualToString:@"00"] || [qty isEqualToString:@"000"])
                {
                    float total =  [qty intValue] * itemPrice;
                    self.lblTotalPrice.text = [NSString stringWithFormat:@"%@%.02f",itemPriceSign, total];
                    return [string isEqualToString:filtered];
                }
                else
                {
                    if (!string.length)
                    {
                        float total =  [qty intValue] * itemPrice;
                        self.lblTotalPrice.text = [NSString stringWithFormat:@"%@%.02f",itemPriceSign, total];
                        return  [string isEqualToString:filtered];

                        return YES;
                    }
                    
                    return NO;
                }
            }
            else
            {
                if([qty intValue] <= 100)
                {
                    float total =  [qty intValue] * itemPrice;
                    self.lblTotalPrice.text = [NSString stringWithFormat:@"%@%.02f",itemPriceSign, total];
                     return  [string isEqualToString:filtered];
                }
                else if([qty intValue] > 100)
                {
                    return NO;
                }
                else
                {
                    return NO;
                }
            }
        }
        return  [string isEqualToString:filtered];
    
    
    // allow backspace
    if (!string.length)
    {
        return YES;
    }
    
//    float total =  [qty intValue] * itemPrice;
//    self.lblTotalPrice.text = [NSString stringWithFormat:@"%@%.02f",itemPriceSign, total];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField== self.txtQtry)
    {
        [self.txtQtry resignFirstResponder];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  
    [self.view endEditing:YES];
    self.scrllView.contentOffset=CGPointMake(0, 0);
    [super touchesBegan:touches withEvent:event];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(!IS_IPAD)
    {
        self.scrllView.contentOffset=CGPointMake(0, 90);
    }
     return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.scrllView.contentOffset=CGPointMake(0, 0);
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
