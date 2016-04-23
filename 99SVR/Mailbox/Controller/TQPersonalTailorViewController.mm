//
//  TQPersonalTailorViewController.m
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
///**************************************** < 私人定制 >**********************************/

#import "TQPersonalTailorViewController.h"
#import "TQPersonalTailorCell.h"
#import "XPrivateDetailViewController.h"
#import "TableViewFactory.h"
#import "TQPersonalModel.h"

@interface TQPersonalTailorViewController ()<UITableViewDataSource,UITableViewDelegate>

/** 模型数组 */
@property (nonatomic ,strong)NSArray *aryModel;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation TQPersonalTailorViewController

static NSString *const PersonalTailorCell = @"PersonalTailorCell.h";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleText:@"私人定制"];
    
    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64) withStyle:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setBackgroundColor:RGB(243, 243, 243)];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TQPersonalTailorCell class]) bundle:nil] forCellReuseIdentifier:PersonalTailorCell];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRplayView:) name:MESSAGE_HTTP_TQPERSONAlTAILOR_VC object:nil];
    [kHTTPSingle RequestPrivateServiceSummary:0 count:10];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)loadRplayView:(NSNotification *)notify
{
    NSArray *aryModel = notify.object;
    _aryModel = aryModel;
    DLog(@"+++++++++++++++++++++++++++++++++++++++++%@", _aryModel);
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _aryModel.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TQPersonalTailorCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalTailorCell];
    if (_aryModel.count>indexPath.section) {
        TQPersonalModel *personalModel = _aryModel[indexPath.section];
        cell.TITLELabel.text = personalModel.title;
        cell.summaryLabel.text = personalModel.summary;
        cell.timeLabel.text = personalModel.publishtime;
        cell.nameLabel.text = personalModel.teamname;
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 164;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_aryModel.count>indexPath.section) {
        TQPersonalModel *model = _aryModel[indexPath.section];
        XPrivateDetailViewController *detailView = [[XPrivateDetailViewController alloc] initWithCustomId:model.ID];
        [self.navigationController pushViewController:detailView animated:YES];
    }
}


@end
