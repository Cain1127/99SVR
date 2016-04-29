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
/**公车交易记录的数据*/
@property (nonatomic , strong) NSMutableArray *busTabArray;
/**仓库记录的数据*/
@property (nonatomic , strong) NSMutableArray *houseTabArray;


/**下拉刷新需要清空数据！上啦不需要*/
@property (nonatomic , assign) __block MJRefreshState refreshState;

@end

@implementation StockRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.txtTitle.text = @"交易记录";
    self.view.backgroundColor = COLOR_Bg_Gay;
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
}


-(void)initData{
    
    WeakSelf(self);
    
    //交易记录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBusinessData:) name:MESSAGE_STOCK_RECORD_BUSINESS_VC object:nil];
    //持仓记录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWareHouseData:) name:MESSAGE_STOCK_WAREHOUSE__VC object:nil];

    //交易记录
    [self.businessTab addGifHeaderWithRefreshingBlock:^{
        
        [weakSelf.busTabArray removeAllObjects];
        [kHTTPSingle RequestOperateStockTransaction:(int)weakSelf.operateId start:0 cout:10];
    }];
    
    [self.businessTab addLegendFooterWithRefreshingBlock:^{
        
        StockDealModel *model = [weakSelf.busTabArray lastObject];
        [kHTTPSingle RequestOperateStockTransaction:(int)weakSelf.operateId start:[model.transId intValue] cout:10];
        
    }];
    
#warning 暂时缺接口。用交易记录模拟。
    //持仓详情
    [self.houseTab addGifHeaderWithRefreshingBlock:^{
        [weakSelf.houseTabArray removeAllObjects];
        [kHTTPSingle RequestOperateStockTransaction:(int)weakSelf.operateId start:0 cout:10];
    }];
    
    [self.houseTab addLegendFooterWithRefreshingBlock:^{
        StockDealModel *model = [weakSelf.houseTabArray lastObject];
        [kHTTPSingle RequestOperateStockTransaction:(int)weakSelf.operateId start:[model.transId intValue] cout:10];
        
    }];

    
    [self.businessTab.gifHeader loadDefaultImg];
    [self.houseTab.gifHeader loadDefaultImg];
    
    
    [self.businessTab.gifHeader beginRefreshing];
    [self.houseTab.gifHeader beginRefreshing];

    

}
#pragma mark 刷新交易记录数据
-(void)refreshBusinessData:(NSNotification *)notfi{

    [self refreshTableDataWithTable:self.businessTab WithTableViewModel:self.businessdTabModel fromDataArray:(NSArray *)notfi.object toDataArray:self.busTabArray withTabTag:1];


}

#pragma mark 刷新持仓记录数据
-(void)refreshWareHouseData:(NSNotification *)notfi{
    
    [self refreshTableDataWithTable:self.houseTab WithTableViewModel:self.houseTabModel fromDataArray:(NSArray *)notfi.object toDataArray:self.houseTabArray withTabTag:2];
}

/**
 *  刷新数据
 *
 *  @param table         对应的tab
 *  @param tableModel    对应的tableMldel
 *  @param fromDataArray 原始数据
 *  @param toDataArray   实际的数据
 *  @param tag           tableView的tag
 */
-(void)refreshTableDataWithTable:(UITableView *)table WithTableViewModel:(StockRecordTabModel *)tableModel fromDataArray:(NSArray *)fromDataArray toDataArray:(NSMutableArray *)toDataArray withTabTag:(NSInteger )tag{
    
    if ([fromDataArray  count]==0) {
        [table.footer noticeNoMoreData];
        [UIView animateWithDuration:1 animations:^{
            table.footer.hidden = YES;
        }];
    }else{
        table.footer.hidden = NO;
        [table.footer resetNoMoreData];
    }
    
    [table.gifHeader endRefreshing];
    [table.footer endRefreshing];
    
    for (int i=0; i!=[fromDataArray  count]; i++) {
        [toDataArray addObject:fromDataArray[i]];
    }
    [tableModel setDataArray:toDataArray WithRecordTableTag:tag];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [table reloadData];
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
    tableView.backgroundColor = COLOR_Bg_Gay;
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
