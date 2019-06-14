//
//  ShowTaskTimeCell.h
//  Tree
//
//  Created by 施威特 on 2018/1/5.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskInfo.h"

@interface ShowTaskTimeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *LB_TimeTitle;
@property (strong, nonatomic) IBOutlet UILabel *LB_TimeValue;

-(void)setCreateTimeWithTaskInfo:(TaskInfo*)task;
-(void)setStartTimeWithTaskInfo:(TaskInfo*)task;

@end
