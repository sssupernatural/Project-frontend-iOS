//
//  Ability.h
//  Tree
//
//  Created by 施威特 on 2017/11/29.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbisHeap.h"

@interface Ability : NSObject

@property (copy, nonatomic)NSString* abiStr;
@property (assign, nonatomic)BOOL selected;
@property (retain, nonatomic)NSMutableArray* childrenAbilities; //[]*Ability
@property (retain, nonatomic)Ability* parentAbi;

+(Ability*)systemAbilities;

+(Ability*)UserAbilitiesWithAbisStrArray:(NSMutableArray*)array;

//通过能力id查找该能力所在的子能力数组
-(NSMutableArray*)GetChildrenAbisByID:(NSInteger)abiID withAbisDic:(NSDictionary*)abisDic;

//通过能力字符串查找该能力所在的子能力数组
-(NSMutableArray*)GetChildrenAbisByAbiStr:(NSString*)abiStr withAbisDic:(NSDictionary*)abisDic;

//通过能力字符串查找该能力
-(Ability*)GetAbilityByAbiStr:(NSString*)abiStr withAbisDic:(NSDictionary*)abisDic;

//通过能力id查找该能力
-(Ability*)GetAbilityByID:(NSInteger)abiID withAbisDic:(NSDictionary*)abisDic;

-(void)SetAllAbilitiesSelected; 

-(void)SelectParentAbis;

-(BOOL)ChildAbiIsSelected;

-(void)CancelChildrenAbisSelect;

-(AbisHeap*)ConstructAbisHeap;

+(NSDictionary*)systemAbilitiesDic;

-(BOOL)AbiInAbisStrArray:(NSMutableArray*)array;


@end
