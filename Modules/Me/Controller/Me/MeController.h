//
//  MeController.h
//  Tree
//
//  Created by 施威特 on 2017/11/15.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface MeController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView* _MeInfoTableView;
    
    UserInfo* _AppUserInfo;
    
    NSMutableArray* _MeInfoCellArray;
    NSMutableArray* _MeInfoCellHeightArray;
    
    NSInteger _profilePicCellIndex;
    NSInteger _userNameCellIndex;
    NSInteger _userSexCellIndex;
    NSInteger _userAgeCellIndex;
    NSInteger _userLocationsCellIndex;
    NSInteger _userAbilitiesIndex;
    
}

@end
