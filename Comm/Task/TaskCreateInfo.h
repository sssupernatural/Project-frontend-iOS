//
//  TaskCreateInfo.h
//  Tree
//
//  Created by 施威特 on 2017/12/13.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbisHeap.h"
#import "Location.h"

@interface TaskCreateInfo : NSObject

@property (copy, nonatomic)NSNumber* RequesterID;           //发起者ID
@property (copy, nonatomic)NSString* Brief;                 //活动简述
@property (copy, nonatomic)NSNumber* Sex;                   //活动响应者性别
@property (copy, nonatomic)NSNumber* AgeMin;                //活动响应者年龄最小值
@property (copy, nonatomic)NSNumber* AgeMax;                //活动响应者年龄最大值
@property (copy, nonatomic)NSString* TaskCreateTime;        //活动创建时间
@property (copy, nonatomic)NSString* TaskStartTime;         //活动开始时间
@property (copy, nonatomic)NSString* TaskLocationDescStr;   //活动地点描述（根据坐标获得）
@property (retain, nonatomic)Location* TaskLocation;        //活动地点坐标

@property (retain, nonatomic)NSMutableArray* LocationsDescStrs; //活动响应者坐标地点描述 []*NSString
@property (retain, nonatomic)NSMutableArray* Locations;     //活动响应者坐标组 []*Location
@property (retain, nonatomic)AbisHeap* Abilities;           //活动响应者的能力堆
@property (retain, nonatomic)NSMutableArray* ImportanceArray; //活动响应者的能力堆中的主要能力的索引 []*NSNumber

+(TaskCreateInfo*)FakeTCInfo;

-(NSString*)AgeRequiredString;

-(NSString*)SexRequiredString;

-(NSDictionary*)GenerateCreateInfoJsonDic;

+(TaskCreateInfo*)TaskCreateInfoFromJsonDic:(NSDictionary*)dic;

@end
