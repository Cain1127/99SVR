//
//  RoomViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 12/10/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "RoomViewController.h"
#import "LSTcpSocket.h"
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
UITextViewDelegate,DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate,EmojiViewDelegate>
{
    NSCache *cellCache;
    NSCache *imageCache;
    //聊天view
    UIView *downView;
    UIView *bodyView;
    ChatButton *_btnName;
    UIButton *_btnSend;
    UITextView *_textChat;
    UILabel *_lblBlue;
    EmojiView *_emojiView;
    CGFloat deltaY;
    float duration;    // 动画持续时间
    CGFloat originalY; // TextField原来的纵坐标
    int toUser;
    UIButton *_btnGift;
    UIView  *_topHUD;
    UILabel *_lblName;
    UIView *_downHUD;
    UIButton *_btnVideo;
    NSInteger _nTag;
    
    
}

@property (nonatomic,strong) NSMutableDictionary *dictIcon;
@property (nonatomic,strong) LivePlayViewController *ffPlay;
@property (nonatomic,strong) UIButton *btnRight;
@property (nonatomic,assign) CGFloat fChatHeight;
@property (nonatomic,strong) RoomTitleView *group;
@property (nonatomic,strong) UITableView *priChatView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITableView *noticeView;
@property (nonatomic,strong) UITableView *chatView;
@property (assign,nonatomic) NSInteger keyboardPresentFlag;

@end

@implementation RoomViewController

- (void)dealloc
{
    DLog(@"room view");
    _ffPlay = nil;
    
    [_dictIcon removeAllObjects];
    
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
}

- (void)navBack
{
    [_ffPlay stop];
    [self dismissViewControllerAnimated:YES completion:
     ^{
         
     }];
    [[LSTcpSocket sharedLSTcpSocket] exit_Room:YES];
}

- (void)colletRoom
{
    NSString *strId = [[LSTcpSocket sharedLSTcpSocket] getRoomId];
    if([UserInfo sharedUserInfo].aryCollet.count>=1)
    {
        RoomGroup *group = [[UserInfo sharedUserInfo].aryCollet objectAtIndex:0];
        for (RoomHttp *room in group.aryRoomHttp)
        {
            if([strId isEqualToString:room.nvcbid])
            {
                __weak RoomViewController *__self = self;
                dispatch_async(dispatch_get_main_queue(),
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

- (void)colletCurrentRoom
{
    _btnRight.selected = !_btnRight.selected;
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
        dispatch_async(dispatch_get_main_queue(),
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
        _topHUD.alpha = 0.8;
        _downHUD.alpha = 0.8;
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
    //设置初始化_ffPlay
    _ffPlay = [[LivePlayViewController alloc] init];
    [self.view insertSubview:_ffPlay.view atIndex:1];
    _ffPlay.view.frame = Rect(0, 20, kScreenWidth, kScreenHeight);
    
    _topHUD = [[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,64)];
    _topHUD.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_topHUD];
    _topHUD.alpha = 0.5;
    
    _lblName = [[UILabel alloc] initWithFrame:Rect(50,35,kScreenWidth-100,20)];
    [_lblName setTextAlignment:NSTextAlignmentCenter];
    [_lblName setText:[NSString stringWithFormat:@"房间名:%@ ID:%@",[[LSTcpSocket sharedLSTcpSocket] getRoomName],
                       [[LSTcpSocket sharedLSTcpSocket] getRoomId]]];
    
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
    
    NSArray *aryTitle = @[@"聊天区",@"对我说",@"公告"];
    _group = [[RoomTitleView alloc] initWithFrame:Rect(0,kVideoImageHeight,kScreenWidth, 44) ary:aryTitle];
    [self.view addSubview:_group];
    
    bodyView = [[UIView alloc] initWithFrame:Rect(0, _group.y+_group.height, kScreenWidth,kScreenHeight-_group.y-_group.height-50)];
    [self.view addSubview:bodyView];
    
    _chatView = [[UITableView alloc] initWithFrame:bodyView.bounds];
    [bodyView addSubview:_chatView];
    _chatView.delegate = self;
    _chatView.dataSource = self;
    [_chatView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _chatView.tag = 1;
    
    _noticeView = [[UITableView alloc] initWithFrame:bodyView.bounds];
    [bodyView addSubview:_noticeView];
    _noticeView.delegate = self;
    _noticeView.dataSource = self;
    [_noticeView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _noticeView.hidden = YES;
    _noticeView.tag = 3;
    
    _priChatView = [[UITableView alloc] initWithFrame:bodyView.bounds];
    [bodyView addSubview:_priChatView];
    _priChatView.scrollEnabled = YES;
    _priChatView.hidden = YES;
    _priChatView.tag = 2;
    _priChatView.delegate = self;
    _priChatView.dataSource = self;
    [_priChatView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _btnGift = [UIButton buttonWithType:UIButtonTypeCustom];
    [bodyView addSubview:_btnGift];
    [_btnGift setFrame:Rect(kScreenWidth-49,bodyView.height-50, 39, 39)];
    [_btnGift setImage:[UIImage imageNamed:@"meigui_n"] forState:UIControlStateNormal];
    [_btnGift setImage:[UIImage imageNamed:@"meigui_h"] forState:UIControlStateHighlighted];
    [_btnGift addTarget:self action:@selector(sendRose) forControlEvents:UIControlEventTouchUpInside];
    
    _downHUD = [[UIView alloc] initWithFrame:Rect(0, kVideoImageHeight-44, kScreenWidth, 44)];
    UIImageView *downImg = [[UIImageView alloc] initWithFrame:_downHUD.bounds];
    [downImg setImage:[UIImage imageNamed:@"dvr_conttrol_bg"]];
    [_downHUD addSubview:downImg];
    [downImg setTag:1];
    [self.view addSubview:_downHUD];
    
    _btnVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    [_downHUD addSubview:_btnVideo];
    _btnVideo.frame = Rect(10, 0, 44, 44);
    [_btnVideo setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
    [_btnVideo setImage:[UIImage imageNamed:@"video_h"] forState:UIControlStateSelected];
    [_btnVideo addTarget:self action:@selector(connectUnVideo:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)connectUnVideo:(UIButton *)sender
{
    [_ffPlay stop];
    [_ffPlay setDefaultImg];
    NSString *strContent = sender.selected ? @"" : @"?only-audio=1";
    sender.selected = !sender.selected;
    [_ffPlay startPlayWithURLString:strContent];
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
    if([UserInfo sharedUserInfo].nType != 1)
    {
        [self.view makeToast:@"游客不能送花"];
        return ;
    }
    __block int __nUserId = toUser;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        LSTcpSocket *socket = [LSTcpSocket sharedLSTcpSocket];
        [socket sendChatInfo:@"[$999$]"  toid:__nUserId];
    });
}

- (void)sendChatMessage
{
    if([UserInfo sharedUserInfo].nType != 1)
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
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
        LSTcpSocket *socket = [LSTcpSocket sharedLSTcpSocket];
        [socket sendChatInfo:__strContent  toid:__nUserId];
    });
    [_textChat setText:@""];
    [self closeKeyBoard];
}

- (void)initUIBody
{
    [self.view setBackgroundColor:UIColorFromRGB(0x000000)];
    //创建成员列表的tableView
    _tableView = [[UITableView alloc] initWithFrame:bodyView.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [bodyView addSubview:_tableView];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.hidden = YES;
    _tableView.tag = 4;
    
    //蓝条
    _lblBlue = [[UILabel alloc] initWithFrame:Rect(0, _group.y+_group.height-2, kScreenWidth/3, 2)];
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
        DLog(@"show user Info");
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
    __weak RoomViewController *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
        [__self startPlay];
    });
}

- (void)startPlay
{
    int nMicId = [LSTcpSocket sharedLSTcpSocket].nMId;
    if (_ffPlay.videoPlayState == VideoPlayStatePlaying || _ffPlay.videoPlayState == VideoPlayStatePause)
    {
        DLog(@"重新加载");
    }
    else
    {
        if (nMicId>0 && [self isViewLoaded])
        {
            [_ffPlay startPlayWithURLString:[NSString stringWithFormat:@"rtmp://pull.99ducaijing.cn/live/%d.flv",nMicId]];
        }
        else
        {
            DLog(@"没加载完？");
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellCache = [[NSCache alloc] init];
    imageCache = [[NSCache alloc] init];
    [self initUIHead];
    [self initUIBody];
    [self createEmojiKeyboard];
    _dictIcon = [NSMutableDictionary dictionary];
    __weak RoomViewController *__self = self;
    [_group addEvent:^(id sender)
     {
         [__self groupEventInfo:(UIButton *)sender];
     }];
    UITapGestureRecognizer* singleRecogn;
    
    singleRecogn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTopHUD)];
    singleRecogn.numberOfTapsRequired = 1; // 双击
    [_ffPlay.view setUserInteractionEnabled:YES];
    [_ffPlay.view addGestureRecognizer:singleRecogn];
    
    [self performSelector:@selector(hiddenTopHud) withObject:nil afterDelay:3.0];
    dispatch_async(dispatch_get_global_queue(0,0),
    ^{
       [__self colletRoom];
    });
    _nTag = 1;
    [self switchBtn:1];
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = nil;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"swipe left");
        if (_nTag<=2)
        {
            [self switchBtn:(int)(_nTag+1)];
        }
    }
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight)
    {
        
        NSLog(@"swipe right");
        if (_nTag>1)
        {
            [self switchBtn:(int)(_nTag-1)];
        }
    }
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
    if (!_group.hidden)//NO状态表示当前竖屏，需要转换成横屏
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
    }
    else
    {
        [self setHorizontal];
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
    _btnRight.frame = Rect(nWidth-50, 10, 44, 44);
    
    _downHUD.frame = Rect(0, nHeight-44, nWidth, 44);
    [[_downHUD viewWithTag:1] setFrame:_downHUD.bounds];
    
    _group.hidden = YES;
    bodyView.hidden = YES;
    downView.hidden = YES;
    _lblBlue.hidden = YES;
    _btnGift.hidden = YES;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark 竖屏
- (void)verticalViewControl
{
    [self closeKeyBoard];
    _topHUD.frame = Rect(0, 0, kScreenWidth, 64);
    [_topHUD viewWithTag:1].frame = Rect(0, 0, kScreenWidth, 64);
    _lblName.frame = Rect(50, 35, kScreenWidth-100, 15);
    [_topHUD viewWithTag:2].frame = Rect(0, 20, 44, 44);
    _btnRight.frame = Rect(kScreenWidth-50, 20, 44, 44);
    _downHUD.frame = Rect(0, kVideoImageHeight-44, kScreenWidth, 44);
    _ffPlay.view.frame = Rect(0, 20, kScreenWidth, kScreenHeight);
    _ffPlay.glView.frame = Rect(0,1,kScreenWidth, kVideoImageHeight);
    _group.hidden = NO;
    bodyView.hidden = NO;
    downView.hidden = NO;
    _lblBlue.hidden = NO;
    _btnGift.hidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden//for iOS7.0
{
    if (!_group.hidden)
    {
        return NO;
    }
    return YES;
}

#pragma mark ViewLayout
//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    if(_group.hidden)
//    {
//        [self verticalViewControl];
//    }
//    else
//    {
//        [self horizontalViewControl];
//    }
//}

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
    UIButton *btnSender = [_group viewWithTag:nTag];
    if(btnSender)
    {
        [self groupEventInfo:btnSender];
    }
}



- (void)groupEventInfo:(UIButton *)sender
{
    [UIViewController attemptRotationToDeviceOrientation];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.5];
    
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
    _lblBlue.frame = Rect(sender.x, _group.y+_group.height-2, kScreenWidth/3, 2);
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
        _noticeView.hidden = YES;
        _chatView.hidden = YES;
        _priChatView.hidden = YES;
        if (sender.tag == 1)
        {
            _chatView.hidden = NO;
        }
        else if(sender.tag == 2)
        {
            _priChatView.hidden = NO;
        }
        else if(sender.tag == 3)
        {
            _noticeView.hidden = NO;
        }
    }
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [cellCache removeAllObjects];
    if ([NSThread isMainThread])
    {
        [[LSTcpSocket sharedLSTcpSocket].aryChat removeAllObjects];
        [[LSTcpSocket sharedLSTcpSocket].aryNotice removeAllObjects];
        [_chatView reloadData];
        [_priChatView reloadData];
        [_noticeView reloadData];
    }
    else
    {
        __weak RoomViewController *__self = self;
        [[LSTcpSocket sharedLSTcpSocket].aryChat removeAllObjects];
        [[LSTcpSocket sharedLSTcpSocket].aryNotice removeAllObjects];
        dispatch_async(dispatch_get_main_queue(),
        ^{
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
- (void) keyboardWasHidden:(NSNotification *) notif
{
    CGRect frame = self.view.frame;
    frame.origin.y = originalY;
}

- (void)startPlayThread
{
    __weak RoomViewController *__self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        [__self startPlay];
    });
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPlayThread) name:MESSAGE_ROOM_MIC_UPDATE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomChatPriMsg:) name:MESSAGE_ROOM_TO_ME_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomChatMSg:) name:MESSAGE_ROOM_CHAT_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomListNotice:) name:MESSAGE_ROOM_NOTICE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomUserList:) name:MESSAGE_ROOM_ALL_USER_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:)
                                                  name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:)
                                                 name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comeBack) name:MESSAGE_COME_BACK_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomBeExit:) name:MESSAGE_ROOM_BE_CLOSE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(room_kickout) name:MESSAGE_ROOM_KICKOUT_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlay) name:MESSAGE_ROOM_MIC_CLOSE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeNotification) name:MESSAGE_REMOVE_NOTIFY_VC object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBack) name:MESSAGE_ENTER_BACK_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNotification) name:MESSAGE_ADD_NOTIFY_VC object:nil];
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
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__ffPlay setDefaultImg];
    });
}

#pragma mark被人踢出房间 触发的notification
- (void)room_kickout
{
    __weak RoomViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [__self.view makeToast:@"您被人踢出当前房间" duration:0.5 position:@"center"];
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
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__ffPlay setDefaultImg];
       [__self.chatView reloadData];
       [__self.noticeView reloadData];
       [__self.tableView reloadData];
       [__self.priChatView reloadData];
    });
    [[LSTcpSocket sharedLSTcpSocket] reConnectRoomInfo];
}

#pragma mark 进入后台
- (void)enterBack
{
    [[LSTcpSocket sharedLSTcpSocket] enterBackGroud];
    __weak RoomViewController *__self =self;
    dispatch_async(dispatch_get_main_queue(),
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
    dispatch_async(dispatch_get_main_queue(),
   ^{
       [__self.tableView reloadData];
   });
}

#pragma mark 公告刷新
- (void)roomListNotice:(NSNotification *)notify
{
    __weak RoomViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [__self.noticeView reloadDataWithCompletion:
         ^{
             NSInteger numberOfRows = [__self.noticeView numberOfRowsInSection:0];
             if (numberOfRows > 0)
             {
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfRows-1 inSection:0];
                 [__self.noticeView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
    dispatch_sync(dispatch_get_main_queue(),
    ^{
        [__self.priChatView reloadDataWithCompletion:
         ^{
             NSInteger numberOfRows = [__self.priChatView numberOfRowsInSection:0];
             if (numberOfRows > 0)
             {
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfRows-1 inSection:0];
                 [__self.priChatView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
             }
         }];
    });
}

- (void)roomChatMSg:(NSNotification *)notify
{
    __weak RoomViewController *__self = self;
    dispatch_sync(dispatch_get_main_queue(),
    ^{
        [__self.chatView reloadDataWithCompletion:
         ^{
             NSInteger numberOfRows = [__self.chatView numberOfRowsInSection:0];
             if (numberOfRows > 0)
             {
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfRows-1 inSection:0];
                 [__self.chatView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
             }
         }];
    });
}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//长度
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _tableView)
    {
        return [[LSTcpSocket sharedLSTcpSocket] aryUser].count;
    }
    else if(tableView == _noticeView)
    {
        return [LSTcpSocket sharedLSTcpSocket].aryNotice.count;
    }
    else if(tableView == _chatView)
    {
        return [LSTcpSocket sharedLSTcpSocket].aryChat.count;
    }
    else if(tableView == _priChatView)
    {
        NSString *query = [NSString stringWithFormat:@"value=\"forme--%d\"",[UserInfo sharedUserInfo].nUserId];
        NSPredicate *pred = TABLEVIEW_ARRAY_PREDICATE(query);
        return [[LSTcpSocket sharedLSTcpSocket].aryChat filteredArrayUsingPredicate:pred].count;
    }
    return 0;
}

//设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView!=_tableView)
    {
//        DTAttributedTextCell *cell = (DTAttributedTextCell*)[self tableView:tableView preparedCellForIndexPath:indexPath];
        ZLCoreTextCell *cell = [self tableView:tableView preparedCellForZLIndexPath:indexPath];
        return cell;
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
    
    RoomUser *user = [[[LSTcpSocket sharedLSTcpSocket] aryUser] objectAtIndex:indexPath.row];
    [cell setRoomUser:user];
    return cell;
}

//设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView!=_tableView)
    {
//        DTAttributedTextCell *cell = (DTAttributedTextCell *)[self tableView:tableView preparedCellForIndexPath:indexPath];
        ZLCoreTextCell *cell = (ZLCoreTextCell *)[self tableView:tableView preparedCellForZLIndexPath:indexPath];
        return [cell.attributedTextContextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-20].height+10;
    }
    return 44;
}



//设置DTAttributedTextCell
- (DTAttributedTextCell *)tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    NSString *key = nil;
    if (tableView == _noticeView)
    {
        key =[NSString stringWithFormat:@"noticeView-%zi-%zi", indexPath.section, indexPath.row];
    }
    else if(tableView == _chatView)
    {
        key =[NSString stringWithFormat:@"chatView-%zi-%zi", indexPath.section, indexPath.row];
    }
    else if(tableView == _priChatView)
    {
        key = [NSString stringWithFormat:@"priChat--%zi-%zi",indexPath.section,indexPath.row];
    }
    if (!cellCache)
    {
        cellCache = [[NSCache alloc] init];
    }
    DTAttributedTextCell *cell = [cellCache objectForKey:key];
    if (!cell)
    {
        cell = [[DTAttributedTextCell alloc] initWithReuseIdentifier:cellIdentifier];
        [cellCache setObject:cell forKey:key];
    }
    NSString *strInfo = nil;
    if (tableView == _chatView && [LSTcpSocket sharedLSTcpSocket].aryChat.count>indexPath.row)
    {
        strInfo = [[LSTcpSocket sharedLSTcpSocket].aryChat objectAtIndex:indexPath.row];
    }
    else if(tableView == _noticeView && [LSTcpSocket sharedLSTcpSocket].aryNotice.count > indexPath.row)
    {
        strInfo = [[LSTcpSocket sharedLSTcpSocket].aryNotice objectAtIndex:indexPath.row];
    }
    else if(tableView == _priChatView)
    {
        NSString *query = [NSString stringWithFormat:@"value=\"forme--%d\"",[UserInfo sharedUserInfo].nUserId];
        NSPredicate *pred = TABLEVIEW_ARRAY_PREDICATE(query);
        NSArray *aryCount = [[LSTcpSocket sharedLSTcpSocket].aryChat filteredArrayUsingPredicate:pred];
        if (aryCount.count>indexPath.row)
        {
            strInfo = [aryCount objectAtIndex:indexPath.row];
        }
    }
    else
    {
        return cell;
    }
    
    [cell setHTMLString:strInfo];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.attributedTextContextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-20];
    cell.attributedTextContextView.shouldDrawImages = YES;
    cell.attributedTextContextView.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    cell.attributedTextContextView.delegate = self;
    return cell;
}

//选择某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self closeKeyBoard];
    if (tableView == _tableView)
    {
        RoomUser *_user = [[[LSTcpSocket sharedLSTcpSocket] aryUser] objectAtIndex:indexPath.row];
        toUser = _user.m_nUserId;
        [_btnName setTitle:[NSString stringWithFormat:@"@%@",_user.m_strUserAlias] forState:UIControlStateNormal];
        [_btnName setImage:[UIImage imageNamed:@"chat_s"] forState:UIControlStateNormal];
        
        [self refreshBtnName];
        _tableView.hidden = YES;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (ZLCoreTextCell *)tableView:(UITableView *)tableView preparedCellForZLIndexPath:(NSIndexPath *)indexPath
{
    NSString *cacheKey;
    NSString *strInfo;
    if(tableView == _noticeView && [LSTcpSocket sharedLSTcpSocket].aryNotice.count > indexPath.row)
    {
        cacheKey =[NSString stringWithFormat:@"noticeView-%zi", indexPath.row];
        strInfo = [[LSTcpSocket sharedLSTcpSocket].aryNotice objectAtIndex:indexPath.row];
    }
    else if(tableView == _chatView && [LSTcpSocket sharedLSTcpSocket].aryChat.count > indexPath.row)
    {
        cacheKey =[NSString stringWithFormat:@"chatView-%zi", indexPath.row];
        strInfo = [[LSTcpSocket sharedLSTcpSocket].aryChat objectAtIndex:indexPath.row];
    }
    else if(tableView == _priChatView )
    {
        cacheKey = [NSString stringWithFormat:@"priChat--%zi",indexPath.row];
        NSString *query = [NSString stringWithFormat:@"value=\"forme--%d\"",[UserInfo sharedUserInfo].nUserId];
        NSPredicate *pred = TABLEVIEW_ARRAY_PREDICATE(query);
        NSArray *aryCount = [[LSTcpSocket sharedLSTcpSocket].aryChat filteredArrayUsingPredicate:pred];
        if (aryCount.count>indexPath.row)
        {
            strInfo = [aryCount objectAtIndex:indexPath.row];
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
    ZLCoreTextCell *cell = [cellCache objectForKey:cacheKey];
    if (!cell)
    {
        cell = [[ZLCoreTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"roomviewcontroller"];
    }
    cell.attributedTextContextView.delegate = self;
    cell.attributedTextContextView.shouldDrawImages = YES;
    [cellCache setObject:cell forKey:cacheKey];
    cell.attributedTextContextView.edgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    NSData *data = [strInfo dataUsingEncoding:NSUTF8StringEncoding];
    cell.attributedTextContextView.attributedString = [[NSAttributedString alloc] initWithHTMLData:data options:nil documentAttributes:nil];
    UIView *selectView = [[UIView alloc] initWithFrame:cell.bounds];
    [selectView setBackgroundColor:[UIColor clearColor]];
    cell.selectedBackgroundView = selectView;
    return cell;
}

- (void)showImageInfo:(UITapGestureRecognizer *)tapGest
{
    UIImageView *imageView = (UIImageView *)tapGest.view;
    NSMutableArray *aryIndex = [NSMutableArray array];
//    [aryIndex addObject:imageView];
    Photo *_photo = [[Photo alloc] init];
    _photo.nId = 0;
    _photo.imgName = imageView.image;
    [aryIndex addObject:_photo];
    PhotoViewController *photoControl = [[PhotoViewController alloc] initWithArray:aryIndex current:0];
    [photoControl show];
}

#pragma mark DTCoreText Delegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView sd_setImageWithURL:attachment.contentURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
        {
//            CGFloat scale = attributedTextContentView.frame.size.width / [image size].width;
//            CGSize scaledSize = CGSizeMake([image size].width * scale, [image size].height * scale);
//            [imageCache setObject:[NSValue valueWithCGSize: scaledSize] forKey:imageURL];
        }];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
           action:@selector(showImageInfo:)]];
        return imageView;
    }
    else if([attachment isKindOfClass:[DTObjectTextAttachment class]])
    {
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        NSString *strName = [attachment.attributes objectForKey:@"value"];
        //[$3$]  [$999$] [$62$]
        if([strName intValue]==999 || [strName intValue]<=34)
        {
            [self findImage:strName imgView:imageView];
        }
        else
        {
            [self findImage:@"8" imgView:imageView];
        }
        return imageView;
    }
    return nil;
}

- (void)findImage:(NSString *)strName imgView:(UIImageView *)imageView
{
    UIImage *image = [_dictIcon objectForKey:strName];
    if (image)
    {
        [imageView setImage:image];
    }
    else
    {
        image = [UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:strName withExtension:@"gif"]];
        [_dictIcon setObject:image forKey:strName];
        [imageView setImage:image];
    }
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
    UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
    [button setImage:normalImage forState:UIControlStateNormal];
    UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
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
            if ([LSTcpSocket sharedLSTcpSocket].getRoomInfo != nil)
            {
                RoomUser *rUser = [[LSTcpSocket sharedLSTcpSocket].getRoomInfo findUser:toUser];
                [_btnName setTitle:[NSString stringWithFormat:@"@%@",rUser.m_strUserAlias] forState:UIControlStateNormal];
                [_btnName setImage:[UIImage imageNamed:@"chat_s"] forState:UIControlStateNormal];
                [self refreshBtnName];
            }
        }
    }
}

#pragma mark LazyImageView Delegate
- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size
{
//    NSURL *url = lazyImageView.url;
//    CGSize imageSize = size;
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
//    for (DTAttributedTextCell *cell in self.noticeView.visibleCells)
//    {
//        for (DTTextAttachment *oneAttachment in
//             [cell.attributedTextContextView.layoutFrame textAttachmentsWithPredicate:pred])
//        {
//            oneAttachment.originalSize = CGSizeMake(40, 40);
//            if (!CGSizeEqualToSize(imageSize, oneAttachment.displaySize))
//            {
//                oneAttachment.displaySize = CGSizeMake(40,40);
//            }
//        }
//        [cell.attributedTextContextView relayoutText];
//    }
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

@end
