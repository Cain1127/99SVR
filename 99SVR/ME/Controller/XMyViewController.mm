//
//  XMyViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/22/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XMyViewController.h"
#import "LeftMenuHeaderView.h"
#import "NNSVRViewController.h"
#import "RoomHttp.h"
#import "RoomViewController.h"
#import "PlayIconView.h"
#import "TextColletViewController.h"
#import "LeftCellModel.h"
#import "LeftViewCell.h"
#import <Bugly/Bugly.h>
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
    
    
    //数据源
    [self initData];
    
    
    //添加一个tableView
    _listTableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64 - 49) style:UITableViewStyleGrouped];
    [_listTableView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [_listTableView setSeparatorColor:COLOR_Line_Small_Gay];
    _listTableView.tableHeaderView = [self tableHeaderView];
    
    [self.view addSubview:_listTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:MESSAGE_UPDATE_LOGIN_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:MESSAGE_EXIT_LOGIN_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadProfile:) name:MEESAGE_LOGIN_SET_PROFILE_VC object:nil];
    //切换皮肤
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeThemeSkin:) name:MESSAGE_CHANGE_THEMESKIN object:nil];
}

- (UIView *)tableHeaderView
{
//    _itemsArray = [NSMutableArray array];
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
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"用户:%@",NSStringFromInt([UserInfo sharedUserInfo].nUserId)]];
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

-(void)initData{
    

    /**默认title*/
    NSArray *sectionArry = @[@[@"我的关注"],
                             @[@"客服中心",@"设置"]];
    
    
    if (KUserSingleton.nStatus) {
        sectionArry = @[@[@"我的私人订制",@"我的玖玖币",@"我的消费记录",@"我的关注"],
                                 @[@"客服中心",@"设置"]];
    }
    /**默认title对应的类名*/
    NSArray *classNameArray = @[@[@"TQMeCustomizedViewController",
                               @"PaySelectViewController",
                               @"NNSVRViewController",
                               @"VideoColletionViewController"],
                             @[@"KefuCenterController",
                               @"SettingCenterController"]];
    /**默认title对应的图片*/
    NSArray *iconNameArray = @[@[@"personal_recharge_icon",
                                 @"personal_recharge_icon",
                                 @"personal_consumption_icon",
                                 @"personal_follow_icon"],
                               @[@"personal_services_icon",
                                 @"personal_ste_icon"]];

    _itemsArray = [NSMutableArray array];
    
    for (int i=0; i!=sectionArry.count; i++) {
        
        NSArray *array = sectionArry[i];
        NSMutableArray *tempArray = [NSMutableArray array];
        
        for (int j=0; j!=array.count; j++) {
            
            [tempArray addObject:[[LeftCellModel alloc] initWithTitle:sectionArry[i][j] icon:iconNameArray[i][j] goClassName:classNameArray[i][j]]];
        }
        [_itemsArray addObject:tempArray];
    }
}


- (void)checkLogin
{
    
    if (KUserSingleton.nStatus) {
        
        LeftCellModel *model = _itemsArray[0][1];
        if (KUserSingleton.bIsLogin && KUserSingleton.nType ==1) {
            NSString *strName= [NSString stringWithFormat:@"我的玖玖币:  %.01f",KUserSingleton.goldCoin];
            model.title = strName;
        }
        else
        {
            model.title = @"我的玖玖币";
        }
        
    }
    _leftMenuHeaderView.login = [UserInfo sharedUserInfo].bIsLogin;
    
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [selfWeak.listTableView reloadData];
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *array = _itemsArray[section];
    return [array count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _itemsArray.count;
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
    
    if (_itemsArray.count==0) {
        return cell;
    }

    
    if (cell == nil)
    {
        cell = [[LeftViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.textColor = [UIColor whiteColor];

        LeftCellModel *model = _itemsArray[indexPath.section][indexPath.row];
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
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }
        else
        {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LeftCellModel *model = _itemsArray[indexPath.section][indexPath.row];

    if ([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1)
    {
            if([model.goClassName isEqualToString:@"NNSVRViewController"])
            {
                NSString *strPath = [kHTTPSingle requestGoid];
                NNSVRViewController  *svrView = [[NNSVRViewController alloc] initWithPath:strPath title:@"消费记录"];
                [self.navigationController pushViewController:svrView animated:YES];
                return ;
            }
            UIViewController *viewController = [[[NSClassFromString(model.goClassName) class] alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
    }else{
    
        
        if (indexPath.section==0) {
            
            LoginViewController *loginView = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginView animated:YES];

            
        }else{
            
            UIViewController *viewController = [[[NSClassFromString(model.goClassName) class] alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
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

-(void)dealloc{
    DLog(@"释放");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark 皮肤切换
-(void)changeThemeSkin:(NSNotification *)notfication{
    
    DLog(@"切换皮肤");
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [selfWeak changeNavBarThemeSkin];
        
    });
}

@end
