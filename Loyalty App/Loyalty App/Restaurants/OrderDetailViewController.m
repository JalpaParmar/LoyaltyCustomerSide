                            //
//  addOrderViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/23/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "OrderDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "paymentViewController.h"
#import "homeDeliveryViewController.h"
#import "HomeDelivery.h"
#import "Singleton.h"
#import "orderDetailCell.h"
#import "DashboardView.h"
#import "RestaDetailView.h"
#import "addOrderViewController.h"
#import "ASIFormDataRequest.h"
#import "RedeemOrderViewController.h"
#import "OrderProcessViewController.h"

// flag_updateQty_fromWhere = 0 by default
// flag_updateQty_fromWhere = 1 by send button
// flag_updateQty_fromWhere = 2 by Add button
// flag_updateQty_fromWhere = 3 by back button


@interface OrderDetailViewController ()
@end

@implementation OrderDetailViewController
@synthesize _fromWhere, selectedOrderId;

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
    
    self.title = @"Edit Table Exmaple";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(enterEditMode:)];
    [self.navigationItem setLeftBarButtonItem:addButton];
    
    flag_updateQty_fromWhere = 0;
    
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
    orderDetailId=@"";
    
    arrOrderDetail = [[NSMutableArray alloc] init];
    if([[[Singleton sharedSingleton] getarrOrderDetail] count] > 0)
    {
        arrOrderDetail = [[Singleton sharedSingleton] getarrOrderDetail] ;
    }
    
    NSLog(@"arrOrderDetail %lu : %@",(unsigned long)[arrOrderDetail count], arrOrderDetail);
    
    arrRedeemPoints = [[NSMutableArray alloc] init];
    if([[[Singleton sharedSingleton] getarrRedeemPoints] count] > 0)
    {
        arrRedeemPoints = [[Singleton sharedSingleton] getarrRedeemPoints] ;
    }
    
    IS_CHANGED = false;
    
    self.lblDiscounts.text=@"0%";
    
    self.lblTax.text=@"-";
    
    self.lblTotalItem.text=@"0";
    
    self.lblTotalPrice.text=@"0";
    
    self.viewFooterTotalOrder.hidden = YES;
    self.viewFooterButton.hidden=YES;
    btnAddOrder.hidden = YES;
    
 //   self.lblTitleOrderDetail.font = FONT_centuryGothic_35;
    
    self.tblOrderDetail.tableFooterView = [[UIView alloc] init];
    self.tblOrderDetail.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tblOrderDetail setAllowsSelection:YES];
    self.tblOrderDetail.hidden = YES;
    self.tblOrderDetail.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tblOrderDetail.allowsMultipleSelectionDuringEditing = YES;
    
    
    if(IS_IPAD)
    {
        arrHeaderText = [NSArray arrayWithObjects:@"Item", @"Qty", @"Price", @"Discount", @"Total", nil];
    }
    else
    {
       // arrHeaderText = [NSArray arrayWithObjects:@"Item", @"Qty", @"Price", @" % ", @"Total", nil];
          arrHeaderText = [NSArray arrayWithObjects:@"Item", @"Qty", @"Price",  @"Total", nil];
    }
    globalTotalPrice=0;
    globalTotalQty=0;
    
   if(IS_IPAD)
   {
       CGRect f = self.viewFooterTotalOrder.frame;
       f.origin.y = self.view.frame.size.height  - 240; //  (self.view.frame.size.height - self.viewFooterButton.frame.origin.y ) - 60;
       self.viewFooterTotalOrder.frame = f;
       
       f = self.viewFooterButton.frame;
       f.origin.y = self.viewFooterTotalOrder.frame.origin.y + self.viewFooterTotalOrder.frame.size.height + 5;// (self.view.frame.size.height - [app setFooterPart].frame.size.height) - f.size.height - 10;
       self.viewFooterButton.frame = f;
   }
    else
    {
        CGRect f = self.viewFooterTotalOrder.frame;
        f.origin.y = self.view.frame.size.height  - 165; //  (self.view.frame.size.height - self.viewFooterButton.frame.origin.y ) - 60;
        self.viewFooterTotalOrder.frame = f;
        
         f = self.viewFooterButton.frame;
         f.origin.y = self.viewFooterTotalOrder.frame.origin.y + self.viewFooterTotalOrder.frame.size.height + 5; //(self.view.frame.size.height - [app setFooterPart].frame.size.height) - f.size.height;
         self.viewFooterButton.frame = f;
    }
    
    self.btnCancle.layer.cornerRadius = 5.0;
    self.btnCancle.clipsToBounds = YES;
    
    self.btnHold.layer.cornerRadius = 5.0;
    self.btnHold.clipsToBounds = YES;
    
    self.btnSend.layer.cornerRadius = 5.0;
    self.btnSend.clipsToBounds = YES;
    
    btnAddOrder.layer.cornerRadius = 5.0;
    btnAddOrder.clipsToBounds = YES;
    
    self.btnBgPoints.layer.cornerRadius = 5.0;
    self.btnBgPoints.clipsToBounds = YES;
    
    btnSave.layer.cornerRadius = 5.0;
    btnSave.clipsToBounds = YES;
    
    btnCancel.layer.cornerRadius = 5.0;
    btnCancel.clipsToBounds = YES;
    
    viewEditeBoard.layer.cornerRadius = 5.0;
    viewEditeBoard.clipsToBounds = YES;
    viewEditeBoard.layer.borderColor = [UIColor grayColor].CGColor;
    viewEditeBoard.layer.borderWidth=1.0f;
  
    
    if([_fromWhere isEqualToString:@"FromHomeDelivery"])
    {
        app = APP;
        [self.view addSubview:[app setFooterPart]];
        app._flagMainBtn = 0; //2;
        
        strURL = @"User/OrderDetail";
       [self getOrderDetail];
        
//        if([arrRedeemPoints count] == 0)
//        {
//            [self getOrderDetail];
//        }
//        else
//        {
//            [self setViewOfOrderDetailList_FromHomeDelivery];
//        }
    }
    else if([_fromWhere isEqualToString:@"FromOrderList"])
    {
        app = APP;
        [self.view addSubview:[app setFooterPart]];
        app._flagMainBtn = 4;
        
        strURL = @"User/OrderHistoryDetail";
       [self getOrderDetail];
    }
    
    
    
    // register notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GoToDashboardFromNotification) name:@"GoToDashboardFromNotification" object:nil];
  
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tblOrderDetail addGestureRecognizer:gestureRecognizer];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    
//    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
//    if([st objectForKey:@"IS_ORDER_START"])
//    {
//        NSString *IS_STARTED = [st objectForKey:@"IS_ORDER_START"];
//        if([IS_STARTED isEqualToString:@"YES"])
//        {
//            
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
-(void)GoToDashboardFromNotification
{
    DashboardView *dashBoard;
    if (IS_IPHONE_5)
    {
        dashBoard=[[DashboardView alloc] initWithNibName:@"DashboardView-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        dashBoard=[[DashboardView alloc] initWithNibName:@"DashboardView_iPad" bundle:nil];
    }
    else
    {
        dashBoard=[[DashboardView alloc] initWithNibName:@"DashboardView" bundle:nil];
    }
    [self.navigationController pushViewController:dashBoard animated:NO];
    
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

-(void)getOrderDetail
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        [[Singleton sharedSingleton] errorInternetConnection];
    }
    else
    {
        [self startActivity];
       
         NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if([strURL isEqualToString:@"User/DeleteOrderDetail"])
        {
            // delete one item
             [dict setValue:orderDetailId forKey:@"OrderDetailId"];
        }
        else
        {
            // FromHomeDelivery //FromOrderList
            if([_fromWhere isEqualToString:@"FromHomeDelivery"])
            {
                NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
                NSString * OrderID ;
                if([st objectForKey:@"OrderID"])
                {
                    OrderID =  [st objectForKey:@"OrderID"];
                }
                [dict setValue:OrderID forKey:@"OrderID"];
            }
            else if([_fromWhere isEqualToString:@"FromOrderList"])
            {
                [dict setValue:selectedOrderId forKey:@"OrderID"];
            }
        }
                
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Add Order Detail - %@ -- ", dict);
             if (dict)
             {
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                     
                      if([strURL isEqualToString:@"User/DeleteOrderDetail"])
                      {
                          //remove from array
                           NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
                          NSArray *valArray = [arrRedeemPoints valueForKey:@"ItemId"];
                          if([valArray count] > 0)
                          {
                              int index = [valArray indexOfObject:[[OrderDetailList objectAtIndex:deleteIndexFlag] objectForKey:@"ItemId"]];
                              @try {
                                  NSLog(@"contans : %d : %@", index, [[Singleton sharedSingleton] arrRedeemPoints]);
                                  [[[Singleton sharedSingleton] arrRedeemPoints] removeObjectAtIndex:index];
                                  NSLog(@" After remove 1: %@", [[Singleton sharedSingleton] arrRedeemPoints] );
                                  arrRedeemPoints = [[Singleton sharedSingleton] getarrRedeemPoints];
                                  NSLog(@" After remove 2: %@", arrRedeemPoints );
                                  
                              }
                              @catch (NSException *exception) {
                                  
                              }
                          }
                          
                      }
                     else
                     {
                         [[[Singleton sharedSingleton] arrOrderDetail] removeAllObjects];
                         [arrOrderDetail removeAllObjects];
                         
                         self.tblOrderDetail.hidden = NO;
                         [self.tblOrderDetail reloadData];
                         
                         if([arrOrderDetail count] > 0)
                         {
                             float h = 40 * [arrOrderDetail count];
                             h += 40;
                             CGRect f = self.tblOrderDetail.frame;
                             f.size.height = h;
                             self.tblOrderDetail.frame = f;
                         }
                         
                         CGRect f = self.viewFooterTotalOrder.frame;
                         f.origin.y= self.tblOrderDetail.frame.origin.y + self.tblOrderDetail.frame.size.height;
                         self.viewFooterTotalOrder.frame = f;
                         
                         self.lblDiscounts.text=@"0%";
                         self.lblTax.text=@"-";
                         self.lblTotalItem.text=@"0";
                         self.lblTotalPrice.text=@"0";
                         
                         //add extra
                         self.tblOrderDetail.hidden = YES;
                         self.viewFooterButton.hidden = YES;
                         self.viewFooterTotalOrder.hidden = YES;
                         self.lblNoOrderDetail.hidden = NO;
                         self.viewFooterButton.hidden=YES;
                         self.viewFooterTotalOrder.hidden =YES;
                         
                     }
                   
                 }
                 else
                 {
                     if([dict objectForKey:@"data"])
                     {
                         if([strURL isEqualToString:@"User/DeleteOrderDetail"])
                         {
                            arrOrderDetail = [[NSMutableArray alloc] initWithObjects:[dict objectForKey:@"data"], nil];
                             
                             @try {
                                 tax= [[[arrOrderDetail objectAtIndex:0] objectForKey:@"Tax"] floatValue];
                             }
                             @catch (NSException *exception) {
                                 tax= [[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrOrderDetail objectAtIndex:0] objectForKey:@"Tax"]] floatValue];
                             }
                             
                              NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
                             
                             NSLog(@"*** Before ArrEdit : %@", [[Singleton sharedSingleton] getarrEditQtyOfOrderItems]);
                             
                             //remove object if global aray contains
                             if([[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] count] > 0)
                             {
                                 for(int i=0; i<[[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] count]; i++)
                                 {
                                    // NSString *ii = [NSString stringWithFormat:@"%@",[[[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] objectAtIndex:i] objectForKey:@"ItemId"]];
                                     NSString *ii = [NSString stringWithFormat:@"%@",deleteItemId];
                                     
                                     NSArray *valArray = [[[Singleton sharedSingleton] getarrEditQtyOfOrderItems]  valueForKey:@"ItemId"];
                                     if([valArray count] > 0)
                                     {
                                         NSUInteger index = [valArray indexOfObject:ii];
                                         if(index == NSNotFound) {
                                             
                                         }
                                         else
                                         {
                                             NSLog(@"Found contans : %lu", (unsigned long)index);
                                             //found in array so deele from global array
                                              NSLog(@"*********** Before [[Singleton sharedSingleton] getarrEditQtyOfOrderItems] : %@",[[Singleton sharedSingleton] getarrEditQtyOfOrderItems]);
                                             [[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] removeObjectAtIndex:index];
                                              NSLog(@"*********** After [[Singleton sharedSingleton] getarrEditQtyOfOrderItems] : %@",[[Singleton sharedSingleton] getarrEditQtyOfOrderItems]);
                                         }
                                     }
                                 }
                             }
                             NSLog(@"*** After ArrEdit : %@", [[Singleton sharedSingleton] getarrEditQtyOfOrderItems]);
                             
                             
                             //update new main array with gloabal array
                             if([[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] count] > 0)
                             {
                                 for(int i=0; i<[[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] count]; i++)
                                 {
                                     NSString *ii = [NSString stringWithFormat:@"%@",[[[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] objectAtIndex:i] objectForKey:@"ItemId"]];
                                     
                                    
                                     NSArray *valArray = [OrderDetailList valueForKey:@"ItemId"];
                                     if([valArray count] > 0)
                                     {
                                         NSUInteger index = [valArray indexOfObject:ii];
                                         if(index == NSNotFound) {
                                             
                                         }
                                         else
                                         {
                                             NSLog(@"contans : %lu", (unsigned long)index);
                                             //found in array so edit from main array
//                                               int ItemTotalRate = [[[[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] objectAtIndex:i] objectForKey:@"ItemQty"] intValue] * [[[OrderDetailList objectAtIndex:index] objectForKey:@"Price"] intValue];
                                             
                                             //update main array
                                             //Discount :         (itemprice * qty) - (discount * (price * qty)) / 100
                                             float p = [[[OrderDetailList objectAtIndex:i] objectForKey:@"Price"] floatValue];
                                             float d = [[[OrderDetailList objectAtIndex:i] objectForKey:@"ItemDiscount"] floatValue];
                                             int q = [[[[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] objectAtIndex:i] objectForKey:@"ItemQty"] intValue];
                                             float ItemTotalRate = (p * q) - (d *(p* q))/100;
                                             
                                             
                                             NSLog(@"Before Arr OrderDetailList : %@", OrderDetailList);
                                             NSMutableArray *arr = [OrderDetailList objectAtIndex:index];
                                             [arr setValue:[[[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] objectAtIndex:i] objectForKey:@"ItemQty"] forKey:@"ItemQty"];
                                              [arr setValue:[NSString stringWithFormat:@"%.02f", ItemTotalRate] forKey:@"ItemTotalRate"];
                                             [OrderDetailList replaceObjectAtIndex:index withObject:arr];
                                             NSLog(@"After Arr OrderDetailList : %@", OrderDetailList);
                                         }
                                     }
                                 }
                             }

                        
                             float totalPrice=0.0;
                             for(int i=0; i<[OrderDetailList count]; i++)
                             {
                                 totalPrice +=  [[[OrderDetailList objectAtIndex:i] objectForKey:@"ItemTotalRate"] floatValue];
                             }
                             totalPrice = totalPrice + ((tax*totalPrice) / 100);

                             NSMutableArray *tempArr1 = [arrOrderDetail objectAtIndex:0];
                             [tempArr1 setValue:[NSString stringWithFormat:@"%.02f", totalPrice] forKey:@"GrandTotal"];
                             [arrOrderDetail replaceObjectAtIndex:0 withObject:tempArr1];
                             
                             
                                // NSLog(@"*********** Before [[Singleton sharedSingleton] arrOrderDetail] : %@",[[Singleton sharedSingleton] getarrOrderDetail]);
                                 [[Singleton sharedSingleton] setarrOrderDetail:arrOrderDetail];
                                // NSLog(@"*********** After [[Singleton sharedSingleton] arrOrderDetail] : %@",[[Singleton sharedSingleton] getarrOrderDetail]);
                             
                             
                             NSString *ii = [NSString stringWithFormat:@"%@",deleteItemId];
                             NSArray *valArray = [[[Singleton sharedSingleton] getarrOrderOfCurrentUser] valueForKey:@"ItemId"];
                             if([valArray count] > 0)
                             {
                                 NSUInteger index = [valArray indexOfObject:ii];
                                 if(index == NSNotFound) {
                                     NSLog(@"Not found");
                                 }
                                 else
                                 {
                                     NSLog(@"Found : %lu", (unsigned long)index);
                                     //found in array so delete from main array
                                     NSLog(@"Before Delete From Current Order also : %@", [[Singleton sharedSingleton] getarrOrderOfCurrentUser]  );
                                     [[[Singleton sharedSingleton] getarrOrderOfCurrentUser]  removeObjectAtIndex:index];
                                     NSLog(@"After Delete From Current Order also : %@", [[Singleton sharedSingleton] getarrOrderOfCurrentUser]  );
                                 }
                             }
                             
                             if([_fromWhere isEqualToString:@"FromOrderList"])
                             {
                                 [self setViewOfOrderDetailList_FromOrderListHistory];
                             }
                             else
                             {
                                 [self setViewOfOrderDetailList_FromHomeDelivery];
                             }
                            
                             
                             /*
                             float OnePrice, oneDiscount;
                             NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
                             if([OrderDetailList count] > 0)
                             {
                                 OnePrice = [[[OrderDetailList objectAtIndex:deleteIndexFlag] objectForKey:@"Price"] floatValue];
                                 oneDiscount= [[[OrderDetailList objectAtIndex:deleteIndexFlag] objectForKey:@"ItemDiscount"] floatValue];
                                 [OrderDetailList removeObjectAtIndex:deleteIndexFlag];
                             }
                             //GrandTotal
//                             float grandTotal = [[[arrOrderDetail objectAtIndex:0] objectForKey:@"GrandTotal"] floatValue];
//                             float final_grandTOtal = grandTotal - OnePrice;
                             float final_grandTOtal=0;
                             for(int i=0; i<[OrderDetailList count]; i++)
                             {
                                 final_grandTOtal += [[[OrderDetailList objectAtIndex:i] objectForKey:@"ItemTotalRate"] floatValue];
                             }
                             
                             //Grand Tota;
//                             if([OrderDetailList count] > 0)
//                             {
                                    self.lblTotalPrice.text = [NSString stringWithFormat:@"%@%.02f",  currncySign,final_grandTOtal] ;
//                             }
                             
                             //total_discount
                             float total_discount = [[[arrOrderDetail objectAtIndex:0] objectForKey:@"TotalDiscount"] floatValue];
                             float final_discount = total_discount - oneDiscount;
                             self.lblDiscounts.text = [NSString stringWithFormat:@"%.02f", final_discount] ;
                             
                             //lblTotalItem
                             int final_totalItem = [self.lblTotalItem.text intValue] - 1;
                             self.lblTotalItem.text = [NSString stringWithFormat:@"%d",final_totalItem] ;
                             
                             
                             //replace array back with final values
                             NSLog(@"DELETE Before arrOrderDetail : %@", arrOrderDetail);
                             NSMutableArray *arr = [arrOrderDetail objectAtIndex:0];
                             [arr setValue:[NSNumber numberWithFloat:final_grandTOtal] forKey:@"GrandTotal"];
                             [arr setValue:[NSNumber numberWithFloat:final_discount] forKey:@"TotalDiscount"];
                             [arr setValue:[NSNumber numberWithFloat:final_totalItem] forKey:@"TotalItem"];
                             [arrOrderDetail replaceObjectAtIndex:0 withObject:arr];
                             NSLog(@" DELETE After  arrOrderDetail : %@", arrOrderDetail);
                             
                             [self.tblOrderDetail reloadData];
                              
                              */
                         }
                         else
                         {
                            arrOrderDetail = [[NSMutableArray alloc] initWithObjects:[dict objectForKey:@"data"], nil];
                             
                             @try {
                                 tax= [[[arrOrderDetail objectAtIndex:0] objectForKey:@"Tax"] floatValue];
                             }
                             @catch (NSException *exception) {
                                 tax= [[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrOrderDetail objectAtIndex:0] objectForKey:@"Tax"]] floatValue];
                             }
                             
                            NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
                             if([[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] count] > 0)
                             {
                                 for(int i=0; i<[[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] count]; i++)
                                 {
                                     NSString *ii = [NSString stringWithFormat:@"%@",[[[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] objectAtIndex:i] objectForKey:@"ItemId"]];
                                  
                                     NSArray *valArray = [OrderDetailList valueForKey:@"ItemId"];
                                     if([valArray count] > 0)
                                     {
                                         NSUInteger index = [valArray indexOfObject:ii];
                                         if(index == NSNotFound) {
                                             
                                         }
                                         else
                                         {
                                             NSLog(@"contans : %lu", (unsigned long)index);
                                             
                                             //found in array so edit from main array
                                             NSLog(@"Before Arr OrderDetailList : %@", OrderDetailList);
                                             //update main array
//                                             int ItemTotalRate = [[[[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] objectAtIndex:i] objectForKey:@"ItemQty"] intValue] * [[[OrderDetailList objectAtIndex:index] objectForKey:@"Price"] intValue];
                                             
                                             //update main array
                                             //Discount :         (itemprice * qty) - (discount * (price * qty)) / 100
                                             float p = [[[OrderDetailList objectAtIndex:i] objectForKey:@"Price"] floatValue];
                                             float d = [[[OrderDetailList objectAtIndex:i] objectForKey:@"ItemDiscount"] floatValue];
                                             int q = [[[[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] objectAtIndex:i] objectForKey:@"ItemQty"] intValue];
                                             float ItemTotalRate = (p * q) - (d *(p* q))/100;
                                             
                                             NSMutableArray *arr = [OrderDetailList objectAtIndex:index];
                                             [arr setValue:[[[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] objectAtIndex:i] objectForKey:@"ItemQty"] forKey:@"ItemQty"];
                                             [arr setValue:[NSString stringWithFormat:@"%.02f", ItemTotalRate] forKey:@"ItemTotalRate"];
                                             [OrderDetailList replaceObjectAtIndex:index withObject:arr];
                                             NSLog(@"After Arr OrderDetailList : %@", OrderDetailList);
                                         }
                                     }
                                 }
                             }
                            
                             
                             float totalPrice=0.0;
                             for(int i=0; i<[OrderDetailList count]; i++)
                             {
                                 totalPrice +=  [[[OrderDetailList objectAtIndex:i] objectForKey:@"ItemTotalRate"] floatValue];
                                 NSLog(@"Grand Total  %d : %f",i, totalPrice);
                             }
                            
                            
                             totalPrice = totalPrice + ((tax*totalPrice) / 100);
                             NSMutableArray *tempArr1 = [arrOrderDetail objectAtIndex:0];
                             [tempArr1 setValue:[NSString stringWithFormat:@"%.02f", totalPrice] forKey:@"GrandTotal"];
                             [arrOrderDetail replaceObjectAtIndex:0 withObject:tempArr1];
                             
                              [[Singleton sharedSingleton] setarrOrderDetail:arrOrderDetail];
                             
                             if([_fromWhere isEqualToString:@"FromOrderList"])
                             {
                                 [self setViewOfOrderDetailList_FromOrderListHistory];
                             }
                             else
                             {
                                 [self setViewOfOrderDetailList_FromHomeDelivery];
                             }
                         }
                   
                     }
                 }
                 [self stopActivity];
             }
             else
             {
                 [arrOrderDetail removeAllObjects];
                 self.tblOrderDetail.hidden = NO;
                 [self.tblOrderDetail reloadData];
                 
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
                 [self stopActivity];
             }
         } :strURL data:dict];
    }
}
-(void)setViewOfOrderDetailList_FromHomeDelivery
{
      NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
    
    //TotalPoints
    @try {
        self.lblPoints.text = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@", [[arrOrderDetail objectAtIndex:0] objectForKey:@"TotalPoints"]]];
        
    }
    @catch (NSException *exception) {
        self.lblPoints.text = [NSString stringWithFormat:@"%@", [[arrOrderDetail objectAtIndex:0] objectForKey:@"TotalPoints"]];
    }
    if([[[Singleton sharedSingleton] ISNSSTRINGNULL:self.lblPoints.text ] isEqualToString:@""])
    {
        self.lblPoints.text = @" 0 ";
    }
    
    
    if([OrderDetailList count] > 0)
    {
        self.tblOrderDetail.hidden = NO;
        [self.tblOrderDetail reloadData];
        self.lblNoOrderDetail.hidden = YES;
        self.viewFooterButton.hidden=NO;
        self.viewFooterTotalOrder.hidden =NO;
//        self.btnBgPoints.hidden=NO;
//        self.lblPoints.hidden=NO;
//        self.lbltextPoints.hidden=NO;
        self.btnBgPoints.hidden=YES;
        self.lblPoints.hidden=YES;
        self.lbltextPoints.hidden=YES;
        
        btnAddOrder.hidden = NO;
        
        CGRect f = btnAddOrder.frame;
        f.origin.x = self.viewFooterTotalOrder.frame.origin.x;
        f.origin.y = self.viewFooterTotalOrder.frame.origin.y - 45;
        btnAddOrder.frame = f;
        
//        self.editButton.enabled = YES;
//        self.editButton.titleLabel.text = @"Edit";
    }
    else
    {
        self.tblOrderDetail.hidden = YES;
        self.viewFooterButton.hidden = YES;
        self.viewFooterTotalOrder.hidden = YES;
        self.lblNoOrderDetail.hidden = NO;
        self.viewFooterButton.hidden=YES;
        self.btnBgPoints.hidden=YES;
        self.lblPoints.hidden=YES;
        self.lbltextPoints.hidden=YES;
        
        btnAddOrder.hidden = NO;
        
        CGRect f = btnAddOrder.frame;
        f.origin.x = self.viewFooterTotalOrder.frame.origin.x;
        if(IS_IPAD)
        {
            f.origin.y = self.view.frame.size.height - 170;
        }
        else
        {
            f.origin.y = self.view.frame.size.height - 95;
        }
        btnAddOrder.frame = f;
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        

        
//        self.editButton.enabled = NO;
//        self.editButton.titleLabel.text = @"Edit";
    }
    
//    //hide total points
//    CGRect f = self.tblOrderDetail.frame;
//    if(IS_IPAD)
//    {
//        f.origin.y = f.origin.y - 60 ;
//    }
//    else
//    {
//        f.origin.y = f.origin.y - 55 ;
//    }
//    self.tblOrderDetail.frame = f;
    
    [self.tblOrderDetail reloadData];
}
-(void)setViewOfOrderDetailList_FromOrderListHistory
{
      NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
    
   // self.editButton.hidden=YES;
    
    if([OrderDetailList count] > 0)
    {
        self.tblOrderDetail.hidden = NO;
        [self.tblOrderDetail reloadData];
        self.lblNoOrderDetail.hidden = YES;
        self.viewFooterButton.hidden=NO;
        self.viewFooterTotalOrder.hidden =NO;
    }
    else
    {
        self.tblOrderDetail.hidden = YES;
        self.viewFooterButton.hidden = YES;
        self.viewFooterTotalOrder.hidden = YES;
        self.lblNoOrderDetail.hidden = NO;
        self.viewFooterButton.hidden=YES;
        self.viewFooterTotalOrder.hidden =YES;
    }
    btnAddOrder.hidden = YES;
    self.viewFooterTotalOrder.hidden = NO;
    self.viewFooterButton.hidden=YES;
    CGRect f = self.viewFooterTotalOrder.frame;
    if(IS_IPAD)
    {
        f.origin.y = self.view.frame.size.height - 180;
    }
    else
    {
        f.origin.y = self.view.frame.size.height - 130;
    }
    
    self.viewFooterTotalOrder.frame = f;
    
//    //hide total points
//    f = self.tblOrderDetail.frame;
//    f.origin.y = f.origin.y - 60 ;
//    self.tblOrderDetail.frame = f;
    
        [self.tblOrderDetail reloadData];
}
//-(void)changeOrderStatus
//{
//    if ([[Singleton sharedSingleton] connection]==0)
//    {
//        [[Singleton sharedSingleton] errorInternetConnection];
//    }
//    else
//    {
//        NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
//        if([OrderDetailList count] > 0)
//        {
//            [self startActivity];
//            
//            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
//            NSString * OrderID ;
//            if([st objectForKey:@"OrderID"])
//            {
//                OrderID =  [st objectForKey:@"OrderID"];
//            }
//            NSString * userId ;
//            if([st objectForKey:@"UserId"])
//            {
//                userId =  [st objectForKey:@"UserId"];
//            }
//            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//            [dict setValue:OrderID forKey:@"OrderID"];
//            [dict setValue:OrderStatus forKey:@"OrderStatus"];
//            [dict setValue:userId forKey:@"CustomerID"];
//            
//            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
//             {
//                 NSLog(@"OrderStatus  Detail - %@ -- ", dict);
//                 if (dict)
//                 {
//                     Boolean strCode=[[dict objectForKey:@"code"] boolValue];
//                     if (!strCode)
//                     {
//                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                         [alt show];
//                     }
//                     else
//                     {
//                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                         [alt show];
//                         
//                         if([dict objectForKey:@"data"])
//                         {
//                             if([OrderStatus isEqualToString:@"Send"])
//                             {
//                                 //send - mean completed order - remove all settings
//                                 [[[Singleton sharedSingleton] arrOrderOfCurrentUser] removeAllObjects];
//                                 
//                                 //save "delete order " in prefernece
//                                 NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
//                                 [st setObject:@"NO" forKey:@"IS_ORDER_START"];
//                                 [st setObject:@"" forKey:@"OrderID"];
//                                 [st synchronize];
//                                 
//                                 DashboardView *dashBoard;
//                                 if (IS_IPHONE_5)
//                                 {
//                                     dashBoard=[[DashboardView alloc] initWithNibName:@"DashboardView-5" bundle:nil];
//                                 }
//                                 else if (IS_IPAD)
//                                 {
//                                     dashBoard=[[DashboardView alloc] initWithNibName:@"DashboardView_iPad" bundle:nil];
//                                 }
//                                 else
//                                 {
//                                     dashBoard=[[DashboardView alloc] initWithNibName:@"DashboardView" bundle:nil];
//                                 }
//                                 [self.navigationController pushViewController:dashBoard animated:YES];
//                             }
//                         }
//                     }
//                     [self stopActivity];
//                 }
//                 else
//                 {
//                     [arrOrderDetail removeAllObjects];
//                     self.tblOrderDetail.hidden = NO;
//                     [self.tblOrderDetail reloadData];
//                     
//                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                     [alt show];
//                     [self stopActivity];
//                 }
//             } :@"User/ChangeOrderStatus" data:dict];
//        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You can not Send this order. You don't have any Order details." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    }
//}
-(void)setViewFooterpart
{
    
    NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
    
    self.lblTotalItem.text = [NSString stringWithFormat:@"%@", [[arrOrderDetail objectAtIndex:0] objectForKey:@"TotalItem"]];
    
    if([OrderDetailList count] > 0)
    {
       self.lblTotalPrice.text = [NSString stringWithFormat:@"%@%.02f",  [[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:0] objectForKey:@"CurrencySigh"]], [[[arrOrderDetail objectAtIndex:0] objectForKey:@"GrandTotal"] floatValue]] ;
    }
    else
    {
         self.lblTotalPrice.text = [NSString stringWithFormat:@"$%.02f", [[[arrOrderDetail objectAtIndex:0] objectForKey:@"GrandTotal"] floatValue]];
    }
    
//      self.lblTax.text=@"0%";
    @try {
        self.lblTax.text = [NSString stringWithFormat:@"%.02f", [[[arrOrderDetail objectAtIndex:0] objectForKey:@"Tax"] floatValue]] ;
    }
    @catch (NSException *exception) {
        self.lblTax.text = [NSString stringWithFormat:@"%.02f", [[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrOrderDetail objectAtIndex:0] objectForKey:@"Tax"] ]floatValue]] ;
    }
    if([[[Singleton sharedSingleton] ISNSSTRINGNULL:self.lblTax.text] isEqualToString:@""])
    {
        self.lblTax.text = [NSString stringWithFormat:@"%@%%", self.lblTax.text] ;
    }
  
    self.lblDiscounts.text=[NSString stringWithFormat:@"%.02f%%", [[[arrOrderDetail objectAtIndex:0] objectForKey:@"TotalDiscount"] floatValue]];

}
- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*-(void)saveOrderDetail
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
        NSLog(@"GLOBAL ARRAY : %@", [[Singleton sharedSingleton] getarrOrderOfCurrentUser]);
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:OrderID forKey:@"OrderID"];
        int count = [[[Singleton sharedSingleton] getarrOrderOfCurrentUser] count];
        
        if([[[Singleton sharedSingleton] getarrOrderOfCurrentUser] count] > 0)
        {
            [dict setValue:[[[[Singleton sharedSingleton] getarrOrderOfCurrentUser] objectAtIndex:count-1] objectForKey:@"ItemId"] forKey:@"ItemId"];
            [dict setValue:[[[[Singleton sharedSingleton] getarrOrderOfCurrentUser] objectAtIndex:count-1] objectForKey:@"ItemQty"] forKey:@"ItemQty"];
           [dict setValue:@"true" forKey:@"Editable"];
        }
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"Save Order Detail  - - %@ -- ", dict);
             if (dict)
             {
                 IS_CHANGED = false;
                 [self stopActivity];
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                 }
                 else
                 {
                     if([arrRedeemPoints count] == 0)
                     {
                         arrOrderDetail = [[NSMutableArray alloc] initWithObjects:[dict objectForKey:@"data"], nil];
                       //  NSLog(@"*********** Before [[Singleton sharedSingleton] arrOrderDetail] : %@",[[Singleton sharedSingleton] getarrOrderDetail]);
                         [[Singleton sharedSingleton] setarrOrderDetail:arrOrderDetail];
                       //  NSLog(@"*********** After [[Singleton sharedSingleton] arrOrderDetail] : %@",[[Singleton sharedSingleton] getarrOrderDetail]);
                         
                         if(flag_updateQty_fromWhere == 1)
                         {
 
                             NSLog(@" Local Count: %d && Global Count: %d", count_QtyUpdated, [[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] count]);
                             if(count_QtyUpdated == [[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] count])
                             {
                                 [self GoToRedeemView];
                             }
                         }
                         else  if(flag_updateQty_fromWhere == 2)
                         {
                             
                         }
                         else if(flag_updateQty_fromWhere == 3)
                         {
                             
                         }
                     }
//                     else
//                     {
//                         NSMutableArray *tempArr = [[NSMutableArray alloc] initWithObjects:[dict objectForKey:@"data"], nil];
//                         NSMutableArray *tempArrOrderDetail = [[tempArr objectAtIndex:0] objectForKey:@"OrderDetailList"];
//                         NSLog(@"Before  tempArrOrderDetail : %@", tempArrOrderDetail);
//                         
//                         NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
//                         
//                        
//                         NSLog(@"After  tempArrOrderDetail : %@", tempArrOrderDetail);
//                         
//                         NSLog(@"Remove  duplicate item");
//                         NSLog(@"Before  : %@", OrderDetailList);
//                         
//                         [OrderDetailList removeAllObjects];
//                         
//                         NSLog(@"Remove After  : %@", OrderDetailList);
//                         
//                         float grand_total, total_Item, total_discount;
//                         for(int i=0; i<[tempArrOrderDetail count]; i++)
//                         {
//                             [OrderDetailList addObject:[tempArrOrderDetail objectAtIndex:i]];
//                             grand_total += [[[tempArrOrderDetail objectAtIndex:i] objectForKey:@"ItemTotalRate"] floatValue];
//                            // total_Item += [[[tempArrOrderDetail objectAtIndex:i] objectForKey:@"TotalItem"] floatValue];
//                             total_discount += [[[tempArrOrderDetail objectAtIndex:i] objectForKey:@"ItemDiscount"] floatValue];
//                         }
//                         grand_total = grand_total + [self.lblTotalPrice.text floatValue];
//                         //total_Item = total_Item + [self.lblTotalItem.text floatValue];
//                         total_discount = total_discount + [self.lblDiscounts.text floatValue];
//                         total_Item = [tempArrOrderDetail count];
//                         
//                         NSLog(@"grand_total  : %f", grand_total);
//                         NSLog(@"total_Item  : %f", total_Item);
//                         NSLog(@"total_discount  : %f", total_discount);
//                         
//                         self.lblTotalPrice.text = [NSString stringWithFormat:@"%@%.02f",  [[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:0] objectForKey:@"CurrencySigh"]], grand_total] ;
//                         self.lblTotalItem.text = [NSString stringWithFormat:@"%f",total_Item];
//                         self.lblDiscounts.text=[NSString stringWithFormat:@"%.02f%%",total_discount];
//                         
//                         NSLog(@"After  : %@", OrderDetailList);
//                         
//                         NSLog(@"Before arrOrderDetail : %@", arrOrderDetail);
//                         NSMutableArray *arr = [arrOrderDetail objectAtIndex:0];
//                         [arr setValue:OrderDetailList forKey:@"OrderDetailList"];
//                         [arr setValue:[NSNumber numberWithFloat:grand_total] forKey:@"GrandTotal"];
//                         [arr setValue:[NSNumber numberWithFloat:total_discount] forKey:@"TotalDiscount"];
//                         [arr setValue:[NSNumber numberWithFloat:total_Item] forKey:@"TotalItem"];
//                         [arrOrderDetail replaceObjectAtIndex:0 withObject:arr];
//                         NSLog(@"After  arrOrderDetail : %@", arrOrderDetail);
//                     }
                   
                     
//                     [self.tblOrderDetail reloadData];
//                     [self setViewFooterpart];
//                     
//                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                     [alt show];
                     [btnBGBack removeFromSuperview];
                     [viewEditQty removeFromSuperview];
                      txtNQty.text=@"";
                     
                     
                 }
             }
             else
             {
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
                 //                 [self stopActivity];
             }
         } :@"User/SaveOrderDetail" data:dict];
    }
}*/
-(void)sendAllItemQtyForUpdate
{
    [self startActivity];
    
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    NSString * OrderID ;
    if([st objectForKey:@"OrderID"])
    {
        OrderID =  [st objectForKey:@"OrderID"];
    }
    
    ASIFormDataRequest *requ = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@User/UpdateMultipleQty", HOSTNAME]]];
    [requ addRequestHeader:@"LoyaltyToken" value:TOKEN];
    [requ setRequestMethod:@"POST"];
    
    [requ addPostValue:OrderID forKey:@"OrderId"];
    
    for(int i=0; i<[[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] count]; i++)
    {
        NSString *key_Id = [NSString stringWithFormat:@"OrderItemArr[%d].OrderDetailId", i];
        [requ addPostValue:[[[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] objectAtIndex:i] objectForKey:@"OrderDetailID"] forKey:key_Id];
        
        NSString *key_qty = [NSString stringWithFormat:@"OrderItemArr[%d].ItemQty", i];
        [requ addPostValue:[[[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] objectAtIndex:i] objectForKey:@"ItemQty"] forKey:key_qty];
    }
    
    [requ setDelegate:self];
    [requ setDidFinishSelector:@selector(requestFinished:)];
    [requ setDidFailSelector:@selector(requestFailed:)];
    [requ startAsynchronous];
    
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *connectionError;
    
    NSData *data = [request responseData];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&connectionError];
    
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
            RedeemOrderViewController *redeemOrder;
            if (IS_IPHONE_5)
            {
                redeemOrder=[[RedeemOrderViewController alloc] initWithNibName:@"RedeemOrderViewController-5" bundle:nil];
            }
            else if (IS_IPAD)
            {
                redeemOrder=[[RedeemOrderViewController alloc] initWithNibName:@"RedeemOrderViewController_iPad" bundle:nil];
            }
            else
            {
                redeemOrder=[[RedeemOrderViewController alloc] initWithNibName:@"RedeemOrderViewController" bundle:nil];
            }
            redeemOrder.arrRedeemOrderDetail = [[NSMutableArray alloc] initWithObjects:[dict objectForKey:@"data"], nil];
            [self.navigationController pushViewController:redeemOrder animated:YES];
            
        }
        [self stopActivity];
    }
    else
    {
        UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alt show];
    }
    NSString *responseStr = [request responseString];
    NSLog(@"********-------- %@",responseStr);
    [self stopActivity];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *responseStr = [request responseString];
    NSLog(@"EROR : -------- %@",responseStr);
    [self stopActivity];
}

- (IBAction)btnSaveClicked:(id)sender
{
    globalQty = [[Singleton sharedSingleton] ISNSSTRINGNULL:txtNQty.text] ;
    
    if([globalQty isEqualToString:@""] || [globalQty isEqualToString:@""] || [globalQty isEqualToString:@"0"] || [globalQty isEqualToString:@"00"] || [globalQty isEqualToString:@"000"] || [globalQty isEqualToString:@"0000"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Minimum Quantity should be 1." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([globalQty intValue] > 100)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quantity more than 100 not allowed." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
       
        int tag = txtNQty.tag;
        
//        int noOfQty=0;
//        float totalPrice=0;
 /*       NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
        if([OrderDetailList count] > 0)
        {
            NSMutableArray *tempArr = [OrderDetailList objectAtIndex:tag];
            [tempArr setValue:globalQty forKey:@"ItemQty"];
            
            int ItemTotalRate = [globalQty intValue] * [[[OrderDetailList objectAtIndex:tag] objectForKey:@"Price"] intValue];
            [tempArr setValue:[NSString stringWithFormat:@"%d", ItemTotalRate] forKey:@"ItemTotalRate"];
            [OrderDetailList replaceObjectAtIndex:tag withObject:tempArr];
            
            for(int i=0; i<[OrderDetailList count]; i++)
            {
                noOfQty  +=  [[[OrderDetailList objectAtIndex:i] objectForKey:@"ItemQty"] intValue];
                totalPrice +=  [[[OrderDetailList objectAtIndex:i] objectForKey:@"ItemTotalRate"] intValue];
            }
            NSMutableArray *tempArr1 = [arrOrderDetail objectAtIndex:0];
            [tempArr1 setValue:[NSString stringWithFormat:@"%.02f", totalPrice] forKey:@"GrandTotal"];
            [tempArr1 setValue:[NSString stringWithFormat:@"%.02f", totalPrice] forKey:@"GrandTotal"];
            
            [arrOrderDetail replaceObjectAtIndex:0 withObject:tempArr1];
        }
   */
        
/*        //show
        orderDetailCell *cell = (orderDetailCell*)[self.tblOrderDetail cellForRowAtIndexPath:[NSIndexPath indexPathForItem:tag inSection:0]];
        cell.lblTotal.text =[NSString stringWithFormat:@"%@%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:tag] objectForKey:@"CurrencySigh"]],  [[OrderDetailList objectAtIndex:tag] objectForKey:@"ItemTotalRate"]];
        
        if([OrderDetailList count] > 0)
        {
            self.lblTotalPrice.text = [NSString stringWithFormat:@"%@%.02f",  [[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:0] objectForKey:@"CurrencySigh"]], [[[arrOrderDetail objectAtIndex:0] objectForKey:@"GrandTotal"] floatValue]] ;
        }
     */
        
        //save for edit in web service
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        NSString * OrderID ;
        if([st objectForKey:@"OrderID"])
        {
            OrderID =  [st objectForKey:@"OrderID"];
        }
        
        NSLog(@"GLOBAL ARRAY : %@", [[Singleton sharedSingleton] getarrOrderOfCurrentUser]);
       
        NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
        if([[[Singleton sharedSingleton] getarrOrderOfCurrentUser] count] > 0)
        {
            for(int i=0; i<[[[Singleton sharedSingleton] getarrOrderOfCurrentUser] count]; i++)
            {
                NSString *ii = [NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:tag] objectForKey:@"ItemId"]];
                
                NSArray *valArray = [[[Singleton sharedSingleton] getarrOrderOfCurrentUser] valueForKey:@"ItemId"];
                if([valArray count] > 0)
                {
                    NSUInteger index = [valArray indexOfObject:ii];
                    if(index == NSNotFound) {
                        
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                        [dict setValue:OrderID forKey:@"OrderID"];
                        [dict setValue:[[OrderDetailList objectAtIndex:tag] objectForKey:@"ItemId"] forKey:@"ItemId"];
                        [dict setValue:[[OrderDetailList objectAtIndex:tag] objectForKey:@"OrderDetailID"] forKey:@"OrderDetailID"];
                        [dict setValue:globalQty forKey:@"ItemQty"];
                        [dict setValue:[[OrderDetailList objectAtIndex:tag] objectForKey:@"SpecialRemark"] forKey:@"Remarks"];
                        [[Singleton sharedSingleton] setarrOrderOfCurrentUser:[NSArray arrayWithObject:dict]];
                    }
                    else
                    {
                        NSLog(@"contans : %lu", (unsigned long)index);
                        
                        //remove first
                        [[[Singleton sharedSingleton] getarrOrderOfCurrentUser] removeObjectAtIndex:index];
                        
                        //then add again
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                        [dict setValue:OrderID forKey:@"OrderID"];
                        [dict setValue:[[OrderDetailList objectAtIndex:tag] objectForKey:@"ItemId"] forKey:@"ItemId"];
                         [dict setValue:[[OrderDetailList objectAtIndex:tag] objectForKey:@"OrderDetailID"] forKey:@"OrderDetailID"];
                        [dict setValue:globalQty forKey:@"ItemQty"];
                        [dict setValue:[[OrderDetailList objectAtIndex:tag] objectForKey:@"SpecialRemark"] forKey:@"Remarks"];
                        [[Singleton sharedSingleton] setarrOrderOfCurrentUser:[NSArray arrayWithObject:dict]];
                        
                    }
                }
            }
        }
        else
        {
           
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:OrderID forKey:@"OrderID"];
            [dict setValue:[[OrderDetailList objectAtIndex:tag] objectForKey:@"ItemId"] forKey:@"ItemId"];
             [dict setValue:[[OrderDetailList objectAtIndex:tag] objectForKey:@"OrderDetailID"] forKey:@"OrderDetailID"];
            [dict setValue:globalQty forKey:@"ItemQty"];
            [dict setValue:[[OrderDetailList objectAtIndex:tag] objectForKey:@"SpecialRemark"] forKey:@"Remarks"];
            [[Singleton sharedSingleton] setarrOrderOfCurrentUser:[NSArray arrayWithObject:dict]];
        }
       // [self saveOrderDetail];
    }
}
- (IBAction)btnAddQtyClicked:(id)sender
{
    UIButton *b = (UIButton*)sender;
    NSString *currentQty;
    NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
    if([OrderDetailList count] > 0)
    {
        currentQty = [NSString stringWithFormat:@"%d",  [[[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:b.tag] objectForKey:@"ItemQty"]]] intValue] + 1];
    }
    
//    orderDetailCell *cell = (orderDetailCell*)[self.tblOrderDetail cellForRowAtIndexPath:[NSIndexPath indexPathForItem:b.tag inSection:0]];
//    cell.txtQty.text = currentQty;

    txtNQty.text = currentQty;
    NSLog(@"New Qty : %@", txtNQty.text);
    
    [self CheckQtyValidation:txtNQty.text];
 
    BOOL IS_CORRECT = [self CheckQtyValidation:txtNQty.text];
    
    if(IS_CORRECT)
    {
        //update global array
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:b.tag] objectForKey:@"ItemId"]] forKey:@"ItemId"];
       [dict setValue:txtNQty.text forKey:@"ItemQty"];
       [dict setValue:[NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:b.tag] objectForKey:@"OrderDetailID"]] forKey:@"OrderDetailID"];
        
        if([[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] count] > 0)
        {
            for(int i=0; i<[[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] count]; i++)
            {
                NSString *ii = [NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:b.tag] objectForKey:@"ItemId"]];
               
                NSArray *valArray = [[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] valueForKey:@"ItemId"];
                if([valArray count] > 0)
                {
                    NSUInteger index = [valArray indexOfObject:ii];
                    if(index == NSNotFound) {
                        [[Singleton sharedSingleton] setarrEditQtyOfOrderItems:[NSArray arrayWithObjects:dict, nil]];
                    }
                    else
                    {
                        NSLog(@"contans : %lu", (unsigned long)index);
                        //found in array so deele from global array
                        [[[Singleton sharedSingleton] getarrEditQtyOfOrderItems]  removeObjectAtIndex:index];
                       
                        [[Singleton sharedSingleton] setarrEditQtyOfOrderItems:[NSArray arrayWithObjects:dict, nil]];
                    }
                }
            }
        }
        else
        {
              [[Singleton sharedSingleton] setarrEditQtyOfOrderItems:[NSArray arrayWithObjects:dict, nil]];   
        }
    
        
        //update in getarrOrderOfCurrentUser also
        if([[[Singleton sharedSingleton] getarrOrderOfCurrentUser] count] > 0)
        {
            for(int i=0; i<[[[Singleton sharedSingleton] getarrOrderOfCurrentUser] count]; i++)
            {
                NSString *ii = [NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:b.tag] objectForKey:@"ItemId"]];
                
                NSArray *valArray = [[[Singleton sharedSingleton] getarrOrderOfCurrentUser] valueForKey:@"ItemId"];
                if([valArray count] > 0)
                {
                    NSUInteger index = [valArray indexOfObject:ii];
                    if(index == NSNotFound) {
                        [[Singleton sharedSingleton] setarrOrderOfCurrentUser:[NSArray arrayWithObjects:dict, nil]];
                    }
                    else
                    {
                        NSLog(@"contans : %lu", (unsigned long)index);
                        //found in array so deele from global array
                        [[[Singleton sharedSingleton] getarrOrderOfCurrentUser]  removeObjectAtIndex:index];
                        
                        [[Singleton sharedSingleton] setarrOrderOfCurrentUser:[NSArray arrayWithObjects:dict, nil]];
                    }
                }
            }
        }
        NSLog(@"------ After getarrOrderOfCurrentUser ------ %@", [[Singleton sharedSingleton] getarrOrderOfCurrentUser]);
        
        //update main array
//Discount :         (itemprice * qty) - (discount * (price * qty)) / 100
        float p = [[[OrderDetailList objectAtIndex:b.tag] objectForKey:@"Price"] floatValue];
        float d = [[[OrderDetailList objectAtIndex:b.tag] objectForKey:@"ItemDiscount"] floatValue];
        
        float ItemTotalRate = (p * [txtNQty.text intValue]) - (d *(p* [txtNQty.text intValue]))/100;
        
        NSLog(@"Before Arr OrderDetailList : %@", OrderDetailList);
        NSMutableArray *arr = [OrderDetailList objectAtIndex:b.tag];
        [arr setValue:txtNQty.text forKey:@"ItemQty"];
        [arr setValue:[NSString stringWithFormat:@"%.02f", ItemTotalRate] forKey:@"ItemTotalRate"];
        [OrderDetailList replaceObjectAtIndex:b.tag withObject:arr];
        NSLog(@"After Arr OrderDetailList : %@", OrderDetailList);
        
        float totalPrice=0.0;
        for(int i=0; i<[OrderDetailList count]; i++)
        {
            totalPrice +=  [[[OrderDetailList objectAtIndex:i] objectForKey:@"ItemTotalRate"] floatValue];
            NSLog(@"Grand Total  %d : %f",i, totalPrice);
        }
      
        
        totalPrice = totalPrice + ((tax*totalPrice) / 100);
        NSMutableArray *tempArr1 = [arrOrderDetail objectAtIndex:0];
        [tempArr1 setValue:[NSString stringWithFormat:@"%.02f", totalPrice] forKey:@"GrandTotal"];
        [arrOrderDetail replaceObjectAtIndex:0 withObject:tempArr1];

        
        
        //update table
//        orderDetailCell *cell = (orderDetailCell*)[self.tblOrderDetail cellForRowAtIndexPath:[NSIndexPath indexPathForItem:b.tag inSection:0]];
//        cell.txtQty.text =txtNQty.text;
        
        [self.tblOrderDetail reloadData];
    }
    
    
}
- (IBAction)btnRemoveQtyClicked:(id)sender
{
    
    UIButton *b = (UIButton*)sender;
    NSString *currentQty;
    NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
    if([OrderDetailList count] > 0)
    {
        currentQty = [NSString stringWithFormat:@"%d",  [[[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:b.tag] objectForKey:@"ItemQty"]]] intValue] - 1];
    }
    
    //    orderDetailCell *cell = (orderDetailCell*)[self.tblOrderDetail cellForRowAtIndexPath:[NSIndexPath indexPathForItem:b.tag inSection:0]];
    //    cell.txtQty.text = currentQty;
    
    txtNQty.text = currentQty;
    NSLog(@"New Qty : %@", txtNQty.text);
    
    BOOL IS_CORRECT = [self CheckQtyValidation:txtNQty.text];
    
    if(IS_CORRECT)
    {
        //update global array
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:b.tag] objectForKey:@"ItemId"]] forKey:@"ItemId"];
         [dict setValue:[[OrderDetailList objectAtIndex:b.tag] objectForKey:@"OrderDetailID"] forKey:@"OrderDetailID"];
        [dict setValue:txtNQty.text forKey:@"ItemQty"];
        
        if([[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] count] > 0)
        {
            for(int i=0; i<[[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] count]; i++)
            {
                NSString *ii = [NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:b.tag] objectForKey:@"ItemId"]];
                
                NSArray *valArray = [[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] valueForKey:@"ItemId"];
                if([valArray count] > 0)
                {
                    NSUInteger index = [valArray indexOfObject:ii];
                    if(index == NSNotFound) {
                        [[Singleton sharedSingleton] setarrEditQtyOfOrderItems:[NSArray arrayWithObjects:dict, nil]];
                    }
                    else
                    {
                        NSLog(@"contans : %lu", (unsigned long)index);
                        //found in array so deele from global array
                        [[[Singleton sharedSingleton] getarrEditQtyOfOrderItems]  removeObjectAtIndex:index];
                        
                        [[Singleton sharedSingleton] setarrEditQtyOfOrderItems:[NSArray arrayWithObjects:dict, nil]];
                    }
                }
            }
        }
        else
        {
            [[Singleton sharedSingleton] setarrEditQtyOfOrderItems:[NSArray arrayWithObjects:dict, nil]];
        }
        
        //update in getarrOrderOfCurrentUser also
        if([[[Singleton sharedSingleton] getarrOrderOfCurrentUser] count] > 0)
        {
            for(int i=0; i<[[[Singleton sharedSingleton] getarrOrderOfCurrentUser] count]; i++)
            {
                NSString *ii = [NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:b.tag] objectForKey:@"ItemId"]];
                
                NSArray *valArray = [[[Singleton sharedSingleton] getarrOrderOfCurrentUser] valueForKey:@"ItemId"];
                if([valArray count] > 0)
                {
                    NSUInteger index = [valArray indexOfObject:ii];
                    if(index == NSNotFound) {
                        [[Singleton sharedSingleton] setarrOrderOfCurrentUser:[NSArray arrayWithObjects:dict, nil]];
                    }
                    else
                    {
                        NSLog(@"contans : %lu", (unsigned long)index);
                        //found in array so deele from global array
                        [[[Singleton sharedSingleton] getarrOrderOfCurrentUser]  removeObjectAtIndex:index];
                        
                        [[Singleton sharedSingleton] setarrOrderOfCurrentUser:[NSArray arrayWithObjects:dict, nil]];
                    }
                }
            }
        }
        NSLog(@"------ After getarrOrderOfCurrentUser ------ %@", [[Singleton sharedSingleton] getarrOrderOfCurrentUser]);
        
        //update main array
//        int ItemTotalRate = [txtNQty.text intValue] * [[[OrderDetailList objectAtIndex:b.tag] objectForKey:@"Price"] intValue];
        
        //update main array
        //Discount :         (itemprice * qty) - (discount * (price * qty)) / 100
        float p = [[[OrderDetailList objectAtIndex:b.tag] objectForKey:@"Price"] floatValue];
        float d = [[[OrderDetailList objectAtIndex:b.tag] objectForKey:@"ItemDiscount"] floatValue];
        float ItemTotalRate = (p * [txtNQty.text intValue]) - (d *(p* [txtNQty.text intValue]))/100;
        
        NSLog(@"Before Arr OrderDetailList : %@", OrderDetailList);
        NSMutableArray *arr = [OrderDetailList objectAtIndex:b.tag];
        [arr setValue:txtNQty.text forKey:@"ItemQty"];
        [arr setValue:[NSString stringWithFormat:@"%.02f", ItemTotalRate] forKey:@"ItemTotalRate"];
        [OrderDetailList replaceObjectAtIndex:b.tag withObject:arr];
        NSLog(@"After Arr OrderDetailList : %@", OrderDetailList);
        
        float totalPrice=0.0;
        for(int i=0; i<[OrderDetailList count]; i++)
        {
            totalPrice +=  [[[OrderDetailList objectAtIndex:i] objectForKey:@"ItemTotalRate"] floatValue];
            NSLog(@"Grand Total  %d : %f",i, totalPrice);
        }
        totalPrice = totalPrice + ((tax*totalPrice) / 100);

        NSMutableArray *tempArr1 = [arrOrderDetail objectAtIndex:0];
        [tempArr1 setValue:[NSString stringWithFormat:@"%.02f", totalPrice] forKey:@"GrandTotal"];
        [arrOrderDetail replaceObjectAtIndex:0 withObject:tempArr1];
        
        //update table
//        orderDetailCell *cell = (orderDetailCell*)[self.tblOrderDetail cellForRowAtIndexPath:[NSIndexPath indexPathForItem:b.tag inSection:0]];
//        cell.txtQty.text =txtNQty.text;
        
        [self.tblOrderDetail reloadData];
        
    }
}
-(BOOL)CheckQtyValidation:(NSString*)qty
{
    BOOL IS_CORRECT = false;
    
    globalQty = [[Singleton sharedSingleton] ISNSSTRINGNULL:qty] ;
    
    if([globalQty isEqualToString:@""] || [globalQty isEqualToString:@""] || [globalQty isEqualToString:@"0"] || [globalQty isEqualToString:@"00"] || [globalQty isEqualToString:@"000"] || [globalQty isEqualToString:@"0000"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Minimum Quantity should be 1." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([globalQty intValue] > 100)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quantity more than 100 not allowed." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        IS_CORRECT = true;
    }
    return IS_CORRECT;
}
- (IBAction)btnCancelClicked:(id)sender
{
    [btnBGBack removeFromSuperview];
    [viewEditQty removeFromSuperview];
}
- (IBAction)hideParentView:(id)sender
{
    [btnBGBack removeFromSuperview];
    [viewEditQty removeFromSuperview];
}
- (IBAction)btnSendClicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    //AddOrder
    if(btn.tag == 4)
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
    else if(btn.tag == 3)
    {
        NSLog(@"-- %@", self.class);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure want to Cancel this Order?" message:@"" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alert.tag = 81;
        [alert show];
        
    }
    else
    {
        // Send
        //BOOL IS_ERROR =  false;
        int ERROR_FLAG=0;
        NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
        if([OrderDetailList count] > 0)
        {
            for(int i=0; i<[OrderDetailList count]; i++)
            {
                int qty =   [[[OrderDetailList objectAtIndex:i] objectForKey:@"ItemQty"] intValue];
                if(qty == 0)
                {
                    ERROR_FLAG = 1;
                    break;
                }
            }
        }
        else {
            ERROR_FLAG = 2;
        }
        
        
        if(ERROR_FLAG == 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quantity should be at least 1" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if(ERROR_FLAG == 2)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You don't have any Order detail to send" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            
            if(btn.tag == 1)
            {
                //Hold
                //        OrderStatus=@"Hold";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Order already on Hold" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if(btn.tag == 2)
            {
                /*
                 
                //Send
                OrderStatus=@"Send";
                //[self changeOrderStatus];
                [self sendRedeemPoints];
                 
                 */
                
                
                BOOL IS_GONEXT=false;
                
                NSLog(@" --- : %f", [[[arrOrderDetail objectAtIndex:0] objectForKey:@"GrandTotal"] floatValue]);
                NSLog(@"[Singleton sharedSingleton].minimumOrder : %f", [Singleton sharedSingleton].minimumOrder);
                NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
                if([[NSString stringWithFormat:@"%@", [st objectForKey:@"OrderType"]] isEqualToString:OrderType_HomeDelivery])
                {
                    if([Singleton sharedSingleton].minimumOrder > [[[arrOrderDetail objectAtIndex:0] objectForKey:@"GrandTotal"] floatValue])
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Minimum Order Value is %.02f", [Singleton sharedSingleton].minimumOrder] message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                        IS_GONEXT=false;
                    }
                    else
                    {
                        IS_GONEXT = true;
                    }
                }
                else
                {
                    IS_GONEXT = true;
                }
                
                if(IS_GONEXT)
                {
//                    if([[[Singleton sharedSingleton] getarrEditQtyOfOrderItems] count] > 0)
//                    {
                        [self sendAllItemQtyForUpdate];
//                    }
//                    else
//                    {
//                        RedeemOrderViewController *redeemOrder;
//                        if (IS_IPHONE_5)
//                        {
//                            redeemOrder=[[RedeemOrderViewController alloc] initWithNibName:@"RedeemOrderViewController-5" bundle:nil];
//                        }
//                        else if (IS_IPAD)
//                        {
//                            redeemOrder=[[RedeemOrderViewController alloc] initWithNibName:@"RedeemOrderViewController_iPad" bundle:nil];
//                        }
//                        else
//                        {
//                            redeemOrder=[[RedeemOrderViewController alloc] initWithNibName:@"RedeemOrderViewController" bundle:nil];
//                        }
//                        redeemOrder.arrRedeemOrderDetail = arrOrderDetail;
//                        [self.navigationController pushViewController:redeemOrder animated:YES];
//                    }
                }
                
            }
            else if(btn.tag == 3)
            {
                NSLog(@"-- %@", self.class);
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure want to Cancel this Order?" message:@"" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                alert.tag = 81;
                [alert show];
            }
        }
    }
}

/*-(void)sendRedeemPoints
{
    [self startActivity];
    NSString *UserId;
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    if([st objectForKey:@"UserId"])
    {
        UserId = [st objectForKey:@"UserId"];
    }
    NSString * OrderID, *restaurantID ;
    if([st objectForKey:@"OrderID"])
    {
        OrderID =  [st objectForKey:@"OrderID"];
    }
    restaurantID = [NSString stringWithFormat:@"%@", [[arrOrderDetail objectAtIndex:0] objectForKey:@"RestaurantID"]];
    
    
    ASIFormDataRequest *requ = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@User/ChangeOrderStatus", HOSTNAME]]];
    [requ addRequestHeader:@"LoyaltyToken" value:TOKEN];
    [requ setRequestMethod:@"POST"];
    
    [requ addPostValue:OrderStatus forKey:@"OrderStatus"];
    [requ addPostValue:OrderID forKey:@"OrderId"];
    
    for(int i=0; i<[arrRedeemPoints count]; i++)
    {
        NSString* keyItemId = [NSString stringWithFormat:@"PointArr[%d].ItemId",i];
        [requ addPostValue:[[arrRedeemPoints objectAtIndex:i] objectForKey:@"ItemId"] forKey:keyItemId];
         NSString* keyPoints = [NSString stringWithFormat:@"PointArr[%d].RedeemPoints",i];
        [requ addPostValue:[[arrRedeemPoints objectAtIndex:i] objectForKey:@"RedeemPoints"] forKey:keyPoints];
        NSString* keyUserId = [NSString stringWithFormat:@"PointArr[%d].UserId",i];
        [requ addPostValue:UserId forKey:keyUserId];
        NSString* keyRestaurantId = [NSString stringWithFormat:@"PointArr[%d].RestaurantId",i];
        [requ addPostValue:restaurantID forKey:keyRestaurantId];
    }
    
    if([arrRedeemPoints count] > 0)
    {
        NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
        for(int i=0; i<[OrderDetailList count]; i++)
        {
            NSString* keyItemId = [NSString stringWithFormat:@"OrderItemArr[%d].OrderId",i];
            [requ addPostValue:OrderID forKey:keyItemId];
            NSString* keyPoints = [NSString stringWithFormat:@"OrderItemArr[%d].ItemId",i];
            [requ addPostValue:[[OrderDetailList objectAtIndex:i] objectForKey:@"ItemId"] forKey:keyPoints];
            NSString* keyUserId = [NSString stringWithFormat:@"OrderItemArr[%d].ItemQty",i];
            [requ addPostValue:[[OrderDetailList objectAtIndex:i] objectForKey:@"ItemQty"] forKey:keyUserId];
            NSString* keyRestaurantId = [NSString stringWithFormat:@"OrderItemArr[%d].ItemTotalRate",i];
            [requ addPostValue:[[OrderDetailList objectAtIndex:i] objectForKey:@"ItemTotalRate"] forKey:keyRestaurantId];
        }
    }
      
    [requ setDelegate:self];
    [requ setDidFinishSelector:@selector(requestFinished:)];
    [requ setDidFailSelector:@selector(requestFailed:)];
    [requ startAsynchronous];
    
}*/




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     if(alertView.tag == 14)
     {
         if([OrderStatus isEqualToString:@"Send"])
         {
             //send - mean completed order - remove all settings
             [[[Singleton sharedSingleton] arrOrderOfCurrentUser] removeAllObjects];
             
             //save "delete order " in prefernece
             NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
             [st setObject:@"NO" forKey:@"IS_ORDER_START"];
             [st setObject:@"" forKey:@"OrderID"];
             [st synchronize];
             
             DashboardView *dashBoard;
             if (IS_IPHONE_5)
             {
                 dashBoard=[[DashboardView alloc] initWithNibName:@"DashboardView-5" bundle:nil];
             }
             else if (IS_IPAD)
             {
                 dashBoard=[[DashboardView alloc] initWithNibName:@"DashboardView_iPad" bundle:nil];
             }
             else
             {
                 dashBoard=[[DashboardView alloc] initWithNibName:@"DashboardView" bundle:nil];
             }
             [self.navigationController pushViewController:dashBoard animated:YES];
         }

     }
    else if(alertView.tag == 81)
    {
        if(buttonIndex == 1)
        {
            //yes sure want to cancel
            
            //Cancel
            //        OrderStatus=@"Cancel";
            [self startActivity];
            BOOL IS_Order_StartDelete  = NO;
            [[Singleton sharedSingleton] callOrderStartService:@"OrderDetailViewController" OrderStatus:IS_Order_StartDelete TableId:@""];
        }
    }
    else if(alertView.tag == 82)
    {
        if(buttonIndex == 1)
        {
            //Delete
            //YES
            [self DeleteOneItemFormOrderList];
            
        }
    }
}
-(void)DeleteOneItemFormOrderList
{
    NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
    if([OrderDetailList count] > 0)
    {
        orderDetailId = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:deleteIndexFlag] objectForKey:@"OrderDetailID"]]];
        deleteItemId = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:deleteIndexFlag] objectForKey:@"ItemId"]]];
    }
    strURL=@"User/DeleteOrderDetail";
    [self getOrderDetail];
}
#pragma mark TableView Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(self.editing)
    {
        if([arrOrderDetail count] > 0)
        {
            NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
            if([OrderDetailList count] > 0)
            {
                return [OrderDetailList count]+1;
            }
        }
    }
    else
    {
        if([arrOrderDetail count] > 0)
        {
            NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
            if([OrderDetailList count] > 0)
            {
                return [OrderDetailList count];
            }
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPAD)
    {
        return 60;
    }
    else
    {
        return 60;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(IS_IPAD)
    {
        return  40;
    }
    else
    {
        return  30;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    if(IS_IPAD)
    {
        view.frame = CGRectMake(0, 0, 768 , 40);
        view.backgroundColor =  [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];

        
        int cx=5;
        for(int i=0; i<[arrHeaderText count]; i++)
        {
            CGRect f;
            if (i == 0)
            {
                f = CGRectMake(cx, 1, 230, 40);
            }
            else if(i == 1)
            {
                f = CGRectMake(cx, 1, 120, 40);
            }
            else if(i == 2)
            {
                f = CGRectMake(cx, 1, 110, 40);
            }
            else if(i == 3)
            {
                f = CGRectMake(cx, 1, 120, 40);
            }
            else if(i == 4)
            {
                f = CGRectMake(cx, 1, 120, 40);
            }
            else if(i == 5)
            {
                f = CGRectMake(cx, 1, 90, 40);
            }
           
            UILabel *lbl = [self getArrayofLabels:f];
            lbl.text=[arrHeaderText objectAtIndex:i];
            cx = cx + f.size.width;
            [view addSubview:lbl];
        }

    }
    else
    {
        view.frame = CGRectMake(5, 0, 315, 20);
        view.backgroundColor =  [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
        
        int cx=5;
        for(int i=0; i<[arrHeaderText count]; i++)
        {
            CGRect f;
            if (i == 0)
            {
                f = CGRectMake(cx, 1, 120, 30);
            }
            else
            {
                f = CGRectMake(cx, 1, 60, 30);
            }
            UILabel *lbl = [self getArrayofLabels:f];
            lbl.text=[arrHeaderText objectAtIndex:i];
            cx = cx + f.size.width;
            [view addSubview:lbl];
        }
    }
    return view;
}

-(UILabel*)getArrayofLabels:(CGRect) f
{
    UILabel *lbl = [[UILabel alloc] init];
    lbl.frame = f;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = [UIColor colorWithRed:86.0/255.0 green:190.0/255.0 blue:15.0/255.0 alpha:1];
    if(IS_IPAD)
    {
         lbl.font = [UIFont fontWithName:@"OpenSans-Light" size:20];//[UIFont boldSystemFontOfSize:20];
    }
    else
    {
        lbl.font = [UIFont fontWithName:@"OpenSans-Light" size:17]; //[UIFont boldSystemFontOfSize:17];
    }
    return lbl;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    
    if(IS_IPAD)
        simpleTableIdentifier = @"orderDetailCell_iPad";
    else
        simpleTableIdentifier = @"orderDetailCell";
    
    orderDetailCell *cell = (orderDetailCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
 
  
    NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
    
    int count = 0;
    if(self.editing && indexPath.row != 0)
        count = 1;
    
//    NSLog([NSString stringWithFormat:@"%li,%i",(long)indexPath.row,(indexPath.row-count)]);
    // Set up the cell...
    if(indexPath.row == ([OrderDetailList count]) && self.editing){
        cell.lblitemName.text = @"add new row";
        return cell;
    }
    
    
    if([OrderDetailList count] > 0)
    {
       // orderDetailId = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"OrderDetailID"]]];
        
        cell.lblitemName.text = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"ItemName"]]];
//        if(!IS_IPAD)
//        {
//            [cell.lblitemName sizeToFit];
//        }
        
        currncySign= [NSString stringWithFormat:@"%@",  [[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"CurrencySigh"]]];
        cell.lblprice.text = [NSString stringWithFormat:@"%@%.02f", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"CurrencySigh"]], [[[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"Price"] floatValue]];

        if(IS_IPAD)
        {
            //for only ipad
            cell.lblDiscount.text = [NSString stringWithFormat:@"%@%%",  [[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"ItemDiscount"]];
        }
        else
        {
             cell.lblDiscount.text = [NSString stringWithFormat:@"Discount: %@%%",  [[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"ItemDiscount"]];
        }
        @try {
               [cell.btnRedeem setTitle:[NSString stringWithFormat:@"%@",  [[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"RedeemPoints"]]] forState:UIControlStateNormal];
            if([[[Singleton sharedSingleton] ISNSSTRINGNULL:cell.btnRedeem.titleLabel.text] isEqualToString:@""])
            {
                [cell.btnRedeem setTitle:@"0" forState:UIControlStateNormal];
            }
        }
        @catch (NSException *exception) {
             [cell.btnRedeem setTitle:[NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"RedeemPoints"]] forState:UIControlStateNormal];
        }
        cell.btnRedeem.layer.cornerRadius = 5.0;
        cell.btnRedeem.clipsToBounds = YES;
        cell.btnRedeem.tag = indexPath.row;
        //[cell.btnRedeem addTarget:self action:@selector(btnredeemClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.txtQty.delegate = self;
        cell.txtQty.tag = indexPath.row;
        
        if([_fromWhere isEqualToString:@"FromHomeDelivery"])
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.btnBackClicked.hidden =YES;
            cell.btn_Add_Qty.hidden = NO;
            cell.btn_Remove_Qty.hidden = NO;
            
            
            if(IS_IPAD)
            {
                 cell.btnArraw.hidden = NO;
                [cell.btnArraw setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
                CGRect f = cell.btnArraw.frame;
                if(IS_IPAD)
                {
                    f.size.width=30;
                    f.size.height = 25;
                }
                cell.btnArraw.frame = f;
                cell.btnArraw.tag = indexPath.row;
                [cell.btnArraw addTarget:self action:@selector(btnArroawRemoveItemClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
               cell.btnArraw.hidden = YES;
            }
            
            cell.txtQty.hidden = NO;
            cell.lblQty.hidden = YES;
            cell.txtQty.tag = indexPath.row;
            cell.txtQty.text = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"ItemQty"]]];
            
                
            cell.btn_Add_Qty.tag = indexPath.row;
            [cell.btn_Add_Qty addTarget:self action:@selector(btnAddQtyClicked:) forControlEvents:UIControlEventTouchUpInside];
            
             cell.btn_Remove_Qty.tag = indexPath.row;
            [cell.btn_Remove_Qty addTarget:self action:@selector(btnRemoveQtyClicked:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else if([_fromWhere isEqualToString:@"FromOrderList"])
        {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.btnBackClicked.hidden =NO;
            cell.btn_Add_Qty.hidden = YES;
            cell.btn_Remove_Qty.hidden = YES;
            
            cell.btnArraw.hidden =NO;
            [cell.btnArraw setBackgroundImage:[UIImage imageNamed:@"next_arrow.png"] forState:UIControlStateNormal];
            CGRect f = cell.btnArraw.frame;
            if(IS_IPAD)
            {
                f.size.width=14;
                f.size.height = 25;
            }
            else
            {
                f.size.width=10;
                f.size.height = 20;
            }
            cell.btnArraw.frame = f;
            
            cell.txtQty.hidden = YES;
            cell.lblQty.hidden = NO;
            cell.lblQty.text = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"ItemQty"]]];
            cell.btnBackClicked.tag = indexPath.row;
            [cell.btnBackClicked addTarget:self action:@selector(GoToRestaurantDetail:) forControlEvents:UIControlEventTouchUpInside];
           
            [cell.btnBackClicked setTintColor:[UIColor grayColor]];
        }
        
        cell.lblTotal.text =[NSString stringWithFormat:@"%@%.02f", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"CurrencySigh"]],  [[[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"ItemTotalRate"] floatValue]];
//        globalTotalPrice += [[[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"ItemTotalRate"] intValue];
        
    
        
        
        [self setViewFooterpart];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEditing] == YES) {
        // Do something.
    }
    else {
        // Do Something else.
    }
    
    if([_fromWhere isEqualToString:@"FromOrderList"])
    {
        // get restaurant Detail
        
        if ([[Singleton sharedSingleton] connection]==0)
        {
            [[Singleton sharedSingleton] errorInternetConnection];
        }
        else
        {
            [self startActivity];
            
            NSString* restaurantId = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrOrderDetail objectAtIndex:0] objectForKey:@"UserId"]]];
              
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:restaurantId forKey:@"RestaurantId"];
            
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 NSLog(@"Restaurant Detail - %@ -- ", dict);
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
                         if([dict objectForKey:@"data"])
                         {
                             [[Singleton sharedSingleton] setarrRestaurantList:[dict objectForKey:@"data"]];
                         }
                        RestaDetailView *detail;
                        if (IS_IPHONE_5)
                        {
                            detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView-5" bundle:nil];
                        }
                        else if(IS_IPAD)
                        {
                            detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView_iPad" bundle:nil];
                        }
                        else
                        {
                            detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView" bundle:nil];
                        }
                        detail._fromWhere = @"FromRestaurant";
                         detail.IS_PUSHNOTIFICATION = FALSE;
                        [[Singleton sharedSingleton] setIndexId:0];
                        
                        [self.navigationController pushViewController:detail animated:YES];
                     }
                     [self stopActivity];
                 }
                 else
                 {
                     [self stopActivity];
                 }
             } :@"Restaurant/GetRestaurantDetails" data:dict];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
//    // Return NO if you do not want the specified item to be editable.
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            return NO;
//        }
//    }
    
 
    
    if(!IS_IPAD)
    {
      return YES;
    }
    return NO;
    
}
//- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
//    return NO;
//}
// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // No editing style if not editing or the index path is nil.
//    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
//    // Determine the editing style based on whether the cell is a placeholder for adding content or already
//    // existing content. Existing content can be deleted.
//    if (self.editing && indexPath.row == ([arrRedeemPoints count])) {
//        return UITableViewCellEditingStyleInsert;
//    } else {
//        return UITableViewCellEditingStyleDelete;
//    }
//    return UITableViewCellEditingStyleNone;
    
    
    return UITableViewCellEditingStyleDelete;
    
}
/*
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // No editing style if not editing or the index path is nil.
//    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
//    // Determine the editing style based on whether the cell is a placeholder for adding content or already
//    // existing content. Existing content can be deleted.
//    
//    NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
//    if (self.editing && indexPath.row == ([OrderDetailList count])) {
//        return UITableViewCellEditingStyleInsert;
//    } else {
//        return UITableViewCellEditingStyleDelete;
//    }
    
    if(!IS_IPAD)
    {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!IS_IPAD)
    {

        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // Delete the row from the data source
          
           
            // Animate the deletion
//            NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
            
           // [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            // Additional code to configure the Edit Button, if any
//            if (arrOrderDetail.count == 0) {
//                self.editButton.enabled = NO;
//                self.editButton.titleLabel.text = @"Edit";
//            }
            
            deleteIndexFlag = (int)indexPath.row;
            [self DeleteOneItemFormOrderList];
        }
        
    }
}

- (IBAction)enterEditMode:(id)sender {
   
    if(!IS_IPAD)
    {
      //  [self setEditing:YES animated:YES];
        
        // [self.tblOrderDetail setEditing:YES animated:YES];
        
       if(self.editing)
        {
            [super setEditing:NO animated:NO];
      //      [self.tblOrderDetail setEditing:NO animated:NO];
            [self.tblOrderDetail reloadData];
            
            [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
            
            [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
            [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
        }
        else
        {
            [super setEditing:YES animated:YES];
         //   [self.tblOrderDetail setEditing:YES animated:YES];
            [self.tblOrderDetail reloadData];
            [self.editButton setTitle:@"Done" forState:UIControlStateNormal];

            
            [self.navigationItem.leftBarButtonItem setTitle:@"Done"];
            [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
        }
    }
   /* if(!IS_IPAD)
    {
         [self.tblOrderDetail setEditing:YES animated:YES];
        
//        if([self.editButton.titleLabel.text isEqualToString:@"Edit"])
//        {
//            [self.editButton setTitle:@"Done" forState:UIControlStateNormal];
//            
//            // Turn on edit mode
//            [self.tblOrderDetail setEditing:YES animated:YES];
//        }
//        else
//        {
//             [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
//        }
        
//        if ([self.tblOrderDetail isEditing]) {
//            // If the tableView is already in edit mode, turn it off. Also change the title of the button to reflect the intended verb (‘Edit’, in this case).
//            [self.tblOrderDetail setEditing:NO animated:YES];
//            [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
//        }
//        else {
//            [self.editButton setTitle:@"Done" forState:UIControlStateNormal];
//            
//            // Turn on edit mode
//            [self.tblOrderDetail setEditing:YES animated:YES];
//            [self.tblOrderDetail reloadData];
//        }
    }*/
}


-(void)btnArroawRemoveItemClicked:(id)sender
{
    UIButton *b = (UIButton*)sender;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure want to Delete this Item?" message:@"" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag = 82;
    NSLog(@"-- delete --- %ld", (long)b.tag);
    deleteIndexFlag = (int)b.tag;
     NSLog(@"-- delete --- %d", deleteIndexFlag);
    [alert show];
    
    /*  orderDetailCell *cell =  (orderDetailCell*)[self.tblOrderDetail cellForRowAtIndexPath:[NSIndexPath indexPathForItem:b.tag inSection:0]];
     NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
     NSLog(@" item name : %@ : %@", cell.lblitemName.text, [[OrderDetailList objectAtIndex:b.tag] objectForKey:@"RedeemPoints"]);
     NSString *strRedeem;
     @try {
     
     strRedeem = [NSString stringWithFormat:@"Redeem %@ Points",[[OrderDetailList objectAtIndex:b.tag] objectForKey:@"RedeemPoints"]];
     if([[[OrderDetailList objectAtIndex:b.tag] objectForKey:@"RedeemPoints"] intValue] > 0)
     {
     
     }
     }
     @catch (NSException *exception) {
     
     strRedeem = [NSString stringWithFormat:@"Redeem %@ Points", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:b.tag] objectForKey:@"RedeemPoints"]]];
     
     if([[[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:b.tag] objectForKey:@"RedeemPoints"]] isEqualToString:@""])
     {
     strRedeem = [NSString stringWithFormat:@"Redeem 0 Points"];
     }
     }
     
     
     
     //What do you want to do with this Item?
     UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""  delegate:self  cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove"   otherButtonTitles:strRedeem, nil];
     deleteIndexFlag = b.tag;
     
     // [actionSheet showInView:self.view];
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
     // In this case the device is an iPad.
     
     
     
     CGRect cellRect = [self.tblOrderDetail cellForRowAtIndexPath:[NSIndexPath indexPathForItem:b.tag inSection:0]].frame;
     // cellRect.origin.y += cellRect.size.height;
     // cellRect.origin.y -= self.tblOrderDetail.contentOffset.y;
     cellRect.origin.x = 700;
     
     //[actionSheet showFromRect:cell.btnArraw.frame inView:self.tblOrderDetail animated:YES];
     [actionSheet showFromRect:cellRect inView:self.tblOrderDetail animated:YES];
     
     }
     else{
     // In this case the device is an iPhone/iPod Touch.
     [actionSheet showInView:self.view];
     }
     actionSheet.tag = 100;
     */
    
}
/*- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 100)
    {
        if (buttonIndex == 0)
        {
            // remove - delete item
            NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
            if([OrderDetailList count] > 0)
            {
                orderDetailId = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:deleteIndexFlag] objectForKey:@"OrderDetailID"]]];
            }
            strURL=@"User/DeleteOrderDetail";
            [self getOrderDetail];
            
        }
        else if(buttonIndex == 1)
        {
            // redeem
            //deleteIndexFlag
            
            NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
            NSLog(@"-- %f", [[[OrderDetailList objectAtIndex:deleteIndexFlag] objectForKey:@"ItemTotalRate"] floatValue]);
            if([[[OrderDetailList objectAtIndex:deleteIndexFlag] objectForKey:@"ItemTotalRate"] intValue] > 0)
            {
                
                NSString *strRedeem;
                @try {
                    strRedeem = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:deleteIndexFlag] objectForKey:@"RedeemPoints"]]];
                    
                    if([[[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:deleteIndexFlag] objectForKey:@"RedeemPoints"]] isEqualToString:@""])
                    {
                        strRedeem = [NSString stringWithFormat:@"0"];
                    }
                }
                @catch (NSException *exception) {
                    strRedeem = [NSString stringWithFormat:@"%@",[[OrderDetailList objectAtIndex:deleteIndexFlag] objectForKey:@"RedeemPoints"]];
                }
                
                if([strRedeem intValue] > 0)
                {
                    int TP;
                    @try
                    {
                        TP  = [[[arrOrderDetail objectAtIndex:0] objectForKey:@"TotalPoints"] intValue];
                    }
                    @catch (NSException *er){
                        TP  = [[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrOrderDetail objectAtIndex:0] objectForKey:@"TotalPoints"]] intValue] ;
                    }
                    
                    if(TP > 0 && TP > [strRedeem intValue])
                    {
                        
                        //total Points
                        int totalP = [self.lblPoints.text intValue] - ([strRedeem intValue]);
                        self.lblPoints.text = [NSString stringWithFormat:@"%d", totalP];
                        NSLog(@"Total Points : %@", self.lblPoints.text);
                        
                        // totalPrice
                        float totalPrice = [[[OrderDetailList objectAtIndex:deleteIndexFlag] objectForKey:@"ItemTotalRate"] floatValue];
                        float OnePrice = [[[OrderDetailList objectAtIndex:deleteIndexFlag] objectForKey:@"Price"] floatValue];
                        float finalPrice = totalPrice - OnePrice;
                        if(finalPrice <= 0)
                        {
                            finalPrice = 0;
                        }
                        NSLog(@"finalPrice : %f", finalPrice);
                        
                        //GrandTotal
                        float grandTotal = [[[arrOrderDetail objectAtIndex:0] objectForKey:@"GrandTotal"] floatValue];
                        float final_grandTOtal = grandTotal - OnePrice;
                        if(final_grandTOtal <= 0)
                        {
                            final_grandTOtal = 0;
                        }
                        NSLog(@"final_grandTOtal : %f", final_grandTOtal);
                        self.lblTotalPrice.text = [NSString stringWithFormat:@"%@%.02f",  [[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:0] objectForKey:@"CurrencySigh"]],final_grandTOtal] ;
                        
                        
                        //Qty
                        //                int totalQty = [[[OrderDetailList objectAtIndex:deleteIndexFlag] objectForKey:@"ItemQty"] floatValue];
                        //                int finalQty = totalQty - 1;
                        
                        //replace array back with final values
                        NSLog(@"Before arrOrderDetail : %@", arrOrderDetail);
                        NSMutableArray *tempArr = [arrOrderDetail objectAtIndex:0];
                        [tempArr setValue:[NSNumber numberWithFloat:final_grandTOtal] forKey:@"GrandTotal"];
                        [tempArr setValue:[NSNumber numberWithFloat:[self.lblPoints.text floatValue]] forKey:@"TotalPoints"];
                        [arrOrderDetail replaceObjectAtIndex:0 withObject:tempArr];
                        NSLog(@"After arrOrderDetail : %@", arrOrderDetail);
                        
                        //replace array back with final values
                        NSMutableArray *tempArr1 = [OrderDetailList objectAtIndex:deleteIndexFlag];
                        [tempArr1 setValue:[NSNumber numberWithFloat:finalPrice] forKey:@"ItemTotalRate"];
                        //[tempArr1 setValue:[NSNumber numberWithFloat:finalQty] forKey:@"ItemQty"];
                        [OrderDetailList replaceObjectAtIndex:deleteIndexFlag withObject:tempArr1];
                        // [self.tblOrderDetail reloadData];
                        
                        [self.tblOrderDetail beginUpdates];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:deleteIndexFlag inSection:0];
                        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
                        [self.tblOrderDetail reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                        [self.tblOrderDetail endUpdates];
                        
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                        [dict setValue:[[OrderDetailList objectAtIndex:deleteIndexFlag] objectForKey:@"ItemId"] forKey:@"ItemId"];
                        strRedeem = [NSString stringWithFormat:@"-%@", strRedeem];
                        [dict setValue:strRedeem forKey:@"RedeemPoints"];
                        
                        NSString *ii = [NSString stringWithFormat:@"%@",[[OrderDetailList objectAtIndex:deleteIndexFlag] objectForKey:@"ItemId"]];
                        NSArray *valArray = [arrRedeemPoints valueForKey:@"ItemId"];
                        if([valArray count] > 0)
                        {
                            NSUInteger index = [valArray indexOfObject:ii];
                            if(index == NSNotFound) {
                                [[Singleton sharedSingleton] setarrRedeemPoints:[NSArray arrayWithObjects:dict, nil]];
                                arrRedeemPoints = [[Singleton sharedSingleton] getarrRedeemPoints];
                            }
                            else
                            {
                                NSLog(@"contans : %lu", (unsigned long)index);
                                NSLog(@"- minus values : %d", -([[[arrRedeemPoints objectAtIndex:index] objectForKey:@"RedeemPoints"] intValue]));
                                
                                NSMutableArray *tempArr = [arrRedeemPoints objectAtIndex:index];
                                int r = [[[arrRedeemPoints objectAtIndex:index] objectForKey:@"RedeemPoints"] intValue] + [strRedeem intValue];
                                [tempArr setValue:[NSNumber numberWithInt:r] forKey:@"RedeemPoints"];
                                [arrRedeemPoints replaceObjectAtIndex:index withObject:tempArr];
                                
                            }
                            
                        }
                        else
                        {
                            [[Singleton sharedSingleton] setarrRedeemPoints:[NSArray arrayWithObjects:dict, nil]];
                            arrRedeemPoints = [[Singleton sharedSingleton] getarrRedeemPoints];
                        }
                        NSLog(@"REDEEM SUCCESS : %@", arrRedeemPoints);
                        
                    }
                    else
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You have not enough Total Points for Redeem" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Redeem Point 0 for this Item" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Total Cost 0, so Redeem not allowed" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        // NSLog(@" %ld - %@", (long)buttonIndex, actionSheet.title);
    }
    
}*/

-(void)GoToRestaurantDetail:(id)sender
{
    if([_fromWhere isEqualToString:@"FromOrderList"])
    {
        // get restaurant Detail
        
        if ([[Singleton sharedSingleton] connection]==0)
        {
            [[Singleton sharedSingleton] errorInternetConnection];
        }
        else
        {
            [self startActivity];
            
            NSString* restaurantId = [NSString stringWithFormat:@"%@",[[arrOrderDetail objectAtIndex:0] objectForKey:@"RestaurantID"]];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:restaurantId forKey:@"RestaurantId"];
            
            [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
             {
                 NSLog(@"Restaurant Detail - %@ -- ", dict);
                 if (dict)
                 {
                     [self stopActivity];
                     Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                     if (!strCode)
                     {
                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alt show];
                     }
                     else
                     {
                         if([dict objectForKey:@"data"])
                         {
                             [[Singleton sharedSingleton] setarrRestaurantList:[dict objectForKey:@"data"]];
                         }
                         RestaDetailView *detail;
                         if (IS_IPHONE_5)
                         {
                             detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView-5" bundle:nil];
                         }
                         else if(IS_IPAD)
                         {
                             detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView_iPad" bundle:nil];
                         }
                         else
                         {
                             detail=[[RestaDetailView alloc] initWithNibName:@"RestaDetailView" bundle:nil];
                         }
                         detail._fromWhere = @"FromRestaurant";
                         detail.IS_PUSHNOTIFICATION = FALSE;
                         [[Singleton sharedSingleton] setIndexId:0];
                         
                         [self.navigationController pushViewController:detail animated:YES];
                     }
                     
                 }
                 else
                 {
                     [self stopActivity];
                 }
             } :@"Restaurant/GetRestaurantDetails" data:dict];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    self.tblOrderDetail.allowsMultipleSelectionDuringEditing = editing;
    [super setEditing:editing animated:animated];
}

#pragma mark UITEXTFIELD DELEGATES

-(void)hideKeyboard
{
    [self.view endEditing:YES];
//    if(IS_CHANGED)
//    {
//        [self saveOrderDetail];
//    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
//    if(IS_CHANGED)
//    {
//        [self saveOrderDetail];
//    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"textField - %d",textField.tag);
    
  /*  if(textField == txtNQty)
    {
        return  YES;
    }
    else
    {
        txtNQty.tag = textField.tag;
        [self.view addSubview:btnBGBack];
        [self.view addSubview:viewEditQty];
        
        if(IS_IPAD)
        {
            viewEditQty.frame = CGRectMake(0, 300, viewEditQty.frame.size.width, viewEditQty.frame.size.height);
        }
        else
        {
            viewEditQty.frame = CGRectMake(0, 100, viewEditQty.frame.size.width, viewEditQty.frame.size.height);
        }
        
        NSMutableArray *OrderDetailList = [[arrOrderDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
        if([OrderDetailList count] > 0)
        {
            txtCQty.enabled = YES;
            txtCQty.text =  [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:textField.tag] objectForKey:@"ItemQty"]]];
            txtCQty.enabled = NO;
        }
        
        return NO;
    }*/
  
    return NO;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  
    // allow backspace
    if (!string.length)
    {
        return YES;
    }
    if(textField == txtNQty)
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
                    return [string isEqualToString:filtered];
                }
                else
                {
                    return NO;
                }
            }
            else
            {
                if([qty intValue] <= 100)
                {
                    return [string isEqualToString:filtered];
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

    }
   

    return YES;
}

@end
