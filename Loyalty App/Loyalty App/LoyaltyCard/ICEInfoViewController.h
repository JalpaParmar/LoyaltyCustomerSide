//
//  ICEInfoViewController.h
//  Loyalty App
//
//  Created by Ntech Technologies on 8/13/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ICEInfoViewController : UIViewController <UITextViewDelegate>
{
    AppDelegate *app;
    NSString *countryID, *gender, *ICEMeditcationID, *ICECardId, *ICEID, *ICECompanyID, *MYIDStrDOB, *stateID;
    IBOutlet UIView *backgroundIndicatorView;
    IBOutlet UIActivityIndicatorView *actIndicatorView;
    IBOutlet UIPickerView *pickerBloodType;
    NSMutableArray *arrICEContactDetail, *arrICEIDCardDetail, *arrICEMeditcation, *arrCompanyDetail;
    NSArray *arrBloodType;
}
@property (nonatomic, assign) int flagForID;
@property (strong, nonatomic) IBOutlet UIView *viewMyIDCard;
@property (strong, nonatomic) IBOutlet UIView *viewCompanyID;
@property (strong, nonatomic) IBOutlet UIView *viewICEID;
@property (strong, nonatomic) IBOutlet UIView *viewDetail;
@property (strong, nonatomic) IBOutlet UIView *viewAddEditDetail;
@property (strong, nonatomic) IBOutlet UIButton *btnAddEdit;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIButton *btnViewMyId;
@property (strong, nonatomic) IBOutlet UIView *viewCompanyIDDetail;
@property (strong, nonatomic) IBOutlet UIView *viewCompanyAddEditDetail;
@property (strong, nonatomic) IBOutlet UIView *viewICEDetail;
@property (strong, nonatomic) IBOutlet UIView *viewICEAddContact;
@property (strong, nonatomic) IBOutlet UIButton *btnICESave, *btnICECancel;
//@property (strong, nonatomic) IBOutlet UITextView *txtCompanyAddress;
@property (strong, nonatomic) IBOutlet UITableView *tblviewICE;

@property (strong, nonatomic) IBOutlet UIView *viewICEMeditcationDetail;
@property (strong, nonatomic) IBOutlet UIView *viewICEMeditcationAddEdit;
@property (strong, nonatomic) IBOutlet UIButton *btnICEMeditcationSave, *btnICEMeditcationCancel;
@property (strong, nonatomic) IBOutlet UIView *subviewICEMeditcationAddEdit;

// MYIDCARD ADD/EDIT
@property (strong, nonatomic) IBOutlet UIView *viewCountry;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerCountry, *pickerCountryIpad;
@property (strong, nonatomic) IBOutlet UIButton *btnCountryDone;
@property (strong, nonatomic) IBOutlet UIButton *MYID_ADD_imgIcom;
@property (strong, nonatomic) IBOutlet UITextField *MYID_ADD_txtName;
@property (strong, nonatomic) IBOutlet UIButton *MYID_ADD_btnCountry, *MYID_ADD_btnState;
@property (strong, nonatomic) IBOutlet UITextField *MYID_ADD_txtSurname;
@property (strong, nonatomic) IBOutlet UITextField *MYID_ADD_txtFamilyName;
@property (strong, nonatomic) IBOutlet UITextField *MYID_ADD_txtparentName;
@property (strong, nonatomic) IBOutlet UIButton *MYID_ADD_btnDOB;
@property (strong, nonatomic) IBOutlet UITextField *MYID_ADD_txtPhoneno;
@property (strong, nonatomic) IBOutlet UITextField *MYID_ADD_IDNumber;
@property (strong, nonatomic) IBOutlet UIButton *MYID_ADD_btnMale, *MYID_ADD_btnOther;
@property (strong, nonatomic) IBOutlet UIButton *MYID_ADD_btnFemale;
@property (strong, nonatomic) IBOutlet UITextField *MYID_ADD_txtGivenName;
@property (strong, nonatomic) IBOutlet UIScrollView *MYID_ADD_scrollview;
@property (strong, nonatomic) IBOutlet UIButton *MYID_ADD_CountryLogo;

// MYIDCARD VIEW
@property (strong, nonatomic) IBOutlet UILabel *MYID_VIEW_lblCountry;
@property (strong, nonatomic) IBOutlet UILabel *MYID_VIEW_lblState;
@property (strong, nonatomic) IBOutlet UILabel *MYID_VIEW_lblIDName;
@property (strong, nonatomic) IBOutlet UILabel *MYID_VIEW_IDNumber;
@property (strong, nonatomic) IBOutlet UIButton *MYID_VIEW_btnprofilePic;
@property (strong, nonatomic) IBOutlet UILabel *MYID_VIEW_lblSurname;
@property (strong, nonatomic) IBOutlet UILabel *MYID_VIEW_lblGivenName;
@property (strong, nonatomic) IBOutlet UILabel *MYID_VIEW_lblFamilyname;
@property (strong, nonatomic) IBOutlet UILabel *MYID_VIEW_lblContactNumber;
@property (strong, nonatomic) IBOutlet UILabel *MYID_VIEW_ParentName;
@property (strong, nonatomic) IBOutlet UILabel *MYID_VIEW_DOB;
@property (strong, nonatomic) IBOutlet UILabel *MYID_VIEW_lblGender;
@property (strong, nonatomic) IBOutlet UIView *view_DOB;
@property (strong, nonatomic) IBOutlet UIDatePicker *picker_DOB;
@property (strong, nonatomic) IBOutlet UIButton *btnDoneDOB;






// ICE Contact
@property (strong, nonatomic) IBOutlet UITextField *ICECONTACT_name;
@property (strong, nonatomic) IBOutlet UITextField *ICECONTACT_phoneno;

//ICE Medictation View

@property (strong, nonatomic) IBOutlet UIView *subviewICEMedicaiton;
@property (strong, nonatomic) IBOutlet UILabel *ICEMEDITCATION_lblname;
@property (strong, nonatomic) IBOutlet UIButton *ICEMEDITCATION_btnprofilepic;
@property (strong, nonatomic) IBOutlet UILabel *ICEMEDITCATION_lblnumber;
@property (strong, nonatomic) IBOutlet UILabel *ICEMEDITCATION_lblbloodType;
@property (strong, nonatomic) IBOutlet UILabel *ICEMEDITCATION_lblalergise;
@property (strong, nonatomic) IBOutlet UILabel *ICEMEDITCATION_lblChronic;
@property (strong, nonatomic) IBOutlet UILabel *ICEMEDITCATION_lblContradication;
@property (strong, nonatomic) IBOutlet UILabel *ICEMEDITCATION_Label_alergise;
@property (strong, nonatomic) IBOutlet UILabel *ICEMEDITCATION_Label_chronic;
@property (strong, nonatomic) IBOutlet UILabel *ICEMEDITCATION_Label_contradication;
@property (strong, nonatomic) IBOutlet UIButton *ICEMEDITCATION_btnBg;
@property (strong, nonatomic) IBOutlet UIButton *ICEMEDITCATION_btnBgTop;


//ICE Medictation Add/Edit
@property (strong, nonatomic) IBOutlet UITextField *ICEMEDITCATION_Add_txtBloodType;
@property (strong, nonatomic) IBOutlet UIButton *ICEMEDITCATION_Add_btnBloodType;

@property (strong, nonatomic) IBOutlet UITextField *ICEMEDITCATION_Add_txtAllergies;
@property (strong, nonatomic) IBOutlet UITextField *ICEMEDITCATION_Add_txtChronic;
@property (strong, nonatomic) IBOutlet UITextField *ICEMEDITCATION_Add_txtContratication;


//ICE COMPANy Add/Edit
@property (strong, nonatomic) IBOutlet UIButton *COMPANY_btnCompanyLogo;
@property (strong, nonatomic) IBOutlet UITextField *COMPANY_txtCompanyName;
@property (strong, nonatomic) IBOutlet UITextField *COMPANY_txtIdNumber;
@property (strong, nonatomic) IBOutlet UITextField *COMPANY_txtPhoneNo;
@property (strong, nonatomic) IBOutlet UITextField *COMPANY_txtWebsite;
@property (strong, nonatomic) IBOutlet UITextField *COMPANY_txtvatNumber;
@property (strong, nonatomic) IBOutlet UITextField *COMPANY_txtPostalCode;
@property (strong, nonatomic) IBOutlet UITextView *COMPANY_txtAddress;
@property (strong, nonatomic) IBOutlet UIScrollView *COMPANY_scrollview;
@property (strong, nonatomic) IBOutlet UILabel *COMPANY_lblTakePhoto;

//ICE COMPANy VIEW
@property (strong, nonatomic) IBOutlet UILabel *COMPANY_VIEW_name;
@property (strong, nonatomic) IBOutlet UIImageView *COMPANY_VIEW_logo;
@property (strong, nonatomic) IBOutlet UILabel *COMPANY_VIEW_lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *COMPANY_VIEW_lblPostalCode;
@property (strong, nonatomic) IBOutlet UILabel *COMPANY_VIEW_lblIdNumber;
@property (strong, nonatomic) IBOutlet UILabel *COMPANY_VIEW_lblVatnumber;
@property (strong, nonatomic) IBOutlet UILabel *COMPANY_VIEW_lblPhoneNo;
@property (strong, nonatomic) IBOutlet UILabel *COMPANY_VIEW_lblWebsite;



- (IBAction)btnbackClick:(id)sender;
- (IBAction)btnMyIDClicked:(id)sender;
- (IBAction)btnCompanyIDCliked:(id)sender;
- (IBAction)btnICEIDClicked:(id)sender;
- (IBAction)btnAddEditClicked:(id)sender;
- (IBAction)btnViewMyIDClicked:(id)sender;
- (IBAction)btnSaveClicked:(id)sender;
- (IBAction)btnICESaveClicked:(id)sender;
- (IBAction)btnICEMeditcationSaveClicked:(id)sender;

- (IBAction)btnCountryClicked:(id)sender;
- (IBAction)btnCountryDoneClicked:(id)sender;
-(IBAction)btnMaleClicked;
-(IBAction)btnFemaleClicked;
-(void)setSelectedGenderButton:(UIButton *)radioButton;
//- (IBAction)MYIDImgIconClicked:(id)sender;

-(IBAction)companyLogoClicked:(id)sender;
-(IBAction)btnDoneDOBClicked:(id)sender;
- (IBAction)btnDOBClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleMyCard;

-(IBAction)ICECancelClicked:(id)sender;
-(IBAction)ICEMedictionCancelClicked:(id)sender;
-(IBAction)ICEMedictionBloodTypeClicked:(id)sender;

@end
