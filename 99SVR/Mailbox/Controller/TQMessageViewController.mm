//
//  TQMessageViewController.m
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
/**************************************** < 系统消息 >**********************************/

#import "TQMessageViewController.h"
#import "TQMessageCell.h"
#import "TQMessageModel.h"
#import "Masonry.h"
#import "TableViewFactory.h"
#import "MJRefresh.h"

@interface TQMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSCache *cellCache;
}
/** 模型数组 */
@property (nonatomic,copy) NSArray *aryMessage;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation TQMessageViewController
static NSString *const messageCell = @"messageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleText:@"系统消息"];
    cellCache = [[NSCache alloc] init];
    [cellCache setTotalCostLimit:10];
    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0,64,kScreenWidth,kScreenHeight-64) withStyle:UITableViewStylePlain];
    [_tableView setBackgroundColor:UIColorFromRGB(0xffffff)];
    [self.view addSubview:_tableView];
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TQMessageCell class]) bundle:nil] forCellReuseIdentifier:messageCell];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // 估算高度
    self.tableView.estimatedRowHeight = 44;
    

    [self addTableHeaderView];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SystemMessage:) name:MESSAGE_SYSTEMMESSAGE_VC object:nil];
    //开始刷新,注册数据接受通知
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(updateRefresh)];
    [self.tableView.gifHeader loadDefaultImg];
    [self.tableView.gifHeader beginRefreshing];
}
//获取模型,刷新列表
- (void)SystemMessage:(NSNotification *)notify{
    NSArray *aryModel = notify.object;
    _aryMessage = aryModel;
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        [selfWeak.tableView reloadData];
    });
}
//开始请求.结束下拉刷新
-(void)updateRefresh {
    [kHTTPSingle RequestSystemMessage:0 count:8];
    [self.tableView.gifHeader endRefreshing];
}

-(void)addTableHeaderView {
<<<<<<< HEAD
    UIView *headerview = [[UIView alloc] init];
    headerview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150);
    self.tableView.tableHeaderView = headerview;
    /*添加子控件*/
    UILabel *titileLabel = [[UILabel alloc] init];
    titileLabel.text = @"尊敬的用户:";
    titileLabel.textColor = [UIColor colorWithHex:@"#262626"];
    titileLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:20];
    
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.numberOfLines = 0;
    contentLabel.text = @"恭喜您开通“一夜岛”的VIP6，服务周期为2016.1.1至2017.1.1。您可以享受以下服务:";
    contentLabel.textColor = [UIColor colorWithHex:@"#878787"];

    UILabel *vipLabel = [[UILabel alloc] init];
    vipLabel.font = [UIFont systemFontOfSize:15];
    vipLabel.text = @"VIP6：一对一私人定制";
    vipLabel.textColor = [UIColor colorWithHex:@"#878787"];

    [headerview addSubview:titileLabel];
    [headerview addSubview:contentLabel];
    [headerview addSubview:vipLabel];
    
    //添加头部子控件布局
    [titileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerview.mas_left).offset(20);
        make.top.equalTo(headerview.mas_top).offset(20);
        make.right.equalTo(headerview.mas_right).offset(-20);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerview.mas_left).offset(20);
        make.top.equalTo(titileLabel.mas_bottom).offset(10);
        make.right.equalTo(headerview.mas_right).offset(-20);
        
    }];
    [vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerview.mas_left).offset(20);
        make.top.equalTo(contentLabel.mas_bottom).offset(10);
        make.right.equalTo(headerview.mas_right).offset(-20);
        
    }];

=======
//    UIView *headerview = [[UIView alloc] init];
//    headerview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150);
//    self.tableView.tableHeaderView = headerview;
//    /*添加子控件*/
//    UILabel *titileLabel = [[UILabel alloc] init];
//    titileLabel.text = @"尊敬的用户:";
//    titileLabel.textColor = [UIColor colorWithHex:@"#262626"];
//    titileLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:20];
//    
//    
//    UILabel *contentLabel = [[UILabel alloc] init];
//    contentLabel.font = [UIFont systemFontOfSize:15];
//    contentLabel.numberOfLines = 0;
//    contentLabel.text = @"恭喜您开通“一夜岛”的VIP6，服务周期为2016.1.1至2017.1.1。您可以享受以下服务:";
//    contentLabel.textColor = [UIColor colorWithHex:@"#878787"];
//
//    UILabel *vipLabel = [[UILabel alloc] init];
//    vipLabel.font = [UIFont systemFontOfSize:15];
//    vipLabel.text = @"VIP6：一对一私人定制";
//    vipLabel.textColor = [UIColor colorWithHex:@"#878787"];
//
//    [headerview addSubview:titileLabel];
//    [headerview addSubview:contentLabel];
//    [headerview addSubview:vipLabel];
//    
//    //添加头部子控件布局
//    [titileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(headerview.mas_left).offset(20);
//        make.top.equalTo(headerview.mas_top).offset(20);
//        make.right.equalTo(headerview.mas_right).offset(-20);
//    }];
//    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(headerview.mas_left).offset(20);
//        make.top.equalTo(titileLabel.mas_bottom).offset(10);
//        make.right.equalTo(headerview.mas_right).offset(-20);
//        
//    }];
//    [vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(headerview.mas_left).offset(20);
//        make.top.equalTo(contentLabel.mas_bottom).offset(10);
//        make.right.equalTo(headerview.mas_right).offset(-20);
//        
//    }];
>>>>>>> 28295b90cd0edb89bfe377e8ead86b5c3fa796b9
}
-(void)setUpheaderchildView {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _aryMessage.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
<<<<<<< HEAD
    TQMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:messageCell];
    cell.messageModel = self.aryModel[indexPath.row];
//    [cell.openBtn addTarget:self action:@selector(openCellReloadata:) forControlEvents:<#(UIControlEvents)#>]
    return cell;
}



=======
    NSString *strKey = [NSString stringWithFormat:@"%zi-%zi",indexPath.row,indexPath.section];
    TQMessageCell *cell = [cellCache objectForKey:strKey];
    if (!cell) {
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TQMessageCell class]) bundle:nil] forCellReuseIdentifier:messageCell];
//        TQMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:messageCell];
        cell = [tableView dequeueReusableCellWithIdentifier:messageCell];
        [cellCache setObject:cell forKey:strKey];
    }
    cell.messageModel = _aryMessage[indexPath.section];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strKey = [NSString stringWithFormat:@"%zi-%zi",indexPath.row,indexPath.section];
    TQMessageCell *cell = [cellCache objectForKey:strKey];
    return [cell requiredRowHeightInTableView];
//    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
>>>>>>> 28295b90cd0edb89bfe377e8ead86b5c3fa796b9

@end
