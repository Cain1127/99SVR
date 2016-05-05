//
//  XMyViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/22/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XMyViewController.h"
#import "LeftMenuHeaderView.h"
#import "RoomHttp.h"
#import "RoomViewController.h"
#import "PlayIconView.h"
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
#import "TQMeCustomizedViewController.h"
#import "PaySelectViewController.h"
#import "TQPurchaseViewController.h"

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
    [self setTitleText:@"我"];
    
//    _itemsArray = [NSMutableArray array];
//    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
//    _leftMenuHeaderView = [[LeftMenuHeaderView alloc] initWithFrame:CGRectMake(0, 64,kScreenWidth, 185)];
//    _leftMenuHeaderView.delegate = self;
//    [self.view addSubview:_leftMenuHeaderView];
    
    //添加一个tableView
    _listTableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    [_listTableView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;

    _listTableView.tableHeaderView = [self tableHeaderView];
    
    [self.view addSubview:_listTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:MESSAGE_UPDATE_LOGIN_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:MESSAGE_EXIT_LOGIN_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadProfile:) name:MEESAGE_LOGIN_SET_PROFILE_VC object:nil];
}

- (UIView *)tableHeaderView
{
    _itemsArray = [NSMutableArray array];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    _leftMenuHeaderView = [[LeftMenuHeaderView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 165)];
    _leftMenuHeaderView.delegate = self;
    return _leftMenuHeaderView;
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
    RoomViewController *roomView = [RoomViewController sharedRoomViewController];
    if (roomView.room)
    {
        PlayIconView *iconView = [PlayIconView sharedPlayIconView];
        iconView.frame = Rect(0, kScreenHeight-104, kScreenWidth, 60);
        [self.view addSubview:iconView];
        [iconView setRoom:roomView.room];
    }
}

- (void)checkLogin
{
    [_itemsArray removeAllObjects];
    _leftMenuHeaderView.login = [UserInfo sharedUserInfo].bIsLogin;
    [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:@"我的私人定制" icon:@"personal_user_icon" goClassName:@"TQMeCustomizedViewController"]];
    if (KUserSingleton.bIsLogin && KUserSingleton.nType ==1) {
        NSString *strName= [NSString stringWithFormat:@"我的玖玖币:  %.01f",KUserSingleton.goldCoin];
        [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:strName icon:@"personal_recharge_icon" goClassName:@"PaySelectViewController"]];
    }
    else
    {
        [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:@"我的玖玖币" icon:@"personal_recharge_icon" goClassName:@"PaySelectViewController"]];
    }
    [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:@"我的消费记录" icon:@"personal_consumption_icon" goClassName:@"CustomizedViewController"]];
    [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:@"我的关注" icon:@"personal_follow_icon" goClassName:@"VideoColletionViewController"]];
    [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:kKefu icon:@"personal_services_icon" goClassName:@"KefuCenterController"]];
    [_itemsArray addObject:[[LeftCellModel alloc] initWithTitle:kSetting icon:@"personal_ste_icon" goClassName:@"SettingCenterController"]];
    
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [selfWeak.listTableView reloadData];
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return _itemsArray.count-2;
    }
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
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
    NSInteger nRow = indexPath.row + indexPath.section * (_itemsArray.count-2);
    if (_itemsArray.count>nRow)
    {
        LeftCellModel *model = _itemsArray[nRow];
        [cell setModel:model];
        if ([model.goClassName isEqualToString:@"PaySelectViewController"])
        {
            [cell setrightInfo:@"充值"];
        }
        else if([model.goClassName isEqualToString:@"TQMeCustomizedViewController"])
        {
            if (KUserSingleton.bIsLogin && KUserSingleton.nType ==1)
            {
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            else
            {
                [cell setrightInfo:@"请登录后查看"];
            }
        }
        else
        {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger nRow = indexPath.row + indexPath.section * (_itemsArray.count-2);
    if ([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1)
    {
        if (_itemsArray.count>nRow)
        {
            
            LeftCellModel *model = _itemsArray[nRow];
            UIViewController *viewController = [[[NSClassFromString(model.goClassName) class] alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    else
    {
        if (_itemsArray.count>nRow && nRow+2>=_itemsArray.count)
        {
            LeftCellModel *model = _itemsArray[nRow];
            UIViewController *viewController = [[[NSClassFromString(model.goClassName) class] alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else
        {
            LoginViewController *loginView = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginView animated:YES];
        }
    }
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

- (void)enterRegister
{
    RegMobileViewController *regView = [[RegMobileViewController alloc] init];
    [self.navigationController pushViewController:regView animated:YES];
}

@end
