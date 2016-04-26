//
//  CustomizedViewController.m
//  99SVR
//
//  Created by jiangys on 16/4/25.
//  Copyright © 2016年 jiangys . All rights reserved.
//

#import "CustomizedViewController.h"
#import "DecodeJson.h"

@interface CustomizedViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

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

-(void)injected{
    NSLog(@"I've been injected: %@", self);
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

// 初始化头部
- (UIView *)tableHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    
    [headerView addSubview:[self createAttrViewWithTitle:@"装修" imageName:@"customized_vip1_icon" value:@"哈哈" viewCount:1]];
    
    return headerView;
}

/**
 *  房源属性
 */
- (UIView *)createAttrViewWithTitle:(NSString *)title imageName:(NSString *)imageName value:(NSString *)value viewCount:(NSInteger)viewCount
{
    CGFloat viewH = 50;
    CGFloat viewX = (viewCount - 1)%2 * (kScreenWidth * 0.5);
    CGFloat viewY = (viewCount - 1)/2 * viewH;
    
    UIView *attrView = [[UIView alloc] init];
    attrView.frame = CGRectMake(viewX, viewY, kScreenWidth * 0.5, viewH);
    
    UIButton *attrDescButton = [UIButton buttonWithType:UIButtonTypeCustom];
    attrDescButton.userInteractionEnabled = NO;
    attrDescButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [attrView addSubview:attrDescButton];
    attrDescButton.frame = CGRectMake(0, 0, kScreenWidth * 0.5, viewH);
    attrDescButton.backgroundColor = [UIColor redColor];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 40, 40)];
    iconImageView.image = [UIImage imageNamed:@"customized_vip1_icon"];
    [attrDescButton addSubview:iconImageView];
    
    UILabel *attrValueLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 80, viewH)];
    attrValueLable.textColor = [UIColor blackColor];
    attrValueLable.text = value;
    attrValueLable.font = XCFONT(13);
    [attrView addSubview:attrValueLable];
    
    // 设置选中
    UIImage *gift_frame = [UIImage imageNamed:@"gift_frame"];
    UIEdgeInsets insets = UIEdgeInsetsMake(2,2,gift_frame.size.height-4,gift_frame.size.height-4);
    [attrDescButton setBackgroundImage:[DecodeJson stretchImage:gift_frame capInsets:insets resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
    
    return attrView;
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
    static NSString *ID = @"RFMeTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = @"文字";
    cell.imageView.image = [UIImage imageNamed:@"me_phone_icon"];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerSectionView.backgroundColor = [UIColor redColor];
    return headerSectionView;
}


#pragma mark - UITableViewDelegate 代理方法
// 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

// 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

// 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
