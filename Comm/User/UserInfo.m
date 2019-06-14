//
//  UserInfo.m
//  Tree
//
//  Created by 施威特 on 2017/11/20.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "UserInfo.h"
#import "Location.h"
#import "AbisHeap.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

@implementation UserInfo

+(UserInfo*)UserInfoWithJsonDic:(NSDictionary*)dic
{
    UserInfo* u = [[UserInfo alloc] init];
    
    u.ID = dic[@"ID"];
    u.PhoneNumber = dic[@"PhoneNumber"];
    u.Name = dic[@"Name"];
    u.Status = dic[@"Status"];
    u.Sex = dic[@"Sex"];
    u.Age = dic[@"Age"];
    
    u.CurLocation = [Location LocationWithJsonDic:dic[@"CurLocation"]];
    u.Locations = [[NSMutableArray alloc] init];
    NSArray* locArray = dic[@"Locations"];
    for (NSDictionary* lDic in locArray)
    {
        [u.Locations addObject:[Location LocationWithJsonDic:lDic]];
    }
    u.LocationStrs = [NSMutableArray arrayWithArray:dic[@"LocationStrs"]];
    
    u.Abilities = [AbisHeap AbisHeapWithJsonDic:dic[@"Abilities"]];
    
    return u;
}

-(void)ResetUserInfoWithJsonDic:(NSDictionary*)dic
{
    self.ID = dic[@"ID"];
    self.PhoneNumber = dic[@"PhoneNumber"];
    self.Name = dic[@"Name"];
    self.Status = dic[@"Status"];
    self.Sex = dic[@"Sex"];
    self.Age = dic[@"Age"];
    
    [self.CurLocation ResetLocationWithJsonDic:dic[@"CurLocation"]];
    
    NSArray* locArray = dic[@"Locations"];
    unsigned long i = 0;
    unsigned long max = self.Locations.count;
    for (NSDictionary* lDic in locArray)
    {
        if (i < max)
        {
            Location* l = (Location*)[self.Locations objectAtIndex:i];
            [l ResetLocationWithJsonDic:lDic];
            i++;
        } else {
            [self.Locations addObject:[Location LocationWithJsonDic:lDic]];
        }
    }
    [self.LocationStrs removeAllObjects];
    NSArray* locStrsArray = dic[@"LocationStrs"];
    for (NSString* locStr in locStrsArray)
    {
        [self.LocationStrs addObject:locStr];
    }
    
    if (self.Abilities != nil && self.Abilities.ABIs != nil)
    {
        [self.Abilities ResetAbisHeapWithJsonDic:dic[@"Abilities"]];
    } else {
        self.Abilities = [AbisHeap AbisHeapWithJsonDic:dic[@"Abilities"]];
    }
}

-(void)UpdateUserInfo
{
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UserInfo* ui = delegate.AppUserInfo;
    
    NSMutableDictionary* infoDic = [[NSMutableDictionary alloc] init];
    
    [infoDic setObject:ui.ID forKey:@"ID"];
    [infoDic setObject:ui.PhoneNumber forKey:@"PhoneNumber"];
    [infoDic setObject:ui.Status forKey:@"Status"];
    if (ui.Name != nil && ![ui.Name isEqualToString:@""])
    {
        [infoDic setObject:ui.Name forKey:@"Name"];
    }
    if (ui.Sex != nil)
    {
        [infoDic setObject:ui.Sex forKey:@"Sex"];
    }
    if (ui.Age != nil)
    {
        [infoDic setObject:ui.Age forKey:@"Age"];
    }
    if (ui.Abilities != nil && ui.Abilities.ABIs != nil && ui.Abilities.ABIs.count != 0)
    {
        [infoDic setObject:@{
                             @"ABIs" : [ui.Abilities AbisHeapJsonArray],
                             } forKey:@"Abilities"];
    }
    
    if (ui.Locations != nil && ui.Locations.count != 0 &&
        ui.LocationStrs != nil && ui.LocationStrs.count == ui.Locations.count)
    {
        NSMutableArray* locDicArray = [[NSMutableArray alloc] init];
        
        for (Location* l in ui.Locations)
        {
            [locDicArray addObject:[l LocationJsonDic]];
        }
        
        [infoDic setObject:locDicArray forKey:@"Locations"];
        
        [infoDic setObject:ui.LocationStrs forKey:@"LocationStrs"];
    }
    
    
    NSData* infoData = [NSJSONSerialization dataWithJSONObject:infoDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString* userInfoURL = @CUR_SERVER_URL_USERINFO;
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest* updateUserInfoRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:userInfoURL parameters:nil error:nil];
    [updateUserInfoRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [updateUserInfoRequest setHTTPBody:infoData];
    
    AFHTTPResponseSerializer* respSerializer = [AFHTTPResponseSerializer serializer];
    respSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                             @"text/html",
                                             @"text/json",
                                             @"text/javascript",
                                             @"text/plain", nil];
    
    manager.responseSerializer = respSerializer;
    
    [[manager dataTaskWithRequest:updateUserInfoRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"err = %@!", error);
        } else {
            
            NSDictionary* respDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"dic = %@", respDic);
            
            
            AppDelegate* appDelegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
            
            if (appDelegate.AppUserInfo != nil)
            {
                [appDelegate.AppUserInfo ResetUserInfoWithJsonDic:respDic];
            } else {
                appDelegate.AppUserInfo = [UserInfo UserInfoWithJsonDic:respDic];
            }
            [appDelegate.AppUserInfo print];
        }
    }] resume];
}

-(NSString*)UserStatusStr
{
    switch (self.Status.integerValue) {
        case 10000:
            return @"在线";
            break;
        case 10001:
            return @"离线";
            break;
            
        default:
            break;
    }
    
    return @"离线";
}

-(NSString*)UserSexStr
{
    switch (self.Sex.integerValue) {
        case 10003:
            return @"男";
            break;
        case 10004:
            return @"女";
            break;
        case 10005:
            return @"谜";
            break;
            
            
        default:
            break;
    }
    
    return @"谜";
}

-(NSString*)UserAgeStr
{
    return self.Age.stringValue;
}

-(void)print
{
    NSLog(@"Print User Infomation : ");
    NSLog(@"ID : %@", self.ID);
    NSLog(@"PhoneNumber : %@", self.PhoneNumber);
    NSLog(@"Name : %@", self.Name);
    NSLog(@"Status : %@", self.Status);
    NSLog(@"Sex : %@", self.Sex);
    NSLog(@"Age : %@", self.Age);
    NSLog(@"Current Location : ");
    [self.CurLocation print];
    NSLog(@"Locations : ");
    for (Location* l in self.Locations)
    {
        [l print];
    }
    NSLog(@"Abis Heap : ");
    if (self.Abilities != nil)
    {
        NSLog(@"POS1");
        [self.Abilities print];
    }
}

@end
