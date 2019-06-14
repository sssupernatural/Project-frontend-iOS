//
//  CreateTaskChooseSexController.h
//  Tree
//
//  Created by 施威特 on 2018/3/22.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCreateInfo.h"

@interface CreateTaskChooseSexController : UIViewController
@property (retain, nonatomic)TaskCreateInfo* CreateInfo;
@property (strong, nonatomic) IBOutlet UISegmentedControl *SC_ChooseSex;
@property (strong, nonatomic) IBOutlet UIButton *BTN_ConfirmSex;

@end
