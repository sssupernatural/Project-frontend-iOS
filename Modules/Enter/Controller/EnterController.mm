//
//  EnterController.m
//  Tree
//
//  Created by 施威特 on 2017/11/14.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "EnterController.h"
#import "RegisterController.h"
#import "TreeController.h"
#import "FriendsController.h"
#import "ExploreController.h"
#import "MeController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "UserInfo.h"
#import "UserCheckInfo.h"
#import "UserAction.h"
#import "TaskInfo.h"

@interface EnterController ()

@end

@implementation EnterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"登录";
    


}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_TF_PhoneNumber resignFirstResponder];
    [_TF_Password resignFirstResponder];
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

- (IBAction)Login:(id)sender {
    NSDictionary* userAction = @{
                                 @"Action" : @"LOGIN",
                                 @"CheckInfo" : @{
                                         @"PhoneNumber" : _TF_PhoneNumber.text,
                                         @"Password" : _TF_Password.text,
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
            
            NSDictionary* respDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"dic = %@", respDic);
            
            
            AppDelegate* appDelegate = (AppDelegate*)([UIApplication sharedApplication].delegate);
            
            appDelegate.AppUserInfo = [UserInfo UserInfoWithJsonDic:respDic];
            [appDelegate.AppUserInfo print];
            
            /*
            //test
            TaskInfo* fi = [TaskInfo FakeTInfo];
            
            [appDelegate.RequesterTasks addObject:fi];
            [appDelegate.RequesterTasks addObject:fi];
            [appDelegate.ChosenResponserTasks addObject:fi];
            [appDelegate.ChosenResponserTasks addObject:fi];
            //[appDelegate.PotentialResponserTasks addObject:fi];
            //[appDelegate.PotentialResponserTasks addObject:fi];
            //[appDelegate.ResponserTasks addObject:fi];
            //[appDelegate.ResponserTasks addObject:fi];
            //test end
             */
            
            [self loginToTree];
        }
    }] resume];
}

-(void)loginToTree
{
    TreeController* tree = [[TreeController alloc] init];
    tree.navigationItem.title = @"Tree";
    UINavigationController* navTree = [[UINavigationController alloc] initWithRootViewController:tree];
    navTree.navigationBarHidden = YES;
    [navTree.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:16.0], NSFontAttributeName, [UIColor colorWithRed:128.0f/255.0f green:138.0f/255.0f blue:135.0f/255.0f alpha:1], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [navTree.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -12)];
    [navTree.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1]} forState:UIControlStateSelected];
    navTree.tabBarItem.title = @"Tree";
    [navTree.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:16.0], NSFontAttributeName, [UIColor colorWithRed:128.0f/255.0f green:138.0f/255.0f blue:135.0f/255.0f alpha:1], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [navTree.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -12)];
    [navTree.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1]} forState:UIControlStateSelected];
    
    FriendsController* friends = [[FriendsController alloc] init];
    friends.navigationItem.title = @"朋友";
    UINavigationController* navFriends = [[UINavigationController alloc] initWithRootViewController:friends];
    navFriends.navigationBar.tintColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
    navFriends.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:128.0f/255.0f green:138.0f/255.0f blue:135.0f/255.0f alpha:1]};
    UIBarButtonItem* btnFriendsList = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:friends action:@selector(goToFriendsList)];
    UIBarButtonItem* btnEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:friends action:@selector(goToEdit)];
    
    friends.navigationItem.leftBarButtonItem = btnFriendsList;
    friends.navigationItem.rightBarButtonItem = btnEdit;
    navFriends.tabBarItem.title = @"朋友";
    [navFriends.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:16.0], NSFontAttributeName, [UIColor colorWithRed:128.0f/255.0f green:138.0f/255.0f blue:135.0f/255.0f alpha:1], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [navFriends.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -12)];
    [navFriends.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1]} forState:UIControlStateSelected];
    
    ExploreController* explore = [[ExploreController alloc] init];
    explore.tabBarItem.title = @"发现";
    [explore.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:61.0f/255.0f green:145.0f/255.0f blue:64.0f/255.0f alpha:1]} forState:UIControlStateSelected];
    
    [explore.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:16.0], NSFontAttributeName,[UIColor colorWithRed:128.0f/255.0f green:138.0f/255.0f blue:135.0f/255.0f alpha:1], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [explore.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -12)];
    
    MeController* me = [[MeController alloc] init];
    UINavigationController* navMe = [[UINavigationController alloc] initWithRootViewController:me];
    me.navigationItem.title = @"我";
    navMe.tabBarItem.title = @"我";
    navMe.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:128.0f/255.0f green:138.0f/255.0f blue:135.0f/255.0f alpha:1]};
    [navMe .tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:16.0], NSFontAttributeName, [UIColor colorWithRed:128.0f/255.0f green:138.0f/255.0f blue:135.0f/255.0f alpha:1], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [navMe.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -12)];
    [navMe.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1]} forState:UIControlStateSelected];
    
    NSArray* treeTabViews = [NSArray arrayWithObjects:navTree, navFriends, explore, navMe, nil];
    
    UITabBarController* treeTabController = [[UITabBarController alloc] init];
    
    treeTabController.viewControllers = treeTabViews;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    window.rootViewController = treeTabController;
}

- (IBAction)Register:(id)sender {
    RegisterController* registerView = [[RegisterController alloc] init];
    
    [self.navigationController pushViewController:registerView animated:YES];
}
@end
