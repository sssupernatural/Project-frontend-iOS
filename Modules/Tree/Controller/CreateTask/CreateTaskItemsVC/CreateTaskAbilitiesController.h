//
//  CreateTaskAbilitiesController.h
//  Tree
//
//  Created by 施威特 on 2018/4/9.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ability.h"
#import "ShowQuickSearhAbisController.h"

#define AbilityType_Main   10
#define AbilityType_First  11
#define AbilityType_Second 12
#define AbilityType_Other  13

@protocol CreateTaskAbilitiesDelegate <NSObject>

-(void)confirmAbilitiesWithType:(NSInteger)abiType andSingleAbi:(Ability*)abi andOtherAbisStr:(NSMutableArray*)array;

@end

@interface CreateTaskAbilitiesController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ShowQuickSearchAbisDelegate>
{
    UITableView* _abilitiesTableView;
    
    UISearchBar* _searchAbility;
    
    ShowQuickSearhAbisController* _showQuickSearchVC;
    
    NSArray* _allAbisStrArray;
    NSArray* _foundAbisStrArray;
}

@property (nonatomic, weak)id<CreateTaskAbilitiesDelegate> delegate;
@property (retain, nonatomic)Ability* singleAbility;
@property (retain, nonatomic)NSMutableArray* otherAbilitiesStrArray;
@property (assign, nonatomic)NSInteger abilityType;
@property (assign, nonatomic)BOOL      singleAbilitySelected;
@property (retain, nonatomic)NSMutableArray* abilities;
@property (retain, nonatomic)Ability* rootAbility;
@property (copy, nonatomic)NSString* searchAbilityBarText;

@end
