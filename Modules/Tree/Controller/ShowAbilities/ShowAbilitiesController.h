//
//  ShowAbilitiesController.h
//  Tree
//
//  Created by 施威特 on 2017/12/22.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskInfo.h"

@interface ShowAbilitiesController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView* _abilitiesTableView;
    
    TaskInfo* _task;
    
    NSInteger _numOfAbisInRow;
    NSInteger _abiWidth;
    NSInteger _abiHeight;
    NSInteger _wsp; //间隙宽度
    NSInteger _hsp; //间隙高度
    NSInteger _wn;  //能力项宽度/间隙宽度
    NSInteger _hn;  //能力项高度/间隙高度
}

@property (assign, nonatomic)NSInteger taskTag;

@end
