//
//  XTeamPrivateController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XTeamPrivateController.h"
#import <DTCoreText/DTCoreText.h>
#import "TQPurchaseViewController.h"
#import "XPrivateDetailViewController.h"
#import "PrivateVipView.h"
#import "TQPurchaseModel.h"
#import "CustomizedTableViewCell.h"
#import "CustomizedModel.h"
#import "RoomHttp.h"
#import "XPrivateService.h"
#import "ZLPrivateDataSource.h"
#import "ZLWhatIsPrivateView.h"
@interface XTeamPrivateController()<DTAttributedTextContentViewDelegate,PrivateDelegate>
{
    ZLWhatIsPrivateView *whatPrivate;
}

@property (nonatomic,strong) UIButton *btnBuy;
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,copy) NSArray *aryVIP;
@property (nonatomic,strong) DTAttributedTextView *textView;
@property (nonatomic,strong) PrivateVipView *privateView;
@property (nonatomic,strong) RoomHttp *room;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *selectIconImageView;
@property (nonatomic,strong) UILabel *selectVipLable;
@property (nonatomic) NSInteger selectIndex;
@property (nonatomic,strong) ZLPrivateDataSource *dataSource;
@property (nonatomic,strong) UIView *buyView;

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

- (void)setModel:(RoomHttp *)room
{
    _room = room;
    NSString *strName = [NSString stringWithFormat:@"开通团队:%@",_room.teamname];
    _titleLable.text = strName;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    [self.view addSubview:_textView];
    
    _buyView = [[UIView alloc] initWithFrame:Rect(0, self.view.height-60, kScreenWidth, 60)];
    [self.view addSubview:_buyView];
    [_buyView setBackgroundColor:COLOR_Bg_Gay];
    
    _btnBuy = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnBuy.frame = Rect(10,8, kScreenWidth-20, 44);
    [_buyView addSubview:_btnBuy];
    [_btnBuy setTitle:@"兑    换" forState:UIControlStateNormal];
    [_btnBuy setTitleColor:UIColorFromRGB(0xe5e5e5) forState:UIControlStateNormal];
    [_btnBuy setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateNormal];
    [_btnBuy setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateHighlighted];
    [_btnBuy setBackgroundImage:[UIImage imageNamed:@"login_default_d"] forState:UIControlStateDisabled];
    _btnBuy.titleLabel.font = XCFONT(15);
    _btnBuy.layer.masksToBounds = YES;
    _btnBuy.layer.cornerRadius = 2.5;
    [_btnBuy addTarget:self action:@selector(buyprivate) forControlEvents:UIControlEventTouchUpInside];
    _buyView.hidden = YES;
    
    whatPrivate = [[ZLWhatIsPrivateView alloc] initWithFrame:Rect(0, 0, kScreenWidth, self.view.height)];
    [self.view addSubview:whatPrivate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadWhatsPrivate:) name:MEESAGE_WHAT_IS_PRIVATE_VC object:nil];
    [kHTTPSingle RequestWhatIsPrivateService];
}

- (void)buyprivate
{
    TQPurchaseViewController *control = [[TQPurchaseViewController alloc] initWithTeamId:[_room.teamid intValue] name:_room.teamname];
    [self.navigationController pushViewController:control animated:YES];
}

- (void)setupTableView
{
    _dataSource  = [[ZLPrivateDataSource alloc] init];
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,self.view.height) style:UITableViewStyleGrouped];;
    _tableView.dataSource = _dataSource;
    _tableView.delegate = _dataSource;
    _dataSource.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [self tableHeaderView];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

- (UIView *)tableHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    @WeakObj(self)
    _privateView = [[PrivateVipView alloc] init];
    _privateView.frame = CGRectMake(0, 0, kScreenWidth, 100);
    _privateView.selectVipBlock = ^(NSUInteger vipLevelId)
    {
        @StrongObj(self)
        self.dataSource.selectIndex = vipLevelId;
        if (self.dataSource.aryVIP.count>vipLevelId-1) {
            XPrivateService *model = [self.dataSource.aryVIP objectAtIndex:vipLevelId-1];
            if (model.isOpen)
            {
                self.buyView.hidden = YES;
            }
            else
            {
                self.buyView.hidden = NO;
            }
        }
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
            _dataSource.aryVIP = aryTemp;
            _dataSource.selectIndex = 1;
            if (muAryTemp.count>0)
            {
                self.privateView.privateVipArray = muAryTemp;
            }
            else
            {
                int i=1;
                for (;i<=6;i++) {
                    NSDictionary *parameters = @{@"vipLevelId" : NSStringFromInt(i),
                                                 @"vipLevelName" : @"VIP",@"isOpen" :NSStringFromInt(0)};
                    [muAryTemp addObject:parameters];
                }
                self.privateView.privateVipArray = muAryTemp;
            }
            @WeakObj(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                @StrongObj(self)
                self.dataSource.selectIndex = 1;
                if (self.dataSource.aryVIP.count>0) {
                    XPrivateService *model = [self.dataSource.aryVIP objectAtIndex:0];
                    if (model.isOpen)
                    {
                        self.buyView.hidden = YES;
                    }
                    else
                    {
                        self.buyView.hidden = NO;
                    }
                }
                [self.tableView reloadData];
            });
            return;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPrivate:) name:MESSAGE_PRIVATE_TEAM_SERVICE_VC object:nil];
    [kHTTPSingle RequestTeamPrivateServiceSummaryPack:[_room.teamid intValue]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadWhatsPrivate:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    if ([dict[@"code"] intValue]==1)
    {
        NSString *strInfo = dict[@"data"];
        if(strInfo)
        {
            [whatPrivate setContent:strInfo];
        }
    }
}

/**
 *  点击疑问，跳转
 */

- (void)showWhatIsPrivate
{
    whatPrivate.hidden = NO;
}
- (void)showPrivateDetail:(XPrivateSummary *)summary
{
    XPrivateDetailViewController *control = [[XPrivateDetailViewController alloc] initWithCustomId:summary.nId];
    [self.navigationController pushViewController:control animated:YES];
}
@end
