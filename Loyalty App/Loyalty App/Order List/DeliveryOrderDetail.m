//
//  orderListViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "DeliveryOrderDetail.h"
#import "RestaCell.h"
#import "RestaDetailView.h"
#import "Singleton.h"
#import "orderHistoryCell.h"
#import "OrderDetailViewController.h"
#import "orderDetailCell.h"
#import "objc/message.h"

#define NewProgram_WIDTH_IPAD 690
#define FONT_RESTAURANTNAME_IPAD [UIFont fontWithName:@"OpenSans-Light" size:17] //[UIFont systemFontOfSize:17]
#define FONT_ADDRESS_IPAD  [UIFont fontWithName:@"OpenSans-Light" size:17]//[UIFont systemFontOfSize:17]

#define NewProgram_WIDTH_IPHONE 310
#define FONT_RESTAURANTNAME_IPHONE  [UIFont fontWithName:@"OpenSans-Light" size:13]//[UIFont systemFontOfSize:13]
#define FONT_ADDRESS_IPHONE  [UIFont fontWithName:@"OpenSans-Light" size:13]//[UIFont systemFontOfSize:13]

#define DIFFERENCE_CELLSPACING 25 //15

#define TWO_UPPER_ROWS (IS_IPAD ? 50 : 70)

@interface DeliveryOrderDetail ()
@end

@implementation DeliveryOrderDetail
@synthesize arrOrderDeliveredDetail, selectedOrderId;

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

    if(!IS_IPAD)
    {
         objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationLandscapeLeft);
    }
    
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
//    
//    [super willRotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft duration:0];
    
//    [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeRight;
//    self.navigationController.view.center = CGPointMake(([UIScreen mainScreen].bounds.size.width/2), [UIScreen mainScreen].bounds.size.height/2);
//    CGFloat angle = 90 * M_PI / 180;
//    self.navigationController.view.transform = CGAffineTransformMakeRotation(angle);
//    self.navigationController.view.bounds = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.height , [UIScreen mainScreen].bounds.size.width);
    
    
    
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    
    self.viewbackItemDetail.layer.cornerRadius = 5.0;
    self.viewbackItemDetail.clipsToBounds = YES;
    self.viewbackItemDetail.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewbackItemDetail.layer.borderWidth = 1.0f;

    self.btnCashMode.layer.cornerRadius = 5.0;
    self.btnCashMode.clipsToBounds = YES;
    self.btnCashMode.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btnCashMode.layer.borderWidth = 1.0f;
    
    self.btnPrint.layer.cornerRadius = 5.0;
    self.btnPrint.clipsToBounds = YES;
    
    self.tblOrderDetail.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tblOrderDetail setBackgroundColor:[UIColor whiteColor]];
    [self.tblOrderDetail setUserInteractionEnabled:YES];
    self.tblOrderDetail.hidden = YES;
    
    self.viewwholeWithprint.hidden = YES;
    [self getOrderDetail];
}
-(void)viewWillAppear:(BOOL)animated
{
    app = APP;
    [self.view addSubview:[app setFooterPart]];
    app._flagMainBtn = 4;
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
        [dict setValue:selectedOrderId forKey:@"OrderID"];
        
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
                     
                 }
                 else
                 {
                     if([dict objectForKey:@"data"])
                     {
                         
                         self.arrOrderDeliveredDetail = [[NSMutableArray alloc] initWithObjects:[dict objectForKey:@"data"], nil];
                         NSMutableArray *OrderDetailList = [[arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
                         
                             if([OrderDetailList count] > 0)
                             {
                                 self.viewwholeWithprint.hidden = NO;
                                 
                                 [self setOrderDetail];
                                 self.tblOrderDetail.hidden = NO;
                                 [self.tblOrderDetail reloadData];
                             }
//                             else
//                             {
//                                 self.tblOrderDetail.hidden = YES;
//                                 self.viewFooterButton.hidden = YES;
//                                 self.viewFooterTotalOrder.hidden = YES;
//                                 self.lblNoOrderDetail.hidden = NO;
//                                 self.viewFooterButton.hidden=YES;
//                                 self.viewFooterTotalOrder.hidden =YES;
//                             }
//                             btnAddOrder.hidden = YES;
//                             self.viewFooterTotalOrder.hidden = NO;
//                             self.viewFooterButton.hidden=YES;
//                             CGRect f = self.viewFooterTotalOrder.frame;
//                             if(IS_IPAD)
//                             {
//                                 f.origin.y = self.view.frame.size.height - 180;
//                             }
//                             else
//                             {
//                                 f.origin.y = self.view.frame.size.height - 130;
//                             }
//                             
//                             self.viewFooterTotalOrder.frame = f;
//                             
//                             f = self.tblOrderDetail.frame;
//                             f.origin.y = 0;
//                             self.tblOrderDetail.frame = f;
                         
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
         } :@"User/OrderHistoryDetail" data:dict];
    }
}
-(void)setOrderDetail
{
    float h=0;
    for(UIView *subview in scrlView.subviews)
    {
        h += subview.frame.size.height;
    }
     [scrlView setContentSize:CGSizeMake(scrlView.frame.size.width,h+10)];
//    [scrlView setContentSize:CGSizeMake(768, [scrlView bounds].size.height)];
    
    NSMutableArray *OrderDetailList = [[arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
    
    self.lblCustomerName.text =[NSString stringWithFormat:@"%@ %@",  [[Singleton sharedSingleton] ISNSSTRINGNULL:[[self.arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"FirstName"]], [[Singleton sharedSingleton] ISNSSTRINGNULL:[[self.arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"LastName"]]];
    
    self.lblOrderType.text = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@", [[self.arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"OrderType"]]];
    self.lblOrderId.text =  [[Singleton sharedSingleton] splitOrderIDFromDash : [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@", [[self.arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"OrderID"]]]] ;
    
    NSString *paymentMode = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@", [[self.arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"PaymentMode"]]] ;
    if([paymentMode isEqualToString:@"COD"])
    {
        [self.btnCashMode setTitle:@"Cash On Delivery" forState:UIControlStateNormal];
    }
    else  if([paymentMode isEqualToString:@"ONLINE"])
    {
        [self.btnCashMode setTitle:@"Online payment" forState:UIControlStateNormal];
    }
    else
    {
        [self.btnCashMode setTitle:@"Cash On Delivery" forState:UIControlStateNormal];
    }
    
    
    self.lblOrderdStatus.text = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"Order Status: %@", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[self.arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"AdminOrderStatus"]]]];

    
    self.lblDeliveryFee.text = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@0.0", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:0] objectForKey:@"CurrencySigh"]]]];
    
    @try {
        if([OrderDetailList count] > 0)
        {
            self.lblNetPrice.text = [NSString stringWithFormat:@"%@%.02f",  [[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:0] objectForKey:@"CurrencySigh"]], [[[arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"OrderDetailTotal"] floatValue]] ;
            
            @try {
                self.lblTax.text = [NSString stringWithFormat:@"%.02f", [[[arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"Tax"] floatValue]] ;
            }
            @catch (NSException *exception) {
               self.lblTax.text = [NSString stringWithFormat:@"%.02f", [[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"Tax"] ]floatValue]] ;
            }
           if([[[Singleton sharedSingleton] ISNSSTRINGNULL:self.lblTax.text] isEqualToString:@""])
           {
               self.lblTax.text = [NSString stringWithFormat:@"%@%%", self.lblTax.text] ;
           }
            
            self.lblGrandTotal.text = [NSString stringWithFormat:@"%@%.02f",  [[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:0] objectForKey:@"CurrencySigh"]], [[[arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"GrandTotal"] floatValue]] ;
         
            self.lblBenefitFromPoints.text = [NSString stringWithFormat:@"%@%.02f",  [[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:0] objectForKey:@"CurrencySigh"]], [[[arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"DiscountByPoints"] floatValue]] ;
            
            @try {
                //Benefit From Redeem Points
                float points = (-[[[arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"RedeemPoints"] floatValue]);
                
                self.lblRedeemPoints.text = [NSString stringWithFormat:@"Benefit of Using %.02f Redeem Points", points] ;
            }
            @catch (NSException *exception) {
                //Benefit From Redeem Points
                
                float points;
                NSString* points_ = [[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"RedeemPoints"]];
                if([points_ isEqualToString:@""])
                {
                    points = 0;
                }
                self.lblRedeemPoints.text = [NSString stringWithFormat:@"Benefit of Using 0 Redeem Points"] ;
            }         
            
        }
        else
        {
            self.lblNetPrice.text = [NSString stringWithFormat:@"$%.02f", [[[arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"OrderDetailTotal"] floatValue]];
            
            self.lblBenefitFromPoints.text = [NSString stringWithFormat:@"$%.02f",[[[arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"DiscountByPoints"] floatValue]] ;
            
            self.lblGrandTotal.text = [NSString stringWithFormat:@"$%.02f", [[[arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"GrandTotal"] floatValue]];
            
            //Benefit From Redeem Points
            self.lblRedeemPoints.text = [NSString stringWithFormat:@"Benefit of Using %.02f Redeem Points", (-[[[arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"RedeemPoints"] floatValue])] ;
        }
    }
    @catch (NSException *exception) {
        
    }
   
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
- (IBAction)btnPrintClicked:(id)sender
{
    NSString *pdfName = [NSString stringWithFormat:@"%@_%@.pdf", self.lblCustomerName.text, self.lblOrderId.text];
    
    
    // Capture Screen
    //
    //    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    //
    //    UIGraphicsBeginImageContext(screenWindow.frame.size);
    //    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    //    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //
    //    NSData *screenshotPNG = UIImagePNGRepresentation(screenshot);
    //
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //
    //    NSError *error = nil;
    //    [screenshotPNG writeToFile:[documentsDirectory stringByAppendingPathComponent:@"screenshot.png"] options:NSAtomicWrite error:&error];
    
    //----------------------------
    
    //Create PDF
    
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *createdPdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(createdPdfData, self.viewForprintDetail.bounds, nil);
  
    UIGraphicsBeginPDFPage(); //===
    CGContextRef pdfContext = UIGraphicsGetCurrentContext(); //==
    
   /* for (int page = 0 ; page < 3 ; page ++ ){
        UIGraphicsBeginPDFPage();
        CGContextRef pdfContext = UIGraphicsGetCurrentContext();
        CGFloat scaleFactor = 3.0;
        CGContextSaveGState(pdfContext);
        CGContextScaleCTM(pdfContext, 1.0/scaleFactor, 1.0/scaleFactor);
        
        
        ///draw stuff
        /// context size is now (612.0 * 3.0 , 792.0 * 3.0) , i.e. resolution 72.0 * 3.0 dpi..
        //
        
        
        CGContextRestoreGState(pdfContext);
        
    }//page drawing loop
    */
    
//    NSString *filePath = [NSFileManager defaultManager]; //etcetc make a path];
//     BOOL success = [pdfData writeToFile:filePath atomically:YES];
    
    
    
//    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    [ self.viewForprintDetail.layer renderInContext:pdfContext];
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:pdfName];
    
    // instructs the mutable data object to write its context to a file on disk
    [createdPdfData writeToFile:documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
    
    
    //-------------------- Print Selected PDF
    
/*    Class printControllerClass = NSClassFromString(@"UIPrintInteractionController");
    if (printControllerClass) {
        printController = [printControllerClass sharedPrintController];
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            if (!completed && error) NSLog(@"Print error: %@", error);
        };
        
        //    NSData *pdfData = [self generatePDFDataForPrintingL:createdPdfData];
        
        printController.printingItem = createdPdfData;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [printController presentFromRect:self.btnPrint.frame inView:self.btnPrint.superview
                                    animated:YES completionHandler:completionHandler];
        } else {
            [printController presentAnimated:YES completionHandler:completionHandler];
        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Print success" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Print Not Supported" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
  */

}
//- (UIPrintPaper *)printInteractionController:(UIPrintInteractionController *)pic
//                                 choosePaper:(NSArray *)paperList {
//    // custom method & properties...
//   pageSize  = [self pageSizeForDocumentType:self.view.ty];
//    return [UIPrintPaper bestPaperForPageSize:pageSize
//                          withPapersFromArray:paperList];
//}

#pragma mark TableView Delegate Method
/*- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat rotationAngleDegrees = 40; //90
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    CGPoint offsetPositioning = CGPointMake(-200, -20);
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    
    
    UIView *card = [cell contentView];
    card.layer.transform = transform;
    card.layer.opacity = 0.8;
    
    
    
    [UIView animateWithDuration:0.7f animations:^{
        card.layer.transform = CATransform3DIdentity;
        card.layer.opacity = 1;
    }];
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.arrOrderDeliveredDetail count] > 0)
    {
        return [[[arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"OrderDetailList"] count];
    }
    else
    {
        return 1;
    }
    return [self.arrOrderDeliveredDetail count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 100;
    
    float h ;
   
    h = 60;
    
    
    
    return h;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier;
    
    if(IS_IPAD)
        simpleTableIdentifier = @"orderDetailCell_iPad";
    else
        simpleTableIdentifier = @"orderDetailCell_landscap";
    
    orderDetailCell *cell = (orderDetailCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableArray *OrderDetailList = [[self.arrOrderDeliveredDetail objectAtIndex:0] objectForKey:@"OrderDetailList"];
    if([OrderDetailList count] > 0)
    {
        // orderDetailId = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"OrderDetailID"]]];
        
        cell.lblitemName.text = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"ItemName"]]];
        cell.lblitemName.textAlignment = NSTextAlignmentLeft;
        
        cell.lblprice.text = [NSString stringWithFormat:@"%@%.02f", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"CurrencySigh"]], [[[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"Price"] floatValue]];
        
        cell.lblDiscount.text = [NSString stringWithFormat:@"%@%%",  [[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"ItemDiscount"]];
        
        @try {
            [cell.btnRedeem setTitle:[NSString stringWithFormat:@"%@",  [[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"RedeemPoints"]]] forState:UIControlStateNormal];
            if([cell.btnRedeem.titleLabel.text isEqualToString:@""])
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
//        [cell.btnRedeem addTarget:self action:@selector(btnredeemClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//        cell.txtQty.delegate = self;
        
//        if([_fromWhere isEqualToString:@"FromHomeDelivery"])
//        {
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.btnBackClicked.hidden =YES;
//            
//            
//            cell.btnArraw.hidden =NO;
//            [cell.btnArraw setBackgroundImage:[UIImage imageNamed:@"dropdown_arrow_ipad.png"] forState:UIControlStateNormal];
//            CGRect f = cell.btnArraw.frame;
//            f.size.width=30;
//            f.size.height = 20;
//            cell.btnArraw.frame = f;
//            cell.btnArraw.tag = indexPath.row;
//            [cell.btnArraw addTarget:self action:@selector(btnArroawRemoveItemClicked:) forControlEvents:UIControlEventTouchUpInside];
//            
//            
//            cell.txtQty.hidden = NO;
//            cell.lblQty.hidden = YES;
//            cell.txtQty.tag = indexPath.row;
//            cell.txtQty.text = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"ItemQty"]]];
//        }
//        else if([_fromWhere isEqualToString:@"FromOrderList"])
//        {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            //cell.btnBackClicked.hidden =NO;
            cell.btnArraw.hidden =NO;
            [cell.btnArraw setBackgroundImage:[UIImage imageNamed:@"next_arrow.png"] forState:UIControlStateNormal];
            CGRect f = cell.btnArraw.frame;
            f.size.width=14;
            f.size.height = 25;
            cell.btnArraw.frame = f;
            
            cell.txtQty.hidden = YES;
            cell.lblQty.hidden = NO;
            cell.lblQty.text = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@",  [[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"ItemQty"]]];
            cell.btnBackClicked.hidden = YES;
        
//            cell.btnBackClicked.tag = indexPath.row;
//            [cell.btnBackClicked addTarget:self action:@selector(GoToRestaurantDetail:) forControlEvents:UIControlEventTouchUpInside];
//            
//            [cell.btnBackClicked setTintColor:[UIColor grayColor]];
//        }
        
        cell.lblTotal.text =[NSString stringWithFormat:@"%@%.02f", [[Singleton sharedSingleton] ISNSSTRINGNULL:[[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"CurrencySigh"]],  [[[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"ItemTotalRate"] floatValue]];
        //        globalTotalPrice += [[[OrderDetailList objectAtIndex:indexPath.row] objectForKey:@"ItemTotalRate"] intValue];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ROTATE
//- (BOOL)shouldAutorotate
//{
//    return YES;
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    if(!IS_IPAD)
//    {
//        return UIInterfaceOrientationMaskLandscapeLeft;
//    }
//    return UIInterfaceOrientationMaskPortrait;
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationLandscapeLeft; // or Right of course
//}
//
//- (NSUInteger)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscape;
//}
//
//-(BOOL)shouldAutorotate {
//    return YES;
//}

@end
