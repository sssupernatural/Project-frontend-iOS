//
//  AbisHeap.m
//  Tree
//
//  Created by 施威特 on 2017/11/20.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "AbisHeap.h"
#import "AbiNode.h"

@implementation AbisHeap

+(AbisHeap*)AbisHeapWithJsonDic:(NSDictionary*)dic
{
    AbisHeap* abis = [[AbisHeap alloc] init];
    
    abis.ABIs = [[NSMutableArray alloc] init];
    
    NSArray* ABIsArray = dic[@"ABIs"];
    
    for (NSDictionary* abiDic in ABIsArray) {
        [abis.ABIs addObject:[AbiNode AbiNodeWithJsonDic:abiDic]];
    }
    
    return abis;
}


-(void)ResetAbisHeapWithJsonDic:(NSDictionary*)dic
{
    if (self.ABIs == nil)
    {
        NSLog(@"Error ! AbisHeap.ABIs Is nil, can't reset.");
        
        return;
    }
    
    NSArray* ABIsArray = dic[@"ABIs"];
    
    unsigned long i = 0;
    unsigned long max = self.ABIs.count;
    
    for (NSDictionary* abiDic in ABIsArray) {
        if (i < max)
        {
            AbiNode* a = (AbiNode*)[self.ABIs objectAtIndex:i];
            [a ResetAbiNodeWithJsonDic:abiDic];
            i++;
        } else {
            [self.ABIs addObject:[AbiNode AbiNodeWithJsonDic:abiDic]];
        }
    }
}

-(NSMutableArray*)AbisHeapJsonArray
{
    if (self.ABIs.count == 0)
    {
        return nil;
    }
    
    NSMutableArray* abiArray = [[NSMutableArray alloc] init];
    
    for(AbiNode* abi in self.ABIs)
    {
        NSDictionary* abiDic = [abi AbiNodeJsonDic];
        [abiArray addObject:abiDic];
    }
    
    return abiArray;
}

-(NSMutableArray*)AbisStrArray
{
    if (self.ABIs == nil)
    {
        return nil;
    }
    
    if(self.ABIs.count == 1)
    {
        AbiNode* first = [self.ABIs objectAtIndex:0];
        
        if ([first.ABI isEqualToString:@""] || first.ABI == nil)
        {
            return nil;
        }
    }
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for (AbiNode* abi in self.ABIs)
    {
        if (abi.ABI == nil)
        {
            [array addObject:@""];
        } else
        {
            [array addObject:abi.ABI];
        }
    }
    
    return array;
}

-(void)print
{
    int i = 0;
    if (self.ABIs != nil && self.ABIs.count != 0)
    {
        for (AbiNode* node in self.ABIs)
        {
            NSLog(@"index = %d, abi = %@, parentIndex = %@, experience = %@", i, node.ABI, node.ParentIndex, node.Experience);
            i++;
        }
    }
}

-(NSMutableArray*)AbisEndNodeIndexes
{
    NSMutableArray* parentBoolArray = [[NSMutableArray alloc] init];
    
    NSNumber* tagYES = [NSNumber numberWithBool:YES];
    NSNumber* tagNO = [NSNumber numberWithBool:NO];
    
    for (int i = 0; i < self.ABIs.count; i++)
    {
        [parentBoolArray addObject:tagNO];
    }
    
    for (int i = 0; i < self.ABIs.count; i++)
    {
        [parentBoolArray replaceObjectAtIndex:((AbiNode*)[self.ABIs objectAtIndex:i]).ParentIndex.unsignedIntegerValue withObject:tagYES];
    }
    
    NSMutableArray* endIndexesArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.ABIs.count; i++)
    {
        if (((NSNumber*)[parentBoolArray objectAtIndex:i]).boolValue == NO)
        {
            [endIndexesArray addObject:[NSNumber numberWithInteger:i]];
        }
    }
    
    return endIndexesArray;
}

@end
