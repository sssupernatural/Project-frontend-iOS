//
//  CreateTaskAbilitiesController.m
//  Tree
//
//  Created by 施威特 on 2018/4/9.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import "CreateTaskAbilitiesController.h"
#import "CreateTaskController.h"

@interface CreateTaskAbilitiesController ()

@end

@implementation CreateTaskAbilitiesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _allAbisStrArray = [[Ability systemAbilitiesDic] allValues];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:128.0f/255.0f green:138.0f/255.0f blue:135.0f/255.0f alpha:1]];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem* btnSaveAbis = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveAbis)];
    btnSaveAbis.tintColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
    
    self.navigationItem.rightBarButtonItem = btnSaveAbis;
    
    [btnSaveAbis.customView setHidden:YES];
    
    /*
    UIBarButtonItem* btnBack = [[UIBarButtonItem alloc] initWithTitle:@"﹤返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToLast)];
    btnBack.tintColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
    self.navigationItem.leftBarButtonItem = btnBack;
     */
    
    //能力搜索框
    _searchAbility = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 70, self.view.bounds.size.width-20, 55)];
    _searchAbility.barStyle = UIBarStyleDefault;
    _searchAbility.placeholder = @"快速搜索能力";
    _searchAbility.tintColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
    _searchAbility.searchBarStyle = UISearchBarStyleDefault;
    _searchAbility.searchFieldBackgroundPositionAdjustment = UIOffsetMake(0, 9);
    UITextField * searchField = [_searchAbility valueForKey:@"_searchField"];
    [searchField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    searchField.layer.borderWidth = 1;
    searchField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    searchField.layer.cornerRadius = 5.0f;
    _searchAbility.delegate = self;
    if (_searchAbilityBarText != nil)
    {
        _searchAbility.text = _searchAbilityBarText;
    }
    [self removeSearchBackground];
    
    
    //能力选择视图
    CGRect rect = self.view.bounds;
    rect.origin.y += 150;
    rect.size.height -= 150;
    
    _abilitiesTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    _abilitiesTableView.backgroundColor = [UIColor whiteColor];
    
    _abilitiesTableView.delegate = self;
    _abilitiesTableView.dataSource = self;
    
    _abilitiesTableView.sectionHeaderHeight = 50;
    
    //能力快速搜索视图
    _showQuickSearchVC = [[ShowQuickSearhAbisController alloc] init];
    _showQuickSearchVC.delegate = self;
    [self setQuickSearchAbisHidden:YES];
    
    [self.view addSubview:_abilitiesTableView];
    [self.view addSubview:_searchAbility];
    [self.view addSubview:_showQuickSearchVC.view];
}

- (void)setQuickSearchAbisHidden:(BOOL)hidden {
    NSLog(@"HIDEN %d", hidden);
    NSInteger height;
    if (_foundAbisStrArray == nil || _foundAbisStrArray.count == 0)
    {
        height = hidden ? 0: 44*1;
    } else
    {
        if (_foundAbisStrArray.count >= 6)
        {
            height = hidden ? 0: 44*6;
        }else
        {
            height = hidden ? 0: 44*_foundAbisStrArray.count;
        }
    }
    
    NSLog(@"height %ld", height);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    [_showQuickSearchVC.view setFrame:CGRectMake(40, 123, self.view.bounds.size.width-58, height)];
    [UIView commitAnimations];
}

-(void)setSearchAbilityBarText:(NSString*)text
{
    _searchAbility.text = text;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_searchAbility resignFirstResponder];
    [self setQuickSearchAbisHidden:YES];
}

//能力快速搜索栏代理
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"change dasdasdasd!");
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", searchText];
    _foundAbisStrArray = [_allAbisStrArray filteredArrayUsingPredicate:pred];
    
    _showQuickSearchVC.foundAbisNumber = _foundAbisStrArray.count;
    _showQuickSearchVC.foundAbisArray = _foundAbisStrArray;
    _showQuickSearchVC.searchStr = searchText;
    
    [_showQuickSearchVC.tableView reloadData];
    if (searchText == nil || searchText.length == 0)
    {
        [self setQuickSearchAbisHidden:YES];
    } else
    {
        [self setQuickSearchAbisHidden:NO];
    }
}

//能力快速搜索视图代理
-(void)chooseAbi:(NSString *)abiStr
{
    if ([abiStr isEqualToString:@"NOTFOUND"])
    {
        [self setQuickSearchAbisHidden:YES];
        [_searchAbility resignFirstResponder];
        
        return;
    }
    
    NSDictionary* systemAbisDic = [Ability systemAbilitiesDic];
    
    Ability* chooseAbi = [_rootAbility GetAbilityByAbiStr:abiStr withAbisDic:systemAbisDic];
    NSLog(@"CA : %@",chooseAbi);
    
    if (!chooseAbi.selected)
    {
        if (_abilityType != AbilityType_Other)
        {
            if (_singleAbilitySelected)
            {
                UIAlertController* cancelAbiAlert = [UIAlertController alertControllerWithTitle:@"替换能力" message:[NSString stringWithFormat:@"是否将已经选择的能力[%@]替换为能力[%@]", _singleAbility.abiStr, chooseAbi.abiStr] preferredStyle:UIAlertControllerStyleAlert];
                
                [cancelAbiAlert addAction:[UIAlertAction actionWithTitle:@"替换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    chooseAbi.selected = YES;
                    _singleAbility.selected = NO;
                    _singleAbility = chooseAbi;
                    _singleAbilitySelected = YES;
                    
                    [self goToChooseAbiVC:chooseAbi];
                }]];
                
                [cancelAbiAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    return;
                }]];
                
                [self presentViewController:cancelAbiAlert animated:YES completion:nil];
            } else
            //if(!_singleAbilitySelected)
            {
                chooseAbi.selected = YES;
                _singleAbility = chooseAbi;
                _singleAbilitySelected = YES;
                
                [self goToChooseAbiVC:chooseAbi];
            }
        }else
        //if(_abilityType == AbilityType_Other)
        {
            NSLog(@"cccc: %@", chooseAbi.abiStr);
            if (_otherAbilitiesStrArray == nil)
            {
                NSLog(@"ASDSAD");
            } else
            {
                NSLog(@"ppp:%ld",_otherAbilitiesStrArray.count);
            }
            chooseAbi.selected = YES;
            [_otherAbilitiesStrArray addObject:chooseAbi.abiStr];
            
            [self goToChooseAbiVC:chooseAbi];
        }
    } else
    {
        if ([self.navigationItem.title isEqualToString:chooseAbi.parentAbi.abiStr])
        {
            _searchAbility.text = abiStr;
            [self setQuickSearchAbisHidden:YES];
            [_searchAbility resignFirstResponder];
            _searchAbility.text = chooseAbi.abiStr;
        } else
        {
            [self goToChooseAbiVC:chooseAbi];
        }
    }
}

-(void)goToChooseAbiVC:(Ability*)abi
{
    CreateTaskAbilitiesController* ctac = [[CreateTaskAbilitiesController alloc] init];
    ctac.navigationItem.title = abi.parentAbi.abiStr;
    ctac.delegate = self.delegate;
    ctac.rootAbility = _rootAbility;
    ctac.singleAbility = _singleAbility;
    ctac.otherAbilitiesStrArray = _otherAbilitiesStrArray;
    ctac.abilityType = _abilityType;
    ctac.singleAbilitySelected = _singleAbilitySelected;
    ctac.abilities = abi.parentAbi.childrenAbilities;
    ctac.searchAbilityBarText = abi.abiStr;
    [self.navigationController pushViewController:ctac animated:YES];
}

-(void)backToLast
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)removeSearchBackground
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if ([_searchAbility respondsToSelector:@selector(barTintColor)]) {
        float iosversion7_1 = 7.1;
        if (version >= iosversion7_1){
            
            [[[[_searchAbility.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
            [_searchAbility setBackgroundColor:[UIColor clearColor]];
            
        }else {            //iOS7.0
            [_searchAbility setBarTintColor:[UIColor clearColor]];
            [_searchAbility setBackgroundColor:[UIColor clearColor]];
        }
    }else {
        //iOS7.0以下
        [[_searchAbility.subviews objectAtIndex:0] removeFromSuperview];
        
        [_searchAbility setBackgroundColor:[UIColor clearColor]];
    }
}

//
-(void)saveAbis
{
    //通过代理设置活动创建控制器中的能力选项参数
    [_delegate confirmAbilitiesWithType:_abilityType andSingleAbi:_singleAbility andOtherAbisStr:_otherAbilitiesStrArray];
    
    UINavigationController* nav = self.navigationController;
    NSMutableArray* vcs = [[NSMutableArray alloc] init];
    for(UIViewController* v in [nav viewControllers])
    {
        [vcs addObject:v];
        if ([v isKindOfClass:[CreateTaskController class]])
        {
            break;
        }
    }
    
    [nav setViewControllers:vcs animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSArray* subViews = [_abilitiesTableView subviews];
    for (id subview in subViews)
    {
        if ([subview isKindOfClass:[UITableViewCell class]])
        {
            UITableViewCell* cell = (UITableViewCell*)subview;
            NSArray* abiBtnViews = [cell subviews];
            for (id view in abiBtnViews)
            {
                if ([view isKindOfClass:[UIButton class]])
                {
                    UIButton* btn = (UIButton*)view;
                    Ability* abi = (Ability*)[_abilities objectAtIndex:btn.tag];
                    
                    if (abi.selected == YES)
                    {
                        [btn setSelected:YES];
                    } else
                    {
                        [btn setSelected:NO];
                    }
                }
            }
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int numberOfBtnsInRow = 3;
    int buttonDistence = 30;
    int buttonHeight = 50;
    return (((_abilities.count-1) / numberOfBtnsInRow) + 1) * (buttonHeight+buttonDistence) + (buttonDistence);
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"单击 → 选中能力                                     双击 → 选择子能力";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize mainsize = [UIScreen mainScreen].bounds.size;
    int numberOfBtnsInRow = 3;
    int buttonDistence = 30;
    int buttonWidth = (mainsize.width - (numberOfBtnsInRow+1)*buttonDistence)/numberOfBtnsInRow;
    int buttonHeight = 50;
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    for (int i = 0; i < _abilities.count; i++)
    {
        UIButton* abiBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //设置按钮边框
        [abiBtn.layer setBorderColor:[UIColor colorWithRed:128.0f/255.0f green:138.0f/255.0f blue:135.0f/255.0f alpha:1].CGColor];
        [abiBtn.layer setBorderWidth:1];
        [abiBtn.layer setMasksToBounds:YES];
        
        //设置按钮普通状态下的文字颜色
        [abiBtn setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
        
        //设置按钮圆角
        [abiBtn.layer setCornerRadius:5];
        
        
        //设置按钮选中时的背景色和文字色
        [abiBtn setBackgroundImage:[CreateTaskAbilitiesController imageWithColor:[UIColor colorWithRed:61.0f/255.0f green:145.0f/255.0f blue:64.0f/255.0f alpha:0.99]] forState:UIControlStateSelected];
        [abiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        //设置按钮位置大小
        [abiBtn setFrame:CGRectMake(buttonDistence*((i%numberOfBtnsInRow)+1) + buttonWidth*(i%numberOfBtnsInRow),
                                    buttonDistence*((i/numberOfBtnsInRow)+1) + buttonHeight*(i/numberOfBtnsInRow),
                                    buttonWidth, buttonHeight)];
        
        //设置按钮文字
        Ability* curAbi = (Ability*)[_abilities objectAtIndex:i];
        [abiBtn setTitle:curAbi.abiStr forState:UIControlStateNormal];
        
        //设置按钮状态
        if (curAbi.selected == YES)
        {
            [abiBtn setSelected:YES];
        } else
        {
            [abiBtn setSelected:NO];
        }
        
        //设置按钮tap与该能力在能力数组中的索引一致
        abiBtn.tag = i;
        
        //为能力按钮添加"单击"事件
        [abiBtn addTarget:self action:@selector(abiBtnOneTapAction:) forControlEvents:UIControlEventTouchDown];
        
        //为能力按钮添加"双击"事件
        [abiBtn addTarget:self action:@selector(abiBtnTwoTapAction:) forControlEvents:UIControlEventTouchDownRepeat];
        
        //添加按钮
        [cell addSubview:abiBtn];
    }
    
    return cell;
}

//能力按钮单击事件
-(void)abiBtnOneTapAction:(id)sender
{
    [self performSelector:@selector(abiBtnSelected:) withObject:sender afterDelay:0.3];
}

//能力按钮双击事件
-(void)abiBtnTwoTapAction:(id)sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(abiBtnSelected:) object:sender];
    
    [self abiBtnGoToChildrenAbis:sender];
}

//能力选中事件
-(void)abiBtnSelected:(id)sender
{
    UIButton* abiBtn = (UIButton*)sender;
    Ability* abi = (Ability*)[_abilities objectAtIndex:abiBtn.tag];
    if (!abiBtn.selected)
    {
        if (_abilityType != AbilityType_Other)
        {
            if (_singleAbilitySelected)
            {
                UIAlertController* cancelAbiAlert = [UIAlertController alertControllerWithTitle:@"替换能力" message:[NSString stringWithFormat:@"是否将已经选择的能力[%@]替换为能力[%@]", _singleAbility.abiStr, abi.abiStr] preferredStyle:UIAlertControllerStyleAlert];
                
                [cancelAbiAlert addAction:[UIAlertAction actionWithTitle:@"替换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    abi.selected = YES;
                    _singleAbility.selected = NO;
                    _singleAbility = abi;
                    _singleAbilitySelected = YES;
                    [self performSelectorOnMainThread:@selector(reloadAbilitiesView) withObject:nil waitUntilDone:nil];
                }]];
                
                [cancelAbiAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    return;
                }]];
                
                [self presentViewController:cancelAbiAlert animated:YES completion:nil];
            } else
            {
                [abiBtn setSelected:YES];
                abi.selected = YES;
                _singleAbility = abi;
                _singleAbilitySelected = YES;
            }
        }else
        {
            [abiBtn setSelected:YES];
            abi.selected = YES;
            [_otherAbilitiesStrArray addObject:abi.abiStr];
        }
    } else
    {
        [abiBtn setSelected:NO];
        abi.selected = NO;
        
        if (_abilityType != AbilityType_Other)
        {
            _singleAbilitySelected = NO;
            _singleAbility = nil;
        } else
        {
            for (int i = 0; i < _otherAbilitiesStrArray.count; i++)
            {
                NSString* str = (NSString*)[_otherAbilitiesStrArray objectAtIndex:i];
                if ([str isEqualToString:abi.abiStr])
                {
                    [_otherAbilitiesStrArray removeObjectAtIndex:i];
                }
            }
        }
    }
}

-(void)reloadAbilitiesView
{
    [_abilitiesTableView reloadData];
}

//选择子能力事件
-(void)abiBtnGoToChildrenAbis:(id)sender
{
    UIButton* abiBtn = (UIButton*)sender;
    Ability* curAbi =(Ability*)[_abilities objectAtIndex:abiBtn.tag];
    if (curAbi.childrenAbilities.count == 0)
    {
        return;
    }
    Ability* child = (Ability*)[curAbi.childrenAbilities firstObject];
    [self goToChooseAbiVC:child];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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
