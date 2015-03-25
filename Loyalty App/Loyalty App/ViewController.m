//
//  ViewController.m
//  Loyalty App
//
//  Created by Amit Parmar on 17/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "ViewController.h"
#import "Login/LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DashboardView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Singleton.h"
#import "SBJSON.h"
#import "FbGraphFile.h"
#import <FacebookSDK/FacebookSDK.h>
#import "RestaurantView.h"
#import "HelpViewController.h"

@interface ViewController ()
@end 

@implementation ViewController
@synthesize fbGraph;
-(void)CallHelpTutorial:(id)object
{
    
    //First time app install
    NSUserDefaults *st1 = [NSUserDefaults standardUserDefaults];
    if([st1 objectForKey:@"FIRST_TIME"])
    {
        
    }
    else
    {
        [st1 setValue:@"1" forKey:@"FIRST_TIME"];
        if([[st1 objectForKey:@"FIRST_TIME"] intValue] == 1)
        {
            HelpViewController *payView;
            if (IS_IPHONE_5)
            {
                payView=[[HelpViewController alloc] initWithNibName:@"HelpViewController-5" bundle:nil];
            }
            else if (IS_IPAD)
            {
                payView=[[HelpViewController alloc] initWithNibName:@"HelpViewController_iPad" bundle:nil];
            }
            else
            {
                payView=[[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
            }
            [self.navigationController pushViewController:payView animated:YES];
            [st1 setValue:@"0" forKey:@"FIRST_TIME"];
        }
    }
}
-(void)hideSplash:(id)object
{
    UIImageView *animatedImageview = (UIImageView *)object;
    [animatedImageview removeFromSuperview];
    
}

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
    
    btnFBSubmit.layer.cornerRadius = 5.0;
    btnFBSubmit.clipsToBounds = YES;
    
    btnDOBDone.layer.cornerRadius = 5.0;
    btnDOBDone.clipsToBounds = YES;
        
    if(app._flagFromLogout == 0)
    {
        [UIView animateWithDuration:0 delay:0   options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionRepeat
                         animations:^{
                             
                             [UIView setAnimationRepeatCount:2]; // **This should appear in the beginning of the block**
                             
                             UIImageView *animatedSplashScreen  = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
                             
                             [self.view addSubview:animatedSplashScreen];
                             
                             //[UIImage imageNamed:@"splash-1536x2008-step1.png"],
                             //                         [UIImage imageNamed:@"splash-1536x2008-step2.png"],
                             animatedSplashScreen.animationImages= [NSArray arrayWithObjects:[UIImage imageNamed:@"splash-1536x2008-step3.png"],[UIImage imageNamed:@"splash-1536x2008-step4.png"], nil];
                             
                             animatedSplashScreen.animationRepeatCount=2;
                             animatedSplashScreen.animationDuration=3.0;
                             [animatedSplashScreen startAnimating];
                              [self performSelector:@selector(CallHelpTutorial:) withObject:animatedSplashScreen afterDelay:5.0];
                             [self performSelector:@selector(hideSplash:) withObject:animatedSplashScreen afterDelay:6.0];
                         }
                         completion:nil];
    }
   
 
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
   
    if([st objectForKey:@"DEVICE_TOKEN_ID"])
    {
        deviceToken = [st objectForKey:@"DEVICE_TOKEN_ID"];
    }
    if([[[Singleton sharedSingleton] ISNSSTRINGNULL:deviceToken] isEqualToString:@""])
    {
        deviceToken=@"9042510773dc4ed24d7afe7ca65f6d4aac615f5776a9dd18eabae78f6e0479cb";
    }

    
    self.btnEmailLogin.layer.cornerRadius = 5.0;
    self.btnEmailLogin.clipsToBounds = YES;
    
    self.btnFbLogin.layer.cornerRadius = 5.0;
    self.btnFbLogin.clipsToBounds = YES;
    
    self.btnRegister.layer.cornerRadius = 5.0;
    self.btnRegister.clipsToBounds = YES;
    
    //save "delete order " in prefernece
  //  NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    [st setObject:@"NO" forKey:@"IS_ORDER_START"];
    [st setObject:@"" forKey:@"OrderID"];
    [st synchronize];

    [[Singleton sharedSingleton] setFontFamily:@"OpenSans-Light" forView:self.view andSubViews:YES];
    
//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//        
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }
    
    if([st objectForKey:@"SEND_TO_SERVER"])
    {
        NSString* s = [st objectForKey:@"SEND_TO_SERVER"];
        if([s isEqualToString:@"false"])
        {
            [self performSelectorInBackground:@selector(sendDeviceTokenToServer) withObject:nil];
        }

    }
    
//    self.loginButton.delegate = self;
//    self.loginButton.readPermissions = @[@"public_profile", @"email"];
    
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated
{

}

- (void)sendDeviceTokenToServer
{
    [self.view endEditing:YES];
    if ([[Singleton sharedSingleton] connection]==0)
    {
        UIAlertView *altMsg=[[UIAlertView alloc] initWithTitle:ERROR_CONNECTION message:@"'" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [altMsg show];
    }
    else
    {
            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
            NSString *d=@"";
            if([st objectForKey:@"DEVICE_TOKEN_ID"])
            {
                d = [st objectForKey:@"DEVICE_TOKEN_ID"];
            }
            
            if(![d isEqualToString:@""])
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:@"IOS" forKey:@"DeviceSource"];
                [dict setValue:d forKey:@"DeviceId"];
                
                [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
                 {
                     NSLog(@" %@ -- ", dict);
                     
                     if (dict)
                     {
                         
                         Boolean strCode=[[dict objectForKey:@"code"] boolValue];
                         if (!strCode)
                         {
                             //                         UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                             //                         [alt show];
                         }
                         else
                         {
                             NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:[dict objectForKey:@"data"], nil];
                             NSString*dd = [[arr objectAtIndex:0] objectForKey:@"DeviceId"];
                             if(![dd isEqualToString:@""])
                             {
                                 NSString* s = [st objectForKey:@"SEND_TO_SERVER"];
                                 if([s isEqualToString:@"false"])
                                 {
                                     [st setObject:@"true" forKey:@"SEND_TO_SERVER"];
                                     [st synchronize];
                                 }
                             }
                        }
                     }
                     else
                     {
                         //                     UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         //                     [alt show];
                         
                     }
                 } :@"Data/Installed" data:dict];
            }
    }
}

-(IBAction)playVideo
{
    
    //----- PLAY THE MOVIE -----
	NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loyalty_video" ofType:@"mp4"]];
    
	MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(movieFinishedCallback:)
												 name:MPMoviePlayerPlaybackDidFinishNotification
											   object:moviePlayer];
    
	moviePlayer.controlStyle = MPMovieControlStyleDefault;
	moviePlayer.shouldAutoplay = YES;
	[self.view addSubview:moviePlayer.view];
	[moviePlayer setFullscreen:YES animated:YES];

}
- (void) movieFinishedCallback:(NSNotification*) aNotification
{
    MPMoviePlayerController *moviePlayer = [aNotification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMoviePlayerPlaybackDidFinishNotification
												  object:moviePlayer];
    
	NSLog(@"Movie playback finished");
    
	if ([moviePlayer
		 respondsToSelector:@selector(setFullscreen:animated:)])
	{
		[moviePlayer.view removeFromSuperview];
	}
} 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Button Click Event
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

#pragma mark LOGIN EMAIL
- (IBAction)btnLoginEmailClick:(id)sender
{
    app._skipRegister = 0;
    LoginViewController *loginView;
    if (IS_IPHONE_5)
    {
        loginView=[[LoginViewController alloc] initWithNibName:@"LoginViewController-5" bundle:nil];
    }
    else if (IS_IPAD)
    {
        loginView=[[LoginViewController alloc] initWithNibName:@"LoginViewController_iPad" bundle:nil];
    }
    else
    {
        loginView=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    }
    [self.navigationController pushViewController:loginView animated:YES];
}
#pragma mark SKIP
- (IBAction)btnSkipClick:(id)sender
{
    app._skipRegister = 1;
    [[Singleton sharedSingleton] resetAllArrayAndVariables];
    
    [self checkGPSCallViews];
}
#pragma mark LOGIN FACEBOOK
- (IBAction)btnLoginFBClick:(id)sender
{
    app._skipRegister = 0;
    app._flagFromLogout = 1;
    [[Singleton sharedSingleton] resetAllArrayAndVariables];
    
    [FBSession.activeSession close];
    [FBSession.activeSession  closeAndClearTokenInformation];
    FBSession.activeSession=nil;

    
    // ********************FACEBOOK SDK  *********************
    // [@"public_profile",@"email", @"user_birthday", @"user_hometown", @"user_location",@"user_relationship_details", @"user_friends"]
    
    @try {
        
  /*      [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if(FB_ISSESSIONOPENWITHSTATE(status)) {
                //do something
                [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error){
                        NSLog(@"success on first try");
                        
                         [self sessionStateChanged:session state:status error:error];
                        
                    } else if ([[error userInfo][FBErrorParsedJSONResponseKey][@"body"][@"error"][@"code"] compare:@190] == NSOrderedSame) {
                        //requestForMe failed due to error validating access token (code 190), so retry login
                        [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                            if (!error){
                                //do something again, or consider recursive call with a max retry count.
                                 [self sessionStateChanged:session state:status error:error];
                                NSLog(@"success on retry");
                            }
                        }];
                    }
                }];
            }
        }];
   */
        
        
      [FBSession openActiveSessionWithReadPermissions:@
         [@"public_profile",@"email", @"user_friends",@"user_birthday"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error)
         {
             if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed)
             {
                 [FBSession.activeSession close];
                 [FBSession.activeSession closeAndClearTokenInformation];
                 FBSession.activeSession=nil;
                 
                 NSUserDefaults *login=[NSUserDefaults standardUserDefaults];
                 [login removeObjectForKey:@"userEMail"];
                 [login removeObjectForKey:@"UserId"];
                 [login removeObjectForKey:@"userMobileNo"];
                 [login removeObjectForKey:@"userLastName"];
                 [login removeObjectForKey:@"userFirstName"];
             }
             
              if (error) {
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your current session is no longer valid. Please log in again." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                  [alert show];
              }
             else
             {
                  @try {
                      [self sessionStateChanged:session state:state error:error];
                  }
                 @catch (NSException *exception) {
                     NSLog(@"Error FB1 : %@", [exception description]);
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your current session is no longer valid. Please log in again." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 

             }
             
         }];

    }
    @catch (NSException *exception) {
        NSLog(@"Error FB : %@", [exception description]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your current session is no longer valid. Please log in again." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
   
    
    // ******************** GRAPH API  *********************
    
    
	/*Facebook Application ID*/
//	NSString *client_id = @"582622861841824"; //@"145634995501895"; //@"100007932766649"; //@"300936606768852";
////	NSString *client_id = @"130902823636657";
//  
//	//alloc and initalize our FbGraph instance
//	self.fbGraph = [[FbGraph alloc] initWithFbClientID:client_id];
//	
//	//begin the authentication process.....
//	[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
	
	/**
	 * OR you may wish to 'anchor' the login UIWebView to a window not at the root of your application...
	 * for example you may wish it to render/display inside a UITabBar view....
	 *
	 * Feel free to try both methods here, simply (un)comment out the appropriate one.....
	 **/
//		[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access" andSuperView:self.view];
    
}

#pragma mark FbGraph Callback Function
-(void)cancelFbLogin
{
    [backgroundIndicatorView removeFromSuperview];
    [actIndicatorView stopAnimating];
}
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    
    if (!error && state == FBSessionStateOpen)
    {
        //NSLog(@"Session opened");
//        [viewObj userLoggedIn];
//        [[Singleton sharedSingleton] setFacebookSession:@"open"];
         [self makeRequestForUserData];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed)
    {

        [FBSession.activeSession close];
        [FBSession.activeSession closeAndClearTokenInformation];
        FBSession.activeSession=nil;
        
        NSUserDefaults *login=[NSUserDefaults standardUserDefaults];
        [login removeObjectForKey:@"userEMail"];
        [login removeObjectForKey:@"UserId"];
        [login removeObjectForKey:@"userMobileNo"];
        [login removeObjectForKey:@"userLastName"];
        [login removeObjectForKey:@"userFirstName"];
        
        return;

    }
    
    // Handle errors
    if (error)
    {
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES)
        {
            [self cancelFbLogin];
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            //            [self showMessage:alertText withTitle:alertTitle];
        }
        else
        {
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled)
            {
                [self cancelFbLogin];
                //NSLog(@"User cancelled login");
            }
            else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession)
            {
                [self cancelFbLogin];
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                //                [self showMessage:alertText withTitle:alertTitle];
            }
            else
            {
                [self cancelFbLogin];
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                //                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
//        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI

    }
}
-(void)makeRequestForUserData
{
    [self.view addSubview:viewForLoader];
    [self startActivity];
   // __block NSDictionary *
    userData=[[NSDictionary alloc] init];
    
    //=id,name,picture,gender,bio,email, FirstName, LastName, birthday, timezone, access_token,hometown, location,relationship
    [FBRequestConnection startWithGraphPath:@"me?fields=id,name, email, first_name, last_name, gender, timezone,age_range,birthday"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              )
     {
         userData = (NSDictionary *)result;
         if(userData == nil)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to Login with Facebook" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];
             [self stopActivity];
             [viewForLoader removeFromSuperview];
         }
         else
         {
             NSUserDefaults *FacebookDefault=[NSUserDefaults standardUserDefaults];
             if (userData && [FacebookDefault objectForKey:@"FBid"]==nil)
             {
                 
                 //Store Facebook data in register table
                 //facebook_id,name, FirstName,LastName,email, gender,birthday, timezone, access_token, RegSource, hometown,location, relationship
                 
                 fbAccessToken = [FBSession activeSession].accessTokenData.accessToken;
                 NSDictionary *params;
                 
                 NSString *e = [userData objectForKeyedSubscript:@"email"];
                 if([[[Singleton sharedSingleton] ISNSSTRINGNULL:e] isEqualToString:@""])
                 {
                     params=@{ @"DeviceId" : deviceToken,  @"email":@"", @"RegSource":@"IOS",  @"facebook_id":[userData objectForKeyedSubscript:@"id"]
                               };
                 }
                 else
                 {
                     params=@{ @"DeviceId" : deviceToken,  @"email":[userData objectForKeyedSubscript:@"email"], @"RegSource":@"IOS",  @"facebook_id":[userData objectForKeyedSubscript:@"id"]
                               };
                 }
                
                
                 
                 [self checkFBUserAlreadyRegistered:params];
              
             }
         }
         /* handle the result */
     }];
    
}
#pragma mark - FBLoginView Delegate method implementation

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
 
    NSLog(@"Logged In");
}
-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    NSLog(@"%@", user);
    
}


-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
   
      NSLog(@"Logged Out");
   
}


-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
}
#pragma mark  ***
- (IBAction)btnFBDOBDoneClicked:(id)sender
{
    // date Picker
    NSDate *date=[pickerDOB date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMMM yyyy"];//yyyy-MM-dd
    [btnFBDOB setTitle:[NSString stringWithFormat:@" %@",[formatter stringFromDate:date]] forState:UIControlStateNormal];
  
    [viewPickerDOB removeFromSuperview];
}
- (IBAction)btnDOBClicked:(id)sender
{
    if(IS_IPAD)
    {
        viewPickerDOB.frame = CGRectMake(0, 200, viewPickerDOB.frame.size.width, viewPickerDOB.frame.size.height);
    }
    else if(IS_IPHONE_5)
    {
        viewPickerDOB.frame = CGRectMake(0, 100, viewPickerDOB.frame.size.width, viewPickerDOB.frame.size.height);
    }
    else
    {
        viewPickerDOB.frame = CGRectMake(0, 50, viewPickerDOB.frame.size.width, viewPickerDOB.frame.size.height);
    }
    
    [self.view addSubview:viewPickerDOB];
}
- (IBAction)hideParentView:(id)sender
{
    
    [btnBG removeFromSuperview];
    [viewFBData removeFromSuperview];
    [viewPickerDOB removeFromSuperview];
    
    [FBSession.activeSession close];
    [FBSession.activeSession closeAndClearTokenInformation];
    FBSession.activeSession=nil;
    
    NSUserDefaults *login=[NSUserDefaults standardUserDefaults];
    [login removeObjectForKey:@"userEMail"];
    [login removeObjectForKey:@"UserId"];
    [login removeObjectForKey:@"userMobileNo"];
    [login removeObjectForKey:@"userLastName"];
    [login removeObjectForKey:@"userFirstName"];
}


-(void)checkFBUserAlreadyRegistered:(NSDictionary*)params
{
    [self.view addSubview:viewForLoader];
    [self startActivity];
    
    [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
     {
         NSLog(@" %@ -- ", dict);
         
         if (dict)
         {
             [self stopActivity];
              //[self.view addSubview:viewForLoader];
             Boolean strCode=[[dict objectForKey:@"code"] boolValue];
             if (!strCode)
             {
                 
                 NSString *b = [userData objectForKeyedSubscript:@"birthday"];
                 if([[[Singleton sharedSingleton] ISNSSTRINGNULL:b] isEqualToString:@""])
                 {
                     
                     [self stopActivity];
                     [viewForLoader removeFromSuperview];
                     [self.view addSubview:btnBG];
                     if(IS_IPAD)
                     {
                         viewFBData.frame = CGRectMake(0, 200, viewFBData.frame.size.width, viewFBData.frame.size.height);
                     }
                     else if(IS_IPHONE_5)
                     {
                         viewFBData.frame = CGRectMake(0, 100, viewFBData.frame.size.width, viewFBData.frame.size.height);
                     }
                     else
                     {
                         viewFBData.frame = CGRectMake(0, 50, viewFBData.frame.size.width, viewFBData.frame.size.height);
                     }
                     [self.view addSubview:viewFBData];
                     
                     txtFBEmail.text=[userData objectForKeyedSubscript:@"email"];
                     txtFBFirstname.text=[userData objectForKeyedSubscript:@"first_name"];
                     txtFBLastname.text=[userData objectForKeyedSubscript:@"last_name"];
                 }
                 else
                 {
                     NSDictionary *params=@{ @"DeviceId" : deviceToken, @"name":[userData objectForKeyedSubscript:@"name"],
                                             @"FirstName":[userData objectForKeyedSubscript:@"first_name"], @"LastName":[userData objectForKeyedSubscript:@"last_name"],                                  @"email":[userData objectForKeyedSubscript:@"email"],
                                             @"gender":[userData objectForKeyedSubscript:@"gender"],
                                             @"timezone":[userData objectForKeyedSubscript:@"timezone"],
                                             @"RegSource":@"IOS",
                                             @"birthday":[userData objectForKeyedSubscript:@"birthday"],
                                             @"facebook_id":[userData objectForKeyedSubscript:@"id"],
                                             @"access_token":fbAccessToken
                                             };
                     [self callServiceForFBLogin:params];
                 }
             }
             else
             {
                 
                 NSUserDefaults *login=[NSUserDefaults standardUserDefaults];
                 [login setValue:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"FirstName"]]  forKey:@"userFirstName"];
                 [login setValue:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"LastName"] ] forKey:@"userLastName"];
                 [login setValue:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"MobileNo"]]  forKey:@"userMobileNo"];
                 [login setValue:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"UserId"] ] forKey:@"UserId"];
                 [login setValue:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"EMail"]]  forKey:@"userEMail"];
                  [login setValue:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"UfId"]]  forKey:@"UfId"];
                 [login synchronize];
                 
                 @try {
                     [[Singleton sharedSingleton] setstrLoginUserChat:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"Chat"]];
                 }
                 @catch (NSException *exception) {
                     [[Singleton sharedSingleton] setstrLoginUserChat:@"0"];
                 }
                [self checkGPSCallViews];
             }
         }
         else
         {
             UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alt show];
             [self stopActivity];
             [viewForLoader removeFromSuperview];
         }
     } :@"Login/CheckFaceBookLogin" data:params];
}
-(void)checkGPSCallViews
{
   // [viewForLoader removeFromSuperview];
    
     //Check Locaiton GPS Service Enabled/Disabled
    BOOL servicesEnabled = [CLLocationManager locationServicesEnabled];
    if(!servicesEnabled)
    {
        // open popup - country,state,city
        CommonDelegateViewController *join;
        if (IS_IPHONE_5)
        {
            join=[[CommonDelegateViewController alloc] initWithNibName:@"CommonDelegateViewController-5" bundle:nil];
        }
        else if (IS_IPAD)
        {
            join=[[CommonDelegateViewController alloc] initWithNibName:@"CommonDelegateViewController_iPad" bundle:nil];
        }
        else
        {
            join=[[CommonDelegateViewController alloc] initWithNibName:@"CommonDelegateViewController" bundle:nil];
        }
        join.delegate = self;
        [self.navigationController pushViewController:join animated:YES];
        
    }
    else
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
        [app.navObj pushViewController:dashBoard animated:YES];
    }
}

-(void)LocationSelectionDone:(NSMutableArray *)arrSelectionValue
{
    NSLog(@" *** LocationSelectionDone  called***");
    NSLog(@" *** arrSelectionValue : %@***", arrSelectionValue);
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

-(void)BackFromSelectionView
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userLocation"])
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
        [self.navigationController pushViewController:dashBoard animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your GPS is off" message:@"Please select area. This will make it much easier for you to find out Restaurant" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)btnFBSubmitClicked:(id)sender
{
    NSString *f = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@", txtFBFirstname.text]];
    NSString *l = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@", txtFBLastname.text]];
    NSString *e = [[Singleton sharedSingleton] ISNSSTRINGNULL:[NSString stringWithFormat:@"%@", txtFBEmail.text]];
    NSString *dob = [NSString stringWithFormat:@"%@", btnFBDOB.titleLabel.text];
    
    //check birth year -
    int age=0;
    
    if(![[[Singleton sharedSingleton] ISNSSTRINGNULL:dob] isEqualToString:@""] && ![dob isEqualToString:@"Select DOB"])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"dd MMMM yyyy";
        NSDate *date = [dateFormatter dateFromString:dob];
        // add this check and set
        if (date == nil) {
            date = [NSDate date];
        }
        dateFormatter.dateFormat = @"MMM d, yyyy";
        [pickerDOB setDate:date];
        
        NSDate *selectedDate1=[pickerDOB date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];//yyyy-MM-dd
        NSString *selectedYear = [NSString stringWithFormat:@"%@", [formatter stringFromDate:selectedDate1]];
        NSString *CurrentYear = [NSString stringWithFormat:@"%@", [formatter stringFromDate:[NSDate date]]];
        age = [CurrentYear intValue] - [selectedYear intValue];
        NSLog(@"Current Agr : %d", age);
    }

    
    if([f isEqualToString:@""] || [l isEqualToString:@""] || [e isEqualToString:@""] || [dob isEqualToString:@" Select DOB"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ERROR_EMPTY_DATA message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(age < 10)
    {
        UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"Minimum age should be 10 years" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alt show];
    }
    else
    {
        
        NSDictionary *params=@{ @"DeviceId" : deviceToken, @"name":[userData objectForKeyedSubscript:@"name"],
                                @"FirstName":[userData objectForKeyedSubscript:@"first_name"], @"LastName":[userData objectForKeyedSubscript:@"last_name"],                                  @"email":[userData objectForKeyedSubscript:@"email"],
                                @"gender":[userData objectForKeyedSubscript:@"gender"],
                                @"timezone":[userData objectForKeyedSubscript:@"timezone"],
                                @"RegSource":@"IOS",
                                @"birthday":dob,
                                @"facebook_id":[userData objectForKeyedSubscript:@"id"],
                                @"access_token":fbAccessToken
                                };
        [self callServiceForFBLogin:params];
        
    }
    
}
-(void)callServiceForFBLogin:(NSDictionary*)params
{
    [self.view addSubview:viewForLoader];
    [self startActivity];
    
    [[Singleton sharedSingleton] getDataWithBlokc:^(NSDictionary *dict)
     {
         NSLog(@" %@ -- ", dict);
         
         if (dict)
         {
            
             Boolean strCode=[[dict objectForKey:@"code"] boolValue];
             if (!strCode)
             {
                 [self stopActivity];
                 [viewForLoader removeFromSuperview];

                 if(![[dict objectForKey:@"message"] isEqualToString:@""])
                 {
                     UIAlertView *alt=[[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alt show];
                 }
             }
             else
             {
                 [self stopActivity];
                 //[viewForLoader removeFromSuperview];

                 NSUserDefaults *login=[NSUserDefaults standardUserDefaults];
                 [login setValue:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"FirstName"]]  forKey:@"userFirstName"];
                 [login setValue:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"LastName"] ] forKey:@"userLastName"];
                 [login setValue:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"MobileNo"]]  forKey:@"userMobileNo"];
                 [login setValue:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"UserId"] ] forKey:@"UserId"];
                 [login setValue:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"EMail"]]  forKey:@"userEMail"];
                [login setValue:[[Singleton sharedSingleton] ISNSSTRINGNULL:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"UfId"]]  forKey:@"UfId"];
                 [login synchronize];
                 
                 @try {
                     [[Singleton sharedSingleton] setstrLoginUserChat:[[[dict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"Chat"]];
                 }
                 @catch (NSException *exception) {
                     [[Singleton sharedSingleton] setstrLoginUserChat:@"0"];
                 }
                 [self checkGPSCallViews];
             }
         }
         else
         {
             UIAlertView *alt=[[UIAlertView alloc] initWithTitle:ERROR_MSG message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alt show];
             [self stopActivity];
             [viewForLoader removeFromSuperview];
         }
     } :@"Login/FaceBookLogin" data:params];
}

#pragma mark ROTATE
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
