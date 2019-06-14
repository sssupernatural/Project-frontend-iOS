//
//  ShowAbilitiesController.m
//  Tree
//
//  Created by 施威特 on 2017/12/22.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "ShowAbilitiesController.h"
#import "AppDelegate.h"
#import "TaskInfo.h"
#import "AbiNode.h"

@interface ShowAbilitiesController ()

@end

@implementation ShowAbilitiesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
    
    _task = [self getTaskInfoByTaskTag];
    
    [self caculateAbiBtnParams];
    
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
    
    _abilitiesTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+120, self.view.bounds.size.width, self.view.bounds.size.height-120) style:UITableViewStyleGrouped];
    
    _abilitiesTableView.showsHorizontalScrollIndicator = NO;
    _abilitiesTableView.showsVerticalScrollIndicator = NO;
    
    [_abilitiesTableView setBackgroundColor:[UIColor whiteColor]];
    
    _abilitiesTableView.delegate = self;
    _abilitiesTableView.dataSource = self;
    
    [self.view addSubview:_abilitiesTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger mainAbiIndex = [((NSNumber*)[_task.Desc.ImportanceArray objectAtIndex:0]) unsignedLongValue];
    NSUInteger firstAbiIndex = [((NSNumber*)[_task.Desc.ImportanceArray objectAtIndex:1]) unsignedLongValue];
    NSUInteger secondAbiIndex = [((NSNumber*)[_task.Desc.ImportanceArray objectAtIndex:2]) unsignedLongValue];
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIButton* btnMainAbi = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnMainAbi.frame = CGRectMake(_wsp, _hsp, _abiWidth, _abiHeight);
        [btnMainAbi.layer setCornerRadius:4];
        [btnMainAbi.layer setMasksToBounds:YES];
        [btnMainAbi setTitle:((AbiNode*)[_task.Desc.Abilities.ABIs objectAtIndex:mainAbiIndex]).ABI forState:UIControlStateNormal];
        [btnMainAbi.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
        [btnMainAbi.layer setBorderWidth:0.3];
        [btnMainAbi setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btnMainAbi.titleLabel.font = [UIFont systemFontOfSize:12];
        
        UIButton* btnFirstAbi = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnFirstAbi.frame = CGRectMake(_wsp*2+_abiWidth, _hsp, _abiWidth, _abiHeight);
        [btnFirstAbi.layer setCornerRadius:4];
        [btnFirstAbi.layer setMasksToBounds:YES];
        [btnFirstAbi setTitle:((AbiNode*)[_task.Desc.Abilities.ABIs objectAtIndex:firstAbiIndex]).ABI forState:UIControlStateNormal];
        [btnFirstAbi.layer setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1].CGColor];
        [btnFirstAbi.layer setBorderWidth:0.3];
        [btnFirstAbi setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btnFirstAbi.titleLabel.font = [UIFont systemFontOfSize:12];
        
        UIButton* btnSecondAbi = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnSecondAbi.frame = CGRectMake(_wsp*3+_abiWidth*2, _hsp, _abiWidth, _abiHeight);
        [btnSecondAbi.layer setCornerRadius:4];
        [btnSecondAbi.layer setMasksToBounds:YES];
        [btnSecondAbi setTitle:((AbiNode*)[_task.Desc.Abilities.ABIs objectAtIndex:secondAbiIndex]).ABI forState:UIControlStateNormal];
        [btnSecondAbi.layer setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1].CGColor];
        [btnSecondAbi.layer setBorderWidth:0.3];
        [btnSecondAbi setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        btnSecondAbi.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [cell addSubview:btnMainAbi];
        [cell addSubview:btnFirstAbi];
        [cell addSubview:btnSecondAbi];
        
        return cell;
        
    } else if (indexPath.section == 1 && indexPath.row == 0)
    {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        for (int i = 0, j = 0; i < _task.Desc.Abilities.ABIs.count; i++)
        {
            if (i == mainAbiIndex || i == firstAbiIndex || i == secondAbiIndex)
            {
                continue;
            }
            
            if (((AbiNode*)[_task.Desc.Abilities.ABIs objectAtIndex:i]).ABI == nil || [((AbiNode*)[_task.Desc.Abilities.ABIs objectAtIndex:i]).ABI isEqualToString:@""])
            {
                continue;
            }
            
            UIButton* btnAbi = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btnAbi.frame = CGRectMake((j%_numOfAbisInRow+1)*_wsp+(j%_numOfAbisInRow)*_abiWidth,
                                      (j/_numOfAbisInRow+1)*_hsp+(j/_numOfAbisInRow)*_abiHeight,
                                      _abiWidth,
                                      _abiHeight);
            [btnAbi.layer setCornerRadius:4];
            [btnAbi.layer setMasksToBounds:YES];
            [btnAbi setTitle:((AbiNode*)[_task.Desc.Abilities.ABIs objectAtIndex:i]).ABI forState:UIControlStateNormal];
            btnAbi.titleLabel.font = [UIFont systemFontOfSize:12];
            [btnAbi.layer setBorderColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1].CGColor];
            [btnAbi.layer setBorderWidth:0.3];
            [btnAbi setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
            
            [cell addSubview:btnAbi];
            
            j++;
        }
        
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return _hsp*2+_abiHeight;
    } else if (indexPath.section == 1 && indexPath.row == 0)
    {
        NSInteger emptyAbi = 0;
        for (int i = 0; i < _task.Desc.Abilities.ABIs.count; i++)
        {
            if (((AbiNode*)[_task.Desc.Abilities.ABIs objectAtIndex:i]).ABI == nil || [((AbiNode*)[_task.Desc.Abilities.ABIs objectAtIndex:i]).ABI isEqualToString:@""])
            {
                emptyAbi++;
            }
        }
        NSInteger addLine = 0;
        if ((_task.Desc.Abilities.ABIs.count - 3 - emptyAbi) % _numOfAbisInRow == 0)
        {
            addLine = 0;
        } else
        {
            addLine = 1;
        }
        return ((_task.Desc.Abilities.ABIs.count - 3 - emptyAbi) / _numOfAbisInRow + addLine + 1) * _hsp + ((_task.Desc.Abilities.ABIs.count - 3 - emptyAbi) / _numOfAbisInRow + addLine) * _abiHeight;
    }
    
    return 100;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"主要能力";
    } else if (section == 1)
    {
        return @"其他能力";
    }
    
    return nil;
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

-(void)caculateAbiBtnParams
{
    CGRect mainFrame = [UIScreen mainScreen].bounds;
    _numOfAbisInRow = 3;
    _wn = 3;
    _hn = 1;
    
    _abiWidth = mainFrame.size.width * _wn / ((_wn+1)*_numOfAbisInRow + 1);
    _wsp = _abiWidth / _wn;
    _abiHeight = _abiWidth/12*5;
    _hsp = _abiHeight/ _hn;
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
