//
//  addCardViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 8/13/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "addCardViewControllerNew.h"
#import <QuartzCore/QuartzCore.h>
#import "Singleton.h"
#import "DBManager.h"


@interface addCardViewControllerNew ()
@end

@implementation addCardViewControllerNew
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
    self.view.userInteractionEnabled = YES;
    
    strPathFirst=@"";
    strPathSecond=@"";
    
    app = APP;
    [self.view addSubview:[app setFooterPart]];
    app._flagMainBtn = 3;
    
    [self.view addSubview:[app setMyLoyaltyTopPart]];
    app._flagMyLoyaltyTopButtons = 1;
    
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.txtBarcodeID setLeftViewMode:UITextFieldViewModeAlways];
    [self.txtBarcodeID setLeftView:v];
    
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.txtBarcodeName setLeftViewMode:UITextFieldViewModeAlways];
    [self.txtBarcodeName setLeftView:v1];
    
    self.btnSave.layer.cornerRadius = 5.0;
    self.btnSave.clipsToBounds=YES;
    self.btnSave.exclusiveTouch = YES;
    
    self.scrollview.contentSize = CGSizeMake(0, 600);
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
//    tapGesture.cancelsTouchesInView = NO;
//    tapGesture.numberOfTapsRequired = 1;
//    tapGesture.enabled = YES;
//    [self.scrollview addGestureRecognizer:tapGesture];
//    self.scrollview.contentSize = CGSizeMake(0, 600);
//    self.scrollview.userInteractionEnabled = YES;
//    self.scrollview.exclusiveTouch = YES;
//    self.scrollview.canCancelContentTouches = YES;
//    self.scrollview.delaysContentTouches = YES;
    
    [self.btnSave addTarget:self action:@selector(btnSaveClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // Initialize the dbManager object.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sampledb.sql"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GettingBarcodePhoto) name:@"GettingBarcodePhoto" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GettingBarcodePhoto1) name:@"GettingBarcodePhoto1" object:nil];
    
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
    
    [imgBarcodeImg1 setContentMode:UIViewContentModeScaleAspectFill];
    imgBarcodeImg1.clipsToBounds=YES;
    
    if(indexId == 1111)
    {
        // add new card
        CardMasterId=@"";
        [[Singleton sharedSingleton] setstrImgEncoded:@""];
        [[Singleton sharedSingleton] setstrImgFilename:@""];
        lblTakePhoto.hidden = NO;
        lblTakePhoto1.hidden = NO;
    }
    else
    {
        lblTakePhoto.hidden = YES;
        lblTakePhoto1.hidden = YES;

        if([[[Singleton sharedSingleton] getarrbarcodeCardDetail] count] > 0)
        {
            CardMasterId = [[Singleton sharedSingleton] ISNSSTRINGNULL: [[[[Singleton sharedSingleton] getarrbarcodeCardDetail] objectAtIndex:indexId] objectAtIndex:0]];
            
            self.txtBarcodeName.text = [[[[Singleton sharedSingleton] getarrbarcodeCardDetail]  objectAtIndex:indexId] objectAtIndex:1];
            
            self.txtBarcodeID.text = [[[[Singleton sharedSingleton] getarrbarcodeCardDetail]  objectAtIndex:indexId] objectAtIndex:2];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
            dispatch_async(queue, ^{
                
                UIImage *image, *image1;
                NSString *imgStr = [NSString stringWithFormat:@"%@/%@",[[Singleton sharedSingleton] getPathofImageStoreInDevice], [[[[Singleton sharedSingleton] getarrbarcodeCardDetail]  objectAtIndex:indexId] objectAtIndex:3]];
                NSString *imgStr1 = [NSString stringWithFormat:@"%@/%@",[[Singleton sharedSingleton] getPathofImageStoreInDevice], [[[[Singleton sharedSingleton] getarrbarcodeCardDetail]  objectAtIndex:indexId] objectAtIndex:4]];
                
                if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:imgStr] isEqualToString:@""])
                {
                   
                    image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",[[Singleton sharedSingleton] getPathofImageStoreInDevice], [[[[Singleton sharedSingleton] getarrbarcodeCardDetail]  objectAtIndex:indexId] objectAtIndex:3]]];
                
                    image =  [[Singleton sharedSingleton] getImageFromCache:[imgStr lastPathComponent]];
                    
                    strPathFirst = [[[[Singleton sharedSingleton] getarrbarcodeCardDetail]  objectAtIndex:indexId] objectAtIndex:3];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                            if(image != nil)
                            {
                                 [self.btnBarcodeImg setBackgroundImage:image forState:UIControlStateNormal];
                                 [imgBarcodeImg setImage:image];
                            }
                            else
                            {
                                [self.btnBarcodeImg setBackgroundImage:[UIImage imageNamed:@"default-image350x350.png"] forState:UIControlStateNormal];
                                [imgBarcodeImg setImage:[UIImage imageNamed:@"default-image350x350.png"]];
                            }
                    });
                }
                
                if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:imgStr1] isEqualToString:@""])
                {
                    image1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@", [[Singleton sharedSingleton] getPathofImageStoreInDevice], [[[[Singleton sharedSingleton] getarrbarcodeCardDetail]  objectAtIndex:indexId] objectAtIndex:4]]];
                    
                    image1 =  [[Singleton sharedSingleton] getImageFromCache:[imgStr1 lastPathComponent]];
                    
                    strPathSecond = [[[[Singleton sharedSingleton] getarrbarcodeCardDetail]  objectAtIndex:indexId] objectAtIndex:4];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                            if(image1 != nil)
                            {
                                    [self.btnBarcodeImg1 setBackgroundImage:image1 forState:UIControlStateNormal];
                                    [imgBarcodeImg1 setImage:image1];                                
                            }
                            else
                            {
                                [self.btnBarcodeImg1 setBackgroundImage:[UIImage imageNamed:@"default-image350x350.png"] forState:UIControlStateNormal];
                                [imgBarcodeImg1 setImage:[UIImage imageNamed:@"default-image350x350.png"]];
                            }
                     });
                }
            });
        }
        else
        {
            
        }
    }
    
  
//    if(IS_IPAD)
//    {
//        viewbackForm.layer.cornerRadius = 5.0;
//        viewbackForm.clipsToBounds = YES;
//        viewbackForm.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        viewbackForm.layer.borderWidth = 1.0f;        
//    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void)GettingBarcodePhoto // : (NSNotification *)notification
{
    NSLog(@"_________ Getting photo n name __________1st Side");
    
    strPathFirst =  [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] getstrImgFilename]]; //[NSString stringWithFormat:@"%@", [Singleton sharedSingleton].strFullPathOfImage];
    NSLog(@"strPathFirst : %@", strPathFirst);
    
    [self.btnBarcodeImg setBackgroundImage:[[Singleton sharedSingleton] decodeBase64ToImage:[[Singleton sharedSingleton] getstrImgEncoded]] forState:UIControlStateNormal];
  
    [imgBarcodeImg setContentMode:UIViewContentModeScaleAspectFill];
    imgBarcodeImg.clipsToBounds=YES;
    imgBarcodeImg.image = [[Singleton sharedSingleton] decodeBase64ToImage:[[Singleton sharedSingleton] getstrImgEncoded]];
    
    lblTakePhoto.hidden=YES;
    if(self.btnBarcodeImg.currentBackgroundImage == nil)
    {
        NSLog(@"Null barcode Image");
        
         [self.btnBarcodeImg setBackgroundImage:[UIImage imageNamed:@"default-image350x350.png"] forState:UIControlStateNormal];
         lblTakePhoto.hidden=NO;
    }
    
   
}

-(void)GettingBarcodePhoto1 // : (NSNotification *)notification
{
    NSLog(@"_________ Getting photo1 n name __________2nd side");
    
    [self.btnBarcodeImg1 setBackgroundImage:[[Singleton sharedSingleton] decodeBase64ToImage:[[Singleton sharedSingleton] getstrImgEncoded]] forState:UIControlStateNormal];
    
    strPathSecond = [NSString stringWithFormat:@"%@", [[Singleton sharedSingleton] getstrImgFilename]];//[NSString stringWithFormat:@"%@", [Singleton sharedSingleton].strFullPathOfImage];
    NSLog(@"strPathSecond : %@", strPathSecond);
    
    [imgBarcodeImg1 setContentMode:UIViewContentModeScaleAspectFill];
    imgBarcodeImg1.clipsToBounds=YES;
    imgBarcodeImg1.image = [[Singleton sharedSingleton] decodeBase64ToImage:[[Singleton sharedSingleton] getstrImgEncoded]];
    
    lblTakePhoto1.hidden=YES;
    
    if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:[Singleton sharedSingleton].strBarcodeId] isEqualToString:@""])
    {
        self.txtBarcodeID.text=[Singleton sharedSingleton].strBarcodeId;
    }
    if(self.btnBarcodeImg1.currentBackgroundImage == nil)
    {
        NSLog(@"Null barcode Image");
        
        [self.btnBarcodeImg1 setBackgroundImage:[UIImage imageNamed:@"default-image350x350.png"] forState:UIControlStateNormal];
        lblTakePhoto1.hidden=NO;
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
- (IBAction)btnSaveClicked:(id)sender
{
    if([[[Singleton sharedSingleton] ISNSSTRINGNULL:strPathFirst] isEqualToString:@""])
    {
        [Singleton showToastMessage:@"Please take photo of first part"];
        return;
    }
    else if([[[Singleton sharedSingleton] ISNSSTRINGNULL:strPathSecond] isEqualToString:@""])
    {
        [Singleton showToastMessage:@"Please take photo of barcode"];
        return;
    }
    else if([[[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtBarcodeID.text] isEqualToString:@""])
    {
        [Singleton showToastMessage:@"Please enter barcode id"];
        return;
    }
    else if([[[Singleton sharedSingleton] ISNSSTRINGNULL:self.txtBarcodeName.text] isEqualToString:@""])
    {
        [Singleton showToastMessage:@"Please enter barcode name"];
        return;
    }
    
    // Prepare the query string.
    // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
    NSString *query;
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    NSString * userId ;
    if([st objectForKey:@"UserId"])
    {
        userId =  [st objectForKey:@"UserId"];
    }
    if (indexId == 1111) {
        query = [NSString stringWithFormat:@"insert into tblMyLoyaltyCard values(null, '%@', '%@', '%@', '%@', '%@')", self.txtBarcodeName.text, self.txtBarcodeID.text, strPathFirst, strPathSecond, userId];
    }
    else{
        query = [NSString stringWithFormat:@"update tblMyLoyaltyCard set CardName='%@', CardBarcodeId='%@', CardFirstsideImagePath='%@', CardSecondsideImagePath='%@' where CardUniqueID='%@' and UserId='%@'", self.txtBarcodeName.text, self.txtBarcodeID.text,  strPathFirst, strPathSecond, CardMasterId, userId];
    }
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    
        // Inform the delegate that the editing was finished.
        if([self.delegate respondsToSelector:@selector(loadData)]){
            [self.delegate loadData];
        }
      
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
        [Singleton showToastMessage:ERROR_MSG];
    }
    
    /*
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
                             
                             //Remove Common Photo Encodeed and Filename
                             [[Singleton sharedSingleton] setStrImgEncoded:@""];
                             [[Singleton sharedSingleton] setstrImgFilename:@""];
                             
                             [self.delegate loadAllCards];
                             
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"message"]  message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                             alert.tag= 15;
                             [alert show];
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
    }*/
}

- (IBAction)btnCameraClicked:(id)sender
{
    UIButton *b = (UIButton*) sender;
    [[Singleton sharedSingleton] CameraClicked:self.view Control:b];
    
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

-(void)hideKeyboard
{
        [self.txtBarcodeName resignFirstResponder];
        [self.txtBarcodeID resignFirstResponder];
        self.scrollview.contentOffset=CGPointMake(0, 0);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(!IS_IPAD)
    {
        if(textField == self.txtBarcodeID)
        {
            self.scrollview.contentOffset=CGPointMake(0, 260);
        }
        else if(textField == self.txtBarcodeName)
        {
            self.scrollview.contentOffset=CGPointMake(0, 310);
        }
    }
    else
    {
        if(textField == self.txtBarcodeID)
        {
            self.scrollview.contentOffset=CGPointMake(0, 230);
        }
        else if(textField == self.txtBarcodeName)
        {
            self.scrollview.contentOffset=CGPointMake(0, 280);
        }
    }
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.scrollview.contentOffset=CGPointMake(0, 0);
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if(textField == self.txtBarcodeID)
    {
        [self.txtBarcodeID resignFirstResponder];
        [self.txtBarcodeName becomeFirstResponder];
    }
    else if(textField == self.txtBarcodeName)
    {
        [self.txtBarcodeName resignFirstResponder];
        if(IS_IPAD)
        {
            self.scrollview.contentOffset=CGPointMake(0, 0);
        }
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.txtBarcodeID)
    {
        [self.txtBarcodeID resignFirstResponder];
        [self.txtBarcodeName becomeFirstResponder];
    }
    else if(textField == self.txtBarcodeName)
    {
        [self.txtBarcodeName resignFirstResponder];
        if(IS_IPAD)
        {
            self.scrollview.contentOffset=CGPointMake(0, 0);
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    //Remove Common Photo Encodeed and Filename
    [[Singleton sharedSingleton] setStrImgEncoded:@""];
    [[Singleton sharedSingleton] setstrImgFilename:@""];
    

  //  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
