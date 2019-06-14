//
//  ShowTaskLocationCell.m
//  Tree
//
//  Created by 施威特 on 2018/1/4.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import "ShowTaskLocationCell.h"

@implementation ShowTaskLocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setWithTaskInfo:(TaskInfo*)task
{
    _LB_TaskLocation.text = task.Desc.TaskLocationDescStr;
}

@end
