//
//  MeEditAbisController.m
//  Tree
//
//  Created by 施威特 on 2017/11/28.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "MeEditAbisController.h"
#import "AppDelegate.h"

@interface MeEditAbisController ()

@end

@implementation MeEditAbisController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:128.0f/255.0f green:138.0f/255.0f blue:135.0f/255.0f alpha:1]];
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationItem.hidesBackButton = NO;
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem* btnSaveAbis = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveAbis)];
    
    self.navigationItem.rightBarButtonItem = btnSaveAbis;
    
    [btnSaveAbis.customView setHidden:YES];
    
    _abilitiesTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    _abilitiesTableView.delegate = self;
    _abilitiesTableView.dataSource = self;
    
    _abilitiesTableView.sectionHeaderHeight = 50;
    
    [self.view addSubview:_abilitiesTableView];
}

//
-(void)saveAbis
{
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    delegate.AppUserInfo.Abilities = [delegate.appAbilities ConstructAbisHeap];
    
    UserInfo* ui = delegate.AppUserInfo;
    
    [ui UpdateUserInfo];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    /*
    NSDictionary* uiDic = @{
                            @"ID" : ui.ID,
                            @"PhoneNumer" : ui.PhoneNumber,
                            @"Name" : ui.Name,
                            @"Status" : ui.Status,
                            @"Sex" : ui.Sex,
                            @"Age" : ui.Age,
                            @"Abilities" : @{
                                    @"ABIs" : [ui.Abilities AbisHeapJsonArray],
                                    }
                            };
    
    NSData* uiData = [NSJSONSerialization dataWithJSONObject:uiDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSDictionary* respDic = [NSJSONSerialization JSONObjectWithData:uiData options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"dic = %@", respDic);
     */
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
        [abiBtn setBackgroundImage:[MeEditAbisController imageWithColor:[UIColor colorWithRed:61.0f/255.0f green:145.0f/255.0f blue:64.0f/255.0f alpha:0.99]] forState:UIControlStateSelected];
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
        [abiBtn setSelected:YES];
        abi.selected = YES;
        [abi SelectParentAbis];
    } else
    {
        if ([abi ChildAbiIsSelected])
        {   
            UIAlertController* cancelAbiAlert = [UIAlertController alertControllerWithTitle:@"取消能力" message:[NSString stringWithFormat:@"取消能力[%@]将会同时取消该能力下的所有子能力", abi.abiStr] preferredStyle:UIAlertControllerStyleAlert];
            
            [cancelAbiAlert addAction:[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [abiBtn setSelected:NO];
                abi.selected = NO;
                [abi CancelChildrenAbisSelect];
            }]];
            
            [cancelAbiAlert addAction:[UIAlertAction actionWithTitle:@"停止" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                return;
            }]];
            
            [self presentViewController:cancelAbiAlert animated:YES completion:nil];
        } else
        {
            [abiBtn setSelected:NO];
            abi.selected = NO;
        }
    }
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
    MeEditAbisController* editsChildrenAbis = [[MeEditAbisController alloc] initWithAbis:curAbi.childrenAbilities];
    editsChildrenAbis.navigationItem.title = curAbi.abiStr;
    [self.navigationController pushViewController:editsChildrenAbis animated:YES];
    
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

-(MeEditAbisController*)initWithAbis:(NSMutableArray*)abis
{
    _abilities = abis;
    
    return self;
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
