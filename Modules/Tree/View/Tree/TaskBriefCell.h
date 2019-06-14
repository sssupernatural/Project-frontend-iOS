//
//  TaskBriefCell.h
//  Tree
//
//  Created by 施威特 on 2017/12/14.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskInfo.h"
#import "TaskStatus.h"

@interface TaskBriefCell : UITableViewCell
@property (retain, nonatomic)TaskInfo* Info;
@property (strong, nonatomic) IBOutlet UILabel *LB_TaskBrief;
@property (strong, nonatomic) IBOutlet UILabel *LB_UserType;
@property (strong, nonatomic) IBOutlet UILabel *LB_UserList;

-(void)setCellTag:(NSInteger)tag;

@end
