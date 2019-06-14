//
//  LocationListController.h
//  Tree
//
//  Created by 施威特 on 2018/3/30.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"

@protocol LocationListDelegate <NSObject>

-(void)ChooseLocationWithKey:(NSString*)locKey andDistrict:(NSString*)locDis andCity:(NSString*)locCity andLoctionPT:(CLLocationCoordinate2D)pt;

@end

@interface LocationListController : UITableViewController

@property (nonatomic, weak)id<LocationListDelegate> delegate;

@property (assign, nonatomic)NSInteger locNumber;
@property (retain, nonatomic)NSArray* keyList;
@property (retain, nonatomic)NSArray* districtList;
@property (retain, nonatomic)NSArray* cityList;
@property (retain, nonatomic)NSArray* ptList;

@end
