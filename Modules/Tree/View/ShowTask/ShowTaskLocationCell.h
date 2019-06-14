//
//  ShowTaskLocationCell.h
//  Tree
//
//  Created by 施威特 on 2018/1/4.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskInfo.h"

@interface ShowTaskLocationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *LB_TaskLocation;

-(void)setWithTaskInfo:(TaskInfo*)task;

@end
