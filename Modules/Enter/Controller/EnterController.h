//
//  EnterController.h
//  Tree
//
//  Created by 施威特 on 2017/11/14.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterController : UIViewController


@property (strong, nonatomic) IBOutlet UILabel *L_title;
@property (strong, nonatomic) IBOutlet UILabel *L_Username;
@property (strong, nonatomic) IBOutlet UILabel *L_Password;
@property (strong, nonatomic) IBOutlet UITextField *TF_PhoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *TF_Password;
@property (strong, nonatomic) IBOutlet UIButton *Btn_Login;
@property (strong, nonatomic) IBOutlet UIButton *Btn_Register;

- (IBAction)Login:(id)sender;
- (IBAction)Register:(id)sender;

@end
