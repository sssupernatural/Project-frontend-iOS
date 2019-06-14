//
//  MeEditAgeController.m
//  Tree
//
//  Created by 施威特 on 2017/12/6.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "MeEditAgeController.h"
#import "AppDelegate.h"

@interface MeEditAgeController ()

@end

@implementation MeEditAgeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:128.0f/255.0f green:138.0f/255.0f blue:135.0f/255.0f alpha:1]];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(CancelEdit)];
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(SaveEdit)];
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.PV_ChooseAge.showsSelectionIndicator = YES;
    self.PV_ChooseAge.dataSource = self;
    self.PV_ChooseAge.delegate = self;
    
    self.TF_Age.userInteractionEnabled = NO;
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if (delegate.AppUserInfo.Age != nil)
    {
        self.TF_Age.text = [NSString stringWithFormat:@"%@ 岁", delegate.AppUserInfo.Age];
        [self.PV_ChooseAge selectRow:[delegate.AppUserInfo.Age integerValue] inComponent:0 animated:YES];
    }else
    {
        self.TF_Age.text = @"0 岁";
    }
    
    [self.view addSubview:self.PV_ChooseAge];
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
    _Age = row;
    self.TF_Age.text = [NSString stringWithFormat:@"%ld 岁", _Age];
}

-(void)CancelEdit
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SaveEdit
{
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    delegate.AppUserInfo.Age = [NSNumber numberWithInteger:_Age];
    
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
