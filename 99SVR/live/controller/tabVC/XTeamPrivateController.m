//
//  XTeamPrivateController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XTeamPrivateController.h"
#import <DTCoreText/DTCoreText.h>
#import "PrivateVipView.h"
#import "TQPurchaseModel.h"
#import "CustomizedTableViewCell.h"
#import "CustomizedModel.h"
#import "RoomHttp.h"
#import "XPrivateService.h"

@interface XTeamPrivateController()<DTAttributedTextContentViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic,copy) NSArray *aryVIP;
@property (nonatomic,strong) DTAttributedTextView *textView;
@property (nonatomic,strong) PrivateVipView *privateView;
@property (nonatomic,strong) RoomHttp *room;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *selectIconImageView;
@property (nonatomic,strong) UILabel *selectVipLable;
@property (nonatomic) NSInteger selectIndex;

@end

@implementation XTeamPrivateController

- (id)initWithModel:(RoomHttp*)room
{
    self = [super init];
    _room = room;
    return self;
}

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-kRoom_head_view_height)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    [self.view addSubview:_textView];
    
}

- (void)setupTableView
{
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];;
    _tableView.dataSource = self;
    _tableView.delegate= self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [self tableHeaderView];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

- (UIView *)tableHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 230)];
    
    // 向您推荐
    UIView *recommendView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    recommendView.backgroundColor = [UIColor whiteColor];
    // 图标
    CGFloat iconW = 80;
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, iconW, iconW)];
    iconImageView.image = [UIImage imageNamed:@"default"];
    iconImageView.clipsToBounds = YES;
    iconImageView.layer.cornerRadius = iconW/ 2;
    [recommendView addSubview:iconImageView];
    
    // 标题：开通团队
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+10,10, kScreenWidth - 90, 30)];
    titleLable.font = XCFONT(16);
    titleLable.textColor = UIColorFromRGB(0x4c4c4c);
    NSString *strName = [NSString stringWithFormat:@"开通团队:%@",_room.cname];
    titleLable.text = strName;
    [recommendView addSubview:titleLable];
    
    // 有效期
    UILabel *expiryLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+10,titleLable.y+30, kScreenWidth - 90, 30)];
    expiryLable.font = XCFONT(16);
    expiryLable.textColor = UIColorFromRGB(0x4c4c4c);
    expiryLable.text = @"有效期:永远";
    [recommendView addSubview:expiryLable];
    
    // 注意
    UILabel *attentionLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+10,expiryLable.y+30, kScreenWidth - 90, 30)];
    attentionLable.font = XCFONT(14);
    attentionLable.textColor = [UIColor redColor];
    attentionLable.text = @"开通高等级VIP，自动获得低等级VIP权限";
    [recommendView addSubview:attentionLable];
    [headerView addSubview:recommendView];
    
    @WeakObj(self)
    _privateView = [[PrivateVipView alloc] init];
    _privateView.frame = CGRectMake(0, CGRectGetMaxY(recommendView.frame)+10, kScreenWidth, 100);
    _privateView.selectVipBlock = ^(NSUInteger vipLevelId){
        @StrongObj(self)
        self.selectIndex = vipLevelId;
        // 设置组头部Vip值
        self.selectIconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"customized_vip%ld_icon",(unsigned long)vipLevelId]];
        self.selectVipLable.text = [NSString stringWithFormat:@"VIP%ld的服务内容",(unsigned long)vipLevelId];
        [self.tableView reloadData];
    };
    [headerView addSubview:_privateView];
    
    return headerView;
}

- (void)loadPrivate:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    if ([dict isKindOfClass:[NSDictionary class]]) {
        int code = [dict[@"code"] intValue];
        if (code==1)
        {
            DLog(@"request suc:%@",dict[@"model"]);
            NSArray *aryTemp = dict[@"model"];
            NSMutableArray *muAryTemp = [NSMutableArray array];
            for (XPrivateService *model in aryTemp) {
                NSDictionary *parameters = @{@"vipLevelId" : NSStringFromInt(model.vipLevelId),
                                             @"vipLevelName" : model.vipLevelName,@"isOpen" :NSStringFromInt(model.isOpen)};
                [muAryTemp addObject:parameters];
            }
            _aryVIP = aryTemp;
            self.privateView.privateVipArray = muAryTemp;
            return;
        }
    }
    
    DLog(@"request fail");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadWhatsPrivate:) name:MEESAGE_WHAT_IS_PRIVATE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPrivate:) name:MESSAGE_PRIVATE_TEAM_SERVICE_VC object:nil];
//    [kHTTPSingle RequestWhatIsPrivateService];
//    [kHTTPSingle RequestBuyPrivateServicePage:198610];
    [kHTTPSingle RequestTeamPrivateServiceSummaryPack:198610];
}

- (void)loadWhatsPrivate:(NSNotification *)notify
{
    NSString *strInfo = notify.object;
    if(strInfo){
        _textView.attributedString = [[NSAttributedString alloc] initWithHTMLData:[strInfo dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
    }
}

#pragma mark 私人定制 tableView datasource

#pragma mark - UITableViewDataSource数据源方法
// 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_aryVIP.count>_selectIndex) {
        XPrivateService *service = _aryVIP[_selectIndex];
        return service.summaryList.count;
    }
    return 0;
}

// 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomizedTableViewCell *cell = [CustomizedTableViewCell cellWithTableView:tableView];
    if (_aryVIP.count>_selectIndex) {
        XPrivateService *service = _aryVIP[_selectIndex];
        if (service.summaryList.count>indexPath.row) {
            XPrivateSummary *summary = service.summaryList[indexPath.row];
            CustomizedModel *customizedModel = [[CustomizedModel alloc] init];
            customizedModel.title = summary.title;
            customizedModel.summary = summary.summary;
            customizedModel.publishTime = summary.publishtime;
            customizedModel.isOpen = service.isOpen;
            cell.customizedModel = customizedModel;
        }
    }
    UIView *lineBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 80 - 0.5,kScreenWidth, 0.5)];
    lineBottomView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [cell addSubview:lineBottomView];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerSectionView.backgroundColor = [UIColor whiteColor];
    // 图标
    _selectIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 25, 25)];
    NSString *imgSrc = [NSString stringWithFormat:@"customized_vip%zi_icon",_selectIndex];
    _selectIconImageView.image = [UIImage imageNamed:imgSrc];
    [headerSectionView addSubview:_selectIconImageView];
    
    // 标题
    _selectVipLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectIconImageView.frame)+8, 0, 150, 40)];
    _selectVipLable.textColor = UIColorFromRGB(0x919191);
    NSString *strName = [NSString stringWithFormat:@"VIP%zi的服务内容",_selectIndex];
    _selectVipLable.text = strName;
    _selectVipLable.font = [UIFont boldSystemFontOfSize:15];
    [headerSectionView addSubview:_selectVipLable];
    
    // 疑问
    UIButton *questionButton= [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 40, 0, 40, 40)];
    [questionButton setImage:[UIImage imageNamed:@"pwd_play_h"] forState:UIControlStateNormal];
    [questionButton addTarget:self action:@selector(questionClick) forControlEvents:UIControlEventTouchUpInside];
    [headerSectionView addSubview:questionButton];
    
    // 添加底部线条
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40 - 0.5, kScreenWidth , 0.5)];
    lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [headerSectionView addSubview:lineView];
    
    return headerSectionView;
}

#pragma mark - UITableViewDelegate 代理方法
// 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

// 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

// 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"didSelectRowAtIndexPath");
}

#pragma mark - 私有方法

/**
 *  点击疑问，跳转
 */
- (void)questionClick
{
    DLog(@"questionClick");
}


@end
