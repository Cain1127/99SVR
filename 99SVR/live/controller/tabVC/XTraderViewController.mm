//
//  XTraderViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XTraderViewController.h"
#import "StockHomeTableViewModel.h"
#import "UIViewController+EmpetViewTips.h"
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
- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-kRoom_head_view_height)];
}

- (void)addNotice
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTotalData:) name:MESSAGE_STOCK_HOME_TOTAL__VC object:nil];
}

- (void)removeNotice
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadModel:(RoomHttp *)room
{
    _room = room;
    [self addNotice];
    [_totalTab.header beginRefreshing];
}

- (id)initWihModel:(RoomHttp *)room
{
    self = [super init];
    _room = room;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotice];
    [self initData];
    [self initUi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark initUi
-(void)initUi{
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark initData
-(void)initData{
    WeakSelf(self);
    @WeakObj(self)
    self.automaticallyAdjustsScrollViewInsets = NO;
   [self.totalTab addGifHeaderWithRefreshingBlock:^{
       @StrongObj(self)
        weakSelf.refreshState = MJRefreshState_Header;
        weakSelf.totalPagInteger = 1;
        [kHTTPSingle RequestOperateStockProfitByAll:[self.room.teamid intValue] start:(int)weakSelf.totalPagInteger count:10];
    }];
    
    [self.totalTab addLegendFooterWithRefreshingBlock:^{
        @StrongObj(self)
        weakSelf.refreshState = MJRefreshState_Footer;
        weakSelf.totalPagInteger ++;
        [kHTTPSingle RequestOperateStockProfitByAll:[self.room.teamid intValue] start:(int)weakSelf.totalPagInteger count:10];
    }];
    
    [self.totalTab.gifHeader loadDefaultImg];
    Loading_Bird_Show(self.totalTab);
    
    [self.totalTab.gifHeader beginRefreshing];
    self.totalTab.footer.hidden = YES;
    
    
}

#pragma mark 刷新数据
-(void)refreshTotalData:(NSNotification *)notfi{
    
    [self refreshTableDataWithTable:self.totalTab WithTableViewModel:self.totalTableViewModel fromDataDic:(NSDictionary *)notfi.object toDataArray:self.totalDataArray];
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
    
    Loading_Bird_Hide(table);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
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
        
        [tableModel setDataArray:toDataArray];
        [table reloadData];
        
        [self chickEmptyViewShowWithTab:table withData:toDataArray withCode:code];
        
    });
    
    
}

-(NSMutableArray *)totalDataArray{
    
    if (!_totalDataArray) {
        
        _totalDataArray = [NSMutableArray array];
    }
    return _totalDataArray;
}

-(UITableView *)totalTab{
    
    if (!_totalTab) {
        _totalTab = [self createTableViewWithFrame:(CGRect){0,0,ScreenWidth,self.view.height} withStyle:UITableViewStylePlain];
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
-(void)chickEmptyViewShowWithTab:(UITableView *)tab withData:(NSMutableArray *)dataArray withCode:(NSString *)code{
    
    WeakSelf(self);
    
    if (dataArray.count==0&&[code intValue]!=1) {//数据为0 请求失败
        
        [self showErrorViewInView:tab withMsg:[NSString stringWithFormat:@"网络请求失败%@,点击重新请求",code] touchHanleBlock:^{
            Loading_Bird_Show(weakSelf.totalTab);
            [weakSelf.totalTab.gifHeader beginRefreshing];
        }];
    }else if (dataArray.count==0&&[code intValue]==1){//数据为0 请求成功
        [self showEmptyViewInView:tab withMsg:[NSString stringWithFormat:@"暂无数据"] touchHanleBlock:^{
            Loading_Bird_Show(weakSelf.totalTab);
            [weakSelf.totalTab.gifHeader beginRefreshing];
        }];
        
    }else{//请求成功
        
        [self hideEmptyViewInView:tab];
        
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