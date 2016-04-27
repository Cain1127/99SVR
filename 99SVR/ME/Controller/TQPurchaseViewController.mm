

#define headerView_H  ValueWithTheIPhoneModelString(@"120,120,120,120")//表头视图高度


#import "TQPurchaseViewController.h"
#import "Masonry.h"
#import "TQHeadView.h"
#import "TableViewCell.h"
#import "StockMacro.h"
#import "TQPurchaseModel.h"

@interface TQPurchaseViewController () <UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic , strong) TQHeadView *headerView;
@property (nonatomic , copy) NSArray *dataArray;
@property (nonatomic , strong) TQPurchaseModel *headerModel;

@end

@implementation TQPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.txtTitle.text = @"购买私人定制";
    self.dataArray = @[];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDayData:) name:MESSAGE_TQPURCHASE_VC object:nil];
    [kHTTPSingle RequestBuyPrivateServicePage:(int)self.teamId];
    
    self.view.backgroundColor = COLOR_Bg_Gay;
    CGFloat navbarH = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    _tableView = [[UITableView alloc]initWithFrame:(CGRect){0,navbarH,ScreenWidth,ScreenHeight-navbarH} style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //自适应高度
    _tableView.rowHeight = UITableViewAutomaticDimension;
    // 估算高度
    _tableView.estimatedRowHeight = 200;
    _tableView.backgroundColor = COLOR_Bg_Gay;

    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = self.headerView;
    
}


-(TQHeadView *)headerView{
    
    if (!_headerView) {
     
        _headerView = [TQHeadView headView];
        _headerView.backgroundColor = COLOR_Bg_Gay;
        _headerView.height = headerView_H;
    }
    return _headerView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (self.dataArray.count==0) {
        
        return cell;
    }
    
    cell.row = indexPath.row;
    cell.delegate = self;
    [cell setCellDataWithModel:(TQPurchaseModel *)self.dataArray[indexPath.row] withIndexRow:indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableViewCellWithClickButton:(UIButton *)button row:(NSInteger)row
{
    NSLog(@"点击了查看的按钮%zi",row);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 刷新数据
-(void)refreshDayData:(NSNotification *)notfi{
    
    NSString *code = [NSString stringWithFormat:@"%@",[notfi.object valueForKey:@"code"]];
    
    if ([code isEqualToString:@"1"]) {//请求成功
        
        self.headerModel = [notfi.object valueForKey:@"headerModel"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.headerView setHeaderViewWithModel:self.headerModel];
            self.dataArray = [[notfi.object valueForKey:@"data"] copy];
            [self.tableView reloadData];
        });
    }else{//请求失败
    
        
        
        
    }
}


@end
