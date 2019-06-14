//
//  MeController.m
//  Tree
//
//  Created by 施威特 on 2017/11/15.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "MeController.h"
#import "MeInfoTextCell.h"
#import "MeInfoProfilePicCell.h"
#import "MeInfoAbilitiesCell.h"
#import "MeEditableInfoTextCell.h"
#import "MeInfoSimpleTextCell.h"
#import "AppDelegate.h"
#import "MeEditAbisController.h"
#import "Ability.h"
#import "MeEditNameController.h"
#import "MeEditSexController.h"
#import "MeEditAgeController.h"
#import "MeEditLocationsController.h"
#import "AFNetworking.h"
#import "EnterController.h"

@interface MeController ()

@end

@implementation MeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tabBarItem.title = @"我";
    
    self.navigationController.navigationBar.hidden = NO;
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _AppUserInfo = delegate.AppUserInfo;
    
    if (_AppUserInfo.Abilities == nil)
    {
        delegate.appAbilities = [Ability systemAbilities];
    } else {
        delegate.appAbilities = [Ability UserAbilitiesWithAbisStrArray:[_AppUserInfo.Abilities AbisStrArray]];
    }
    
    [self makeMeInfoCellArray];
    
    _MeInfoTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    _MeInfoTableView.delegate = self;
    _MeInfoTableView.dataSource = self;

    _MeInfoTableView.scrollEnabled = NO;
    
    [self.view addSubview:_MeInfoTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self performSelectorOnMainThread:@selector(reloadMeInfo) withObject:nil waitUntilDone:nil];
}

-(void)reloadMeInfo
{
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _AppUserInfo = delegate.AppUserInfo;
    
    [self makeMeInfoCellArray];
    
    [_MeInfoTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeMeInfoCellArray {
    _MeInfoCellArray = [[NSMutableArray alloc] init];
    _MeInfoCellHeightArray = [[NSMutableArray alloc] init];
    
    [_MeInfoCellArray addObject:[self makeProfilePicCell]];
    [_MeInfoCellHeightArray addObject:[NSNumber numberWithDouble:[self makeProfilePicCellHeight]]];
    _profilePicCellIndex = 0;
    
    [_MeInfoCellArray addObject:[self makeTreeIDCell]];
    [_MeInfoCellHeightArray addObject:[NSNumber numberWithDouble:[self makeTreeIDCellHeight]]];
    
    [_MeInfoCellArray addObject:[self makeUserNameCell]];
    [_MeInfoCellHeightArray addObject:[NSNumber numberWithDouble:[self makeUserNameCellHeight]]];
    _userNameCellIndex = 2;
    
    [_MeInfoCellArray addObject:[self makeUserSexCell]];
    [_MeInfoCellHeightArray addObject:[NSNumber numberWithDouble:[self makeUserSexCellHeight]]];
    _userSexCellIndex = 3;
    
    [_MeInfoCellArray addObject:[self makeUserAgeCell]];
    [_MeInfoCellHeightArray addObject:[NSNumber numberWithDouble:[self makeUserAgeCellHeight]]];
    _userAgeCellIndex = 4;
    
    [_MeInfoCellArray addObject:[self makeUserLocationsCell]];
    [_MeInfoCellHeightArray addObject:[NSNumber numberWithDouble:[self makeUserLocationsCellHeight]]];
    _userLocationsCellIndex = 5;
    
    [_MeInfoCellArray addObject:[self makeUserAbilitiesCell]];
    [_MeInfoCellHeightArray addObject:[NSNumber numberWithDouble:[self makeUserAbilitiesCellHeight]]];
    _userAbilitiesIndex = 6;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _MeInfoCellArray.count;
            break;
        case 1:
            return 1;
            break;
        default:
            break;
    }
    
    return 0;
}

-(UITableViewCell*)makeProfilePicCell
{
    MeInfoProfilePicCell* proPicCell = [[[NSBundle mainBundle] loadNibNamed:@"MeInfoProfilePicCell" owner:self options:nil] lastObject];
    proPicCell.userInteractionEnabled = NO;
    
    proPicCell.IV_MeProfilePic.image = [UIImage imageNamed:@"tree.jpeg"];
    
    return proPicCell;
}

-(CGFloat)makeProfilePicCellHeight
{
    return ((MeInfoProfilePicCell*)[[[NSBundle mainBundle] loadNibNamed:@"MeInfoProfilePicCell" owner:self options:nil] lastObject]).frame.size.height;
}

-(UITableViewCell*)makeTreeIDCell
{
    MeInfoTextCell* propertyCell = [[[NSBundle mainBundle] loadNibNamed:@"MeInfoTextCell" owner:self options:nil] lastObject];
    
    propertyCell.LB_Property.text = @"Tree号";
    propertyCell.userInteractionEnabled = NO;
    propertyCell.TF_PropertyValue.enabled = NO;
    propertyCell.TF_PropertyValue.text = [_AppUserInfo.ID stringValue];
    
    return propertyCell;
}

-(CGFloat)makeTreeIDCellHeight
{
    return ((MeInfoTextCell*)[[[NSBundle mainBundle] loadNibNamed:@"MeInfoTextCell" owner:self options:nil] lastObject]).frame.size.height;
}

-(UITableViewCell*)makeUserNameCell
{
    MeEditableInfoTextCell* userNameCell = [[[NSBundle mainBundle] loadNibNamed:@"MeEditableInfoTextCell" owner:self options:nil] lastObject];
    
    userNameCell._LB_Property.text = @"名字";
    if (_AppUserInfo.Name != nil)
    {
        userNameCell._LB_PropertyValue.text = _AppUserInfo.Name;
    } else
    {
        userNameCell._LB_PropertyValue.text = @"";
    }
    
    return userNameCell;
}

-(CGFloat)makeUserNameCellHeight
{
    return ((MeEditableInfoTextCell*)[[[NSBundle mainBundle] loadNibNamed:@"MeEditableInfoTextCell" owner:self options:nil] lastObject]).frame.size.height;
}

-(UITableViewCell*)makeUserSexCell
{
    MeEditableInfoTextCell* userSexCell = [[[NSBundle mainBundle] loadNibNamed:@"MeEditableInfoTextCell" owner:self options:nil] lastObject];
    
    userSexCell._LB_Property.text = @"性别";
    if (_AppUserInfo.Sex != nil)
    {
        if (_AppUserInfo.Sex.integerValue == 10003)
        {
            userSexCell._LB_PropertyValue.text = @"男";
        }else if (_AppUserInfo.Sex.integerValue == 10004)
        {
            userSexCell._LB_PropertyValue.text = @"女";
        }
        else {
            userSexCell._LB_PropertyValue.text = @"未填写";
        }
    } else
    {
        userSexCell._LB_PropertyValue.text = @"未填写";
    }
    
    return userSexCell;
}

-(CGFloat)makeUserSexCellHeight
{
    return ((MeEditableInfoTextCell*)[[[NSBundle mainBundle] loadNibNamed:@"MeEditableInfoTextCell" owner:self options:nil] lastObject]).frame.size.height;
}

-(UITableViewCell*)makeUserAgeCell
{
    MeEditableInfoTextCell* userAgeCell = [[[NSBundle mainBundle] loadNibNamed:@"MeEditableInfoTextCell" owner:self options:nil] lastObject];
    
    userAgeCell._LB_Property.text = @"年龄";
    if (_AppUserInfo.Age != nil)
    {
        userAgeCell._LB_PropertyValue.text = [NSString stringWithFormat:@"%@ 岁", _AppUserInfo.Age];
    } else
    {
        userAgeCell._LB_PropertyValue.text = @"未填写";
    }
    
    return userAgeCell;
}

-(CGFloat)makeUserAgeCellHeight
{
    return ((MeEditableInfoTextCell*)[[[NSBundle mainBundle] loadNibNamed:@"MeEditableInfoTextCell" owner:self options:nil] lastObject]).frame.size.height;
}

-(UITableViewCell*)makeUserLocationsCell
{
    MeInfoSimpleTextCell* userLocationsCell = [[[NSBundle mainBundle] loadNibNamed:@"MeInfoSimpleTextCell" owner:self options:nil] lastObject];
    
    userLocationsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    userLocationsCell.LB_text.textColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
    userLocationsCell.LB_text.text = @"编辑常用位置";
    
    return userLocationsCell;
}

-(CGFloat)makeUserLocationsCellHeight
{
    return ((MeInfoSimpleTextCell*)[[[NSBundle mainBundle] loadNibNamed:@"MeInfoSimpleTextCell" owner:self options:nil] lastObject]).frame.size.height;
}

-(UITableViewCell*)makeUserAbilitiesCell
{
    MeInfoSimpleTextCell* abilitiesCell = [[[NSBundle mainBundle] loadNibNamed:@"MeInfoSimpleTextCell" owner:self options:nil] lastObject];
    abilitiesCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    abilitiesCell.LB_text.textColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
    abilitiesCell.LB_text.text = @"编辑能力";
    
    return abilitiesCell;
}

-(CGFloat)makeUserAbilitiesCellHeight
{
    return ((MeInfoSimpleTextCell*)[[[NSBundle mainBundle] loadNibNamed:@"MeInfoSimpleTextCell" owner:self options:nil] lastObject]).frame.size.height;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return [_MeInfoCellArray objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            MeInfoSimpleTextCell* LogOutCell = [[[NSBundle mainBundle] loadNibNamed:@"MeInfoSimpleTextCell" owner:self options:nil] lastObject];
            
            LogOutCell.LB_text.text = @"退出登录";
            
            return LogOutCell;
        }
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return (CGFloat)[((NSNumber*)[_MeInfoCellHeightArray objectAtIndex:indexPath.row]) doubleValue];
    } else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            return ((MeInfoSimpleTextCell*)[[[NSBundle mainBundle] loadNibNamed:@"MeInfoSimpleTextCell" owner:self options:nil] lastObject]).frame.size.height;
        }
    }
    
    return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == _userNameCellIndex)
        {
            MeEditNameController* editName = [[MeEditNameController alloc] init];
            [self.navigationController pushViewController:editName animated:YES];
        } else if (indexPath.row == _userSexCellIndex)
        {
            MeEditSexController* editSex = [[MeEditSexController alloc] init];
            [self.navigationController pushViewController:editSex animated:YES];
        } else if (indexPath.row == _userAgeCellIndex)
        {
            MeEditAgeController* editAge = [[MeEditAgeController alloc] init];
            [self.navigationController pushViewController:editAge animated:YES];
        } else if (indexPath.row == _userLocationsCellIndex)
        {
            MeEditLocationsController* editLocations = [[MeEditLocationsController alloc] init];
            [self.navigationController pushViewController:editLocations animated:YES];
        } else if (indexPath.row == _userAbilitiesIndex)
        {
            AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            MeEditAbisController* editAbis = [[MeEditAbisController alloc] initWithAbis:delegate.appAbilities.childrenAbilities];
            editAbis.navigationItem.title = @"编辑能力";
            [self.navigationController pushViewController:editAbis animated:YES];
        }
    } else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            [self logout];
        }
    }
}

- (void)logout
{
    AppDelegate* appDelegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
    
    NSDictionary* userAction = @{
                                 @"Action" : @"LOGOUT",
                                 @"CheckInfo" : @{
                                         @"PhoneNumber" : appDelegate.AppUserInfo.PhoneNumber,
                                         },
                                 };
    
    
    NSData* userActionData = [NSJSONSerialization dataWithJSONObject:userAction options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString* userURL = @CUR_SERVER_URL_USERS;
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest* loginRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:userURL parameters:nil error:nil];
    [loginRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [loginRequest setHTTPBody:userActionData];
    
    AFHTTPResponseSerializer* respSerializer = [AFHTTPResponseSerializer serializer];
    respSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                             @"text/html",
                                             @"text/json",
                                             @"text/javascript",
                                             @"text/plain", nil];
    
    manager.responseSerializer = respSerializer;
    
    [[manager dataTaskWithRequest:loginRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"err = %@!", error);
        } else {
            appDelegate.AppUserInfo = nil;
            appDelegate.appAbilities = nil;
            [appDelegate.RequesterTasks removeAllObjects];
            [appDelegate.ChosenResponserTasks removeAllObjects];
            [appDelegate.PotentialResponserTasks removeAllObjects];
            [appDelegate.ResponserTasks removeAllObjects];
            
            EnterController* enterView = [[EnterController alloc] init];
            
            UINavigationController* enterNav = [[UINavigationController alloc] initWithRootViewController:enterView];
            
            enterNav.navigationBarHidden = YES;
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            
            window.rootViewController = enterNav;
        }
    }] resume];
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
