//
//  ProfileViewController.m
//  99SVR
//
//  Created by Jiangys on 16/3/16.
//  Copyright © 2016年 Jiangys . All rights reserved.
//

#import "ProfileViewController.h"
#import "NickNameViewController.h"
#import "SexViewController.h"
#import "SignatureViewController.h"
#import "UserInfo.h"
#define kImageWidth 107
#define kCircle (kImageWidth + 12)

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate>
/**  */
@property(nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSString *strInfo;
@property (nonatomic,copy) NSString *strSex;
/** 单元格数据 */
//@property(nonatomic,strong) NSArray *cellArray;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.txtTitle.text = @"我的资料";
    self.view.backgroundColor = kTableViewBgColor;
    _strInfo = [UserInfo sharedUserInfo].strName;
    // 初始化界面
    [self setupTableView];
    [self showSex];
    // 初始化数据
    //[self sutupData];
}

/**
 *  初始化TableView
 */
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.backgroundColor = kTableViewBgColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

// 初始化头部
- (UIView *)setupTableHeaderView
{
    // headerView 会多加8来造成间隔
    UIView *headerView = [[UIView alloc] init];
    
    UIView *headerContentView = [[UIView alloc] init];
    headerContentView.backgroundColor = kNavColor;
    headerContentView.frame = CGRectMake(0, 0, ScreenWidth, 200);
    [headerView addSubview:headerContentView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:Rect(0, 40, kScreenWidth,88)];
    [imgView setImage:[UIImage imageNamed:@"left_bg"]];
    [headerContentView addSubview:imgView];
    
    // 头像圆框
    UIView *circleLine = [UIView new];
    circleLine.layer.masksToBounds = YES;
    circleLine.layer.cornerRadius = (kCircle) / 2;
    circleLine.layer.borderWidth = 0.5;
    circleLine.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    [headerContentView addSubview:circleLine];
    
    // 头像
    UIButton *avatarButton = [[UIButton alloc] init];
    avatarButton.contentMode = UIViewContentModeScaleAspectFill;
    avatarButton.layer.cornerRadius = kImageWidth / 2;
    avatarButton.layer.masksToBounds = YES;
    [avatarButton setBackgroundImage:[UIImage imageNamed:@"personal_user_head"] forState:UIControlStateNormal];
    [avatarButton setBackgroundImage:[UIImage imageNamed:@"personal_user_head"] forState:UIControlStateHighlighted];
    [circleLine addSubview:avatarButton];
    
    // ID
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = kFontSize(15);
    nameLabel.text = [NSString stringWithFormat:@"ID:%d",[UserInfo sharedUserInfo].nUserId];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [headerContentView addSubview:nameLabel];
    
    circleLine.frame = Rect(kScreenWidth/2-kCircle/2, 20, kCircle, kCircle);
    avatarButton.frame = Rect(6, 6, circleLine.width-12, circleLine.height-12);
    nameLabel.frame = Rect(30, CGRectGetMaxY(circleLine.frame) + 15, kScreenWidth-60, 20);
    
    // 间隔
    headerView.frame = CGRectMake(0, 0, ScreenWidth, 215);
    return headerView;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

#pragma mark 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"profileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.textLabel.textColor = UIColorFromRGB(0x4c4c4c);
    }
    if(indexPath.row ==0)
    {
        cell.textLabel.text = @"昵称";
        cell.detailTextLabel.text = [UserInfo sharedUserInfo].strName;
    }
    else if(indexPath.row == 1){
        cell.textLabel.text = @"性别";
        cell.detailTextLabel.text = _strSex;
    }
    else if(indexPath.row == 2){
        cell.textLabel.text = @"签名";
        cell.detailTextLabel.text = [UserInfo sharedUserInfo].strIntro;
        cell.detailTextLabel.numberOfLines = 0;
    }
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    
    return cell;
}

- (NSString *)showSex
{
    int nNum = [UserInfo sharedUserInfo].sex;
    NSString *strMsg = nil;
    switch (nNum) {
        case 0:
            strMsg = @"未设置";
            break;
        case 1:
            strMsg = @"男";
            break;
        default:
            strMsg = @"女";
            break;
    }
    _strSex = strMsg;
    return _strSex;
}

#pragma mark 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row==2)
    {
        return 60;
    }
    return 44;
}

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(self)
    if(indexPath.row == 0)
    {
        NickNameViewController *nickNameVc = [[NickNameViewController alloc] init];
        nickNameVc.title = @"昵称";
        nickNameVc.nickName = [UserInfo sharedUserInfo].strName;
        nickNameVc.nickNameBlock = ^(NSString * nickName){
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:nickNameVc animated:YES];
    }
    else if(indexPath.row == 1)
    {
        SexViewController *sexView = [[SexViewController alloc] init];
        sexView.sexBlock = ^(NSString *strSex)
        {
            weakSelf.strSex = strSex;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:sexView animated:YES];
    }
    else{
        SignatureViewController *signatureVc = [[SignatureViewController alloc] init];
        signatureVc.signature = [UserInfo sharedUserInfo].strIntro;
        signatureVc.signatureBlock =^(NSString * nickName){
            // 回调处理，同步
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:signatureVc animated:YES];
    }
    
}



@end
