//
//  CreateTaskStartTimeController.h
//  Tree
//
//  Created by 施威特 on 2018/3/21.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCreateInfo.h"

@interface CreateTaskStartTimeController : UIViewController
@property (retain, nonatomic)TaskCreateInfo* CreateInfo;
@property (strong, nonatomic) IBOutlet UIDatePicker *DP_StartTimePicker;
@property (strong, nonatomic) IBOutlet UIButton *Btn_ConfirmTime;

@end
