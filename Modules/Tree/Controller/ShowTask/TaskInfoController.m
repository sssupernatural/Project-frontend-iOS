//
//  TaskInfoController.m
//  Tree
//
//  Created by 施威特 on 2017/12/21.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "TaskInfoController.h"
#import "ShowTaskAbilitiesCell.h"
#import "ShowTaskBriefCell.h"
#import "ShowTaskStatusCell.h"
#import "ShowTaskRequesterCell.h"
#import "ShowTaskTimeCell.h"
#import "ShowTaskAgeCell.h"
#import "ShowTaskSexCell.h"
#import "ShowTaskLocationCell.h"
#import "ShowLocationsCell.h"
#import "ShowTaskResponsersCell.h"
#import "AppDelegate.h"
#import "TaskInfo.h"
#import "UserInfo.h"
#import "../../../../Comm/Task/TaskStatus.h"
#import "ShowAbilitiesController.h"
#import "ShowUserController.h"
#import "ChooseResponsersController.h"
#import "AFNetworking.h"
#import "TaskAction.h"

#define AcceptTask 12001
#define RefuseTask 12002

@interface TaskInfoController ()

@end

@implementation TaskInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
    
    _delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _showMoreBrief = NO;
    _showMoreLocations = NO;
    _showMoreResponsers = NO;
    
    _task = [self getTaskInfoByTaskTag];
    _taskActionStatus = [self ActionStatus];
    
    [self generateCellArray];
    
    //[self.Btn_CurAction.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
    [self.Btn_CurAction.layer setBorderWidth:1];
    [self.Btn_CurAction.layer setMasksToBounds:YES];
    //[self.Btn_CurAction setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [self setBtnCurActionTitleAndFunc];
    //[self.Btn_CurAction setBackgroundColor:[UIColor colorWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1]];
    
    _TaskInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+150, self.view.bounds.size.width, self.view.bounds.size.height-150) style:UITableViewStyleGrouped];
    
    _TaskInfoTableView.showsHorizontalScrollIndicator = NO;
    _TaskInfoTableView.showsVerticalScrollIndicator = NO;
    
    [_TaskInfoTableView setBackgroundColor:[UIColor whiteColor]];
    
    //[_UserTasksTableView setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
    
    _TaskInfoTableView.delegate = self;
    _TaskInfoTableView.dataSource = self;
    
    [self.view addSubview:_TaskInfoTableView];
    [self.view addSubview:self.Btn_CurAction];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)backToTree
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setBtnCurActionTitleAndFunc
{
    switch (_taskActionStatus) {
        case RequesterStatus_WaitingAccept:
            [self.Btn_CurAction setTitle:@"等待响应者中" forState:UIControlStateNormal];
            [self.Btn_CurAction.layer setBorderColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1].CGColor];
            [self.Btn_CurAction setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1] forState:UIControlStateNormal];
            break;
        case RequesterStatus_WaitingChoose:
            [self.Btn_CurAction setTitle:@"选择响应者" forState:UIControlStateNormal];
            [self.Btn_CurAction.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
            [self.Btn_CurAction setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
            [self.Btn_CurAction addTarget:self action:@selector(actionChooseResponsers) forControlEvents:UIControlEventTouchUpInside];
            break;
        case RequesterStatus_Processing:
            [self.Btn_CurAction setTitle:@"活动进行中" forState:UIControlStateNormal];
            [self.Btn_CurAction.layer setBorderColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1].CGColor];
            [self.Btn_CurAction setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1] forState:UIControlStateNormal];
            break;
        case RequesterStatus_Fulfilled:
            [self.Btn_CurAction setTitle:@"评价活动和参与者" forState:UIControlStateNormal];
            [self.Btn_CurAction.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
            [self.Btn_CurAction setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
            [self.Btn_CurAction addTarget:self action:@selector(actionRequesterEvaluateTask) forControlEvents:UIControlEventTouchUpInside];
            break;
        case RequesterStatus_Finished:
            [self.Btn_CurAction setTitle:@"活动已结束" forState:UIControlStateNormal];
            [self.Btn_CurAction.layer setBorderColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1].CGColor];
            [self.Btn_CurAction setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1] forState:UIControlStateNormal];
            break;
        case ResponserStatus_WaitingAccept:
            [self.Btn_CurAction setTitle:@"已经响应活动" forState:UIControlStateNormal];
            [self.Btn_CurAction.layer setBorderColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1].CGColor];
            [self.Btn_CurAction setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1] forState:UIControlStateNormal];
            break;
        case ResponserStatus_WaitingChoose:
            [self.Btn_CurAction setTitle:@"已经响应活动" forState:UIControlStateNormal];
            [self.Btn_CurAction.layer setBorderColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1].CGColor];
            [self.Btn_CurAction setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1] forState:UIControlStateNormal];
            break;
        case ChosenResponserStatus_Processing:
            [self.Btn_CurAction setTitle:@"完成活动" forState:UIControlStateNormal];
            [self.Btn_CurAction.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
            [self.Btn_CurAction setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
            [self.Btn_CurAction addTarget:self action:@selector(actionChosenResponserTaskBtnFulfilTask) forControlEvents:UIControlEventTouchUpInside];
            break;
        case ChosenResponserStatus_Fulfilled:
            [self.Btn_CurAction setTitle:@"评价活动和参与者" forState:UIControlStateNormal];
            [self.Btn_CurAction.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
            [self.Btn_CurAction setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
            break;
        case ChosenResponserStatus_Finished:
            [self.Btn_CurAction setTitle:@"活动已结束" forState:UIControlStateNormal];
            [self.Btn_CurAction.layer setBorderColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1].CGColor];
            [self.Btn_CurAction setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1] forState:UIControlStateNormal];
            break;
        case PotentialResponserStatus_WaitingAccept:
            [self.Btn_CurAction setTitle:@"参与活动" forState:UIControlStateNormal];
            [self.Btn_CurAction.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
            [self.Btn_CurAction setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
            [self.Btn_CurAction addTarget:self action:@selector(actionPotentialResponserTaskBtnAcceptTask) forControlEvents:UIControlEventTouchUpInside];
            break;
        default:
            [self.Btn_CurAction setTitle:@"活动异常" forState:UIControlStateNormal];
            [self.Btn_CurAction.layer setBorderColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1].CGColor];
            [self.Btn_CurAction setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1] forState:UIControlStateNormal];
            break;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infoCellArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (UITableViewCell*)[_infoCellArray objectAtIndex:indexPath.row];
}

-(UITableViewCell*)MakeShowTaskAbilitiesCell
{
    ShowTaskAbilitiesCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"ShowTaskAbilitiesCell" owner:self options:nil] lastObject];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.Btn_MainAbi addTarget:self action:@selector(showAbilitiesView) forControlEvents:UIControlEventTouchUpInside];
    [cell.Btn_FirstAbi addTarget:self action:@selector(showAbilitiesView) forControlEvents:UIControlEventTouchUpInside];
    [cell.Btn_SecondAbi addTarget:self action:@selector(showAbilitiesView) forControlEvents:UIControlEventTouchUpInside];
    
    cell.userInteractionEnabled = YES;
    
    [cell setWithTaskInfo:_task];
    
    return cell;
}

-(CGFloat)MakeShowTaskAbilitiesCellHeight
{
    return ((ShowTaskAbilitiesCell*)[[[NSBundle mainBundle] loadNibNamed:@"ShowTaskAbilitiesCell" owner:self options:nil] lastObject]).frame.size.height;
}

-(UITableViewCell*)MakeShowTaskBriefCell
{
    ShowTaskBriefCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"ShowTaskBriefCell" owner:self options:nil] lastObject];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.userInteractionEnabled = YES;
    
    NSInteger briefLen = [_task.Desc.Brief length];
    
    if (briefLen < 20)
    {
        UILabel* lbTaskBrief = [[UILabel alloc] initWithFrame:CGRectMake(150, 16, 205, 37)];
        lbTaskBrief.textAlignment = NSTextAlignmentRight;
        lbTaskBrief.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
        lbTaskBrief.font = [UIFont systemFontOfSize:13];
        lbTaskBrief.text = _task.Desc.Brief;
        
        [cell addSubview:lbTaskBrief];
    } else
    {
        UILabel* lbTaskBrief = [[UILabel alloc] init];
        lbTaskBrief.textAlignment = NSTextAlignmentLeft;
        lbTaskBrief.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
        lbTaskBrief.font = [UIFont systemFontOfSize:13];
        
        UIButton* btnShowMoreBrief = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnShowMoreBrief setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btnShowMoreBrief.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnShowMoreBrief addTarget:self action:@selector(ShowBrief) forControlEvents:UIControlEventTouchUpInside];
        
        if (_showMoreBrief == YES)
        {
            NSInteger lines = briefLen / 20;
            lbTaskBrief.frame = CGRectMake(150, 8, 205, 37 + lines*20);
            lbTaskBrief.text = _task.Desc.Brief;
            lbTaskBrief.numberOfLines = 0;
            
            [btnShowMoreBrief setTitle:@"回去 △" forState:UIControlStateNormal];
            btnShowMoreBrief.frame = CGRectMake(284, 47+lines*20, 107, 22);
        } else {
            lbTaskBrief.frame = CGRectMake(150, 8, 205, 37);
            lbTaskBrief.text = _task.Desc.Brief;
            lbTaskBrief.numberOfLines = 2;
            
            [btnShowMoreBrief setTitle:@"出来 ▽" forState:UIControlStateNormal];
            btnShowMoreBrief.frame = CGRectMake(284, 47, 107, 22);
        }
        
        [cell addSubview:lbTaskBrief];
        [cell addSubview:btnShowMoreBrief];
    }
    
    return cell;
}

-(CGFloat)MakeShowTaskBriefCellHeight
{
    NSInteger cellh = 0;
    if (_showMoreBrief == YES)
    {
        NSInteger lines = _task.Desc.Brief.length / 20;
        cellh = ((ShowTaskBriefCell*)[[[NSBundle mainBundle] loadNibNamed:@"ShowTaskBriefCell" owner:self options:nil] lastObject]).frame.size.height+ lines * 20;
        return ((ShowTaskBriefCell*)[[[NSBundle mainBundle] loadNibNamed:@"ShowTaskBriefCell" owner:self options:nil] lastObject]).frame.size.height+ lines * 20;
    } else
    {
        cellh = ((ShowTaskBriefCell*)[[[NSBundle mainBundle] loadNibNamed:@"ShowTaskBriefCell" owner:self options:nil] lastObject]).frame.size.height;
        return ((ShowTaskBriefCell*)[[[NSBundle mainBundle] loadNibNamed:@"ShowTaskBriefCell" owner:self options:nil] lastObject]).frame.size.height;
    }
}

-(UITableViewCell*)MakeShowTaskStatusCell
{
    ShowTaskStatusCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"ShowTaskStatusCell" owner:self options:nil] lastObject];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.userInteractionEnabled = NO;
    
    [cell setWithTaskInfo:_task];
    
    return cell;
}

-(CGFloat)MakeShowTaskStatusCellHeight
{
    return ((ShowTaskStatusCell*)[[[NSBundle mainBundle] loadNibNamed:@"ShowTaskStatusCell" owner:self options:nil] lastObject]).frame.size.height;
}

-(UITableViewCell*)MakeShowTaskRequesterCell
{
    ShowTaskRequesterCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"ShowTaskRequesterCell" owner:self options:nil] lastObject];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.userInteractionEnabled = YES;
    
    cell.IV_RequesterPic.image = [UIImage imageNamed:@"tree.jpeg"];
    
    cell.LB_Requester.text = _task.Requester.Name;
    
    UITapGestureRecognizer* userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLabelUser:)];
    [userTap setNumberOfTouchesRequired:1];
    [userTap setNumberOfTapsRequired:1];
    
    cell.LB_Requester.userInteractionEnabled = YES;
    cell.LB_Requester.tag = 0;
    [cell.LB_Requester addGestureRecognizer:userTap];

    return cell;
}

-(CGFloat)MakeShowTaskRequesterCellHeight
{
    return ((ShowTaskRequesterCell*)[[[NSBundle mainBundle] loadNibNamed:@"ShowTaskRequesterCell" owner:self options:nil] lastObject]).frame.size.height;
}

-(UITableViewCell*)MakeShowTaskResponsersCell
{
    ShowTaskResponsersCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"ShowTaskResponsersCell" owner:self options:nil] lastObject];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSInteger taskType = _taskTag % 10;
    NSInteger tag1 = 1;
    if (taskType == 1)
    {
        if ((_task.Status.integerValue == 11001) || (_task.Status.integerValue == 11002))
        {
            cell.LB_ResponserType.text = @"响应的人";
            _responsersInfo = _task.Responsers;
            tag1 = 1;
        } else if ((_task.Status.integerValue == 11003) || (_task.Status.integerValue == 11004))
        {
            cell.LB_ResponserType.text = @"参与的人";
            _responsersInfo = _task.ChosenResponser;
            tag1 = 2;
        }
    } else if (taskType == 2)
    {
        cell.LB_ResponserType.text = @"参与的人";
        _responsersInfo = _task.ChosenResponser;
        tag1 = 2;
    }
    
    cell.userInteractionEnabled = YES;
    
    NSInteger rNum = _responsersInfo.count;
    
    if (rNum == 0)
    {
        UILabel* lbTaskNoResponser = [[UILabel alloc] initWithFrame:CGRectMake(149, 16, 205, 37)];
        lbTaskNoResponser.textAlignment = NSTextAlignmentRight;
        lbTaskNoResponser.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
        lbTaskNoResponser.font = [UIFont systemFontOfSize:13];
        lbTaskNoResponser.text = @"当前没有响应者";
        
        [cell addSubview:lbTaskNoResponser];
    } else if (rNum == 1)
    {
        UserInfo* u = (UserInfo*)[_responsersInfo objectAtIndex:0];
        UILabel* lbTaskResponserName = [[UILabel alloc] initWithFrame:CGRectMake(142, 26, 95, 21)];
        lbTaskResponserName.textAlignment = NSTextAlignmentRight;
        lbTaskResponserName.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
        lbTaskResponserName.font = [UIFont systemFontOfSize:13];
        lbTaskResponserName.text = u.Name;
        
        UITapGestureRecognizer* userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLabelUser:)];
        [userTap setNumberOfTouchesRequired:1];
        [userTap setNumberOfTapsRequired:1];
        
        lbTaskResponserName.userInteractionEnabled = YES;
        lbTaskResponserName.tag = tag1*10 + 0;
        [lbTaskResponserName addGestureRecognizer:userTap];
        
        UILabel* lbSymbol = [[UILabel alloc] initWithFrame:CGRectMake(243, 11, 16, 52)];
        lbSymbol.textAlignment = NSTextAlignmentLeft;
        lbSymbol.textColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
        lbSymbol.font = [UIFont systemFontOfSize:20];
        lbSymbol.text = @"I";
        
        UIImageView* ivUserPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tree.jpeg"]];
        ivUserPic.frame = CGRectMake(258, 11, 100, 49);
        ivUserPic.layer.cornerRadius = 5;
        ivUserPic.layer.masksToBounds = YES;
        
        [cell addSubview:ivUserPic];
        [cell addSubview:lbSymbol];
        [cell addSubview:lbTaskResponserName];
    } else
    {
        UIButton* btnShowMoreResponsers = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnShowMoreResponsers setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btnShowMoreResponsers.titleLabel.font = [UIFont systemFontOfSize:12];
        [btnShowMoreResponsers addTarget:self action:@selector(ShowResponsers) forControlEvents:UIControlEventTouchUpInside];
        
        if (_showMoreResponsers == YES)
        {
            for (int i = 0; i < rNum; i++)
            {
                UserInfo* u = (UserInfo*)[_responsersInfo objectAtIndex:i];
                UILabel* lbTaskResponserName = [[UILabel alloc] initWithFrame:CGRectMake(142, 26+i*74, 95, 21)];
                lbTaskResponserName.textAlignment = NSTextAlignmentRight;
                lbTaskResponserName.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
                lbTaskResponserName.font = [UIFont systemFontOfSize:13];
                lbTaskResponserName.text = u.Name;
                
                UITapGestureRecognizer* userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLabelUser:)];
                [userTap setNumberOfTouchesRequired:1];
                [userTap setNumberOfTapsRequired:1];
                
                lbTaskResponserName.userInteractionEnabled = YES;
                lbTaskResponserName.tag = tag1*10 + i;
                [lbTaskResponserName addGestureRecognizer:userTap];
                
                UILabel* lbSymbol = [[UILabel alloc] initWithFrame:CGRectMake(243, 11+i*74, 16, 52)];
                lbSymbol.textAlignment = NSTextAlignmentLeft;
                lbSymbol.textColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
                lbSymbol.font = [UIFont systemFontOfSize:20];
                lbSymbol.text = @"I";
                
                UIImageView* ivUserPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tree.jpeg"]];
                ivUserPic.frame = CGRectMake(258, 11+i*74, 100, 49);
                ivUserPic.layer.cornerRadius = 5;
                ivUserPic.layer.masksToBounds = YES;
                
                if (i != (rNum - 1))
                {
                    UILabel* lbSperator = [[UILabel alloc] initWithFrame:CGRectMake(150, 68+i*74, 230, 10)];
                    lbSperator.textAlignment = NSTextAlignmentLeft;
                    lbSperator.textColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1];
                    lbSperator.font = [UIFont systemFontOfSize:11];
                    lbSperator.text = @"━━━━━━━━━━━━━━━━━━━";
                    
                    [cell addSubview:lbSperator];
                }
                
                [cell addSubview:lbSymbol];
                [cell addSubview:lbTaskResponserName];
                [cell addSubview:ivUserPic];
            }
            
            [btnShowMoreResponsers setTitle:@"回去 △" forState:UIControlStateNormal];
            btnShowMoreResponsers.frame = CGRectMake(284, 11+(rNum-1)*74+49+10, 107, 22);
        } else {
            UserInfo* u = (UserInfo*)[_responsersInfo objectAtIndex:0];
            UILabel* lbTaskResponserName = [[UILabel alloc] initWithFrame:CGRectMake(142, 15, 95, 21)];
            lbTaskResponserName.textAlignment = NSTextAlignmentRight;
            lbTaskResponserName.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
            lbTaskResponserName.font = [UIFont systemFontOfSize:13];
            lbTaskResponserName.text = u.Name;
            
            UITapGestureRecognizer* userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLabelUser:)];
            [userTap setNumberOfTouchesRequired:1];
            [userTap setNumberOfTapsRequired:1];
            
            lbTaskResponserName.userInteractionEnabled = YES;
            lbTaskResponserName.tag = tag1*10 + 0;
            [lbTaskResponserName addGestureRecognizer:userTap];
            
            UILabel* lbSymbol = [[UILabel alloc] initWithFrame:CGRectMake(243, 0, 16, 52)];
            lbSymbol.textAlignment = NSTextAlignmentLeft;
            lbSymbol.textColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
            lbSymbol.font = [UIFont systemFontOfSize:20];
            lbSymbol.text = @"I";
        
            
            UIImageView* ivUserPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tree.jpeg"]];
            ivUserPic.frame = CGRectMake(258, 5, 100, 49);
            ivUserPic.layer.cornerRadius = 5;
            ivUserPic.layer.masksToBounds = YES;
            
            [cell addSubview:lbSymbol];
            [cell addSubview:lbTaskResponserName];
            [cell addSubview:ivUserPic];
            
            [btnShowMoreResponsers setTitle:@"出来 ▽" forState:UIControlStateNormal];
            btnShowMoreResponsers.frame = CGRectMake(284, 47, 107, 35);
        }
        
        [cell addSubview:btnShowMoreResponsers];
    }
    
    return cell;
}

-(CGFloat)MakeShowTaskResponsersCellHeight
{
    NSInteger rNum = _responsersInfo.count;
    if (_showMoreResponsers == YES)
    {
        return ((ShowTaskResponsersCell*)[[[NSBundle mainBundle] loadNibNamed:@"ShowTaskResponsersCell" owner:self options:nil] lastObject]).frame.size.height+ (rNum-1)*74+30;
    } else
    {
        if (rNum <= 1)
        {
            return ((ShowTaskResponsersCell*)[[[NSBundle mainBundle] loadNibNamed:@"ShowTaskResponsersCell" owner:self options:nil] lastObject]).frame.size.height;
        } else
        {
            return ((ShowTaskResponsersCell*)[[[NSBundle mainBundle] loadNibNamed:@"ShowTaskResponsersCell" owner:self options:nil] lastObject]).frame.size.height+10;
        }
    }
}

-(UITableViewCell*)MakeShowTaskCreateTimeCell
{
    ShowTaskTimeCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"ShowTaskTimeCell" owner:self options:nil] lastObject];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.userInteractionEnabled = NO;
    
    [cell setCreateTimeWithTaskInfo:_task];
    
    return cell;
}

-(UITableViewCell*)MakeShowTaskStartTimeCell
{
    ShowTaskTimeCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"ShowTaskTimeCell" owner:self options:nil] lastObject];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.userInteractionEnabled = NO;
    
    [cell setStartTimeWithTaskInfo:_task];
    
    return cell;
}

-(CGFloat)MakeShowTaskTimeCellHeight
{
    return ((ShowTaskTimeCell*)[[[NSBundle mainBundle] loadNibNamed:@"ShowTaskTimeCell" owner:self options:nil] lastObject]).frame.size.height;
}

-(UITableViewCell*)MakeShowTaskSexCell
{
    ShowTaskSexCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"ShowTaskSexCell" owner:self options:nil] lastObject];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.userInteractionEnabled = NO;
    
    [cell setWithTaskInfo:_task];
    
    return cell;
}

-(CGFloat)MakeShowTaskSexCellHeight
{
    return ((ShowTaskSexCell*)[[[NSBundle mainBundle] loadNibNamed:@"ShowTaskSexCell" owner:self options:nil] lastObject]).frame.size.height;
}

-(UITableViewCell*)MakeShowTaskAgeCell
{
    ShowTaskAgeCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"ShowTaskAgeCell" owner:self options:nil] lastObject];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.userInteractionEnabled = NO;
    
    [cell setWithTaskInfo:_task];
    
    return cell;
}

-(CGFloat)MakeShowTaskAgeCellHeight
{
    return ((ShowTaskAgeCell*)[[[NSBundle mainBundle] loadNibNamed:@"ShowTaskAgeCell" owner:self options:nil] lastObject]).frame.size.height;
}

-(UITableViewCell*)MakeShowTaskLocationCell
{
    ShowTaskLocationCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"ShowTaskLocationCell" owner:self options:nil] lastObject];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.userInteractionEnabled = NO;
    
    [cell setWithTaskInfo:_task];
    
    return cell;
}

-(CGFloat)MakeShowTaskLocationCellHeight
{
    return ((ShowTaskLocationCell*)[[[NSBundle mainBundle] loadNibNamed:@"ShowTaskLocationCell" owner:self options:nil] lastObject]).frame.size.height;
}

-(UITableViewCell*)MakeShowLocationsCell
{
    ShowLocationsCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"ShowLocationsCell" owner:self options:nil] lastObject];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.userInteractionEnabled = YES;
    
    if (_task.Desc.LocationsDescStrs == nil || _task.Desc.LocationsDescStrs.count == 0)
    {
        
    } else if (_task.Desc.LocationsDescStrs.count == 1)
    {
        UILabel* lbLocation = [[UILabel alloc] initWithFrame:CGRectMake(96, 24, 252, 20)];
        lbLocation.textAlignment = NSTextAlignmentRight;
        lbLocation.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
        lbLocation.font = [UIFont systemFontOfSize:13];
        lbLocation.text = (NSString*)[_task.Desc.LocationsDescStrs objectAtIndex:0];
        
        [cell addSubview:lbLocation];
    } else
    {
        if (_showMoreLocations == YES)
        {
            for (int i = 0; i < _task.Desc.LocationsDescStrs.count; i++)
            {
                UILabel* lbLocation = [[UILabel alloc] initWithFrame:CGRectMake(96, 24+(i*10)+((i)*20), 252, 20)];
                lbLocation.textAlignment = NSTextAlignmentRight;
                lbLocation.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
                lbLocation.font = [UIFont systemFontOfSize:13];
                lbLocation.text = (NSString*)[_task.Desc.LocationsDescStrs objectAtIndex:i];
                
                [cell addSubview:lbLocation];
            }
            
            UIButton* btnMoreLocations = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btnMoreLocations setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
            btnMoreLocations.titleLabel.font = [UIFont systemFontOfSize:12];
            [btnMoreLocations addTarget:self action:@selector(ShowLocations) forControlEvents:UIControlEventTouchUpInside];
            [btnMoreLocations setTitle:@"回去 △" forState:UIControlStateNormal];
            btnMoreLocations.frame = CGRectMake(284, 47+(_task.Desc.LocationsDescStrs.count-1)*30, 107, 22);
            
            [cell addSubview:btnMoreLocations];
        } else {
            UILabel* lbLocation = [[UILabel alloc] initWithFrame:CGRectMake(96, 24, 252, 20)];
            lbLocation.textAlignment = NSTextAlignmentRight;
            lbLocation.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
            lbLocation.font = [UIFont systemFontOfSize:13];
            lbLocation.text = (NSString*)[_task.Desc.LocationsDescStrs objectAtIndex:0];
            
            UIButton* btnMoreLocations = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btnMoreLocations setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
            btnMoreLocations.titleLabel.font = [UIFont systemFontOfSize:12];
            [btnMoreLocations addTarget:self action:@selector(ShowLocations) forControlEvents:UIControlEventTouchUpInside];
            [btnMoreLocations setTitle:@"出来 ▽" forState:UIControlStateNormal];
            btnMoreLocations.frame = CGRectMake(284, 47, 107, 22);
            
            [cell addSubview:lbLocation];
            [cell addSubview:btnMoreLocations];
        }
    }
    
    return cell;
}

-(CGFloat)MakeShowLocationsCellHeight
{
    if (_showMoreLocations == YES)
    {
        NSInteger locNum = _task.Desc.LocationsDescStrs.count - 1;
        return ((ShowLocationsCell*)[[[NSBundle mainBundle] loadNibNamed:@"ShowLocationsCell" owner:self options:nil] lastObject]).frame.size.height+ locNum*30;
    } else
    {
        return ((ShowLocationsCell*)[[[NSBundle mainBundle] loadNibNamed:@"ShowLocationsCell" owner:self options:nil] lastObject]).frame.size.height;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGFloat)[((NSNumber*)[_infoCellHeightArray objectAtIndex:indexPath.row]) doubleValue];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [self showAbilitiesView];
    }
    
    if (indexPath.row == _briefIndex)
    {
        [self ShowBrief];
    }
    
    if (indexPath.row == _locationsIndex)
    {
        [self ShowLocations];
    }
    
    if (indexPath.row == _responsersIndex && _hasResponsersCell)
    {
        [self ShowResponsers];
    }
}

-(void)generateCellArray
{
    NSInteger taskType = self.taskTag % 10;
    if(taskType == 1 || taskType == 2)
    {
        _briefIndex = 4;
        _locationsIndex = 10;
        _responsersIndex = 2;
        _hasResponsersCell = YES;
    } else
    {
        _briefIndex = 3;
        _locationsIndex = 9;
        _responsersIndex = 0;
        _hasResponsersCell = NO;
    }
    
    _infoCellArray = [[NSMutableArray alloc] init];
    _infoCellHeightArray = [[NSMutableArray alloc] init];
    
    [_infoCellArray addObject:[self MakeShowTaskAbilitiesCell]];
    [_infoCellHeightArray addObject:[NSNumber numberWithDouble:[self MakeShowTaskAbilitiesCellHeight]]];
    
    [_infoCellArray addObject:[self MakeShowTaskRequesterCell]];
    [_infoCellHeightArray addObject:[NSNumber numberWithDouble:[self MakeShowTaskRequesterCellHeight]]];
    
    if (taskType == 1 || taskType == 2)
    {
        [_infoCellArray addObject:[self MakeShowTaskResponsersCell]];
        [_infoCellHeightArray addObject:[NSNumber numberWithDouble:[self MakeShowTaskResponsersCellHeight]]];
    }
    
    [_infoCellArray addObject:[self MakeShowTaskStatusCell]];
    [_infoCellHeightArray addObject:[NSNumber numberWithDouble:[self MakeShowTaskStatusCellHeight]]];
    
    [_infoCellArray addObject:[self MakeShowTaskBriefCell]];
    [_infoCellHeightArray addObject:[NSNumber numberWithDouble:[self MakeShowTaskBriefCellHeight]]];
    
    [_infoCellArray addObject:[self MakeShowTaskStartTimeCell]];
    [_infoCellHeightArray addObject:[NSNumber numberWithDouble:[self MakeShowTaskTimeCellHeight]]];
    
    [_infoCellArray addObject:[self MakeShowTaskLocationCell]];
    [_infoCellHeightArray addObject:[NSNumber numberWithDouble:[self MakeShowTaskLocationCellHeight]]];
    
    [_infoCellArray addObject:[self MakeShowTaskSexCell]];
    [_infoCellHeightArray addObject:[NSNumber numberWithDouble:[self MakeShowTaskSexCellHeight]]];
    
    [_infoCellArray addObject:[self MakeShowTaskAgeCell]];
    [_infoCellHeightArray addObject:[NSNumber numberWithDouble:[self MakeShowTaskAgeCellHeight]]];
    
    [_infoCellArray addObject:[self MakeShowTaskCreateTimeCell]];
    [_infoCellHeightArray addObject:[NSNumber numberWithDouble:[self MakeShowTaskTimeCellHeight]]];
    
    [_infoCellArray addObject:[self MakeShowLocationsCell]];
    [_infoCellHeightArray addObject:[NSNumber numberWithDouble:[self MakeShowLocationsCellHeight]]];
}


-(void)ShowBrief
{
    if (_task.Desc.Brief.length < 20)
    {
        return;
    }
    
    if (_showMoreBrief == NO)
    {
        _showMoreBrief = YES;
    } else
    {
        _showMoreBrief = NO;
    }
    
    [_infoCellArray removeObjectAtIndex:_briefIndex];
    [_infoCellHeightArray removeObjectAtIndex:_briefIndex];
    
    [_infoCellArray insertObject:[self MakeShowTaskBriefCell] atIndex:_briefIndex];
    [_infoCellHeightArray insertObject:[NSNumber numberWithDouble:[self MakeShowTaskBriefCellHeight]] atIndex:_briefIndex];
    
    [_TaskInfoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_briefIndex inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)ShowLocations
{
    if (_task.Desc.LocationsDescStrs.count <= 1)
    {
        return;
    }
    
    if (_showMoreLocations == NO)
    {
        _showMoreLocations = YES;
    } else
    {
        _showMoreLocations = NO;
    }
    
    [_infoCellArray removeObjectAtIndex:_locationsIndex];
    [_infoCellHeightArray removeObjectAtIndex:_locationsIndex];
    
    [_infoCellArray insertObject:[self MakeShowLocationsCell] atIndex:_locationsIndex];
    [_infoCellHeightArray insertObject:[NSNumber numberWithDouble:[self MakeShowLocationsCellHeight]] atIndex:_locationsIndex];
    
    [_TaskInfoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_locationsIndex inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)ShowResponsers
{
    if (_responsersInfo.count <= 1)
    {
        return;
    }
    
    if (!_hasResponsersCell)
    {
        return;
    }
    
    if (_showMoreResponsers == NO)
    {
        _showMoreResponsers = YES;
    } else
    {
        _showMoreResponsers = NO;
    }
    
    [_infoCellArray removeObjectAtIndex:_responsersIndex];
    [_infoCellHeightArray removeObjectAtIndex:_responsersIndex];
    
    [_infoCellArray insertObject:[self MakeShowTaskResponsersCell] atIndex:_responsersIndex];
    [_infoCellHeightArray insertObject:[NSNumber numberWithDouble:[self MakeShowTaskResponsersCellHeight]] atIndex:_responsersIndex];
    
    [_TaskInfoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_responsersIndex inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
}

-(TaskInfo*)getTaskInfoByTaskTag
{
    NSInteger taskType = self.taskTag % 10;
    NSInteger taskIndex = (self.taskTag / 10) - 1;
    
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

-(NSInteger)ActionStatus
{
    NSInteger taskType = self.taskTag % 10;
    switch (taskType) {
        case 1:
            if (_task.Status.integerValue == TaskStatusWaitingAccept)
            {
                return RequesterStatus_WaitingAccept;
            } else if (_task.Status.integerValue == TaskStatusWaitingChoose)
            {
                return RequesterStatus_WaitingChoose;
            } else if (_task.Status.integerValue == TaskStatusProcessing)
            {
                return RequesterStatus_Processing;
            } else if (_task.Status.integerValue == TaskStatusFulfilled)
            {
                return RequesterStatus_Fulfilled;
            } else if (_task.Status.integerValue == TaskStatusFinished)
            {
                return RequesterStatus_Finished;
            }
            
            break;
        case 2:
            if (_task.Status.integerValue == TaskStatusProcessing)
            {
                return ChosenResponserStatus_Processing;
            } else if (_task.Status.integerValue == TaskStatusFulfilled)
            {
                return ChosenResponserStatus_Fulfilled;
            } else if (_task.Status.integerValue == TaskStatusFinished)
            {
                return ChosenResponserStatus_Finished;
            }
            
            break;
        case 3:
            if (_task.Status.integerValue == TaskStatusWaitingAccept)
            {
                return PotentialResponserStatus_WaitingAccept;
            }
            
            break;
        case 4:
            if (_task.Status.integerValue == TaskStatusWaitingAccept)
            {
                return ResponserStatus_WaitingAccept;
            } else if (_task.Status.integerValue == TaskStatusWaitingChoose)
            {
                return ResponserStatus_WaitingChoose;
            }
            
            break;
            
        default:
            break;
    }
    
    return TaskActionStatusError;
}

-(void)showAbilitiesView
{
    ShowAbilitiesController* showAbis = [[ShowAbilitiesController alloc] init];
    showAbis.taskTag = self.taskTag;
    
    [self.navigationController pushViewController:showAbis animated:YES];
}

-(void)clickLabelUser:(UIGestureRecognizer*)gesture
{
    if (gesture.view.tag == 0)
    {
        [self showUserViewWithUserInfo:_task.Requester];
    } else
    {
        if (gesture.view.tag / 10 == 1)
        {
            [self showUserViewWithUserInfo:(UserInfo*)[_task.Responsers objectAtIndex:(gesture.view.tag % 10)]];
        } else if (gesture.view.tag / 10 == 2)
        {
             [self showUserViewWithUserInfo:(UserInfo*)[_task.ChosenResponser objectAtIndex:(gesture.view.tag % 10)]];
        }
    }
    
    return ;
}

-(void)showUserViewWithUserInfo:(UserInfo*)user
{
    ShowUserController* su = [[ShowUserController alloc] init];
    
    su.userInfo = user;
    
    [self.navigationController pushViewController:su animated:YES];
}

-(void)actionChooseResponsers
{
    ChooseResponsersController* crc = [[ChooseResponsersController alloc] init];
    crc.info = _task;
    [self.navigationController pushViewController:crc animated:YES];
}

-(void)actionRequesterEvaluateTask
{
    TaskAction* evaluateTask = [[TaskAction alloc] init];
    evaluateTask.Action = @"EVALUATE";
    evaluateTask.UserID = _delegate.AppUserInfo.ID;
    evaluateTask.TaskID = _task.ID;
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
                [_delegate.RequesterTasks removeObject:_task];
                
                [self.navigationController popViewControllerAnimated:YES];
            } else
            {
                NSLog(@"评价任务失败！");
            }
        }
    }] resume];
}

-(void)actionChosenResponserTaskBtnFulfilTask
{
    TaskAction* fulfilTask = [[TaskAction alloc] init];
    fulfilTask.Action = @"FULFIL";
    fulfilTask.UserID = _delegate.AppUserInfo.ID;
    fulfilTask.TaskID = _task.ID;
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
                [self.navigationController popViewControllerAnimated:YES];
            } else
            {
                NSLog(@"评价任务失败！");
            }
        }
    }] resume];
}

-(void)actionPotentialResponserTaskBtnAcceptTask
{
    TaskAction* acceptTask = [[TaskAction alloc] init];
    acceptTask.Action = @"ACCEPT";
    acceptTask.UserID = _delegate.AppUserInfo.ID;
    acceptTask.TaskID = _task.ID;
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
                [_delegate.PotentialResponserTasks removeObject:_task];
                [self.navigationController popViewControllerAnimated:YES];
            } else
            {
                NSLog(@"接受任务失败！");
            }
        }
    }] resume];
}

-(void)actionPotentialResponserTaskBtnRefuseTask
{
    TaskAction* refuseTask = [[TaskAction alloc] init];
    refuseTask.Action = @"ACCEPT";
    refuseTask.UserID = _delegate.AppUserInfo.ID;
    refuseTask.TaskID = _task.ID;
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
                [_delegate.PotentialResponserTasks removeObject:_task];
                
                [self.navigationController popViewControllerAnimated:YES];
            } else
            {
                NSLog(@"拒绝任务失败！");
            }
        }
    }] resume];
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
