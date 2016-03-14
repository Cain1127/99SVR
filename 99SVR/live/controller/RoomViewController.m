//
//  RoomViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 12/10/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "RoomViewController.h"
#import "RoomTcpSocket.h"
#import "M80AttributedLabel.h"
#import "FTCoreTextView.h"
#import "GitInfo.h"
#import "RoomCoreTextCell.h"
#import "RoomHttp.h"
#import "SDImageCache.h"
#import "NoticeModel.h"
#import "UIImageView+WebCache.h"
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

#define TABLEVIEW_ARRAY_PREDICATE(A) [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",A];



@interface RoomViewController ()<UITableViewDelegate,UITableViewDataSource,
UITextViewDelegate,DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate,EmojiViewDelegate,UIScrollViewDelegate>
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
    EmojiView *_emojiView;
    CGFloat deltaY;
    float duration;    // 动画持续时间
    CGFloat originalY; // TextField原来的纵坐标
    int toUser;
    UIImageView *_imgGift;
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
    UILabel *lblPlace;
    BOOL bFull;
    RoomHttp *_room;
    
    NSCache *cellCache;
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
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITableView *noticeView;
@property (nonatomic,strong) UITableView *chatView;
@property (assign,nonatomic) NSInteger keyboardPresentFlag;
@property (nonatomic,strong) UIScrollView *scrollView;


@property (nonatomic,strong)    NSMutableDictionary     *cellHeights;

@end

@implementation RoomViewController

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
    [_tableView removeFromSuperview];
    _tableView = nil;
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
    NSString *strId = [_tcpSocket getRoomId];
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
    [self closeKeyBoard];
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
    [_lblName setText:[NSString stringWithFormat:@"%@ %@",_room.cname,_room.nvcbid]];
    
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
    
    NSArray *aryTitle = @[@"聊天区",@"我的",@"公告"];
    _group = [[RoomTitleView alloc] initWithFrame:Rect(0,20+kVideoImageHeight,kScreenWidth, 44) ary:aryTitle];
    [self.view addSubview:_group];
    
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
    
    _priChatView = [[UITableView alloc] initWithFrame:Rect(_scrollView.width,0, _scrollView.width, _scrollView.height-50)];
    [_scrollView addSubview:_priChatView];
    _priChatView.delegate = self;
    _priChatView.dataSource = self;
    [_priChatView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _noticeView = [[UITableView alloc] initWithFrame:Rect(_scrollView.width*2, 0, _scrollView.width, _scrollView.height)];
    [_scrollView addSubview:_noticeView];
    _noticeView.delegate = self;
    _noticeView.dataSource = self;
    [_noticeView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth*3,_scrollView.height);
    _imgGift = [[UIImageView alloc] initWithFrame:Rect(kScreenWidth-49,bodyView.height-100, 39, 39)];
    [bodyView addSubview:_imgGift];
    [_imgGift setUserInteractionEnabled:YES];
    
    [_imgGift setImage:[UIImage imageNamed:@"meigui_n"]];
    [_imgGift addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragMoving:)]];
    [_imgGift addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dragEnd)]];
    
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

- (void)dragMoving:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:bodyView];
    CGFloat x;
    CGFloat y;
    if (point.x -19.5<=0)
    {
        x = 0;
    }
    else if(point.x +19.5>=bodyView.width)
    {
        x = bodyView.width - 39;
    }
    else
    {
        x = point.x;
    }
    
    if (point.y-19.5 <= 0)
    {
        y = 0;
    }
    else if(point.y+19.5>=bodyView.height-50)
    {
        y = bodyView.height-89;
    }
    else
    {
        y = point.y;
    }
    _imgGift.frame = Rect(x, y, 39, 39);
}

- (void)dragEnd
{
    [self sendRose];
}

- (void)connectUnVideo:(UIButton *)sender
{
    if (_ffPlay.playing)
    {
        [_ffPlay setOnlyAudio:sender.selected];
        sender.selected = !sender.selected;
    }
}

- (void)showEmojiView
{
    if ([_textChat isFirstResponder])
    {
        [_textChat resignFirstResponder];
    }
    _emojiView.hidden = NO;
    downView.frame = Rect(0, kScreenHeight-266,kScreenWidth, 50);
}

#pragma mark 表情键盘
- (void)createEmojiKeyboard
{
    _emojiView = [[EmojiView alloc] initWithFrame:Rect(0, kScreenHeight-216,kScreenWidth, 216)];
    [self.view addSubview:_emojiView];
    [_emojiView setBackgroundColor:UIColorFromRGB(0xffffff)];
    [_emojiView setHidden:YES];
    _emojiView.delegate = self;
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
    __block int __nUserId = toUser;
    __weak RoomViewController *__self = self;
    dispatch_async(room_gcd,
    ^{
        [__self.tcpSocket sendChatInfo:@"[$999$]"  toid:__nUserId];
    });
}

- (void)sendChatMessage
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
    NSString *strContent = [NSString stringWithFormat:@"%@",[_textChat.textStorage getPlainString]];
    if (_textChat.text.length == 0)
    {
        [self.view makeToast:@"不能发送空的内容"];
        return ;
    }
    DLog(@"发送内容:%@",strContent);
    __block NSString *__strContent = strContent;
    __block int __nUserId = toUser;
    __weak RoomViewController *__self = self;
    dispatch_async(room_gcd,
    ^{
           [__self.tcpSocket sendChatInfo:__strContent  toid:__nUserId];
    });
    [_textChat setText:@""];
    [self closeKeyBoard];
    [self switchBtn:1];
}

- (void)initUIBody
{
    //创建成员列表的tableView
    _tableView = [[UITableView alloc] initWithFrame:_scrollView.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [bodyView addSubview:_tableView];
    _tableView.bounces = NO;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.hidden = YES;
    _tableView.tag = 4;
    
    _lblBlue = [[UILabel alloc] initWithFrame:Rect(0, _group.y+_group.height-1, 0, 2)];
    [_lblBlue setBackgroundColor:UIColorFromRGB(0x629bff)];
    [self.view addSubview:_lblBlue];
    
    downView = [[UIView alloc] initWithFrame:Rect(0, kScreenHeight-50, kScreenWidth, 50)];
    [downView setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    [self.view addSubview:downView];
    
    UILabel *lblDownLine = [[UILabel alloc] initWithFrame:Rect(0, 0, kScreenWidth, 0.5)];
    [lblDownLine setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    [downView addSubview:lblDownLine];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:Rect(10, 7, kScreenWidth-20, 36)];
    [whiteView setBackgroundColor:UIColorFromRGB(0xffffff)];
    [downView addSubview:whiteView];
    
    _btnName = [[ChatButton alloc] initWithFrame:Rect(0,0,80, whiteView.height)];
    [whiteView addSubview:_btnName];
    [_btnName setTitle:@"大家" forState:UIControlStateNormal];
    [_btnName setImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
    [_btnName addTarget:self action:@selector(clickBtnName:) forControlEvents:UIControlEventTouchUpInside];
    [self refreshBtnName];
    
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(_btnName.x+_btnName.width+1,5,1, 26)];
    [lblContent setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    [whiteView addSubview:lblContent];
    
    //聊天框
    _textChat = [[UITextView alloc] initWithFrame:Rect(_btnName.x+_btnName.width+3, _btnName.y, kScreenWidth-156, 36)];
    [whiteView addSubview:_textChat];
    [_textChat setFont:XCFONT(15)];
    _textChat.delegate = self;
    [_textChat setReturnKeyType:UIReturnKeySend];
    
    lblPlace = [[UILabel alloc] initWithFrame:Rect(_textChat.x+5,_textChat.y,_textChat.width,_textChat.height)];
    lblPlace.text = @"点此和大家说点什么吧";
    lblPlace.font = XCFONT(14);
    lblPlace.enabled = NO;
    lblPlace.backgroundColor = [UIColor clearColor];
    [lblPlace setTextColor:UIColorFromRGB(0xcfcfcf)];
    [whiteView addSubview:lblPlace];
    
    //发送消息按钮
    _btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSend setImage:[UIImage imageNamed:@"Expression"] forState:UIControlStateNormal];
    [_btnSend setImage:[UIImage imageNamed:@"Expression_H"] forState:UIControlStateHighlighted];
    [_btnSend setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    [_btnSend setTitleColor:UIColorFromRGB(0x629bff) forState:UIControlStateHighlighted];
    [whiteView addSubview:_btnSend];
    _btnSend.frame = Rect(kScreenWidth-60,0, 36, 36);
    [_btnSend addTarget:self action:@selector(showEmojiView) forControlEvents:UIControlEventTouchUpInside];
}



- (void)clickBtnName:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"大家"])
    {
        [_tableView setHidden:!_tableView.hidden];
    }
    else
    {
        [sender setTitle:@"大家" forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
        toUser = 0;
        [self refreshBtnName];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_ROOM_COLLET_UPDATE_VC object:nil];
//    __weak RoomViewController *__self = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_global_queue(0,0),
//    ^{
//        [__self startNewPlay];
//    });
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
    _cellHeights = [NSMutableDictionary dictionary];
    cellCache = [[NSCache alloc] init];
    room_gcd = dispatch_queue_create("decode_gcd",0);
    _cellCache = [[NSCache alloc] init];
    cellCache.totalCostLimit = 20;
    _cellCache.totalCostLimit = 20;
    [self initUIHead];
    [self createEmojiKeyboard];
    __weak RoomViewController *__self = self;
    [_group addEvent:^(id sender)
     {
         [__self switchBtn:(int)((UIButton *)sender).tag];
     }];
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
    dispatch_async(dispatch_get_global_queue(0,0),
    ^{
        [__self colletRoom];
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
        if (_tableView.hidden==NO)
        {
            _tableView.hidden = YES;
        }
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
    [self closeKeyBoard];
    
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
    _imgGift.hidden = YES;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark 竖屏
- (void)verticalViewControl
{
//    [self closeKeyBoard];
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
    _imgGift.hidden = NO;
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

- (void)closeKeyBoard
{
    if([_textChat isFirstResponder])
    {
        [_textChat resignFirstResponder];
        [downView setFrame:Rect(0, kScreenHeight-50, kScreenWidth, 50)];
    }
    if(_emojiView.hidden==NO)
    {
        [_emojiView setHidden:YES];
        [self.view setFrame:Rect(0,0,kScreenWidth,kScreenHeight)];
        [downView setFrame:Rect(0,kScreenHeight-50,kScreenWidth,50)];
    }
}

- (void)switchBtn:(int)nTag
{
    if (_tableView.hidden==NO)
    {
        _tableView.hidden = YES;
    }
    UIButton *btnSender = [_group viewWithTag:nTag];
    if(btnSender)
    {
        int tag = (int)btnSender.tag;
        [_group setBtnSelect:tag];
        if(tag+2 == _tag || tag-2==_tag)
        {
            _tag = (int)btnSender.tag;
            [_scrollView setContentOffset:CGPointMake((tag-1)*kScreenWidth, 0)];
        }
        else
        {
            [_scrollView setContentOffset:CGPointMake((tag-1)*kScreenWidth, 0)];
            _tag = (int)btnSender.tag;
        }
        if (_tag==3)
        {
            downView.hidden = YES;
        }
        else
        {
            downView.hidden = NO;
        }
        if (_tag==1)
        {
            _imgGift.hidden = NO;
        }
        else
        {
            _imgGift.hidden = YES;
        }
    }
}

- (void)groupEventInfo:(UIButton *)sender
{
    for (id view in _group.subviews)
    {
        if([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)view;
            btn.selected = NO;
        }
    }
    
    sender.selected = YES;
    _nTag = sender.tag;
    [self setBluePointX:kScreenWidth*(_nTag-1)];
    if (sender.tag==4)
    {
        _tableView.hidden = NO;
        _chatView.hidden = YES;
        _noticeView.hidden = YES;
        _priChatView.hidden = YES;
    }
    else
    {
        _tableView.hidden = YES;
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

/**
 * 键盘frame变化时执行的通知方法
 * @note 键盘弹出，收起，改变输入法时这个方法都会执行
 */
- (void)keyboardFrameDidChange:(NSNotification *)notification
{
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat keyboardOriginY = self.view.frame.size.height - keyboardSize.height;
    deltaY = downView.frame.origin.y + downView.frame.size.height - keyboardOriginY;
    
    if (self.keyboardPresentFlag == 1)
    {
        [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
            downView.frame = CGRectOffset(downView.frame, 0, -deltaY);
        } completion:nil];
    }
}

- (void) keyboardWasShown:(NSNotification *) notification
{
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    // 获得弹出keyboard的动画时间，也可以手动赋值，如0.25f
    duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 得到keyboard在当前controller的view中的Y轴坐标
    DLog(@"keyboardSize:%f",keyboardSize.height);
    CGFloat keyboardOriginY = self.view.frame.size.height - keyboardSize.height;
    // textField下边到view顶点的距离减去keyboard的Y轴坐标就是textField要移动的距离，
    // 这里是刚好让textField完全显示出来，也可以再在deltaY的基础上再加上一定距离，如20f、30f等
    deltaY = downView.frame.origin.y + downView.frame.size.height - keyboardOriginY;
    // 当deltaY大于0时说明textField会被键盘遮住，需要上移
    // 以动画的方式改变textField的frame
    [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:
     ^{
         downView.frame = CGRectOffset(downView.frame, 0, -deltaY);
     } completion:nil];
    
    if (_emojiView.hidden == NO)
    {
        _emojiView.hidden = YES;
    }
}
- (void) keyboardWasHidden:(NSNotification *) notification
{
    CGRect frame = self.view.frame;
    frame.origin.y = originalY;
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (keyboardSize.height==282)
    {
        downView.frame = Rect(0, kScreenHeight-50, kScreenWidth, 50);
    }
    // 得到keyboard在当前controller的view中的Y轴坐标
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:)
                                                  name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:)
                                                 name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comeBack) name:MESSAGE_COME_BACK_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomBeExit:) name:MESSAGE_ROOM_BE_CLOSE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(room_kickout) name:MESSAGE_ROOM_KICKOUT_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlay) name:MESSAGE_ROOM_MIC_CLOSE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reConnectRoomInfo) name:MESSAGE_RECONNECT_TIMER_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinRoomErr:) name:MESSAGE_JOIN_ROOM_ERR_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinRoomSucsess) name:MESSAGE_JOIN_ROOM_SUC_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendRoomMediaInfo:) name:MESSAGE_TCP_SOCKET_SEND_MEDIA object:nil];
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
    
}

- (void)joinRoomErr:(NSNotification *)notify
{
    NSString *strMsg = notify.object;
    if(strMsg)
    {
        __weak RoomViewController *__self = self;
        __weak NSString *__strMsg = strMsg;
        dispatch_async(dispatch_get_main_queue(),
        ^{
            [__self.view makeToast:__strMsg];
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
        [__self.tableView reloadData];
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
       [__self.tableView reloadData];
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
    __weak RoomViewController *__self = self;
    dispatch_main_async_safe(
    ^{
       [__self.tableView reloadData];
    });
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

//长度
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _tableView)
    {
        return [_tcpSocket aryUser].count;
    }
    else if(tableView == _noticeView)
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

- (RoomCoreTextCell *)tableView:(UITableView *)tableView chatPreparedCellForIndexPath:(NSIndexPath *)indexPath
{
    RoomCoreTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newChatCoreTextCell"];
    if (!cell)
    {
         cell = [[RoomCoreTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newChatCoreTextCell"];
    }
    NSArray *aryObj = nil;
    NSString *cacheKey = nil;
    if (tableView==_chatView)
    {
        aryObj = _tcpSocket.aryChat;
        cacheKey = [NSString stringWithFormat:@"chatview_%zi",indexPath.row];
    }
    else
    {
        aryObj = _tcpSocket.aryPriChat;
        cacheKey = [NSString stringWithFormat:@"prichat_%zi",indexPath.row];
    }
    [self configuration:cell forIndexPath:indexPath ary:aryObj];
    CGFloat fHeight = [cell.textView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-20].height+10;
    [cellCache setObject:NSStringFromFloat(fHeight) forKey:cacheKey];
    [cell.textView relayoutText];
    return cell;
}

- (void)configuration:(RoomCoreTextCell *)cell forIndexPath:(NSIndexPath *)indexPath ary:(NSArray *)aryObj
{
    if (aryObj.count>indexPath.row)
    {
        NSString *bodyHtml = [aryObj objectAtIndex:indexPath.row];
        NSData *data = [bodyHtml  dataUsingEncoding:NSUTF8StringEncoding];
        NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:NULL documentAttributes:NULL];
        cell.textView.shouldDrawImages = YES;
        cell.textView.delegate = self;
        [cell.textView setAttributedString:string];
    }
}
static const NSInteger labelTag = 10;
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
    else if(tableView == _chatView || tableView == _priChatView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"message_cell"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:@"message_cell"];
            FTCoreTextView *textView = [[FTCoreTextView alloc] initWithFrame:CGRectZero];
            [cell.contentView addSubview:textView];
            [textView setTag:labelTag];
        }
        NSArray *aryInfo = (tableView == _chatView) ? _tcpSocket.aryChat : _tcpSocket.aryPriChat;
        if (aryInfo.count > indexPath.row)
        {
            SVRMesssage *message = [aryInfo objectAtIndex:[indexPath row]];
            FTCoreTextView *textView = (FTCoreTextView *)[cell viewWithTag:labelTag];
            [textView setText:message.text];
            return cell;
        }
    }
    static NSString *strIdentifier = @"ROOMVIEWTABLEVIEWIDENTIFIER";
    RoomUserCell *cell = [tableView dequeueReusableCellWithIdentifier:strIdentifier];
    if (cell == nil)
    {
        cell = [[RoomUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier];
    }
    UIView *selectView = [[UIView alloc] initWithFrame:cell.bounds];
    
    [selectView setBackgroundColor:UIColorFromRGB(0x629aff)];
    [cell setSelectedBackgroundView:selectView];
    
    RoomUser *user = [[_tcpSocket aryUser] objectAtIndex:indexPath.row];
    [cell setRoomUser:user];
    return cell;
}

//设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView!=_tableView)
    {
        NSString *cacheKey;
        if(tableView == _noticeView && _tcpSocket.aryNotice.count > indexPath.section)
        {
            cacheKey =[NSString stringWithFormat:@"noticeView-%zi", indexPath.section];
            if([_cellCache objectForKey:cacheKey])
            {
                return [[_cellCache objectForKey:cacheKey] floatValue];
            }
        }
        else
        {
            NSString *cacheKey = nil;
            if (tableView==_chatView && _tcpSocket.aryChat.count > indexPath.row)
            {
                SVRMesssage *message = [_tcpSocket.aryChat objectAtIndex:[indexPath row]];
                CGFloat height = [self textViewHeight:message];
//                DLog(@"height:%f",height);
                return height;
            }
            else if(tableView==_priChatView && _tcpSocket.aryPriChat.count > indexPath.row)
            {
                SVRMesssage *message = [_tcpSocket.aryPriChat objectAtIndex:[indexPath row]];
                return [self textViewHeight:message];
            }
            if ([cellCache objectForKey:cacheKey])
            {
                CGFloat suggestedHeight = [[cellCache objectForKey:cacheKey] floatValue];
                return suggestedHeight;
            }
        }
    }
    return 44;
}

- (CGFloat)textViewHeight:(SVRMesssage *)message
{
    NSString *messageID = message.messageID;
    CGFloat height = [[_cellHeights objectForKey:messageID] floatValue];
    if (height == 0)
    {
        FTCoreTextView *textView = [[FTCoreTextView alloc] initWithFrame:CGRectZero];
        textView.text = message.text;
        CGSize size = [textView suggestedSizeConstrainedToSize:CGSizeMake(300, MAXFLOAT)];
        height = size.height+10;
        [_cellHeights setObject:@(height)
                         forKey:messageID];
    }
    return height;
}


//选择某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self closeKeyBoard];
    if (tableView == _tableView)
    {
        [_tableView deselectRowAtIndexPath:indexPath animated:NO];
        RoomUser *_user = [[_tcpSocket aryUser] objectAtIndex:indexPath.row];
        if(_user.m_nUserId != [UserInfo sharedUserInfo].nUserId)
        {
            toUser = _user.m_nUserId;
            [_btnName setTitle:[NSString stringWithFormat:@"@%@",_user.m_strUserAlias] forState:UIControlStateNormal];
            [_btnName setImage:[UIImage imageNamed:@"chat_s"] forState:UIControlStateNormal];
            [self refreshBtnName];
            _tableView.hidden = YES;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _priChatView && _tcpSocket.aryPriChat.count>indexPath.row)
    {
        FTCoreTextView *label = (FTCoreTextView *)[cell viewWithTag:labelTag];
        [label setFrame:CGRectMake(10, 5, cell.bounds.size.width - 10 * 2, cell.bounds.size.height - 5 * 2)];
    }
    else if(tableView==_chatView && _tcpSocket.aryChat.count>indexPath.row)
    {
        FTCoreTextView *label = (FTCoreTextView *)[cell viewWithTag:labelTag];
        [label setFrame:CGRectMake(10, 5, cell.bounds.size.width - 10 * 2, cell.bounds.size.height - 5 * 2)];
    }
}

- (ZLCoreTextCell *)tableView:(UITableView *)tableView preparedCellForZLIndexPath:(NSIndexPath *)indexPath
{
    NSString *cacheKey;
    NSString *strInfo;
    ZLCoreTextCell *cell = nil;
    NSString *strIdentifier = nil;
    if(tableView == _noticeView && _tcpSocket.aryNotice.count > indexPath.section)
    {
        cacheKey =[NSString stringWithFormat:@"noticeView-%zi", indexPath.section];
        NoticeModel *notice = [_tcpSocket.aryNotice objectAtIndex:indexPath.section];
        strInfo = [[NSString alloc] initWithFormat:@"%@:<br>%@",notice.strType,notice.strContent];
        strIdentifier = @"kNoticeIdentifier";
    }
    else
    {
        if (tableView == _noticeView)
        {
            strIdentifier = @"kNoticeIdentifier";
        }
        cell = [tableView dequeueReusableCellWithIdentifier:strIdentifier];
        if (cell==nil)
        {
            cell = [[ZLCoreTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier];
        }
        return cell;
    }
    cell = [tableView dequeueReusableCellWithIdentifier:strIdentifier];
    if (cell==nil)
    {
        cell = [[ZLCoreTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier];
    }
    [cell setNeedsDisplay];
    cell.lblInfo.attributedTextContentView.delegate = self;
    cell.lblInfo.attributedTextContentView.shouldDrawImages = YES;
    cell.lblInfo.attributedTextContentView.edgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    NSData *data = [strInfo dataUsingEncoding:NSUTF8StringEncoding];
    cell.lblInfo.attributedString = [[NSAttributedString alloc] initWithHTMLData:data options:nil documentAttributes:nil];
    CGFloat fHeight = [cell.lblInfo.attributedTextContentView
                       suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-20].height+10;
    [_cellCache setObject:NSStringFromFloat(fHeight) forKey:cacheKey];
    UIView *selectView = [[UIView alloc] initWithFrame:cell.bounds];
    [selectView setBackgroundColor:[UIColor clearColor]];
    cell.selectedBackgroundView = selectView;
    [cell.lblInfo relayoutText];
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
        if (toUser==0)
        {
            [_btnName setTitle:@"大家" forState:UIControlStateNormal];
            [_btnName setImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
            [self refreshBtnName];
        }
        else
        {
            if (_tcpSocket.getRoomInfo != nil)
            {
                RoomUser *rUser = [_tcpSocket.getRoomInfo findUser:toUser];
                [_btnName setTitle:[NSString stringWithFormat:@"@%@",rUser.m_strUserAlias] forState:UIControlStateNormal];
                [_btnName setImage:[UIImage imageNamed:@"chat_s"] forState:UIControlStateNormal];
                [self refreshBtnName];
            }
        }
    }
}

#pragma mark EmojiViewDelegate
- (void)sendEmojiInfo:(NSInteger)nId
{
    [self insertEmoji:nId];
}

#pragma mark TextChat CoreText
- (void)resetTextStyle
{
    NSRange wholeRange = NSMakeRange(0, _textChat.textStorage.length);
    [_textChat.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [_textChat.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22.0f] range:wholeRange];
}

//加入表情图片
- (void)insertEmoji:(NSInteger)nId
{
    NSString *strInfo = [NSString stringWithFormat:@"%zi",nId];
    NSString *strContent = [NSString stringWithFormat:@"[$%zi$]",nId];
    EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
    emojiTextAttachment.emojiTag = strContent;
    emojiTextAttachment.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:strInfo ofType:@"gif"]];
    emojiTextAttachment.emojiSize = CGSizeMake(15,15);
    [_textChat.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]
                                          atIndex:_textChat.selectedRange.location];
    _textChat.selectedRange = NSMakeRange(_textChat.selectedRange.location + 1, _textChat.selectedRange.length);
    if ([_textChat.textStorage getPlainString].length==0)
    {
        lblPlace.text = @"点此和大家说点什么吧";
    }
    else
    {
        lblPlace.text = @"";
    }
    [self resetTextStyle];
}

#pragma mark 解析
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self sendChatMessage];
        return NO;
    }
    return YES;
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
    if (scrollView == _scrollView) {
        [self setBluePointX:scrollView.contentOffset.x];
        int temp = floor((scrollView.contentOffset.x - kScreenWidth/2.0)/kScreenWidth +1);//判断是否翻页
        if (temp != _currentPage)
        {
            if (temp > _currentPage)
            {
                if (_tag<=2)
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
            if(_tag==3)
            {
                downView.hidden = YES;
            }
            else
            {
                downView.hidden = NO;
            }
            if (_tag==1)
            {
                _imgGift.hidden = NO;
            }
            else
            {
                _imgGift.hidden = YES;
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
    }
}


- (void)setBluePointX:(CGFloat)fPointX
{
    CGFloat fx = kScreenWidth/3/2-fTempWidth/2+fPointX/kScreenWidth * kScreenWidth/3;
    [_lblBlue setFrame:Rect(fx,_group.y+_group.height-2,fTempWidth,2)];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if ([_textChat.textStorage getPlainString].length==0)
    {
        lblPlace.text = @"点此和大家说点什么吧";
    }
    else
    {
        lblPlace.text = @"";
    }
}

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
        NSString *strAry = [[UserInfo sharedUserInfo].strRoomAddr componentsSeparatedByString:@";"][0];
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
}

- (CGFloat)cellHeight:(SVRMesssage *)message
{
    NSString *messageID = message.messageID;
    CGFloat height = [[_cellHeights objectForKey:messageID] floatValue];
    if (height == 0)
    {
        M80AttributedLabel *label = [[M80AttributedLabel alloc]initWithFrame:CGRectZero];
        [self updateLabel:label
                     text:message.text];
        CGSize size = [label sizeThatFits:CGSizeMake(270, CGFLOAT_MAX)];
        height = size.height + 20 + 20;
        [_cellHeights setObject:@(height)
                         forKey:messageID];
    }
    return height;
}

- (void)updateLabel:(M80AttributedLabel *)label
               text:(NSString *)text
{
    [label setText:@""];
    NSArray *components = [text componentsSeparatedByString:@"[haha]"];
    NSUInteger count = [components count];
    for (NSUInteger i = 0; i < count; i++)
    {
        [label appendText:[components objectAtIndex:i]];
        if (i != count - 1)
        {
            [label appendImage:[UIImage imageNamed:@"haha"]
                       maxSize:CGSizeMake(13, 13)
                        margin:UIEdgeInsetsZero
                     alignment:M80ImageAlignmentCenter];
        }
    }
}

@end

