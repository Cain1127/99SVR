//
//  AnswerViewController.m
//  99SVR_UI
//
//  Created by jiangys on 16/4/28.
//  Copyright © 2016年 Jiangys. All rights reserved.
//

#import "AnswerViewController.h"
#import "AnswerTableViewCell.h"
#import "TQAnswerModel.h"
#import "MJRefresh.h"
#import "UIViewController+EmpetViewTips.h"

static NSUInteger const kPageCount = 10; // 每页显示多少条

@interface AnswerViewController()<UITableViewDelegate,UITableViewDataSource,AnswerTableViewCellDelegate>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *modelArray;
@end

@implementation AnswerViewController

- (NSMutableArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

#pragma mark - 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableView];
    self.view.backgroundColor = COLOR_Bg_Gay;
    [self setTitleText:@"提问回复"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRplayView:) name:MESSAGE_ANSWERREPLY_VC object:nil];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_ANSWERREPLY_VC object:nil];
    [super viewWillDisappear:animated];
}

#pragma mark - 初始化界面

- (void)setupTableView
{
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];;
    _tableView.dataSource = self;
    _tableView.delegate=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = COLOR_Bg_Gay;
    [_tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(updateRefresh)];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    [_tableView.gifHeader loadDefaultImg];
    [_tableView.gifHeader beginRefreshing];
    [_tableView.footer setHidden:YES];
    
    [self.view addSubview:_tableView];
    [self.view makeToastActivity_bird];
}

-(void)chickEmptyViewShowWithTab:(UITableView *)tab withData:(NSMutableArray *)dataArray withCode:(NSInteger)code{
    [self hideEmptyViewInView:tab];
    @WeakObj(self);
    if(code!=1) {
        [self showErrorViewInView:tab withMsg:RequestState_NetworkErrorStr(@"AnswerViewController") touchHanleBlock:^{
            @StrongObj(self);
            [self.tableView.gifHeader beginRefreshing];
        }];
    } else if (dataArray.count==0 && code==1){//数据为0 请求成功
        [self showEmptyViewInView:tab withMsg:RequestState_EmptyStr(@"AnswerViewController") touchHanleBlock:^{
            @StrongObj(self);
            [self.tableView.gifHeader beginRefreshing];
        }];
    } else{//请求成功
        [self.tableView reloadData];
    }
}

- (void)loadRplayView:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    if ([dict[@"code"] intValue]==1) {
        NSArray *aryModel = dict[@"data"];
        if ([self.tableView.header isRefreshing]) { // 下拉刷新，清除原来的数据
            [self.modelArray removeAllObjects];
        }
        for (TQAnswerModel *model in aryModel) {
            [self.modelArray addObject:model];
        }
        
        // 隐藏上拉刷新
        if ([self.tableView.footer isRefreshing]
            && aryModel.count < kPageCount){
            [self.tableView.footer setHidden:YES];
        } else {
            [self.tableView.footer setHidden:NO];
        }
    }
    
    @WeakObj(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @StrongObj(self);
        [self.view hideToastActivity];
        if ([self.tableView.header isRefreshing]) {
            [self.tableView.header endRefreshing];
        }else{
            [self.tableView.footer endRefreshing];
        }
        [self chickEmptyViewShowWithTab:_tableView withData:(NSMutableArray *)_modelArray withCode:[dict[@"code"] intValue]];
    });
}

//开始请求.结束下拉刷新
-(void)updateRefresh
{
    [kHTTPSingle RequestQuestionAnswer:0 count:kPageCount teamer:YES];
}

// 加载更多
- (void)uploadMore
{
    if (_modelArray.count > 0) {
        TQAnswerModel *model = _modelArray[_modelArray.count-1];
        [kHTTPSingle RequestQuestionAnswer:model.ID count:kPageCount teamer:YES];
    }
}

#pragma mark - UITableViewDataSource数据源方法
// 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

// 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerTableViewCell *cell = [AnswerTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.answerModel = self.modelArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate 代理方法

// 设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat LR = 12;
    CGFloat H = 140;
    TQAnswerModel *model = self.modelArray[indexPath.row];
    if(!model.answercontent)
    {
        return H;
    }
    if (!model.askcontent) {
        return H;
    }
    CGSize answercontentSize = [model.answercontent sizeMakeWithFont:Font_15 maxW:kScreenWidth - 2* LR];
    CGSize askcontentSize = [model.askcontent sizeMakeWithFont:Font_15 maxW:kScreenWidth - 4 * LR];

    return H + answercontentSize.height + askcontentSize.height;;
}

#pragma mark - AnswerTableViewCellDelegate

- (void)answerTableViewCell:(AnswerTableViewCell *)answerTableViewCell allTextClick:(NSInteger)btnId
{
    int index = -1 ;
    
    TQAnswerModel *model = [[TQAnswerModel alloc] init];
    for (int i = 0; i<self.modelArray.count; i++) {
        TQAnswerModel *oldModel = self.modelArray[i];
        if (oldModel.ID == btnId) {
            model = oldModel;
            index = i;
        }
    }
    
    if (index >= 0) {
        model.isAllText = !model.isAllText;
        [self.modelArray replaceObjectAtIndex:index withObject:model];
        [self.tableView reloadData];
    }
}

@end
