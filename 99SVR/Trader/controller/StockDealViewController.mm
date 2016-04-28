

#define warningLab_h ValueWithTheIPhoneModelString(@"50,50,50,50") //提示信息的高度

#import "StockDealViewController.h"
#import "StockDealHeaderView.h"
#import "StockMacro.h"
#import "StockDealTableModel.h"
#import "HttpMessage.pb.h"
#import "TQPurchaseViewController.h"
#import "ViewNullFactory.h"

@interface StockDealViewController ()
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) StockDealHeaderView *headerView;
@property (nonatomic , strong) StockDealTableModel *tableViewModel;
@property (nonatomic , strong) UILabel *warningLab;
/**股票视图的数据*/
@property (nonatomic , strong) StockDealModel *headerModel;
/**数据源*/
@property (nonatomic , strong) NSMutableArray *tableViewDataArray;
/**数据加载view*/
@property (nonatomic , strong) UIView *emptyView;
@end

@implementation StockDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.view.backgroundColor = COLOR_Bg_Gay;
    
    [self initData];
    [self initUI];
}

-(void)initUI{
    //表格
}

-(void)initData{

    self.txtTitle.text = self.stockModel.teamname;
    self.warningLab.text = @"仅代表讲师个人操盘记录,不构成投资建议，风险自负";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printInfo:) name:MESSAGE_STOCK_DEAL_VC object:nil];
    [kHTTPSingle RequestOperateStockAllDetail:[self.stockModel.operateid intValue]];


}

-(NSMutableArray *)tableViewDataArray{
    
    if (!_tableViewDataArray) {
        
        _tableViewDataArray = [NSMutableArray array];
    }
    return _tableViewDataArray;
}
- (void)printInfo:(NSNotification *)notify{
    
    
    NSDictionary *dic = notify.object;
    NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
    
    
    
    if ([code isEqualToString:@"1"]) {//请求成功
        
        
        //    //拿到头部视图的数据
        self.headerModel = dic[@"headerModel"];
        //    //拿到股票视图的数据
        [self.tableViewDataArray addObject:@[dic[@"stockModel"]]];
        //交易详情
        [self.tableViewDataArray addObject:dic[@"trans"]];
        //持仓记录
        [self.tableViewDataArray addObject:dic[@"stocks"]];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.tableView.tableFooterView = self.warningLab;
            [self.headerView setHeaderViewWithDataModel:self.headerModel];
            [self.tableViewModel setIsShowRecal:dic[@"recalState"] withDataModel:self.headerModel];
            self.tableViewModel.dataArray = self.tableViewDataArray;
            [self.tableView reloadData];
        });
        
    }else{//请求失败
        
        
    }
    
    
    [self chickEmptyViewShow:self.tableViewDataArray withCode:code];

    
}

#pragma mark
-(void)chickEmptyViewShow:(NSMutableArray *)dataArray withCode:(NSString *)code{

    
    if ([code isEqualToString:@"1"]) {//网络OK
        
        if (dataArray.count==0) {//不存在数据
            
            self.emptyView = [ViewNullFactory createViewBg:self.emptyView.bounds imgView:[UIImage imageNamed:@"text_blank_page@3x.png"] msg:@"数据为空"];
            [self.tableView addSubview:self.emptyView];

            
        }else{
            
            if (self.emptyView) {
                [self.emptyView removeFromSuperview];
            }
        }
        
        
    }else{//网络错误
       
        if (dataArray.count==0) {
            
            self.emptyView = [ViewNullFactory createViewBg:self.tableView.bounds imgView:[UIImage imageNamed:@"network_anomaly_fail@3x.png"] msg:[NSString stringWithFormat:@"网络错误代码%@",code]];
            [self.tableView addSubview:self.emptyView];
        }
    }
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
        _tableView.backgroundColor = COLOR_Bg_Gay;
        _tableView.tableHeaderView = self.headerView;
        [self.view addSubview:_tableView];

    }
    return _tableView;
}

-(UILabel *)warningLab{
    
    if (!_warningLab) {
     
        _warningLab = [[UILabel alloc]init];
        _warningLab.backgroundColor = COLOR_Bg_Gay;
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

    DLog(@"释放");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_STOCK_DEAL_VC object:nil];
}


@end
