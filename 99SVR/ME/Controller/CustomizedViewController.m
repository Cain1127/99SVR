//
//  CustomizedViewController.m
//  99SVR
//
//  Created by jiangys on 16/4/25.
//  Copyright © 2016年 jiangys . All rights reserved.
//

#import "CustomizedViewController.h"
#import "DecodeJson.h"
#import "CustomizedTableViewCell.h"
#import "CustomizedModel.h"
#import "PrivateVipView.h"

@interface CustomizedViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *selectIconImageView;
@property (nonatomic, strong) UILabel *selectVipLable;
@end

@implementation CustomizedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化界面

- (void)setupTableView
{
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];;
    _tableView.dataSource = self;
    _tableView.delegate=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [self tableHeaderView];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

/**
 *  初始化头部
 */
- (UIView *)tableHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 270)];
    
    // 向您推荐
    UIView *recommendView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    recommendView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleHeaderLable = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, kScreenWidth - 12, 40)];
    titleHeaderLable.font = XCFONT(16);
    titleHeaderLable.textColor = UIColorFromRGB(0x4c4c4c);
    titleHeaderLable.text = @"向您推荐";
    [recommendView addSubview:titleHeaderLable];
    
    // 分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40 - 0.5,kScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [recommendView addSubview:lineView];
    
    // 图标
    CGFloat iconW = 80;
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 55, iconW, iconW)];
    iconImageView.image = [UIImage imageNamed:@"default"];
    iconImageView.clipsToBounds = YES;
    iconImageView.layer.cornerRadius = iconW/ 2;
    [recommendView addSubview:iconImageView];
    
    // 标题：开通团队
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+10,50, kScreenWidth - 90, 30)];
    titleLable.font = XCFONT(16);
    titleLable.textColor = UIColorFromRGB(0x4c4c4c);
    titleLable.text = @"开通团队：趋势为王";
    [recommendView addSubview:titleLable];
    
    // 有效期
    UILabel *expiryLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+10,80, kScreenWidth - 90, 30)];
    expiryLable.font = XCFONT(16);
    expiryLable.textColor = UIColorFromRGB(0x4c4c4c);
    expiryLable.text = @"有效期：2013.1.1 - 2017.1.1";
    [recommendView addSubview:expiryLable];
    
    // 注意
    UILabel *attentionLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+10,110, kScreenWidth - 90, 30)];
    attentionLable.font = XCFONT(14);
    attentionLable.textColor = [UIColor redColor];
    attentionLable.text = @"开通高等级VIP，自动获得低等级VIP权限";
    [recommendView addSubview:attentionLable];
    
    [headerView addSubview:recommendView];
    
    
    
    @WeakObj(self)
    PrivateVipView *vipView = [[PrivateVipView alloc] init];
    vipView.frame = CGRectMake(0, CGRectGetMaxY(recommendView.frame)+10, kScreenWidth, 100);
    vipView.privateVipArray = [self privateVipArray];
    vipView.selectVipBlock = ^(NSUInteger vipLevelId){
        @StrongObj(self)
        // 设置组头部Vip值
        self.selectIconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"customized_vip%ld_icon",(unsigned long)vipLevelId]];
        self.selectVipLable.text = [NSString stringWithFormat:@"VIP%ld的服务内容",(unsigned long)vipLevelId];
    };
    [headerView addSubview:vipView];
    
    return headerView;
}
#pragma mark - 数据源
// 数据源
- (NSArray *)privateVipArray
{
    NSArray *array = @[
                       @{
                           @"vipLevelId" : @"1",
                           @"vipLevelName" : @"VIP1",
                           @"isOpen" : @"0"
                           },
                       @{
                           @"vipLevelId" : @"2",
                           @"vipLevelName" : @"VIP2",
                           @"isOpen" : @"0"
                           },
                       @{
                           @"vipLevelId" : @"3",
                           @"vipLevelName" : @"VIP3",
                           @"isOpen" : @"0"
                           },
                       @{
                           @"vipLevelId" : @"4",
                           @"vipLevelName" : @"VIP4",
                           @"isOpen" : @"0"
                           },
                       @{
                           @"vipLevelId" : @"5",
                           @"vipLevelName" : @"VIP5",
                           @"isOpen" : @"0"
                           },
                       @{
                           @"vipLevelId" : @"6",
                           @"vipLevelName" : @"VIP6",
                           @"isOpen" : @"0"
                           },
                       ];
    return array;
}

#pragma mark - UITableViewDataSource数据源方法
// 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

// 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomizedModel *customizedModel = [[CustomizedModel alloc] init];
    customizedModel.title = @"测试的拉拉拉";
    customizedModel.summary = @"内容拉拼接拉拉拉的";
    customizedModel.publishTime = @"2015-05-30 12:40";
    customizedModel.isOpen = NO;
    
    CustomizedTableViewCell *cell = [CustomizedTableViewCell cellWithTableView:tableView];
    cell.customizedModel = customizedModel;
    
    UIView *lineBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 80 - 0.5,kScreenWidth, 0.5)];
    lineBottomView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [cell addSubview:lineBottomView];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerSectionView.backgroundColor = [UIColor whiteColor];
    
    // 图标
    _selectIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 25, 25)];
    _selectIconImageView.image = [UIImage imageNamed:@"customized_vip1_icon"];
    [headerSectionView addSubview:_selectIconImageView];
    
    // 标题
    _selectVipLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectIconImageView.frame)+8, 0, 150, 40)];
    _selectVipLable.textColor = UIColorFromRGB(0x919191);
    _selectVipLable.text = @"VIP1的服务内容";
    _selectVipLable.font = [UIFont boldSystemFontOfSize:15];
    [headerSectionView addSubview:_selectVipLable];
    
    // 疑问
    UIButton *questionButton= [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 40, 0, 40, 40)];
    [questionButton setImage:[UIImage imageNamed:@"pwd_play_h"] forState:UIControlStateNormal];
    [questionButton addTarget:self action:@selector(questionClick) forControlEvents:UIControlEventTouchUpInside];
    [headerSectionView addSubview:questionButton];
    
    // 添加底部线条
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40 - 0.5, kScreenWidth , 0.5)];
    lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [headerSectionView addSubview:lineView];
    
    return headerSectionView;
}

#pragma mark - UITableViewDelegate 代理方法
// 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

// 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

// 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"didSelectRowAtIndexPath");
}

#pragma mark - 私有方法

/**
 *  点击疑问，跳转
 */
- (void)questionClick
{
    DLog(@"questionClick");
}

@end
