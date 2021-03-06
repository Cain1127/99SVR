//
//  InAppPurchasesViewController.m
//  99SVR
//
//  Created by ysmeng on 16/3/31.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "InAppPurchasesViewController.h"
#import "GTMBase64.h"
#import "ProgressHUD.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "SBJsonWriter.h"
#import <StoreKit/StoreKit.h>

///SKPaymentTransactionObserver
@interface InAppPurchasesViewController () <SKProductsRequestDelegate, SKPaymentTransactionObserver, UITableViewDelegate, UITableViewDataSource>

///商品列表
@property (nonatomic, strong) UITableView *purchasesListTableView;

///当前请求状态，避免重复下拉刷新
@property (nonatomic, assign) BOOL isRefreshing;

///商品请求
@property (nonatomic, strong) SKProductsRequest *purchasesRequest;

///商品列表
@property (nonatomic, strong) NSMutableArray *purchasesArray;

///当前选择的商品下标
@property (nonatomic, assign) NSInteger currentPickedIndex;

@end

@implementation InAppPurchasesViewController

#pragma mark -
#pragma mark - VC life circle
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self setTitleText:@"金币商店"];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    ///初始化数据源
    self.purchasesArray = [NSMutableArray array];
    self.currentPickedIndex = 0;
    self.isRefreshing = NO;
    
    ///右侧提交按钮
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = Rect(kScreenWidth - 44.0f, 20.0f, 44.0f, 44.0f);
    [commitButton setTitle:@"购买" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [commitButton addTarget:self action:@selector(commitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    commitButton.titleLabel.font = XCFONT(16);
    [self.view addSubview:commitButton];
    
    ///判断当前是否允许内购付费
    if (![SKPaymentQueue canMakePayments])
    {
        
        UIAlertView *tips = [[UIAlertView alloc] initWithTitle:@"In App purechases" message:@"当前设置不允许内购！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [tips show];
        return;
        
    }
    
    ///创建商品列表UI
    [self initPurchasesListTableView];
    
    ///请求商品
    [self initInAppPurchasesRequest];
    
}

///初始化商品请求并发起一次请求
- (void)initInAppPurchasesRequest
{

    /// 2 实例化产品请求：模拟商品
    NSArray *productArray = @[@"com.HCTT.SVRNN.JJGold1",
                              @"com.HCTT.SVRNN.JJGold2",
                              @"com.HCTT.SVRNN.JJGold3",
                              @"com.HCTT.SVRNN.JJGold4",
                              @"com.HCTT.SVRNN.JJGold5"];
    self.purchasesRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productArray]];
    
    /// 3 设置代理
    [self.purchasesRequest setDelegate:self];
    
    /// 4 启动请求
    self.isRefreshing = YES;
    [self.purchasesRequest start];

}

///创建默认的商品列表
- (void)initPurchasesListTableView
{
    self.purchasesListTableView = [[UITableView alloc] initWithFrame:Rect(0.0f, kNavigationHeight + 10.0f, kScreenWidth, kScreenHeight - kNavigationHeight - 10.0f) style:UITableViewStylePlain];
    self.purchasesListTableView.delegate = self;
    self.purchasesListTableView.dataSource = self;
    self.purchasesListTableView.showsVerticalScrollIndicator = NO;
    self.purchasesListTableView.showsHorizontalScrollIndicator = NO;
    self.purchasesListTableView.allowsSelection = YES;
    self.purchasesListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.purchasesListTableView];
    
    ///添加头部刷新
    @WeakObj(self);
    [self.purchasesListTableView addLegendHeaderWithRefreshingBlock:^{
        
        ///判断当前状态
        if (selfWeak.isRefreshing)
        {
            
            return;
            
        }
        
        ///重新请求商品
        selfWeak.isRefreshing = YES;
        [selfWeak.purchasesRequest start];
        
    }];

}

#pragma mark -
#pragma mark - 购买内购商品
- (void)commitButtonAction:(UIButton *)button
{

    ///判断当前的采购是否有效
    if (self.currentPickedIndex < self.purchasesArray.count &&
        0 <= self.currentPickedIndex)
    {
        
        ///显示HUD
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        SKPayment *payment = [SKPayment paymentWithProduct:self.purchasesArray[self.currentPickedIndex]];
        
        NSLog(@"::::::::::发送购买请求");
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
    }

}



#pragma mark -
#pragma mark - SKProductsRequestDelegate
///收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    NSLog(@"::::::::::收到产品反馈消息");
    NSArray *productsArray = response.products;
    if (0 >= productsArray)
    {
        NSLog(@"::::::::::没有商品");
        [ProgressHUD showError:@"没有此商品"];
        ///停止头部刷新
        [self.purchasesListTableView.header endRefreshing];
        self.isRefreshing = NO;
        
        return;
    }
    
    ///清空原数据
    [self.purchasesArray removeAllObjects];
    
    ///打印商品信息
    for (SKProduct *pro in productsArray)
    {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
    }
    
    ///将新商品放入数据源
    [self.purchasesArray addObjectsFromArray:productsArray];
    
    ///刷新列表
    [self.purchasesListTableView reloadData];
    
    ///停止头部刷新
    [self.purchasesListTableView.header endRefreshing];
    self.isRefreshing = NO;
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
    } else {
        NSLog(@"用户取消交易");
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(BOOL)putStringToItunes:(NSData*)iapData type:(BOOL)bFlag
{
    //用户购成功的transactionReceipt
    
    NSString* encodingStr = [GTMBase64 encodeBase64Data:iapData];
    NSString *URL;
    if(bFlag)
    {
       URL =@"https://buy.itunes.apple.com/verifyReceipt";
        
    }else{
       URL=@"https://sandbox.itunes.apple.com/verifyReceipt";
    }
    
    //https://buy.itunes.apple.com/verifyReceipt
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];// autorelease];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    //设置contentType
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%zi", [encodingStr length]] forHTTPHeaderField:@"Content-Length"];
    
    NSDictionary* body = [NSDictionary dictionaryWithObjectsAndKeys:encodingStr, @"receipt-data", nil];
    SBJsonWriter *writer = [SBJsonWriter new];
    
    [request setHTTPBody:[[writer stringWithObject:body] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    NSHTTPURLResponse *urlResponse=nil;
    NSError *errorr=nil;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&urlResponse
                                                             error:&errorr];
    
    //解析
    NSString *results=[[NSString alloc]initWithBytes:[receivedData bytes] length:[receivedData length] encoding:NSUTF8StringEncoding];
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:[results dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"result:%@",results);
    if([[resultDict objectForKey:@"status"] intValue]==1){
        [self.navigationController popViewControllerAnimated:YES];
        return true;
    }
    return false;
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"?????");
}
#pragma mark -
#pragma mark - in app payment delegate
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        
        // 购买完成
        if (transaction.transactionState == SKPaymentTransactionStatePurchased)
        {
            [self putStringToItunes:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] type:transaction.payment.simulatesAskToBuyInSandbox];
//            NSLog(@"transaction:%@",transaction.payment);
//            NSLog(@"transaction:%d",transaction.payment.simulatesAskToBuyInSandbox);
//            NSLog(@"transaction:%@",transaction);
//            NSLog(@"transaction:%@",transaction);
            [queue finishTransaction:transaction];
//            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (transaction.transactionState == SKPaymentTransactionStateFailed)
        {
            
            if (transaction.error.code != SKErrorPaymentCancelled)
            {
                [self failedTransaction:transaction];
            }
        }
    }
    
    ///隐藏HUD
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.isRefreshing = NO;
    
}


#pragma mark -
#pragma mark - UITableViewDelegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.purchasesArray.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 60.0f;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *purchasesCellName = @"purchasesCellName";
    UITableViewCell *cellPurchases = [tableView dequeueReusableCellWithIdentifier:purchasesCellName];
    if (!cellPurchases)
    {
        
        cellPurchases = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:purchasesCellName];
        cellPurchases.selectionStyle = UITableViewCellSelectionStyleNone;
        cellPurchases.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    ///设置选择状态
    if (self.currentPickedIndex == indexPath.row)
    {
        cellPurchases.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cellPurchases.accessoryType = UITableViewCellAccessoryNone;
    }
    
    ///更新标题
    SKProduct *dataModel = self.purchasesArray[indexPath.row];
    cellPurchases.textLabel.text = [NSString stringWithFormat:@"$%@      %@", dataModel.price, dataModel.localizedTitle];
    cellPurchases.detailTextLabel.numberOfLines = 0;
    cellPurchases.detailTextLabel.text = dataModel.localizedDescription;
    
    return cellPurchases;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ///刷新列表
    NSInteger origilIndex = self.currentPickedIndex;
    self.currentPickedIndex = indexPath.row;
    
    NSIndexPath *origilIndexPath = [NSIndexPath indexPathForRow:origilIndex inSection:0];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.currentPickedIndex inSection:0];
    
    ///重新刷新对应下标的rows
    [tableView reloadRowsAtIndexPaths:@[origilIndexPath, newIndexPath] withRowAnimation:UITableViewRowAnimationNone];

}

- (void)dealloc{
     [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end
