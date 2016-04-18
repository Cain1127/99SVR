//
//  TQMailboxViewController.m
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
/**************************************** < 信箱首页 >**********************************/

#import "TQMailboxViewController.h"
#import "TQCustomizedCell.h"
#import "TQMailboxCell.h"
#import "TQAnswerViewController.h"
#import "TQMessageViewController.h"
#import "TQCommentReplyViewController.h"
#import "TQPersonalTailorViewController.h"

@interface TQMailboxViewController ()

@end

@implementation TQMailboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信息";
    /*死界面*/
//    [self.tableView registerClass:[TQCustomizedCell class] forCellReuseIdentifier:CustomizedCell];
//    [self.tableView registerClass:[TQMailboxCell class] forCellReuseIdentifier:MailboxCell];
    self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const CustomizedCell = @"CustomizedCell";
    static NSString *const MailboxCell = @"MailboxCell";

    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = (TQCustomizedCell *)[tableView dequeueReusableCellWithIdentifier:CustomizedCell];
        if (!cell) {
            cell = [[TQCustomizedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomizedCell];
        }
    }else {
        cell= (TQMailboxCell *)[tableView dequeueReusableCellWithIdentifier:MailboxCell];
        if (!cell) {
            cell = [[TQMailboxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MailboxCell];
        }
    }
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;

}
#pragma mark - TableView datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        TQPersonalTailorViewController *personalTailVC = [[TQPersonalTailorViewController alloc] init];
        [self.navigationController pushViewController:personalTailVC animated:YES];
        
    }else if (indexPath.row == 1) {
        
        TQMessageViewController *messageVC = [[TQMessageViewController alloc] init];
        [self.navigationController pushViewController:messageVC animated:YES];
    }else if (indexPath.row == 2) {
        
        TQCommentReplyViewController *commentVC = [[TQCommentReplyViewController alloc] init];
        [self.navigationController pushViewController:commentVC animated:YES];
        
    }else if (indexPath.row == 3) {
        
        TQAnswerViewController *answerVC = [[TQAnswerViewController alloc] init];
        [self.navigationController pushViewController:answerVC animated:YES];
    }

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
