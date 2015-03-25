//
//  MyLoyaltyCardView.m
//  Loyalty App
//
//  Created by Amit Parmar on 18/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "MyLoyaltyCardView.h"
#import "cardCell.h"
#import "addCardViewController.h"
#import "Singleton.h"
#import "specialOfferDetailViewController.h"
#import "addCardViewControllerNew.h"

#define CONSTANT_TAG 1000
#define Diamond_Height_Ipad 190
#define Extra_SPace 20
#define Diamond_Height_Iphone 175

@interface MyLoyaltyCardView ()
@end
@implementation MyLoyaltyCardView
@synthesize collectionViewBarcode,btnBar;
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
    app._flagMainBtn = 3;
    self.view.userInteractionEnabled = YES;
    
    UIImage *imgtry = [UIImage imageNamed:@"zdefault-image400x200.png"];
    [[Singleton sharedSingleton] saveImageInCache:imgtry ImgName:@"zdefault-image400x200.png"];
    
    NSLog(@"%@", [[Singleton sharedSingleton] getListOfImagesCaches:@".JPG"]);
    NSLog(@"%@", [[Singleton sharedSingleton] getListOfImagesCaches:@".PNG"]);
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sampledb.sql"];
        
    [self.view addSubview:[app setMyLoyaltyTopPart]];
    app._flagMyLoyaltyTopButtons = 1;
    
    [collectionViewBarcode registerClass:[cardCell class] forCellWithReuseIdentifier:@"cardCell"];
    [collectionViewBarcode registerClass:[cardCell class] forCellWithReuseIdentifier:@"cardCell_iPad"];
    
    [collectionViewCustomerCard registerClass:[cardCell class] forCellWithReuseIdentifier:@"cardCell"];
    [collectionViewCustomerCard registerClass:[cardCell class] forCellWithReuseIdentifier:@"cardCell_iPad"];
    
    self.lblNoCards.hidden = YES;
    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
   
    if ([[Singleton sharedSingleton] connection]==0)
    {
        if([[[Singleton sharedSingleton] getarrDiamondDetail] count] > 0)
        {
            collectionViewCustomerCard.hidden = NO;
            arrDiamondDetail = [[NSMutableArray alloc] init];
            arrDiamondDetail = [[Singleton sharedSingleton] getarrDiamondDetail];
            [collectionViewCustomerCard reloadData];
            [self setHeightOfCollectionView];
        }
        
        if([[[Singleton sharedSingleton] getarrbarcodeCardDetail] count] <= 0)
        {
            self.lblNoCards.hidden = NO;
            collectionViewBarcode.hidden = YES;
        }
        else
        {
            self.lblNoCards.hidden = YES;
            collectionViewBarcode.hidden = NO;
            arrMyIDCardDetail = [[NSMutableArray alloc] init];
            //            [arrMyIDCardDetail addObject:[[Singleton sharedSingleton] getarrbarcodeCardDetail]];
            arrMyIDCardDetail = [[Singleton sharedSingleton] getarrbarcodeCardDetail];
            [collectionViewBarcode reloadData];
            [self setHeightOfCollectionView];
        }
    }
    else
    {
        [self getMyCards];
    }
  
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [Singleton sharedSingleton].IS_IMAGE_INSTAED_BARCODE = FALSE;
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
-(void)getMyCards
{
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
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
        [dict setValue:userId forKey:@"UserId"];
        
        [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
         {
             NSLog(@"GET MY CARD Info  :  %@ -- ", dict);
             if (dict)
             {
                 Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                 if (!strCode)
                 {
//                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                     [alt show];
                     
                     self.lblNoCards.hidden = NO;
                     self.lblNoCards.text = [dict objectForKey:@"message"];
                 }
                 else
                 {
                      self.lblNoCards.hidden = YES;
                     
                     if([dict objectForKey:@"data"] != [NSNull null])
                     {
                         NSMutableArray *tempArr = [[NSMutableArray alloc] initWithObjects:[dict objectForKey:@"data"], nil];

                         [self setCardView:tempArr];
                     }
                 }
                [self stopActivity];
             }
             else
             {
                 UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alt show];
             }
         } :@"Offers/GetMyCard" data:dict];        
    }
}
#pragma mark SET HEIGHT
-(void)setCardView:(NSMutableArray*)tempArr
{
    
    //*****Card
     [self loadData];
    
    
    //****Diamond
    arrDiamondDetail = [[NSMutableArray alloc] init];
    arrDiamondDetail = [[tempArr objectAtIndex:0] objectForKey:@"Diamonds"];
    NSString *strCustomerId=@"", *strCustomerName=@"";
    NSUserDefaults *st  = [NSUserDefaults standardUserDefaults];
    if([st objectForKey:@"userFirstName"])
    {
        strCustomerName = [NSString stringWithFormat:@"%@ %@", [st objectForKey:@"userFirstName"],  [st objectForKey:@"userLirstName"]];
        strCustomerId = [NSString stringWithFormat:@"%@", [st objectForKey:@"UserId"]];
    }
    NSMutableArray *temparrCustomer = [[NSMutableArray alloc] init];
    NSMutableDictionary *dictCustomer = [[NSMutableDictionary alloc] init];
    [dictCustomer setValue:strCustomerName forKey:@"CustomerName"];
    [dictCustomer setValue:strCustomerId forKey:@"CustomerId"];
    [temparrCustomer addObject:dictCustomer];
    if([temparrCustomer count] > 0)
    {
        temparrCustomer = [temparrCustomer objectAtIndex:0];
    }
    [arrDiamondDetail insertObject:temparrCustomer atIndex:0];
    [[Singleton sharedSingleton] setarrDiamondDetail:arrDiamondDetail];
    collectionViewCustomerCard.hidden = NO;
    [collectionViewCustomerCard reloadData];
    [self setHeightOfCollectionView];
    
    
//    //****Card
//    arrMyIDCardDetail = [[NSMutableArray alloc] init];
//    arrMyIDCardDetail = [[tempArr objectAtIndex:0] objectForKey:@"Cards"];
//    //                         [arrMyIDCardDetail addObject:[[tempArr objectAtIndex:0] objectForKey:@"Cards"]];
//    collectionViewBarcode.hidden = NO;
//    [collectionViewBarcode reloadData];
//    [[Singleton sharedSingleton] setarrbarcodeCardDetail:arrMyIDCardDetail];
//    [self setHeightOfCollectionView];
//    
//    //****Diamond
//    arrDiamondDetail = [[NSMutableArray alloc] init];
//    arrDiamondDetail = [[tempArr objectAtIndex:0] objectForKey:@"Diamonds"];
//    NSString *strCustomerId=@"", *strCustomerName=@"";
//    NSUserDefaults *st  = [NSUserDefaults standardUserDefaults];
//    if([st objectForKey:@"userFirstName"])
//    {
//        strCustomerName = [NSString stringWithFormat:@"%@ %@", [st objectForKey:@"userFirstName"],  [st objectForKey:@"userLirstName"]];
//        strCustomerId = [NSString stringWithFormat:@"%@", [st objectForKey:@"UserId"]];
//    }
//    NSMutableArray *temparrCustomer = [[NSMutableArray alloc] init];
//    NSMutableDictionary *dictCustomer = [[NSMutableDictionary alloc] init];
//    [dictCustomer setValue:strCustomerName forKey:@"CustomerName"];
//    [dictCustomer setValue:strCustomerId forKey:@"CustomerId"];
//    [temparrCustomer addObject:dictCustomer];
//    if([temparrCustomer count] > 0)
//    {
//        temparrCustomer = [temparrCustomer objectAtIndex:0];
//    }
//    [arrDiamondDetail insertObject:temparrCustomer atIndex:0];
//    [[Singleton sharedSingleton] setarrDiamondDetail:arrDiamondDetail];
//    collectionViewCustomerCard.hidden = NO;
//    [collectionViewCustomerCard reloadData];
//    [self setHeightOfCollectionView];
}
-(void)setHeightOfCollectionView
{
    float globalH ;
    float division;
    float h;

    if(IS_IPAD)
    {
        globalH = Diamond_Height_Ipad;
        division = [arrDiamondDetail count] / 3;
        if([arrDiamondDetail count] % 3 == 0)
        {
            h =  (division) * globalH;
        }
        else
        {
            h =  (division+1) * globalH;
        }
    }
    else
    {
        globalH = Diamond_Height_Iphone;
        division = [arrDiamondDetail count] / 2;
        if([arrDiamondDetail count] % 2 == 0)
        {
            h =  (division) * globalH;
        }
        else
        {
            h =  (division+1) * globalH;
        }
    }
    
    CGRect f = collectionViewCustomerCard.frame;
     if(IS_IPAD)
     {
         f.size.height =  h + (Extra_SPace*(division+1));
     }
    else
    {
        f.size.height =  h ; //+ (Extra_SPace*(division));
    }
    collectionViewCustomerCard.frame = f;
    
    f = viewSeparator.frame;
    f.origin.y = collectionViewCustomerCard.frame.origin.y + collectionViewCustomerCard.frame.size.height + 20;
    viewSeparator.frame = f;
    
    
    if(IS_IPAD)
    {
        division = [arrMyIDCardDetail count] / 3;
    }
    else
    {
        division = [arrMyIDCardDetail count] / 2;
    }
   
    if(IS_IPAD)
    {
        h =  (division+1) * globalH;
    }
    else
    {
        h =  (division+1) * globalH;
    }
    
    
    f = collectionViewBarcode.frame;
    f.origin.y = viewSeparator.frame.origin.y + viewSeparator.frame.size.height + 20;
    if(IS_IPAD)
    {
        f.size.height = h + (Extra_SPace*(division+1));
    }
    else
    {
        f.size.height = h + Extra_SPace ; //+ (Extra_SPace*(division));
    }
    collectionViewBarcode.frame = f;
    
    
    scrollView.contentSize = CGSizeMake(0, collectionViewBarcode.frame.origin.y + collectionViewBarcode.frame.size.height + 50);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark CollectionView Delegate Method
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if(collectionView == collectionViewBarcode)
//    {
//        if(indexPath.row == [[arrMyIDCardDetail objectAtIndex:0] count]-1)
//        {
//            
//        }
//    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPAD)
    {
         return CGSizeMake(230, Diamond_Height_Ipad);
    }
    else{
        return CGSizeMake(150, Diamond_Height_Iphone); //260
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == collectionViewCustomerCard)
    {
        return [arrDiamondDetail count];
    }
    else
    {
        if([arrMyIDCardDetail count] > 0)
        {
              return [arrMyIDCardDetail count];
            
//            if([ (NSMutableArray*)[arrMyIDCardDetail objectAtIndex:0] count] > 0)
//            {
//                return [(NSMutableArray*)[arrMyIDCardDetail objectAtIndex:0] count];
//            }
        }
    }
    return 0;
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier;
    
    if(IS_IPAD)
    {
        cellIdentifier=@"cardCell_iPad";
    }
    else
    {
        cellIdentifier=@"cardCell";
    }
    cardCell *cell = (cardCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.imgbarcodeImg.contentMode = UIViewContentModeScaleAspectFill;
    cell.imgbarcodeImg.clipsToBounds=YES;
    
    
    if(collectionView == collectionViewCustomerCard)
    {
        cell.btnBGMain.tag = indexPath.row;
        cell.imgbarcodeImg.tag = indexPath.row;
        cell.btnbarcodeImg.hidden = YES;
        cell.btnEdit.tag = indexPath.row;
        
        CGRect f = cell.imgbarcodeImg.frame;
        if(IS_IPAD)
        {
            //            f.size.width = 230;
        }
        else
        {
            f.size.width = 115; //170;
        }
        cell.imgbarcodeImg.frame = f;
        
        
        if(indexPath.row == 0)
        {
            cell.btnEdit.hidden=YES;
            CGRect f = cell.lblBarcodeName.frame;
            if(IS_IPAD)
            {
                f.size.width = 230;
            }
            else
            {
                f.size.width = 115; //170;
            }
            cell.lblBarcodeName.frame =f;
            [cell.imgbarcodeImg setImage:[UIImage imageNamed:@"defaultImage.png"]];
            cell.lblBarcodeName.text= [NSString stringWithFormat:@"LoyaltyCamp ID: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"UfId"]]; //@"My LoyaltyCamp ID";
            NSLog(@"ID : %@", [NSString stringWithFormat:@"LoyaltyCamp ID: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"UfId"]]);
        }
        else
        {
            cell.btnEdit.hidden=NO;
            
            [cell.imgbarcodeImg setImage:[UIImage imageNamed:@"defaultImage.png"]];
            cell.lblBarcodeName.text=[NSString stringWithFormat:@"%@", [[arrDiamondDetail objectAtIndex:indexPath.row] objectForKey:@"OfferName"]];
        }
        
        [cell.btnBGMain addTarget:self action:@selector(Customer_OfferCardClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnEdit addTarget:self action:@selector(btnEditSpecialOfferlicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tapRecognizer;
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Customer_OfferCardClicked:)] ;
        tapRecognizer.numberOfTapsRequired = 1;
        [cell.imgbarcodeImg addGestureRecognizer:tapRecognizer];
        
        
        dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue1, ^{
            
            if(indexPath.row == 0)
            {
                dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.myCompanyName.imagegrabber.bgqueue", NULL);
                dispatch_async(backgroundQueue, ^(void) {
                    
                    // QRCode Image
                    
                    NSString *imageName = [NSString stringWithFormat:@"https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=%@&choe=UTF-8", [[arrDiamondDetail objectAtIndex:indexPath.row] objectForKey:@"CustomerId"]];
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        
                        if(image == nil)
                        {
                            [cell.imgbarcodeImg setImage:[UIImage imageNamed:@"defaultImage.png"]];
                        }
                        else
                        {
                            [cell.imgbarcodeImg setImage:image];
                        }
                    });
                    
                });
                
            }
            else
            {
                NSString *s =[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrDiamondDetail objectAtIndex:indexPath.row] objectForKey:@"SpecialOffer"]];
                
                if([s isEqualToString:@""])
                {
                    [cell.imgbarcodeImg setImage:[UIImage imageNamed:@"defaultImage.png"]];
                }
                else
                {
                    dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.myCompanyName.imagegrabber.bgqueue", NULL);
                    dispatch_async(backgroundQueue, ^(void) {
                        
                        // QRCode Image
                        
                        NSString *imageName = [NSString stringWithFormat:@"https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=%@&choe=UTF-8", s];
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
                        
                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                            
                            if(image == nil)
                            {
                                [cell.imgbarcodeImg setImage:[UIImage imageNamed:@"defaultImage.png"]];
                            }
                            else
                            {
                                [cell.imgbarcodeImg setImage:image];
                            }
                        });
                    });
                    
                }
            }
        });
    }
    else if(collectionView == self.collectionViewBarcode)
    {
        cell.btnBGMain.tag = indexPath.row;
        cell.btnbarcodeImg.tag = indexPath.row;
        cell.imgbarcodeImg.tag = indexPath.row;
        cell.btnEdit.tag = indexPath.row;
        
        cell.btnbarcodeImg.userInteractionEnabled = YES;
        [cell.btnbarcodeImg addTarget:self action:@selector(ZoomBarcodeImageClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnBGMain.userInteractionEnabled = YES;
        [cell.btnBGMain addTarget:self action:@selector(ZoomBarcodeImageClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnEdit addTarget:self action:@selector(AddViewBarcodeClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.lblBarcodeName.text= [NSString stringWithFormat:@"%@", [[arrMyIDCardDetail objectAtIndex:indexPath.row] objectAtIndex:1]];
       
        [cell.imgbarcodeImg setImage:[UIImage imageNamed:@"defaultImage.png"]];
        
        dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue1, ^{
            
            UIImage *image;
            NSString *imgStr =  [NSString stringWithFormat:@"%@/%@",[[Singleton sharedSingleton] getPathofImageStoreInDevice], [[self.arrCardInfo objectAtIndex:indexPath.row] objectAtIndex:3]];
            //@"zdefault-image400x200.png";//
           
            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:imgStr] isEqualToString:@""])
            {
                image =  [[Singleton sharedSingleton] getImageFromCache:[imgStr lastPathComponent]];
                
                if(image != nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [cell.imgbarcodeImg setImage:image];
                    });
                }
                else
                {
                    [cell.imgbarcodeImg setImage:[UIImage imageNamed:@"defaultImage.png"]];
                }
            }
        });
        
    }
    
    return cell;
}

/*
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier;
    
    if(IS_IPAD)
    {
        cellIdentifier=@"cardCell_iPad";
    }
    else
    {
        cellIdentifier=@"cardCell";
    }
    cardCell *cell = (cardCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.imgbarcodeImg.contentMode = UIViewContentModeScaleAspectFill;
    cell.imgbarcodeImg.clipsToBounds=YES;
    
    
    if(collectionView == collectionViewCustomerCard)
    {
        cell.btnBGMain.tag = indexPath.row;
        cell.imgbarcodeImg.tag = indexPath.row;
        cell.btnbarcodeImg.hidden = YES;
        cell.btnEdit.tag = indexPath.row;
        
        CGRect f = cell.imgbarcodeImg.frame;
        if(IS_IPAD)
        {
//            f.size.width = 230;
        }
        else
        {
            f.size.width = 115; //170;
        }
        cell.imgbarcodeImg.frame = f;
        
        
        if(indexPath.row == 0)
        {
            cell.btnEdit.hidden=YES;
            CGRect f = cell.lblBarcodeName.frame;
            if(IS_IPAD)
            {
                f.size.width = 230;
            }
            else
            {
                f.size.width = 115; //170;
            }
            cell.lblBarcodeName.frame =f;
            [cell.imgbarcodeImg setImage:[UIImage imageNamed:@"defaultImage.png"]];
            cell.lblBarcodeName.text= [NSString stringWithFormat:@"LoyaltyCamp ID: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"UfId"]]; //@"My LoyaltyCamp ID";
            NSLog(@"ID : %@", [NSString stringWithFormat:@"LoyaltyCamp ID: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"UfId"]]);
        }
        else
        {            
            cell.btnEdit.hidden=NO;
          
            [cell.imgbarcodeImg setImage:[UIImage imageNamed:@"defaultImage.png"]];
            cell.lblBarcodeName.text=[NSString stringWithFormat:@"%@", [[arrDiamondDetail objectAtIndex:indexPath.row] objectForKey:@"OfferName"]];
        }        
        
        [cell.btnBGMain addTarget:self action:@selector(Customer_OfferCardClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnEdit addTarget:self action:@selector(btnEditSpecialOfferlicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tapRecognizer;
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Customer_OfferCardClicked:)] ;
        tapRecognizer.numberOfTapsRequired = 1;
        [cell.imgbarcodeImg addGestureRecognizer:tapRecognizer];
        
        
        dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue1, ^{
            
            if(indexPath.row == 0)
            {
                dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.myCompanyName.imagegrabber.bgqueue", NULL);
                dispatch_async(backgroundQueue, ^(void) {
                    
                    // QRCode Image
                    
                    NSString *imageName = [NSString stringWithFormat:@"https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=%@&choe=UTF-8", [[arrDiamondDetail objectAtIndex:indexPath.row] objectForKey:@"CustomerId"]];
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        
                        if(image == nil)
                        {
                            [cell.imgbarcodeImg setImage:[UIImage imageNamed:@"defaultImage.png"]];
                        }
                        else
                        {
                             [cell.imgbarcodeImg setImage:image];
                        }
                    });
                    
                });

            }
            else
            {
                NSString *s =[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrDiamondDetail objectAtIndex:indexPath.row] objectForKey:@"SpecialOffer"]];
                
                if([s isEqualToString:@""])
                {
                      [cell.imgbarcodeImg setImage:[UIImage imageNamed:@"defaultImage.png"]];
                }
                else
                {
                    dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.myCompanyName.imagegrabber.bgqueue", NULL);
                    dispatch_async(backgroundQueue, ^(void) {
                        
                        // QRCode Image
                        
                        NSString *imageName = [NSString stringWithFormat:@"https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=%@&choe=UTF-8", s];
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
                        
                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                            
                            if(image == nil)
                            {
                                [cell.imgbarcodeImg setImage:[UIImage imageNamed:@"defaultImage.png"]];
                            }
                            else
                            {
                                [cell.imgbarcodeImg setImage:image];
                            }
                        });
                    });

                }
              }
        });        
    }
    else if(collectionView == self.collectionViewBarcode)
    {
        cell.btnBGMain.tag = indexPath.row;
        cell.btnbarcodeImg.tag = indexPath.row;
        cell.imgbarcodeImg.tag = indexPath.row;
        cell.btnEdit.tag = indexPath.row;
        
        cell.btnBGMain.userInteractionEnabled = YES;
        [cell.btnBGMain addTarget:self action:@selector(ZoomBarcodeImageClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.btnbarcodeImg addTarget:self action:@selector(ZoomBarcodeImageClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnEdit addTarget:self action:@selector(AddViewBarcodeClicked:) forControlEvents:UIControlEventTouchUpInside];
        
         cell.lblBarcodeName.text= [NSString stringWithFormat:@"%@", [[arrMyIDCardDetail objectAtIndex:indexPath.row] objectForKey:@"CardId"]];
//        [cell.btnbarcodeImg setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
          [cell.imgbarcodeImg setImage:[UIImage imageNamed:@"defaultImage.png"]];
        
        
//        cell.imgbarcodeImg.userInteractionEnabled=YES;
//        UITapGestureRecognizer *tapRecognizer;
//        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ZoomBarcodeImageClicked:)] ;
//        tapRecognizer.numberOfTapsRequired = 1;
//        [cell.imgbarcodeImg addGestureRecognizer:tapRecognizer];

        
        dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue1, ^{
            
            UIImage *image;
            NSString *imgStr =[[arrMyIDCardDetail  objectAtIndex:indexPath.row] objectForKey:@"Photo"];
            
            if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:imgStr] isEqualToString:@""])
            {
                NSString *imageName = [NSString stringWithFormat:@"%@%@", HOSTMEDIA,   imgStr];
                image =  [[Singleton sharedSingleton] getImageFromCache:[imageName lastPathComponent]];
                
                if(image != nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
//                        [cell.btnbarcodeImg setBackgroundImage:image forState:UIControlStateNormal];
//                        [cell.btnbarcodeImg setImage:image forState:UIControlStateNormal];
                        
                     [cell.imgbarcodeImg setImage:image];
                        
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
                    
                    //  /Upload/UserCard/bb1f9253-ae44-44a1-8427-94d1a0e71dfc/bb1f9253-ae44-44a1-8427-94d1a0e71dfc_06102014521AM.png
                    
                    [[Singleton sharedSingleton] saveImageInCache:image ImgName:[[arrMyIDCardDetail  objectAtIndex:indexPath.row] objectForKey:@"Photo"]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //
                        
                        if(image == nil)
                        {
//                            [cell.btnbarcodeImg setBackgroundImage:[UIImage imageNamed:@"defaultImage.png"] forState:UIControlStateNormal];
                            [cell.imgbarcodeImg setImage:[UIImage imageNamed:@"defaultImage.png"]];
                            
//                            //temp
//                            UIImage *imageTemp =  [[Singleton sharedSingleton] getImageFromCache:@"LoyaltyTestDemo.png"];
//                            [cell.btnbarcodeImg setBackgroundImage:imageTemp forState:UIControlStateNormal];
                        }
                        else
                        {
//                            [cell.btnbarcodeImg setBackgroundImage:image forState:UIControlStateNormal];
//                            [cell.btnbarcodeImg setImage:image forState:UIControlStateNormal];
                            
                        }
                        [cell.imgbarcodeImg setImage:image];
                    });
                }
            }
        });

    }
    
    return cell;
}
*/
#pragma mark Button Click Event
-(IBAction)btnEditSpecialOfferlicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    specialOfferDetailViewController *detail;
    if (IS_IPHONE_5)
    {
        detail=[[specialOfferDetailViewController alloc] initWithNibName:@"specialOfferDetailViewController-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        detail=[[specialOfferDetailViewController alloc] initWithNibName:@"specialOfferDetailViewController_iPad" bundle:nil];
    }
    else
    {
        detail=[[specialOfferDetailViewController alloc] initWithNibName:@"specialOfferDetailViewController" bundle:nil];
    }
    NSLog(@"1  ----  %@", arrDiamondDetail);
    NSLog(@"2 ----- %@", [[NSMutableArray alloc] initWithObjects:arrDiamondDetail, nil]);
    
    detail.arrRestaurantSpecialOfferDetail = [[NSMutableArray alloc] initWithObjects:arrDiamondDetail, nil];
    detail.joinIndexId = btn.tag;
    [self.navigationController pushViewController:detail animated:YES];
}
-(IBAction)AddViewBarcodeClicked:(id)sender
{
    app._flagMainBtn = 3;
    UIButton *btn = (UIButton*)sender;
    addCardViewControllerNew *addCard ;
    if (IS_IPHONE_5)
    {
        addCard=[[addCardViewControllerNew alloc] initWithNibName:@"addCardViewControllerNew-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        addCard=[[addCardViewControllerNew alloc] initWithNibName:@"addCardViewControllerNew_iPad" bundle:nil];
    }
    else
    {
        addCard=[[addCardViewControllerNew alloc] initWithNibName:@"addCardViewControllerNew" bundle:nil];
    }
    addCard.indexId = btn.tag;
    addCard.delegate = self;
    [self.navigationController pushViewController:addCard animated:YES];
    
//    addCardViewController *addCard ;
//    if (IS_IPHONE_5)
//    {
//        addCard=[[addCardViewController alloc] initWithNibName:@"addCardViewController-5" bundle:nil];
//    }
//    else if (IS_IPAD)
//    {
//        addCard=[[addCardViewController alloc] initWithNibName:@"addCardViewController_iPad" bundle:nil];
//    }
//    else
//    {
//        addCard=[[addCardViewController alloc] initWithNibName:@"addCardViewController" bundle:nil];
//    }
//    addCard.indexId = btn.tag;
//    [self.navigationController pushViewController:addCard animated:YES];
    
    
//    MyLoyaltyCardView *addCard ;
//    
//    if (IS_IPHONE_5)
//    {
//        addCard=[[MyLoyaltyCardView alloc] initWithNibName:@"MyLoyaltyCardView-5" bundle:nil];
//    }
//    else if (IS_IPAD)
//    {
//        addCard=[[MyLoyaltyCardView alloc] initWithNibName:@"MyLoyaltyCardView_iPad" bundle:nil];
//    }
//    else
//    {
//        addCard=[[MyLoyaltyCardView alloc] initWithNibName:@"MyLoyaltyCardView" bundle:nil];
//    }
//    
//    //    CardMasterId =[NSString stringWithFormat:@"%@", [[[arrMyIDCardDetail objectAtIndex:0]objectAtIndex:btn.tag] objectForKey:@"CardMasterId"]];
//    
////    addCard.indexId = btn.tag;
//    [self.navigationController pushViewController:addCard animated:YES];
    
}
-(IBAction)ZoomBarcodeImageClicked:(id)sender
{
    UIButton *b = (UIButton*)sender;
    NSLog(@"b.tag : %d", b.tag);

//    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
//    NSLog (@"%d",[tapRecognizer.view tag]);
    
    imgLargeBarcode = [[UIImageView alloc] init];
    imgLargeBarcode.contentMode = UIViewContentModeScaleAspectFill;
    imgLargeBarcode.clipsToBounds=YES;
    if(IS_IPAD)
    {
        imgLargeBarcode.frame = CGRectMake(0, 180, 768, 624);
    }
    else
    {
        imgLargeBarcode.frame = CGRectMake(0, 100, 320, 380);
    }
    
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue1, ^{
        
        UIImage *image;
       // NSString *imgStr =[[arrMyIDCardDetail  objectAtIndex:b.tag] objectAtIndex:3];
        
        NSString *imgStr =  [NSString stringWithFormat:@"%@/%@",[[Singleton sharedSingleton] getPathofImageStoreInDevice], [[self.arrCardInfo objectAtIndex:b.tag] objectAtIndex:3]];
                                                                 
        if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:imgStr] isEqualToString:@""])
        {
            //image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@", [[Singleton sharedSingleton] getPathofImageStoreInDevice], [[self.arrCardInfo objectAtIndex:b.tag] objectAtIndex:3]]];
          //  NSLog(@"path : %@", [NSString stringWithFormat:@"%@/%@", [[Singleton sharedSingleton] getPathofImageStoreInDevice], [[self.arrCardInfo objectAtIndex:b.tag] objectAtIndex:3]]);
            
            image =  [[Singleton sharedSingleton] getImageFromCache:[imgStr lastPathComponent]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(image != nil)
                {
                    [imgLargeBarcode setImage:image];
                }
                else
                {
                    [imgLargeBarcode setImage:[UIImage imageNamed:@"default-image350x350.png"]];
                }
            });
        }
        
    });
    
    [self.view addSubview:btnBG];
    [self.view addSubview:imgLargeBarcode];
}
-(IBAction)Customer_OfferCardClicked:(id)sender
{
     UIButton *b = (UIButton*)sender;
    NSString *s =[[Singleton sharedSingleton] ISNSSTRINGNULL:[[arrDiamondDetail objectAtIndex:b.tag] objectForKey:@"SpecialOffer"]];
    
    imgLargeBarcode = [[UIImageView alloc] init];
    imgLargeBarcode.contentMode = UIViewContentModeScaleAspectFill;
    imgLargeBarcode.clipsToBounds=YES;
    if(IS_IPAD)
    {
        imgLargeBarcode.frame = CGRectMake(0, 180, 768, 624);
    }
    else
    {
        imgLargeBarcode.frame = CGRectMake(0, 100, 320, 380);
    }
    [imgLargeBarcode setImage:[UIImage imageNamed:@"default-image350x350.png"]];
    
    if(b.tag == 0)
    {
        dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue1, ^{
            
            dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.myCompanyName.imagegrabber.bgqueue", NULL);
            dispatch_async(backgroundQueue, ^(void) {
                
                // QRCode Image
                NSString *imageName = [NSString stringWithFormat:@"https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=%@&choe=UTF-8", [[arrDiamondDetail objectAtIndex:b.tag] objectForKey:@"CustomerId"]];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    
                    if(image == nil)
                    {
                        [imgLargeBarcode setImage:[UIImage imageNamed:@"default-image350x350.png"]];
                    }
                    else
                    {
                        [imgLargeBarcode setImage:image];
                    }
                });
            });
        });
    }
    else
    {
        if([s isEqualToString:@""])
        {
           [imgLargeBarcode setImage:[UIImage imageNamed:@"default-image350x350.png"]];
        }
        else
        {
            dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue1, ^{
                
                dispatch_queue_t backgroundQueue  = dispatch_queue_create("com.myCompanyName.imagegrabber.bgqueue", NULL);
                dispatch_async(backgroundQueue, ^(void) {
                    
                    // QRCode Image
                    NSString *imageName = [NSString stringWithFormat:@"https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=%@&choe=UTF-8",  s];
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        
                        if(image == nil)
                        {
                            [imgLargeBarcode setImage:[UIImage imageNamed:@"default-image350x350.png"]];
                        }
                        else
                        {
                            [imgLargeBarcode setImage:image];
                        }
                    });
                });
            });
        }
   }
    
    
    [self.view addSubview:btnBG];
    [self.view addSubview:imgLargeBarcode];
    
}
- (IBAction)hideParentView:(id)sender
{
    [btnBG removeFromSuperview];
    [imgLargeBarcode removeFromSuperview];
}
- (IBAction)btnbackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   
    [super touchesBegan:touches withEvent:event];
}
#pragma mark DELEGATE
-(void)loadAllCards
{
    NSLog(@"loadAllCards called");
    if([[[Singleton sharedSingleton] getarrbarcodeCardDetail] count] > 0)
    {
        arrMyIDCardDetail = [[NSMutableArray alloc] init];
        arrMyIDCardDetail = [[Singleton sharedSingleton] getarrbarcodeCardDetail];
        collectionViewBarcode.hidden = NO;
        [collectionViewBarcode reloadData];
        [[Singleton sharedSingleton] setarrbarcodeCardDetail:arrMyIDCardDetail];
        [self setHeightOfCollectionView];
    }
}

#pragma mark - Private method implementation
-(void)loadData{
    // Form the query.
      NSLog(@"loadData called");
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    NSString * userId ;
    if([st objectForKey:@"UserId"])
    {
        userId =  [st objectForKey:@"UserId"];
    }
    
    NSString *query = [NSString stringWithFormat:@"select * from tblMyLoyaltyCard where UserId='%@'",userId];
    
    // Get the results.
    if (self.arrCardInfo != nil) {
        self.arrCardInfo = nil;
    }
    self.arrCardInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    NSLog(@"self.arrCardInfo  %d: %@", [self.arrCardInfo count], self.arrCardInfo);

    //****Card
    arrMyIDCardDetail = [[NSMutableArray alloc] init];
    arrMyIDCardDetail = [[NSMutableArray alloc] initWithArray:self.arrCardInfo];//[[tempArr objectAtIndex:0] objectForKey:@"Cards"];

    collectionViewBarcode.hidden = NO;
    [collectionViewBarcode reloadData];
    [[Singleton sharedSingleton] setarrbarcodeCardDetail:arrMyIDCardDetail];
    [self setHeightOfCollectionView];
    
    NSLog(@"arrMyIDCardDetail  %d : %@",[arrMyIDCardDetail count], arrMyIDCardDetail);
}

@end
