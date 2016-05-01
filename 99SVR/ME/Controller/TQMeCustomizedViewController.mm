//
//  TQMeCustomizedViewController.m
//  99SVR
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//已经购买的私人定制界面

#import "TQMeCustomizedViewController.h"
#import "TQMeCustomizedModel.h"
#import "ViewNullFactory.h"
#import "XPrivateService.h"
#import "TQNoCustomView.h"
#import "UIBarButtonItem+Item.h"
#import "HttpManagerSing.h"
#import "TableViewFactory.h"
#import "XMeCustomDataSource.h"
#import "XPrivateDetailViewController.h"
#import "TQPurchaseViewController.h"
#import "ZLPrivateDataSource.h"
#import "RoomHttp.h"
#import "PrivateVipView.h"

@interface TQMeCustomizedViewController ()<MeCustomDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *aryPurchase;;
@property (nonatomic,strong) XMeCustomDataSource *buyDataSource;
@property (nonatomic,strong) ZLPrivateDataSource *noBuyDataSource;
@property (nonatomic,strong) RoomHttp *room;
@property (nonatomic,strong) PrivateVipView *privateView;
@end

@implementation TQMeCustomizedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0,64,kScreenWidth,kScreenHeight-64) withStyle:UITableViewStylePlain];
    [_tableView setBackgroundColor:UIColorFromRGB(0xffffff)];
    _buyDataSource = [[XMeCustomDataSource alloc] init];
    _noBuyDataSource = [[ZLPrivateDataSource alloc] init];
    [self.view addSubview:_tableView];
    [self initUi];
    
    @WeakObj(self)
    _privateView = [[PrivateVipView alloc] init];
    _privateView.selectVipBlock = ^(NSUInteger vipLevelId){
        @StrongObj(self)
        self.noBuyDataSource.selectIndex = vipLevelId;
        [self.tableView reloadData];
    };
}
-(void)nopurchaseVc {
    TQPurchaseViewController *vc = [[TQPurchaseViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)initUi
{
    [self setTitleText:@"我的私人定制"];
}

- (void)noPurchase:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    if ([dict isKindOfClass:[NSDictionary class]]) {
        int code = [dict[@"code"] intValue];
        if (code==1)
        {
            if ([dict[@"model"] isKindOfClass:[RoomHttp class]]) {
                _room = dict[@"model"];
            }
            NSArray *aryTemp = dict[@"array"];
            NSMutableArray *muAryTemp = [NSMutableArray array];
            for (XPrivateService *model in aryTemp) {
                NSDictionary *parameters = @{@"vipLevelId" : NSStringFromInt(model.vipLevelId),
                                             @"vipLevelName" : model.vipLevelName,@"isOpen" :NSStringFromInt(model.isOpen)};
                [muAryTemp addObject:parameters];
            }
            _noBuyDataSource.aryVIP = aryTemp;
            _noBuyDataSource.selectIndex = 1;
            if (muAryTemp.count>0)
            {
                self.privateView.privateVipArray = muAryTemp;
            }else
            {
                int i=1;
                for (;i<=6;i++) {
                    NSDictionary *parameters = @{@"vipLevelId" : NSStringFromInt(i),
                                                 @"vipLevelName" : @"VIP",@"isOpen" :NSStringFromInt(0)};
                    [muAryTemp addObject:parameters];
                }
                self.privateView.privateVipArray = muAryTemp;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                @WeakObj(self)
                dispatch_async(dispatch_get_main_queue(), ^{
                    selfWeak.tableView.tableHeaderView = [selfWeak tableHeaderView];
                    selfWeak.tableView.delegate = selfWeak.buyDataSource;
                    selfWeak.tableView.dataSource = selfWeak.buyDataSource;
                    [selfWeak.tableView reloadData];
                });
            });
            return;
        }
    }
}

- (void)havePurchase:(NSNotification *)notify
{
    NSArray *aryModel = notify.object;
    _buyDataSource.aryModel = aryModel;
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        selfWeak.tableView.delegate = selfWeak.buyDataSource;
        selfWeak.tableView.dataSource = selfWeak.buyDataSource;
        [selfWeak.tableView reloadData];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noPurchase:) name:MESSAGE_HTTP_NOPURCHASE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(havePurchase:) name:MESSAGE_HTTP_MYPRIVATESERVICE_VC object:nil];
    [kHTTPSingle RequestMyPrivateService:KUserSingleton.nUserId];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)dealloc
{
    DLog(@"dealloc!");
}

- (void)selectIndex:(TQMeCustomizedModel *)model
{
    XPrivateDetailViewController *detailView = [[XPrivateDetailViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:detailView animated:YES];
}

/**
*  创建table HeadView
*/
- (UIView *)tableHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 274+kScreenWidth*0.7)];
    [headerView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    char cString[255];
    const char *path = [[[NSBundle mainBundle] bundlePath] UTF8String];
    sprintf(cString, "%s/network_anomaly_fail.png",path);
    NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
    UIImage *image = [UIImage imageWithContentsOfFile:objCString];
    if(image)
    {
        UIView *noView = [ViewNullFactory createViewBg:Rect(0,0,kScreenWidth,kScreenWidth*0.7) imgView:image msg:@"您没有购买私人定制"];
        noView.userInteractionEnabled = NO;
        [headerView addSubview:noView];
    }
    // 向您推荐
    UIView *recommendView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenWidth*0.7, kScreenWidth, 154)];
    recommendView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lblTemp = [[UILabel alloc] initWithFrame:Rect(10,0,kScreenWidth-20,30)];
    [lblTemp setText:@"向您推荐"];
    [lblTemp setFont:XCFONT(16)];
    [recommendView addSubview:lblTemp];
    
    UILabel *line = [[UILabel alloc] initWithFrame:Rect(0, 30, kScreenWidth, 0.5)];
    [recommendView addSubview:line];
    [line setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    
    // 图标
    CGFloat iconW = 80;
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, lblTemp.height+10, iconW, iconW)];
    iconImageView.image = [UIImage imageNamed:@"default"];
    iconImageView.clipsToBounds = YES;
    iconImageView.layer.cornerRadius = iconW/ 2;
    [recommendView addSubview:iconImageView];
    
    // 标题：开通团队
    UILabel *_titleLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+10,iconImageView.y, kScreenWidth - 90, 30)];
    _titleLable.font = XCFONT(16);
    _titleLable.textColor = UIColorFromRGB(0x4c4c4c);
    NSString *strName = [NSString stringWithFormat:@"开通团队:%@",_room.teamname];
    _titleLable.text = strName;
    [recommendView addSubview:_titleLable];
    
    // 有效期
    UILabel *expiryLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame)+10,_titleLable.y+30, kScreenWidth - 90, 30)];
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
    if(!_privateView)
    {
        _privateView = [[PrivateVipView alloc] init];
        _privateView.frame = CGRectMake(0, CGRectGetMaxY(recommendView.frame)+10, kScreenWidth, 100);
        _privateView.selectVipBlock = ^(NSUInteger vipLevelId){
            @StrongObj(self)
            self.noBuyDataSource.selectIndex = vipLevelId;
            [self.tableView reloadData];
        };
    }
    _privateView.frame = CGRectMake(0, CGRectGetMaxY(recommendView.frame)+10, kScreenWidth, 100);
    [headerView addSubview:_privateView];
    return headerView;
}

@end
