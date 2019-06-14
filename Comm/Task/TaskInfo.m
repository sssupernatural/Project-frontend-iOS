//
//  TaskInfo.m
//  Tree
//
//  Created by 施威特 on 2017/12/13.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "TaskInfo.h"
#import "TaskCreateInfo.h"
#import "AppDelegate.h"
#import "TaskStatus.h"

@implementation TaskInfo

+(TaskInfo*)FakeTInfo
{
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    TaskInfo* info = [[TaskInfo alloc] init];
    
    info.ID = [NSNumber numberWithInteger:1];
    info.Status = [NSNumber numberWithInteger:TaskStatusProcessing];
    info.Desc = [TaskCreateInfo FakeTCInfo];
    info.Requester = delegate.AppUserInfo;
    info.ChosenResponser = [[NSMutableArray alloc] init];
    info.FulfilStatus = [[NSMutableArray alloc] init];
    info.Responsers = [[NSMutableArray alloc] init];
    
    [info.Responsers addObject:delegate.AppUserInfo];
    //[info.Responsers addObject:delegate.AppUserInfo];
    //[info.Responsers addObject:delegate.AppUserInfo];
    
    [info.ChosenResponser addObject:delegate.AppUserInfo];
    [info.ChosenResponser addObject:delegate.AppUserInfo];
    [info.ChosenResponser addObject:delegate.AppUserInfo];
    
    return info;
}

-(NSString*)StatusString
{
    NSInteger s = [self.Status integerValue];
    switch (s) {
        case 11000:
            return @"活动创建中";
            break;
        case 11001:
            return @"等待响应者";
            break;
        case 11002:
            return @"选择响应者";
            break;
        case 11003:
            return @"活动进行中";
            break;
        case 11004:
            return @"活动已完成";
            break;
        case 11005:
            return @"活动已结束";
            break;
        case 11006:
            return @"查找响应者失败";
            break;
        case 11007:
            return @"没找到适合的人";
            break;
            
        default: return @"处理活动异常";
            break;
    }
    
    return nil;
}

+(TaskInfo*)TaskInfoFromJsonDic:(NSDictionary*)dic
{
    TaskInfo* info = [[TaskInfo alloc] init];
    info.ID = dic[@"ID"];
    info.Status = dic[@"Status"];
    info.Desc = [TaskCreateInfo TaskCreateInfoFromJsonDic:dic[@"Desc"]];
    info.Requester = [UserInfo UserInfoWithJsonDic:dic[@"Requester"]];
    info.ChosenResponser = [[NSMutableArray alloc] init];
    NSArray* cuiArray = dic[@"ChosenResponser"];
    for (NSDictionary* cuiDic in cuiArray)
    {
        [info.ChosenResponser addObject:[UserInfo UserInfoWithJsonDic:cuiDic]];
    }
    info.FulfilStatus = [NSMutableArray arrayWithArray:dic[@"FulfilStatus"]];
    info.Responsers = [[NSMutableArray alloc] init];
    NSArray* ruiArray = dic[@"Responsers"];
    for (NSDictionary* ruiDic in ruiArray)
    {
        [info.Responsers addObject:[UserInfo UserInfoWithJsonDic:ruiDic]];
    }
    
    return info;
}

@end
