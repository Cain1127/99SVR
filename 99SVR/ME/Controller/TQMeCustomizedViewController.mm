//
//  TQMeCustomizedViewController.m
//  99SVR
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//已经购买的私人定制界面

#import "TQMeCustomizedViewController.h"
#import "TQMeCustomizedModel.h"
#import "TQNoCustomView.h"
#import "TQNoPurchaseViewController.h"
#import "UIBarButtonItem+Item.h"
#import "HttpManagerSing.h"
#import "TableViewFactory.h"
#import "XMeCustomDataSource.h"
#import "XPrivateDetailViewController.h"

@interface TQMeCustomizedViewController ()<MeCustomDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *aryPurchase;;
@property (nonatomic,strong) XMeCustomDataSource *dataSource;
@end

@implementation TQMeCustomizedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//        TQNoCustomView *NOView = [[TQNoCustomView alloc] initWithFrame:self.view.bounds];
//        [self.view addSubview:NOView];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushIntroductController) name:MESSAGE_TQINTORDUCT_VC object:nil];
//
    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0,64,kScreenWidth,kScreenHeight-64) withStyle:UITableViewStylePlain];
    [_tableView setBackgroundColor:UIColorFromRGB(0xffffff)];
    _dataSource = [[XMeCustomDataSource alloc] init];
    _dataSource.delegate = self;
    [self initUi];
}
-(void)nopurchaseVc {
    TQNoPurchaseViewController *vc = [[TQNoPurchaseViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)initUi{
    [self setTitleText:@"我的私人定制"];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"私人定制未购买页" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(nopurchaseVc) forControlEvents:UIControlEventTouchUpInside];
    [self setRightBtn:rightBtn];
}

- (void)noPurchase:(NSNotification *)notify
{
    
}

- (void)havePurchase:(NSNotification *)notify
{
    NSArray *aryModel = notify.object;
    _dataSource.aryModel = aryModel;
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        [selfWeak.view addSubview:_tableView];
        selfWeak.tableView.delegate = _dataSource;
        selfWeak.tableView.dataSource = _dataSource;
        [selfWeak.tableView reloadData];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noPurchase:) name:MESSAGE_HTTP_NOPURCHASE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(havePurchase:) name:MESSAGE_HTTP_MYPRIVATESERVICE_VC object:nil];
    [kHTTPSingle RequestMyPrivateService:KUserSingleton.nUserId];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)dealloc {
}


- (void)selectIndex:(TQMeCustomizedModel *)model
{
    XPrivateDetailViewController *detailView = [[XPrivateDetailViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:detailView animated:YES];
}

@end
