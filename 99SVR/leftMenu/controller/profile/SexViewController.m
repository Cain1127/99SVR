//
//  SexViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 3/31/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "SexViewController.h"
#import "ZLLogonServerSing.h"
#import "UserInfo.h"

@interface SexViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) NSInteger selectIndex;
@end

@implementation SexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleText:@"修改性别"];
    _selectIndex = [UserInfo sharedUserInfo].sex-1;
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    UITableView *tableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kScreenWidth, 88)];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setTitle:@"保存" forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [btnRight setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateNormal];
    [self.view addSubview:btnRight];
    btnRight.frame = Rect(10,tableView.y+tableView.height+20, kScreenWidth-20, 40);
    [btnRight setTitleColor:UIColorFromRGB(0xe5e5e5) forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    btnRight.layer.cornerRadius = 2.5;
    btnRight.layer.masksToBounds = YES;
}

/**
 *  完成
 */
- (void)rightItemClick
{
    ZLLogonServerSing *sing = [ZLLogonServerSing sharedZLLogonServerSing];
    [sing updateNick:[UserInfo sharedUserInfo].strName intro:[UserInfo sharedUserInfo].strIntro sex:(int)(_selectIndex+1)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updatePro:(NSNotification *)notify
{
    NSString *strMsg = _selectIndex?@"女":@"男";
    __weak NSString *__strMsg = strMsg;
    NSNumber *number = notify.object;
    if ([number intValue]==0) {
        @WeakObj(self)
        gcd_main_safe(^{
            [MBProgressHUD showSuccess:@"修改性别成功"];
            [selfWeak.navigationController popViewControllerAnimated:YES];
            selfWeak.sexBlock(__strMsg);
        });
    }
    else
    {
        gcd_main_safe(^{
            [MBProgressHUD showError:@"修改性别出错"];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePro:) name:MEESAGE_LOGIN_SET_PROFILE_VC object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strIdentifier = @"sexTableViewIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier];
    }
    if (_selectIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.font = XCFONT(15);
    if (indexPath.row==0) {
        cell.textLabel.text = @"男";
    }
    else
    {
        cell.textLabel.text = @"女";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectIndex = indexPath.row;
    [tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


@end
