//
//  Location.m
//  Tree
//
//  Created by 施威特 on 2017/11/20.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "Location.h"

@implementation Location

+(Location*)LocationWithJsonDic:(NSDictionary*)dic
{
    Location* location = [[Location alloc] init];
    
    location.Latitude = dic[@"latitude"];
    location.Longitude = dic[@"longitude"];
    
    return location;
}

-(void)ResetLocationWithJsonDic:(NSDictionary*)dic
{
    self.Latitude = dic[@"latitude"];
    self.Longitude = dic[@"longitude"];
}

+(Location*)LocationWithCLLocationCoordinate2D:(CLLocationCoordinate2D)pt
{
    Location* loc = [[Location alloc] init];
    loc.Latitude = [NSNumber numberWithDouble:pt.latitude];
    loc.Longitude = [NSNumber numberWithDouble:pt.longitude];
    
    return loc;
}

-(NSMutableDictionary*)LocationJsonDic
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:self.Latitude forKey:@"latitude"];
    [dic setObject:self.Longitude forKey:@"longitude"];
    
    return dic;
}

-(void)print
{
    NSLog(@"Location - longitude : %@, latitude : %@", self.Longitude, self.Latitude);
}

@end
