//
//  AbisHeap.h
//  Tree
//
//  Created by 施威特 on 2017/11/20.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbisHeap : NSObject

@property (retain, nonatomic) NSMutableArray* ABIs; //[]*AbiNode

-(NSMutableArray*)AbisEndNodeIndexes;

+(AbisHeap*)AbisHeapWithJsonDic:(NSDictionary*)dic;

-(void)ResetAbisHeapWithJsonDic:(NSDictionary*)dic;

-(NSMutableArray*)AbisHeapJsonArray;

-(NSMutableArray*)AbisStrArray;

-(void)print;

@end
