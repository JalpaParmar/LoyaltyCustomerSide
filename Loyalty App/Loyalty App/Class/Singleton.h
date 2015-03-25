//
//  singelton.h
//  Loyalty App
//
//  Created by Ntech Technologies on 8/11/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Reachability.h"
#import "PayPalMobile.h"
#import "LRouteController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ALAssetsLibrary+CustomPhotoAlbum.h>
#import "ZBarSDK.h"


typedef void (^OnComplate) (NSDictionary * dict);
@class Reachability;
@interface Singleton : NSObject <UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIWebViewDelegate, PayPalPaymentDelegate, ZBarReaderDelegate>
{
    Reachability* internetReachable;
    Reachability *hostReachability;
    Reachability *internetReachability;
    Reachability *wifiReachability;

    GMSMutablePath *path;
    GMSPolyline *polyline;
    LRouteController *_routeController;
    NSMutableArray *_coordinates;
    GMSMarker *_markerFinish, *_markerStart;
    
    
    NSInteger connection;
    int indexId, itemIndexId, flagGoToDirectAddOrder, flagJoinFromDetail;
    NSString *strImgEncoded, *strImgFilename, *charID, *strRestaurantForChat, *strLoginUserChat,*countryId, *stateId, *cityId,  *countryDBID, *stateDBID, *cityDBID, *PaymentMode, *alertOTPMsg ;
    
    NSMutableArray *arrRestaurantList, *arrItemListOfSelectedCategory, *arrTableList, *arrFavoriteRestaurantList, *arrOrderOfCurrentUser, *arrCountryList, *arrStateList, *arrICEContactDetail, *arrICEIDCardDetail, *arrICEMeditcation, *arrbarcodeCardDetail, *arrCompanyDetail, *arrCityList, *arrProfileDetail, *arrChatDetail, *arrRedeemPoints, *arrOrderDetail, *arrGmsPolyLines, *arrEditQtyOfOrderItems, *arrDiamondDetail;
    float globalTotalPoints, minimumOrder;
    BOOL IS_OTP_SUCCESS;
}
@property (nonatomic, assign) float totalPriceInCart;
@property (nonatomic, strong) NSString *strEnteredOTP, *strOTPServer, *strFullPathOfImage, *strCurrencySign, *strBarcodeId;

@property (nonatomic, strong) Reachability *hostReachability;
@property (nonatomic, strong) Reachability *internetReachability;
@property (nonatomic, strong) Reachability *wifiReachability;

@property (nonatomic, assign) BOOL IS_VISITED_MAP, IS_FIRST_SIDE, IS_IMAGE_INSTAED_BARCODE;
@property (nonatomic, assign)  float globalTotalPoints, minimumOrder, globalHomeDeliveryDistance;
@property (nonatomic, assign) int globalEnteredRedeemPoints, globalRedeemPoints_flag;
@property (nonatomic, strong)  GMSMutablePath *path;
@property (nonatomic, strong) GMSPolyline *polyline;
@property (nonatomic, assign) int indexId, flagGoToDirectAddOrder, itemIndexId, flagJoinFromDetail;
@property (nonatomic, strong) NSMutableArray *arrRestaurantList, *arrItemListOfSelectedCategory, *arrTableList, *arrFavoriteRestaurantList, *arrOrderOfCurrentUser, *arrCountryList, *arrStateList, *arrICEContactDetail, *arrICEIDCardDetail, *arrICEMeditcation, *arrbarcodeCardDetail, *arrCompanyDetail, *arrCityList, *arrProfileDetail, *arrChatDetail, *arrRedeemPoints, *arrOrderDetail, *arrGmsPolyLines, *arrEditQtyOfOrderItems, *arrDiamondDetail;
@property (nonatomic, strong) NSString *strImgEncoded, *strImgFilename, *charID, *strRestaurantForChat, *countryId, *stateId, *cityId,  *countryDBID, *stateDBID, *cityDBID;
@property(nonatomic) NSInteger connection;



@property(nonatomic, strong, readwrite) IBOutlet UIView *successView;
@property(nonatomic, strong, readwrite) NSString *resultText, *PaymentMode, *transcationID;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(nonatomic, strong, readwrite) NSString *environment;
@property (strong, atomic) ALAssetsLibrary* library;


+ (void)showToastMessage:(NSString *)message;
+(Singleton*)sharedSingleton;
-(UIToolbar*)AccessoryButtonsForNumPad:(id)self_;

-(void)checkConnection;
-(void)errorInternetConnection;
-(void)checkPendingOrderInArray;
-(NSInteger) checkNetworkStatus:(NSNotification *)notice;

- (void)setPayPalEnvironment;
-(void)PayPalConfigOnDidLoad;
-(void)PayPalCheckOutClicked:(NSMutableDictionary*)dict;

-(NSString *)ConvertMilliSecIntoDate:(NSString *)str Format:(NSString*)formt;
-(NSString*)ISNSSTRINGNULL:(NSString*)str;
-(NSString *)getCurrentDayName;
-(NSString*)getDistanceBetweenLocations:(double)lat Lon:(double)lon Aontherlat:(double)anotherLat AnotheLong:(double)anotherLong;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
-(NSString *)ConvertMilliSecIntoDate:(NSString *)str;
-(NSString*)getStateIdFromIndexId:(NSString*)sName;
-(NSString*)getCountryIdFromIndexId:(NSString*)cName;
-(NSString*)removePostfixFromTime:(NSString*)time;
-(CGSize)heightOfTextForLabel:(NSString *)aString andFont:(UIFont *)aFont maxSize:(CGSize)aSize;
-(void)callOrderStartService:(id)unknownTypeParameter OrderStatus:(BOOL)IS_Order_StartDelete TableId:(NSString*)TableId;
-(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews;
-(NSString*)getReviewFromGLobalArray:(NSArray*)arrRating;
-(void)CallLogoutGlobally;
- (NSString *) substituteEmoticons : (NSString*)msg;
- (NSString *) getCurrentTime;
-(void)resetAllArrayAndVariables;
-(void)checkViewControllerExitsNRemove;
- (BOOL)validateEmailWithString:(NSString*)email;
- (BOOL) validateUrlWithString: (NSString *) candidate;

-(CGSize)getDynamicHeightofLabels:(NSString*)text SIZE:(CGSize)aSize FONT:(UIFont*)font;

//-(void)checkGPSCallViews;
-(void)ReadTermsCondition_privacypolicy:terms WebView:(UIWebView*)wb;

-(void)drawCircleAroundMe:(CLLocationCoordinate2D)coordinate GMSGOOGLEMAP:(GMSMapView*)mapView_;
-(void)drawPathBetweenLocations:(NSMutableArray*)arr GMSGOOGLEMAP:(GMSMapView*)mapView_;
-(void)RemovePathBetweenLocations:(NSMutableArray*)arr GMSGOOGLEMAP:(GMSMapView*)mapView_;


-(void)setIndexId:(int)index;
-(int)getIndexId;
-(void)setitemIndexId:(int)index;
-(int)getitemIndexId;
-(void)setflagGoToDirectAddOrder:(int)index;
-(int)getflagGoToDirectAddOrder;
-(void)setarrRestaurantList:(NSArray*)arr;
-(NSMutableArray*)getarrRestaurantList;
-(void)setarrItemListOfSelectedCategory:(NSArray*)arr;
-(NSMutableArray*)getarrItemListOfSelectedCategory;
-(void)setarrTableList:(NSArray*)arr;
-(NSMutableArray*)getarrTableList;
-(void)setarrOrderOfCurrentUser:(NSArray*)arr;
-(NSMutableArray*)getarrOrderOfCurrentUser;
-(void)setarrCountryList:(NSArray*)arr;
-(NSMutableArray*)getarrCountryList;
-(void)setarrStateList:(NSArray*)arr;
-(NSMutableArray*)getarrStateList;
-(void)setarrFavoriteRestaurantList:(NSArray*)arr;
-(NSMutableArray*)getarrFavoriteRestaurantList;
-(NSString*)getstrImgEncoded;
-(void)setstrImgEncoded:(NSString*)str;
-(NSString*)getstrImgFilename;
-(void)setstrImgFilename:(NSString*)str;
-(void)setarrICEContactDetail:(NSArray*)arr;
-(NSMutableArray*)getarrICEContactDetail;
-(void)setarrICEIDCardDetail:(NSArray*)arr;
-(NSMutableArray*)getarrICEIDCardDetail;
-(void)setarrICEMeditcation:(NSArray*)arr;
-(NSMutableArray*)getarrICEMeditcation;
-(void)setarrbarcodeCardDetail:(NSArray*)arr;
-(NSMutableArray*)getarrbarcodeCardDetail;
-(void)setarrDiamondDetail:(NSArray*)arr;
-(NSMutableArray*)getarrDiamondDetail;
-(void)setarrCompanyDetail:(NSArray*)arr;
-(NSMutableArray*)getarrCompanyDetail;
-(void)setarrCityList:(NSArray*)arr;
-(NSMutableArray*)getarrCityList;
-(void)setcharID:(NSString*)str;
-(NSString*)getcharID;
-(void)setarrProfileDetail:(NSArray*)arr;
-(NSMutableArray*)getarrProfileDetail;
-(void)setarrChatDetail:(NSArray*)arr;
-(NSMutableArray*)getarrChatDetail;
-(void)setstrRestaurantForChat:(NSString*)str;
-(NSString*)getstrRestaurantForChat;
-(void)setstrLoginUserChat:(NSString*)str;
-(NSString*)getstrLoginUserChat;
-(void)setarrRedeemPoints:(NSArray*)arr;
-(NSMutableArray*)getarrRedeemPoints;
-(void)setarrOrderDetail:(NSArray*)arr;
-(NSMutableArray*)getarrOrderDetail;
-(void)setarrEditQtyOfOrderItems:(NSArray*)arr;
-(NSMutableArray*)getarrEditQtyOfOrderItems;

-(NSString*)splitOrderIDFromDash:(NSString*)OrderId;
-(void)setPaymentMode:(NSString *)mode;

- (UIImage*)getImageFromCache:(NSString*)path;
- (IBAction)saveImageInCache:(UIImage*)image ImgName:(NSString*)name;
- (void)CameraClicked:(UIView*)view Control:(UIButton*)btn;
- (NSString *)encodeToBase64String:(UIImage *)image;
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
-(void)savePhotoToiPhoneGallery:(UIImage *)image;
-(NSArray*)getListOfImagesCaches:(NSString*)end;
-(NSString*)getPathofImageStoreInDevice;

-(void)CALLPhoneNumberProgrammatically:(NSString *)number;

-(void)errorFilledUpAllData;
-(void)errorCheckTermsCondition;
-(void)errorPasswordMismatch;
-(void)errorLoginFirst;

-(void)getDataWithBlokc:(OnComplate)block :(NSString*)strUrl data:(NSDictionary*)dictData;
-(void)getDataWithBlokc_GET:(OnComplate)block :(NSString*)strUrl;
-(void)getCountryList;
-(void)getStateList:(NSString*)countryId;
-(void)getCityList:(NSString*)stateId;


- (void)updateInterfaceWithReachability:(Reachability *)reachability;
-(void)sendSuccessTranscationToServer;
-(void)sendOTPToUser;

@end
