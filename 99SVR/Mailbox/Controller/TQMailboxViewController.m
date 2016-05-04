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
#import "MessageViewController.h"
#import "TQCommentReplyViewController.h"
#import "TQPersonalTailorViewController.h"
#import "TableViewFactory.h"
#import "LeftCellModel.h"
#import "UIImageView+WebCache.h"
#import "UIImageFactory.h"
#import "TQButton-RoundedRectBtn.h"
#import "TQMeCustomizedViewController.h"
#import "CommentReplyViewController.h"
#import "UnreadModel.h"

@interface TQMailboxViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *aryModel;
@property (nonatomic, strong) UnreadModel *unreadModel;

@end

@implementation TQMailboxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:@"消息"];
    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64) withStyle:UITableViewStylePlain];
    [_tableView setBackgroundColor:RGB(243, 243, 243)];
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

- (UnreadModel *)unreadModel
{
    if (!_unreadModel) {
        _unreadModel = [[UnreadModel alloc] init];
    }
    return _unreadModel;
}

/**
 *  获取到未读数据
 */
- (void)loadUnreadCount:(NSNotification *)notify
{
    self.unreadModel.system = [notify.object[@"system"] intValue];
    self.unreadModel.answer = [notify.object[@"answer"] intValue];
    self.unreadModel.privateservice = [notify.object[@"privateservice"] intValue];
    self.unreadModel.reply = [notify.object[@"reply"] intValue];
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

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
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TQMailBoxTableViewIdentifier];
    }
    
    if (indexPath.section == 0) {
        [cell addSubview:[self cellViewWithIcon:@"prv_vip_icon" title:@"私人定制"
                                   isShowUnread:_unreadModel.privateservice]];
    } else if(indexPath.section==1)
    {
        [cell addSubview:[self cellViewWithIcon:@"mes_sys_icon" title:@"系统消息"
                                   isShowUnread:_unreadModel.system]];
    } else if(indexPath.section == 2)
    {
        [cell addSubview:[self cellViewWithIcon:@"com_reply_icon" title:@"评论回复"
                                   isShowUnread:_unreadModel.reply]];
    } else{
        [cell addSubview:[self cellViewWithIcon:@"quiz_reply_icon" title:@"提问回复"
                                   isShowUnread:_unreadModel.answer]];
    }
    return cell;
}

- (UIView *)cellViewWithIcon:(NSString *)icon title:(NSString *)title isShowUnread:(BOOL)isShowUnread
{
    CGFloat H = 77;
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, H)];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 40, H)];
    iconImageView.image = [UIImage imageNamed:icon];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [cellView addSubview:iconImageView];
    
    CGSize titleSize = [title sizeMakeWithFont:Font_16];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(60, 0, titleSize.width, H);
    titleLabel.text = title;
    titleLabel.font = Font_16;
    [cellView addSubview:titleLabel];
    
    // 未读数
    if(isShowUnread)
    {
        UIImageView *unreadimageView = [[UIImageView alloc] init];
        unreadimageView.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame), 25, 8, 8);
        unreadimageView.image = [self imageWithColor:[UIColor redColor]];
        unreadimageView.layer.masksToBounds = YES;
        unreadimageView.layer.cornerRadius = 4;
        [cellView addSubview:unreadimageView];
    }
    return cellView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *vc = @"TQPersonalTailorViewController";
    if (indexPath.section == 0) {
        vc = @"TQPersonalTailorViewController";
    } else if(indexPath.section==1)
    {
        vc = @"MessageViewController";
    } else if(indexPath.section == 2)
    {
        vc = @"CommentReplyViewController";
    } else{
        vc = @"AnswerViewController";
    }
    
    UIViewController *viewController = [[[NSClassFromString(vc) class] alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (UIImage * _Nonnull)imageWithColor:(UIColor * _Nonnull)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
