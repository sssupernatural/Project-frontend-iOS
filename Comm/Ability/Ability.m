//
//  Ability.m
//  Tree
//
//  Created by 施威特 on 2017/11/29.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "Ability.h"
#import "AbisHeap.h"
#import "AbiNode.h"

@implementation Ability

+(Ability*)systemAbilities
{
    NSDictionary* abisDic = [Ability systemAbilitiesDic];
    
    Ability* systemAbis = [[Ability alloc] initWithAbiString:@""];
    
    systemAbis.parentAbi = nil;
    
    systemAbis.childrenAbilities = [Ability constructChildrenAbis:0 withAbisDic:abisDic andParentAbility:systemAbis];
    
    return systemAbis;
}

+(Ability*)UserAbilitiesWithAbisStrArray:(NSMutableArray*)array
{
    if (array == nil)
    {
        return [Ability systemAbilities];
    }
    
    NSDictionary* abisDic = [Ability systemAbilitiesDic];
    
    Ability* userAbis = [[Ability alloc] initWithAbiString:@""];
    
    userAbis.parentAbi = nil;
    
    userAbis.childrenAbilities = [Ability constructUserChildrenAbis:0 withAbisDic:abisDic andParentAbility:userAbis andUserAbisStrArray:array];
    
    return userAbis;
}

-(void)SelectParentAbis
{
    Ability* curAbility = self.parentAbi;
    
    while (curAbility != nil) {
        curAbility.selected = YES;
        curAbility = curAbility.parentAbi;
    }
}

-(BOOL)ChildAbiIsSelected
{
    if (self.childrenAbilities == nil)
    {
        return NO;
    }
    
    for (Ability* abi in self.childrenAbilities) {
        if (abi.selected == YES)
        {
            return YES;
        }
    }
    
    return NO;
}

-(void)CancelChildrenAbisSelect
{
    if (self.childrenAbilities == nil)
    {
        return;
    }
    
    for (Ability* child in self.childrenAbilities)
    {
        child.selected = NO;
        [child CancelChildrenAbisSelect];
    }
}

-(AbisHeap*)ConstructAbisHeap
{
    AbisHeap* heap = [[AbisHeap alloc] init];
    
    heap.ABIs = [[NSMutableArray alloc] init];
    
    [self addAbilityIntoHeapArray:heap.ABIs withParentIndex:nil];
    
    return heap;
}

-(void)addAbilityIntoHeapArray:(NSMutableArray*)heapArray withParentIndex:(NSNumber*)parentIndex
{
    AbiNode* abiNode = [[AbiNode alloc] init];
    
    abiNode.ABI = self.abiStr;
    abiNode.ParentIndex = parentIndex;
    abiNode.Experience = nil;
    
    NSNumber* pIndex = [NSNumber numberWithUnsignedInteger:heapArray.count];
    
    [heapArray insertObject:abiNode atIndex:heapArray.count];
    
    if (self.childrenAbilities == nil)
    {
        return;
    }
    
    for (Ability* abi in self.childrenAbilities)
    {
        if (abi.selected == YES)
        {
            [abi addAbilityIntoHeapArray:heapArray withParentIndex:pIndex];
        }
    }
}

-(void)SetAllAbilitiesSelected
{
    self.selected = YES;
    
    if (self.childrenAbilities == nil || self.childrenAbilities.count == 0)
    {
        return;
    }
    
    for (Ability* abi in self.childrenAbilities)
    {
        [abi SetAllAbilitiesSelected];
    }
    
    return;
}

-(BOOL)AbiInAbisStrArray:(NSMutableArray*)array
{
    if ([array containsObject:self.abiStr])
    {
        return YES;
    }
    
    return NO;
}

+(NSMutableArray*)constructUserChildrenAbis:(int)abiID withAbisDic:(NSDictionary*)abisDic andParentAbility:(Ability*)parentAbi andUserAbisStrArray:(NSMutableArray*)array
{
    NSMutableArray* childrenAbis = [[NSMutableArray alloc] init];
    
    NSString* parentAbiIDStr = nil;
    if (abiID == 0)
    {
        parentAbiIDStr = @"";
    } else
    {
        parentAbiIDStr = [NSString stringWithFormat:@"%d", abiID];
    }
    
    NSString* parentCompleteStr = nil;
    if (parentAbiIDStr.length % 2 == 0)
    {
        parentCompleteStr = @"";
    } else
    {
        parentCompleteStr = @"0";
    }
    
    for (int i = 1; i < 100; i++)
    {
        NSString* abiStr = [abisDic objectForKey:[NSString stringWithFormat:@"%d%@%@", i, parentCompleteStr, parentAbiIDStr]];
        if (abiStr != nil)
        {
            NSString* abiIDStr = [NSString stringWithFormat:@"%d%@%@", i, parentCompleteStr, parentAbiIDStr];
            Ability* abi = [[Ability alloc] initWithAbiString:abiStr];
            if ([abi AbiInAbisStrArray:array])
            {
                abi.selected = YES;
            }
            abi.childrenAbilities = [Ability constructUserChildrenAbis:[abiIDStr intValue] withAbisDic:abisDic andParentAbility:abi andUserAbisStrArray:array];
            abi.parentAbi = parentAbi;
            [childrenAbis addObject:abi];
        } else
        {
            break;
        }
    }
    
    if (childrenAbis.count == 0)
    {
        return nil;
    }
    
    return childrenAbis;
}

+(NSMutableArray*)constructChildrenAbis:(int)abiID withAbisDic:(NSDictionary*)abisDic andParentAbility:(Ability*)parentAbi
{
    NSMutableArray* childrenAbis = [[NSMutableArray alloc] init];
    
    NSString* parentAbiIDStr = nil;
    if (abiID == 0)
    {
        parentAbiIDStr = @"";
    } else
    {
        parentAbiIDStr = [NSString stringWithFormat:@"%d", abiID];
    }
    
    NSString* parentCompleteStr = nil;
    if (parentAbiIDStr.length % 2 == 0)
    {
        parentCompleteStr = @"";
    } else
    {
        parentCompleteStr = @"0";
    }
    
    for (int i = 1; i < 100; i++)
    {
        NSString* abiStr = [abisDic objectForKey:[NSString stringWithFormat:@"%d%@%@", i, parentCompleteStr, parentAbiIDStr]];
        if (abiStr != nil)
        {
            NSString* abiIDStr = [NSString stringWithFormat:@"%d%@%@", i, parentCompleteStr, parentAbiIDStr];
            Ability* abi = [[Ability alloc] initWithAbiString:abiStr];
            abi.childrenAbilities = [Ability constructChildrenAbis:[abiIDStr intValue] withAbisDic:abisDic andParentAbility:abi];
            abi.parentAbi = parentAbi;
            [childrenAbis addObject:abi];
        } else
        {
            break;
        }
    }
    
    if (childrenAbis.count == 0)
    {
        return nil;
    }
    
    return childrenAbis;
}


+(NSDictionary*)systemAbilitiesDic
{
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         
                         //娱乐大类
                         @"娱乐", @"1", @"KTV", @"101", @"桌游", @"201", @"密室逃脱", @"301",
                         @"真人CS", @"401", @"电脑游戏", @"501", @"手机游戏", @"601", @"看电影", @"701",
                         @"狼人杀", @"10201", @"三国杀", @"20201", @"麻将", @"30201", @"扑克", @"40201",
                         @"网络游戏", @"10501", @"单机游戏", @"20501", @"PUBG", @"1010501", @"DOTA2", @"2010501",
                         @"CSGO", @"3010501",
                         
                         //生活大类
                         @"生活", @"2", @"美食", @"102", @"交通", @"202", @"住宿", @"302",
                         @"衣装", @"402", @"宠物", @"502", @"火锅", @"10102", @"串串", @"20102",
                         @"川菜", @"30102", @"海鲜", @"40102", @"泰国菜", @"50102", @"面点", @"60102",
                         @"烧烤", @"70102", @"小龙虾", @"80102", @"短途车", @"10202", @"长途车", @"20202",
                         @"火车", @"30202", @"飞机", @"40202", @"短期住宿", @"10302", @"长期住宿", @"20302",
                         @"男装", @"10402", @"女装", @"20402", @"小孩衣装", @"30402", @"老人衣装", @"40402",
                         @"宠物猫", @"10502", @"宠物狗", @"20502", @"宠物猪", @"30502", @"观赏鱼", @"40502",
                         @"变色龙", @"50502", @"宠物鼠", @"60502",
                         
                         //职业大类
                         @"职业", @"3", @"IT", @"103", @"医药", @"203", @"通讯IT", @"10103",
                         @"游戏IT", @"20103", @"社交IT", @"30103", @"互联网前端", @"40103", @"互联网后台", @"50103",
                         @"医药销售", @"10203", @"医药管理", @"20203", @"医药生产", @"30203",
                         
                         //帮忙大类
                         @"帮忙", @"4", @"帮小忙", @"104", @"帮大忙", @"204",
                         
                         //旅游大类
                         @"旅游", @"5", @"国内游", @"105", @"境外游", @"205", @"成都旅游", @"10105",
                         @"上海旅游", @"20105", @"北京旅游", @"30105", @"拉萨旅游", @"40105", @"西安旅游", @"50105",
                         @"欧洲游", @"10205", @"亚洲游", @"20205", @"非洲游", @"30205", @"北美州游", @"40205",
                         @"澳洲游", @"50205", @"北极游", @"60205", @"南极游", @"70205",
                         
                         //运动大类
                         @"运动", @"6", @"跑步", @"106", @"球类运动", @"206", @"健身", @"306",
                         @"跑酷", @"406", @"滑板", @"506", @"自行车", @"606", @"拳击", @"706",
                         @"武术", @"806", @"足球", @"10206", @"篮球", @"20206", @"羽毛球", @"30206",
                         @"乒乓球", @"40206", @"排球", @"50206", @"网球", @"60206", @"台球", @"70206",
                         
                         nil];
    return dic;
}

//通过能力字符串查找该能力
-(Ability*)GetAbilityByAbiStr:(NSString*)abiStr withAbisDic:(NSDictionary*)abisDic
{
    NSMutableArray* childAbis = [self GetChildrenAbisByAbiStr:abiStr withAbisDic:abisDic];
    
    for (int i = 0; i < childAbis.count; i++)
    {
        Ability* curAbi = (Ability*)[childAbis objectAtIndex:i];
        
        if ([curAbi.abiStr isEqualToString:abiStr])
        {
            return curAbi;
        }
    }
    
    return nil;
}

//通过能力id查找该能力
-(Ability*)GetAbilityByID:(NSInteger)abiID withAbisDic:(NSDictionary*)abisDic;
{
    NSMutableArray* childAbis = [self GetChildrenAbisByID:abiID withAbisDic:abisDic];
    
    NSString* abiStr = [abisDic objectForKey:[NSString stringWithFormat:@"%ld", abiID]];
    
    for (int i = 0; i < childAbis.count; i++)
    {
        Ability* curAbi = (Ability*)[childAbis objectAtIndex:i];
        
        if ([curAbi.abiStr isEqualToString:abiStr])
        {
            return curAbi;
        }
    }
    
    return nil;
}

-(NSMutableArray*)GetChildrenAbisByAbiStr:(NSString*)abiStr withAbisDic:(NSDictionary*)abisDic
{
    static NSString* abiIDStr;
    
    [abisDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([((NSString*)obj) isEqualToString:abiStr]) {
            abiIDStr = [NSString stringWithString:((NSString*)key)];
            *stop = YES;
        }
    }];

    
    NSInteger ID = [abiIDStr integerValue];
    
    return [self GetChildrenAbisByID:ID withAbisDic:abisDic];
}

-(NSMutableArray*)GetChildrenAbisByID:(NSInteger)abiID withAbisDic:(NSDictionary*)abisDic
{
    NSInteger ys = 100;
    NSInteger curAbiID = abiID % ys;
    NSMutableArray* foundChildrenAbisArray = self.childrenAbilities;
    while (abiID / ys != 0)
    {
        NSString* abiStr = [abisDic objectForKey:[NSString stringWithFormat:@"%ld", curAbiID]];
        for (int i = 0; i < foundChildrenAbisArray.count; i++)
        {
            Ability* foundAbi = (Ability*)[foundChildrenAbisArray objectAtIndex:i];
            if ([foundAbi.abiStr isEqualToString:abiStr])
            {
                foundChildrenAbisArray = foundAbi.childrenAbilities;
                ys *= 100;
                curAbiID = abiID % ys;
                break;
            }
        }
    }
    
    return foundChildrenAbisArray;
    
}

-(Ability*)initWithAbiString:(NSString*)abiStr
{
    self.abiStr = abiStr;
    self.selected = false;
    self.childrenAbilities = nil;
    
    return self;
}


@end
