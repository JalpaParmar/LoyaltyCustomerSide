//
//  ReservationDetailViewController1.h
//  Loyalty App
//
//  Created by Ntech Technologies on 7/25/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface chatViewController : UIViewController <UITextFieldDelegate>
{
    AppDelegate *app;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    
    IBOutlet UITableView *tblChat;
    
    NSMutableArray *arrSelectTable;
    int indexId;
   
    //Chat Request
    IBOutlet UIButton *btnRestaurant;
    IBOutlet UIButton *btnChatRequest;
    IBOutlet UIPickerView *picker_allData;
    IBOutlet UIView *view_gettignPickerData;
    NSString  *strURL;
    
    NSString *anotherUserId;
    
    NSTimer *timer ;
    
    //Chat Accept
    NSString *chatId;
    
    
    //
    NSMutableArray	*arrChatList;
    IBOutlet UIButton *btnEnd;
    IBOutlet UIButton *btnSend;
    IBOutlet UITextField *txtMessage;
    IBOutlet UIScrollView *scrlPage;
    
    int flag_firstTime;
}
@property (strong, nonatomic) IBOutlet NSString *restaurantId;

- (IBAction)btnSendClicked:(id)sender;
- (IBAction)btnEndClicked:(id)sender;

- (IBAction)btnBackClick:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleReservation;

-(void)getChatIdAndStart;

////Chat Request
//- (IBAction)btnChatRequestClicked:(id)sender;
//- (IBAction)selectRestaurantInOfferView:(id)sender;
//

@end
