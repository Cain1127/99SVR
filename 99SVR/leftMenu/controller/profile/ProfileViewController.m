//
//  ProfileViewController.m
//  99SVR
//
//  Created by Jiangys on 16/3/16.
//  Copyright © 2016年 Jiangys . All rights reserved.
//

#import "ProfileViewController.h"
#import "NickNameViewController.h"
#import "SignatureViewController.h"

#define kImageWidth 107
#define kCircle (kImageWidth + 12)

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate>
/**  */
@property(nonatomic,strong) UITableView *tableView;
/** 单元格数据 */
//@property(nonatomic,strong) NSArray *cellArray;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.txtTitle.text = @"我的资料";
    self.view.backgroundColor = kTableViewBgColor;
    
    // 初始化界面
    [self setupTableView];
    
    // 初始化数据
    //[self sutupData];
}

/**
 *  初始化TableView
 */
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.backgroundColor = kTableViewBgColor;
    tableView.tableHeaderView = [self setupTableHeaderView];
    tableView.tableFooterView = [[UIView alloc] init];
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
    [avatarButton setBackgroundImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    [avatarButton setBackgroundImage:[UIImage imageNamed:@"logo"] forState:UIControlStateHighlighted];
    [circleLine addSubview:avatarButton];
    
    // ID
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = kFontSize(15);
    nameLabel.text = @"ID:1680024";
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [headerContentView addSubview:nameLabel];
    
    circleLine.frame = Rect(kScreenWidth/2-kCircle/2, 20, kCircle, kCircle);
    avatarButton.frame = Rect(6, 6, circleLine.width-12, circleLine.height-12);
    nameLabel.frame = Rect(30, CGRectGetMaxY(circleLine.frame) + 15, kScreenWidth-60, 20);
    
    // 间隔
    headerView.frame = CGRectMake(0, 0, ScreenWidth, 215);
    return headerView;
}

/**
 *  初始化数据
 */
//- (void)sutupData
//{
//    NSArray *dict = @[
//                      @{
//                          @"title" : @"昵称",
//                          @"value" : @"股中之王"
//                          },
//                      @{
//                          @"title" : @"性别",
//                          @"value" : @"男"
//                          },
//                      @{
//                          @"title" : @"签名",
//                          @"value" : @"趁我们年轻，多走在路上，多翻山越岭，多走在路上，多翻山越岭"
//                          }
//                      ];
//    self.cellArray = dict;
//}

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
    }
    if(indexPath.row ==0)
    {
        cell.textLabel.text = @"昵称";
        cell.detailTextLabel.text = @"股中之王";
    } else if(indexPath.row == 1){
        cell.textLabel.text = @"性别";
        cell.detailTextLabel.text = @"男";
    } else if(indexPath.row == 2){
        cell.textLabel.text = @"签名";
        cell.detailTextLabel.text = @"趁我们年轻，多走在路上，多翻山越岭，多走在路上，多翻山越岭";
    }
    return cell;
}

#pragma mark 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(self)
    if(indexPath.row == 0)
    {
        NickNameViewController *nickNameVc = [[NickNameViewController alloc] init];
        nickNameVc.title = @"昵称";
        nickNameVc.nickNameBlock = ^(NSString * nickName){
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:nickNameVc animated:YES];
    } else if(indexPath.row == 1)
    {
    
    } else{
        SignatureViewController *signatureVc = [[SignatureViewController alloc] init];
        signatureVc.signatureBlock =^(NSString * nickName){
            // 回调处理，同步
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:signatureVc animated:YES];
    }
    
}

@end
