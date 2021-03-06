//
//  ZLMeTeamPrivate.m
//  99SVR
//
//  Created by xia zhonglin  on 5/4/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ZLMeTeamPrivate.h"
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
#import "ZLWhatIsPrivateView.h"
#import "TQMeCustomizedModel.h"
#import "UIViewController+EmpetViewTips.h"
#import "PrivateTeamService.h"

@interface ZLMeTeamPrivate()<DTAttributedTextContentViewDelegate,PrivateDelegate>
{
    PrivateTeamService *_privateService;
}

@property (nonatomic,strong) UIButton *btnBuy;
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,copy) NSArray *aryVIP;
@property (nonatomic,strong) DTAttributedTextView *textView;
@property (nonatomic,strong) PrivateVipView *privateView;
@property (nonatomic,strong) TQMeCustomizedModel *room;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *selectIconImageView;
@property (nonatomic,strong) UILabel *selectVipLable;
@property (nonatomic) NSInteger selectIndex;
@property (nonatomic,strong) ZLPrivateDataSource *dataSource;
@property (nonatomic,strong) UIView *buyView;
@property (nonatomic,assign) int roomId;

@end

@implementation ZLMeTeamPrivate

- (id)initWIthModel:(TQMeCustomizedModel *)model
{
    self = [super init];
    _room = model;
    return self;
}

- (void)setModel:(TQMeCustomizedModel *)room
{
    _room = room;
    NSString *strName = [NSString stringWithFormat:@"开通团队:%@",_room.teamname];
    _titleLable.text = strName;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:_room.teamname];
    [self setupTableView];
    [self.view addSubview:_textView];
    _privateService = [[PrivateTeamService alloc] init];
    
    @WeakObj(self)
    _privateService.block = ^(NSDictionary *dict)
    {
        [selfWeak loadPrivate:dict];
    };
    
    _buyView = [[UIView alloc] initWithFrame:Rect(0, self.view.height-60, kScreenWidth, 60)];
    [self.view addSubview:_buyView];
    [_buyView setBackgroundColor:COLOR_Bg_Gay];
    
    _btnBuy = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnBuy.frame = Rect(10,8, kScreenWidth-20, 44);
    [_buyView addSubview:_btnBuy];
    [_btnBuy setTitle:@"兑    换" forState:UIControlStateNormal];
    [_btnBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnBuy setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateNormal];
    [_btnBuy setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateHighlighted];
    [_btnBuy setBackgroundImage:[UIImage imageNamed:@"login_default_d"] forState:UIControlStateDisabled];
    _btnBuy.titleLabel.font = XCFONT(15);
    _btnBuy.layer.masksToBounds = YES;
    _btnBuy.layer.cornerRadius = 2.5;
    [_btnBuy addTarget:self action:@selector(buyprivate) forControlEvents:UIControlEventTouchUpInside];
    _buyView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:MESSAGE_RefreshSTOCK_DEAL_VC object:nil];
}

- (void)refreshData:(NSNotification *)notify
{
    
    if (_dataSource.aryVIP.count>0) {
        Loading_Cup_Show(self.tableView);
    }else{
        Loading_Bird_Show(self.tableView);
    }
    [_privateService requestTeamService:[_room.teamid intValue]];
}
#pragma mark 兑换私人定制
- (void)buyprivate
{
    TQPurchaseViewController *control = [[TQPurchaseViewController alloc] init];
    control.stockModel = [[StockDealModel alloc]init];
    control.stockModel.teamicon = _room.teamicon;
    control.stockModel.teamid = _room.teamid;
    control.stockModel.teamname = _room.teamname;
    control.stockModel.teamicon = _room.teamicon;
    [self.navigationController pushViewController:control animated:YES];
}

- (void)setupTableView
{
    _dataSource  = [[ZLPrivateDataSource alloc] init];
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth,kScreenHeight-64) style:UITableViewStyleGrouped];;
    _tableView.dataSource = _dataSource;
    _tableView.delegate = _dataSource;
    _dataSource.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [self tableHeaderView];
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = COLOR_Bg_Gay;
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

- (void)loadPrivate:(NSDictionary *)dict
{
    Loading_Hide(self.tableView);
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
        }else{//请求错误
            
        }
        
        [self chickEmptyViewShow:self.dataSource.aryVIP withCode:[NSString stringWithFormat:@"%d",code]];
    }
}

#pragma mark
-(void)chickEmptyViewShow:(NSArray *)dataArray withCode:(NSString *)code{
    
    WeakSelf(self);

    __weak typeof(_room) weakRoom = _room;
    @WeakObj(_privateService)
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self showEmptyViewInView:weakSelf.tableView withMsg:RequestState_EmptyStr(code) touchHanleBlock:^{
            
            Loading_Bird_Show(weakSelf.tableView);
            [_privateServiceWeak requestTeamService:[_room.teamid intValue]];
        }];
        
        if (dataArray.count==0&&[code intValue]!=1) {//数据为0 错误代码不为1
            
            [self showErrorViewInView:weakSelf.tableView withMsg:RequestState_NetworkErrorStr(code) touchHanleBlock:^{
                
                Loading_Bird_Show(weakSelf.tableView);
                [_privateServiceWeak requestTeamService:[_room.teamid intValue]];
            }];
            
        }else if (dataArray.count==0&&[code intValue]==1){//请求成功 空数据
            
            [self showEmptyViewInView:weakSelf.tableView withMsg:RequestState_EmptyStr(code) touchHanleBlock:^{
                
            }];
            
        }else{
            [self hideEmptyViewInView:weakSelf.tableView];
        }

    });
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_roomId!=[_room.teamid intValue])
    {
        Loading_Bird_Show(self.tableView);
        [_privateService requestTeamService:[_room.teamid intValue]];
        _roomId = [_room.teamid intValue];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MEESAGE_WHAT_IS_PRIVATE_VC object:nil];
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
    NSString *strUrl = [kHTTPSingle GetPrivateServiceDetailUrl:summary.nId];
    NSString *title = (summary.teamname && summary.teamname.length >0)?summary.teamname:@"私人定制详情";
    NNSVRViewController *svrView = [[NNSVRViewController alloc] initWithPath:strUrl title:title];
    [self.navigationController pushViewController:svrView animated:YES];
}


-(void)dealloc{
    
    DLog(@"delloc");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_RefreshSTOCK_DEAL_VC object:nil];
    
}

@end
