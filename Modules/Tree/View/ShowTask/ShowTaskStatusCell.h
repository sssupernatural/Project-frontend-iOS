//
//  ShowTaskStatusCell.h
//  Tree
//
//  Created by 施威特 on 2018/1/2.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskInfo.h"

@interface ShowTaskStatusCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *LB_TaskStatus;

-(void)setWithTaskInfo:(TaskInfo*)info;

@end
