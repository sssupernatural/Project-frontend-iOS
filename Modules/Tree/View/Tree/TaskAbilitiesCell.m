//
//  TaskAbilitiesCell.m
//  Tree
//
//  Created by 施威特 on 2017/12/14.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import "TaskAbilitiesCell.h"
#import "AbiNode.h"

@implementation TaskAbilitiesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setWithTaskInfo:(TaskInfo*)info
{
    NSUInteger mainAbiIndex = [((NSNumber*)[info.Desc.ImportanceArray objectAtIndex:0]) unsignedLongValue];
    [self.Btn_MainAbi setTitle:((AbiNode*)[info.Desc.Abilities.ABIs objectAtIndex:mainAbiIndex]).ABI forState:UIControlStateNormal];
    [self.Btn_MainAbi.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
    //[self.Btn_MainAbi.layer setBorderColor:[UIColor colorWithRed:176.0f/255.0f green:23.0f/255.0f blue:31.0f/255.0f alpha:1].CGColor];
    [self.Btn_MainAbi.layer setBorderWidth:0.3];
    [self.Btn_MainAbi.layer setMasksToBounds:YES];
    [self.Btn_MainAbi setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
    
    NSUInteger firstAbiIndex = [((NSNumber*)[info.Desc.ImportanceArray objectAtIndex:1]) unsignedLongValue];
    [self.Btn_FirstAbi setTitle:((AbiNode*)[info.Desc.Abilities.ABIs objectAtIndex:firstAbiIndex]).ABI forState:UIControlStateNormal];
    [self.Btn_FirstAbi.layer setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1].CGColor];
    [self.Btn_FirstAbi.layer setBorderWidth:0.3];
    [self.Btn_FirstAbi.layer setMasksToBounds:YES];
    [self.Btn_FirstAbi setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
    
    NSUInteger secondAbiIndex = [((NSNumber*)[info.Desc.ImportanceArray objectAtIndex:2]) unsignedLongValue];
    [self.Btn_SecondAbi setTitle:((AbiNode*)[info.Desc.Abilities.ABIs objectAtIndex:secondAbiIndex]).ABI forState:UIControlStateNormal];
    [self.Btn_SecondAbi.layer setBorderColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1].CGColor];
    [self.Btn_SecondAbi.layer setBorderWidth:0.3];
    [self.Btn_SecondAbi.layer setMasksToBounds:YES];
    [self.Btn_SecondAbi setTitleColor:[UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1] forState:UIControlStateNormal];
    
    [self.Btn_TaskStatus setTitle:[info StatusString] forState:UIControlStateNormal];
}

-(void)setCellTag:(NSInteger)tag
{
    self.Btn_TaskStatus.tag = tag;
    self.Btn_MainAbi.tag = tag;
    self.Btn_FirstAbi.tag = tag;
    self.Btn_SecondAbi.tag = tag;
    self.tag = tag;
}

@end
