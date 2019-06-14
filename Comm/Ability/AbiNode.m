//
//  AbiNode.m
//  Tree
//
//  Created by 施威特 on 2017/11/20.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "AbiNode.h"

@implementation AbiNode

+(AbiNode*)AbiNodeWithJsonDic:(NSDictionary*)dic
{
    AbiNode* abiNode = [[AbiNode alloc] init];
    
    abiNode.ABI = [dic objectForKey:@"ABI"];
    abiNode.ParentIndex = [dic objectForKey:@"ParentIndex"];
    abiNode.Experience = [dic objectForKey:@"Experience"];
    
    return abiNode;
}

-(void)ResetAbiNodeWithJsonDic:(NSDictionary*)dic
{
    self.ABI = [dic objectForKey:@"ABI"];
    self.ParentIndex = [dic objectForKey:@"ParentIndex"];
    self.Experience = [dic objectForKey:@"Experience"];
}

-(NSMutableDictionary*)AbiNodeJsonDic
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    
    if (self.ABI != nil)
    {
        [dic setObject:self.ABI forKey:@"ABI"];
    }
    
    if (self.ParentIndex != nil)
    {
        [dic setObject:self.ParentIndex forKey:@"ParentIndex"];
    }
    
    if (self.Experience != nil)
    {
        [dic setObject:self.Experience forKey:@"Experience"];
    }
    
    return dic;
}

@end
