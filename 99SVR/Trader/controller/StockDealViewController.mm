

#define warningLab_h ValueWithTheIPhoneModelString(@"50,50,50,50") //提示信息的高度

#import "StockDealViewController.h"
#import "StockDealHeaderView.h"
#import "StockMacro.h"
#import "StockDealTableModel.h"
#import "HttpMessage.pb.h"
#import "StockDealModel.h"

@interface StockDealViewController ()
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) StockDealHeaderView *headerView;
@property (nonatomic , strong) StockDealTableModel *tableViewModel;
@property (nonatomic , strong) UILabel *warningLab;
/**股票视图的数据*/
@property (nonatomic , strong) StockDealModel *headerModel;
/**数据源*/
@property (nonatomic , strong) NSMutableArray *tableViewDataArray;
@end

@implementation StockDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.view.backgroundColor = COLOR_STOCK_BackGroundColor;
    
    [self initData];
    [self initUI];
}

-(void)initUI{
    
    //表格
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.warningLab;
}

-(void)initData{

    self.txtTitle.text = @"金山";
    self.warningLab.text = @"仅代表讲师个人操盘记录,不构成投资建议，风险自负";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printInfo:) name:MESSAGE_STOCK_DEAL_VC object:nil];
    [kHTTPSingle RequestOperateStockAllDetail:100];


}

-(NSMutableArray *)tableViewDataArray{
    
    if (!_tableViewDataArray) {
        
        _tableViewDataArray = [NSMutableArray array];
    }
    return _tableViewDataArray;
}
- (void)printInfo:(NSNotification *)notify{

    WeakSelf(self);
    
    NSDictionary *dic = notify.object;
    weakSelf.tableViewModel.vipLevel = [dic[@"vipLevel"] integerValue];
    //拿到头部视图的数据
    self.headerModel = dic[@"headerModel"];
    [self.headerView setHeaderViewWithDataModel:self.headerModel];
    //拿到股票视图的数据
    [self.tableViewDataArray addObject:@[dic[@"stockModel"]]];
    //交易详情
    [self.tableViewDataArray addObject:dic[@"trans"]];
    //持仓记录
    [self.tableViewDataArray addObject:dic[@"stocks"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.tableViewModel.dataArray = weakSelf.tableViewDataArray;
        [weakSelf.tableView reloadData];
    });
    
    
}


#pragma mark lazyUI
-(StockDealHeaderView *)headerView{
    
    if (!_headerView) {
        _headerView = [[StockDealHeaderView alloc]initWithFrame:(CGRect){0,0,ScreenWidth,STORCK_Deal_HeaderView_H}];
        
    }
    return _headerView;
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        
        CGFloat navbarH = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        _tableView = [[UITableView alloc]initWithFrame:(CGRect){0,navbarH,ScreenWidth,ScreenHeight-navbarH} style:UITableViewStyleGrouped];
        self.tableViewModel = [[StockDealTableModel alloc]init];
        self.tableViewModel.viewController = self;
        _tableView.delegate = self.tableViewModel;
        _tableView.dataSource = self.tableViewModel;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_STOCK_BackGroundColor;
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

-(UILabel *)warningLab{
    
    if (!_warningLab) {
     
        _warningLab = [[UILabel alloc]init];
        _warningLab.backgroundColor = COLOR_STOCK_BackGroundColor;
        _warningLab.font = [UIFont systemFontOfSize:12];
        _warningLab.textAlignment = NSTextAlignmentCenter;
        _warningLab.textColor = UIColorFromRGB(0xb2b2b2);
        _warningLab.frame = (CGRect){0,0,ScreenWidth,warningLab_h};
    }
    return _warningLab;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{

    NSLog(@"释放");
}


@end
