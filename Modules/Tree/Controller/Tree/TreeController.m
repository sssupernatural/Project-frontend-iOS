//
//  TreeController.m
//  Tree
//
//  Created by 施威特 on 2017/11/15.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "TreeController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "EnterController.h"
#import "NoRequesterTaskCell.h"
#import "NoChosenResponserCell.h"
#import "NoResponserTaskCell.h"
#import "NoPotentialResponserTaskCell.h"
#import "TaskBriefCell.h"
#import "TaskAbilitiesCell.h"
#import "TaskInfo.h"
#import "TaskAction.h"
#import "TaskInfoController.h"
#import "ShowAbilitiesController.h"
#import "TaskStatus.h"
#import "CreateTaskController.h"
#import "ChooseResponsersController.h"

#define TaskType_RequesterTask          0
#define TaskType_ChosenResponserTask    1
#define TaskType_PotentialResponserTask 2
#define TaskType_ResponserTask          3

#define AcceptTask 12001
#define RefuseTask 12002

@interface TreeController ()

@end

@implementation TreeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
    
    self.tabBarItem.title = @"Tree";
    
    _delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _L_UserName.text = _delegate.AppUserInfo.Name;
    
    _IV_UserProfilePic.image = [UIImage imageNamed:@"tree.jpeg"];
    
    [self.Btn_CreateTask.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
    [self.Btn_CreateTask.layer setBorderWidth:1];
    [self.Btn_CreateTask.layer setMasksToBounds:YES];
    [self.Btn_CreateTask setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [self.Btn_CreateTask addTarget:self action:@selector(createTask) forControlEvents:UIControlEventTouchUpInside];

    [self getTasksNum];
    
    _UserTasksTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+180, self.view.bounds.size.width, self.view.bounds.size.height-180) style:UITableViewStyleGrouped];
    
    _UserTasksTableView.showsHorizontalScrollIndicator = NO;
    _UserTasksTableView.showsVerticalScrollIndicator = NO;
    
    [_UserTasksTableView setBackgroundColor:[UIColor whiteColor]];
    
    //[_UserTasksTableView setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
    
    _UserTasksTableView.delegate = self;
    _UserTasksTableView.dataSource = self;
    
    [self setRefreshTasks];
    
    [self.view addSubview:_UserTasksTableView];
    [self.view addSubview:self.Btn_CreateTask];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    _delegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    
    _L_UserName.text = _delegate.AppUserInfo.Name;
    
    //_IV_UserProfilePic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tree.jpeg"]];
    
    _IV_UserProfilePic.image = [UIImage imageNamed:@"tree.jpeg"];
    
    [self QueryUserTasks];
}

-(void)createTask
{
    CreateTaskController* ct = [[CreateTaskController alloc] init];
    
    [self.navigationController pushViewController:ct animated:YES];
}

-(void)getTasksNum
{
    if (_delegate.RequesterTasks.count == 0)
    {
        _requesterTaskNum = 0;
        _requesterTaskSectionNum = 1;
    }else
    {
        _requesterTaskNum = _delegate.RequesterTasks.count;
        _requesterTaskSectionNum = _delegate.RequesterTasks.count;
    }
    
    if (_delegate.ChosenResponserTasks.count == 0)
    {
        _chosenResponserTaskNum = 0;
        _chosenResponserTaskSectionNum = 1;
    }else
    {
        _chosenResponserTaskNum = _delegate.ChosenResponserTasks.count;
        _chosenResponserTaskSectionNum = _delegate.ChosenResponserTasks.count;
    }
    
    if (_delegate.PotentialResponserTasks.count == 0)
    {
        _potentialResponserTaskNum = 0;
        _potentialResponserTaskSectionNum = 1;
    }else
    {
        _potentialResponserTaskNum = _delegate.PotentialResponserTasks.count;
        _potentialResponserTaskSectionNum = _delegate.PotentialResponserTasks.count;
    }
    
    if (_delegate.ResponserTasks.count == 0)
    {
        _responserTaskNum = 0;
        _responserTaskSectionNum = 1;
    }else
    {
        _responserTaskNum = _delegate.ResponserTasks.count;
        _responserTaskSectionNum = _delegate.ResponserTasks.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _requesterTaskSectionNum+_chosenResponserTaskSectionNum+_potentialResponserTaskSectionNum+_responserTaskSectionNum;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < _requesterTaskSectionNum)
    {
        if (_requesterTaskNum == 0)
        {
            return 1;
        } else
        {
            return 2;
        }
    }
    
    if (section >= _requesterTaskSectionNum && section < (_requesterTaskSectionNum+_chosenResponserTaskSectionNum))
    {
        if (_chosenResponserTaskNum == 0)
        {
            return 1;
        } else
        {
            return 2;
        }
    }
    
    if (section >= (_requesterTaskSectionNum+_chosenResponserTaskSectionNum) && section < (_chosenResponserTaskSectionNum+_requesterTaskSectionNum+_potentialResponserTaskSectionNum))
    {
        if (_potentialResponserTaskNum == 0)
        {
            return 1;
        } else
        {
            return 2;
        }
    }
    
    if (section >= (_requesterTaskSectionNum+_chosenResponserTaskSectionNum + _potentialResponserTaskSectionNum) && section < (_chosenResponserTaskSectionNum+_requesterTaskSectionNum+_potentialResponserTaskSectionNum + _responserTaskSectionNum))
    {
        if (_responserTaskNum == 0)
        {
            return 1;
        } else
        {
            return 2;
        }
    }
    
    return 2;
}

/*
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.backgroundColor = [UIColor clearColor];
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.backgroundColor = [UIColor clearColor];
}
 */

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section >= 0 && section < _requesterTaskSectionNum)
    {
        return @"发起的活动";
    }
    
    if (section >= _requesterTaskSectionNum && section < _requesterTaskSectionNum + _chosenResponserTaskSectionNum)
    {
        return @"参与的活动";
    }
    
    if (section >= _requesterTaskSectionNum + _chosenResponserTaskSectionNum && section < _requesterTaskSectionNum + _chosenResponserTaskSectionNum + _potentialResponserTaskSectionNum)
    {
        return @"等待响应的活动";
    }
    
    if (section >= _requesterTaskSectionNum + _chosenResponserTaskSectionNum + _potentialResponserTaskSectionNum && section < _requesterTaskSectionNum + _chosenResponserTaskSectionNum + _potentialResponserTaskSectionNum + _responserTaskSectionNum)
    {
        return @"已经响应的活动";
    }
    
    return nil;
}

/*
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];

    [footerView setBackgroundColor:[UIColor whiteColor]];
    
    return footerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 100)];
    
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    return headerView;
 
    if (section == 0)
    {
       UITableViewHeaderFooterView* headerView = [_UserTasksTableView headerViewForSection:0];
       
        UIButton* btnCreateTask = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        btnCreateTask.frame = CGRectMake(280, 0, 80, 40);
        
        btnCreateTask.titleLabel.text = @"发起活动";
        
        [btnCreateTask addTarget:self action:@selector(createTask) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView addSubview:btnCreateTask];
        
       return headerView;
    }
    
    return [_UserTasksTableView headerViewForSection:section];
 
}
*/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < _requesterTaskSectionNum)
    {
        if (_requesterTaskNum == 0)
        {
            NoRequesterTaskCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"NoRequesterTaskCell" owner:self options:nil] lastObject];
            
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
            
            cell.userInteractionEnabled = NO;
            
            return cell;
        } else
        {
            NSUInteger infoIndex = [self getTaskIndex:indexPath];
            NSInteger taskType = [self getTaskType:indexPath];
            NSInteger cellTag = [self generateTaskTagWithTaskIndex:infoIndex andTaskType:taskType];
            if (indexPath.row % 2 == 0)
            {
                TaskAbilitiesCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskAbilitiesCell" owner:self options:nil] lastObject];
                
                TaskInfo* info = [_delegate.RequesterTasks objectAtIndex:infoIndex];
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                [cell setCellTag:cellTag];
                
                [cell setWithTaskInfo:info];
                
                [cell.Btn_TaskStatus addTarget:self action:@selector(showTask:) forControlEvents:UIControlEventTouchUpInside];
                [cell.Btn_MainAbi addTarget:self action:@selector(showAbilities:) forControlEvents:UIControlEventTouchUpInside];
                [cell.Btn_SecondAbi addTarget:self action:@selector(showAbilities:) forControlEvents:UIControlEventTouchUpInside];
                [cell.Btn_FirstAbi addTarget:self action:@selector(showAbilities:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            } else
            {
                TaskBriefCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskBriefCell" owner:self options:nil] lastObject];
                
                TaskInfo* info = [_delegate.RequesterTasks objectAtIndex:infoIndex];
                
                cell.userInteractionEnabled = YES;
                
                [cell setCellTag:cellTag];
                
                [self setRequesterTaskBriefCell:cell WithTaskInfo:info];
                
                return cell;
            }
        }
    }
    
    if (indexPath.section >= _requesterTaskSectionNum && indexPath.section < (_requesterTaskSectionNum+_chosenResponserTaskSectionNum))
    {
        if (_chosenResponserTaskNum == 0)
        {
            NoChosenResponserCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"NoChosenResponserCell" owner:self options:nil] lastObject];
            
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
            
            cell.userInteractionEnabled = NO;
            
            return cell;
        } else
        {
            NSUInteger infoIndex = [self getTaskIndex:indexPath];
            NSInteger taskType = [self getTaskType:indexPath];
            NSInteger cellTag = [self generateTaskTagWithTaskIndex:infoIndex andTaskType:taskType];
            if (indexPath.row % 2 == 0)
            {
                TaskAbilitiesCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskAbilitiesCell" owner:self options:nil] lastObject];
                
                TaskInfo* info = [_delegate.ChosenResponserTasks objectAtIndex:infoIndex];
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                [cell setCellTag:cellTag];
                
                [cell setWithTaskInfo:info];
                
                [cell.Btn_TaskStatus addTarget:self action:@selector(showTask:) forControlEvents:UIControlEventTouchUpInside];
                [cell.Btn_MainAbi addTarget:self action:@selector(showAbilities:) forControlEvents:UIControlEventTouchUpInside];
                [cell.Btn_SecondAbi addTarget:self action:@selector(showAbilities:) forControlEvents:UIControlEventTouchUpInside];
                [cell.Btn_FirstAbi addTarget:self action:@selector(showAbilities:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            } else
            {
                TaskBriefCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskBriefCell" owner:self options:nil] lastObject];
                
                TaskInfo* info = [_delegate.ChosenResponserTasks objectAtIndex:infoIndex];
                
                cell.userInteractionEnabled = YES;
                
                [cell setCellTag:cellTag];
                
                [self setChosenResponserTaskBriefCell:cell WithTaskInfo:info];
                
                return cell;
            }
        }
    }
    
    if (indexPath.section >= (_requesterTaskSectionNum+_chosenResponserTaskSectionNum) && indexPath.section < (_chosenResponserTaskSectionNum+_requesterTaskSectionNum+_potentialResponserTaskSectionNum))
    {
        if (_potentialResponserTaskNum == 0)
        {
            NoPotentialResponserTaskCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"NoPotentialResponserTaskCell" owner:self options:nil] lastObject];
            
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
            
            cell.userInteractionEnabled = NO;
            
            return cell;
        } else
        {
            NSUInteger infoIndex = [self getTaskIndex:indexPath];
            NSInteger taskType = [self getTaskType:indexPath];
            NSInteger cellTag = [self generateTaskTagWithTaskIndex:infoIndex andTaskType:taskType];
            if (indexPath.row % 2 == 0)
            {
                TaskAbilitiesCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskAbilitiesCell" owner:self options:nil] lastObject];
                
                TaskInfo* info = [_delegate.PotentialResponserTasks objectAtIndex:infoIndex];
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                [cell setCellTag:cellTag];
                
                [cell setWithTaskInfo:info];
                
                [cell.Btn_TaskStatus addTarget:self action:@selector(showTask:) forControlEvents:UIControlEventTouchUpInside];
                [cell.Btn_MainAbi addTarget:self action:@selector(showAbilities:) forControlEvents:UIControlEventTouchUpInside];
                [cell.Btn_SecondAbi addTarget:self action:@selector(showAbilities:) forControlEvents:UIControlEventTouchUpInside];
                [cell.Btn_FirstAbi addTarget:self action:@selector(showAbilities:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            } else
            {
                TaskBriefCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskBriefCell" owner:self options:nil] lastObject];
                
                TaskInfo* info = [_delegate.PotentialResponserTasks objectAtIndex:infoIndex];
                
                cell.userInteractionEnabled = YES;
                
                [cell setCellTag:cellTag];
                
                [self setPotentialResponserTaskCell:cell WithTaskInfo:info];
                
                return cell;
            }
        }
    }
    
    if (indexPath.section >= (_requesterTaskSectionNum+_chosenResponserTaskSectionNum + _potentialResponserTaskSectionNum) && indexPath.section < (_chosenResponserTaskSectionNum+_requesterTaskSectionNum+_potentialResponserTaskSectionNum + _responserTaskSectionNum))
    {
        if (_responserTaskNum == 0)
        {
            NoResponserTaskCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"NoResponserTaskCell" owner:self options:nil] lastObject];
            
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
            
            cell.userInteractionEnabled = NO;
            
            return cell;
        } else
        {
            NSUInteger infoIndex = [self getTaskIndex:indexPath];
            NSInteger taskType = [self getTaskType:indexPath];
            NSInteger cellTag = [self generateTaskTagWithTaskIndex:infoIndex andTaskType:taskType];
            if (indexPath.row % 2 == 0)
            {
                TaskAbilitiesCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskAbilitiesCell" owner:self options:nil] lastObject];
                
                TaskInfo* info = [_delegate.ResponserTasks objectAtIndex:infoIndex];
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                [cell setCellTag:cellTag];
                
                [cell setWithTaskInfo:info];
                
                [cell.Btn_TaskStatus addTarget:self action:@selector(showTask:) forControlEvents:UIControlEventTouchUpInside];
                [cell.Btn_MainAbi addTarget:self action:@selector(showAbilities:) forControlEvents:UIControlEventTouchUpInside];
                [cell.Btn_SecondAbi addTarget:self action:@selector(showAbilities:) forControlEvents:UIControlEventTouchUpInside];
                [cell.Btn_FirstAbi addTarget:self action:@selector(showAbilities:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            } else
            {
                TaskBriefCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskBriefCell" owner:self options:nil] lastObject];
                
                TaskInfo* info = [_delegate.ResponserTasks objectAtIndex:infoIndex];
                
                cell.userInteractionEnabled = YES;
                
                [cell setCellTag:cellTag];
                
                [self setResponserTaskCell:cell WithTaskInfo:info];
                
                return cell;
            }
        }
    }
    
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger infoIndex = [self getTaskIndex:indexPath];
    NSInteger taskType = [self getTaskType:indexPath];
    NSInteger taskTag = [self generateTaskTagWithTaskIndex:infoIndex andTaskType:taskType];
    
    [self showTaskInfoView:taskTag];
}

/*
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* v = [[UIView alloc] init];
    v.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1];
    return v;
}
 */

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat taskAbisCellHeight = ((TaskAbilitiesCell*)[[[NSBundle mainBundle] loadNibNamed:@"TaskAbilitiesCell" owner:self options:nil] lastObject]).frame.size.height;
    CGFloat taskBriefCellHeight = ((TaskBriefCell*)[[[NSBundle mainBundle] loadNibNamed:@"TaskBriefCell" owner:self options:nil] lastObject]).frame.size.height;
    
    if (indexPath.section < _requesterTaskSectionNum)
    {
        if (_requesterTaskNum == 0)
        {
            return ((NoRequesterTaskCell*)[[[NSBundle mainBundle] loadNibNamed:@"NoRequesterTaskCell" owner:self options:nil] lastObject]).frame.size.height;
            
        } else
        {
            if (indexPath.row % 2 == 0)
            {
                return taskAbisCellHeight;
            } else
            {
                return taskBriefCellHeight;
            }
        }
    }
    
    if (indexPath.section >= _requesterTaskSectionNum && indexPath.section < (_requesterTaskSectionNum+_chosenResponserTaskSectionNum))
    {
        if (_chosenResponserTaskNum == 0)
        {
            return ((NoChosenResponserCell*)[[[NSBundle mainBundle] loadNibNamed:@"NoChosenResponserCell" owner:self options:nil] lastObject]).frame.size.height;
        } else
        {
            if (indexPath.row % 2 == 0)
            {
                return taskAbisCellHeight;
            } else
            {
                return taskBriefCellHeight;
            }
        }
    }
    
    if (indexPath.section >= (_requesterTaskSectionNum+_chosenResponserTaskSectionNum) && indexPath.section < (_chosenResponserTaskSectionNum+_requesterTaskSectionNum+_potentialResponserTaskSectionNum))
    {
        if (_potentialResponserTaskNum == 0)
        {
            return ((NoPotentialResponserTaskCell*)[[[NSBundle mainBundle] loadNibNamed:@"NoPotentialResponserTaskCell" owner:self options:nil] lastObject]).frame.size.height;
            
        } else
        {
            if (indexPath.row % 2 == 0)
            {
                return taskAbisCellHeight;
            } else
            {
                return taskBriefCellHeight;
            }
        }
    }
    
    if (indexPath.section >= (_requesterTaskSectionNum+_chosenResponserTaskSectionNum + _potentialResponserTaskSectionNum) && indexPath.section < (_chosenResponserTaskSectionNum+_requesterTaskSectionNum+_potentialResponserTaskSectionNum + _responserTaskSectionNum))
    {
        if (_responserTaskNum == 0)
        {
            return ((NoResponserTaskCell*)[[[NSBundle mainBundle] loadNibNamed:@"NoResponserTaskCell" owner:self options:nil] lastObject]).frame.size.height;
            
        } else
        {
            if (indexPath.row % 2 == 0)
            {
                return taskAbisCellHeight;
            } else
            {
                return taskBriefCellHeight;
            }
        }
    }
    
    return 100;
}

-(void)setRequesterTaskBriefCell:(TaskBriefCell*)cell WithTaskInfo:(TaskInfo*)info
{
    cell.LB_TaskBrief.text = info.Desc.Brief;
    NSMutableArray* respArray = nil;
    if ((info.Status.integerValue == TaskStatusWaitingAccept)
        || (info.Status.integerValue == TaskStatusWaitingChoose))
    {
        cell.LB_UserType.text = @"响应的人";
        respArray = info.Responsers;
    } else
    {
        cell.LB_UserType.text = @"参与的人";
        respArray = info.ChosenResponser;
    }
    
    if (respArray.count == 0)
    {
        cell.LB_UserList.text = @"0 人";
    } else
    {
        NSString* list = [NSString stringWithFormat:@"%lu 人 | ", respArray.count];
        
        if (respArray.count == 1)
        {
            UserInfo* u = (UserInfo*)[respArray objectAtIndex:0];
            list = [list stringByAppendingFormat:@"%@", u.Name];
        } else {
            for(int i = 0; i < respArray.count; i++)
            {
                UserInfo* u = (UserInfo*)[respArray objectAtIndex:i];
                if (i == (respArray.count - 1))
                {
                    list = [list stringByAppendingFormat:@"%@", u.Name];
                } else
                {
                    list = [list stringByAppendingFormat:@"%@、", u.Name];
                }
            }
        }
        
        cell.LB_UserList.text = list;
    }
    
    if (info.Status.integerValue == TaskStatusWaitingAccept)
    {
        UIButton* btnCancelTask = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCancelTask.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
        [btnCancelTask.layer setBorderWidth:1];
        [btnCancelTask.layer setCornerRadius:4];
        [btnCancelTask.layer setMasksToBounds:YES];
        [btnCancelTask setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btnCancelTask.frame = CGRectMake(297, 69, 68, 23);
        btnCancelTask.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnCancelTask setTitle:@"取消活动" forState:UIControlStateNormal];
        
        [cell addSubview:btnCancelTask];
    } else if (info.Status.integerValue == TaskStatusWaitingChoose)
    {
        UIButton* btnCancelTask = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCancelTask.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
        [btnCancelTask.layer setBorderWidth:1];
        [btnCancelTask.layer setCornerRadius:4];
        [btnCancelTask.layer setMasksToBounds:YES];
        [btnCancelTask setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btnCancelTask.frame = CGRectMake(297, 69, 68, 23);
        btnCancelTask.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnCancelTask setTitle:@"取消活动" forState:UIControlStateNormal];
        
        UIButton* btnChooseResponser = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnChooseResponser.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
        [btnChooseResponser.layer setBorderWidth:1];
        [btnChooseResponser.layer setCornerRadius:4];
        [btnChooseResponser.layer setMasksToBounds:YES];
        [btnChooseResponser setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btnChooseResponser.frame = CGRectMake(222, 69, 68, 23);
        btnChooseResponser.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnChooseResponser setTitle:@"选择响应者" forState:UIControlStateNormal];
        btnChooseResponser.tag = cell.tag;
        [btnChooseResponser addTarget:self action:@selector(actionChooseResponsers:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:btnCancelTask];
        [cell addSubview:btnChooseResponser];
    } else if (info.Status.integerValue == TaskStatusProcessing)
    {
        UIButton* btnCancelTask = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCancelTask.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
        [btnCancelTask.layer setBorderWidth:1];
        [btnCancelTask.layer setCornerRadius:4];
        [btnCancelTask.layer setMasksToBounds:YES];
        [btnCancelTask setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btnCancelTask.frame = CGRectMake(297, 69, 68, 23);
        btnCancelTask.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnCancelTask setTitle:@"取消活动" forState:UIControlStateNormal];
        
        [cell addSubview:btnCancelTask];
    } else if (info.Status.integerValue == TaskStatusFulfilled)
    {
        UIButton* btnEvaluate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnEvaluate.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
        [btnEvaluate.layer setBorderWidth:1];
        [btnEvaluate.layer setCornerRadius:4];
        [btnEvaluate.layer setMasksToBounds:YES];
        [btnEvaluate setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btnEvaluate.frame = CGRectMake(297, 69, 68, 23);
        btnEvaluate.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnEvaluate setTitle:@"评价" forState:UIControlStateNormal];
        
        [cell addSubview:btnEvaluate];
    }
}

-(void)actionChooseResponsers:(UIButton*)btn
{
    ChooseResponsersController* crc = [[ChooseResponsersController alloc] init];
    TaskInfo* info = [self getTaskInfoByTaskTag:btn.tag];
    crc.info = info;
    [self.navigationController pushViewController:crc animated:YES];
}

-(void)setChosenResponserTaskBriefCell:(TaskBriefCell*)cell WithTaskInfo:(TaskInfo*)info
{
    cell.LB_TaskBrief.text = info.Desc.Brief;
    cell.LB_UserType.text = @"发起的人";
    
    cell.LB_UserList.text = info.Requester.Name;
    
    if (info.Status.integerValue == TaskStatusProcessing)
    {
        UIButton* btnQuitTask = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnQuitTask.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
        [btnQuitTask.layer setBorderWidth:1];
        [btnQuitTask.layer setCornerRadius:4];
        [btnQuitTask.layer setMasksToBounds:YES];
        [btnQuitTask setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btnQuitTask.frame = CGRectMake(297, 69, 68, 23);
        btnQuitTask.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnQuitTask setTitle:@"退出活动" forState:UIControlStateNormal];
        
        UIButton* btnFulfilTask = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnFulfilTask.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
        [btnFulfilTask.layer setBorderWidth:1];
        [btnFulfilTask.layer setCornerRadius:4];
        [btnFulfilTask.layer setMasksToBounds:YES];
        [btnFulfilTask setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btnFulfilTask.frame = CGRectMake(222, 69, 68, 23);
        btnFulfilTask.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnFulfilTask setTitle:@"完成活动" forState:UIControlStateNormal];
        btnFulfilTask.tag = cell.tag;
        [btnFulfilTask addTarget:self action:@selector(chosenResponserTaskBtnFulfilTask:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:btnQuitTask];
        [cell addSubview:btnFulfilTask];
    }
    /*
    else if (info.Status.integerValue == TaskStatusFulfilled)
    {
        UIButton* btnEvaluate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnEvaluate.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
        [btnEvaluate.layer setBorderWidth:1];
        [btnEvaluate.layer setCornerRadius:4];
        [btnEvaluate.layer setMasksToBounds:YES];
        [btnEvaluate setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btnEvaluate.frame = CGRectMake(297, 69, 68, 23);
        btnEvaluate.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnEvaluate setTitle:@"评价" forState:UIControlStateNormal];
        
        [cell addSubview:btnEvaluate];
    }
     */
}

-(void)setPotentialResponserTaskCell:(TaskBriefCell*)cell WithTaskInfo:(TaskInfo*)info
{
    cell.LB_TaskBrief.text = info.Desc.Brief;
    cell.LB_UserType.text = @"发起的人";
    
    cell.LB_UserList.text = info.Requester.Name;
    
    if (info.Status.integerValue == TaskStatusWaitingAccept)
    {
        UIButton* btnRefuseTask = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnRefuseTask.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
        [btnRefuseTask.layer setBorderWidth:1];
        [btnRefuseTask.layer setCornerRadius:4];
        [btnRefuseTask.layer setMasksToBounds:YES];
        [btnRefuseTask setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btnRefuseTask.frame = CGRectMake(297, 69, 68, 23);
        btnRefuseTask.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnRefuseTask setTitle:@"拒绝活动" forState:UIControlStateNormal];
        btnRefuseTask.tag = cell.tag;
        [btnRefuseTask addTarget:self action:@selector(potentialResponserTaskBtnRefuseTask:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* btnAcceptTask = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnAcceptTask.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
        [btnAcceptTask.layer setBorderWidth:1];
        [btnAcceptTask.layer setCornerRadius:4];
        [btnAcceptTask.layer setMasksToBounds:YES];
        [btnAcceptTask setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btnAcceptTask.frame = CGRectMake(222, 69, 68, 23);
        btnAcceptTask.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnAcceptTask setTitle:@"参与活动" forState:UIControlStateNormal];
        btnAcceptTask.tag = cell.tag;
        [btnAcceptTask addTarget:self action:@selector(potentialResponserTaskBtnAcceptTask:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:btnRefuseTask];
        [cell addSubview:btnAcceptTask];
    }
}

-(void)setResponserTaskCell:(TaskBriefCell*)cell WithTaskInfo:(TaskInfo*)info
{
    cell.LB_TaskBrief.text = info.Desc.Brief;
    cell.LB_UserType.text = @"发起的人";
    
    cell.LB_UserList.text = info.Requester.Name;
    
    if (info.Status.integerValue == TaskStatusWaitingAccept)
    {
        UIButton* btnCancelAccept = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCancelAccept.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
        [btnCancelAccept.layer setBorderWidth:1];
        [btnCancelAccept.layer setCornerRadius:4];
        [btnCancelAccept.layer setMasksToBounds:YES];
        [btnCancelAccept setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btnCancelAccept.frame = CGRectMake(297, 69, 68, 23);
        btnCancelAccept.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnCancelAccept setTitle:@"取消响应" forState:UIControlStateNormal];
        
        [cell addSubview:btnCancelAccept];
    } else if (info.Status.integerValue == TaskStatusWaitingChoose)
    {
        UIButton* btnCancelAccept = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCancelAccept.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
        [btnCancelAccept.layer setBorderWidth:1];
        [btnCancelAccept.layer setCornerRadius:4];
        [btnCancelAccept.layer setMasksToBounds:YES];
        [btnCancelAccept setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btnCancelAccept.frame = CGRectMake(297, 69, 68, 23);
        btnCancelAccept.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnCancelAccept setTitle:@"取消响应" forState:UIControlStateNormal];
        
        [cell addSubview:btnCancelAccept];
    }
}

-(TaskInfo*)getTaskInfoByTaskTag:(NSInteger)tag
{
    NSInteger taskType = tag % 10;
    NSInteger taskIndex = (tag / 10) - 1;
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    switch (taskType) {
        case 1:
            return (TaskInfo*)[delegate.RequesterTasks objectAtIndex:taskIndex];
            break;
        case 2:
            return (TaskInfo*)[delegate.ChosenResponserTasks objectAtIndex:taskIndex];
            break;
        case 3:
            return (TaskInfo*)[delegate.PotentialResponserTasks objectAtIndex:taskIndex];
            break;
        case 4:
            return (TaskInfo*)[delegate.ResponserTasks objectAtIndex:taskIndex];
            break;
            
        default:
            break;
    }
    
    return nil;
}

-(void)requesterTaskBtnEvaluateTask:(UIButton*)btn
{
    TaskInfo* task = [self getTaskInfoByTaskTag:btn.tag];
    
    TaskAction* evaluateTask = [[TaskAction alloc] init];
    evaluateTask.Action = @"EVALUATE";
    evaluateTask.UserID = _delegate.AppUserInfo.ID;
    evaluateTask.TaskID = task.ID;
    NSDictionary* evaluateDic = [evaluateTask GenerateTaskActionJsonDic];
    
    NSLog(@"evaluate Tasks!");
    
    NSData* evaluateData = [NSJSONSerialization dataWithJSONObject:evaluateDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString* taskURL = @CUR_SERVER_URL_TASKS;
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest* evaluateTaskRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:taskURL parameters:nil error:nil];
    [evaluateTaskRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [evaluateTaskRequest setHTTPBody:evaluateData];
    
    AFHTTPResponseSerializer* respSerializer = [AFHTTPResponseSerializer serializer];
    respSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                             @"text/html",
                                             @"text/json",
                                             @"text/javascript",
                                             @"text/plain", nil];
    
    manager.responseSerializer = respSerializer;
    
    [[manager dataTaskWithRequest:evaluateTaskRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"err = %@!", error);
        } else {
            NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
            if (rsp.statusCode == 200)
            {
                [_delegate.RequesterTasks removeObject:task];
                
                [self performSelectorOnMainThread:@selector(reloadTasksView) withObject:nil waitUntilDone:nil];
            } else
            {
                NSLog(@"评价任务失败！");
            }
        }
    }] resume];
}

-(void)chosenResponserTaskBtnFulfilTask:(UIButton*)btn
{
    TaskInfo* task = [self getTaskInfoByTaskTag:btn.tag];
    
    TaskAction* fulfilTask = [[TaskAction alloc] init];
    fulfilTask.Action = @"FULFIL";
    fulfilTask.UserID = _delegate.AppUserInfo.ID;
    fulfilTask.TaskID = task.ID;
    NSDictionary* evaluateDic = [fulfilTask GenerateTaskActionJsonDic];
    
    NSLog(@"FULFIL Tasks!");
    
    NSData* fulfilData = [NSJSONSerialization dataWithJSONObject:evaluateDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString* taskURL = @CUR_SERVER_URL_TASKS;
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest* fulfilTaskRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:taskURL parameters:nil error:nil];
    [fulfilTaskRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [fulfilTaskRequest setHTTPBody:fulfilData];
    
    AFHTTPResponseSerializer* respSerializer = [AFHTTPResponseSerializer serializer];
    respSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                             @"text/html",
                                             @"text/json",
                                             @"text/javascript",
                                             @"text/plain", nil];
    
    manager.responseSerializer = respSerializer;
    
    [[manager dataTaskWithRequest:fulfilTaskRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"err = %@!", error);
        } else {
            NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
            if (rsp.statusCode == 200)
            {
                [self QueryUserTasks];
            } else
            {
                NSLog(@"评价任务失败！");
            }
        }
    }] resume];
}

-(void)potentialResponserTaskBtnAcceptTask:(UIButton*)btn
{
    TaskInfo* task = [self getTaskInfoByTaskTag:btn.tag];
    
    TaskAction* acceptTask = [[TaskAction alloc] init];
    acceptTask.Action = @"ACCEPT";
    acceptTask.UserID = _delegate.AppUserInfo.ID;
    acceptTask.TaskID = task.ID;
    acceptTask.Decision = [NSNumber numberWithInteger:AcceptTask];
    
    NSDictionary* acceptDic = [acceptTask GenerateTaskActionJsonDic];
    
    NSLog(@"accept Tasks!");
    
    NSData* acceptData = [NSJSONSerialization dataWithJSONObject:acceptDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString* taskURL = @CUR_SERVER_URL_TASKS;
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest* acceptTaskRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:taskURL parameters:nil error:nil];
    [acceptTaskRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [acceptTaskRequest setHTTPBody:acceptData];
    
    AFHTTPResponseSerializer* respSerializer = [AFHTTPResponseSerializer serializer];
    respSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                             @"text/html",
                                             @"text/json",
                                             @"text/javascript",
                                             @"text/plain", nil];
    
    manager.responseSerializer = respSerializer;
    
    [[manager dataTaskWithRequest:acceptTaskRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"err = %@!", error);
        } else {
            NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
            if (rsp.statusCode == 200)
            {
                [_delegate.PotentialResponserTasks removeObject:task];
                [self QueryUserTasks];
            } else
            {
                NSLog(@"接受任务失败！");
            }
        }
    }] resume];
}

-(void)potentialResponserTaskBtnRefuseTask:(UIButton*)btn
{
    TaskInfo* task = [self getTaskInfoByTaskTag:btn.tag];
    
    TaskAction* refuseTask = [[TaskAction alloc] init];
    refuseTask.Action = @"ACCEPT";
    refuseTask.UserID = _delegate.AppUserInfo.ID;
    refuseTask.TaskID = task.ID;
    refuseTask.Decision = [NSNumber numberWithInteger:RefuseTask];
    
    NSDictionary* refuseDic = [refuseTask GenerateTaskActionJsonDic];
    
    NSLog(@"refuse Tasks!");
    
    NSData* refuseData = [NSJSONSerialization dataWithJSONObject:refuseDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString* taskURL = @CUR_SERVER_URL_TASKS;
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest* refuseTaskRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:taskURL parameters:nil error:nil];
    [refuseTaskRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [refuseTaskRequest setHTTPBody:refuseData];
    
    AFHTTPResponseSerializer* respSerializer = [AFHTTPResponseSerializer serializer];
    respSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                             @"text/html",
                                             @"text/json",
                                             @"text/javascript",
                                             @"text/plain", nil];
    
    manager.responseSerializer = respSerializer;
    
    [[manager dataTaskWithRequest:refuseTaskRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"err = %@!", error);
        } else {
            NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
            if (rsp.statusCode == 200)
            {
                [_delegate.PotentialResponserTasks removeObject:task];
                
                [self performSelectorOnMainThread:@selector(reloadTasksView) withObject:nil waitUntilDone:nil];
            } else
            {
                NSLog(@"拒绝任务失败！");
            }
        }
    }] resume];
}


-(void)showAbilities:(UIButton*)btn
{
    [self showAbilitiesView:btn.tag];
}

-(void)showAbilitiesView:(NSInteger)taskTag
{
    NSInteger type = taskTag % 10;
    NSString* str;
    switch (type) {
        case 1:
            str = @"能力信息 - 发起的任务 : ";
            break;
        case 2:
            str = @"能力信息 - 参与的任务 : ";
            break;
        case 3:
            str = @"能力信息 - 等待响应的任务 : ";
            break;
        case 4:
            str = @"能力信息 - 已经响应的任务 : ";
            break;
        default:
            break;
    }
    
    NSInteger index = (taskTag / 10) - 1;
    
    str = [str stringByAppendingFormat:@"第 %ld 个任务.", index];
    
    NSLog(@"%@", str);
    
    ShowAbilitiesController* sa = [[ShowAbilitiesController alloc] init];
    
    sa.navigationItem.title = @"";
    
    sa.taskTag = taskTag;
    
    [self.navigationController pushViewController:sa animated:YES];
}

-(void)showTask:(UIButton*)btn
{
    [self showTaskInfoView:btn.tag];
}

-(void)showTaskInfoView:(NSInteger)taskTag
{
    NSInteger type = taskTag % 10;
    NSString* str;
    switch (type) {
        case 1:
            str = @"任务信息 - 发起的任务 : ";
            break;
        case 2:
            str = @"任务信息 - 参与的任务 : ";
            break;
        case 3:
            str = @"任务信息 - 等待响应的任务 : ";
            break;
        case 4:
            str = @"任务信息 - 已经响应的任务 : ";
            break;
        default:
            break;
    }
    
    NSInteger index = (taskTag / 10) - 1;

    str = [str stringByAppendingFormat:@"第 %ld 个任务.", index];
    
    NSLog(@"%@", str);
    
    TaskInfoController* ti = [[TaskInfoController alloc] init];
    
    ti.navigationItem.title = @"";
    
    ti.taskTag = taskTag;
    
    [self.navigationController pushViewController:ti animated:YES];
}

-(NSUInteger)getTaskIndex:(NSIndexPath*)path
{
    if(path.section < _requesterTaskSectionNum)
    {
        return (NSUInteger)path.section;
    } else if (path.section >= _requesterTaskSectionNum && path.section < _requesterTaskSectionNum+_chosenResponserTaskSectionNum)
    {
        return (NSUInteger)(path.section - _requesterTaskSectionNum);
    } else if (path.section >= _requesterTaskSectionNum + _chosenResponserTaskNum && path.section < _requesterTaskSectionNum+_chosenResponserTaskSectionNum + _potentialResponserTaskSectionNum)
    {
        return (NSUInteger)(path.section - _requesterTaskSectionNum - _chosenResponserTaskSectionNum);
    } else
    {
        return (NSUInteger)(path.section - _requesterTaskSectionNum - _chosenResponserTaskSectionNum - _potentialResponserTaskSectionNum);
    }
    
    return 0;
}

-(NSInteger)getTaskType:(NSIndexPath*)path
{
    if(path.section < _requesterTaskSectionNum)
    {
        return 1;
    } else if (path.section >= _requesterTaskSectionNum && path.section < _requesterTaskSectionNum+_chosenResponserTaskSectionNum)
    {
        return 2;
    } else if (path.section >= _requesterTaskSectionNum && path.section < _requesterTaskSectionNum+_chosenResponserTaskSectionNum + _potentialResponserTaskSectionNum)
    {
        return 3;
    } else
    {
        return 4;
    }
    
    return 0;
}

-(NSInteger)generateTaskTagWithTaskIndex:(NSUInteger)taskIndex andTaskType:(NSInteger)taskType
{
    return (taskIndex+1)*10+taskType;
}

-(NSInteger)ActionStatusWithTaksType:(NSInteger)type andTaskStatus:(NSInteger)status
{
    switch (type) {
        case 1:
            if (status == TaskStatusWaitingAccept)
            {
                return RequesterStatus_WaitingAccept;
            } else if (status == TaskStatusWaitingChoose)
            {
                return RequesterStatus_WaitingChoose;
            } else if (status == TaskStatusProcessing)
            {
                return RequesterStatus_Processing;
            } else if (status == TaskStatusFulfilled)
            {
                return RequesterStatus_Fulfilled;
            } else if (status == TaskStatusFinished)
            {
                return RequesterStatus_Finished;
            }
            
            break;
        case 2:
            if (status == TaskStatusProcessing)
            {
                return ChosenResponserStatus_Processing;
            } else if (status == TaskStatusFulfilled)
            {
                return ChosenResponserStatus_Fulfilled;
            } else if (status == TaskStatusFinished)
            {
                return ChosenResponserStatus_Finished;
            }
            
            break;
        case 3:
            if (status == TaskStatusWaitingAccept)
            {
                return PotentialResponserStatus_WaitingAccept;
            }
            
            break;
        case 4:
            if (status == TaskStatusWaitingAccept)
            {
                return ResponserStatus_WaitingAccept;
            } else if (status == TaskStatusWaitingChoose)
            {
                return ResponserStatus_WaitingChoose;
            }
            
            break;
            
        default:
            break;
    }
    
    return TaskActionStatusError;
}

-(void)QueryUserTasks {
    TaskAction* queryTask = [[TaskAction alloc] init];
    queryTask.Action = @"QUERY";
    queryTask.UserID = _delegate.AppUserInfo.ID;
    NSDictionary* queryDic = [queryTask GenerateTaskActionJsonDic];
    
    NSLog(@"Query Tasks!");

    NSData* queryData = [NSJSONSerialization dataWithJSONObject:queryDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString* taskInfoURL = @CUR_SERVER_URL_TASKS;
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest* queryTaskRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:taskInfoURL parameters:nil error:nil];
    [queryTaskRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [queryTaskRequest setHTTPBody:queryData];
    
    AFHTTPResponseSerializer* respSerializer = [AFHTTPResponseSerializer serializer];
    respSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                             @"text/html",
                                             @"text/json",
                                             @"text/javascript",
                                             @"text/plain", nil];
    
    manager.responseSerializer = respSerializer;
    
    [[manager dataTaskWithRequest:queryTaskRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (_refreshControl.refreshing)
        {
            [_refreshControl endRefreshing];
        }
        
        if (error) {
            NSLog(@"err = %@!", error);
        } else {
            NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
            if (rsp.statusCode == 200)
            {
                NSArray* tiDicArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                NSLog(@"info count : %ld", tiDicArray.count);
                
                for (NSDictionary* tiDic in tiDicArray)
                {
                    TaskInfo* curInfo = [TaskInfo TaskInfoFromJsonDic:tiDic];
                    
                    [self addTaskInfoToUserTasksList:curInfo];
                }
                
                [self performSelectorOnMainThread:@selector(reloadTasksView) withObject:nil waitUntilDone:nil];
            } else
            {
                NSLog(@"查询任务失败！");
            }
        }
    }] resume];

}

-(void)reloadTasksView
{
    [self getTasksNum];
    
    [_UserTasksTableView reloadData];
}

-(void)addTaskInfoToUserTasksList:(TaskInfo*)info
{
    for (int i = 0; i < _delegate.RequesterTasks.count; i++)
    {
        TaskInfo* curInfo = (TaskInfo*)[_delegate.RequesterTasks objectAtIndex:i];
        if ([curInfo.ID isEqualToNumber:info.ID])
        {
            [_delegate.RequesterTasks removeObjectAtIndex:i];
            break;
        }
    }
    
    for (int i = 0; i < _delegate.ChosenResponserTasks.count; i++)
    {
        TaskInfo* curInfo = (TaskInfo*)[_delegate.ChosenResponserTasks objectAtIndex:i];
        if ([curInfo.ID isEqualToNumber:info.ID])
        {
            [_delegate.ChosenResponserTasks removeObjectAtIndex:i];
            break;
        }
    }
    
    for (int i = 0; i < _delegate.ResponserTasks.count; i++)
    {
        TaskInfo* curInfo = (TaskInfo*)[_delegate.ResponserTasks objectAtIndex:i];
        if ([curInfo.ID isEqualToNumber:info.ID])
        {
            [_delegate.ResponserTasks removeObjectAtIndex:i];
            break;
        }
    }
    
    for (int i = 0; i < _delegate.PotentialResponserTasks.count; i++)
    {
        TaskInfo* curInfo = (TaskInfo*)[_delegate.PotentialResponserTasks objectAtIndex:i];
        if ([curInfo.ID isEqualToNumber:info.ID])
        {
            [_delegate.PotentialResponserTasks removeObjectAtIndex:i];
            break;
        }
    }
    
    NSLog(@"rid : %@, appuserid :%@",info.Requester.ID, _delegate.AppUserInfo.ID);
    if ([info.Requester.ID isEqualToNumber:_delegate.AppUserInfo.ID])
    {
        [_delegate.RequesterTasks addObject:info];
    
        return;
    } else {
        for (UserInfo* ui in info.ChosenResponser)
        {
            if ([ui.ID isEqualToNumber:_delegate.AppUserInfo.ID])
            {
                [_delegate.ChosenResponserTasks addObject:info];
                
                return;
            }
        }
        
        for (UserInfo* ui in info.Responsers)
        {
            if ([ui.ID isEqualToNumber:_delegate.AppUserInfo.ID])
            {
                [_delegate.ResponserTasks addObject:info];
                
                return;
            }
        }
        
        [_delegate.PotentialResponserTasks addObject:info];
        
        return;
    }
}

- (void)setRefreshTasks {
    _refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+180, self.view.bounds.size.width, 50)];
    [_refreshControl addTarget:self action:@selector(refreshQueryTasks:) forControlEvents:UIControlEventValueChanged];
    _refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在获取活动"];

    _refreshControl.tintColor = [UIColor grayColor];
    [_UserTasksTableView addSubview:_refreshControl];
    //[_refreshControl beginRefreshing];
    //[self refreshQueryTasks:_refreshControl];
}

- (void)refreshQueryTasks:(UIRefreshControl *)refreshControl {
    [self QueryUserTasks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
