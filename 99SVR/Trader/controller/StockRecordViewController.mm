//
//  StockRecordViewController.m
//  99SVR
//
//  Created by 刘海东 on 16/4/21.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "StockRecordViewController.h"
#import "SliderMenuView.h"
#import "StockMacro.h"
#import "StockRecordTabModel.h"
#import "StockDealModel.h"
#import "MJRefresh.h"

@interface StockRecordViewController ()
@property (nonatomic , strong) SliderMenuView *sliderMenuView;
/**交易记录*/
@property (nonatomic , strong) UITableView *businessTab;
/**持仓情况*/
@property (nonatomic , strong) UITableView *houseTab;
@property (nonatomic , strong) StockRecordTabModel *businessdTabModel;
@property (nonatomic , strong) StockRecordTabModel *houseTabModel;
@property (nonatomic, assign) int nCurrent;
/**公车交易记录的数据*/
@property (nonatomic , strong) NSMutableArray *busTabArray;
/**仓库记录的数据*/
@property (nonatomic , strong) NSMutableArray *houseTabArray;

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
    
    WeakSelf(self);
    self.sliderMenuView.DidSelectSliderIndex = ^(NSInteger index){
        if (index==1) {
            
            [weakSelf.businessdTabModel setDataArray:weakSelf.busTabArray WithRecordTableTag:index];
        }else{
            [weakSelf.houseTabModel setDataArray:weakSelf.houseTabArray WithRecordTableTag:index];
        }
    };
//    [_businessTab addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(test)] ;
//    
//    _businessTab addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(test1)
//    _businessTab addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(test)] ;
    
}
//
//- (void)test1{
//    [kHTTPSingle RequestReply:0 start:_nCurrent count:20];
//    _nCurrent += 20;
//}
//
//- (void)test{
//    [kHTTPSingle RequestReply:0 start:0 count:20];
//    _nCurrent = 20;
//}

-(void)initData{
    
    //交易记录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBusinessData:) name:MESSAGE_STOCK_RECORD_BUSINESS_VC object:nil];
    //持仓记录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWareHouseData:) name:MESSAGE_STOCK_WAREHOUSE__VC object:nil];

    
    [kHTTPSingle RequestOperateStockTransaction:100 start:0 cout:20];
    [kHTTPSingle RequestOperateStocks:100];

    
}
#pragma mark 刷新交易记录数据
-(void)refreshBusinessData:(NSNotification *)notfi{
//    NSArray *aryModel = notfi.object;
    WeakSelf(self);
#if 0
    if (aryModel) {
        //_aryModel = aryModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_businessTab.header isRefreshing]) {
                [_businessTab.footer resetNoMoreData];
            }else if([_businessTab.footer isRefreshing])
            {}
            if (selfWeak.nCurrent!=_aryModel.count) {
                [_businessTab.footer noticeNoMoreData];
            }
            else{
                [_businessTab.footer resetNoMoreData];
            }
        });
    }
#endif
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSArray *array = notfi.object;
        for (int i=0; i!=array.count; i++) {
            StockDealModel *model = array[i];
            [weakSelf.busTabArray addObject:model];
        }
        [weakSelf.businessdTabModel setDataArray:weakSelf.busTabArray WithRecordTableTag:1];
        [weakSelf.businessTab reloadData];
    });

}

#pragma mark 刷新持仓记录数据
-(void)refreshWareHouseData:(NSNotification *)notfi{
    WeakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *array = notfi.object;
        
        for (int i=0; i!=array.count; i++) {
            
            StockDealModel *model = array[i];
            [weakSelf.houseTabArray addObject:model];
        }
        [weakSelf.houseTabModel setDataArray:weakSelf.houseTabArray WithRecordTableTag:2];
        [weakSelf.houseTab reloadData];
    });
}
#pragma mark lazy 懒加载
-(NSMutableArray *)busTabArray{

    if (!_busTabArray) {
        
        _busTabArray = [NSMutableArray array];
    }
    
    return _busTabArray;
}

-(NSMutableArray *)houseTabArray{
    
    if (!_houseTabArray) {
        
        _houseTabArray = [NSMutableArray array];
    }
    return _houseTabArray;
}

-(SliderMenuView *)sliderMenuView{
    
    if (!_sliderMenuView) {
        
        CGFloat navbarH = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        _sliderMenuView = [[SliderMenuView alloc]initWithFrame:(CGRect){0,navbarH,ScreenWidth,ScreenHeight-navbarH} withTitles:@[@"交易记录",@"持仓情况"] withDefaultSelectIndex:self.recordType];
        _sliderMenuView.topBagColor = [UIColor whiteColor];
        _sliderMenuView.titleBagColor = [UIColor whiteColor];
        _sliderMenuView.viewArrays = @[self.businessTab,self.houseTab];
    }
    return _sliderMenuView;
}

-(UITableView *)businessTab{
    
    if (!_businessTab) {
        
        _businessTab = [self createTableViewWithFrame:(CGRect){0,0,ScreenWidth,ScreenHeight} withStyle:UITableViewStylePlain];
        _businessTab.delegate = self.businessdTabModel;
        _businessTab.dataSource = self.businessdTabModel;
        
    }
    
    return _businessTab;
}

-(UITableView *)houseTab{
    
    if (!_houseTab) {
        
        _houseTab = [self createTableViewWithFrame:(CGRect){0,0,ScreenWidth,ScreenHeight} withStyle:UITableViewStylePlain];
        _houseTab.delegate = self.houseTabModel;
        _houseTab.dataSource = self.houseTabModel;

    }
    return _houseTab;
}

-(StockRecordTabModel *)businessdTabModel{
    
    if (!_businessdTabModel) {
        
        _businessdTabModel = [[StockRecordTabModel alloc]init];
        
    }
    return _businessdTabModel;
}

-(StockRecordTabModel *)houseTabModel{
    
    if (!_houseTabModel) {
        
        _houseTabModel = [[StockRecordTabModel alloc]init];
        
    }
    return _houseTabModel;
}


-(UITableView *)createTableViewWithFrame:(CGRect)frame withStyle:(UITableViewStyle)style{
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:style];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_STOCK_BackGroundColor;
    return tableView;
}

-(void)dealloc{
    DLog(@"释放");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_STOCK_RECORD_BUSINESS_VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_STOCK_WAREHOUSE__VC object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
