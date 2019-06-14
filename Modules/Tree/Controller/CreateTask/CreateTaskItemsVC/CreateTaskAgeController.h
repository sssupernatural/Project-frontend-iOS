//
//  CreateTaskAgeController.h
//  Tree
//
//  Created by 施威特 on 2018/3/22.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCreateInfo.h"

@interface CreateTaskAgeController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (retain, nonatomic)TaskCreateInfo* CreateInfo;
@property (strong, nonatomic) IBOutlet UIPickerView *PV_AgeMin;
@property (strong, nonatomic) IBOutlet UIPickerView *PV_AgeMax;
@property (strong, nonatomic) IBOutlet UILabel *LB_AgeMin;
@property (strong, nonatomic) IBOutlet UILabel *LB_AgeMax;
@property (strong, nonatomic) IBOutlet UIButton *Btn_ConfirmAge;

@end
