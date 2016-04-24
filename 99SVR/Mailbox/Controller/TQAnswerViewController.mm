//
//  TQAnswerViewController.m
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
/**************************************** < 问题答复 >**********************************/

#import "TQAnswerViewController.h"
#import "TQAllReplyCell.h"
#import "UIImageView+Header.h"
#import "MJRefresh.h"
#import "TQAnswerModel.h"
#import "TableViewFactory.h"

@interface TQAnswerViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)NSArray *aryModel;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation TQAnswerViewController
static NSString *const answerCell = @"answerCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleText:@"提问回复"];
    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64) withStyle:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    // cell自动计算高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // 估算高度
    self.tableView.estimatedRowHeight = 44;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TQAllReplyCell class]) bundle:nil] forCellReuseIdentifier:answerCell];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //开始刷新,注册数据接受通知
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(updateRefresh)];
    [self.tableView.gifHeader loadDefaultImg];
    [self.tableView.gifHeader beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRplayView:) name:MESSAGE_ANSWERREPLY_VC object:nil];

}

- (void)loadRplayView:(NSNotification *)notify
{
    NSArray *aryModel = notify.object;
    _aryModel = aryModel;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

//开始请求.结束下拉刷新
-(void)updateRefresh {
    [kHTTPSingle RequestQuestionAnswer:0 count:10 teamer:YES];
    [self.tableView.gifHeader endRefreshing];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _aryModel.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TQAllReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:answerCell];
    if(_aryModel.count>indexPath.section)
    {
        TQAnswerModel *model = _aryModel[indexPath.section];
        [cell.iconImageView xmg_setHeader:model.answerauthorhead];
        //    self.iconImageView.image = [UIImage imageNamed:model.answerauthorhead];
        cell.ansNamelb.text = model.answerauthorname;
        cell.ansTimelb.text = model.answertime;
        cell.ansContentV.text = model.answercontent;
        cell.askNamelb.text = model.askauthorname;
        cell.askContentV.text = model.askcontent;
    }
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 250;
//}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
