//
//  XTraderViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XTraderViewController.h"
#import "StockHomeTableViewModel.h"
#import "TableViewFactory.h"
#import "MJRefresh.h"
#import "StockDealModel.h"
#import "RoomHttp.h"
@interface XTraderViewController()
{
    
}
@property (nonatomic,strong) RoomHttp *room;
@property (nonatomic, strong) UITableView *totalTab;
@property (nonatomic ,strong) StockHomeTableViewModel *totalTableViewModel;
@property (nonatomic , strong) NSMutableArray *totalDataArray;

@end

@implementation XTraderViewController
- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-kRoom_head_view_height)];
}
- (void)reloadModel:(RoomHttp *)room
{
    _room = room;
    [self initData];
}

- (id)initWihModel:(RoomHttp *)room
{
    self = [super init];
    _room = room;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _totalTab = [TableViewFactory createTableViewWithFrame:Rect(0, 0, kScreenWidth,self.view.height) withStyle:UITableViewStylePlain];
    _totalTab.delegate = self.totalTableViewModel;
    _totalTab.dataSource = self.totalTableViewModel;
    [self.view addSubview:_totalTab];
    [self initData];
}

#pragma mark initData
-(void)initData{
    
    WeakSelf(self);
    //total
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTotalData:) name:MESSAGE_STOCK_HOME_TOTAL__VC object:nil];
    [self.totalTab addGifHeaderWithRefreshingBlock:^{
        [weakSelf.totalDataArray removeAllObjects];
        [kHTTPSingle RequestOperateStockProfitByAll:0 start:0 count:5];
    }];
    
    [self.totalTab addLegendFooterWithRefreshingBlock:^{
        StockDealModel *model = [weakSelf.totalDataArray lastObject];
        [kHTTPSingle RequestOperateStockProfitByAll:0 start:[model.transId intValue] count:5];
    }];
    
    [self.totalTab.gifHeader loadDefaultImg];
    [self.totalTab.gifHeader beginRefreshing];
}

-(StockHomeTableViewModel *)totalTableViewModel{
    if (!_totalTableViewModel) {
        _totalTableViewModel = [[StockHomeTableViewModel alloc]initWithViewController:self];
    }
    return _totalTableViewModel;
}

#pragma mark 刷新数据

-(void)refreshTotalData:(NSNotification *)notfi{
    
    [self refreshTableDataWithTable:self.totalTab WithTableViewModel:self.totalTableViewModel fromDataArray:(NSArray *)notfi.object toDataArray:self.totalDataArray];
}
/**
 *  刷新数据
 *
 *  @param table         对应的tab
 *  @param tableModel    对应的tableMldel
 *  @param fromDataArray 原始数据
 *  @param toDataArray   实际的数据
 */
-(void)refreshTableDataWithTable:(UITableView *)table WithTableViewModel:(StockHomeTableViewModel *)tableModel fromDataArray:(NSArray *)fromDataArray toDataArray:(NSMutableArray *)toDataArray{
    if ([fromDataArray  count]==0) {
        [table.footer noticeNoMoreData];
        [UIView animateWithDuration:1 animations:^{
            table.footer.hidden = YES;
        }];
    }
    else
    {
        table.footer.hidden = NO;
        [table.footer resetNoMoreData];
    }
    [table.gifHeader endRefreshing];
    [table.footer endRefreshing];
    for (int i=0; i!=[fromDataArray  count]; i++) {
        [toDataArray addObject:fromDataArray[i]];
    }
    [tableModel setDataArray:toDataArray];
    dispatch_async(dispatch_get_main_queue(), ^{
        [table reloadData];
    });
}

-(NSMutableArray *)totalDataArray{
    
    if (!_totalDataArray) {
        
        _totalDataArray = [NSMutableArray array];
    }
    return _totalDataArray;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"dealloc");
}

@end
