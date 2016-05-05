//
//  SettingCenterController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/24.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "SettingCenterController.h"
#import "AboutController.h"
#import "ZLLogonServerSing.h"
#import "UserInfo.h"
#import "LeftViewCell.h"

#define kCellHeight 44

@interface EnterModel : NSObject
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *enterClass;

+ (id)createContent:(NSString *)content className:(NSString *)enterClass;
@end

@implementation EnterModel
+ (id)createContent:(NSString *)content className:(NSString *)enterClass
{
    EnterModel *model = [[EnterModel alloc] init];
    model.content = content;
    model.enterClass = enterClass;
    return model;
}
@end

@interface SettingCenterController() <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    UIView *_clearTipsView;
    UIButton *_clearMsgBtn;
    UILabel *lblContent;
    UIButton *logoutBtn;
}
@property (nonatomic,copy) NSArray *array;

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
    self.txtTitle.text = @"设置";
    
    [self setDefaultSettingItems];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 30.0f + kNavigationHeight, self.view.width, (1 + _array.count) * kCellHeight + 8.0f)];
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
    
    lblContent = [[UILabel alloc] initWithFrame:Rect(8.0f, kScreenHeight-50, kScreenWidth - 16.0f,0.5f)];
    [lblContent setBackgroundColor:kLineColor];
    [self.view addSubview:lblContent];
    
    logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(0,kScreenHeight-50,kScreenWidth,kCellHeight);
    [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [logoutBtn setTitleColor:UIColorFromRGB(0x629bff) forState:UIControlStateHighlighted];

    lblContent.hidden = YES;
    logoutBtn.hidden = YES;
    __weak SettingCenterController *__self = self;
    [self.view addSubview:logoutBtn];
    [logoutBtn clickWithBlock:^(UIGestureRecognizer *gesture)
     {
         UIAlertView *tips = [[UIAlertView alloc] initWithTitle:nil message:@"是否确认退出登录?" delegate:__self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
         [tips show];
     }];
}

/**
 *  @author yangshengmeng, 16-03-30 16:03:47
 *
 *  @brief  区分登录和不登录时的设置菜单栏
 *
 *  @since  v1.0.0
 */
- (void)setDefaultSettingItems
{

    if ([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1)
    {
        
        _array = @[[EnterModel createContent:@"绑定手机" className:@"BandingMobileViewController"],
                   [EnterModel createContent:@"修改密码" className:@"UpdatePwdViewController"],
                   [EnterModel createContent:@"关于我们" className:@"AboutController"]];
        
    }
    else
    {
        
        _array = @[[EnterModel createContent:@"关于我们" className:@"AboutController"]];
        
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1)
    {
        lblContent.hidden = NO;
        logoutBtn.hidden = NO;
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
        [lblContent setHidden:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        ///刷新设置列表
        [self setDefaultSettingItems];
        [_tableView reloadData];
        
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
    return 1 + _array.count;
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
    else
    {
        if(_array.count > indexPath.row - 1)
        {
            EnterModel *model = [_array objectAtIndex:indexPath.row - 1];
            cell.nameLabel.text = model.content;
        }
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
    if(indexPath.row==0){
        [self clearCache];
    }
    else if (indexPath.row > 0 && _array.count>indexPath.row-1) {
        EnterModel *model = [_array objectAtIndex:indexPath.row-1];
        UIViewController *viewController = [[NSClassFromString(model.enterClass) alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)dealloc
{
    DLog(@"dealloc");
}

@end
