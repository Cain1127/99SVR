//
//  RoomViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 12/10/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "RoomViewController.h"
#import "XTeamPrivateController.h"
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

@interface RoomViewController ()<UIScrollViewDelegate,RoomHeadViewDelegate,VideoLiveDelegate>
{
    //聊天view
    NSInteger _nTag;
    dispatch_queue_t room_gcd;
    NSInteger _tag;
    CGFloat startContentOffsetX;
    CGFloat willEndContentOffsetX;
    CGFloat endContentOffsetX;
    RoomHeaderView *headView;
    int updateCount;
    int _currentPage;
    BOOL bFull;
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

@end

@implementation RoomViewController

DEFINE_SINGLETON_FOR_CLASS(RoomViewController)

- (void)setRoom:(RoomHttp*)room
{
    _room = room;
    if([self isViewLoaded]){
        [self loadHeadModel];
        [_liveControl stopNewPlay];
        [_liveControl reloadModel:_room];
        [_ideaControl setModel:_room];
        [_tradeView reloadModel:_room];
        [_ideaControl setModel:_room];
        [_privateView setModel:_room];
    }
}

/**
*  释放房间中的内容
*/
- (void)closeRoomInfo
{
    [[SDImageCache sharedImageCache] clearMemory];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)exitRoom
{
    [_liveControl stopNewPlay];
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

- (void)colletRoom
{
    if([UserInfo sharedUserInfo].aryCollet.count>=1)
    {
        RoomGroup *group = [[UserInfo sharedUserInfo].aryCollet objectAtIndex:0];
        for (RoomHttp *room in group.roomList)
        {
            if([_room.nvcbid isEqualToString:room.nvcbid])
            {
                __weak RoomViewController *__self = self;
                dispatch_main_async_safe(
                ^{
                   [__self.btnRight setSelected:YES];
                });
                break;
            }
        }
    }
}

#pragma mark 关注
- (void)colletCurrentRoom
{
    if([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1)
    {
        _btnRight.selected = !_btnRight.selected;
        NSString *strMsg = _btnRight.selected ? @"关注成功" : @"取消关注";
        [self.view makeToast:strMsg];
    }
    else
    {
        [self.view makeToast:@"游客不能关注"];
    }
}

- (void)createScrolView:(CGRect)frame{
    if (_scrollView==nil) {
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
    headView.lblCount.text = _room.onlineusercount;
    headView.lblFans.text = _room.onlineusercount;
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
    _liveControl.delegate = self;
    
    frame.origin.x += kScreenWidth;
    _ideaControl = [[XIdeaViewController alloc] initWihModel:_room];
    [self addChildViewController:_ideaControl];
    _ideaControl.view.frame = frame;
    
    frame.origin.x += kScreenWidth;
    _tradeView = [[XTraderViewController alloc] initWihModel:_room];
    [self addChildViewController:_tradeView];
    _tradeView.view.frame = frame;
    
    frame.origin.x += kScreenWidth;
    _privateView = [[XTeamPrivateController alloc] initWithModel:_room];
    [self addChildViewController:_privateView];
    _privateView.view.frame = frame;
    
    [_scrollView addSubview:_liveControl.view];
    [_scrollView addSubview:_ideaControl.view];
    [_scrollView addSubview:_tradeView.view];
    [_scrollView addSubview:_privateView.view];
   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    room_gcd = dispatch_queue_create("decode_gcd",0);
    [self initUIHead];
    @WeakObj(self)
    dispatch_async(dispatch_get_global_queue(0,0),
    ^{
        [selfWeak colletRoom];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DLog(@"收到内存警告");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        if (temp > _currentPage)
        {
            if (_tag < 3)
            {
                _tag++;
                [headView.segmented setSelectedSegmentIndex:_tag];
            }
        }
        else
        {
            if (_tag > 0)
            {
                _tag--;
                [headView.segmented setSelectedSegmentIndex:_tag];
            }
        }
        updateCount++;
        _currentPage = temp;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (updateCount == 1)//正常
    {
        
    }
    else if(updateCount == 0 && _currentPage == 0)
    {

    }
    else//加速
    {}
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
    if(bFull)
    {
        [self horizontalViewControl];
    }
    else
    {
        [self verticalViewControl];
    }
}

- (void)fullModel
{
//    [self fullPlayMode];
}

#pragma mark 切换
#pragma mark 全屏与四屏切换，设置frame与bounds
-(void)fullPlayMode
{
    if (!bFull)//NO状态表示当前竖屏，需要转换成横屏
    {
        CGFloat _duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [[UIDevice currentDevice] setValue: [NSNumber numberWithInteger:UIDeviceOrientationLandscapeRight] forKey:@"orientation"];
        [UIViewController attemptRotationToDeviceOrientation];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:_duration];
        CGRect frame = [UIScreen mainScreen].bounds;
        CGPoint center = CGPointMake(frame.origin.x + ceil(frame.size.width/2), frame.origin.y + ceil(frame.size.height/2));
        self.view.center = center;
        self.view.transform = [self transformView];
        self.view.bounds = Rect(0, 0,kScreenHeight,kScreenWidth);
        [UIView commitAnimations];
        bFull = YES;
    }
    else
    {
        [self setHorizontal];
        bFull = NO;
    }
}

-(void)setHorizontal
{
    [[UIDevice currentDevice] setValue: [NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    CGFloat _duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:_duration];
    CGRect frame = [UIScreen mainScreen].bounds;
    CGPoint center = CGPointMake(frame.origin.x + ceil(frame.size.width/2), frame.origin.y + ceil(frame.size.height/2));
    self.view.center = center;
    self.view.transform = [self transformView];
    self.view.bounds = CGRectMake(0, 0, kScreenSourchWidth, kScreenSourchHeight);
    [UIView commitAnimations];
}

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
}

#pragma mark 竖屏
- (void)verticalViewControl
{
   [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden//for iOS7.0
{
    if (!bFull)
    {
        return NO;
    }
    return YES;
}

@end

