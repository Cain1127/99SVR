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
#import "TQButton-RoundedRectBtn.h"
#import "TQMeCustomizedViewController.h"


@interface TQMailboxViewController () 
@property (weak, nonatomic) IBOutlet TQButton_RoundedRectBtn *redPromptBtn;
@property (weak, nonatomic) IBOutlet TQButton_RoundedRectBtn *systemBtn;
@property (weak, nonatomic) IBOutlet TQButton_RoundedRectBtn *commetnRedBtn;
@property (weak, nonatomic) IBOutlet TQButton_RoundedRectBtn *askRedBtn;

@end

@implementation TQMailboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信息";
    /*死界面*/
//    [self.tableView registerClass:[TQCustomizedCell class] forCellReuseIdentifier:CustomizedCell];
//    [self.tableView registerClass:[TQMailboxCell class] forCellReuseIdentifier:MailboxCell];
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blueColor]];

}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //跳入私人定制
        TQPersonalTailorViewController *personalTailVC = [[TQPersonalTailorViewController alloc] init];
        [self.navigationController pushViewController:personalTailVC animated:YES];
        self.redPromptBtn.backgroundColor  = [UIColor clearColor];
        
    }else if (indexPath.row == 1) {
        //跳入系统信息
        TQMessageViewController *messageVC = [[TQMessageViewController alloc] init];
        [self.navigationController pushViewController:messageVC animated:YES];
        self.systemBtn.backgroundColor  = [UIColor clearColor];

    }else if (indexPath.row == 2) {
        //跳入评论回复
        TQCommentReplyViewController *commentVC = [[TQCommentReplyViewController alloc] init];
        [self.navigationController pushViewController:commentVC animated:YES];
        self.commetnRedBtn.backgroundColor  = [UIColor clearColor];

        
    }else if (indexPath.row == 3) {
        //跳入问题回复
        TQAnswerViewController *answerVC = [[TQAnswerViewController alloc] init];
        [self.navigationController pushViewController:answerVC animated:YES];
        self.askRedBtn.backgroundColor  = [UIColor clearColor];

    }

}


@end
