//
//  MeEditAgeController.h
//  Tree
//
//  Created by 施威特 on 2017/12/6.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeEditAgeController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *PV_ChooseAge;
@property (assign, nonatomic) NSInteger Age;
@property (strong, nonatomic) IBOutlet UITextField *TF_Age;

@end
