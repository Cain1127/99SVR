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
#import "TableViewFactory.h"
#import "LeftCellModel.h"
#import "UIImageView+WebCache.h"
#import "UIImageFactory.h"
#import "TQButton-RoundedRectBtn.h"
#import "TQMeCustomizedViewController.h"

@interface TQMailboxViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *aryModel;

@property (weak, nonatomic) IBOutlet TQButton_RoundedRectBtn *redPromptBtn;
@property (weak, nonatomic) IBOutlet TQButton_RoundedRectBtn *systemBtn;
@property (weak, nonatomic) IBOutlet TQButton_RoundedRectBtn *commetnRedBtn;
@property (weak, nonatomic) IBOutlet TQButton_RoundedRectBtn *askRedBtn;

@end

@implementation TQMailboxViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:@"信息"];
    _aryModel = [[NSArray alloc] initWithObjects:
                 [[LeftCellModel alloc] initWithTitle:@"私人定制" icon:@"prv_vip_icon" goClassName:@"TQPersonalTailorViewController"],
                 [[LeftCellModel alloc] initWithTitle:@"系统消息" icon:@"mes_sys_icon" goClassName:@"TQMessageViewController"],
                 [[LeftCellModel alloc] initWithTitle:@"评论回复" icon:@"com_reply_icon" goClassName:@"TQCommentReplyViewController"],
                 [[LeftCellModel alloc] initWithTitle:@"提问回复" icon:@"quiz_reply_icon" goClassName:@"AnswerViewController"],
                 nil];
    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64) withStyle:UITableViewStylePlain];
    [_tableView setBackgroundColor:RGB(243, 243, 243)];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//    self.title = @"信息";
    /*死界面*/
//    [self.tableView registerClass:[TQCustomizedCell class] forCellReuseIdentifier:CustomizedCell];
//    [self.tableView registerClass:[TQMailboxCell class] forCellReuseIdentifier:MailboxCell];
    
//    [self.navigationController.navigationBar setHidden:NO];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor blueColor]];

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TQMailBoxTableViewIdentifier = @"TQMailBoxTableViewCell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:TQMailBoxTableViewIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TQMailBoxTableViewIdentifier];
    }
    LeftCellModel *model = [_aryModel objectAtIndex:indexPath.section];
    cell.textLabel.text = model.title;
    [cell.imageView setImage:[UIImage imageNamed:model.icon]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LeftCellModel *model = _aryModel[indexPath.section];
    UIViewController *viewController = [[[NSClassFromString(model.goClassName) class] alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
