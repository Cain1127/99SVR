

#define warningLab_h ValueWithTheIPhoneModelString(@"50,50,50,50") //提示信息的高度

#import "StockDealViewController.h"
#import "StockDealHeaderView.h"
#import "StockMacro.h"
#import "StockDealTableModel.h"
#import "HttpMessage.pb.h"
#import "TQPurchaseViewController.h"
#import "UIViewController+EmpetViewTips.h"
#import "LoginViewController.h"
#import "UIAlertView+Block.h"
#import "StockRecordViewController.h"

@interface StockDealViewController ()<StockDealTableModelDelegate>
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
@property (nonatomic , assign) BOOL isVipBool;
@end

@implementation StockDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_Bg_Gay;
    [self initData];
}

-(void)initData{

    self.txtTitle.text = self.stockModel.teamname;
    self.warningLab.text = @"仅代表讲师个人操盘记录,不构成投资建议，风险自负";
    
    Loading_Bird_Show(self.tableView);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printInfo:) name:MESSAGE_STOCK_DEAL_VC object:nil];
    [kHTTPSingle RequestOperateStockAllDetail:[self.stockModel.operateid intValue]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:MESSAGE_RefreshSTOCK_DEAL_VC object:nil];
}

-(NSMutableArray *)tableViewDataArray{
    
    if (!_tableViewDataArray) {
        
        _tableViewDataArray = [NSMutableArray array];
    }
    return _tableViewDataArray;
}
- (void)printInfo:(NSNotification *)notify{
    

    Loading_Bird_Hide(self.tableView);
    NSDictionary *dic = notify.object;
    NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
    [self.view hideToastActivity];
    
    dispatch_async(dispatch_get_main_queue(), ^{

    if ([code isEqualToString:@"1"]) {//请求成功
        
        [self.tableViewDataArray removeAllObjects];
        
        //拿到头部视图的数据
        self.headerView.backgroundColor = COLOR_Bg_Blue;
        self.headerModel = dic[@"headerModel"];
        //拿到股票视图的数据
        [self.tableViewDataArray addObject:@[dic[@"stockModel"]]];
        //交易详情
        [self.tableViewDataArray addObject:dic[@"trans"]];
        //持仓记录
        [self.tableViewDataArray addObject:dic[@"stocks"]];

        
        if ([[NSString stringWithFormat:@"%@",dic[@"recalState"]] isEqualToString:@"show"]) {//是否是VIP
            self.isVipBool = YES;
        }else{
            self.isVipBool = NO;
        }
        
        
        self.tableView.tableFooterView = self.warningLab;
        [self.headerView setHeaderViewWithDataModel:self.headerModel];
        [self.tableViewModel setIsShowRecal:dic[@"recalState"] withDataModel:self.headerModel];
        self.tableViewModel.dataArray = self.tableViewDataArray;
        [self.tableView reloadData];
        
    }else{//请求失败
        
        self.headerView.backgroundColor = COLOR_Bg_Gay;
        self.tableView.backgroundColor = COLOR_Bg_Gay;
    }
    [self chickEmptyViewShow:self.tableViewDataArray withCode:code];
    
    });

}

#pragma mark
-(void)chickEmptyViewShow:(NSArray *)dataArray withCode:(NSString *)code{
    
    WeakSelf(self);
    
    if (dataArray.count==0&&[code intValue]!=1) {//数据为0 错误代码不为1
        
        [self showErrorViewInView:self.tableView withMsg:[NSString stringWithFormat:@"网络链接错误%@,点击重新链接",code] touchHanleBlock:^{
            
            Loading_Bird_Show(weakSelf.tableView);
            [kHTTPSingle RequestOperateStockAllDetail:[weakSelf.stockModel.operateid intValue]];
        }];
        
    }else if (dataArray.count==0&&[code intValue]==1){
        
        [self showEmptyViewInView:self.tableView withMsg:[NSString stringWithFormat:@"暂无数据%@",code] touchHanleBlock:^{
            
        }];
        
    }else{
        [self hideEmptyViewInView:self.tableView];
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
        self.tableViewModel.delegate = self;
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

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}
-(void)dealloc{

    DLog(@"delloc---------StockDealViewController");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_STOCK_DEAL_VC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_RefreshSTOCK_DEAL_VC object:nil];

}

#pragma mark refreshData 再次刷新页面数据
-(void)refreshData:(NSNotification *)notify{

    dispatch_async(dispatch_get_main_queue(), ^{
        //再次刷新
        [self.view makeToastActivity];
        [kHTTPSingle RequestOperateStockAllDetail:[self.stockModel.operateid intValue]];
        
    });
}


#pragma mark StockDealTableModelDelegate
#pragma mark 去购买VIP
-(void)goBuyVipService{
 
    [self goBuyVipServiceViewController];
}

#pragma mark 点击tableHeaderViw的提示
-(void)didClickTableHeaderViewTag:(NSInteger)tag{
        
    WeakSelf(self);
    
    if (tag==1 || tag==2) {
        
        if (self.isVipBool) {
            
            StockRecordViewController *recordVC = [[StockRecordViewController alloc]init];
            recordVC.recordType = tag==1 ? RecordType_Business : RecordType_StoreHouse;
            recordVC.operateId = [self.headerModel.operateid integerValue];
            [self.navigationController pushViewController:recordVC animated:YES];
            
        }else{
            
            [UIAlertView createAlertViewWithTitle:@"温馨提示" withViewController:self withCancleBtnStr:@"取消" withOtherBtnStr:@"去兑换" withMessage:[NSString stringWithFormat:@"需要兑换私人订制服务-vip%@才能查看详细内容",self.headerModel.minVipLevel] completionCallback:^(NSInteger index) {
                
                if (index==1) {
                    [weakSelf goBuyVipServiceViewController];
                }
                
            }];
        }
        
    }
}
#pragma mark 点击tableView的跳转
-(void)didSelectRowAtIndexPathWithTableView:(NSIndexPath *)indexPath{
    
    if (self.isVipBool) {
        if (indexPath.section==1 || indexPath.section==2) {
            StockRecordViewController *recordVC = [[StockRecordViewController alloc]init];
            recordVC.recordType = indexPath.section==1 ? RecordType_Business : RecordType_StoreHouse;
            recordVC.operateId = [self.headerModel.operateid integerValue];
            [self.navigationController pushViewController:recordVC animated:YES];
        }
    }
    
}


#pragma mark 购买VIP页面
-(void)goBuyVipServiceViewController{
    
    if ([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1) {//已登陆 //1：注册账户
        
        TQPurchaseViewController *tqVC = [[TQPurchaseViewController alloc]init];
        tqVC.stockModel = self.headerModel;
        [self.navigationController pushViewController:tqVC animated:YES];
        
    }else{//未登录
        [UIAlertView createAlertViewWithTitle:@"提示" withViewController:self withCancleBtnStr:@"取消" withOtherBtnStr:@"确定" withMessage:@"未登陆，请登陆后操作" completionCallback:^(NSInteger index) {
            if (index==1) {
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }];
    }
}


@end
