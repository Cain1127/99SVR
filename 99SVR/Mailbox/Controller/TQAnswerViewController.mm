//
//  TQAnswerViewController.m
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
/**************************************** < 问题答复 >**********************************/

#import "TQAnswerViewController.h"
#import "TQAllReplyCell.h"
#import "MJRefresh.h"
#import "TQAnswerModel.h"

@interface TQAnswerViewController ()
@property (nonatomic ,strong)NSArray *aryModel;

@end

@implementation TQAnswerViewController
static NSString *const answerCell = @"answerCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    return _aryModel.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TQAllReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:answerCell];
    cell.model = _aryModel[indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
