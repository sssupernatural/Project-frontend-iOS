//
//  TreeController.h
//  Tree
//
//  Created by 施威特 on 2017/11/15.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TreeController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView* _UserTasksTableView;
    
    AppDelegate* _delegate;
    
    NSInteger _requesterTaskNum;
    NSInteger _chosenResponserTaskNum;
    NSInteger _potentialResponserTaskNum;
    NSInteger _responserTaskNum;
    
    NSInteger _requesterTaskSectionNum;
    NSInteger _chosenResponserTaskSectionNum;
    NSInteger _potentialResponserTaskSectionNum;
    NSInteger _responserTaskSectionNum;
    
    UIRefreshControl* _refreshControl;
}

@property (strong, nonatomic) IBOutlet UILabel *L_UserName;
@property (strong, nonatomic) IBOutlet UIImageView *IV_UserProfilePic;
@property (strong, nonatomic) IBOutlet UIButton *Btn_CreateTask;

@end
