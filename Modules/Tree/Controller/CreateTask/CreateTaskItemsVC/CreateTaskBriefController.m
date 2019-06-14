//
//  CreateTaskBriefController.m
//  Tree
//
//  Created by 施威特 on 2018/3/13.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import "CreateTaskBriefController.h"

@interface CreateTaskBriefController ()

@end

@implementation CreateTaskBriefController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationItem.hidesBackButton = YES;
    self.navigationItem.backBarButtonItem.title = @"返回";
    
    self.navigationController.navigationBar.hidden = YES;
    
    [_Btn_Confirm addTarget:self action:@selector(confirmBrief) forControlEvents:UIControlEventTouchUpInside];
    
    [self.Btn_Confirm.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
    [self.Btn_Confirm.layer setBorderWidth:1];
    [self.Btn_Confirm.layer setMasksToBounds:YES];
    
    _TV_Brief.layer.borderWidth = 0.8;
    _TV_Brief.layer.borderColor = [[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] CGColor];
    if(_CreateInfo.Brief != nil)
    {
        _TV_Brief.text = _CreateInfo.Brief;
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_TV_Brief resignFirstResponder];
}

-(void)confirmBrief
{
    _CreateInfo.Brief = _TV_Brief.text;
    
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
