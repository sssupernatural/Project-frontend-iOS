//
//  TaskAbilitiesCell.h
//  Tree
//
//  Created by 施威特 on 2017/12/14.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskInfo.h"

@interface TaskAbilitiesCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *Btn_MainAbi;
@property (strong, nonatomic) IBOutlet UIButton *Btn_FirstAbi;
@property (strong, nonatomic) IBOutlet UIButton *Btn_SecondAbi;
@property (strong, nonatomic) IBOutlet UIButton *Btn_TaskStatus;

-(void)setWithTaskInfo:(TaskInfo*)info;

-(void)setCellTag:(NSInteger)tag;

@end
