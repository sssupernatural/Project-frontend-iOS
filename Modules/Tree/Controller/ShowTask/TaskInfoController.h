//
//  TaskInfoController.h
//  Tree
//
//  Created by 施威特 on 2017/12/21.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TaskInfo.h"

@interface TaskInfoController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView* _TaskInfoTableView;
    
    TaskInfo* _task;
    NSInteger _taskActionStatus;
    
    NSMutableArray* _infoCellArray;
    NSMutableArray* _infoCellHeightArray;
    
    BOOL _showMoreBrief;
    BOOL _showMoreLocations;
    BOOL _showMoreResponsers;
    BOOL _showMoreChosenResponsers;
    
    NSInteger _briefIndex;
    NSInteger _locationsIndex;
    NSInteger _responsersIndex;
    BOOL _hasResponsersCell;
    
    NSMutableArray* _responsersInfo;
    
    AppDelegate* _delegate;
}

@property (strong, nonatomic) IBOutlet UIButton *Btn_CurAction;

-(void)ShowBrief;
-(void)ShowLocations;

@property (assign, nonatomic)NSInteger taskTag;

@end
