//
//  RoomViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 12/10/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "RoomViewController.h"
#import "XTeamPrivateController.h"
#import "ConnectRoomViewModel.h"
#import "RoomService.h"
#import "AlertFactory.h"

#import "ZLLogonProtocol.h"
#import "ZLLogonServerSing.h"

#import "InAppPurchasesViewController.h"
#import "PaySelectViewController.h"

#import "LivePlayViewController.h"
#import "Photo.h"
#import "PhotoViewController.h"

#import "ZLCoreTextCell.h"
#import "RoomCoreTextCell.h"

#import "NoticeModel.h"
#import "RoomHttp.h"
#import "RoomGroup.h"

#import "ChatView.h"
#import "MyScrollView.h"
#import "FloatingView.h"
#import "GiftView.h"
#import "RoomDownView.h"
#import "RoomUserCell.h"
#import "RoomUser.h"
#import "RoomInfo.h"
#import "UserListView.h"
#import "SliderMenuView.h"
#import "RoomHeaderView.h"

#import "NSAttributedString+EmojiExtension.h"
#import "UIControl+UIControl_XY.h"
#import "UITableView+reloadComplete.h"
#import <DTCoreText/DTCoreText.h>

#import "XVideoLiveViewcontroller.h"
#import "XIdeaViewController.h"
#import "XTraderViewController.h"
#import "XTeamViewController.h"

#define TABLEVIEW_ARRAY_PREDICATE(A) [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",A];

@interface RoomViewController ()<UIScrollViewDelegate,RoomHeadViewDelegate>
{
    //聊天view
    NSInteger _nTag;
    NSInteger _tag;
    CGFloat startContentOffsetX;
    CGFloat willEndContentOffsetX;
    CGFloat endContentOffsetX;
    RoomHeaderView *headView;
    int updateCount;
    int _currentPage;
    
}

@property (nonatomic,strong) UIButton *btnRight;

@property (assign,nonatomic) NSInteger keyboardPresentFlag;

@property (nonatomic,strong) MyScrollView *scrollView;

@property (nonatomic,copy) NSArray *aryUser;
@property (nonatomic,copy) NSArray *aryNotice;
@property (nonatomic,copy) NSArray *aryPriChat;
@property (nonatomic,copy) NSArray *aryChat;

@property (nonatomic,strong) XTraderViewController *tradeView;
@property (nonatomic,strong) XTeamPrivateController *privateView;
@property (nonatomic,strong) XVideoLiveViewcontroller *liveControl;
@property (nonatomic,strong) XIdeaViewController *ideaControl;
@property (nonatomic,strong) ConnectRoomViewModel *roomModel;

@end

@implementation RoomViewController

DEFINE_SINGLETON_FOR_CLASS(RoomViewController)

- (void)addNotify
{
    [_liveControl addNotify];
    [_ideaControl addNotify];
    [_tradeView addNotify];
    [_privateView addNotify];
}

- (void)createRoomModel
{
    if (!_roomModel)
    {
        _roomModel = [[ConnectRoomViewModel alloc] initWithViewController:self];
    }
    @WeakObj(self)
    _roomModel.ConnectRoomResult = ^(int nStatus)
    {
        if(nStatus==1)
        {
            dispatch_main_async_safe(
            ^{
                [selfWeak loadHeadModel];
                [selfWeak.liveControl stopNewPlay];
                [selfWeak.liveControl reloadModel:selfWeak.room];
            });
        }
        else if(nStatus == 999)
        {
            dispatch_main_async_safe(
             ^{
                 [ProgressHUD showError:@"加入房间超时"];
                 [selfWeak loadHeadModel];
                 [selfWeak.liveControl stopNewPlay];
                 [selfWeak.liveControl reloadModel:selfWeak.room];
             });
        }
    };
}

- (void)setRoom:(RoomHttp*)room
{
    _room = room;
    [[ZLLogonServerSing sharedZLLogonServerSing] exitRoom];
    [self createRoomModel];
    _roomModel.nTimes = 0;
    @WeakObj(self)
    if([self isViewLoaded])
    {
        [self addNotify];
        [self loadHeadModel];
        [_liveControl stopNewPlay];
        [headView.segmented setSelectedSegmentIndex:0];
        headView.hdsegmented.selectIndex = 0;
        [self selectIndexSegment:0];
        
        [_ideaControl setModel:_room];
        [_tradeView reloadModel:_room];
        [_privateView setModel:_room];
    }
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
        [selfWeak.roomModel connectViewModel:selfWeak.room];
    });
}

- (void)removeNotice
{
    [_liveControl removeNotify];
    [_ideaControl removeNotify];
    [_tradeView removeNotify];
    [_privateView removeNotify];
}

- (void)removeAllNotice
{
    [_liveControl removeAllNotify];
}

- (void)startVideoPlay
{
    [_liveControl startNewPlay];
}

/**
*  释放房间中的内容
*/
- (void)closeRoomInfo
{
    [[SDImageCache sharedImageCache] clearMemory];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)stopVideoPlay
{
    [_liveControl stopNewPlay];
}

- (void)exitRoom
{
    [_liveControl stopNewPlay];
    [_liveControl removeAllNotify];
    _room = nil;
    [kProtocolSingle exitRoom];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)exitRoomHeader
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    DLog(@"room view");
    [kProtocolSingle exitRoom];
    [[SDImageCache sharedImageCache] clearMemory];
    [_scrollView removeFromSuperview];
    _scrollView = nil;
}

- (void)createScrolView:(CGRect)frame{
    if (_scrollView==nil)
    {
        _scrollView = [[MyScrollView alloc] initWithFrame:frame];
        [self.view addSubview:_scrollView];
        _scrollView.clipsToBounds = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _scrollView.delegate = self;
        [_scrollView setBackgroundColor:UIColorFromRGB(0xffffff)];
        _scrollView.contentSize = CGSizeMake(kScreenWidth*4, _scrollView.height);
    }
}

- (void)loadHeadModel
{
    headView.lblTitle.text = _room.teamname;
    NSDictionary *dict = @{@"count":NSStringFromInt(nRoom_count_info),@"fans":NSStringFromInt(nRoom_fans_info)};
    [headView setDict:dict];
}

/**
*  新初始化方案
*/
- (void)initUIHead
{
    headView = [[RoomHeaderView alloc] initWithFrame:Rect(0, 0, kScreenWidth,kRoom_head_view_height)];
    [self.view addSubview:headView];
    headView.delegate = self;
    [self loadHeadModel];
    
    [self createScrolView:Rect(0, headView.height, kScreenWidth, kScreenHeight-headView.height)];
    CGRect frame = _scrollView.bounds;
    
    _liveControl = [[XVideoLiveViewcontroller alloc] initWithModel:_room];
    [self addChildViewController:_liveControl];
    _liveControl.view.frame = frame;
    [_scrollView addSubview:_liveControl.view];
    
    @WeakObj(self)
    _liveControl.ffPlay.statusBarHidden=^(BOOL bFull)
    {
         [selfWeak setNeedsStatusBarAppearanceUpdate];
    };
    
    _liveControl.ffPlay.colletView = ^(BOOL bCollet)
    {
        if (bCollet) {
            nRoom_fans_info++;
        }
        else
        {
            nRoom_fans_info--;
        }
        dispatch_main_async_safe(
        ^{
            [selfWeak loadHeadModel];
        });
    };
    
    frame.origin.x += kScreenWidth;
    _ideaControl = [[XIdeaViewController alloc] initWithFrame:frame model:_room];
    [_scrollView addSubview:_ideaControl];
    
    frame.origin.x += kScreenWidth;
    //伪UIViewController
    _tradeView = [[XTraderViewController alloc] initWithFrame:frame model:_room control:self];
    [_scrollView addSubview:_tradeView];
    
    frame.origin.x += kScreenWidth;
    _privateView = [[XTeamPrivateController alloc] initWithFrame:frame model:_room];
    [_scrollView addSubview:_privateView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUIHead];
    [self addNotify];
    [self loadHeadModel];
//    [headView.segmented setSelectedSegmentIndex:0];
    headView.hdsegmented.selectIndex = 0;
    [self selectIndexSegment:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DLog(@"收到内存警告");
}

#pragma mark 重力感应设置
-(BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //拖动前的起始坐标
    startContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //将要停止前的坐标
    willEndContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (startContentOffsetX==0 && willEndContentOffsetX == 0) {
        return ;
    }
    int temp = floor((scrollView.contentOffset.x - kScreenWidth/2.0)/kScreenWidth +1);//判断是否翻页
    if (temp != _currentPage)
    {
        updateCount++;
        _currentPage = temp;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (updateCount == 1)//正常
    {
        DLog(@"x:%f--y:%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
        _tag = scrollView.contentOffset.x/kScreenWidth;
//        [headView.segmented setSelectedSegmentIndex:_tag];
        headView.hdsegmented.selectIndex = _tag;

    }
    else//加速
    {
        DLog(@"x:%f--y:%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
        _tag = scrollView.contentOffset.x/kScreenWidth;
//        [headView.segmented setSelectedSegmentIndex:_tag];
        headView.hdsegmented.selectIndex = _tag;

    }
    updateCount = 0;
    startContentOffsetX=0;
    willEndContentOffsetX = 0;
}

- (void)selectIndexSegment:(NSInteger)nIndex
{
    _tag = nIndex;
    [_scrollView setContentOffset:CGPointMake(nIndex*kScreenWidth,0)];
}

- (void)enterTeamIntroduce
{
    XTeamViewController *teamView = [[XTeamViewController alloc] initWithModel:_room];
    [self.navigationController pushViewController:teamView animated:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self horizontalViewControl];
}

#pragma mark 切换
#pragma mark 全屏与四屏切换，设置frame与bounds

-(CGAffineTransform)transformView
{
    if (rand()%2)
    {
        return CGAffineTransformMakeRotation(M_PI/2);
    }
    else
    {
        return CGAffineTransformIdentity;
    }
}

#pragma mark 横屏
- (void)horizontalViewControl
{
   [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark 竖屏
- (void)verticalViewControl
{
   [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden//for iOS7.0
{
    if (!_liveControl.ffPlay.bFull)
    {
        return NO;
    }
    return YES;
}

@end

