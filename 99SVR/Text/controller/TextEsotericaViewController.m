//
//  TextEsotericaViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 3/28/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextEsotericaViewController.h"
#import "EsotericaCell.h"
#import "TextEsoterModel.h"
@interface TextEsotericaViewController ()<UITableViewDataSource,UITableViewDelegate>

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
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
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

@end
