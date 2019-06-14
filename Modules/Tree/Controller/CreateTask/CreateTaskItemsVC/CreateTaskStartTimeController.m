//
//  CreateTaskStartTimeController.m
//  Tree
//
//  Created by 施威特 on 2018/3/21.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import "CreateTaskStartTimeController.h"

@interface CreateTaskStartTimeController ()

@end

@implementation CreateTaskStartTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem.title = @"返回";
    
    self.navigationController.navigationBar.hidden = YES;
    
    [_Btn_ConfirmTime addTarget:self action:@selector(confirmTime) forControlEvents:UIControlEventTouchUpInside];
    
    [self.Btn_ConfirmTime.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
    [self.Btn_ConfirmTime.layer setBorderWidth:1];
    [self.Btn_ConfirmTime.layer setMasksToBounds:YES];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    _DP_StartTimePicker.locale = locale;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)confirmTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-M-d    HH:mm"];
    
    _CreateInfo.TaskStartTime = [dateFormatter stringFromDate:_DP_StartTimePicker.date];
    
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
