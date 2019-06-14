//
//  CreateTaskChooseSexController.m
//  Tree
//
//  Created by 施威特 on 2018/3/22.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import "CreateTaskChooseSexController.h"

@interface CreateTaskChooseSexController ()

@end

@implementation CreateTaskChooseSexController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    // Do any additional setup after loading the view from its nib.
    self.SC_ChooseSex.tintColor = [UIColor colorWithRed:128.0f/255.0f green:138.0f/255.0f blue:135.0f/255.0f alpha:1];
    
    if ([_CreateInfo.Sex isEqualToNumber:[NSNumber numberWithInteger:10003]])
    {
        self.SC_ChooseSex.selectedSegmentIndex = 0;
    } else if ([_CreateInfo.Sex isEqualToNumber:[NSNumber numberWithInteger:10004]])
    {
        self.SC_ChooseSex.selectedSegmentIndex = 1;
    } else if ([_CreateInfo.Sex isEqualToNumber:[NSNumber numberWithInteger:10005]])
    {
        self.SC_ChooseSex.selectedSegmentIndex = 2;
    }
    
    [self.BTN_ConfirmSex addTarget:self action:@selector(confirmSex) forControlEvents:UIControlEventTouchUpInside];
    
    [self.BTN_ConfirmSex.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
    [self.BTN_ConfirmSex.layer setBorderWidth:1];
    [self.BTN_ConfirmSex.layer setMasksToBounds:YES];
}

-(void)confirmSex
{
    if (self.SC_ChooseSex.selectedSegmentIndex == 0)
    {
        _CreateInfo.Sex = [NSNumber numberWithInteger:10003];
    } else if (self.SC_ChooseSex.selectedSegmentIndex == 1)
    {
        _CreateInfo.Sex = [NSNumber numberWithInteger:10004];
    } else if (self.SC_ChooseSex.selectedSegmentIndex == 2)
    {
        _CreateInfo.Sex = [NSNumber numberWithInteger:10005];
    }
    
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
