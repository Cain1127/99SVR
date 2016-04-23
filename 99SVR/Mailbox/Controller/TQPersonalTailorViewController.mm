//
//  TQPersonalTailorViewController.m
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
///**************************************** < 私人定制 >**********************************/

#import "TQPersonalTailorViewController.h"
#import "TQPersonalTailorCell.h"
#import "TableViewFactory.h"

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
    self.title = @"私人定制";
    
    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0, 64, kScreenWidth, kScreenHeight-64) withStyle:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _aryModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TQPersonalTailorCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalTailorCell];
    cell.personalModel = self.aryModel[indexPath.row];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 164;
}


@end
