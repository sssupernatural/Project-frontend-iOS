//
//  MeEditAbisController.h
//  Tree
//
//  Created by 施威特 on 2017/11/28.
//  Copyright © 2017年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ability.h"

@interface MeEditAbisController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView* _abilitiesTableView;
    
    NSMutableArray* _abilities;
}

-(MeEditAbisController*)initWithAbis:(NSMutableArray*)abis;

@end
