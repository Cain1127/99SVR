//
//  CommentReplyViewController.m
//  99SVR
//
//  Created by jiangys on 16/4/29.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "CommentReplyViewController.h"
#import "AnswerTableViewCell.h"
#import "TQAnswerModel.h"
#import "MJRefresh.h"

@interface CommentReplyViewController()<UITableViewDelegate,UITableViewDataSource,AnswerTableViewCellDelegate>
/** tableView */
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *modelArray;
@end

@implementation CommentReplyViewController

- (NSMutableArray *)modelArray
{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

#pragma mark - 初始化界面

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableView];
    self.view.backgroundColor = COLOR_Bg_Gay;
    [self setTitleText:@"评论回复"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRplayView:) name:MESSAGE_MAILREPLY_VC object:nil];
    [self.tableView.gifHeader beginRefreshing];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_MAILREPLY_VC object:nil];
}

- (void)setupTableView
{
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];;
    _tableView.dataSource = self;
    _tableView.delegate=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = COLOR_Bg_Gay;
    [self.view addSubview:_tableView];
    
    [_tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(updateRefresh)];
    [_tableView.gifHeader loadDefaultImg];
    
}

- (void)loadRplayView:(NSNotification *)notify
{
    NSArray *aryModel = notify.object;
    [self.modelArray removeAllObjects];
    
    for (int i = 0; i < aryModel.count; i++) {
        TQAnswerModel *model = aryModel[i];
        model.autoId = i;
        [self.modelArray addObject:model];
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

//开始请求.结束下拉刷新
-(void)updateRefresh
{
    [kHTTPSingle RequestMailReply:0 count:10];
    [self.tableView.gifHeader endRefreshing];
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
    CGFloat H = 130;
    TQAnswerModel *model = self.modelArray[indexPath.row];
    if(!model.answercontent)
    {
        return H;
    }
    if (!model.askcontent) {
        return H;
    }
    CGSize answercontentSize = [model.answercontent sizeMakeWithFont:Font_14 maxW:kScreenWidth - 2* LR];
    CGSize askcontentSize = [model.askcontent sizeMakeWithFont:Font_15 maxW:kScreenWidth - 4 * LR];
    DLog(@"%f --- answercontentSize.height",answercontentSize.height);
    if (answercontentSize.height < 18) {
        H = H + 18;
    } else if (answercontentSize.height > 18 && !model.isAllText) {
        H = H + 40;
    } else if(model.isAllText){
        H = H + answercontentSize.height + 20;
    }
    
    if (askcontentSize.height > 18) {
        H = H + askcontentSize.height;
    }
    return H;
}

#pragma mark - AnswerTableViewCellDelegate

- (void)answerTableViewCell:(AnswerTableViewCell *)answerTableViewCell allTextClick:(NSUInteger)btnId
{
    TQAnswerModel *model = self.modelArray[btnId];
    model.isAllText = !model.isAllText; // 取反
    [self.modelArray replaceObjectAtIndex:btnId withObject:model];
    [self.tableView reloadData];
}

@end
