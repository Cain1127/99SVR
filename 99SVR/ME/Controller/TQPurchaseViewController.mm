

//
//  DemoViewController.m
//  Demo
//
//  Created by 林柏参 on 16/4/22.
//  Copyright © 2016年 XMG. All rights reserved.
//

#import "TQPurchaseViewController.h"
#import "Masonry.h"
#import "TQHeadView.h"
#import "TableViewCell.h"

@interface TQPurchaseViewController () <UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation TQPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.txtTitle.text = @"购买私人定制";
    self.view.backgroundColor = COLOR_STOCK_BackGroundColor;
    CGFloat navbarH = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    _tableView = [[UITableView alloc]initWithFrame:(CGRect){0,navbarH,ScreenWidth,ScreenHeight-navbarH} style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.row = indexPath.row;
    cell.delegate = self;
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableViewCellWithClickButton:(UIButton *)button row:(NSInteger)row
{
    NSLog(@"点击了查看的按钮%zi",row);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了对应的cell%zi",indexPath.row);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 162;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
