//
//  MeLocationListController.h
//  Tree
//
//  Created by 施威特 on 2018/6/11.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"

@protocol MeLocationListDelegate <NSObject>

-(void)ChooseLocationWithKey:(NSString*)locKey andDistrict:(NSString*)locDis andCity:(NSString*)locCity andLoctionPT:(CLLocationCoordinate2D)pt;

@end

@interface MeLocationListController : UITableViewController

@property (nonatomic, weak)id<MeLocationListDelegate> delegate;

@property (assign, nonatomic)NSInteger locNumber;
@property (retain, nonatomic)NSArray* keyList;
@property (retain, nonatomic)NSArray* districtList;
@property (retain, nonatomic)NSArray* cityList;
@property (retain, nonatomic)NSArray* ptList;

@end

