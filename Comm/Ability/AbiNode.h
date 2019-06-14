//
//  AbiNode.h
//  Tree
//
//  Created by 施威特 on 2017/11/20.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbiNode : NSObject

@property (copy, nonatomic) NSString* ABI;
@property (copy, nonatomic) NSNumber* ParentIndex;
@property (copy, nonatomic) NSNumber* Experience;

+(AbiNode*)AbiNodeWithJsonDic:(NSDictionary*)dic;

-(void)ResetAbiNodeWithJsonDic:(NSDictionary*)dic;

-(NSDictionary*)AbiNodeJsonDic;

@end
