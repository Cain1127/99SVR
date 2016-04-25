


#import "StockHomeViewController.h"
#import "SliderMenuView.h"
#import "ShareFunction.h"
#import "SearchController.h"
#import "StockMacro.h"
#import "StockDealViewController.h"
#import "StockHomeTableViewModel.h"
#import "MJRefresh.h"
#import "MJRefreshComponent.h"
#import "StockDealModel.h"
#import "TQMailboxViewController.h"

@interface StockHomeViewController ()
/**滑动控制器*/
@property (nonatomic, strong) SliderMenuView *sliderMenuView;
/**日*/
@property (nonatomic, strong) UITableView *dayTab;
@property (nonatomic ,strong) StockHomeTableViewModel *dayTableViewModel;
@property (nonatomic , strong) NSMutableArray *dayDataArray;

/**月*/
@property (nonatomic, strong) UITableView *monTab;
@property (nonatomic ,strong) StockHomeTableViewModel *monTableViewModel;
@property (nonatomic , strong) NSMutableArray *monDataArray;

/**总的*/
@property (nonatomic, strong) UITableView *totalTab;
@property (nonatomic ,strong) StockHomeTableViewModel *totalTableViewModel;
@property (nonatomic , strong) NSMutableArray *totalDataArray;



@end

@implementation StockHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUi];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark initUi
-(void)initUi{
    
    [self.navigationController.navigationBar setHidden:YES];
    UIView *_headView  = [[UIView alloc] initWithFrame:Rect(0, 0,kScreenWidth,64)];
    [self.view addSubview:_headView];
    _headView.backgroundColor = UIColorFromRGB(0xffffff);
    UILabel *title;
    title = [[UILabel alloc] initWithFrame:Rect(44,33,kScreenWidth-88, 20)];
    [title setFont:XCFONT(20)];
    [_headView addSubview:title];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:UIColorFromRGB(0x0078DD)];
    UILabel *_lblContent;
    _lblContent = [[UILabel alloc] initWithFrame:Rect(0, 63.5, kScreenWidth, 0.5)];
    [_lblContent setBackgroundColor:[UIColor whiteColor]];
    [_headView addSubview:_lblContent];
    title.text = @"高手操盘";
    UIButton *btnLeft = [CustomViewController itemWithTarget:self action:@selector(showLeftView) image:@"nav_menu_icon_n" highImage:@"nav_menu_icon_p"];
    [self.view addSubview:btnLeft];
    [btnLeft setFrame:Rect(0,20,44,44)];
    
    UIButton *btnRight = [CustomViewController itemWithTarget:self action:@selector(searchClick) image:@"nav_search_icon_n" highImage:@"nav_search_icon_p"];
    [_headView addSubview:btnRight];
    [btnRight setFrame:Rect(kScreenWidth-44, 20, 44, 44)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.sliderMenuView];
    self.sliderMenuView.DidSelectSliderIndex = ^(NSInteger index){
        NSLog(@"模块%ld",(long)index);
    };
    

    
}

#pragma mark initData
-(void)initData{
    
    WeakSelf(self);

    //day
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDayData:) name:MESSAGE_STOCK_HOME_DAY__VC object:nil];
    //mon
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMonData:) name:MESSAGE_STOCK_HOME_MON__VC object:nil];
    //total
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTotalData:) name:MESSAGE_STOCK_HOME_TOTAL__VC object:nil];
    [self.dayTab addGifHeaderWithRefreshingBlock:^{
        
        [weakSelf.dayDataArray removeAllObjects];
        [kHTTPSingle RequestOperateStockProfitByDay:0 start:0 count:2];
    }];
    
    [self.dayTab addLegendFooterWithRefreshingBlock:^{
        
        StockDealModel *model = [weakSelf.dayDataArray lastObject];
        [kHTTPSingle RequestOperateStockProfitByDay:0 start:[model.transId intValue] count:2];

        
    }];
    
    
    
    [self.monTab addGifHeaderWithRefreshingBlock:^{
        [weakSelf.monDataArray removeAllObjects];
        [kHTTPSingle RequestOperateStockProfitByMonth:0 start:0 count:5];
        
    }];
    
    [self.monTab addLegendFooterWithRefreshingBlock:^{
        
        StockDealModel *model = [weakSelf.monDataArray lastObject];
        [kHTTPSingle RequestOperateStockProfitByMonth:0 start:[model.transId intValue] count:5];

    }];
    
    

    [self.totalTab addGifHeaderWithRefreshingBlock:^{
        [weakSelf.totalDataArray removeAllObjects];
        [kHTTPSingle RequestOperateStockProfitByAll:0 start:0 count:5];
    }];
    
    [self.totalTab addLegendFooterWithRefreshingBlock:^{
        
        StockDealModel *model = [weakSelf.totalDataArray lastObject];
        [kHTTPSingle RequestOperateStockProfitByAll:0 start:[model.transId intValue] count:5];
    }];

    [self.dayTab.gifHeader loadDefaultImg];
    [self.monTab.gifHeader loadDefaultImg];
    [self.totalTab.gifHeader loadDefaultImg];
    

    [self.dayTab.gifHeader beginRefreshing];
    [self.monTab.gifHeader beginRefreshing];
    [self.totalTab.gifHeader beginRefreshing];
    
}


#pragma mark 刷新数据
-(void)refreshDayData:(NSNotification *)notfi{
    [self refreshTableDataWithTable:self.dayTab WithTableViewModel:self.dayTableViewModel fromDataArray:(NSArray *)notfi.object toDataArray:self.dayDataArray];
}
-(void)refreshMonData:(NSNotification *)notfi{

    [self refreshTableDataWithTable:self.monTab WithTableViewModel:self.monTableViewModel fromDataArray:(NSArray *)notfi.object toDataArray:self.monDataArray];

}
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
    }else{
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
        _dayTableViewModel = [[StockHomeTableViewModel alloc]initWithViewController:self];
    }
    return _dayTableViewModel;
}

-(StockHomeTableViewModel *)monTableViewModel{
    if (!_monTableViewModel) {
        _monTableViewModel = [[StockHomeTableViewModel alloc]initWithViewController:self];
    }
    return _monTableViewModel;
}

-(StockHomeTableViewModel *)totalTableViewModel{
    if (!_totalTableViewModel) {
        _totalTableViewModel = [[StockHomeTableViewModel alloc]initWithViewController:self];
    }
    return _totalTableViewModel;
}


-(UITableView *)createTableViewWithFrame:(CGRect)frame withStyle:(UITableViewStyle)style{
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:style];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = COLOR_STOCK_BackGroundColor;
    return tableView;
}

-(void)dealloc{
    
    DLog(@"释放");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_STOCK_HOME_DAY__VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_STOCK_HOME_MON__VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_STOCK_HOME_TOTAL__VC object:nil];

}


@end
