
#import "StockHomeViewController.h"
#import "SliderMenuView.h"
#import "ShareFunction.h"
#import "SearchController.h"
#import "StockMacro.h"
#import "StockDealViewController.h"
#import "StockHomeTableViewModel.h"
#import "roomhttp.h"
#import "PlayIconView.h"
#import "RoomViewController.h"
#import "MJRefresh.h"
#import "MJRefreshComponent.h"
#import "StockDealModel.h"
#import "TQMailboxViewController.h"
#import "UIViewController+EmpetViewTips.h"
@interface StockHomeViewController ()<StockHomeTableViewModelDelegate>
/**滑动控制器*/
@property (nonatomic, strong) SliderMenuView *sliderMenuView;
/**日*/
@property (nonatomic , strong) UITableView *dayTab;
@property (nonatomic , strong) StockHomeTableViewModel *dayTableViewModel;
@property (nonatomic , strong) __block NSMutableArray *dayDataArray;
@property (nonatomic , assign) __block NSInteger dayPagInteger;

/**月*/
@property (nonatomic , strong) UITableView *monTab;
@property (nonatomic , strong) StockHomeTableViewModel *monTableViewModel;
@property (nonatomic , strong) __block NSMutableArray *monDataArray;
@property (nonatomic , assign) __block NSInteger monPagInteger;

/**总的*/
@property (nonatomic , strong) UITableView *totalTab;
@property (nonatomic , strong) StockHomeTableViewModel *totalTableViewModel;
@property (nonatomic , strong) __block NSMutableArray *totalDataArray;
@property (nonatomic , assign) __block NSInteger totalPagInteger;

/**下拉刷新需要清空数据！上啦不需要*/
@property (nonatomic , assign) __block MJRefreshState refreshState;
@property (nonatomic , assign) __block NSInteger tabViewTag;



@end

@implementation StockHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUi];
    self.headLine.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark initUi
-(void)initUi{
    
    WeakSelf(self);
    [self.navigationController.navigationBar setHidden:YES];
    [self setTitleText:@"高手操盘"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.sliderMenuView];
    self.sliderMenuView.DidSelectSliderIndex = ^(NSInteger index)
    {
        weakSelf.tabViewTag = index;
    };
}

#pragma mark initData
-(void)initData{
    
    WeakSelf(self);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    weakSelf.tabViewTag = 1;
    
    //day
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDayData:) name:MESSAGE_STOCK_HOME_DAY__VC object:nil];
    //mon
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMonData:) name:MESSAGE_STOCK_HOME_MON__VC object:nil];
    //total
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTotalData:) name:MESSAGE_STOCK_HOME_TOTAL__VC object:nil];
    
    //切换皮肤
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeThemeSkin:) name:MESSAGE_CHANGE_THEMESKIN object:nil];

    
    [self.dayTab addGifHeaderWithRefreshingBlock:^{
        
        weakSelf.refreshState = MJRefreshState_Header;
        weakSelf.dayPagInteger = 1;
        [kHTTPSingle RequestOperateStockProfitByDay:0 start:(int)weakSelf.dayPagInteger count:0];
    }];
    
    [self.dayTab addLegendFooterWithRefreshingBlock:^{

        weakSelf.refreshState = MJRefreshState_Footer;
        weakSelf.dayPagInteger ++;
        [kHTTPSingle RequestOperateStockProfitByDay:0 start:(int)weakSelf.dayPagInteger count:0];
        
    }];
    
    
    [self.monTab addGifHeaderWithRefreshingBlock:^{
        weakSelf.refreshState = MJRefreshState_Header;
        weakSelf.monPagInteger = 1;
        [kHTTPSingle RequestOperateStockProfitByMonth:0 start:(int)weakSelf.monPagInteger count:0];
        
    }];
    
    [self.monTab addLegendFooterWithRefreshingBlock:^{
        weakSelf.refreshState = MJRefreshState_Footer;
        weakSelf.monPagInteger ++;
        [kHTTPSingle RequestOperateStockProfitByMonth:0 start:(int)weakSelf.monPagInteger count:0];

    }];

    [self.totalTab addGifHeaderWithRefreshingBlock:^{
        [weakSelf setRequestUserDefaults];
        weakSelf.refreshState = MJRefreshState_Header;
        weakSelf.totalPagInteger = 1;
        [kHTTPSingle RequestOperateStockProfitByAll:0 start:(int)weakSelf.totalPagInteger count:0];
    }];
    
    [self.totalTab addLegendFooterWithRefreshingBlock:^{
        [weakSelf setRequestUserDefaults];
        weakSelf.refreshState = MJRefreshState_Footer;
        weakSelf.totalPagInteger ++;
        [kHTTPSingle RequestOperateStockProfitByAll:0 start:(int)weakSelf.totalPagInteger count:0];
    }];

    [self.dayTab.gifHeader loadDefaultImg];
    [self.monTab.gifHeader loadDefaultImg];
    [self.totalTab.gifHeader loadDefaultImg];
    
    Loading_Bird_Show(self.dayTab);
    Loading_Bird_Show(self.monTab);
    Loading_Bird_Show(self.totalTab);
    
    
    [self.dayTab.gifHeader beginRefreshing];
    [self.monTab.gifHeader beginRefreshing];
    [self.totalTab.gifHeader beginRefreshing];
    
    self.dayTab.footer.hidden = YES;
    self.monTab.footer.hidden = YES;
    self.totalTab.footer.hidden = YES;

    
}

#pragma mark 刷新数据
-(void)refreshDayData:(NSNotification *)notfi{

    [self refreshTableDataWithTable:self.dayTab WithTableViewModel:self.dayTableViewModel fromDataDic:(NSDictionary *)notfi.object toDataArray:self.dayDataArray];
}
-(void)refreshMonData:(NSNotification *)notfi{

    [self refreshTableDataWithTable:self.monTab WithTableViewModel:self.monTableViewModel fromDataDic:(NSDictionary *)notfi.object toDataArray:self.monDataArray];

}
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
    
    Loading_Hide(table);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *code = [NSString stringWithFormat:@"%@",fromDataDic[@"code"]];
        if ([code isEqualToString:@"1"]) {//请求成功
            
            if (self.refreshState == MJRefreshState_Header) {//头部刷新需要清空数据
                [toDataArray removeAllObjects];
            }
            
            
            NSArray *fromDataArray = fromDataDic[@"data"];

            //检测有没有上啦加载更多
            if ([fromDataDic[@"refresh"] isEqualToString:@"1"]) {
                if ([fromDataArray  count]==0) {//返回数据时候为0
                    [table.footer noticeNoMoreData];
                    [UIView animateWithDuration:1 animations:^{
                        table.footer.hidden = YES;
                    }];
                }else{
                    table.footer.hidden = NO;
                    [table.footer resetNoMoreData];
                }
                
            }else{
                table.footer.hidden = YES;
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

        if (table.contentSize.height>table.frame.size.height) {
            table.footer.hidden = YES;
        }
        [self chickEmptyViewShowWithTab:table withData:toDataArray withCode:code];
        
    });
}


-(NSMutableArray *)dayDataArray{
    
    if (!_dayDataArray) {
        
        _dayDataArray = [NSMutableArray array];
    }
    return _dayDataArray;
}

-(NSMutableArray *)monDataArray{
    
    if (!_monDataArray) {
        
        _monDataArray = [NSMutableArray array];
    }
    return _monDataArray;
}

-(NSMutableArray *)totalDataArray{
    
    if (!_totalDataArray) {
        
        _totalDataArray = [NSMutableArray array];
    }
    return _totalDataArray;
}

#pragma mark nabbar左右两边按钮事件
- (void)showLeftView
{
    TQMailboxViewController *mailbox = [[TQMailboxViewController alloc] init];
    [self.navigationController pushViewController:mailbox animated:YES];
}

- (void)searchClick
{
    SearchController *search = [[SearchController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}
#pragma mark lazyView 懒加载
-(SliderMenuView *)sliderMenuView{
    
    if (!_sliderMenuView) {
        
        CGFloat navbarH = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        CGFloat tabbarH = CGRectGetHeight(self.tabBarController.tabBar.frame);
        _sliderMenuView = [[SliderMenuView alloc]initWithFrame:(CGRect){0,navbarH,ScreenWidth,ScreenHeight-navbarH-tabbarH} withTitles:@[@"日收益",@"月收益",@"总收益"] withDefaultSelectIndex:1];
        _sliderMenuView.viewArrays = @[self.dayTab,self.monTab,self.totalTab];
        [_sliderMenuView setTopLineViewHide:YES];
    }
    return _sliderMenuView;
}

-(UITableView *)dayTab{

    if (!_dayTab) {
        
        _dayTab = [self createTableViewWithFrame:(CGRect){0,0,ScreenWidth,ScreenHeight} withStyle:UITableViewStylePlain];
        _dayTab.delegate = self.dayTableViewModel;
        _dayTab.dataSource = self.dayTableViewModel;
    }
    
    return _dayTab;
}

-(UITableView *)monTab{
    
    if (!_monTab) {
     
        _monTab = [self createTableViewWithFrame:(CGRect){0,0,ScreenWidth,ScreenHeight} withStyle:UITableViewStylePlain];
        _monTab.delegate = self.monTableViewModel;
        _monTab.dataSource = self.monTableViewModel;
    }
    return _monTab;
}

-(UITableView *)totalTab{
    
    if (!_totalTab) {
        _totalTab = [self createTableViewWithFrame:(CGRect){0,0,ScreenWidth,ScreenHeight} withStyle:UITableViewStylePlain];
        _totalTab.delegate = self.totalTableViewModel;
        _totalTab.dataSource = self.totalTableViewModel;
    }
    return _totalTab;
}

-(StockHomeTableViewModel *)dayTableViewModel{
    if (!_dayTableViewModel) {
        _dayTableViewModel = [[StockHomeTableViewModel alloc]initWithViewModelType:StockHomeTableViewType_StockHomeVC];
        _dayTableViewModel.delegate = self;
    }
    return _dayTableViewModel;
}

-(StockHomeTableViewModel *)monTableViewModel{
    if (!_monTableViewModel) {
        _monTableViewModel = [[StockHomeTableViewModel alloc]initWithViewModelType:StockHomeTableViewType_StockHomeVC];
        _monTableViewModel.delegate = self;
    }
    return _monTableViewModel;
}

-(StockHomeTableViewModel *)totalTableViewModel{
    if (!_totalTableViewModel) {
        _totalTableViewModel = [[StockHomeTableViewModel alloc]initWithViewModelType:StockHomeTableViewType_StockHomeVC];
        _totalTableViewModel.delegate = self;
    }
    return _totalTableViewModel;
}

#pragma mark 请求成功时候-检测是否出现提示图
-(void)chickEmptyViewShowWithTab:(UITableView *)tab withData:(NSMutableArray *)dataArray withCode:(NSString *)code{

    WeakSelf(self);
    
    if (dataArray.count==0&&[code intValue]!=1) {//数据为0 请求失败
        
        [self showErrorViewInView:tab withMsg:RequestState_NetworkErrorStr(code) touchHanleBlock:^{
           
            if (weakSelf.tabViewTag==1) {//日收益
                Loading_Bird_Show(weakSelf.dayTab);
                [weakSelf.dayTab.gifHeader beginRefreshing];
            }else if (weakSelf.tabViewTag==2){//月收益
                Loading_Bird_Show(weakSelf.monTab);
                [weakSelf.monTab.gifHeader beginRefreshing];
            }else if (weakSelf.tabViewTag==3){//总收益
                Loading_Bird_Show(weakSelf.totalTab);
                [weakSelf.totalTab.gifHeader beginRefreshing];
            }
        }];
    }else if (dataArray.count==0&&[code intValue]==1){//数据为0 请求成功
        
        [self showEmptyViewInView:tab withMsg:RequestState_EmptyStr(code) touchHanleBlock:^{
            
            if (weakSelf.tabViewTag==1) {//日收益
                Loading_Bird_Show(weakSelf.dayTab);
                [weakSelf.dayTab.gifHeader beginRefreshing];
            }else if (weakSelf.tabViewTag==2){//月收益
                Loading_Bird_Show(weakSelf.monTab);
                [weakSelf.monTab.gifHeader beginRefreshing];
            }else if (weakSelf.tabViewTag==3){//总收益
                Loading_Bird_Show(weakSelf.totalTab);
                [weakSelf.totalTab.gifHeader beginRefreshing];
            }
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_STOCK_HOME_DAY__VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_STOCK_HOME_MON__VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_STOCK_HOME_TOTAL__VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_CHANGE_THEMESKIN object:nil];

}

#pragma mark StockHomeTableViewModelDelegate
-(void)tabViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath withModel:(id)model{
    
    StockDealModel *stockModel = model;
    StockDealViewController *stockVC = [[StockDealViewController alloc]init];
    stockVC.stockModel = stockModel;
    [self.navigationController pushViewController:stockVC animated:YES];
    
}

#pragma mark 高手操盘总收益的请求 为了和房间内的高手操盘区别
-(void)setRequestUserDefaults{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:MESSAGE_STOCK_HOME_TOTAL__VC forKey:@"RequestOperateStockProfitByAll"];
    [user synchronize];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    RoomViewController *roomView = [RoomViewController sharedRoomViewController];
    if (roomView.room)
    {
        PlayIconView *iconView = [PlayIconView sharedPlayIconView];
        iconView.frame = Rect(0, kScreenHeight-104, kScreenWidth, 60);
        [self.view addSubview:iconView];
        [roomView removeNotice];
        [iconView setRoom:roomView.room];
    }
}


#pragma mark 皮肤切换
-(void)changeThemeSkin:(NSNotification *)notfication{
    DLog(@"切换皮肤");
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [selfWeak changeNavBarThemeSkin];
        
    });
}




@end
