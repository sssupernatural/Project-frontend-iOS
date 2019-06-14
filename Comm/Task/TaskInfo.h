//
//  TaskInfo.h
//  Tree
//
//  Created by 施威特 on 2017/12/13.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskCreateInfo.h"
#import "UserInfo.h"

@interface TaskInfo : NSObject

@property (copy, nonatomic)NSNumber* ID;
@property (copy, nonatomic)NSNumber* Status;
@property (retain, nonatomic)TaskCreateInfo* Desc;
@property (retain, nonatomic)UserInfo* Requester;
@property (retain, nonatomic)NSMutableArray* ChosenResponser; //[]*UserInfo
@property (retain, nonatomic)NSMutableArray* FulfilStatus;    //[]*NSNumber
@property (retain, nonatomic)NSMutableArray* Responsers;      //[]*UserInfo 已经响应了的人

+(TaskInfo*)TaskInfoFromJsonDic:(NSDictionary*)dic;

+(TaskInfo*)FakeTInfo;

-(NSString*)StatusString;

@end
