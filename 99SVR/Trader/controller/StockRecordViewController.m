//
//  StockRecordViewController.m
//  99SVR
//
//  Created by 刘海东 on 16/4/21.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "StockRecordViewController.h"
#import "SliderMenuView.h"
#import "MacroHeader.h"
@interface StockRecordViewController ()
@property (nonatomic , strong) SliderMenuView *sliderMenuView;
/**交易记录*/
@property (nonatomic , strong) UITableView *busTab;
/**持仓情况*/
@property (nonatomic , strong) UITableView *houseTab;
@end

@implementation StockRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.txtTitle.text = @"交易记录";
    self.view.backgroundColor = COLOR_STOCK_BackGroundColor;


    [self initData];
    [self initUI];
    
}

-(void)initUI{
    
    [self.view addSubview:self.sliderMenuView];
}

-(void)initData{
    
    
}

#pragma mark lazyView 懒加载
-(SliderMenuView *)sliderMenuView{
    
    if (!_sliderMenuView) {
        
        CGFloat navbarH = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        CGFloat tabbarH = CGRectGetHeight(self.tabBarController.tabBar.frame);
        _sliderMenuView = [[SliderMenuView alloc]initWithFrame:(CGRect){0,navbarH,ScreenWidth,ScreenHeight-navbarH-tabbarH} withTitles:@[@"日收益",@"月收益",@"总收益"] withDefaultSelectIndex:self.recordType];
//        _sliderMenuView.viewArrays = @[self.dayTab,self.monTab,self.totalTab];
    }
    return _sliderMenuView;
}

-(UITableView *)busTab{
    
    if (!_busTab) {
        
        _busTab = [self createTableViewWithFrame:(CGRect){0,0,ScreenWidth,ScreenHeight} withStyle:UITableViewStylePlain];
        
    }
    
    return _busTab;
}

-(UITableView *)houseTab{
    
    if (!_houseTab) {
        
        _houseTab = [self createTableViewWithFrame:(CGRect){0,0,ScreenWidth,ScreenHeight} withStyle:UITableViewStylePlain];

    }
    return _houseTab;
}


-(UITableView *)createTableViewWithFrame:(CGRect)frame withStyle:(UITableViewStyle)style{
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:style];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor grayColor];
    return tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
