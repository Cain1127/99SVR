

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
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDayData:) name:MESSAGE_TQPURCHASE_VC object:nil];

    [kHTTPSingle RequestBuyPrivateServicePage:[UserInfo sharedUserInfo].nUserId];
    
//    UserInfo *userInfo = [UserInfo sharedUserInfo];
    
    
    
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
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.row = indexPath.row;
    cell.delegate = self;
    
    if (indexPath.row%2==0) {
        
        cell.introduceLab.text = [NSString stringWithFormat:@"我是一个测试VIP。就是一个简单地测试VIP！"];

        
    }else{
        
        cell.introduceLab.text = [NSString stringWithFormat:@"皇冠灯是Bigbang队长GD亲自设计的，打破了应援色或一般应援棒的样式，设计成皇冠，有预示着王者的意义，又与“Vip”的名字相呼应。"];

    }
    
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

    DLog(@"刷新数据---");

}


@end
