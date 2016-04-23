//
//  XMyViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/22/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XMyViewController.h"
#import "LeftMenuHeaderView.h"
#import "TextColletViewController.h"
#import "LeftCellModel.h"
#import "LeftViewCell.h"
#import <Bugly/CrashReporter.h>
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
#define kMyProfile @"我的资料"
#define kMyLivingHistory @"我的足迹"
#define kKefu @"客服中心"

@interface XMyViewController()<UITableViewDataSource,UITableViewDelegate,LeftMenuHeaderViewDelegate>
{
    
}

@property (nonatomic, strong) LeftMenuHeaderView *leftMenuHeaderView;
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *itemsArray;

@end

@implementation XMyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    _leftMenuHeaderView = [[LeftMenuHeaderView alloc] initWithFrame:CGRectMake(0, 44,kScreenWidth, 205)];
    _leftMenuHeaderView.delegate = self;
    [self.view addSubview:_leftMenuHeaderView];
    
    //添加一个tableView
    _listTableView = [[UITableView alloc] initWithFrame:Rect(0, 255, kScreenWidth, 308) style:UITableViewStylePlain];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.bounces = NO;
    _listTableView.backgroundColor = [UIColor clearColor];
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_listTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:MESSAGE_UPDATE_LOGIN_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:MESSAGE_EXIT_LOGIN_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadProfile:) name:MEESAGE_LOGIN_SET_PROFILE_VC object:nil];
    
}

- (void)reloadProfile:(NSNotification *)notify
{
    NSNumber *number = notify.object;
    if ([number intValue]==0) {
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            selfWeak.leftMenuHeaderView.login = [UserInfo sharedUserInfo].bIsLogin;
        });
    }
}

- (void)refreshUI
{
    [[CrashReporter sharedInstance] setUserId:[NSString stringWithFormat:@"用户:%@",NSStringFromInt([UserInfo sharedUserInfo].nUserId)]];
    [self performSelectorOnMainThread:@selector(checkLogin) withObject:nil waitUntilDone:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkLogin];
}

- (void)checkLogin
{
    [_itemsArray removeAllObjects];
    _leftMenuHeaderView.login = [UserInfo sharedUserInfo].bIsLogin;
    // 登录成功用户
    if ([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1)
    {
        [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:@"我的资料" icon:@"mydata.png" goClassName:@"ProfileViewController"]];
        if(KUserSingleton.nStatus)
        {
            [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:kMyAsset icon:@"personal_recharge_icon" goClassName:@"AssetViewController"]];
        }
        [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:kMyCollection icon:@"personal_collection_icon" goClassName:@"VideoColletionViewController"]];
        [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:@"关注讲师" icon:@"personal_follow_icon" goClassName:@"TextColletViewController"]];
        [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:@"我的足迹" icon:@"personal_record_icon" goClassName:@"HistoryViewController"]];
    }
    else  // 没登录
    {
        [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:kLogin icon:@"mydata.png" goClassName:@"LoginViewController"]];
        [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:kRegist icon:@"regist.png" goClassName:@"RegMobileViewController"]];
    }
    [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:kKefu icon:@"kefu.png" goClassName:@"KefuCenterController"]];
    [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:kSetting icon:@"setting" goClassName:@"SettingCenterController"]];
    
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(),
       ^{
           [selfWeak.listTableView reloadData];
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
    LeftCellModel *model = _itemsArray[indexPath.row];
    UIViewController *viewController = [[[NSClassFromString(model.goClassName) class] alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - leftMenuHeaderViewDelegate
- (void)enterLogin
{
    if ([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1)
    {
        
        ProfileViewController *profileVC = [[ProfileViewController alloc] init];
        [self.navigationController pushViewController:profileVC animated:YES];
        return;
    }
    ///未登录
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

@end
