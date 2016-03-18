//
//  LeftMenu.m
//  99SVR
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "LeftMenu.h"
#import "LeftMenuHeaderView.h"
#import "UserInfo.h"
#import "LeftCellModel.h"
#import "LeftViewCell.h"

#import "VideoColletionViewController.h"
#import "AssetViewController.h"
#import "SettingCenterController.h"
#import "KefuCenterController.h"
#import "LoginViewController.h"
#import "RegMobileViewController.h"
#import "SettingCenterController.h"
#import "KefuCenterController.h"
#import "ProfileViewController.h"

#define kLogin @"登录"
#define kRegist @"注册"
#define kHistory @"历史记录"
#define kSetting @"设置"
#define kMyCollection @"我的收藏"
#define kMyAsset @"我的资产"
#define kKefu @"客服中心"

@interface LeftMenu()<UITableViewDataSource,UITableViewDelegate,LeftMenuHeaderViewDelegate>
@property (nonatomic, weak) LeftMenuHeaderView *leftMenuHeaderView;
@property (nonatomic, weak) UITableView *listTableView;
@property (nonatomic,strong) NSMutableArray *itemsArray;
@end

@implementation LeftMenu

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kLeftMenuBgColor;
        //添加头部的View
        LeftMenuHeaderView *header = [[LeftMenuHeaderView alloc] initWithFrame:CGRectMake(0, 44,kScreenWidth * 0.75, 205)];
        header.delegate = self;
        [self addSubview:header];
        self.leftMenuHeaderView = header;
        
        //添加一个tableView
        UITableView *tableview = [[UITableView alloc] init];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.bounces = NO;
        tableview.backgroundColor = [UIColor clearColor];
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView = tableview;
        [self addSubview:tableview];
    }
    return self;
}

- (NSMutableArray *)itemsArray
{
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _listTableView.frame = CGRectMake(0, 255, kScreenWidth * 0.75, 308);
    
    [self checkLogin];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:MESSAGE_UPDATE_LOGIN_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:MESSAGE_EXIT_LOGIN_VC object:nil];
}

- (void)refreshUI
{
    [self performSelectorOnMainThread:@selector(checkLogin) withObject:nil waitUntilDone:YES];
}

- (void)checkLogin
{
    [_itemsArray removeAllObjects];
    
    _leftMenuHeaderView.login = [UserInfo sharedUserInfo].bIsLogin;
    // 登录成功用户
    if ([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1)
    {
        VideoColletionViewController *videoVc = [[VideoColletionViewController alloc] init];
        [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:kMyCollection icon:@"collect.png" Vc:videoVc]];
        
        AssetViewController *assetVc = [[AssetViewController alloc] init];
        [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:kMyAsset icon:@"setting" Vc:assetVc]];
        
        ProfileViewController *profileVc = [[ProfileViewController alloc] init];
        [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:@"我的资料" icon:@"setting" Vc:profileVc]];
    }
    else  // 没登录
    {
        LoginViewController *loginVc = [[LoginViewController alloc] init];
        [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:kLogin icon:@"mydata.png" Vc:loginVc]];
        
        RegMobileViewController *regVc = [[RegMobileViewController alloc] init];
        [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:kRegist icon:@"regist.png" Vc:regVc]];
    }
    
    SettingCenterController *settingVc = [[SettingCenterController alloc] init];
    [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:kSetting icon:@"setting" Vc:settingVc]];
    
    KefuCenterController *kefuVc = [[KefuCenterController alloc] init];
    [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:kKefu icon:@"kefu.png" Vc:kefuVc]];
    
    __weak LeftMenu *__self = self;
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [__self.listTableView reloadData];
                   });
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"kTableViewLeftIdentifier";
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[LeftViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    LeftCellModel *model = _itemsArray[indexPath.row];
    [cell setModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.degelate respondsToSelector:@selector(leftMenuDidSeletedAtRow:title:vc:)]) {
        LeftCellModel *model = _itemsArray[indexPath.row];
        [self.degelate leftMenuDidSeletedAtRow:indexPath.row title:model.title vc:model.vc];
    }
}

#pragma mark - leftMenuHeaderViewDelegate

- (void)enterLogin
{
    if ([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType != 1)
    {
        if ([self.degelate respondsToSelector:@selector(leftMenuIconDidClick)]) {
            [self.degelate leftMenuIconDidClick];
        }
    }
}
@end