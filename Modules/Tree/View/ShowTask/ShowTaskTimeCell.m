//
//  ShowTaskTimeCell.m
//  Tree
//
//  Created by 施威特 on 2018/1/5.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import "ShowTaskTimeCell.h"

@implementation ShowTaskTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCreateTimeWithTaskInfo:(TaskInfo*)task
{
    _LB_TimeTitle.text = @"创建时间";
    _LB_TimeValue.text = task.Desc.TaskCreateTime;
}

-(void)setStartTimeWithTaskInfo:(TaskInfo*)task
{
    _LB_TimeTitle.text = @"活动时间";
    _LB_TimeValue.text = task.Desc.TaskStartTime;
}

@end
