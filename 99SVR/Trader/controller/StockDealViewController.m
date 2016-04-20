

#define headerView_h ValueWithTheIPhoneModelString(@"150,180,200,220") //表头的高度
#define warningLab_h ValueWithTheIPhoneModelString(@"30,30,30,30") //提示信息的高度

#import "StockDealViewController.h"
#import "StockDealHeaderView.h"
#import "MacroHeader.h"
#import "StockDealTableModel.h"
@interface StockDealViewController ()
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) StockDealHeaderView *headerView;
@property (nonatomic , strong) StockDealTableModel *tableViewModel;
@property (nonatomic , strong) UILabel *warningLab;
@end

@implementation StockDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    [self initUI];
}

-(void)initUI{
    
    //表格
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.headerView;
}

-(void)initData{

    self.txtTitle.text = @"金山";
    //是否是会员
    self.stockState = Stock_State_Vip;
    
    self.warningLab.text = @"仅代表讲师个人操盘记录,不构成投资建议，风险自负";


}

#pragma mark lazyUI
-(StockDealHeaderView *)headerView{
    
    if (!_headerView) {
        _headerView = [[StockDealHeaderView alloc]initWithFrame:(CGRect){0,0,ScreenWidth,headerView_h}];
    }
    
    return _headerView;
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        
        CGFloat navbarH = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        _tableView = [[UITableView alloc]initWithFrame:(CGRect){0,navbarH,ScreenWidth,ScreenHeight-navbarH - warningLab_h} style:UITableViewStylePlain];
        self.tableViewModel = [[StockDealTableModel alloc]init];
        _tableView.delegate = self.tableViewModel;
        _tableView.dataSource = self.tableViewModel;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kTableViewBgColor;
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

-(UILabel *)warningLab{
    
    if (!_warningLab) {
     
        _warningLab = [[UILabel alloc]init];
        _warningLab.backgroundColor = [UIColor grayColor];
        _warningLab.font = [UIFont systemFontOfSize:12];
        _warningLab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_warningLab];
        [_warningLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.and.left.and.right.equalTo(@0);
            make.height.equalTo(@(warningLab_h));
        }];
    }
    return _warningLab;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
