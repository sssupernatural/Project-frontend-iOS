//
//  MeEditSexController.m
//  Tree
//
//  Created by 施威特 on 2017/12/6.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "MeEditSexController.h"
#import "AppDelegate.h"

@interface MeEditSexController ()

@end

@implementation MeEditSexController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:128.0f/255.0f green:138.0f/255.0f blue:135.0f/255.0f alpha:1]];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(CancelEdit)];
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(SaveEdit)];
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.SC_ChooseSex.tintColor = [UIColor colorWithRed:128.0f/255.0f green:138.0f/255.0f blue:135.0f/255.0f alpha:1];
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (delegate.AppUserInfo.Sex != nil)
    {
        if ([delegate.AppUserInfo.Sex isEqualToNumber:[NSNumber numberWithInteger:10003]])
        {
            self.SC_ChooseSex.selectedSegmentIndex = 0;
        } else if ([delegate.AppUserInfo.Sex isEqualToNumber:[NSNumber numberWithInteger:10004]])
        {
            self.SC_ChooseSex.selectedSegmentIndex = 1;
        } else
        {
            self.SC_ChooseSex.selectedSegmentIndex = 2;
        }
    } else
    {
        self.SC_ChooseSex.selectedSegmentIndex = 2;
    }
}

-(void)CancelEdit
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SaveEdit
{
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (self.SC_ChooseSex.selectedSegmentIndex == 0)
    {
        delegate.AppUserInfo.Sex = [NSNumber numberWithInteger:10003];
    } else if (self.SC_ChooseSex.selectedSegmentIndex == 1)
    {
        delegate.AppUserInfo.Sex = [NSNumber numberWithInteger:10004];
    } else {
        delegate.AppUserInfo.Sex = [NSNumber numberWithInteger:10005];
    }
    
    UserInfo* ui = delegate.AppUserInfo;
    
    [ui UpdateUserInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
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
