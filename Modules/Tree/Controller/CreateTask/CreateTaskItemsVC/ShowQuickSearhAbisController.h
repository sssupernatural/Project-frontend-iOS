//
//  ShowQuickSearhAbisController.h
//  Tree
//
//  Created by 施威特 on 2018/4/12.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShowQuickSearchAbisDelegate <NSObject>

-(void)chooseAbi:(NSString*)abiStr;

@end

@interface ShowQuickSearhAbisController : UITableViewController

@property (nonatomic, weak)id<ShowQuickSearchAbisDelegate> delegate;
@property (copy, nonatomic)NSString* searchStr;
@property (assign, nonatomic)NSInteger foundAbisNumber;
@property (retain, nonatomic)NSArray* foundAbisArray;

@end
