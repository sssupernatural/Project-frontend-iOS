//
//  ShowRespLocListController.m
//  Tree
//
//  Created by 施威特 on 2018/4/4.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import "ShowRespLocListController.h"

@interface ShowRespLocListController ()

@end

@implementation ShowRespLocListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.layer.borderWidth = 1;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius = 4;
    self.tableView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    _showFlag = TRUE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_showFlag)
    {
        return _locNumber+1;
    } else
    {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    if (indexPath.row == 0)
    {
        if (_showFlag)
        {
            cell.textLabel.text = @"收起地址列表";
        }else
        {
            cell.textLabel.text = @"展开地址列表";
        }
        
        cell.textLabel.textColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    } else
    {
        NSUInteger row = [indexPath row] - 1;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ | %@", (NSString*)[_districtList objectAtIndex:row], (NSString*)[_keyList objectAtIndex:row]];
    }
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.row == 0)
    {
        return NO;
    }
    
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row - 1;
    _locNumber --;
    [_keyList removeObjectAtIndex:index];
    [_districtList removeObjectAtIndex:index];
    [_cityList removeObjectAtIndex:index];
    [_ptList removeObjectAtIndex:index];
    
    [_delegate removeRespLoc:index];
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
    {
        _showFlag = !_showFlag;
        
        [_delegate changeShowState];
    }
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
