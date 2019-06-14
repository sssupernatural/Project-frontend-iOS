//
//  ChooseResponsersController.h
//  Tree
//
//  Created by 施威特 on 2018/5/10.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskInfo.h"

@interface ChooseResponsersController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView* _chooseResponsersTableView;
    NSMutableArray* _chooseIndexes;
}

@property (strong, nonatomic) IBOutlet UIButton *Btn_ConfirmResponsers;
@property (retain, nonatomic) TaskInfo* info;

@end
