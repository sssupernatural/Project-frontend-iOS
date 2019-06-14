//
//  FriendsController.m
//  Tree
//
//  Created by 施威特 on 2017/11/15.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "FriendsController.h"
#import "FriendsListController.h"

@interface FriendsController ()

@end

@implementation FriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tabBarItem.title = @"朋友";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goToFriendsList
{
    FriendsListController* fl = [[FriendsListController alloc] init];
    
    [self.navigationController pushViewController:fl animated:YES];
}

-(void)goToEdit
{
    
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
