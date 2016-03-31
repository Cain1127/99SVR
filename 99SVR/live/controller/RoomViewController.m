//
//  RoomViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 12/10/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "RoomViewController.h"
#import "ChatView.h"
#import "FloatingView.h"
#import "RoomTcpSocket.h"
#import "GiftView.h"
#import "GitInfo.h"
#import "RoomCoreTextCell.h"
#import "RoomHttp.h"
#import "SDImageCache.h"
#import "NoticeModel.h"
#import "UIImageView+WebCache.h"
#import "RoomDownView.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import "ZLCoreTextCell.h"
#import "UITableView+reloadComplete.h"
#import "RoomHttp.h"
#import "RoomGroup.h"
#import "RoomUserCell.h"
#import "Toast+UIView.h"
#import "EmojiTextAttachment.h"
#import "UIImage+animatedGIF.h"
#import "UserInfo.h"
#import "RoomUser.h"
#import "RoomTitleView.h"
#import <DTCoreText/DTCoreText.h>
#import "LivePlayViewController.h"
#import "RoomInfo.h"
#import "UserInfo.h"
#import "ChatButton.h"
#import "EmojiView.h"
#import "NSAttributedString+EmojiExtension.h"
#import "UserListView.h"

#define TABLEVIEW_ARRAY_PREDICATE(A) [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",A];

@interface RoomViewController ()<UITableViewDelegate,UITableViewDataSource,TitleViewDelegate,
UITextViewDelegate,DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate,UIScrollViewDelegate,RoomDownDelegate,ChatViewDelegate,GiftDelegate,UserListSelectDelegate>
{
    //聊天view
    UIView *bodyView;
    UIView *downView;
    BOOL bDrag;
    UIView *defaultHeadView;
    UIView *defaultDownView;
    ChatButton *_btnName;
    UIButton *_btnSend;
    UITextView *_textChat;
    UILabel *_lblBlue;
    CGFloat deltaY;
    float duration;    // 动画持续时间
    CGFloat originalY; // TextField原来的纵坐标
    int toUser;
    UIView  *_topHUD;
    UILabel *_lblName;
    UIView *_downHUD;
    UIButton *_btnVideo;
    NSInteger _nTag;
    dispatch_queue_t room_gcd;
    
    int _tag;
    CGFloat startContentOffsetX;
    CGFloat willEndContentOffsetX;
    CGFloat endContentOffsetX;
    int updateCount;
    int _currentPage;
    CGFloat fTempWidth;
    BOOL bFull;
    
    RoomHttp *_room;
    GiftView *_giftView;
    RoomDownView *_infoView;
    
    UIView *userHidden;
    UIView *headTable;
    ChatView *_inputView;
    int nColor;
    UserListView *_listView;
    
    NSCache *chatCache;
    DTAttributedLabel *lblTeachInfo;
}

@property (nonatomic,strong) RoomTcpSocket *tcpSocket;
@property (nonatomic,strong) NSCache *cellCache;
@property (nonatomic,strong) NSMutableDictionary *dictIcon;
@property (nonatomic,strong) LivePlayViewController *ffPlay;
@property (nonatomic,strong) UIButton *btnRight;
@property (nonatomic,strong) UIButton *btnFull;
@property (nonatomic,assign) CGFloat fChatHeight;
@property (nonatomic,strong) RoomTitleView *group;
@property (nonatomic,strong) UITableView *priChatView;
@property (nonatomic,strong) UITableView *noticeView;
@property (nonatomic,strong) UITableView *chatView;
@property (assign,nonatomic) NSInteger keyboardPresentFlag;
@property (nonatomic,strong) UIScrollView *scrollView;
//@property (nonatomic,strong) NSMutableDictionary *cellHeights;

@end

@implementation RoomViewController

- (id)initWithModel:(RoomHttp *)room
{
    self = [super init];
    _room = room;
    _tcpSocket = [[RoomTcpSocket alloc] init];
    return self;
}

- (void)connectRoomInfo
{
    NSString *strAddress;
    NSString *strPort;
    if([UserInfo sharedUserInfo].strRoomAddr)
    {
        NSString *strAry = [[UserInfo sharedUserInfo].strRoomAddr componentsSeparatedByString:@","][0];
        strAddress = [strAry componentsSeparatedByString:@":"][0];
        strPort = [strAry componentsSeparatedByString:@":"][1];
    }
    else
    {
        NSString *strAry = [_room.cgateaddr componentsSeparatedByString:@";"][0];
        strAddress = [strAry componentsSeparatedByString:@":"][0];
        strPort = [strAry componentsSeparatedByString:@":"][1];
    }
    [_tcpSocket connectRoomInfo:_room.nvcbid address:strAddress port:[strPort intValue]];
//    [_tcpSocket connectRoomInfo:_room.nvcbid address:@"121.12.118.32" port:22706];
    [self performSelector:@selector(joinRoomTimeOut) withObject:nil afterDelay:6];
}

- (void)dealloc
{
    DLog(@"room view");
    _ffPlay = nil;
    [_scrollView removeFromSuperview];
    _scrollView = nil;
    [_dictIcon removeAllObjects];
    _dictIcon = nil;
    [_group removeFromSuperview];
    _group = nil;
    [_chatView removeFromSuperview];
    _chatView = nil;
    [_noticeView removeFromSuperview];
    _noticeView = nil;
    [_priChatView removeFromSuperview];
    _priChatView = nil;
    [[GitInfo sharedGitInfo] removeAllIcon];
}

- (void)navBack
{
    if(!bFull)
    {
        [_ffPlay stop];
        [_tcpSocket exit_Room:YES];
        [[SDImageCache sharedImageCache] clearMemory];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self fullPlayMode];
    }
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

#pragma mark 刷新文字与图片的位置
- (void)refreshBtnName
{
    CGSize size = [_btnName.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:XCFONT(12)}];
    CGFloat fTemp = (_btnName.width-20)/2+size.width/2;
    CGFloat fWidth = fTemp >= (_btnName.width-20) ? (_btnName.width-20+3) :fTemp+3;
    _btnName.imageEdgeInsets = UIEdgeInsetsMake(0.,fWidth, 0., 0.);
    _btnName.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
}

#pragma mark 关注
- (void)colletCurrentRoom
{
    if([UserInfo sharedUserInfo].bIsLogin && [UserInfo sharedUserInfo].nType == 1)
    {
        _btnRight.selected = !_btnRight.selected;
        NSString *strMsg = _btnRight.selected ? @"关注成功" : @"取消关注";
        [self.view makeToast:strMsg];
        [_tcpSocket sendColletRoom:_btnRight.selected];
    }
    else
    {
        [self.view makeToast:@"游客不能关注"];
    }
}

//隐藏透明栏
- (void)hiddenTopHud
{
    if ([NSThread isMainThread])
    {
        _topHUD.alpha = 0;
        _downHUD.alpha = 0;
    }
    else
    {
        __weak UIView *__topHud = _topHUD;
        __weak UIView *__downHUD = _downHUD;
        dispatch_main_async_safe(
       ^{
           __topHud.alpha = 0;
           __downHUD.alpha = 0;
       });
    }
}

- (void)showTopHUD
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if(_topHUD.alpha==0)
    {
        _topHUD.alpha = 1;
        _downHUD.alpha = 1;
        [self performSelector:@selector(hiddenTopHud) withObject:nil afterDelay:2.0];
    }
    else
    {
        _topHUD.alpha = 0;
        _downHUD.alpha = 0;
    }
}

- (void)roomTitleView:(UIButton *)sender
{
    [self switchBtn:(int)sender.tag];
}

- (void)initUIHead
{
    _ffPlay = [[LivePlayViewController alloc] init];
    [self.view insertSubview:_ffPlay.view atIndex:1];
    _ffPlay.view.frame = Rect(0, 20, kScreenWidth, kScreenHeight);
    
    _topHUD = [[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,64)];
    _topHUD.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_topHUD];
    
    _lblName = [[UILabel alloc] initWithFrame:Rect(50,35,kScreenWidth-100,20)];
    [_lblName setTextAlignment:NSTextAlignmentCenter];
    char cString[150] = {0};
    sprintf(cString,"%s %s",[_room.cname UTF8String],[_room.nvcbid UTF8String]);
    [_lblName setText:[[NSString alloc] initWithUTF8String:cString]];
    
    [_lblName setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    [_lblName setTextColor:[UIColor whiteColor]];
    [_topHUD addSubview:_lblName];
    
    UIImageView *topViewBg = [[UIImageView alloc] initWithFrame:_topHUD.bounds];
    [topViewBg setImage:[UIImage imageNamed:@"dvr_conttrol_bg"]];
    [topViewBg setTag:1];
    [_topHUD insertSubview:topViewBg atIndex:0];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_high"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    [_topHUD addSubview:btnBack];
    btnBack.tag = 2;
    btnBack.frame = Rect(0, 20, 44, 44);
    
    _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnRight setImage:[UIImage imageNamed:@"coll_normal"] forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:@"coll_high"] forState:UIControlStateHighlighted];
    [_btnRight setImage:[UIImage imageNamed:@"coll_high"] forState:UIControlStateSelected];
    [_btnRight addTarget:self action:@selector(colletCurrentRoom) forControlEvents:UIControlEventTouchUpInside];
    [_topHUD addSubview:_btnRight];
    _btnRight.frame = Rect(kScreenWidth-44, 20, 44, 44);
    
    NSArray *aryTitle = @[@"聊天区",@"我的",@"公告",@"课程表"];
    _group = [[RoomTitleView alloc] initWithFrame:Rect(0,20+kVideoImageHeight,kScreenWidth, 44) ary:aryTitle];
    [self.view addSubview:_group];
    _group.delegate = self;
    
    bodyView = [[UIView alloc] initWithFrame:Rect(0, _group.y+_group.height, kScreenWidth,kScreenHeight-_group.y-_group.height)];
    [self.view addSubview:bodyView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:Rect(0, 0, bodyView.width, bodyView.height)];
    [bodyView addSubview:_scrollView];
    
    _scrollView.clipsToBounds = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _scrollView.delegate = self;
    [_scrollView setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    _chatView = [[UITableView alloc] initWithFrame:Rect(0, 0, _scrollView.width, _scrollView.height-50)];
    [_scrollView addSubview:_chatView];
    _chatView.delegate = self;
    _chatView.dataSource = self;
    [_chatView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_chatView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    
    _priChatView = [[UITableView alloc] initWithFrame:Rect(_scrollView.width,0, _scrollView.width, _scrollView.height)];
    [_scrollView addSubview:_priChatView];
    _priChatView.delegate = self;
    _priChatView.dataSource = self;
    [_priChatView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_priChatView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    
    _noticeView = [[UITableView alloc] initWithFrame:Rect(_scrollView.width*2, 0, _scrollView.width, _scrollView.height) style:UITableViewStyleGrouped];
    [_scrollView addSubview:_noticeView];
    _noticeView.delegate = self;
    _noticeView.dataSource = self;
    [_noticeView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    lblTeachInfo = [[DTAttributedLabel alloc] initWithFrame:Rect(_scrollView.width*3+8, 0, _scrollView.width-16,_scrollView.height)];
    [_scrollView addSubview:lblTeachInfo];
    lblTeachInfo.delegate = self;
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth*4,_scrollView.height);
    _downHUD = [[UIView alloc] initWithFrame:Rect(0, kVideoImageHeight-24, kScreenWidth, 44)];
    UIImageView *downImg = [[UIImageView alloc] initWithFrame:_downHUD.bounds];
    [downImg setImage:[UIImage imageNamed:@"dvr_conttrol_bg"]];
    [_downHUD addSubview:downImg];
    [downImg setTag:1];
    [self.view addSubview:_downHUD];
    
    _btnVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    [_downHUD addSubview:_btnVideo];
    _btnVideo.frame = Rect(10, 0, 44, 44);
    [_btnVideo setImage:[UIImage imageNamed:@"video_h"] forState:UIControlStateNormal];
    [_btnVideo setImage:[UIImage imageNamed:@"video"] forState:UIControlStateSelected];
    [_btnVideo addTarget:self action:@selector(connectUnVideo:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnFull = [UIButton buttonWithType:UIButtonTypeCustom];
    [_downHUD addSubview:_btnFull];
    _btnFull.frame = Rect(kScreenWidth-54, 0, 44, 44);
    [_btnFull setImage:[UIImage imageNamed:@"full"] forState:UIControlStateNormal];
    [_btnFull setImage:[UIImage imageNamed:@"full_h"] forState:UIControlStateSelected];
    [_btnFull addTarget:self action:@selector(fullPlayMode) forControlEvents:UIControlEventTouchUpInside];
    [self initUIBody];
}

- (void)connectUnVideo:(UIButton *)sender
{
    if (_ffPlay.playing)
    {
        [_ffPlay setOnlyAudio:sender.selected];
        sender.selected = !sender.selected;
    }
}



- (void)sendRose
{
    if(!_tcpSocket.rInfo)
    {
        [self.view makeToast:@"加入房间成功，才可以互动"];
        return ;
    }
    if([UserInfo sharedUserInfo].nType != 1 && ![_room.nvcbid isEqualToString:@"10000"] && ![_room.nvcbid isEqualToString:@"10001"])
    {
        [self.view makeToast:@"游客不能送花"];
        return ;
    }
//    __block int __nUserId = toUser;
    __weak RoomViewController *__self = self;
    dispatch_async(room_gcd,
    ^{
        [__self.tcpSocket sendChatInfo:@"[$999$]" toid:0];
    });
}

- (void)initUIBody
{
    //创建成员列表的tableView
    
    _lblBlue = [[UILabel alloc] initWithFrame:Rect(0, _group.y+_group.height-1, 0, 2)];
    [_lblBlue setBackgroundColor:UIColorFromRGB(0x629bff)];
    [self.view addSubview:_lblBlue];
    
     _infoView = [[RoomDownView alloc] initWithFrame:Rect(0,_scrollView.height-50, kScreenWidth, 50)];
    [_scrollView addSubview:_infoView];
    _infoView.delegate = self;
    
    UILabel *lblDownLine = [[UILabel alloc] initWithFrame:Rect(0, 0, kScreenWidth, 0.5)];
    [lblDownLine setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    [downView addSubview:lblDownLine];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:Rect(10, 7, kScreenWidth-20, 36)];
    [whiteView setBackgroundColor:UIColorFromRGB(0xffffff)];
    [downView addSubview:whiteView];
    
    //发送消息按钮
    _giftView = [[GiftView alloc] initWithFrame:Rect(0,0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_giftView];
    _giftView.frame = Rect(0, kScreenHeight, kScreenWidth, 0);
    _giftView.delegate = self;
    
    _listView = [[UserListView alloc] initWithFrame:Rect(0,0, kScreenWidth, kScreenHeight) array:nil];
    [self.view addSubview:_listView];
    _listView.frame = Rect(0, kScreenHeight, kScreenWidth, 0);
    _listView.delegate = self;
    
    [self createChatView];
}

- (void)createChatView
{
    _inputView = [[ChatView alloc] initWithFrame:Rect(0, 0, kScreenWidth,kScreenHeight)];
    [self.view addSubview:_inputView];
    _inputView.hidden = YES;
    _inputView.delegate = self;
}

- (void)hidnUserTable
{

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_COLLET_UPDATE_VC object:nil];
    [self showTopHUD];
}

- (void)startNewPlay
{
    NSArray *aryUser = _tcpSocket.aryUser;
    for (RoomUser *user in aryUser)
    {
        if ([user isOnMic])
        {
            [_ffPlay startPlayRoomId:[[_tcpSocket getRoomId] intValue] user:user.m_nUserId];
            return ;
        }
    }
    __weak LivePlayViewController *__ffPlay = _ffPlay;
    dispatch_main_async_safe(
    ^{
        [__ffPlay setNullMic];
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    room_gcd = dispatch_queue_create("decode_gcd",0);
    _cellCache = [[NSCache alloc] init];
    _cellCache.totalCostLimit = 20;
    [self initUIHead];
    UITapGestureRecognizer* singleRecogn;
    
    singleRecogn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTopHUD)];
    singleRecogn.numberOfTapsRequired = 1; // 双击
    [_ffPlay.view setUserInteractionEnabled:YES];
    [_ffPlay.view addGestureRecognizer:singleRecogn];
    
    singleRecogn = nil;
    singleRecogn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom)];
    singleRecogn.numberOfTapsRequired = 2;
    [_ffPlay.view addGestureRecognizer:singleRecogn];
    
    [self performSelector:@selector(hiddenTopHud) withObject:nil afterDelay:3.0];
    @WeakObj(self)
    dispatch_async(dispatch_get_global_queue(0,0),
    ^{
        [selfWeak colletRoom];
    });
    _nTag = 1;
    fTempWidth = [@"热门推荐" sizeWithAttributes:@{NSFontAttributeName:XCFONT(14)}].width;
    [self setBluePointX:0];
    [self switchBtn:1];
    [self connectRoomInfo];
    
}

#pragma mark 双击事件  切换屏幕
- (void)handleDoubleTapFrom
{
    [self fullPlayMode];
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
        _btnFull.selected = YES;
    }
    else
    {
        [self setHorizontal];
        bFull = NO;
        _btnFull.selected = NO;
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
    if (!_group.hidden)
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
    
    int nWidth = kScreenHeight > kScreenWidth ? kScreenHeight : kScreenWidth;
    int nHeight = kScreenHeight > kScreenWidth ? kScreenWidth : kScreenHeight;
    
    _ffPlay.view.frame = Rect(0, 0, nWidth, nHeight);
    _ffPlay.glView.frame = Rect(0, 0, nWidth, nHeight);
    
    _topHUD.frame = Rect(0, 0, nWidth, 44);
    
    [_topHUD viewWithTag:1].frame = Rect(0, 0, nWidth, 44);
    [_topHUD viewWithTag:2].frame = Rect(0, 0, 44, 44);
    
    _lblName.frame = Rect(50, 12, nWidth-100, 15);
    _btnRight.frame = Rect(nWidth-50, 0, 44, 44);
    
    _downHUD.frame = Rect(0, nHeight-44, nWidth, 44);
    [[_downHUD viewWithTag:1] setFrame:_downHUD.bounds];
    _btnFull.frame = Rect(nWidth-54, 0, 44, 44);
    
    _group.hidden = YES;
    downView.hidden = YES;
    _scrollView.hidden = YES;
    _lblBlue.hidden = YES;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark 竖屏
- (void)verticalViewControl
{
    _topHUD.frame = Rect(0, 0, kScreenWidth, 64);
    [_topHUD viewWithTag:1].frame = Rect(0, 0, kScreenWidth, 64);
    _lblName.frame = Rect(50, 35, kScreenWidth-100, 15);
    [_topHUD viewWithTag:2].frame = Rect(0, 20, 44, 44);
    _btnRight.frame = Rect(kScreenWidth-50, 20, 44, 44);
    _downHUD.frame = Rect(0, kVideoImageHeight-24, kScreenWidth, 44);
    _ffPlay.view.frame = Rect(0, 20, kScreenWidth, kScreenHeight);
    _ffPlay.glView.frame = Rect(0,1,kScreenWidth, kVideoImageHeight);
    
    _btnFull.frame = Rect(kScreenWidth-54, 0, 44, 44);
    
    _group.hidden = NO;
    downView.hidden = NO;
    _lblBlue.hidden = NO;
    _scrollView.hidden = NO;
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

#pragma mark ViewLayout
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(!bFull)
    {
        [self verticalViewControl];
    }
    else
    {
        [self horizontalViewControl];
    }
}

- (void)switchBtn:(int)nTag
{
    UIButton *btnSender = [_group viewWithTag:nTag];
    if(btnSender)
    {
        int tag = (int)btnSender.tag;
        [_group setBtnSelect:tag];
        if(tag+3 >= _tag || tag-3 <=_tag)
        {
            _tag = (int)btnSender.tag;
            [_scrollView setContentOffset:CGPointMake((tag-1)*kScreenWidth, 0)];
        }
        else
        {
            [_scrollView setContentOffset:CGPointMake((tag-1)*kScreenWidth, 0)];
            _tag = (int)btnSender.tag;
        }
        [self setBluePointX:_scrollView.contentOffset.x];
    }
}

- (void)groupEventInfo:(UIButton *)sender
{
    for (id view in _group.subviews){
        if([view isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)view;
            btn.selected = NO;
        }
    }
    sender.selected = YES;
    _nTag = sender.tag;
    [self setBluePointX:kScreenWidth*(_nTag-1)];
    if (sender.tag==4){
        _chatView.hidden = YES;
        _noticeView.hidden = YES;
        _priChatView.hidden = YES;
    }
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DLog(@"收到内存警告");
    [_cellCache removeAllObjects];
    if ([NSThread isMainThread])
    {
        [_tcpSocket.aryChat removeAllObjects];
        [_tcpSocket.aryNotice removeAllObjects];
        [_chatView reloadData];
        [_priChatView reloadData];
        [_noticeView reloadData];
    }
    else
    {
        __weak RoomViewController *__self = self;
        [_tcpSocket.aryChat removeAllObjects];
        [_tcpSocket.aryNotice removeAllObjects];
        dispatch_main_async_safe(^{
             [__self.chatView reloadData];
             [__self.priChatView reloadData];
             [__self.noticeView reloadData];
        });
    }
}

- (void)startPlayThread:(NSNotification *)notify
{
    __weak RoomViewController *__self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0),
    ^{
        [__self startNewPlay];
    });
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPlayThread:) name:MESSAGE_ROOM_MIC_UPDATE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomChatPriMsg:) name:MESSAGE_ROOM_TO_ME_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomChatMSg:) name:MESSAGE_ROOM_CHAT_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomListNotice:) name:MESSAGE_ROOM_NOTICE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomUserList:) name:MESSAGE_ROOM_ALL_USER_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comeBack) name:MESSAGE_COME_BACK_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomBeExit:) name:MESSAGE_ROOM_BE_CLOSE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(room_kickout) name:MESSAGE_ROOM_KICKOUT_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlay) name:MESSAGE_ROOM_MIC_CLOSE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reConnectRoomInfo) name:MESSAGE_RECONNECT_TIMER_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinRoomErr:) name:MESSAGE_JOIN_ROOM_ERR_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinRoomSucsess) name:MESSAGE_JOIN_ROOM_SUC_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendRoomMediaInfo:) name:MESSAGE_TCP_SOCKET_SEND_MEDIA object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTeachInfo) name:MESSAGE_ROOM_TEACH_INFO_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendLiwuRespInfo) name:MEESAGE_ROOM_SEND_LIWU_RESP_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendLiwuNotifyInfo:) name:MEESAGE_ROOM_SEND_LIWU_NOTIFY_VC object:nil];
}

- (void)sendLiwuNotifyInfo:(NSNotification *)notify
{
    NSDictionary *parameter = notify.object;
    __weak NSDictionary *__parameter = parameter;
    @WeakObj(self)
    __block int __nColor = nColor;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *strName = nil;
        int gid ;
        int num ;
        if ([__parameter objectForKey:@"name"] && [__parameter objectForKey:@"gitId"] && [__parameter objectForKey:@"num"]) {
            strName = [parameter objectForKey:@"name"];
            gid = [[parameter objectForKey:@"gitId"] intValue];
            num = [[parameter objectForKey:@"num"] intValue];
            FloatingView *floatView = [[FloatingView alloc] initWithFrame:Rect(0,selfWeak.group.y+selfWeak.group.height,kScreenWidth, 45) color:__nColor++ name:strName number:num gid:gid];
            [selfWeak.view addSubview:floatView];
            [floatView showGift:1.0];
        }
    });
}

- (void)sendLiwuRespInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showSuccess:@"赠送礼物成功"];
    });
}

- (void)setTeachInfo
{
    @WeakObj(lblTeachInfo)
    @WeakObj(self)
    gcd_main_safe(^{
        NSData *data = [selfWeak.tcpSocket.teachInfo dataUsingEncoding:NSUTF8StringEncoding];
        lblTeachInfoWeak.attributedString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:nil];
    });
}

- (void)sendRoomMediaInfo:(NSNotification *)notify
{
    if (notify&& notify.object)
    {
        NSString *strInfo = notify.object;
        [_tcpSocket sendMediaInfo:strInfo];
    }
}

- (void)joinRoomSucsess
{
    DLog(@"停止after");
    __weak RoomViewController *__self =self;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:__self];
    });
}

- (void)joinRoomErr:(NSNotification *)notify
{
    __weak RoomViewController *__self =self;
    dispatch_async(dispatch_get_main_queue(),
    ^{
       [NSObject cancelPreviousPerformRequestsWithTarget:__self];
    });
    NSNumber *strMsg = notify.object;
    if(strMsg && [strMsg intValue]==201)
    {
        __weak RoomViewController *__self = self;
        dispatch_async(dispatch_get_main_queue(),
        ^{
            [__self createAlertController];
        });
    }
}

- (void)roomMsgInfo:(NSNotification *)notify
{
      
}

- (void)reConnectRoomInfo
{
    [_tcpSocket reConnectRoomInfo];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self addNotification];
}

#pragma mark stop Play

- (void)stopPlay
{
    if(_ffPlay)
    {
        [_ffPlay stop];
    }
    __weak LivePlayViewController *__ffPlay = _ffPlay;
    dispatch_main_async_safe(
    ^{
        [__ffPlay setNullMic];
    });
}

#pragma mark被人踢出房间 触发的notification
- (void)room_kickout
{
    __weak RoomViewController *__self = self;
    dispatch_main_async_safe(
    ^{
        [__self.view makeToast:@"您被人踢出当前房间" duration:2 position:@"center"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [__self navBack];
        });
    });
}

#pragma mark 从后台返回
- (void)comeBack
{
    __weak RoomViewController *__self =self;
    __weak LivePlayViewController *__ffPlay = _ffPlay;
    dispatch_main_async_safe(
    ^{
        [__ffPlay setDefaultImg];
        [__self.chatView reloadData];
        [__self.noticeView reloadData];
        [__self.priChatView reloadData];
    });
    [_tcpSocket reConnectRoomInfo];
}

#pragma mark 进入后台
- (void)enterBack
{
    [_tcpSocket enterBackGroud];
    __weak RoomViewController *__self =self;
    dispatch_main_async_safe(
    ^{
       [__self.chatView reloadData];
       [__self.noticeView reloadData];
       [__self.priChatView reloadData];
    });
    [_ffPlay stop];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Room User List Update
- (void)roomUserList:(NSNotification*)notify
{
    [_listView reloadItems:_tcpSocket.aryUser];
}

#pragma mark 公告刷新
- (void)roomListNotice:(NSNotification *)notify
{
    __weak RoomViewController *__self = self;
    __weak RoomTcpSocket *__tcpSocket = _tcpSocket;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__self.noticeView reloadDataWithCompletion:
         ^{
             if (__tcpSocket.aryNotice.count > 0)
             {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:__tcpSocket.aryNotice.count-1];
                [__self.noticeView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
             }
         }];
    });
}

- (void)roomExitOrJoin:(NSNotification *)notify
{
    
}

- (void)roomBeExit:(NSNotification *)notify
{
    __weak RoomViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(),
       ^{
           [__self.view makeToast:@"当前房间被关闭" duration:2.0 position:@"center"];
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(),
           ^{
               [__self navBack];
           });
       });
}

- (void)roomChatPriMsg:(NSNotification *)notify
{
    __weak RoomViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(),^{
      [__self.priChatView reloadDataWithCompletion:
       ^{
           NSInteger numberOfRows = [__self.priChatView numberOfRowsInSection:0];
           if (numberOfRows > 0)
           {
               NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfRows-1 inSection:0];
               [__self.priChatView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
           }
       }];
   });
}

- (void)roomChatMSg:(NSNotification *)notify
{
    __weak RoomViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__self.chatView reloadDataWithCompletion:
         ^{
             NSInteger numberOfRows = [__self.chatView numberOfRowsInSection:0];
              if (numberOfRows > 0)
              {
                  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfRows-1 inSection:0];
                  [__self.chatView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
              }
         }];
    });
}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView==_noticeView)
    {
        return _tcpSocket.aryNotice.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _noticeView)
    {
        return 1;
    }
    else if(tableView == _chatView)
    {
        return _tcpSocket.aryChat.count;
    }
    else if(tableView == _priChatView)
    {
        return _tcpSocket.aryPriChat.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView == _noticeView)
    return 10;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == _noticeView)
    {
        return 10;
    }
    return 0;
}

- (DTAttributedTextCell *)tableView:(UITableView *)tableView chatPreparedCellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    NSString *key=nil;
    if (tableView==_chatView) {
        char cBuffer[100];
        sprintf(cBuffer,"chatView%zi-%zi",indexPath.section,indexPath.row);
        key = [[NSString alloc] initWithUTF8String:cBuffer];
    }
    else if(tableView == _priChatView){
        char cBuffer[100];
        sprintf(cBuffer,"private%zi-%zi",indexPath.section,indexPath.row);
        key = [[NSString alloc] initWithUTF8String:cBuffer];
    }
    if (!chatCache)
    {
        chatCache = [[NSCache alloc] init];
    }
    DTAttributedTextCell *cell = [chatCache objectForKey:key];
    if (!cell)
    {
        cell = [[DTAttributedTextCell alloc] initWithReuseIdentifier:cellIdentifier];
        UIView *selectView = [[UIView alloc] initWithFrame:cell.bounds];
        [selectView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
        cell.selectedBackgroundView = selectView;
        [chatCache setObject:cell forKey:key];
    }
    NSArray *aryInfo = (tableView==_chatView) ? _tcpSocket.aryChat : _tcpSocket.aryPriChat;
    if(aryInfo.count>indexPath.row)
    {
        [self configureCell:cell forIndexPath:indexPath array:aryInfo];
    }
    [cell.attributedTextContextView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    return cell;
}

//设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _noticeView)
    {
        ZLCoreTextCell *cell = [self tableView:tableView preparedCellForZLIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    DTAttributedTextCell *cell = [self tableView:tableView chatPreparedCellForIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(DTAttributedTextCell *)cell forIndexPath:(NSIndexPath *)indexPath array:(NSArray *)aryInfo
{
    NSString *html = ((SVRMesssage *)[aryInfo objectAtIndex:indexPath.row]).text;
    [cell setHTMLString:html];
    cell.attributedTextContextView.shouldDrawImages = YES;
    cell.attributedTextContextView.delegate = self;
}

- (CGFloat)cellHeight:(SVRMesssage *)message
{
    return 0;
//    NSString *messageID = message.messageID;
//    CGFloat height = [[_cellHeights objectForKey:messageID] floatValue];
//    if (height == 0)
//    {
//        DTAttributedTextContentView *text = [DTAttributedTextContentView new];
//        text.attributedString = [[NSAttributedString alloc] initWithHTMLData:[message.text dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];;
//        height = [text suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-20].height;
//        [_cellHeights setObject:@(height+10) forKey:messageID];
//    }
//    return height;
}

//设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cacheKey;
    if(tableView == _noticeView && _tcpSocket.aryNotice.count > indexPath.section)
    {
        ZLCoreTextCell *coreText = [self tableView:tableView preparedCellForZLIndexPath:indexPath];
        return [coreText.lblInfo.attributedTextContentView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-20].height;
    }
    else
    {
        DTAttributedTextCell *cell = [self tableView:tableView chatPreparedCellForIndexPath:indexPath];
        return [cell requiredRowHeightInTableView:tableView];
    }
    
    return 60;
}

//选择某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (ZLCoreTextCell *)tableView:(UITableView *)tableView preparedCellForZLIndexPath:(NSIndexPath *)indexPath
{
    NSString *cacheKey = [NSString stringWithFormat:@"%zi-%zi",indexPath.row,indexPath.section];
    NSString *strInfo;
    ZLCoreTextCell *cell = nil;
    NSString *strIdentifier = @"kNoticeIdentifier";
    cell = [_cellCache objectForKey:cacheKey];
    if (cell==nil)
    {
        cell = [[ZLCoreTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier];
        [_cellCache setObject:cell forKey:cacheKey];
    }
    if(_tcpSocket.aryNotice.count > indexPath.section)
    {
        char cString[150] = {0};
        sprintf(cString,"noticeView-%zi",indexPath.section);
        cacheKey = [[NSString alloc] initWithUTF8String:cString];
        NoticeModel *notice = [_tcpSocket.aryNotice objectAtIndex:indexPath.section];
        strInfo = notice.strContent;
        strIdentifier = @"kNoticeIdentifier";
    }
    else
    {
        return cell;
    }
    cell.lblInfo.attributedTextContentView.delegate = self;
    cell.lblInfo.attributedTextContentView.shouldDrawImages = YES;
    cell.lblInfo.attributedTextContentView.edgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    NSData *data = [strInfo dataUsingEncoding:NSUTF8StringEncoding];
    cell.lblInfo.attributedString = [[NSAttributedString alloc] initWithHTMLData:data options:nil documentAttributes:nil];
    CGFloat fHeight = [cell.lblInfo.attributedTextContentView
                       suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-20].height+10;
    UIView *selectView = [[UIView alloc] initWithFrame:cell.bounds];
    [selectView setBackgroundColor:[UIColor clearColor]];
    cell.selectedBackgroundView = selectView;
    return cell;
}

- (void)showImageInfo:(UITapGestureRecognizer *)tapGest
{
    UIImageView *imageView = (UIImageView *)tapGest.view;
    if (imageView.image)
    {
        NSMutableArray *aryIndex = [NSMutableArray array];
        Photo *_photo = [[Photo alloc] init];
        _photo.nId = 0;
        _photo.imgName = imageView.image;
        [aryIndex addObject:_photo];
        PhotoViewController *photoControl = [[PhotoViewController alloc] initWithArray:aryIndex current:0];
        [photoControl show];
    }
}

#pragma mark DTCoreText Delegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView sd_setImageWithURL:attachment.contentURL];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(showImageInfo:)]];
        return imageView;
    }
    else if([attachment isKindOfClass:[DTObjectTextAttachment class]])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        NSString *strName = [attachment.attributes objectForKey:@"value"];
        NSURL *url1 = [[NSBundle mainBundle] URLForResource:strName withExtension:@"gif"];
        [imageView sd_setImageWithURL:url1];
        return imageView;
    }
    return nil;
}

#pragma mark Custom Views on Text
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame
{
    //超链接操作
    NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
    NSURL *URL = [attributes objectForKey:DTLinkAttribute];
    NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = URL;
    button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
    button.GUID = identifier;
    [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark 点击超链接
- (void)linkPushed:(DTLinkButton *)sender
{
    DLog(@"路径:%@",sender.URL.absoluteString);
    if([sender.URL.absoluteString rangeOfString:@"sqchatid://"].location != NSNotFound)
    {
        NSString *strNumber = [sender.URL.absoluteString stringByReplacingOccurrencesOfString:@"sqchatid://" withString:@""];
        toUser = [strNumber intValue];
        if (_tcpSocket.getRoomInfo != nil)
        {
            RoomUser *rUser = [_tcpSocket.getRoomInfo findUser:toUser];
            [_inputView setChatInfo:rUser];
        }
    }
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
    if (scrollView == _scrollView)
    {
        //拖动前的起始坐标
        startContentOffsetX = scrollView.contentOffset.x;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView == _scrollView) {
        //将要停止前的坐标
        willEndContentOffsetX = scrollView.contentOffset.x;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView == _scrollView)
    {
        if (willEndContentOffsetX == 0 && startContentOffsetX ==0 )
        {
            return ;
        }
        [self setBluePointX:scrollView.contentOffset.x];
        int temp = floor((scrollView.contentOffset.x - kScreenWidth/2.0)/kScreenWidth +1);//判断是否翻页
        if (temp != _currentPage)
        {
            if (temp > _currentPage)
            {
                if (_tag<4)
                {
                    _tag ++;
                    [_group setBtnSelect:_tag];
                }
            }
            else
            {
                if (_tag>1)
                {
                    _tag--;
                    [_group setBtnSelect:_tag];
                }
            }
            updateCount++;
            _currentPage = temp;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == _scrollView)
    {
        if (updateCount ==1)//正常
        {
            
        }
        else if(updateCount==0 && _currentPage ==0)
        {

        }
        else//加速
        {}
        updateCount = 0;
        startContentOffsetX = 0;
        willEndContentOffsetX = 0;
    }
}


- (void)setBluePointX:(CGFloat)fPointX
{
    CGFloat fx = kScreenWidth/4/2-fTempWidth/2+fPointX/kScreenWidth * kScreenWidth/4;
    [_lblBlue setFrame:Rect(fx,_group.y+_group.height-2,fTempWidth,2)];
}






#pragma mark 创建alert
- (void)createAlertController
{
    __weak RoomViewController *__self =self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"请输入密码" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"密码";
     }];
    UIAlertAction *canAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           //如果不再登录房间，取消notification
                           [__self.view hideToastActivity];
                       });
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
    {
       UITextField *login = alert.textFields.firstObject;
       if ([login.text length]==0){
           dispatch_async(dispatch_get_main_queue(),
              ^{
                  [__self.view hideToastActivity];
                  [__self.view makeToast:@"密码不能为空"];
                  [__self createAlertController];
              });
       }
       else
       {
           [__self.tcpSocket connectRoomAndPwd:login.text];
       }
   }];
    [alert addAction:canAction];
    [alert addAction:okAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [__self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)joinRoomTimeOut
{
    [_tcpSocket addChatInfo:@"[系统消息]加入房间超时"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_CHAT_VC object:nil];
}

- (void)showInputView
{
    if ([UserInfo sharedUserInfo].nType != 1 && ![_room.nvcbid isEqualToString:@"10000"] && ![_room.nvcbid isEqualToString:@"10001"]) {
        
    }
    else{
        
    }
}

- (void)createLoginAlert
{
    
}

- (void)enterLoginView
{
//    UINavigationController *navControl = [[UINavigationController alloc] init];
}

#pragma mark RoomDwonDelegate
- (void)clickRoom:(UIButton *)button index:(NSInteger)nIndex
{
    if(!_tcpSocket.rInfo){return;}
    switch (nIndex) {
        case 0://显示聊天
        {
            _inputView.hidden = !_inputView.hidden;
        }
        break;
        case 1://显示成员
        {
            _listView.bShow = YES;
        }
        break;
        case 2://显示礼物
        {
            [_giftView updateGoid];
            [UIView animateWithDuration:0.5 animations:^{
                [_giftView setFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
            } completion:^(BOOL finished) {}];
        }
        break;
        case 3://送玫瑰
        {
            [self sendRose];
        }
        break;
    }
}

#pragma mark ChatViewDelegate
- (void)sendMessage:(UITextView *)textView userid:(int)nUser
{
    NSString *strInfo = [textView.textStorage getPlainString];
    toUser = nUser;
    [self sendChatMessage:strInfo];
}

- (void)sendChatMessage:(NSString *)strInfo
{
    if(!_tcpSocket.rInfo)
    {
        [self.view makeToast:@"加入房间成功，才可以互动"];
        return ;
    }
    if([UserInfo sharedUserInfo].nType != 1 && ![_room.nvcbid isEqualToString:@"10000"] && ![_room.nvcbid isEqualToString:@"10001"])
    {
        [self.view makeToast:@"游客不能发送信息"];
        return ;
    }
    if (strInfo.length == 0)
    {
        [self.view makeToast:@"不能发送空的内容"];
        return ;
    }
    __block NSString *__strContent = strInfo;
    __block int __nUserId = toUser;
    __weak RoomViewController *__self = self;
    dispatch_async(room_gcd,
    ^{
           [__self.tcpSocket sendChatInfo:__strContent  toid:__nUserId];
    });
    [_inputView.textView setText:@""];
    [_inputView setHidden:YES];
    [self switchBtn:1];
}

#pragma mark 送礼物
- (void)sendGift:(int)giftId num:(int)giftNum
{
    [_tcpSocket sendGift:giftId num:giftNum];
    [_giftView setGestureHidden];
}

#pragma mark 用户列表选择某一列
- (void)selectUser:(NSInteger)nIndex
{
    if(_tcpSocket.aryUser.count>nIndex)
    {
        RoomUser *_user = [[_tcpSocket aryUser] objectAtIndex:nIndex];
        if(_user.m_nUserId != [UserInfo sharedUserInfo].nUserId)
        {
            _listView.bShow = NO;
            toUser = _user.m_nUserId;
            [_inputView setChatInfo:_user];
        }
    }
}

@end

