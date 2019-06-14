//
//  TaskAction.h
//  Tree
//
//  Created by 施威特 on 2017/12/13.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskAction : NSObject

@property (copy, nonatomic)NSString* Action;
@property (copy, nonatomic)NSNumber* TaskID;
@property (copy, nonatomic)NSNumber* UserID;
@property (copy, nonatomic)NSNumber* Decision;
@property (retain, nonatomic)NSMutableArray* ChosenResponserIDs; //[]*NSNumber;

-(NSDictionary*)GenerateTaskActionJsonDic;

@end
