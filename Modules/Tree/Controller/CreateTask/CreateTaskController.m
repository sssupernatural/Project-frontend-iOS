//
//  CreateTaskController.m
//  Tree
//
//  Created by 施威特 on 2018/1/30.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import "CreateTaskController.h"
#import "TaskInfo.h"
#import "TaskCreateInfo.h"
#import "AbilitiesOptionCell.h"
#import "BriefCell.h"
#import "TaskLocationCell.h"
#import "StartTimeCell.h"
#import "ResponserLocationsCell.h"
#import "TaskSexCell.h"
#import "TaskAgeCell.h"
#import "CreateTaskBriefController.h"
#import "CreateTaskStartTimeController.h"
#import "CreateTaskAgeController.h"
#import "CreateTaskChooseSexController.h"
#import "CreateTaskLocationController.h"
#import "CreateTaskResponserLocationsController.h"
#import "CreateTaskAbilitiesController.h"
#import "Location.h"
#import "AbiNode.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

#define CREATE_READY 0
#define CREATE_NOT_READY 1

@interface CreateTaskController ()

@end

@implementation CreateTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
    
    [self.Btn_CreateTask.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
    [self.Btn_CreateTask.layer setBorderWidth:1];
    [self.Btn_CreateTask.layer setMasksToBounds:YES];
    [self.Btn_CreateTask setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [self.Btn_CreateTask addTarget:self action:@selector(createNewTaskWithTaskInfo) forControlEvents:UIControlEventTouchUpInside];
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _createTaskInfo = [[TaskCreateInfo alloc] init];
    _createTaskInfo.RequesterID = delegate.AppUserInfo.ID;
    _createTaskInfo.AgeMin = [NSNumber numberWithInteger:20];
    _createTaskInfo.AgeMax = [NSNumber numberWithInteger:20];
    _createTaskInfo.LocationsDescStrs = [[NSMutableArray alloc] init];
    _createTaskInfo.Locations = [[NSMutableArray alloc] init];
    _createTaskInfo.TaskLocation = [[Location alloc] init];
    
    _createTaskItemCells = [self generateCreateItemCells];
    _createTaskItemCellHeights = [self generateCreateItemCellHeights];
    
    _createTaskAbilities = [Ability systemAbilities];
    
    _createTaskItemsTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+150, self.view.bounds.size.width, self.view.bounds.size.height-150) style:UITableViewStyleGrouped];
    
    _createTaskItemsTableView.showsHorizontalScrollIndicator = NO;
    _createTaskItemsTableView.showsVerticalScrollIndicator = NO;
    
    [_createTaskItemsTableView setBackgroundColor:[UIColor whiteColor]];
        
    //[_UserTasksTableView setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
    
    _createTaskItemsTableView.delegate = self;
    _createTaskItemsTableView.dataSource = self;
    
    [self.view addSubview:_createTaskItemsTableView];
    [self.view addSubview:self.Btn_CreateTask];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self performSelectorOnMainThread:@selector(reloadCreateInfoCellsData) withObject:nil waitUntilDone:nil];
}

-(void)reloadCreateInfoCellsData
{
    _createTaskItemCells = [self generateCreateItemCells];
    _createTaskItemCellHeights = [self generateCreateItemCellHeights];
    [_createTaskItemsTableView reloadData];
}

-(NSInteger)checkCreateTaskCondition
{
    if (_createTaskInfo.RequesterID == nil)
    {
        NSLog(@"_createTaskInfo.RequesterID == nil");
        
        return CREATE_NOT_READY;
    }
    
    if (_createTaskInfo.Brief == nil)
    {
        NSLog(@"_createTaskInfo.Brief == nil");
        
        return CREATE_NOT_READY;
    }
    
    if (_createTaskInfo.Sex == nil)
    {
        NSLog(@"_createTaskInfo.Sex == nil");
        
        return CREATE_NOT_READY;
    }
    
    if (_createTaskInfo.AgeMax == nil)
    {
        NSLog(@"_createTaskInfo.AgeMax == nil");
        
        return CREATE_NOT_READY;
    }
    
    if (_createTaskInfo.AgeMin == nil)
    {
        NSLog(@"_createTaskInfo.AgeMin == nil");
        
        return CREATE_NOT_READY;
    }
    
    if (_createTaskInfo.TaskCreateTime == nil)
    {
        NSLog(@"_createTaskInfo.TaskCreateTime == nil");
        
        return CREATE_NOT_READY;
    }
    
    if (_createTaskInfo.TaskStartTime == nil)
    {
        NSLog(@"_createTaskInfo.TaskStartTime == nil");
        
        return CREATE_NOT_READY;
    }
    
    if (_createTaskInfo.TaskLocationDescStr == nil)
    {
        NSLog(@"_createTaskInfo.TaskLocationDescStr == nil");
        
        return CREATE_NOT_READY;
    }
    
    if (_createTaskInfo.TaskLocation == nil)
    {
        NSLog(@"_createTaskInfo.TaskLocation == nil");
        
        return CREATE_NOT_READY;
    }
    
    if (_createTaskInfo.Abilities == nil)
    {
        NSLog(@"_createTaskInfo.Abilities == nil");
        
        return CREATE_NOT_READY;
    }
    
    if (_createTaskInfo.ImportanceArray == nil)
    {
        NSLog(@"_createTaskInfo.ImportanceArray == nil");
        
        return CREATE_NOT_READY;
    }
    
    return CREATE_READY;
}

-(void)createNewTaskWithTaskInfo
{
    [self constructCreateAbisHeap];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-M-d    HH:mm"];
    _createTaskInfo.TaskCreateTime = [dateFormatter stringFromDate:[NSDate date]];
    
    NSInteger createCheck = [self checkCreateTaskCondition];
    if (CREATE_NOT_READY == createCheck)
    {
        return;
    }
    
    NSDictionary* createInfoDic = [_createTaskInfo GenerateCreateInfoJsonDic];
    
    NSData* createTaskData = [NSJSONSerialization dataWithJSONObject:createInfoDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString* taskInfoURL = @CUR_SERVER_URL_TASKS;
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest* updateUserInfoRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT" URLString:taskInfoURL parameters:nil error:nil];
    [updateUserInfoRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [updateUserInfoRequest setHTTPBody:createTaskData];
    
    AFHTTPResponseSerializer* respSerializer = [AFHTTPResponseSerializer serializer];
    respSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                             @"text/html",
                                             @"text/json",
                                             @"text/javascript",
                                             @"text/plain", nil];
    
    manager.responseSerializer = respSerializer;
    
    [[manager dataTaskWithRequest:updateUserInfoRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"err = %@!", error);
        } else {
            NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
            if (rsp.statusCode == 200)
            {
                UIAlertController* succAlert = [UIAlertController alertControllerWithTitle:@"创建活动信息" message:@"活动已经创建成功" preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:succAlert animated:YES completion:nil];
                
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(createTaskSucceed:) userInfo:succAlert repeats:NO];
            } else
            {
                UIAlertController* failedAlert = [UIAlertController alertControllerWithTitle:@"创建活动信息" message:[NSString stringWithFormat:@"活动创建失败，请重试。错误码为%ld", rsp.statusCode] preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:failedAlert animated:YES completion:nil];
                
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(createTaskFailed:) userInfo:failedAlert repeats:NO];
            }
        }
    }] resume];
    
}

-(void)createTaskSucceed:(NSTimer*)timer
{
    UIAlertController *alert = [timer userInfo];
    
    [alert dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createTaskFailed:(NSTimer*)timer
{
    UIAlertController *alert = [timer userInfo];
    
    [alert dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _createTaskItemCells.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (UITableViewCell*)[_createTaskItemCells objectAtIndex:indexPath.row];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGFloat)(((NSNumber*)[_createTaskItemCellHeights objectAtIndex:indexPath.row]).doubleValue);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _abilitiesCellIndex)
    {
        //TODO:打开一个展示已经选择的能力堆的页面
        return;
    } else if (indexPath.row == _briefCellIndex)
    {
        CreateTaskBriefController* ctb = [[CreateTaskBriefController alloc] init];
        ctb.CreateInfo = _createTaskInfo;
        
        [self.navigationController pushViewController:ctb animated:YES];
    } else if (indexPath.row == _taskLocationCellIndex)
    {
        CreateTaskLocationController* ctl = [[CreateTaskLocationController alloc] init];
        ctl.CreateInfo = _createTaskInfo;
        
        [self.navigationController pushViewController:ctl animated:YES];
    } else if (indexPath.row == _taskStartTimeCellIndex)
    {
        CreateTaskStartTimeController* ctst = [[CreateTaskStartTimeController alloc] init];
        ctst.CreateInfo = _createTaskInfo;
        
        [self.navigationController pushViewController:ctst animated:YES];
    } else if (indexPath.row == _rLocationsCellIndex)
    {
        CreateTaskResponserLocationsController* ctrlc = [[CreateTaskResponserLocationsController alloc] init];
        ctrlc.CreateInfo = _createTaskInfo;
        
        [self.navigationController pushViewController:ctrlc animated:YES];
    }else if (indexPath.row == _taskSexCellIndex)
    {
        CreateTaskChooseSexController* ctcs = [[CreateTaskChooseSexController alloc] init];
        ctcs.CreateInfo = _createTaskInfo;
        
        [self.navigationController pushViewController:ctcs animated:YES];
    } else if (indexPath.row == _taskAgeCellIndex)
    {
        CreateTaskAgeController* cta = [[CreateTaskAgeController alloc] init];
        cta.CreateInfo = _createTaskInfo;
        
        [self.navigationController pushViewController:cta animated:YES];
        
        _AgeConfirmed = [NSNumber numberWithInteger:0];
    }
    
    return;
}

-(void)constructCreateAbisHeap
{
    NSDictionary* sysAbisDic = [Ability systemAbilitiesDic];
    
    if (_mainAbilityStr == nil)
    {
        return;
    }else
    {
        Ability* mainAbi = [_createTaskAbilities GetAbilityByAbiStr:_mainAbilityStr withAbisDic:sysAbisDic];
        mainAbi.selected = YES;
        [mainAbi SelectParentAbis];
    }
    
    if (_firstAbilityStr != nil)
    {
        Ability* firstAbi = [_createTaskAbilities GetAbilityByAbiStr:_firstAbilityStr withAbisDic:sysAbisDic];
        firstAbi.selected = YES;
        [firstAbi SelectParentAbis];
    }
    
    if (_secondAbilityStr != nil)
    {
        Ability* secondAbi = [_createTaskAbilities GetAbilityByAbiStr:_secondAbilityStr withAbisDic:sysAbisDic];
        secondAbi.selected = YES;
        [secondAbi SelectParentAbis];
    }
    
    if (_otherAbilitiesStr != nil && _otherAbilitiesStr.count != 0)
    {
        for (int i = 0; i < _otherAbilitiesStr.count; i++)
        {
            NSString* curAbiStr = (NSString*)[_otherAbilitiesStr objectAtIndex:i];
            Ability* curAbi =[_createTaskAbilities GetAbilityByAbiStr:curAbiStr withAbisDic:sysAbisDic];
            curAbi.selected = YES;
            [curAbi SelectParentAbis];
        }
    }
    
    _createTaskInfo.Abilities = [_createTaskAbilities ConstructAbisHeap];
    [_createTaskInfo.Abilities print];
    
    _createTaskInfo.ImportanceArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"", nil];
    
    for (int i = 0; i < _createTaskInfo.Abilities.ABIs.count; i++)
    {
        AbiNode* curNode = (AbiNode*)[_createTaskInfo.Abilities.ABIs objectAtIndex:i];
        if ([curNode.ABI isEqualToString:_mainAbilityStr])
        {
            [_createTaskInfo.ImportanceArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:i]];
            continue;
        }
        
        if (_firstAbilityStr != nil && [curNode.ABI isEqualToString:_firstAbilityStr])
        {
            [_createTaskInfo.ImportanceArray replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:i]];
            continue;
        }
        
        if (_secondAbilityStr != nil && [curNode.ABI isEqualToString:_secondAbilityStr])
        {
            [_createTaskInfo.ImportanceArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:i]];
            continue;
        }
    }
    
    NSLog(@"ARRAY : %@", _createTaskInfo.ImportanceArray);
}

-(NSMutableArray*)generateCreateItemCells
{
    NSMutableArray* cells = [[NSMutableArray alloc] init];
    NSInteger i = 0;
    
    [cells addObject:[self MakeAbilitiesCell]];
    _abilitiesCellIndex = i++;
    
    [cells addObject:[self MakeBriefCell]];
    _briefCellIndex = i++;
    
    [cells addObject:[self MakeTaskLocationCell]];
    _taskLocationCellIndex = i++;
    
    [cells addObject:[self MakeStartTimeCell]];
    _taskStartTimeCellIndex = i++;
    
    [cells addObject:[self MakeResponsersLocationsCell]];
    _rLocationsCellIndex = i++;
    
    [cells addObject:[self MakeSexCell]];
    _taskSexCellIndex = i++;
    
    [cells addObject:[self MakeAgeCell]];
    _taskAgeCellIndex = i++;
    
    return cells;
}

-(NSMutableArray*)generateCreateItemCellHeights
{
    NSMutableArray* heights = [[NSMutableArray alloc] init];
    
    [heights addObject:[NSNumber numberWithDouble:[self MakeAbilitiesCellHeight]]];
    [heights addObject:[NSNumber numberWithDouble:[self MakeBriefCellHeight]]];
    [heights addObject:[NSNumber numberWithDouble:[self MakeTaskLocationCellHeight]]];
    [heights addObject:[NSNumber numberWithDouble:[self MakeStartTimeCellHeight]]];
    [heights addObject:[NSNumber numberWithDouble:[self MakeResponsersLocationsCellHeight]]];
    [heights addObject:[NSNumber numberWithDouble:[self MakeSexCellHeight]]];
    [heights addObject:[NSNumber numberWithDouble:[self MakeAgeCellHeight]]];
    
    return heights;
}

-(void)setTaskItemDefault:(UITableViewCell*)cell
{
    UILabel* lbTaskItemDefault = [[UILabel alloc] init];
    lbTaskItemDefault.frame = CGRectMake(149, 24, 205, 20);
    lbTaskItemDefault.textAlignment = NSTextAlignmentRight;
    lbTaskItemDefault.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
    lbTaskItemDefault.font = [UIFont systemFontOfSize:21];
    lbTaskItemDefault.text = @"›";
    
    [cell addSubview:lbTaskItemDefault];
}

-(UITableViewCell*)MakeAbilitiesCell
{
    AbilitiesOptionCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"AbilitiesOptionCell" owner:self options:nil] lastObject];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.userInteractionEnabled = YES;
    
    if (_mainAbilityStr != nil)
    {
        
        [cell.Btn_SetMainAbi setTitle:_mainAbilityStr forState:UIControlStateNormal];
    }
    
    if (_firstAbilityStr != nil)
    {
        [cell.Btn_SetFirstAbi setTitle:_firstAbilityStr forState:UIControlStateNormal];
    }
    
    if (_secondAbilityStr != nil)
    {
        [cell.Btn_SetSecondAbi setTitle:_secondAbilityStr forState:UIControlStateNormal];
    }
    
    if (_otherAbilitiesStr != nil && _otherAbilitiesStr.count != 0)
    {        
        [cell.Btn_SetOtherAbis setTitle:[NSString stringWithFormat:@"%ld项", _otherAbilitiesStr.count] forState:UIControlStateNormal];
    }
    
    cell.Btn_SetMainAbi.tag = AbilityType_Main;
    [cell.Btn_SetMainAbi addTarget:self action:@selector(chooseAbility:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.Btn_SetFirstAbi.tag = AbilityType_First;
    [cell.Btn_SetFirstAbi addTarget:self action:@selector(chooseAbility:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.Btn_SetSecondAbi.tag = AbilityType_Second;
    [cell.Btn_SetSecondAbi addTarget:self action:@selector(chooseAbility:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.Btn_SetOtherAbis.tag = AbilityType_Other;
    [cell.Btn_SetOtherAbis addTarget:self action:@selector(chooseAbility:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)confirmAbilitiesWithType:(NSInteger)abiType andSingleAbi:(Ability *)abi andOtherAbisStr:(NSMutableArray *)array
{
    if (abiType == AbilityType_Main)
    {
        _mainAbilityStr = abi.abiStr;
        _curMainAbility = abi;
    } else if (abiType == AbilityType_First)
    {
        _firstAbilityStr = abi.abiStr;
        _curfirstAbility = abi;
    } else if (abiType == AbilityType_Second)
    {
        _secondAbilityStr = abi.abiStr;
        _curSecondAbility = abi;
    } else if (AbilityType_Other == abiType)
    {
        _otherAbilitiesStr = array;
        NSString* abis = [[NSString alloc] init];
        for(int i = 0; i < _otherAbilitiesStr.count; i++)
        {
            abis = [abis stringByAppendingString:(NSString*)[_otherAbilitiesStr objectAtIndex:i]];
        }
    }
}

-(void)chooseAbility:(UIButton*)btn
{
    CreateTaskAbilitiesController* ctac = [[CreateTaskAbilitiesController alloc] init];
    ctac.delegate = self;
    ctac.otherAbilitiesStrArray = nil;
    ctac.abilityType = btn.tag;
    
    if (btn.tag == AbilityType_Main)
    {
        if (_mainAbilitySelecter == nil)
        {
            _mainAbilitySelecter = [Ability systemAbilities];
        }
        
        if (_curMainAbility != nil)
        {
            ctac.singleAbility = _curMainAbility;
            ctac.singleAbilitySelected = YES;
        } else
        {
            ctac.singleAbility = nil;
            ctac.singleAbilitySelected = NO;
        }
        
        ctac.abilities = _mainAbilitySelecter.childrenAbilities;
        ctac.rootAbility = _mainAbilitySelecter;
    } else if (btn.tag == AbilityType_First)
    {
        if (_firstAbilitySelecter == nil)
        {
            _firstAbilitySelecter = [Ability systemAbilities];
        }
        
        if (_curfirstAbility != nil)
        {
            ctac.singleAbility = _curfirstAbility;
            ctac.singleAbilitySelected = YES;
        } else
        {
            ctac.singleAbility = nil;
            ctac.singleAbilitySelected = NO;
        }
        
        ctac.abilities = _firstAbilitySelecter.childrenAbilities;
        ctac.rootAbility = _firstAbilitySelecter;
    } else if (btn.tag == AbilityType_Second)
    {
        if (_SecondAbilitySelecter == nil)
        {
            _SecondAbilitySelecter = [Ability systemAbilities];
        }
        
        if (_curSecondAbility != nil)
        {
            ctac.singleAbility = _curSecondAbility;
            ctac.singleAbilitySelected = YES;
        } else
        {
            ctac.singleAbility = nil;
            ctac.singleAbilitySelected = NO;
        }
        
        ctac.abilities = _SecondAbilitySelecter.childrenAbilities;
        ctac.rootAbility = _SecondAbilitySelecter;
    }  else if (btn.tag == AbilityType_Other)
    {
        if (_otherAbilitySelecter == nil)
        {
            _otherAbilitySelecter = [Ability systemAbilities];
        }
        
        if (_otherAbilitiesStr != nil)
        {
            ctac.otherAbilitiesStrArray = _otherAbilitiesStr;
        } else
        {
            ctac.otherAbilitiesStrArray = [[NSMutableArray alloc] init];
        }
        
        ctac.abilities = _otherAbilitySelecter.childrenAbilities;
        ctac.rootAbility = _otherAbilitySelecter;
    }
    
    [self.navigationController pushViewController:ctac animated:YES];
}



-(UITableViewCell*)MakeBriefCell
{
    BriefCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"BriefCell" owner:self options:nil] lastObject];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.userInteractionEnabled = YES;
    
    if (_createTaskInfo.Brief == nil)
    {
        [self setTaskItemDefault:cell];
        
        return cell;
    } else
    {
        UILabel* lbTaskBrief = [[UILabel alloc] initWithFrame:CGRectMake(150, 15, 205, 37)];
        NSInteger briefLen = [_createTaskInfo.Brief length];
        lbTaskBrief.text = _createTaskInfo.Brief;
        lbTaskBrief.font = [UIFont systemFontOfSize:13];
        lbTaskBrief.numberOfLines = 0;
        if (briefLen < 29)
        {
            lbTaskBrief.textAlignment = NSTextAlignmentRight;
            _briefCellHeight = ((BriefCell*)[[[NSBundle mainBundle] loadNibNamed:@"BriefCell" owner:self options:nil] lastObject]).frame.size.height;;
        } else
        {
            lbTaskBrief.textAlignment = NSTextAlignmentLeft;
            [lbTaskBrief sizeToFit];
            [lbTaskBrief setFrame:CGRectMake(150, 15, lbTaskBrief.frame.size.width, lbTaskBrief.frame.size.height)];
            _briefCellHeight = lbTaskBrief.frame.size.height+40;
        }
        lbTaskBrief.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
        
        [cell addSubview:lbTaskBrief];
        
        return cell;
    }
    
    return nil;
}

-(UITableViewCell*)MakeTaskLocationCell
{
    TaskLocationCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskLocationCell" owner:self options:nil] lastObject];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.userInteractionEnabled = YES;
    
    if (_createTaskInfo.TaskLocationDescStr == nil)
    {
        [self setTaskItemDefault:cell];
        
        return cell;
    } else
    {
        UILabel* lbTaskLoc = [[UILabel alloc] initWithFrame:CGRectMake(96, 24, 355-96, 21)];
        lbTaskLoc.textAlignment = NSTextAlignmentRight;
        lbTaskLoc.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
        lbTaskLoc.font = [UIFont systemFontOfSize:13];
        
        lbTaskLoc.text = _createTaskInfo.TaskLocationDescStr;
        
        [cell addSubview:lbTaskLoc];
        
        return cell;
    }
    
    return nil;
}

-(UITableViewCell*)MakeStartTimeCell
{
    StartTimeCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"StartTimeCell" owner:self options:nil] lastObject];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.userInteractionEnabled = YES;
    
    if (_createTaskInfo.TaskStartTime == nil)
    {
        [self setTaskItemDefault:cell];
        
        return cell;
    } else
    {
        UILabel* lbTaskStartTime = [[UILabel alloc] initWithFrame:CGRectMake(96, 24, 355-96, 21)];
        lbTaskStartTime.textAlignment = NSTextAlignmentRight;
        lbTaskStartTime.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
        lbTaskStartTime.font = [UIFont systemFontOfSize:13];
        
        lbTaskStartTime.text = _createTaskInfo.TaskStartTime;
        
        [cell addSubview:lbTaskStartTime];
        
        return cell;
    }
    
    return nil;
}

-(UITableViewCell*)MakeResponsersLocationsCell
{
    ResponserLocationsCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"ResponserLocationsCell" owner:self options:nil] lastObject];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.userInteractionEnabled = YES;
    
    if (_createTaskInfo.LocationsDescStrs == nil || _createTaskInfo.Locations == nil
        || _createTaskInfo.LocationsDescStrs.count == 0 || _createTaskInfo.Locations.count == 0)
    {
        [self setTaskItemDefault:cell];
        
        return cell;
    } else
    {
        for (int i = 0; i < _createTaskInfo.LocationsDescStrs.count; i++)
        {
            UILabel* lbLocation = [[UILabel alloc] initWithFrame:CGRectMake(96, 24+(i*10)+((i)*20), 355-96, 20)];
            lbLocation.textAlignment = NSTextAlignmentRight;
            lbLocation.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
            lbLocation.font = [UIFont systemFontOfSize:13];
            lbLocation.text = (NSString*)[_createTaskInfo.LocationsDescStrs objectAtIndex:i];
            
            [cell addSubview:lbLocation];
        }
        
        return cell;
    }
    
    return nil;
}

-(UITableViewCell*)MakeSexCell
{
    TaskSexCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskSexCell" owner:self options:nil] lastObject];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.userInteractionEnabled = YES;
    
    if (_createTaskInfo.Sex == nil)
    {
        [self setTaskItemDefault:cell];
        
        return cell;
    } else
    {
        UILabel* lbTaskSex = [[UILabel alloc] initWithFrame:CGRectMake(96, 24, 355-96, 21)];
        lbTaskSex.textAlignment = NSTextAlignmentRight;
        lbTaskSex.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
        lbTaskSex.font = [UIFont systemFontOfSize:13];
        
        if (_createTaskInfo.Sex.integerValue == 10003)
        {
            lbTaskSex.text = @"男";
        } else if (_createTaskInfo.Sex.integerValue == 10004)
        {
            lbTaskSex.text = @"女";
        } else if (_createTaskInfo.Sex.integerValue == 10005)
        {
            lbTaskSex.text = @"不限性别";
        }
        
        [cell addSubview:lbTaskSex];
        
        return cell;
    }
    
    return nil;
}

-(UITableViewCell*)MakeAgeCell
{
    TaskAgeCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskAgeCell" owner:self options:nil] lastObject];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.userInteractionEnabled = YES;
    
    if (_AgeConfirmed == nil)
    {
        [self setTaskItemDefault:cell];
        
        return cell;
    } else
    {
        UILabel* lbTaskAge = [[UILabel alloc] initWithFrame:CGRectMake(96, 24, 355-96, 21)];
        lbTaskAge.textAlignment = NSTextAlignmentRight;
        lbTaskAge.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
        lbTaskAge.font = [UIFont systemFontOfSize:13];
        
        lbTaskAge.text = [NSString stringWithFormat:@"%ld岁 - %ld岁", _createTaskInfo.AgeMin.integerValue, _createTaskInfo.AgeMax.integerValue];
        
        [cell addSubview:lbTaskAge];
        
        return cell;
    }
    
    return nil;
}

-(CGFloat)MakeAbilitiesCellHeight
{
    return ((AbilitiesOptionCell*)[[[NSBundle mainBundle] loadNibNamed:@"AbilitiesOptionCell" owner:self options:nil] lastObject]).frame.size.height;
}

-(CGFloat)MakeBriefCellHeight
{
    if (_createTaskInfo.Brief == nil)
    {
        return ((BriefCell*)[[[NSBundle mainBundle] loadNibNamed:@"BriefCell" owner:self options:nil] lastObject]).frame.size.height;
    } else
    {
        return _briefCellHeight;
    }
}

-(CGFloat)MakeTaskLocationCellHeight
{
    return ((TaskLocationCell*)[[[NSBundle mainBundle] loadNibNamed:@"TaskLocationCell" owner:self options:nil] lastObject]).frame.size.height;
}

-(CGFloat)MakeStartTimeCellHeight
{
    return ((StartTimeCell*)[[[NSBundle mainBundle] loadNibNamed:@"StartTimeCell" owner:self options:nil] lastObject]).frame.size.height;
}

-(CGFloat)MakeResponsersLocationsCellHeight
{
    NSInteger locNum = 0;
    if (_createTaskInfo.LocationsDescStrs != nil && _createTaskInfo.LocationsDescStrs.count != 0)
    {
          locNum = _createTaskInfo.LocationsDescStrs.count - 1;
    }
    return ((ResponserLocationsCell*)[[[NSBundle mainBundle] loadNibNamed:@"ResponserLocationsCell" owner:self options:nil] lastObject]).frame.size.height+ locNum*30;
}

-(CGFloat)MakeSexCellHeight
{
    return ((TaskSexCell*)[[[NSBundle mainBundle] loadNibNamed:@"TaskSexCell" owner:self options:nil] lastObject]).frame.size.height;
}

-(CGFloat)MakeAgeCellHeight
{
    return ((TaskAgeCell*)[[[NSBundle mainBundle] loadNibNamed:@"TaskAgeCell" owner:self options:nil] lastObject]).frame.size.height;
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
