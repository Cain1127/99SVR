//
//  LeftViewController.m
//  WWSideslipViewControllerSample
//
//  Created by 王维 on 14-8-26.
//  Copyright (c) 2014年 wangwei. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "LeftViewController.h"
#import "Common.h"
#import "RegisterViewController.h"
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

#define kLogin @"登陆"
#define kRegist @"注册"
#define kHistory @"历史记录"
#define kSetting @"设置"
#define kMyCollection @"我的收藏"
#define kKefu @"客服中心"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate>
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    _items = [NSMutableArray array];
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
    
    LeftHeaderView *header = [[LeftHeaderView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth*0.85, 205)];
    _tableView.tableHeaderView = header;
    _leftHeaderView = header;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 44, self.view.width - 75, 44)];
    footerView.backgroundColor = kLeftViewBgColor;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(8, 0,kScreenWidth*0.85-24, 1)];
    line.backgroundColor = kLineColor;
    [footerView addSubview:line];
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(0, 1, footerView.width, 43);
    [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [logoutBtn setImage:[UIImage imageNamed:@"exit"] forState:UIControlStateNormal];
    UIEdgeInsets btnInsets = logoutBtn.imageEdgeInsets;
    btnInsets.left -= 10;
    logoutBtn.imageEdgeInsets = btnInsets;
    [footerView addSubview:logoutBtn];
    [self.view addSubview:footerView];
    _footerView = footerView;
    
    [logoutBtn clickWithBlock:^(UIGestureRecognizer *gesture)
    {
        UIAlertView *tips = [[UIAlertView alloc] initWithTitle:nil message:@"是否确认退出登陆?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [tips show];
    }];
    
    [self checkLogin];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:MESSAGE_UPDATE_LOGIN_STATUS object:nil];
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
        [_items addObject:[[LeftCellModel alloc] initWithTitle:@"我的资料" icon:@"mydata.png" goClassName:@"MyDataController"]];
        [_items addObject:[[LeftCellModel alloc] initWithTitle:kMyCollection icon:@"collect.png" goClassName:@"MyCollectionController"]];
        [_items addObject:[[LeftCellModel alloc] initWithTitle:kSetting icon:@"setting" goClassName:@"SettingCenterController"]];
        [_items addObject:[[LeftCellModel alloc] initWithTitle:kKefu icon:@"kefu.png" goClassName:@"KefuCenterController"]];
        _footerView.hidden = NO;
    }
    else
    {
        [_items addObject:[[LeftCellModel alloc] initWithTitle:kLogin icon:@"mydata.png" goClassName:@"LoginViewController"]];
        [_items addObject:[[LeftCellModel alloc] initWithTitle:kRegist icon:@"regist.png" goClassName:@"RegisterViewController"]];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [UserDefaults removeObjectForKey:kIsLogin];
        [UserInfo sharedUserInfo].bIsLogin = NO;
        [UserInfo sharedUserInfo].nUserId = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_UPDATE_LOGIN_STATUS object:nil];
        [self checkLogin];
    }
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