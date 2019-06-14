//
//  TaskCreateInfo.m
//  Tree
//
//  Created by 施威特 on 2017/12/13.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "TaskCreateInfo.h"
#import "AppDelegate.h"
#import "Ability.h"
#import "AbisHeap.h"

@implementation TaskCreateInfo

+(TaskCreateInfo*)FakeTCInfo
{
    TaskCreateInfo* info = [[TaskCreateInfo alloc] init];
    
    info.RequesterID = [NSNumber numberWithInteger:1];

    info.Brief = @"最近在面试，面试过程中问到了一些Xcode常用的调试技巧问题。平常开发过程中用的还挺顺手的，但你要突然让我说，确实一脸懵逼。Debug的技巧很多，比如最常见的方式是打个Log，在一些工程中处处可见NSLog。还有就是打断点的Debug方式等。诸如此类，下面就自己在开发过程中常用的Xcode调试技巧简单的做个总结。最近在面试，面试过程中问到了一些Xcode常用的调试技巧问题。平常开发过程中用的还挺顺手的，但你要突然让我说，确实一脸懵逼。Debug的技巧很多，比如最常见的方式是打个Log，在一些工程中处处可见NSLog。还有就是打断点的Debug方式等。诸如此类，下面就自己在开发过程中常用的Xcode调试技巧简单的做个总结。最近在面试，面试过程中问到了一些Xcode常用的调试技巧问题。平常开发过程中用的还挺顺手的，但你要突然让我说，确实一脸懵逼。Debug的技巧很多，比如最常见的方式是打个Log，在一些工程中处处可见NSLog。还有就是打断点的Debug方式等。诸如此类，下面就自己在开发过程中常用的Xcode调试技巧简单的做个总结。";
     
    //info.Brief = @"5V5小场比赛";
    info.Sex = [NSNumber numberWithInteger:10003];
    info.AgeMin = [NSNumber numberWithInteger:18];
    info.AgeMax = [NSNumber numberWithInteger:30];
    info.TaskCreateTime = @"15:27  2018/1/04";
    info.TaskStartTime =  @"18:00  2018/1/04";
    info.TaskLocationDescStr = @"西体路西体足球场";
    info.LocationsDescStrs = [NSMutableArray arrayWithObjects:@"丽晶花园", @"人民公园", @"新城市广场", nil];
    //info.LocationsDescStrs = [NSMutableArray arrayWithObjects:@"丽晶花园", nil];
    
    Ability* sysAbis = [Ability systemAbilities];
    [sysAbis SetAllAbilitiesSelected];
    AbisHeap* sysAbisHeap = [sysAbis ConstructAbisHeap];
    info.Abilities = sysAbisHeap;
    
    NSLog(@"ID:%@", [[NSBundle mainBundle] bundleIdentifier]);
    info.ImportanceArray = [NSMutableArray arrayWithObjects:
                             [NSNumber numberWithInteger:28],
                             [NSNumber numberWithInteger:29],
                             [NSNumber numberWithInteger:7],
                             [NSNumber numberWithInteger:2],
                             nil];
    info.Locations = [[NSMutableArray alloc] init];
    return info;
}

-(NSDictionary*)GenerateCreateInfoJsonDic
{
    NSMutableDictionary* createTaskDic = [[NSMutableDictionary alloc] init];
    
    [createTaskDic setObject:self.RequesterID forKey:@"RequesterID"];
    [createTaskDic setObject:self.Brief forKey:@"Brief"];
    [createTaskDic setObject:self.Sex forKey:@"Sex"];
    [createTaskDic setObject:self.AgeMin forKey:@"AgeMin"];
    [createTaskDic setObject:self.AgeMax forKey:@"AgeMax"];
    [createTaskDic setObject:self.TaskCreateTime forKey:@"TaskCreateTime"];
    [createTaskDic setObject:self.TaskStartTime forKey:@"TaskStartTime"];
    [createTaskDic setObject:self.TaskLocationDescStr forKey:@"TaskLocationDescStr"];
    [createTaskDic setObject:@{
                               @"Longitude" : self.TaskLocation.Longitude,
                               @"Latitude" : self.TaskLocation.Latitude,
                               } forKey:@"TaskLocation"];
    
    [createTaskDic setObject:self.LocationsDescStrs forKey:@"LocationsDescStrs"];
    NSMutableArray* locsDescStrArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.Locations.count; i++)
    {
        Location* tmpLoc = (Location*)[self.Locations objectAtIndex:i];
        [locsDescStrArray addObject:@{
                                      @"Longitude" : tmpLoc.Longitude,
                                      @"Latitude" : tmpLoc.Latitude,
                                      }];
    }
    [createTaskDic setObject:locsDescStrArray forKey:@"Locations"];
    [createTaskDic setObject:@{
                               @"ABIs" : [self.Abilities AbisHeapJsonArray],
                               } forKey:@"Abilities"];
    [createTaskDic setObject:self.ImportanceArray forKey:@"ImportanceArray"];
    
    return createTaskDic;
}

+(TaskCreateInfo*)TaskCreateInfoFromJsonDic:(NSDictionary*)dic
{
    TaskCreateInfo* info = [[TaskCreateInfo alloc] init];
    
    info.RequesterID = dic[@"RequesterID"];
    info.Brief = dic[@"Brief"];
    info.Sex = dic[@"Sex"];
    info.AgeMin = dic[@"AgeMin"];
    info.AgeMax = dic[@"AgeMax"];
    info.TaskCreateTime = dic[@"TaskCreateTime"];
    info.TaskStartTime = dic[@"TaskStartTime"];
    info.TaskLocationDescStr = dic[@"TaskLocationDescStr"];
    info.TaskLocation = [Location LocationWithJsonDic:dic[@"TaskLocation"]];
    info.LocationsDescStrs = [NSMutableArray arrayWithArray:dic[@"LocationsDescStrs"]];
    info.Locations = [[NSMutableArray alloc] init];
    NSArray* locArray = dic[@"Locations"];
    for (NSDictionary* lDic in locArray)
    {
        [info.Locations addObject:[Location LocationWithJsonDic:lDic]];
    }
    info.Abilities = [AbisHeap AbisHeapWithJsonDic:dic[@"Abilities"]];
    info.ImportanceArray = [NSMutableArray arrayWithArray:dic[@"ImportanceArray"]];
    
    return info;
}

-(NSString*)AgeRequiredString
{
    NSString* ageR = [NSString stringWithFormat:@"%ld岁 - %ld岁", self.AgeMin.integerValue, self.AgeMax.integerValue];
    
    return ageR;
}

-(NSString*)SexRequiredString
{
    if (self.Sex.integerValue == 10003)
    {
        return @"男";
    } else if (self.Sex.integerValue == 10004)
    {
        return @"女";
    } else {
        return @"男或女";
    }
}

@end
