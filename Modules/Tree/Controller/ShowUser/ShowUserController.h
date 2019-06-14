//
//  ShowUserController.h
//  Tree
//
//  Created by 施威特 on 2018/1/23.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface ShowUserController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView* _userInfoTableView;
    
    NSInteger _numOfAbisInRow;
    NSInteger _abiWidth;
    NSInteger _abiHeight;
    NSInteger _wsp; //间隙宽度
    NSInteger _hsp; //间隙高度
    NSInteger _wn;  //能力项宽度/间隙宽度
    NSInteger _hn;  //能力项高度/间隙高度
    
    BOOL _showUserAbisAll;
}
@property (strong, nonatomic) IBOutlet UILabel *LB_UserName;
@property (strong, nonatomic) IBOutlet UIImageView *IV_UserPic;
@property (strong, nonatomic) IBOutlet UILabel *LB_UserScore;

@property (retain, nonatomic)UserInfo* userInfo;

@end
