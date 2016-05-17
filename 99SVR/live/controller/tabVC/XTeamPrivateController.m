//
//  XTeamPrivateController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XTeamPrivateController.h"
#import <DTCoreText/DTCoreText.h>
#import "NNSVRViewController.h"
#import "TQPurchaseViewController.h"
#import "XPrivateDetailViewController.h"
#import "PrivateVipView.h"
#import "TQPurchaseModel.h"
#import "CustomizedTableViewCell.h"
#import "CustomizedModel.h"
#import "RoomHttp.h"
#import "XPrivateService.h"
#import "ZLPrivateDataSource.h"
#import "LoginViewController.h"
#import "UIAlertView+Block.h"
#import "RoomChatNull.h"
#import "UIView+EmptyViewTips.h"

@interface XTeamPrivateController()<DTAttributedTextContentViewDelegate,PrivateDelegate>
{
    
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
@property (nonatomic,assign) int roomId;
@property (nonatomic, strong) UIView *emptyView;

@end

@implementation XTeamPrivateController

- (id)initWithFrame:(CGRect)frame model:(RoomHttp *)room
{
    self = [super initWithFrame:frame];
    _room = room;
    [self addNotify];
    [self initBody];
    return self;
}

- (void)requestPrivate
{
    [kHTTPSingle RequestTeamPrivateServiceSummaryPack:[_room.teamid intValue]];
}

- (void)setModel:(RoomHttp *)room
{
    _room = room;
    NSString *strName = [NSString stringWithFormat:@"开通团队:%@",_room.teamname];
    _titleLable.text = strName;
    [kHTTPSingle RequestTeamPrivateServiceSummaryPack:[_room.teamid intValue]];
}

- (void)addNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestPrivate)
                                                 name:MESSAGE_RefreshSTOCK_DEAL_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPrivate:)
                                                 name:MESSAGE_PRIVATE_TEAM_SERVICE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:MESSAGE_RefreshSTOCK_DEAL_VC object:nil];
    
}

- (void)removeNotify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initBody
{
    [self setupTableView];
    [self addSubview:_textView];
    
    _emptyView = [UIView initWithFrame:CGRectMake(0, 0, kScreenWidth,self.height) message:@"讲师没有发布私人定制"];
    [self addSubview:_emptyView];
    _emptyView.hidden = YES;
    
    _buyView = [[UIView alloc] initWithFrame:Rect(0, self.height-60, kScreenWidth, 60)];
    [self addSubview:_buyView];
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
    
    [kHTTPSingle RequestTeamPrivateServiceSummaryPack:[_room.teamid intValue]];
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)buyprivate
{
    
    if (KUserSingleton.nType ==1 && KUserSingleton.bIsLogin) {
        
        TQPurchaseViewController *control = [[TQPurchaseViewController alloc] init];
        control.stockModel = [[StockDealModel alloc]init];
        control.stockModel.teamicon = _room.teamicon;
        control.stockModel.teamid = _room.teamid;
        control.stockModel.teamname = _room.teamname;
        control.stockModel.teamicon = _room.teamicon;
        [[self viewController].navigationController pushViewController:control animated:YES];
        
    }else{
        
        WeakSelf(self);
        
        [UIAlertView createAlertViewWithTitle:@"提示" withViewController:[self viewController] withCancleBtnStr:@"取消" withOtherBtnStr:@"登录" withMessage:@"您未登录,登录后兑换" completionCallback:^(NSInteger index) {
            
            if (index==1) {
                LoginViewController *loginVc = [[LoginViewController alloc]init];
                [[weakSelf viewController].navigationController pushViewController:loginVc animated:YES];
            }
            
        }];
    }
}

- (void)setupTableView
{
    _dataSource  = [[ZLPrivateDataSource alloc] init];
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,self.height-44) style:UITableViewStyleGrouped];;
    _tableView.dataSource = _dataSource;
    _tableView.delegate = _dataSource;
    _dataSource.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [self tableHeaderView];
    _tableView.tableFooterView = [UIView new];
    [self addSubview:_tableView];
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
                self.tableView.height = self.height;
            }
            else
            {
                self.buyView.hidden = NO;
                self.tableView.height = self.height - 60;
            }
        }
        [self.tableView reloadData];
    };
    [headerView addSubview:_privateView];
    return headerView;
}

#pragma mark 刷新数据
- (void)refreshData:(NSNotification *)notify{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        Loading_Cup_Show(self.tableView);
        [kHTTPSingle RequestTeamPrivateServiceSummaryPack:[_room.teamid intValue]];
    });
}

- (void)loadPrivate:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        Loading_Hide(self.tableView);
        
        if ([dict isKindOfClass:[NSDictionary class]]) {
            int code = [dict[@"code"] intValue];
            if (code==1)
            {
                DLog(@"request suc:%@",dict[@"model"]);
                NSArray *aryTemp = dict[@"model"];
                if (aryTemp.count == 0) { // 私人定制没有内容时，显示默认图和文案
                    _emptyView.hidden = NO;
                    _tableView.hidden = YES;
                    _buyView.hidden = YES;
                    return;
                } else
                {
                    _emptyView.hidden = YES;
                    _tableView.hidden = NO;
                    _buyView.hidden = NO;
                }
                
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
                @StrongObj(self)
                self.dataSource.selectIndex = 1;
                if (self.dataSource.aryVIP.count>0) {
                    XPrivateService *model = [self.dataSource.aryVIP objectAtIndex:0];
                    if (model.isOpen)
                    {
                        self.buyView.hidden = YES;
                        self.tableView.height = self.height;
                    }
                    else
                    {
                        self.buyView.hidden = NO;
                        self.tableView.height = self.height - 60;
                        
                    }
                }
                [self.tableView reloadData];
                return;
            }
        }
    });
    
}


- (void)loadWhatsPrivate:(NSNotification *)notify
{
}

/**
 *  点击疑问，跳转
 */

- (void)showWhatIsPrivate
{
}
- (void)showPrivateDetail:(XPrivateSummary *)summary
{
    NSString *strInfo = [kHTTPSingle GetPrivateServiceDetailUrl:summary.nId];
    NNSVRViewController *svrView = [[NNSVRViewController alloc] initWithPath:strInfo title:summary.teamname];
    [[self viewController].navigationController pushViewController:svrView animated:YES];
}
@end
