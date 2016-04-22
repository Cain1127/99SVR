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
    
    [self.navigationController.navigationBar setHidden:NO];


}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    return 4;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *const CustomizedCell = @"CustomizedCell";
//    static NSString *const MailboxCell = @"MailboxCell";
//
//    UITableViewCell *cell;
//    if (indexPath.row == 0) {
//        //展示私人定制的cell
//        cell = (TQCustomizedCell *)[tableView dequeueReusableCellWithIdentifier:CustomizedCell];
//        if (!cell) {
//            cell = [[TQCustomizedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomizedCell];
//        }
//    }else {
//        //展示其他相同的cell
//        cell= (TQMailboxCell *)[tableView dequeueReusableCellWithIdentifier:MailboxCell];
//        if (!cell) {
//            cell = [[TQMailboxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MailboxCell];
//        }
//    }
//    cell.backgroundColor = [UIColor lightGrayColor];
//    return cell;
//
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 130;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //跳入私人定制
        TQPersonalTailorViewController *personalTailVC = [[TQPersonalTailorViewController alloc] init];
        [self.navigationController pushViewController:personalTailVC animated:YES];
        
    }else if (indexPath.row == 1) {
        //跳入系统信息
        TQMessageViewController *messageVC = [[TQMessageViewController alloc] init];
        [self.navigationController pushViewController:messageVC animated:YES];
    }else if (indexPath.row == 2) {
        //跳入评论回复
        TQCommentReplyViewController *commentVC = [[TQCommentReplyViewController alloc] init];
        [self.navigationController pushViewController:commentVC animated:YES];
        
    }else if (indexPath.row == 3) {
        //跳入问题回复
        TQAnswerViewController *answerVC = [[TQAnswerViewController alloc] init];
        [self.navigationController pushViewController:answerVC animated:YES];
    }

}


@end
