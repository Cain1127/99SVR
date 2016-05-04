//
//  TQMailboxViewController.m
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
/**************************************** < 信箱首页 >**********************************/

#import "TQMailboxViewController.h"
#import "TableViewFactory.h"
#import "MailboxTableViewCell.h"
#import "MailboxModel.h"

@interface TQMailboxViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *mailboxArray;

@end

@implementation TQMailboxViewController

#pragma mark - 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitleText:@"消息"];
    
    // 初始化消息列表数据
    [self mailboxArrayWithPrvUnreadCount:0 messageUnreadCount:0 replyUnreadCount:0 answerUnreadCount:0];
    
    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight - 64) withStyle:UITableViewStylePlain];
    _tableView.backgroundColor = COLOR_Bg_Gay;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUnreadCount:) name:MESSAGE_UNREAD_INFO_VC object:nil];
    [kHTTPSingle RequestUnreadCount];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_UNREAD_INFO_VC object:nil];
    [super viewWillDisappear:animated];
}

#pragma mark - 懒加载

-(NSMutableArray *)mailboxArray
{
    if (!_mailboxArray) {
        _mailboxArray = [NSMutableArray array];
    }
    return _mailboxArray;
}

/**
 *  获取到未读数据
 */
- (void)loadUnreadCount:(NSNotification *)notify
{
    // 初始化消息列表数据
    [self mailboxArrayWithPrvUnreadCount:[notify.object[@"privateservice"] intValue]
                      messageUnreadCount:[notify.object[@"system"] intValue]
                        replyUnreadCount:[notify.object[@"reply"] intValue]
                       answerUnreadCount:[notify.object[@"answer"] intValue]];
    
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mailboxArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MailboxTableViewCell *cell = [MailboxTableViewCell cellWithTableView:tableView];
    MailboxModel *mailboxModel = self.mailboxArray[indexPath.row];
    cell.mailboxModel = mailboxModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MailboxModel *mailboxModel = self.mailboxArray[indexPath.row];
    UIViewController *viewController = [[[NSClassFromString(mailboxModel.skipVc) class] alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - 私有方法

/**
 *  初始化消息列表
 */
- (void)mailboxArrayWithPrvUnreadCount:(NSInteger)PrvUnreadCount
                    messageUnreadCount:(NSInteger)messageUnreadCount
                      replyUnreadCount:(NSInteger)replyUnreadCount
                      answerUnreadCount:(NSInteger)answerUnreadCount
{
    [self.mailboxArray removeAllObjects];
    
    [self addMailboxArrayWithIcon:@"prv_vip_icon" title:@"私人定制"
                      unreadCount:PrvUnreadCount skipVc:@"TQPersonalTailorViewController"];
    [self addMailboxArrayWithIcon:@"mes_sys_icon" title:@"系统消息"
                      unreadCount:messageUnreadCount skipVc:@"MessageViewController"];
    [self addMailboxArrayWithIcon:@"com_reply_icon" title:@"评论回复"
                      unreadCount:replyUnreadCount skipVc:@"CommentReplyViewController"];
    [self addMailboxArrayWithIcon:@"quiz_reply_icon" title:@"提问回复"
                      unreadCount:answerUnreadCount skipVc:@"AnswerViewController"];
}

- (void)addMailboxArrayWithIcon:(NSString *)icon
                          title:(NSString *)title
                    unreadCount:(NSInteger)unreadCount
                         skipVc:(NSString *)skipVc
{
    MailboxModel *mailboxModel = [[MailboxModel alloc] init];
    mailboxModel.icon = icon;
    mailboxModel.title = title;
    mailboxModel.unreadCount = unreadCount;
    mailboxModel.skipVc = skipVc;
    
    [self.mailboxArray addObject:mailboxModel];
}

@end
