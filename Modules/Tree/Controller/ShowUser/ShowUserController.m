//
//  ShowUserController.m
//  Tree
//
//  Created by 施威特 on 2018/1/23.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import "ShowUserController.h"
#import "../../View/ShowUser/ShowUserAbilitiesOptionCell.h"
#import "AbiNode.h"

@interface ShowUserController ()

@end

@implementation ShowUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
     
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
    
    [self caculateAbiBtnParams];
    
    _showUserAbisAll = YES;
    
    _LB_UserName.text = _userInfo.Name;
    _IV_UserPic.image = [UIImage imageNamed:@"tree.jpeg"];
    
    _userInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+150, self.view.bounds.size.width, self.view.bounds.size.height-150) style:UITableViewStyleGrouped];
    
    _userInfoTableView.showsHorizontalScrollIndicator = NO;
    _userInfoTableView.showsVerticalScrollIndicator = NO;
    
    [_userInfoTableView setBackgroundColor:[UIColor whiteColor]];
    
    //[_UserTasksTableView setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
    
    _userInfoTableView.delegate = self;
    _userInfoTableView.dataSource = self;
    
    [self.view addSubview:_userInfoTableView];
    
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return [self MakeUserInfoCellWithType:@"状态" andValue:[_userInfo UserStatusStr]];
        } else if (indexPath.row == 1)
        {
            return [self MakeUserInfoCellWithType:@"性别" andValue:[_userInfo UserSexStr]];
        } else if (indexPath.row == 2)
        {
            return [self MakeUserInfoCellWithType:@"年龄" andValue:[_userInfo UserAgeStr]];
        }
    } else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            return [self MakeUserAbisOptionCell];
        } else if (indexPath.row == 1)
        {
            return [self MakeUserAbliltiesCell];
        }
        
    } else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            return [self MakeUserLocationsCell];
        }
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 70;
    } else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            return 70;
        } else if (indexPath.row == 1)
        {
            if (_showUserAbisAll == YES)
            {
                NSInteger emptyAbi = 0;
                for (int i = 0; i < _userInfo.Abilities.ABIs.count; i++)
                {
                    if (((AbiNode*)[_userInfo.Abilities.ABIs objectAtIndex:i]).ABI == nil || [((AbiNode*)[_userInfo.Abilities.ABIs objectAtIndex:i]).ABI isEqualToString:@""])
                    {
                        emptyAbi++;
                    }
                }
                NSInteger addLine = 0;
                if ((_userInfo.Abilities.ABIs.count - emptyAbi) % _numOfAbisInRow == 0)
                {
                    addLine = 0;
                } else
                {
                    addLine = 1;
                }
                return ((_userInfo.Abilities.ABIs.count - emptyAbi) / _numOfAbisInRow + addLine + 1) * _hsp + ((_userInfo.Abilities.ABIs.count - emptyAbi) / _numOfAbisInRow + addLine) * _abiHeight;
            } else if (_showUserAbisAll == NO)
            {
                NSMutableArray* endIndexesArray = [_userInfo.Abilities AbisEndNodeIndexes];
                NSInteger emptyAbi = 0;
                for (int i = 0; i < endIndexesArray.count; i++)
                {
                    if (((AbiNode*)[_userInfo.Abilities.ABIs objectAtIndex:(((NSNumber*)[endIndexesArray objectAtIndex:i]).integerValue)]).ABI == nil || [((AbiNode*)[_userInfo.Abilities.ABIs objectAtIndex:(((NSNumber*)[endIndexesArray objectAtIndex:i]).integerValue)]).ABI isEqualToString:@""])
                    {
                        emptyAbi++;
                    }
                }
                NSInteger addLine = 0;
                if ((endIndexesArray.count - emptyAbi) % _numOfAbisInRow == 0)
                {
                    addLine = 0;
                } else
                {
                    addLine = 1;
                }
                return ((endIndexesArray.count - emptyAbi) / _numOfAbisInRow + addLine + 1) * _hsp + ((endIndexesArray.count - emptyAbi) / _numOfAbisInRow + addLine) * _abiHeight;
            }
        }
    } else if (indexPath.section == 2)
    {
        return 70;
    }
    
    return 70;
}

-(UITableViewCell*)MakeUserInfoCellWithType:(NSString*)type andValue:(NSString*)value
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.frame = CGRectMake(0, 0, 364, 70);
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UILabel* lbType = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, 75, 21)];
    lbType.text = type;
    lbType.textAlignment = NSTextAlignmentRight;
    lbType.font = [UIFont systemFontOfSize:13];
    lbType.textColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
    [cell addSubview:lbType];
    
    UILabel* lbValue = [[UILabel alloc] initWithFrame:CGRectMake(242, 24, 106, 21)];
    lbValue.text = value;
    lbValue.textAlignment = NSTextAlignmentRight;
    lbValue.font = [UIFont systemFontOfSize:13];
    lbValue.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
    [cell addSubview:lbValue];
    
    return cell;
}

-(ShowUserAbilitiesOptionCell*)MakeUserAbisOptionCell
{
    ShowUserAbilitiesOptionCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"ShowUserAbilitiesOptionCell" owner:self options:nil] lastObject];
    
    if (_showUserAbisAll == YES)
    {
        cell.SC_ShowUserAbisoption.selectedSegmentIndex = 0;
    } else {
        cell.SC_ShowUserAbisoption.selectedSegmentIndex = 1;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.SC_ShowUserAbisoption addTarget:self action:@selector(ShowAbisOptionValueChange:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

-(UITableViewCell*)MakeUserAbliltiesCell
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (_showUserAbisAll == YES)
    {
        for (int i = 0, j = 0; i < _userInfo.Abilities.ABIs.count; i++)
        {
            if (((AbiNode*)[_userInfo.Abilities.ABIs objectAtIndex:i]).ABI == nil || [((AbiNode*)[_userInfo.Abilities.ABIs objectAtIndex:i]).ABI isEqualToString:@""])
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
            [btnAbi setTitle:((AbiNode*)[_userInfo.Abilities.ABIs objectAtIndex:i]).ABI forState:UIControlStateNormal];
            btnAbi.titleLabel.font = [UIFont systemFontOfSize:12];
            [btnAbi.layer setBorderColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1].CGColor];
            [btnAbi.layer setBorderWidth:0.3];
            [btnAbi setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
            
            [cell addSubview:btnAbi];
            
            j++;
        }
    } else if (_showUserAbisAll == NO)
    {
        NSMutableArray* endIndexesArray = [_userInfo.Abilities AbisEndNodeIndexes];
        
        for (int i = 0, j = 0; i < endIndexesArray.count; i++)
        {
            if (((AbiNode*)[_userInfo.Abilities.ABIs objectAtIndex:(((NSNumber*)[endIndexesArray objectAtIndex:i]).integerValue)]).ABI == nil || [((AbiNode*)[_userInfo.Abilities.ABIs objectAtIndex:(((NSNumber*)[endIndexesArray objectAtIndex:i]).integerValue)]).ABI isEqualToString:@""])
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
            [btnAbi setTitle:((AbiNode*)[_userInfo.Abilities.ABIs objectAtIndex:(((NSNumber*)[endIndexesArray objectAtIndex:i]).integerValue)]).ABI forState:UIControlStateNormal];
            btnAbi.titleLabel.font = [UIFont systemFontOfSize:12];
            [btnAbi.layer setBorderColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1].CGColor];
            [btnAbi.layer setBorderWidth:0.3];
            [btnAbi setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
            
            [cell addSubview:btnAbi];
            
            j++;
        }
    }
    
    return cell;
}

-(UITableViewCell*)MakeUserLocationsCell
{
    return [self MakeUserInfoCellWithType:@"" andValue:@""];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _userInfo.Name;
            break;
        case 1:
            return @"能力";
            break;
        case 2:
            return @"位置";
            break;
            
        default:
            return nil;
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

-(void)ShowAbisOptionValueChange:(UISegmentedControl*)sc
{
    if (sc.selectedSegmentIndex == 0)
    {
        _showUserAbisAll = YES;
    } else
    {
        _showUserAbisAll = NO;
    }
    
    [_userInfoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:1], nil] withRowAnimation:UITableViewRowAnimationFade];
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
