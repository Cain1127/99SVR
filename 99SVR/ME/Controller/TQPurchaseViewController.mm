

#define headerView_H  ValueWithTheIPhoneModelString(@"120,120,120,120")//表头视图高度


#import "TQPurchaseViewController.h"
#import "Masonry.h"
#import "TQHeadView.h"
#import "TableViewCell.h"
#import "StockMacro.h"

@interface TQPurchaseViewController () <UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic , strong) TQHeadView *headerView;

@end

@implementation TQPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.txtTitle.text = @"购买私人定制";
    self.view.backgroundColor = COLOR_STOCK_BackGroundColor;
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
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = self.headerView;
    
}


-(TQHeadView *)headerView{
    
    if (!_headerView) {
     
        _headerView = [TQHeadView headView];
        _headerView.backgroundColor = COLOR_STOCK_BackGroundColor;
        _headerView.height = headerView_H;
    }
    return _headerView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.row = indexPath.row;
    cell.delegate = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableViewCellWithClickButton:(UIButton *)button row:(NSInteger)row
{
    NSLog(@"点击了查看的按钮%zi",row);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了对应的cell%zi",indexPath.row);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
