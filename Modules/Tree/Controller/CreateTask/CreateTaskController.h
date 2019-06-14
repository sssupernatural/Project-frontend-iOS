//
//  CreateTaskController.h
//  Tree
//
//  Created by 施威特 on 2018/1/30.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCreateInfo.h"
#import "Ability.h"
#import "Location.h"
#import "CreateTaskAbilitiesController.h"

#define AbilityType_Main   10
#define AbilityType_First  11
#define AbilityType_Second 12
#define AbilityType_Other  13

@interface CreateTaskController : UIViewController<UITableViewDelegate, UITableViewDataSource, CreateTaskAbilitiesDelegate>
{
    UITableView* _createTaskItemsTableView;
    
    NSMutableArray* _createTaskItemCells;
    NSMutableArray* _createTaskItemCellHeights;
    
    TaskCreateInfo* _createTaskInfo;
    
    //Abilities Items
    NSInteger _abilitiesCellIndex;
    
    Ability* _mainAbilitySelecter;
    Ability* _curMainAbility;
    NSString* _mainAbilityStr;
    
    Ability* _firstAbilitySelecter;
    Ability* _curfirstAbility;
    NSString* _firstAbilityStr;
    
    Ability* _SecondAbilitySelecter;
    Ability* _curSecondAbility;
    NSString* _secondAbilityStr;
    
    Ability* _otherAbilitySelecter;
    NSMutableArray* _otherAbilitiesStr; //[]*NSSting;
    
    Ability* _createTaskAbilities;
    
    //Brief Item
    NSInteger _briefCellIndex;
    NSInteger _briefCellHeight;
    
    //TaskLocation Item
    NSInteger _taskLocationCellIndex;
    
    //TaskStartTime Items
    NSInteger _taskStartTimeCellIndex;
    
    //Task Responsers Locations Items
    NSInteger _rLocationsCellIndex;
    
    //Task Sex Items
    NSInteger _taskSexCellIndex;
    
    //Task Age Items
    NSNumber* _AgeConfirmed;
    NSInteger _taskAgeCellIndex;
}

@property (strong, nonatomic) IBOutlet UIButton *Btn_CreateTask;

@end
