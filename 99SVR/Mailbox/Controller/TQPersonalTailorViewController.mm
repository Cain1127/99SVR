//
//  TQPersonalTailorViewController.m
//  99SVR
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
///**************************************** < 私人定制 >**********************************/

#import "TQPersonalTailorViewController.h"
#import "TQPersonalTailorCell.h"


@interface TQPersonalTailorViewController ()
/** 模型数组 */
@property (nonatomic ,strong)NSArray *aryModel;
@end

@implementation TQPersonalTailorViewController
static NSString *const PersonalTailorCell = @"PersonalTailorCell.h";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
-(void)initUI {
    self.title = @"私人定制";

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TQPersonalTailorCell class]) bundle:nil] forCellReuseIdentifier:PersonalTailorCell];
    //    开始刷新,注册数据接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRplayView:) name:MESSAGE_HTTP_TQPERSONAlTAILOR_VC object:nil];
    // cell自动计算高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // 估算高度
    self.tableView.estimatedRowHeight = 44;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [kHTTPSingle RequestPrivateServiceSummary:0 count:10];
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _aryModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TQPersonalTailorCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalTailorCell];
    cell.personalModel = self.aryModel[indexPath.row];
    
    return cell;
    
}




@end
