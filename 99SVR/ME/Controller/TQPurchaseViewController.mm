

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
#import "ProgressHUD.h"

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

    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDayData:) name:MESSAGE_TQPURCHASE_VC object:nil];
    //购买VIP
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyVipData:) name:MESSAGE_BUY_PRIVATE_VIP_VC object:nil];

    [kHTTPSingle RequestBuyPrivateServicePage:[self.stockModel.teamid intValue]];
    
    DLog(@"讲师ID %d",[self.stockModel.teamid intValue]);
    
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
            
            if (index==1) {//购买                
                DLog(@"购买的vip等级%@   的战队ID = %@",model.levelid,self.stockModel.teamid);
                ZLLogonServerSing *sing = [ZLLogonServerSing sharedZLLogonServerSing];
                [sing requestBuyPrivateVip:[self.stockModel.teamid intValue] vipType:[model.levelid intValue]];
                
            }
            
            
        }];
    }else{//需要充值
        
        [self rechargeGold];
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
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([code isEqualToString:@"1"]) {//请求成功
            
            DLog(@"请求成功");
            
            self.headerModel = [notfi.object valueForKey:@"headerModel"];
            self.headerModel.teamName = self.stockModel.teamname;
            
            [self.headerView setHeaderViewWithModel:self.headerModel];
            self.tableView.tableHeaderView = self.headerView;
            self.dataArray = [[notfi.object valueForKey:@"data"] copy];
            
            
        }else{//请求失败
            DLog(@"请求失败 %@",code);
            self.dataArray = @[];
        }
        [self.tableView reloadData];
        [self chickEmptyViewShow:self.dataArray withCode:code];
    });
    
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


#pragma mark vip购买通知
-(void)buyVipData:(NSNotification *)notfi{

    
    NSDictionary *dic = (NSDictionary *)notfi.object;
    NSString *code = dic[@"code"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if ([code isEqualToString:@"1"]) {//
            
            DLog(@"兑换或者升级成功");
            
            
            
            if (self.handle) {
                self.handle();//回调刷新上一界面的股票详情视图
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            
        }else{
        
            if ([code isEqualToString:@"1014"]) {//金币不足请充值
                
                [self rechargeGold];
                
            }else if ([code isEqualToString:@"1015"]){//已经购买
                
                [ProgressHUD showError:@"已经购买"];
                
            }else if ([code isEqualToString:@"1016"]){//没有该私人定制
            
                [ProgressHUD showError:@"没有该私人定制"];
            }else{
            
                [ProgressHUD showError:code];

            }
            
            
            
        }
        
        
    });
}

#pragma mark 充值
-(void)rechargeGold{

    [UIAlertView createAlertViewWithTitle:@"提示" withViewController:self withCancleBtnStr:@"取消" withOtherBtnStr:@"充值" withMessage:@"账户余额不足，需要充值！" completionCallback:^(NSInteger index) {
        if (index==1) {//取消
            DLog(@"去充值");
            PaySelectViewController *paySelectVC = [[PaySelectViewController alloc] init];
            [self.navigationController pushViewController:paySelectVC animated:YES];
        }
    }];

}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_TQPURCHASE_VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_BUY_PRIVATE_VIP_VC object:nil];
}




@end
