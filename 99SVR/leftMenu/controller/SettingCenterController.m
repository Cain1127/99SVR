//
//  SettingCenterController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/24.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "SettingCenterController.h"
#import "AboutController.h"
#import "PlayIconView.h"
#import "RoomViewController.h"
#import "ZLLogonServerSing.h"
#import "UserInfo.h"
#import "LeftViewCell.h"

#define kCellHeight 44

@interface SettingCenterController() <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    UIButton *logoutBtn;
}
@property (nonatomic,copy) NSArray *array;

@end

@implementation SettingCenterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtTitle.text = @"设置";
    self.view.backgroundColor = COLOR_Bg_Gay;
#warning 测试切换皮肤
//    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_CHANGE_THEMESKIN object:nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64,kScreenWidth,kScreenHeight - 64 - 50) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = COLOR_Bg_Gay;
    [_tableView setSeparatorColor:COLOR_Line_Small_Gay];
    [self.view addSubview:_tableView];
    
    logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(0,kScreenHeight - 60,kScreenWidth,kCellHeight);
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:COLOR_Auxiliary_Red forState:UIControlStateNormal];
    [logoutBtn setTitleColor:UIColorFromRGB(0x629bff) forState:UIControlStateHighlighted];
    logoutBtn.layer.borderColor = COLOR_Line_Small_Gay.CGColor;
    logoutBtn.layer.borderWidth = 0.5;
    logoutBtn.backgroundColor = [UIColor whiteColor];
    logoutBtn.hidden = YES;
    
    __weak SettingCenterController *__self = self;
    [self.view addSubview:logoutBtn];
    [logoutBtn clickWithBlock:^(UIGestureRecognizer *gesture)
     {
         UIAlertView *tips = [[UIAlertView alloc] initWithTitle:nil message:@"是否确认退出登录?" delegate:__self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
         [tips show];
     }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self isLogin])
    {
        logoutBtn.hidden = NO;
    }
}

- (void)clearCache
{
    [MBProgressHUD showMessage:@"正在清除中..."];
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"清除缓存完成"];
    });
}

// 退出登录
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        // 退出视频
        //[[PlayIconView sharedPlayIconView] exitPlay];
        
        [[ZLLogonServerSing sharedZLLogonServerSing] closeProtocol];
        
        [UserInfo sharedUserInfo].bIsLogin = NO;
        [UserInfo sharedUserInfo].otherLogin = 0;
        [UserInfo sharedUserInfo].nUserId = 0;
        [UserInfo sharedUserInfo].banding = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_EXIT_LOGIN_VC object:nil];
        [UserDefaults setBool:NO forKey:kIsLogin];
        [UserDefaults synchronize];
        [[ZLLogonServerSing sharedZLLogonServerSing] loginSuccess:@"0" pwd:@""];
        [logoutBtn setHidden:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        ///刷新设置列表
        [_tableView reloadData];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (![self isLogin]) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        // 如果是第三方登录，隐藏修改密码
        if ([UserInfo sharedUserInfo].otherLogin != 0) {
            return 1;
        }
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    if (section==0 && [self isLogin]) {
        switch (row) {
            case 0:
            {
                NSString *tel = [UserInfo sharedUserInfo].strMobile;
                if (!tel||tel.length==0) {
                    cell.textLabel.text=@"绑定手机";
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                } else {
                    if (tel.length == 11) {
                        tel = [tel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                    }
                    cell.textLabel.text=@"修改手机";
                    cell.detailTextLabel.font = Font_14;
                    cell.detailTextLabel.text = tel;
                }
            }
                break;
            case 1:{
                cell.textLabel.text=@"修改密码";
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            default:
                break;
        }
    } else {
        switch (row) {
            case 0:
            {
                cell.textLabel.text=@"清除缓存";
                cell.detailTextLabel.text = @"";
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 1:
            {
                cell.textLabel.text=@"关于我们";
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            default:
                break;
        }
    }
    cell.textLabel.textColor=COLOR_Text_Black;
    cell.textLabel.font = Font_14;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    NSString *vc = @"";
    if (section==0 && [self isLogin]) {
        switch (row) {
            case 0: // 修改手机
                vc = @"BandingMobileViewController";
                break;
            case 1: // 修改密码
                vc = @"UpdatePwdViewController";
            default:
                break;
        }
    } else {
        switch (row) {
            case 0: //清除缓存
                [self clearCache];
                return;
                break;
            case 1: //关于我们
                vc = @"AboutController";
                break;
            default:
                break;
        }
    }
    UIViewController *viewController = [[NSClassFromString(vc) alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - 私有方法

/**
 *  判断是否登录
 *
 *  @return Yes 为登录
 */
- (BOOL)isLogin
{
    if ([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1)
    {
        return YES;
    }
    return NO;
}

- (void)dealloc
{
    DLog(@"dealloc");
}

@end
