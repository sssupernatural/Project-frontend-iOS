//
//  TaskAction.m
//  Tree
//
//  Created by 施威特 on 2017/12/13.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "TaskAction.h"

@implementation TaskAction

-(NSDictionary*)GenerateTaskActionJsonDic
{
    NSMutableDictionary* taskActionDic = [[NSMutableDictionary alloc] init];
    
    if (self.Action != nil)
    {
       [taskActionDic setObject:self.Action forKey:@"Action"];
    }
    
    if (self.TaskID != nil)
    {
        [taskActionDic setObject:self.TaskID forKey:@"TaskID"];
    }
    
    if (self.UserID != nil)
    {
        [taskActionDic setObject:self.UserID forKey:@"UserID"];
    }
    
    if (self.Decision != nil)
    {
        [taskActionDic setObject:self.Decision forKey:@"Decision"];
    }
    
    if (self.ChosenResponserIDs != nil)
    {
        [taskActionDic setObject:self.ChosenResponserIDs forKey:@"ChosenResponserIDs"];
    }

    return taskActionDic;
}

@end
