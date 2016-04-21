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
    
    self.sliderMenuView.DidSelectSliderIndex = ^(NSInteger index){
      
        
    };
}

-(void)initData{
    
    
}

#pragma mark lazyView 懒加载
-(SliderMenuView *)sliderMenuView{
    
    if (!_sliderMenuView) {
        
        CGFloat navbarH = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        _sliderMenuView = [[SliderMenuView alloc]initWithFrame:(CGRect){0,navbarH,ScreenWidth,ScreenHeight-navbarH} withTitles:@[@"交易记录",@"持仓情况"] withDefaultSelectIndex:self.recordType];
        _sliderMenuView.topBagColor = [UIColor whiteColor];
        _sliderMenuView.titleBagColor = [UIColor whiteColor];
        _sliderMenuView.viewArrays = @[self.busTab,self.houseTab];
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
    tableView.backgroundColor = COLOR_STOCK_BackGroundColor;
    return tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
