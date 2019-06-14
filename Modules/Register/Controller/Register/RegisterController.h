//
//  RegisterController.h
//  Tree
//
//  Created by 施威特 on 2017/11/14.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *TF_PhoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *TF_Username;
@property (strong, nonatomic) IBOutlet UITextField *TF_Password;
@property (strong, nonatomic) IBOutlet UITextField *TF_ConfirmPassword;
@property (strong, nonatomic) IBOutlet UIButton *Btn_Register;
@property (strong, nonatomic) IBOutlet UIButton *Btn_ReadNotice;
@property (strong, nonatomic) IBOutlet UIButton *Btn_backToLogin;

- (IBAction)backToLogin:(id)sender;
- (IBAction)userRegister:(id)sender;
- (IBAction)readNotice:(id)sender;

@end
