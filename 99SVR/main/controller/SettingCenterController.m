//
//  SettingCenterController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/24.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "SettingCenterController.h"
#import "AboutController.h"
#import "LSTcpSocket.h"
#import "UserInfo.h"
#import "LeftViewCell.h"

#define kCellHeight 44

@interface SettingCenterController() <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    UIView *_clearTipsView;
    UIButton *_clearMsgBtn;
}

@end

@implementation SettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor colorWithHex:@"#343434"];
        _nameLabel.font = kFontSize(17);
        [self.contentView addSubview:_nameLabel];
        
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"arrow"];
        [self.contentView addSubview:_arrowImageView];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kLineColor;
        [self.contentView addSubview:line];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.contentView);
        }];
        
        [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(self.contentView);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kScreenWidth - 20, 0.5));
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(1);
        }];
    }
    return self;
}

@end

@implementation SettingCenterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 36, self.view.width,3*kCellHeight+8)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    UIView *emptyFooter = [[UIView alloc] init];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0.5)];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.width - 20, 0.5)];
    [headerView addSubview:line];
    line.backgroundColor = kLineColor;
    _tableView.tableHeaderView = headerView;
    _tableView.tableFooterView = emptyFooter;
    [_tableView registerClass:[SettingCell class] forCellReuseIdentifier:@"cellId"];
    [self addDefaultHeader:@"设置"];
    
    if ([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1)
    {
        UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(8, kScreenHeight-55, kScreenWidth-16,0.5)];
        [lblContent setBackgroundColor:kLineColor];
        [self.view addSubview:lblContent];
        
        UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        logoutBtn.frame = CGRectMake(0,kScreenSourchHeight-50,kScreenWidth,kCellHeight);
        [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
        [logoutBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [logoutBtn setTitleColor:UIColorFromRGB(0x629bff) forState:UIControlStateHighlighted];
        [logoutBtn setImage:[UIImage imageNamed:@"exit_n"] forState:UIControlStateNormal];
        [logoutBtn setImage:[UIImage imageNamed:@"exit"] forState:UIControlStateHighlighted];
        UIEdgeInsets btnInsets = logoutBtn.imageEdgeInsets;
        btnInsets.left -= 10;
        logoutBtn.imageEdgeInsets = btnInsets;
        
        __weak SettingCenterController *__self = self;
        [self.view addSubview:logoutBtn];
        [logoutBtn clickWithBlock:^(UIGestureRecognizer *gesture)
         {
             UIAlertView *tips = [[UIAlertView alloc] initWithTitle:nil message:@"是否确认退出登录?" delegate:__self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
             [tips show];
         }];
    }
}

- (void)clearCache
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [self.view addSubview:view];
    _clearTipsView = view;
    [_clearTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = kFontSize(17);
    [btn setTitleColor:[UIColor colorWithHex:@"#343434"] forState:UIControlStateNormal];
    [btn setTitle:@"清除中..." forState:UIControlStateNormal];
    [_clearTipsView addSubview:btn];
    _clearMsgBtn = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 45));
        make.center.equalTo(_clearTipsView);
    }];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:0.5];
        [self performSelectorOnMainThread:@selector(clearDone) withObject:nil waitUntilDone:NO];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [UserDefaults removeObjectForKey:kIsLogin];
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_EXIT_LOGIN_VC object:nil];
        [UserInfo sharedUserInfo].bIsLogin = NO;
        [UserInfo sharedUserInfo].nUserId = 0;
        [[LSTcpSocket sharedLSTcpSocket] loginServer:@"0" pwd:@""];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)clearDone
{
    [_clearMsgBtn setTitle:@"清除完成" forState:UIControlStateNormal];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:1.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_clearTipsView removeFromSuperview];
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1)
    {
        return 3;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.row == 0)
    {
        cell.nameLabel.text = @"清除缓存";
        cell.arrowImageView.hidden = YES;
    }
    else if(indexPath.row==1)
    {
        cell.nameLabel.text = @"关于我们";
        cell.arrowImageView.hidden = NO;
    }
    else
    {
        cell.nameLabel.text = @"修改密码";
        cell.arrowImageView.hidden = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        AboutController *about = [[AboutController alloc] init];
        [self presentViewController:about animated:YES completion:nil];
    }
    else if(indexPath.row == 2)
    {
        
    }
    else {
        [self clearCache];
    }
}

- (void)dealloc
{
    DLog(@"dealloc");
}

@end
