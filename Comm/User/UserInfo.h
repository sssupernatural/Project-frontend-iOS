//
//  UserInfo.h
//  Tree
//
//  Created by 施威特 on 2017/11/20.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "AbisHeap.h"
#import "AFNetworking.h"

@interface UserInfo : NSObject

@property (copy, nonatomic) NSNumber* ID;
@property (copy, nonatomic) NSString* PhoneNumber;
@property (copy, nonatomic) NSString* Name;
@property (copy, nonatomic) NSNumber* Status;
@property (copy, nonatomic) NSNumber* Sex;
@property (copy, nonatomic) NSNumber* Age;
@property (retain, nonatomic) Location* CurLocation;
@property (retain, nonatomic) NSMutableArray* Locations; //[]*Location
@property (retain, nonatomic) NSMutableArray* LocationStrs; //[]*NSString
@property (retain, nonatomic) AbisHeap* Abilities;

+(UserInfo*)UserInfoWithJsonDic:(NSDictionary*)dic;

-(void)ResetUserInfoWithJsonDic:(NSDictionary*)dic;

-(void)print;

-(void)UpdateUserInfo;

-(NSString*)UserStatusStr;

-(NSString*)UserSexStr;

-(NSString*)UserAgeStr;

@end
