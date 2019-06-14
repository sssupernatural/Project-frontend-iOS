//
//  TaskBriefCell.m
//  Tree
//
//  Created by 施威特 on 2017/12/14.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "TaskBriefCell.h"
#import "UserInfo.h"
#import "../../../../Comm/Task/TaskStatus.h"

#define TaskType_RequesterTask          0
#define TaskType_ChosenResponserTask    1
#define TaskType_PotentialResponserTask 2
#define TaskType_ResponserTask          3


@implementation TaskBriefCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setResponserTaskCellWithTaskInfo:(TaskInfo*)info
{
    _LB_TaskBrief.text = info.Desc.Brief;
    _LB_UserType.text = @"发起的人";
    
    _LB_UserList.text = info.Requester.Name;
    
    if (info.Status.integerValue == TaskStatusWaitingAccept)
    {
        UIButton* btnCancelAccept = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCancelAccept.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
        [btnCancelAccept.layer setBorderWidth:1];
        [btnCancelAccept.layer setCornerRadius:4];
        [btnCancelAccept.layer setMasksToBounds:YES];
        [btnCancelAccept setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btnCancelAccept.frame = CGRectMake(297, 69, 68, 23);
        btnCancelAccept.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnCancelAccept setTitle:@"取消响应" forState:UIControlStateNormal];
        
        [self addSubview:btnCancelAccept];
    } else if (info.Status.integerValue == TaskStatusWaitingChoose)
    {
        UIButton* btnCancelAccept = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCancelAccept.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
        [btnCancelAccept.layer setBorderWidth:1];
        [btnCancelAccept.layer setCornerRadius:4];
        [btnCancelAccept.layer setMasksToBounds:YES];
        [btnCancelAccept setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btnCancelAccept.frame = CGRectMake(297, 69, 68, 23);
        btnCancelAccept.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnCancelAccept setTitle:@"取消响应" forState:UIControlStateNormal];
        
        [self addSubview:btnCancelAccept];
    }
}

-(void)setCellTag:(NSInteger)tag
{
    self.tag = tag;
}

@end
