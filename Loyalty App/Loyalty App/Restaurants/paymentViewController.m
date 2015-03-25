//
//  paymentViewController.m
//  Loyalty App
//
//  Created by Ntech Technologies on 7/23/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import "paymentViewController.h"
#import <QuartzCore/QuartzCore.h>


// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
// - For testing, use PayPalEnvironmentNoNetwork.
#define kPayPalEnvironment PayPalEnvironmentSandbox

@interface paymentViewController ()
@end

@implementation paymentViewController
@synthesize arrPayment;

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
    app._flagMainBtn = 0; //2;
    
    self.btnPayNow.layer.cornerRadius = 5.0;
    self.btnPayNow.clipsToBounds = YES;
    
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    
    // Setting the payPalShippingAddressOption property is optional.
    //
    // See PayPalConfiguration.h for details.
    
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    self.successView.hidden = YES;
    
    // use default environment, should be Production in real life
    self.environment = kPayPalEnvironment;
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    // Preconnect to PayPal early
    [self setPayPalEnvironment:self.environment];
}

- (void)setPayPalEnvironment:(NSString *)environment {
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}

- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setSelectedButton:(UIButton *)radioButton
{
    UIImage *Checkimage = [UIImage imageNamed:@"checked.png"];
    
    UIImage *Uncheckimage = [UIImage imageNamed:@"unchecked.png"];
    
    if(radioButton == self.radioButton1){
        [self.radioButton1 setBackgroundImage:Checkimage forState:UIControlStateNormal];
        [self.radioButton1 setBackgroundImage:Checkimage forState:UIControlStateSelected];
        [self.radioButton1 setBackgroundImage:Checkimage forState:UIControlStateHighlighted];
        self.radioButton1.adjustsImageWhenHighlighted = YES;
        
        [self.radioButton2 setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
       // [self.radioButton2 setBackgroundImage:Uncheckimage forState:UIControlStateSelected];
      //  [self.radioButton2 setBackgroundImage:Uncheckimage forState:UIControlStateHighlighted];
       // [self.radioButton2 setBackgroundImage:Uncheckimage forState:UIControlStateDisabled];
        
        [self.radioButton3 setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
       // [self.radioButton3 setBackgroundImage:Uncheckimage forState:UIControlStateDisabled];
       // [self.radioButton3 setBackgroundImage:Uncheckimage forState:UIControlStateHighlighted];
      //  [self.radioButton3 setBackgroundImage:Uncheckimage forState:UIControlStateSelected];
        
        self.radioButton1.enabled = NO;
        self.radioButton2.enabled = YES;
        self.radioButton3.enabled = YES;
        //selectedValue.text = label1.text;
        
    }
    else if(radioButton == self.radioButton2){
        [self.radioButton2 setBackgroundImage:Checkimage forState:UIControlStateNormal];
        [self.radioButton2 setBackgroundImage:Checkimage forState:UIControlStateSelected];
        [self.radioButton2 setBackgroundImage:Checkimage forState:UIControlStateHighlighted];
        self.radioButton2.adjustsImageWhenHighlighted = YES;
        
        [self.radioButton1 setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
      //  [self.radioButton1 setBackgroundImage:Uncheckimage forState:UIControlStateDisabled];
      //  [self.radioButton1 setBackgroundImage:Uncheckimage forState:UIControlStateHighlighted];
      //  [self.radioButton1 setBackgroundImage:Uncheckimage forState:UIControlStateSelected];
        
        [self.radioButton3 setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
       // [self.radioButton3 setBackgroundImage:Uncheckimage forState:UIControlStateDisabled];
        //[self.radioButton3 setBackgroundImage:Uncheckimage forState:UIControlStateHighlighted];
       // [self.radioButton3 setBackgroundImage:Uncheckimage forState:UIControlStateSelected];
        
        self.radioButton1.enabled = YES;
        self.radioButton2.enabled = NO;
        self.radioButton3.enabled = YES;
        //selectedValue.text = label2.text;
    }
    else
    {
        [self.radioButton3 setBackgroundImage:Checkimage forState:UIControlStateNormal];
        [self.radioButton3 setBackgroundImage:Checkimage forState:UIControlStateSelected];
        [self.radioButton3 setBackgroundImage:Checkimage forState:UIControlStateHighlighted];
        self.radioButton3.adjustsImageWhenHighlighted = YES;
        
        [self.radioButton2 setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
      //  [self.radioButton2 setBackgroundImage:Uncheckimage forState:UIControlStateSelected];
    //    [self.radioButton2 setBackgroundImage:Uncheckimage forState:UIControlStateHighlighted];
  //      [self.radioButton2 setBackgroundImage:Uncheckimage forState:UIControlStateDisabled];
        [self.radioButton1 setBackgroundImage:Uncheckimage forState:UIControlStateNormal];
    //    [self.radioButton1 setBackgroundImage:Uncheckimage forState:UIControlStateDisabled];
    //    [self.radioButton1 setBackgroundImage:Uncheckimage forState:UIControlStateHighlighted];
    //    [self.radioButton1 setBackgroundImage:Uncheckimage forState:UIControlStateSelected];
        
        self.radioButton1.enabled = YES;
        self.radioButton2.enabled = YES;
        self.radioButton3.enabled = NO;
        //selectedValue.text = label3.text;
    }
    
}

-(IBAction)radioButton1Selected{
    [self setSelectedButton:self.radioButton1];
}
-(IBAction)radioButton2Selected{
    [self setSelectedButton:self.radioButton2];
}
-(IBAction)radioButton3Selected{
    [self setSelectedButton:self.radioButton3];
}
#pragma mark - Receive Single Payment

-(IBAction)payNowClicked:(id)sender
{
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your Payment Received Successfully" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    [alert show];
    

        // Remove our last completed payment, just for demo purposes.
      //  self.resultText = nil;
        
        // Note: For purposes of illustration, this example shows a payment that includes
        //       both payment details (subtotal, shipping, tax) and multiple items.
        //       You would only specify these if appropriate to your situation.
        //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
        //       and simply set payment.amount to your total charge.
        
        // Optional: include multiple items
        PayPalItem *item1 = [PayPalItem itemWithName:@"Old jeans with holes"
                                        withQuantity:2
                                           withPrice:[NSDecimalNumber decimalNumberWithString:@"84.99"]
                                        withCurrency:@"USD"
                                             withSku:@"Hip-00037"];
        PayPalItem *item2 = [PayPalItem itemWithName:@"Free rainbow patch"
                                        withQuantity:1
                                           withPrice:[NSDecimalNumber decimalNumberWithString:@"0.00"]
                                        withCurrency:@"USD"
                                             withSku:@"Hip-00066"];
        PayPalItem *item3 = [PayPalItem itemWithName:@"Long-sleeve plaid shirt (mustache not included)"
                                        withQuantity:1
                                           withPrice:[NSDecimalNumber decimalNumberWithString:@"37.99"]
                                        withCurrency:@"USD"
                                             withSku:@"Hip-00291"];
        NSArray *items = @[item1, item2, item3];
        NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
        
        // Optional: include payment details
        NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"5.99"];
        NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"2.50"];
        PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal  withShipping:shipping   withTax:tax];
        
        NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
        
        PayPalPayment *payment = [[PayPalPayment alloc] init];
        payment.amount = total;
        payment.currencyCode = @"USD";
        payment.shortDescription = @"Hipster clothing";
        payment.items = items;  // if not including multiple items, then leave payment.items as nil
        payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
        
        if (!payment.processable) {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
        }
    
        self.acceptCreditCards = @"YES"; // extra
    
        // Update payPalConfig re accepting credit cards.
        self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
        
        PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment  configuration:self.payPalConfig  delegate:self];
        [self presentViewController:paymentViewController animated:YES completion:nil];
   
    
}
#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
    [self showSuccess];
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Helpers

- (void)showSuccess {
    self.successView.hidden = NO;
    self.successView.alpha = 1.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:2.0];
    self.successView.alpha = 0.0f;
    [UIView commitAnimations];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
