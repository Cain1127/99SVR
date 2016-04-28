

#define headerView_H  ValueWithTheIPhoneModelString(@"120,120,120,120")//表头视图高度


#import "TQPurchaseViewController.h"
#import "Masonry.h"
#import "TQHeadView.h"
#import "TableViewCell.h"
#import "StockMacro.h"
#import "TQPurchaseModel.h"
#import "UIAlertView+Block.h"

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
    [kHTTPSingle RequestBuyPrivateServicePage:[self.stockModel.teamid intValue]];
    
    self.view.backgroundColor = COLOR_Bg_Gay;
}


-(TQHeadView *)headerView{
    
    if (!_headerView) {
     
        _headerView = [TQHeadView headView];
        _headerView.backgroundColor = COLOR_Bg_Gay;
        _headerView.height = headerView_H;
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
        [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        //自适应高度
        _tableView.rowHeight = UITableViewAutomaticDimension;
        // 估算高度
        _tableView.estimatedRowHeight = 200;
        _tableView.backgroundColor = COLOR_Bg_Gay;
        [self.view addSubview:_tableView];
        _tableView.tableHeaderView = self.headerView;
    }
    
    return _tableView;
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
    TQPurchaseModel *model = self.dataArray[row];
    
    if ([UserInfo sharedUserInfo].goldCoin >= [model.actualPrice floatValue]) {//账户余额大于购买的余额
        
        [UIAlertView createAlertViewWithTitle:@"提示" withViewController:self withCancleBtnStr:@"取消" withOtherBtnStr:@"兑换" withMessage:@"是否确定兑换！" completionCallback:^(NSInteger index) {
            
            if (index==0) {//取消
                
                DLog(@"取消兑换");
                
            }else{
                
                DLog(@"去购买");

                
                
            }
            
            
        }];

        
        
    }else{//需要充值
        
        [UIAlertView createAlertViewWithTitle:@"提示" withViewController:self withCancleBtnStr:@"取消" withOtherBtnStr:@"充值" withMessage:@"账户余额不足，需要充值！" completionCallback:^(NSInteger index) {
            
            if (index==0) {//取消
                
                DLog(@"取消充值");

                
            }else{
                
                DLog(@"去充值");

                
                
            }
            
            
        }];
        
        
        
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 刷新数据
-(void)refreshDayData:(NSNotification *)notfi{
    
    NSString *code = [NSString stringWithFormat:@"%@",[notfi.object valueForKey:@"code"]];
    
    if ([code isEqualToString:@"1"]) {//请求成功
        
        DLog(@"请求成功");
        
        self.headerModel = [notfi.object valueForKey:@"headerModel"];
        self.headerModel.teamName = self.stockModel.teamname;
        [self.headerView setHeaderViewWithModel:self.headerModel];

    }else{//请求失败
    
        
        DLog(@"请求失败");
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.dataArray = [[notfi.object valueForKey:@"data"] copy];
        [self.tableView reloadData];
    });
    
}


@end
