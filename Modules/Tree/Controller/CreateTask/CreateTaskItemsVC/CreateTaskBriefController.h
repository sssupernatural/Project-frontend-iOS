//
//  CreateTaskBriefController.h
//  Tree
//
//  Created by 施威特 on 2018/3/13.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCreateInfo.h"

@interface CreateTaskBriefController : UIViewController

@property (retain, nonatomic)TaskCreateInfo* CreateInfo;
@property (strong, nonatomic) IBOutlet UITextView *TV_Brief;
@property (strong, nonatomic) IBOutlet UIButton *Btn_Confirm;

@end
