//
//  addCardViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 8/13/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "addCardViewController.h"
#import <QuartzCore/QuartzCore.h>
//#import "Base64.h"
//#import <AssetsLibrary/AssetsLibrary.h>
#import "Singleton.h"
//#import "ZBarReaderController.h"

@interface addCardViewController ()

@end

@implementation addCardViewController
@synthesize indexId;

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
  
    self.view.clipsToBounds = YES;
    
    app = APP;
    [self.view addSubview:[app setFooterPart]];
    app._flagMainBtn = 3;
    
    [self.view addSubview:[app setMyLoyaltyTopPart]];
    app._flagMyLoyaltyTopButtons = 1;
    
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    
    self.btnSave.layer.cornerRadius = 5.0;
    self.btnSave.clipsToBounds=YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.scrollview addGestureRecognizer:tapGesture];

  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GettingBarcodePhoto) name:@"GettingBarcodePhoto" object:nil];
    
    if(IS_IPHONE_5)
    {
        
    }
    else
    {
        if(IS_IOS_6)
        {
            CGRect f = self.lblAddCard.frame;
            f.origin.y = f.origin.y + 3;
            self.lblAddCard.frame = f;
        }
        else
        {
            
        }
    }
    
    [imgBarcodeImg setContentMode:UIViewContentModeScaleAspectFill];
    imgBarcodeImg.clipsToBounds=YES;
    
    if(indexId == 1111)
    {
        // add new card
        CardMasterId=@"";
        [[Singleton sharedSingleton] setstrImgEncoded:@""];
        [[Singleton sharedSingleton] setstrImgFilename:@""];
        lblTakePhoto.hidden = NO;
    }
    else
    {
        lblTakePhoto.hidden = YES;
        
        if([[[Singleton sharedSingleton] getarrbarcodeCardDetail] count] > 0)
        {
            CardMasterId = [[Singleton sharedSingleton] ISNSSTRINGNULL: [[[[Singleton sharedSingleton] getarrbarcodeCardDetail]  objectAtIndex:indexId] objectForKey:@"CardMasterId"]];
            
            self.txtBarcodeName.text = [[[[Singleton sharedSingleton] getarrbarcodeCardDetail]  objectAtIndex:indexId] objectForKey:@"CardId"];
            
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
            dispatch_async(queue, ^{
                
                NSData *imageData;
                UIImage *image;
                NSString *imgStr = [[[[Singleton sharedSingleton] getarrbarcodeCardDetail]  objectAtIndex:indexId] objectForKey:@"Photo"];
                if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:imgStr] isEqualToString:@""])
                {
                    NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA,imgStr];
                    
                    image =  [[Singleton sharedSingleton] getImageFromCache:[imageName lastPathComponent]];
                    
                    [[Singleton sharedSingleton] setstrImgEncoded:[[Singleton sharedSingleton] encodeToBase64String:image]];
                    
                    [[Singleton sharedSingleton] setstrImgFilename:[NSString stringWithFormat:@"%@",  [[[[Singleton sharedSingleton] getarrbarcodeCardDetail]  objectAtIndex:indexId] objectForKey:@"OriginalName"]]];
                    
                    if(image != nil)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.btnBarcodeImg setBackgroundImage:image forState:UIControlStateNormal];
                            [imgBarcodeImg setImage:image];
                             
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
                        [[Singleton sharedSingleton] setStrImgEncoded:[[Singleton sharedSingleton] encodeToBase64String:image]];
                        
                        [[Singleton sharedSingleton] setstrImgFilename:[NSString stringWithFormat:@"%@",  [[[[Singleton sharedSingleton] getarrbarcodeCardDetail]  objectAtIndex:indexId] objectForKey:@"OriginalName"]]];
                        
                        [[Singleton sharedSingleton] saveImageInCache:image ImgName:imgStr];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if(image == nil)
                            {
                                 [self.btnBarcodeImg setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
                                [imgBarcodeImg setImage:[UIImage imageNamed:@"defaultImage.png"]];
                            }
                            else
                            {
                                [self.btnBarcodeImg setBackgroundImage:image forState:UIControlStateNormal];
                                [imgBarcodeImg setImage:image];
                            }
                        });
                    }
                }
                
            });
            
//            dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.myCompanyName.imagegrabber.bgqueue", NULL);
//            dispatch_async(backgroundQueue, ^(void) {
//                
//                //profile Pic
//                NSString *imageName1 = [NSString stringWithFormat:@"%@%@", HOSTMEDIA, [[[[Singleton sharedSingleton] getarrbarcodeCardDetail]  objectAtIndex:indexId] objectForKey:@"Photo"]];
//                UIImage *image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName1]]];
//                
//                [[Singleton sharedSingleton] setStrImgEncoded:[[Singleton sharedSingleton] encodeToBase64String:image1]];
//                
//                [[Singleton sharedSingleton] setstrImgFilename:[NSString stringWithFormat:@"%@",  [[[[Singleton sharedSingleton] getarrbarcodeCardDetail]  objectAtIndex:indexId] objectForKey:@"OriginalName"]]];
//                
//                // Update UI on main thread
//                dispatch_async(dispatch_get_main_queue(), ^(void) {
//                    if(image1 == nil)
//                    {
//                        [self.btnBarcodeImg setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
//                    }
//                    else{
//                        [self.btnBarcodeImg setBackgroundImage:image1 forState:UIControlStateNormal];
//                    }
//                } );
//            });
        }
        else
        {
            
        }
    }
    
    
    
    if(IS_IPAD)
    {
        viewbackForm.layer.cornerRadius = 5.0;
        viewbackForm.clipsToBounds = YES;
        viewbackForm.layer.borderColor = [UIColor lightGrayColor].CGColor;
        viewbackForm.layer.borderWidth = 1.0f;
        
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void)GettingBarcodePhoto // : (NSNotification *)notification
{
    NSLog(@"_________ Getting photo n name __________");
    
    [self.btnBarcodeImg setBackgroundImage:[[Singleton sharedSingleton] decodeBase64ToImage:[[Singleton sharedSingleton] getstrImgEncoded]] forState:UIControlStateNormal];
    
    [imgBarcodeImg setContentMode:UIViewContentModeScaleAspectFill];
    imgBarcodeImg.clipsToBounds=YES;
    imgBarcodeImg.image = [[Singleton sharedSingleton] decodeBase64ToImage:[[Singleton sharedSingleton] getstrImgEncoded]];
    
    lblTakePhoto.hidden=YES;
    if(self.btnBarcodeImg.currentBackgroundImage == nil)
    {
        NSLog(@"Null barcode Image");
        
         [self.btnBarcodeImg setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
         lblTakePhoto.hidden=NO;
    }
    
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Button Click Event
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 15)
    {
        if(buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (IBAction)btnbackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
- (IBAction)btnSaveClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    if(app._skipRegister == 1)
    {
        [[Singleton sharedSingleton] errorLoginFirst];
    }
    else
    {
        if ([[Singleton sharedSingleton] connection]==0)
        {
            UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [altMsg show];
        }
        else
        {
        
            NSString * barcodeName = [[Singleton sharedSingleton] ISNSSTRINGNULL:[self.txtBarcodeName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            NSString * encodedImg =[[Singleton sharedSingleton] getstrImgEncoded];
            NSString * fileName = [[Singleton sharedSingleton] getstrImgFilename];
            
            if([barcodeName isEqualToString:@""] || [encodedImg isEqualToString:@""] || [fileName isEqualToString:@""] )
            {
                UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_EMPTY_DATA message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:encodedImg forKey:@"Photo"];
                [dict setValue:userId forKey:@"UserId"];
                [dict setValue:barcodeName forKey:@"CardId"];
                [dict setValue:fileName forKey:@"OriginalName"];
                if(![CardMasterId isEqualToString:@""])
                {
                    [dict setValue:CardMasterId forKey:@"CardMasterId"];
                }
                [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
                 {
                     NSLog(@"upload Barcode Image  :  %@ -- ", dict);
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
                             if([dict objectForKey:@"data"] != [NSNull null])
                             {
                                 NSMutableArray *tempArr = [[NSMutableArray alloc] initWithObjects:[dict objectForKey:@"data"], nil];
                               
                                 [[Singleton sharedSingleton] setarrbarcodeCardDetail:[[tempArr objectAtIndex:0] objectForKey:@"Cards"]];
                             }
                             
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"message"]  message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                             alert.tag= 15;
                             [alert show];
                          
                             //Remove Common Photo Encodeed and Filename
                             [[Singleton sharedSingleton] setStrImgEncoded:@""];
                             [[Singleton sharedSingleton] setstrImgFilename:@""];

                             
                             [self.delegate loadAllCards];
                         }
                     }
                     else
                     {
                         UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alt show];
                     }
                  
                     [self stopActivity];
                     
                 } :@"Offers/AddMyCard" data:dict];
            }            
        }
    }
}

- (IBAction)btnCameraClicked:(id)sender
{
    
    
    [[Singleton sharedSingleton] CameraClicked:self.view Control:self.btnCamera];
    
//    ZBarReaderController *reader = [ZBarReaderController new];
//    reader.readerDelegate = self;
//    if([ZBarReaderController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
//    {
//        reader.sourceType = UIImagePickerControllerSourceTypeCamera;
//       
//    }
//  
//     [reader.scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
//    
//    [self presentModalViewController: reader
//                            animated: YES];
    
  
    
  
}
//- (void) imagePickerController: (UIImagePickerController*) reader
// didFinishPickingMediaWithInfo: (NSDictionary*) info
//{
//    // ADD: get the decode results
//    id<NSFastEnumeration> results =
//    [info objectForKey: ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for(symbol in results)
//        // EXAMPLE: just grab the first barcode
//        break;
//    
//    // EXAMPLE: do something useful with the barcode data
//    //resultText.text = symbol.data;
//    NSLog(@"RESULT : %@", symbol.data);
//    
//    // EXAMPLE: do something useful with the barcode image
//    UIImage *image  = [info objectForKey: UIImagePickerControllerOriginalImage];
//    
//    // ADD: dismiss the controller (NB dismiss from the *reader*!)
//    [reader dismissModalViewControllerAnimated: YES];
//    
//}
//- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
//                             withRetry: (BOOL) retry
//{
//    NSLog(@"No Barcode Detected : %hhd", retry);
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//}


#pragma mark TextField Delegate
#pragma mark TextField Delegate
-(void)hideKeyboard
{
    [self.txtBarcodeName resignFirstResponder];
    self.scrollview.contentOffset=CGPointMake(0, 0);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(!IS_IPAD)
    {
        if(textField == self.txtBarcodeName)
        {
            self.scrollview.contentOffset=CGPointMake(0, 50);
        }
    }
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.scrollview.contentOffset=CGPointMake(0, 0);
    
//    CGRect f = self.view.frame;
//  
//    if(f.origin.y == -80)
//    {
//        //NSLog(@"---------- y : %f", f.origin.y);
//        f.origin.y = f.origin.y + 80;
//        self.view.frame = f;
//    }
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [self.txtBarcodeName resignFirstResponder];
    
    self.scrollview.contentOffset=CGPointMake(0, 0);
    
//    CGRect f = self.view.frame;
//    f.origin.y = f.origin.y + 80;
//    self.view.frame = f;
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    //Remove Common Photo Encodeed and Filename
    [[Singleton sharedSingleton] setStrImgEncoded:@""];
    [[Singleton sharedSingleton] setstrImgFilename:@""];
    

  //  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
