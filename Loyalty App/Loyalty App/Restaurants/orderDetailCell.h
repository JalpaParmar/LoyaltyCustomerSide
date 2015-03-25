//
//  RestaCell.h
//  Loyalty App
//
//  Created by Amit Parmar on 18/06/14.
//  Copyright (c) 2014 N-Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderDetailCell : UITableViewCell
{

}
@property (strong, nonatomic) IBOutlet UILabel *lblitemName;
@property (strong, nonatomic) IBOutlet UILabel *lblQty;
@property (strong, nonatomic) IBOutlet UILabel *lblprice;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscount;

@property (strong, nonatomic) IBOutlet UITextField *txtQty;
@property (strong, nonatomic) IBOutlet UIButton *btnBackClicked;

@property (strong, nonatomic) IBOutlet UIButton *btnArraw;
@property (strong, nonatomic) IBOutlet UIButton *btnRedeem;

@property (strong, nonatomic) IBOutlet UIButton *btn_Add_Qty;
@property (strong, nonatomic) IBOutlet UIButton *btn_Remove_Qty;



@end
