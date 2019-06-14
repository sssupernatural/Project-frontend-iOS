//
//  UserAction.h
//  Tree
//
//  Created by 施威特 on 2017/11/20.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserCheckInfo.h"

@interface UserAction : NSObject

@property (copy, nonatomic) NSString* Action;
@property (retain, nonatomic) UserCheckInfo* CheckInfo;

@end
