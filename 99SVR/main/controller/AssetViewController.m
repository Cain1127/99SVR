//
//  AssetViewController.m
//  99SVR
//
//  Created by Jiangys on 16/3/10.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "AssetViewController.h"
#import "NSString+Size.h"
#import "PaySelectViewController.h"

@interface AssetViewController ()


@property (nonatomic,weak) UILabel *titleLable;
@property (nonatomic,weak) UILabel *amountLabel;

@end

@implementation AssetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addDefaultHeader:@"我的资产"];
    [self initSubviews];
}

// 初始化View
- (void)initSubviews{
    
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.tintColor = UIColorFromRGB(0x555555);
    titleLable.frame = Rect(30, 80,80,25);
    titleLable.font = XCFONT(15);
    titleLable.text = @"玖玖币";
    [self.view addSubview:titleLable];
    
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.tintColor = UIColorFromRGB(0x555555);
    amountLabel.text = @"8888币";
    amountLabel.font = XCFONT(15);
    amountLabel.tintColor = UIColorFromRGB(0x555555);
    CGSize amountLabelSize = [amountLabel.text sizeMakeWithFont:XCFONT(15)];
    CGFloat amountLabelX = ScreenWidth - 30 - amountLabelSize.width;
    amountLabel.frame = Rect(amountLabelX, 80,amountLabelSize.width, 25);
    [self.view addSubview:amountLabel];
    
    [self createLabelWithRect:Rect(30, CGRectGetMaxY(titleLable.frame),80, 1)];
    
    UIButton *rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:rechargeButton];
    rechargeButton.frame = Rect(30, CGRectGetMaxY(titleLable.frame) + 40, kScreenWidth-60, 40);
    [rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [rechargeButton setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [rechargeButton setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    rechargeButton.layer.masksToBounds = YES;
    rechargeButton.layer.cornerRadius = 3;
    [rechargeButton addTarget:self action:@selector(rechargeClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createLabelWithRect:(CGRect)frame
{
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(frame.origin.x,frame.origin.y+frame.size.height+10,kScreenWidth-frame.origin.x*2,0.5)];
    [lblContent setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    [self.view addSubview:lblContent];
}

- (UITextField *)createTextField:(CGRect)frame
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    [self.view addSubview:textField];
    [textField setTextColor:UIColorFromRGB(0x555555)];
    [textField setFont:XCFONT(15)];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [textField setClearButtonMode:UITextFieldViewModeAlways];
    [textField setKeyboardType:UIKeyboardTypeNumberPad];
    return textField;
}

/**
 *  跳转去充值
 */
- (void)rechargeClick
{
    PaySelectViewController *paySelectVc = [[PaySelectViewController alloc] init];
    [self presentViewController:paySelectVc animated:YES completion:nil];
}

/**
 *  初始化tableView
 */
// 初始化tableView
//- (void)setupTableView
//{
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    tableView.backgroundColor = [UIColor whiteColor];
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView = tableView;
//    //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
//    [self.view addSubview:tableView];
//}
//
//#pragma mark - UITableViewDelegate && UITableViewDataSource
//
//// 返回每组行数
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 3;
//}
//
//
//// 返回每行的单元格
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellWithIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellWithIdentifier];
//    }
//    NSUInteger row = [indexPath row];
//    cell.textLabel.text = @"aaa";
//    //cell.imageView.image = [UIImage imageNamed:@"green.png"];
//    cell.detailTextLabel.text = @"详细信息";
//    return cell;
//}
//
//
//// 点击行
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    //[self.navigationController pushViewController:productDetailVc animated:YES];
//}
//
//// 设置每行高度（每行高度可以不一样）
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 44;
//}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}




@end
