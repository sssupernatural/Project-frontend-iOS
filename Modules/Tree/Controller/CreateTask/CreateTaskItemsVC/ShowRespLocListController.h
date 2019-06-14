//
//  ShowRespLocListController.h
//  Tree
//
//  Created by 施威特 on 2018/4/4.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RespLocListDelegate <NSObject>

-(void)removeRespLoc:(NSInteger)index;

-(void)changeShowState;

@end

@interface ShowRespLocListController : UITableViewController

@property (nonatomic, weak)id<RespLocListDelegate> delegate;

@property (assign, nonatomic)BOOL showFlag;
@property (assign, nonatomic)NSInteger locNumber;
@property (retain, nonatomic)NSMutableArray* keyList;
@property (retain, nonatomic)NSMutableArray* districtList;
@property (retain, nonatomic)NSMutableArray* cityList;
@property (retain, nonatomic)NSMutableArray* ptList;

@end
