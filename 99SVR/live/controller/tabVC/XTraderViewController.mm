//
//  XTraderViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XTraderViewController.h"
#import "StockHomeTableViewModel.h"
#import "ViewNullFactory.h"
#import "TableViewFactory.h"
#import "MJRefresh.h"
#import "StockDealModel.h"
#import "RoomHttp.h"
#import "MJRefresh.h"
@interface XTraderViewController()
{
    
}
@property (nonatomic,strong) RoomHttp *room;
/**总的*/
@property (nonatomic , strong) UITableView *totalTab;
@property (nonatomic , strong) StockHomeTableViewModel *totalTableViewModel;
@property (nonatomic , strong) __block NSMutableArray *totalDataArray;
@property (nonatomic , assign) __block NSInteger totalPagInteger;
@property (nonatomic , strong) UIView *totalEmptyView;

@property (nonatomic , assign) __block MJRefreshState refreshState;

@end

@implementation XTraderViewController
- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-kRoom_head_view_height)];
}
- (void)reloadModel:(RoomHttp *)room
{
    _room = room;
    [_totalTab.header beginRefreshing];
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
    [self initData];
    [self initUi];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTotalData:) name:MESSAGE_STOCK_HOME_TOTAL__VC object:nil];
    [self.totalTab.gifHeader beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_STOCK_HOME_TOTAL__VC object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark initUi
-(void)initUi{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.totalTab];

}

#pragma mark initData
-(void)initData{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //total

    @WeakObj(self)
    [self.totalTab addGifHeaderWithRefreshingBlock:^{
        selfWeak.refreshState = MJRefreshState_Header;
        selfWeak.totalPagInteger = 1;
        [kHTTPSingle RequestOperateStockProfitByAll:[selfWeak.room.teamid intValue] start:(int)selfWeak.totalPagInteger count:10];
    }];
    
    [self.totalTab addLegendFooterWithRefreshingBlock:^{
        selfWeak.refreshState = MJRefreshState_Footer;
        selfWeak.totalPagInteger ++;
        [kHTTPSingle RequestOperateStockProfitByAll:[selfWeak.room.teamid intValue] start:(int)selfWeak.totalPagInteger count:10];
    }];
    [self.totalTab.gifHeader loadDefaultImg];
}

-(void)refreshTotalData:(NSNotification *)notfi{
    @WeakObj(self)
    NSDictionary *dict = notfi.object;
    if ([dict isKindOfClass:[NSDictionary class]]) {
        @WeakObj(dict)
        dispatch_async(dispatch_get_main_queue(),^{
            @StrongObj(self)
            [self refreshTableDataWithTable:self.totalTab WithTableViewModel:self.totalTableViewModel fromDataDic:dictWeak toDataArray:self.totalDataArray];
        });
    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [selfWeak.totalTab.header endRefreshing];
            [selfWeak.totalTab.footer endRefreshing];
        });
    }
}
/**
 *  刷新数据
 *
 *  @param table         对应的tab
 *  @param tableModel    对应的tableMldel
 *  @param fromDataArray 原始数据
 *  @param toDataArray   实际的数据
 */
-(void)refreshTableDataWithTable:(UITableView *)table WithTableViewModel:(StockHomeTableViewModel *)tableModel fromDataDic:(NSDictionary *)fromDataDic toDataArray:(NSMutableArray *)toDataArray{
    
    Loading_Bird_Hide
    
    NSString *code = [NSString stringWithFormat:@"%@",fromDataDic[@"code"]];
    
    if ([code isEqualToString:@"1"]) {//请求成功
        
        if (self.refreshState == MJRefreshState_Header) {//头部刷新需要清空数据
            [toDataArray removeAllObjects];
        }
        
        
        NSArray *fromDataArray = fromDataDic[@"data"];
        
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
    }else{//请求失败
        
        table.footer.hidden = YES;
        [table.gifHeader endRefreshing];
        [table.footer endRefreshing];
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableModel setDataArray:toDataArray];
        [table reloadData];
    });
    
    [self chickEmptyViewShow:toDataArray withCode:code];
}


-(NSMutableArray *)totalDataArray{
    
    if (!_totalDataArray) {
        
        _totalDataArray = [NSMutableArray array];
    }
    return _totalDataArray;
}

-(UITableView *)totalTab{
    
    if (!_totalTab) {
        _totalTab = [self createTableViewWithFrame:(CGRect){0,0,ScreenWidth,ScreenHeight} withStyle:UITableViewStylePlain];
        _totalTab.delegate = self.totalTableViewModel;
        _totalTab.dataSource = self.totalTableViewModel;
    }
    return _totalTab;
}

-(StockHomeTableViewModel *)totalTableViewModel{
    if (!_totalTableViewModel) {
        _totalTableViewModel = [[StockHomeTableViewModel alloc]initWithViewController:self];
    }
    return _totalTableViewModel;
}

#pragma mark 请求成功时候-检测是否出现提示图
-(void)chickEmptyViewShow:(NSMutableArray *)dataArray withCode:(NSString *)code{
    
    BOOL requestBool = [code isEqualToString:@"1"] ? YES : NO;
    
    if (requestBool) {//请求成功
        
        if (dataArray.count ==0) {//不存在数据时候
            
            if (dataArray == self.totalDataArray) {
                self.totalEmptyView = [ViewNullFactory createViewBg:self.totalTab.bounds imgView:[UIImage imageNamed:@"text_blank_page@3x.png"] msg:RequestState_EmptyStr(@"总收益")];
                [self.totalTab addSubview:self.totalEmptyView];
            }
        }else{//存在数据
            if (self.totalEmptyView) {
                [self.totalEmptyView removeFromSuperview];
            }
        }
    }else{
        //请求失败
        if (self.totalEmptyView) {
            [self.totalEmptyView removeFromSuperview];
        }
        
        if (dataArray.count==0) {
            self.totalEmptyView = [ViewNullFactory createViewBg:self.totalTab.bounds imgView:[UIImage imageNamed:@"network_anomaly_fail"] msg:RequestState_NetworkErrorStr(code)];
            [self.totalTab addSubview:self.totalEmptyView];
        }else{
            
        }
    }
}


-(UITableView *)createTableViewWithFrame:(CGRect)frame withStyle:(UITableViewStyle)style{
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:style];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_Bg_Gay;
    return tableView;
}

-(void)dealloc{
    
    DLog(@"释放");
    
    
}

@end