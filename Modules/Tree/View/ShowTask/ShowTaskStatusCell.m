//
//  ShowTaskStatusCell.m
//  Tree
//
//  Created by 施威特 on 2018/1/2.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import "ShowTaskStatusCell.h"
#import "TaskInfo.h"

@implementation ShowTaskStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setWithTaskInfo:(TaskInfo*)info
{
    _LB_TaskStatus.text = [info StatusString];
}


@end
