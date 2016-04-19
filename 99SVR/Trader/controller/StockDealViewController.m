

#define headerView_h ValueWithTheIPhoneModelString(@"100,120,150,180") //表头的高度

#import "StockDealViewController.h"
#import "StockDealHeaderView.h"
#import "MacroHeader.h"
@interface StockDealViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) StockDealHeaderView *headerView;
@end

@implementation StockDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    [self initUI];

<<<<<<< HEAD

    
=======
>>>>>>> master
}

-(void)initUI{
    
    //表格
    [self.view addSubview:self.tableView];
    
    
}

-(void)initData{

    self.txtTitle.text = @"金山";
    //是否是会员
    self.stockState = Stock_State_Vip;

}

#pragma mark lazyUI
-(StockDealHeaderView *)headerView{
    
    if (!_headerView) {
        

        _headerView.backgroundColor = [UIColor grayColor];
    }
    
    return _headerView;
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        
        CGFloat navbarH = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        _tableView = [[UITableView alloc]initWithFrame:(CGRect){0,navbarH,ScreenWidth,ScreenHeight-navbarH} style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

#pragma mark Tab
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.text = @"sssss";
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
