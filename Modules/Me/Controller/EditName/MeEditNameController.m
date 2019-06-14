//
//  MeEditNameController.m
//  Tree
//
//  Created by 施威特 on 2017/12/6.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "MeEditNameController.h"
#import "AppDelegate.h"

@interface MeEditNameController ()

@end

@implementation MeEditNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:128.0f/255.0f green:138.0f/255.0f blue:135.0f/255.0f alpha:1]];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(CancelEdit)];
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(SaveEdit)];
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.rightBarButtonItem = rightBtn;
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (delegate.AppUserInfo.Name != nil)
    {
        self.TF_EditName.text = delegate.AppUserInfo.Name;
    }

}

-(void)CancelEdit
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SaveEdit
{
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    delegate.AppUserInfo.Name = _TF_EditName.text;
    
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
