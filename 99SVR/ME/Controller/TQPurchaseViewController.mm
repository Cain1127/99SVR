

#define headerView_H  ValueWithTheIPhoneModelString(@"120,120,120,120")//表头视图高度


#import "TQPurchaseViewController.h"
#import "Masonry.h"
#import "TQHeadView.h"
#import "TableViewCell.h"
#import "StockMacro.h"
#import "TQPurchaseModel.h"
#import "UIAlertView+Block.h"
#import "PaySelectViewController.h"
#import "UIViewController+EmpetViewTips.h"
#import "MBProgressHUD.h"
#import "BandingMobileViewController.h"

@interface TQPurchaseViewController () <UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic , strong) TQHeadView *headerView;
@property (nonatomic , copy) NSArray *dataArray;
@property (nonatomic , strong) TQPurchaseModel *headerModel;
/**数据加载view*/
@property (nonatomic , strong) UIView *emptyView;
@property (nonatomic,assign) int nId;
@property (nonatomic,copy) NSString *strName;
@end

@implementation TQPurchaseViewController

- (id)initWithTeamId:(int)nId name:(NSString *)strName
{
    self = [super init];
    _nId = nId;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Loading_Bird_Show(self.tableView);
    self.txtTitle.text = @"购买私人定制";
    self.dataArray = @[];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDayData:) name:MESSAGE_TQPURCHASE_VC object:nil];
    //购买VIP
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyVipData:) name:MESSAGE_BUY_PRIVATE_VIP_VC object:nil];

    if (_nId) {
        [kHTTPSingle RequestBuyPrivateServicePage:_nId];
    }
    else
    {
        [kHTTPSingle RequestBuyPrivateServicePage:[self.stockModel.teamid intValue]];
    }
    
//    DLog(@"讲师ID %d",[self.stockModel.teamid intValue]);
    
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
                [MBProgressHUD showMessage:@"Vip兑换中..."];
                ZLLogonServerSing *sing = [ZLLogonServerSing sharedZLLogonServerSing];
                if(_nId)
                {
                    [sing requestBuyPrivateVip:_nId vipType:[model.levelid intValue]];
                }else
                {
                    [sing requestBuyPrivateVip:[self.stockModel.teamid intValue] vipType:[model.levelid intValue]];
                }
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
    
    Loading_Bird_Hide(self.tableView);
    
    NSString *code = [NSString stringWithFormat:@"%@",[notfi.object valueForKey:@"code"]];
    
    [self.view hideToastActivity];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([code isEqualToString:@"1"]) {//请求成功
            self.headerModel = [notfi.object valueForKey:@"headerModel"];
            self.headerModel.teamIcon = self.stockModel.teamicon;
            if(_strName)
            {
                self.headerModel.teamName = _strName;
            }
            else{
                self.headerModel.teamName = self.stockModel.teamname;
            }
            
            [self.headerView setHeaderViewWithModel:self.headerModel];
            self.tableView.tableHeaderView = self.headerView;
            self.dataArray = [[notfi.object valueForKey:@"data"] copy];
            
            
        }else{//请求失败
            self.dataArray = @[];
        }
        [self.tableView reloadData];
        [self chickEmptyViewShow:self.dataArray withCode:code];
    });
    
}




-(void)chickEmptyViewShow:(NSArray *)dataArray withCode:(NSString *)code{
    
    WeakSelf(self);
    
    if (dataArray.count==0&&[code intValue]!=1) {//数据为0 错误代码不为1
        
        [self showErrorViewInView:self.tableView withMsg:[NSString stringWithFormat:@"网络链接错误%@,点击重新链接",code] touchHanleBlock:^{
            
            Loading_Bird_Show(weakSelf.tableView);
            [kHTTPSingle RequestBuyPrivateServicePage:[weakSelf.stockModel.teamid intValue]];
            
        }];

    }else if (dataArray.count==0&&[code intValue]==1){
    
        [self showEmptyViewInView:self.tableView withMsg:[NSString stringWithFormat:@"暂无数据%@",code] touchHanleBlock:^{
            
            
        }];
    
    }else{
        [self hideEmptyViewInView:self.tableView];
    }
}


#pragma mark vip购买通知
-(void)buyVipData:(NSNotification *)notfi{

    WeakSelf(self);
    
    NSDictionary *dic = (NSDictionary *)notfi.object;
    NSString *code = dic[@"code"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUD];
        
        if ([code isEqualToString:@"1"]) {//
            
            if ([UserInfo sharedUserInfo].banding) {//已绑定
                [MBProgressHUD showMessage:@"兑换成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD hideHUD];
                    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_RefreshSTOCK_DEAL_VC object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }else{//未绑定
                
                [UIAlertView createAlertViewWithTitle:@"温馨提示" withViewController:self withCancleBtnStr:@"取消" withOtherBtnStr:@"绑定" withMessage:@"Vip兑换成功！请绑定您的手机号，才能享受完整的Vip服务" completionCallback:^(NSInteger index) {
                    if (index==1) {//绑定手机
                        BandingMobileViewController *bangdingVC = [[BandingMobileViewController alloc]init];
                        [weakSelf.navigationController pushViewController:bangdingVC animated:YES];
                    }else{
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_RefreshSTOCK_DEAL_VC object:nil];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
            
        }else{
        
            if ([code isEqualToString:@"1014"]) {//金币不足请充值
                
                [self rechargeGold];
                
            }else if ([code isEqualToString:@"1015"]){//已经购买
                
                [ProgressHUD showError:@"已经兑换该等级私人订制"];
                
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


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_TQPURCHASE_VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_BUY_PRIVATE_VIP_VC object:nil];
}




@end
