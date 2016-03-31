//
//  TextEsotericaViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 3/28/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextEsotericaViewController.h"
#import "EsotericaCell.h"
#import "ProgressHUD.h"
#import "TextEsoterModel.h"

@interface TextEsotericaViewController ()<UITableViewDataSource,UITableViewDelegate,EsoterDelegate>
{
    NSMutableDictionary *_dict;
}
@property (nonatomic,strong) TextTcpSocket *tcpSocket;
@property (nonatomic,copy) NSArray *arySecret;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation TextEsotericaViewController

- (id)initWithSocket:(TextTcpSocket *)socket
{
    self = [super init];
    if (self) {
        _tcpSocket = socket;
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-108)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dict = [NSMutableDictionary dictionary];
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-108) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    DLog(@"frame:%@",NSStringFromCGRect(self.view.frame));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arySecret.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strIdentifier = @"esotercaTableview";
    EsotericaCell *cell = [tableView dequeueReusableCellWithIdentifier:strIdentifier];
    if (cell==nil) {
        cell = [[EsotericaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier];

    }
    if (_arySecret.count>indexPath.section) {
        TextEsoterModel *text = [_arySecret objectAtIndex:indexPath.section];
        [cell setTextModel:text];
        cell.delegate = self;
    }
    cell.nRow = indexPath.section;
    
    return cell;
}
/**
 *  个人秘籍的delegate
 */
- (void)clickEsoter:(EsotericaCell *)cell model:(TextEsoterModel *)model
{
    if (!model.buyflag) {
//        [self createAlertInfo];
        //请求购买
        [_dict setObject:cell forKey:@(model.secretsid)];
        [_tcpSocket reqBuySecret:model.secretsid goodsid:model.goodsid];
    }
    else{
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 158;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNew) name:MESSAGE_TEXT_NEW_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewEsoter) name:MESSAGE_TEXT_SECRET_LIST_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyOK:) name:MESSAGE_TEXT_SECRET_BUY_SUC_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyErr:) name:MESSAGE_TEXT_SECRET_BUY_ERR_VC object:nil];
}

- (void)buyOK:(NSNotification *)notify
{
    NSNumber *numId = [notify object];
    EsotericaCell *cell = [_dict objectForKey:numId];
    if(_arySecret.count>cell.nRow)
    {
        TextEsoterModel *textModel = [_arySecret objectAtIndex:cell.nRow];
        textModel.buyflag = 1;
        textModel.buynums += 1;
        @WeakObj(cell)
        @WeakObj(textModel)
        dispatch_main_async_safe(^{
            [cellWeak setTextModel:textModelWeak];
            [ProgressHUD showSuccess:@"购买成功"];
        });
    }
    [_dict removeObjectForKey:numId];
}

- (void)buyErr:(NSNotification *)notify
{
    NSString *info = [notify object];
    __block NSString *__info = info;
    dispatch_main_async_safe(^{
        [ProgressHUD showError:__info];
    });
}

- (void)loadNewEsoter
{
    _arySecret = _tcpSocket.aryEsoter;
    @WeakObj(self)
    gcd_main_safe(^{
        [selfWeak.tableView reloadData];
    });
}

/**
 *  请求个人秘籍资料
 */
- (void)reloadNew
{
    [_tcpSocket reqEsotericaList:0 count:20 teach:10];
}

- (void)createAlertInfo
{
    @WeakObj(self)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"确定购买此秘籍" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *canAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
    {
           
    }];
    [alert addAction:canAction];
    [alert addAction:okAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [selfWeak presentViewController:alert animated:YES completion:nil];
    });
}

@end
