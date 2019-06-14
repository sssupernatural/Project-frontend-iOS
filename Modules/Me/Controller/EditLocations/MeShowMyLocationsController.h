//
//  MeShowMyLocationsController.h
//  Tree
//
//  Created by 施威特 on 2018/6/11.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MeShowMyLocListDelegate <NSObject>

-(void)removeMyLoc:(NSInteger)index;

-(void)changeShowState;

@end

@interface MeShowMyLocationsController : UITableViewController

@property (nonatomic, weak)id<MeShowMyLocListDelegate> delegate;

@property (assign, nonatomic)BOOL showFlag;
@property (assign, nonatomic)NSInteger locNumber;
@property (retain, nonatomic)NSMutableArray* keyList;
@property (retain, nonatomic)NSMutableArray* districtList;
@property (retain, nonatomic)NSMutableArray* cityList;
@property (retain, nonatomic)NSMutableArray* ptList;

@end
