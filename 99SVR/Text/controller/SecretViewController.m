//
//  SecretViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 3/30/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "SecretViewController.h"
#import "UserInfo.h"
#import "BaseService.h"

@interface SecretViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) TextTcpSocket *tcpSocket;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic) int64_t secretId;
@end

@implementation SecretViewController

- (id)initWithSocket:(TextTcpSocket *)tcpSocket secret:(int64_t)secretId
{
    self = [super init];
    if (self) {
        _tcpSocket = tcpSocket;
        _secretId = secretId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleText:@"个人秘籍"];
    
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    _tableView = [[UITableView alloc] initWithFrame:Rect(0,64, kScreenWidth,kScreenHeight-114)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

- (void)requestView
{
    //TODD:需要加入次数限制
    @WeakObj(self)
    NSString *strInfo = [NSString stringWithFormat:@"http://121.12.118.32/caijing/index.php?m=Api&c=PersonalSecrets&a=show&id=%lld&nuserid=%d&token=%@",_secretId,[UserInfo sharedUserInfo].nUserId,[UserInfo sharedUserInfo].strToken];
    [BaseService postJSONWithUrl:strInfo parameters:nil success:^(id responseObject) {
         
    } fail:^(NSError *error) {
        [self requestView];
    }];
}

- (void)initUIHead
{
    __weak SecretViewController *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
        [__self requestView];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strIdentifier = @"secretViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier];
    }
    
    return cell;
}


@end
