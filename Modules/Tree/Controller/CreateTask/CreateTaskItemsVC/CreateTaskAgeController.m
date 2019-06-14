//
//  CreateTaskAgeController.m
//  Tree
//
//  Created by 施威特 on 2018/3/22.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import "CreateTaskAgeController.h"

@interface CreateTaskAgeController ()

@end

@implementation CreateTaskAgeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
    
    [self.Btn_ConfirmAge addTarget:self action:@selector(confirmAge) forControlEvents:UIControlEventTouchUpInside];
    
    [self.Btn_ConfirmAge.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
    [self.Btn_ConfirmAge.layer setBorderWidth:1];
    [self.Btn_ConfirmAge.layer setMasksToBounds:YES];
    
    self.PV_AgeMax.showsSelectionIndicator = YES;
    self.PV_AgeMax.dataSource = self;
    self.PV_AgeMax.delegate = self;
    [self.PV_AgeMax selectRow:_CreateInfo.AgeMax.integerValue inComponent:0 animated:YES];
    [self.LB_AgeMax setText:[NSString stringWithFormat:@"%ld岁", _CreateInfo.AgeMax.integerValue]];
    
    self.PV_AgeMin.showsSelectionIndicator = YES;
    self.PV_AgeMin.dataSource = self;
    self.PV_AgeMin.delegate = self;
    [self.PV_AgeMin selectRow:_CreateInfo.AgeMin.integerValue inComponent:0 animated:YES];
    [self.LB_AgeMin setText:[NSString stringWithFormat:@"%ld岁", _CreateInfo.AgeMin.integerValue]];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 151;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%ld", row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == _PV_AgeMin)
    {
        _CreateInfo.AgeMin = [NSNumber numberWithInteger:row];
        self.LB_AgeMin.text = [NSString stringWithFormat:@"%ld 岁", row];
    } else if (pickerView == _PV_AgeMax)
    {
        _CreateInfo.AgeMax = [NSNumber numberWithInteger:row];
        self.LB_AgeMax.text = [NSString stringWithFormat:@"%ld 岁", row];
    }
}

-(void)confirmAge
{
    if (_CreateInfo.AgeMax.integerValue < _CreateInfo.AgeMin.integerValue)
    {
        UIAlertController* alertAgeLimit = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"最大年龄应该大于或者等于最小年龄"] preferredStyle:UIAlertControllerStyleAlert];
        
        [alertAgeLimit addAction:[UIAlertAction actionWithTitle:@"重新设置年龄要求" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            return;
        }]];
        
        [self presentViewController:alertAgeLimit animated:YES completion:nil];
    } else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
