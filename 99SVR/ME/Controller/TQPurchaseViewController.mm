

#define headerView_H  ValueWithTheIPhoneModelString(@"120,120,120,120")//表头视图高度


#import "TQPurchaseViewController.h"
#import "Masonry.h"
#import "TQHeadView.h"
#import "TableViewCell.h"
#import "StockMacro.h"
#import "TQPurchaseModel.h"
#import "UIAlertView+Block.h"
#import "PaySelectViewController.h"
#import "ViewNullFactory.h"


@interface TQPurchaseViewController () <UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic , strong) TQHeadView *headerView;
@property (nonatomic , copy) NSArray *dataArray;
@property (nonatomic , strong) TQPurchaseModel *headerModel;
/**数据加载view*/
@property (nonatomic , strong) UIView *emptyView;
@end

@implementation TQPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Loading_Bird_Show
    
    self.txtTitle.text = @"购买私人定制";
    self.dataArray = @[];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view makeToastActivity];
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

                PaySelectViewController *paySelectVC = [[PaySelectViewController alloc] init];
                [self.navigationController pushViewController:paySelectVC animated:YES];

                
            }
            
            
        }];
        
        
        
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 刷新数据
-(void)refreshDayData:(NSNotification *)notfi{
    
    Loading_Bird_Hide
    
    NSString *code = [NSString stringWithFormat:@"%@",[notfi.object valueForKey:@"code"]];
    
    [self.view hideToastActivity];

    
    if ([code isEqualToString:@"1"]) {//请求成功
        
        DLog(@"请求成功");
        
        self.headerModel = [notfi.object valueForKey:@"headerModel"];
        self.headerModel.teamName = self.stockModel.teamname;


        dispatch_async(dispatch_get_main_queue(), ^{
            [self.headerView setHeaderViewWithModel:self.headerModel];
            self.tableView.tableHeaderView = self.headerView;
            [self.tableView reloadData];
        });

        
    }else{//请求失败
    
        
        DLog(@"请求失败 %@",code);
        
    }
    self.dataArray = [[notfi.object valueForKey:@"data"] copy];

    
    [self chickEmptyViewShow:self.dataArray withCode:code];

    
}


-(void)chickEmptyViewShow:(NSArray *)dataArray withCode:(NSString *)code{
    
    
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

@end
