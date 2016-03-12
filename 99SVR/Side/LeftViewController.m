//
//  LeftViewController.m
//  WWSideslipViewControllerSample
//
//  Created by xiazhonglin on 14-8-26.
//  Copyright (c) 2014年 xiazhonglin. All rights reserved.
//


#import "LeftViewController.h"
#import "Common.h"
#import "RegisterViewController.h"
#import "RegMobileViewController.h"
#import "UIView+Extension.h"
#import "LeftCellModel.h"
#import "LeftViewCell.h"
#import "LeftHeaderView.h"
#import "AppDelegate.h"
#import "WWSideslipViewController.h"
#import "LoginViewController.h"
#import "RegViewController.h"
#import "AllColletViewController.h"
#import "SettingCenterController.h"
#import "KefuCenterController.h"
#import "MyDataController.h"
#import "UserInfo.h"
#import "LSTcpSocket.h"
#import "VideoColletionViewController.h"

#define kLogin @"登录"
#define kRegist @"注册"
#define kHistory @"历史记录"
#define kSetting @"设置"
#define kMyCollection @"我的收藏"
#define kMyAsset @"我的资产"
#define kKefu @"客服中心"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate,LeftHeaderDelegate>
{
    LeftHeaderView *_leftHeaderView;
    UIView *_footerView;
}
@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *itemList;
@end
@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {}
    return self;
}

- (void)enterLogin
{
    if ([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType != 1)
    {
        LoginViewController *loginView = [[LoginViewController alloc] init];
        [self presentViewController:loginView animated:YES completion:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _items = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:MESSAGE_UPDATE_LOGIN_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:MESSAGE_EXIT_LOGIN_VC object:nil];
    [self.view setBackgroundColor:kLeftViewBgColor];
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 64,self.view.width,self.view.height)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgView.image = [UIImage imageNamed:@"bg_side_navigation"];
    [self.view addSubview:imgView];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_tableView];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces =  NO;
    LeftHeaderView *header = [[LeftHeaderView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth*0.85, 205)];
    _tableView.tableHeaderView = header;
    header.delegate = self;
    _leftHeaderView = header;
    [self checkLogin];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)refreshUI
{
    [self performSelectorOnMainThread:@selector(checkLogin) withObject:nil waitUntilDone:YES];
}

- (void)checkLogin
{
    [_items removeAllObjects];
    _leftHeaderView.login = [UserInfo sharedUserInfo].bIsLogin;
    if ([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1)
    {
        [_items addObject:[[LeftCellModel alloc] initWithTitle:kMyCollection icon:@"collect.png" goClassName:@"VideoColletionViewController"]];
        [_items addObject:[[LeftCellModel alloc] initWithTitle:kMyAsset icon:@"setting" goClassName:@"AssetViewController"]];
        [_items addObject:[[LeftCellModel alloc] initWithTitle:kSetting icon:@"setting" goClassName:@"SettingCenterController"]];
        [_items addObject:[[LeftCellModel alloc] initWithTitle:kKefu icon:@"kefu.png" goClassName:@"KefuCenterController"]];
        _footerView.hidden = NO;
    }
    else
    {
    //   RegMobileViewController//
        [_items addObject:[[LeftCellModel alloc] initWithTitle:kLogin icon:@"mydata.png" goClassName:@"LoginViewController"]];
        [_items addObject:[[LeftCellModel alloc] initWithTitle:kRegist icon:@"regist.png" goClassName:@"RegMobileViewController"]];
        [_items addObject:[[LeftCellModel alloc] initWithTitle:kSetting icon:@"setting" goClassName:@"SettingCenterController"]];
        [_items addObject:[[LeftCellModel alloc] initWithTitle:kKefu icon:@"kefu.png" goClassName:@"KefuCenterController"]];
        _footerView.hidden = YES;
    }
    __weak LeftViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__self.tableView reloadData];
    });
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
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
    LeftCellModel *model = _items[indexPath.row];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewControl = nil;
    LeftCellModel *leftModel = [_items objectAtIndex:indexPath.row];
    viewControl = [[NSClassFromString(leftModel.goClassName) alloc] init];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (viewControl)
    {
        [self presentViewController:viewControl animated:YES completion:nil];
    }
}

#pragma mark 重力感应设置
-(BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end