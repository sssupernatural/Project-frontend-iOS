//
//  AbilitiesOptionCell.m
//  Tree
//
//  Created by 施威特 on 2018/2/1.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import "AbilitiesOptionCell.h"

@implementation AbilitiesOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setBtnBasic:self.Btn_SetMainAbi];
    [self setBtnBasic:self.Btn_SetFirstAbi];
    [self setBtnBasic:self.Btn_SetSecondAbi];
    [self setBtnBasic:self.Btn_SetOtherAbis];
    
}

-(void)setBtnBasic:(UIButton*)btn
{
    [btn.layer setBorderColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1].CGColor];
    [btn.layer setBorderWidth:0.3];
    [btn.layer setMasksToBounds:YES];
    [btn setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
