//
//  Location.h
//  Tree
//
//  Created by 施威特 on 2017/11/20.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"

@interface Location : NSObject

@property (copy, nonatomic) NSNumber* Longitude;
@property (copy, nonatomic) NSNumber* Latitude;

+(Location*)LocationWithCLLocationCoordinate2D:(CLLocationCoordinate2D)pt;

+(Location*)LocationWithJsonDic:(NSDictionary*)dic;

-(NSMutableDictionary*)LocationJsonDic;

-(void)ResetLocationWithJsonDic:(NSDictionary*)dic;

-(void)print;

@end
