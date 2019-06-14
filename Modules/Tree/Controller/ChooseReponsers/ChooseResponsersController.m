//
//  ChooseResponsersController.m
//  Tree
//
//  Created by 施威特 on 2018/5/10.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import "ChooseResponsersController.h"
#import "ShowUserController.h"
#import "TaskAction.h"
#import "UserInfo.h"
#import "TreeController.h"

@interface ChooseResponsersController ()

@end

@implementation ChooseResponsersController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
    
    [self.Btn_ConfirmResponsers.layer setBorderWidth:1];
    [self.Btn_ConfirmResponsers.layer setMasksToBounds:YES];
    [self.Btn_ConfirmResponsers.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
    [self.Btn_ConfirmResponsers setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [self.Btn_ConfirmResponsers addTarget:self action:@selector(confirmResponsers) forControlEvents:UIControlEventTouchUpInside];
    
    _chooseIndexes = [[NSMutableArray alloc] init];
    
    _chooseResponsersTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+150, self.view.bounds.size.width, self.view.bounds.size.height-150) style:UITableViewStyleGrouped];
    
    _chooseResponsersTableView.showsHorizontalScrollIndicator = NO;
    _chooseResponsersTableView.showsVerticalScrollIndicator = NO;
    
    [_chooseResponsersTableView setBackgroundColor:[UIColor whiteColor]];
    
    //[_UserTasksTableView setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
    
    _chooseResponsersTableView.delegate = self;
    _chooseResponsersTableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:_chooseResponsersTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_info.Responsers == nil || _info.Responsers.count == 0)
    {
        return 1;
    } else
    {
        return _info.Responsers.count;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"点击选择（取消选择）响应者";
    }
    
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ((_info.Responsers == nil || _info.Responsers.count == 0) && indexPath.row == 0)
    {
        UILabel* lbTaskNoResponser = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, 205, 37)];
        lbTaskNoResponser.textAlignment = NSTextAlignmentRight;
        lbTaskNoResponser.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
        lbTaskNoResponser.font = [UIFont systemFontOfSize:13];
        lbTaskNoResponser.text = @"当前没有响应者";
        
        [cell addSubview:lbTaskNoResponser];
    } else
    {
        UserInfo* u = (UserInfo*)[_info.Responsers objectAtIndex:indexPath.row];
        UILabel* lbTaskResponserName = [[UILabel alloc] initWithFrame:CGRectMake(0, 26, 95, 21)];
        lbTaskResponserName.textAlignment = NSTextAlignmentRight;
        lbTaskResponserName.textColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1];
        lbTaskResponserName.font = [UIFont systemFontOfSize:13];
        lbTaskResponserName.text = u.Name;
        
        UITapGestureRecognizer* userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLabelUser:)];
        [userTap setNumberOfTouchesRequired:1];
        [userTap setNumberOfTapsRequired:1];
        
        lbTaskResponserName.userInteractionEnabled = YES;
        lbTaskResponserName.tag = indexPath.row;
        [lbTaskResponserName addGestureRecognizer:userTap];
        
        UILabel* lbSymbol = [[UILabel alloc] initWithFrame:CGRectMake(101, 11, 16, 52)];
        lbSymbol.textAlignment = NSTextAlignmentLeft;
        lbSymbol.textColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
        lbSymbol.font = [UIFont systemFontOfSize:20];
        lbSymbol.text = @"I";
        
        UIImageView* ivUserPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tree.jpeg"]];
        ivUserPic.frame = CGRectMake(116, 11, 100, 49);
        ivUserPic.layer.cornerRadius = 5;
        ivUserPic.layer.masksToBounds = YES;
        
        [cell addSubview:ivUserPic];
        [cell addSubview:lbSymbol];
        [cell addSubview:lbTaskResponserName];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [_chooseResponsersTableView cellForRowAtIndexPath:indexPath];
    for (NSNumber* row in _chooseIndexes)
    {
        if (row.integerValue == indexPath.row)
        {
            [_chooseIndexes removeObject:row];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            return;
        }
    }
    
    [_chooseIndexes addObject:[NSNumber numberWithInteger:indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    return;
}

-(void)clickLabelUser:(UIGestureRecognizer*)gesture
{
    [self showUserViewWithUserInfo:(UserInfo*)[_info.Responsers objectAtIndex:gesture.view.tag]];
    
    return ;
}

-(void)showUserViewWithUserInfo:(UserInfo*)user
{
    ShowUserController* su = [[ShowUserController alloc] init];
    
    su.userInfo = user;
    
    [self.navigationController pushViewController:su animated:YES];
}

-(void)confirmResponsers
{
    TaskAction* chooseResponsers = [[TaskAction alloc] init];
    chooseResponsers.Action = @"CHOOSE";
    chooseResponsers.TaskID = _info.ID;
    chooseResponsers.ChosenResponserIDs = [[NSMutableArray alloc] init];
    
    for (NSNumber* index in _chooseIndexes)
    {
        UserInfo* u = [_info.Responsers objectAtIndex:index.integerValue];
        NSNumber* curUid = [NSNumber numberWithInteger:u.ID.integerValue];
        [chooseResponsers.ChosenResponserIDs addObject:curUid];
    }
    
    NSDictionary* chooseDic = [chooseResponsers GenerateTaskActionJsonDic];
    
    NSData* chooseData = [NSJSONSerialization dataWithJSONObject:chooseDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString* tasksURL = @CUR_SERVER_URL_TASKS;
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest* chooseRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:tasksURL parameters:nil error:nil];
    [chooseRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [chooseRequest setHTTPBody:chooseData];
    
    AFHTTPResponseSerializer* respSerializer = [AFHTTPResponseSerializer serializer];
    respSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                             @"text/html",
                                             @"text/json",
                                             @"text/javascript",
                                             @"text/plain", nil];
    
    manager.responseSerializer = respSerializer;
    
    [[manager dataTaskWithRequest:chooseRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"err = %@!", error);
        } else {
            NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
            if (rsp.statusCode == 200)
            {
                UINavigationController* nav = self.navigationController;
                NSMutableArray* vcs = [[NSMutableArray alloc] init];
                for(UIViewController* v in [nav viewControllers])
                {
                    [vcs addObject:v];
                    if ([v isKindOfClass:[TreeController class]])
                    {
                        break;
                    }
                }
                
                [nav setViewControllers:vcs animated:YES];
            } else
            {
                UIAlertController* failedAlert = [UIAlertController alertControllerWithTitle:@"选择响应者信息" message:[NSString stringWithFormat:@"选择响应者失败，请重试。错误码为%ld", rsp.statusCode] preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:failedAlert animated:YES completion:nil];
                
                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(chooseResponsersFailed:) userInfo:failedAlert repeats:NO];
            }
        }
    }] resume];
}

-(void)chooseResponsersFailed:(NSTimer*)timer
{
    UIAlertController *alert = [timer userInfo];
    
    [alert dismissViewControllerAnimated:YES completion:nil];
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
