//
//  FSFFPLAYViewController.m
//  TestPlayWithFFMPEGAndSDL
//
//  Created by  on 12-12-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LivePlayViewController.h"
#import "UIImageView+WebCache.h"
#import "RoomViewController.h"
#import "UIAlertView+Block.h"
#import "ZLLogonServerSing.h"
#import "OpenAL.h"
#import "SVRMediaClient.h"
#import "RoomHttp.h"
#import "Toast+UIView.h"
#include <sys/time.h>
#import "SDWebImageCompat.h"
#import <AVFoundation/AVAudioSession.h>
#import "ZLShareViewController.h"
#import "LoginViewController.h"
#import "UIAlertView+Block.h"

@interface LivePlayViewController()<SVRMediaClientDelegate>
{
    UITapGestureRecognizer *tapGesture;
    int nSourceWidth;
    int nSourceHeight;
    UIAlertView *myAlert;
    BOOL _pictureValid;
    NSTimer *_timer;
    dispatch_queue_t videoQueue;
    dispatch_queue_t audioQueue;
    BOOL paused;
    BOOL bFirst;
    UILabel *lblText;
    int _roomid;
    int nReceiveMemory;
    UIView *sunView;
    UIView *_downHUD;
    UIView *_TopHUD;
    int _videoWidth;
    int _videoHeight;
    BOOL bCoding;
    
    OpenAL *_openAL;
}
@property (nonatomic,strong) NSMutableArray *aryVideo;
@property (nonatomic) BOOL backGroud;
@property (nonatomic) BOOL bVideo;
@property (nonatomic,copy) UIImage *currentImage;
@property (nonatomic,strong) UIImageView *smallView;
@property (nonatomic,copy) NSString *strPath;
@property (nonatomic,strong) UIButton *btnVideo;
@property (nonatomic,strong) UIButton *btnFull;
@property (nonatomic,strong) UIButton *btnShare;
@property (nonatomic,strong) UIButton *btnCollet;
@property (nonatomic,copy) NSString *roomName;

@end

@implementation LivePlayViewController

@synthesize bFull;

- (void)addNotify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBackGroudMode:) name:MESSAGE_ENTER_BACK_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectMedia:) name:MESSAGE_MEDIA_DISCONNECT_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCollet:) name:MESSAGE_COLLET_RESP_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadVideoList:) name:MESSAGE_ROOM_COLLET_UPDATE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinSuc:) name:MESSAGE_JOIN_ROOM_SUC_VC object:nil];
}

- (void)setRoomId:(int)roomId
{
    _roomid = roomId;
    [kHTTPSingle RequestCollection];
    [self addNotify];
    
}

#pragma mark 加入房间成功
- (void)joinSuc:(NSNotification *)notify{
    
    int  collect = [(NSString *)[notify.object valueForKey:@"collet"] intValue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _roomIsCollet = collect;
        _btnCollet.selected = _roomIsCollet==1? YES:NO;
    });
}

- (void)loadVideoList:(NSNotification *)notify
{
    NSDictionary *dict = notify.object;
    @WeakObj(self)
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGE_ROOM_COLLET_UPDATE_VC object:nil];
    if([dict isKindOfClass:[NSDictionary class]])
    {
        int nStatus = [dict[@"code"] intValue];
        if(nStatus==1)
        {
            NSArray *aryCollet = dict[@"data"];
            if (aryCollet.count==0)
            {
                for (RoomHttp *_roomTemp in aryCollet)
                {
                    if ([_roomTemp.roomid intValue]==_roomid)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            selfWeak.btnCollet.selected = YES;
                        });
                        break;
                    }
                }
            }
        }
    }
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showTopHUD];
}

- (void)hiddenTopHud
{
    __weak UIView *__downHUD = _downHUD;
    __weak UIView *__topHUD = _TopHUD;
    @WeakObj(self)
    dispatch_main_async_safe(
    ^{
         __topHUD.hidden = YES;
         __downHUD.alpha = 0;
        if (selfWeak.roomHiddenHUD)
        {
            selfWeak.roomHiddenHUD(YES);
        }
    });
}

- (void)showTopHUD
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if(_downHUD.alpha==0)
    {
        _downHUD.alpha = 1;
        if (bFull)
        {
            _TopHUD.hidden = NO;
        }
        else
        {
            if (_roomHiddenHUD)
            {
                _roomHiddenHUD(NO);
            }
        }
        [self performSelector:@selector(hiddenTopHud) withObject:nil afterDelay:5.0];
    }
    else
    {
        _TopHUD.hidden = YES;
        _downHUD.alpha = 0;
        if (_roomHiddenHUD)
        {
            _roomHiddenHUD(YES);
        }
    }
}

- (void)setRoomName:(NSString *)name
{
    _roomName = name;
    __weak UIView *__topHUD = _TopHUD;
    @WeakObj(_roomName)
    dispatch_main_async_safe(^{
        UILabel *lblName = [__topHUD viewWithTag:1001];
        [lblName setText:_roomNameWeak];
    });
}

- (void)stopLoad
{

}

- (void)frameView
{
    _glView = [[LivePlayImageView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kVideoImageHeight)];
    _glView.contentMode = UIViewContentModeScaleAspectFit;
    _glView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:_glView];
    [self setDefaultImg];
}

- (void)disconnectMedia:(NSNotification *)notify
{
    __weak LivePlayViewController *__self = self;
    NSString *strMsg = notify && notify.object ? notify.object : nil;
    __weak NSString *__strMsg = strMsg;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        if(strMsg)
        {
            [__self.view makeToast:__strMsg];
        }
        [__self setDefaultImg];
    });
}

- (void)setDefaultImg
{
    char cBuffer[100]={0};
    sprintf(cBuffer,"video_logo_bg@2x");
    NSString *strName = [NSString stringWithUTF8String:cBuffer];
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:strName withExtension:@"png"];
    [_glView sd_setImageWithURL:url1];
    [_glView.lblContent setText:@""];
    [_glView loadDefault];
    _glView.nMode = 1;
}

- (void)setNoVideo
{
    char cBuffer[100]={0};
    sprintf(cBuffer,"video_logo_bg@2x");
    NSString *strName = [NSString stringWithUTF8String:cBuffer];
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:strName withExtension:@"png"];
    [_glView sd_setImageWithURL:url1];
    [_glView.lblContent setText:@""];
    [_glView loadAudioModel];
    _glView.nMode = 2;
}

- (id)init
{
    if(self = [super init])
    {
        nSourceHeight = kVideoImageHeight;
        nSourceWidth = kScreenWidth;
        return self;
    }
    return nil;
}

- (void)initDecode
{
    if (!_openAL)
    {
        _openAL = [[OpenAL alloc] init];
    }
    [_openAL initOpenAL];
    @synchronized(_aryVideo)
    {
        [_aryVideo removeAllObjects];
    }
}

- (void)stop
{
    DLog(@"视频停止");
    if(!_playing)
    {
        return ;
    }
    _playing = NO;
    _bVideo = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SVRMediaClient sharedSVRMediaClient] clientRcvStreamStop];
    });
    [_openAL stopSound];
    @WeakObj(self)
    gcd_main_safe(
    ^{
         [selfWeak setNullMic];
    });
    [UIApplication sharedApplication].idleTimerDisabled = _playing;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setBackGroudMode:(NSNotification *)notify
{
    if([notify.object isEqualToString:@"ON"])
    {
        _backGroud = YES;
        dispatch_async(dispatch_get_global_queue(0, 0),
        ^{
            [[SVRMediaClient sharedSVRMediaClient] clientMuteVideoStream:YES];
        });
        __weak LivePlayViewController *__self = self;
        dispatch_async(dispatch_get_main_queue(),
        ^{
            [__self setDefaultImg];
        });
    }
    else
    {
        _backGroud = NO;
        dispatch_async(dispatch_get_global_queue(0, 0),
        ^{
            [[SVRMediaClient sharedSVRMediaClient] clientMuteVideoStream:NO];
        });
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNotify];
    [self frameView];
    _aryVideo = [NSMutableArray array];
    lblText = [[UILabel alloc] initWithFrame:Rect(kScreenWidth/2-100,160,200,20)];
    [lblText setTextColor:[UIColor whiteColor]];
    [self.view addSubview:lblText];
    [lblText setFont:XCFONT(16)];
    [lblText setTextAlignment:NSTextAlignmentCenter];
    _glView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleRecogn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTopHUD)];
    singleRecogn.numberOfTapsRequired = 1;
    [_glView addGestureRecognizer:singleRecogn];
    
    UITapGestureRecognizer *doubleRecogn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom)];
    doubleRecogn.numberOfTapsRequired = 2;
    [_glView addGestureRecognizer:doubleRecogn];
    
    _TopHUD = [[UIView alloc] init];
    [_glView addSubview:_TopHUD];
    UIImageView *topImg = [[UIImageView alloc] initWithFrame:_downHUD.bounds];
    [topImg setImage:[UIImage imageNamed:@"dvr_conttrol_bg"]];
    [_TopHUD addSubview:topImg];
    [topImg setTag:1];
    UILabel *lblName = [[UILabel alloc] initWithFrame:Rect(0, 0, _TopHUD.width, 44)];
    [lblName setFont:XCFONT(15)];
    [lblName setTextAlignment:NSTextAlignmentCenter];
    lblName.tag = 1001;
    [lblName setTextColor:UIColorFromRGB(0xffffff)];
    [_TopHUD addSubview:lblName];
    _TopHUD.hidden = YES;
    
    UIButton *btnBack = [self createPlayBtn:@"back" high:@"back"];
    btnBack.frame = Rect(0, 0, 44, 44);
    [_TopHUD addSubview:btnBack];
    [btnBack addTarget:self action:@selector(fullPlayMode) forControlEvents:UIControlEventTouchUpInside];
    
    _downHUD = [[UIView alloc] initWithFrame:Rect(0, kVideoImageHeight-44, kScreenWidth, 44)];
    _downHUD.alpha = 1;
    UIImageView *downImg = [[UIImageView alloc] initWithFrame:_downHUD.bounds];
    [downImg setImage:[UIImage imageNamed:@"dvr_conttrol_bg"]];
    [_downHUD addSubview:downImg];
    [downImg setTag:1];
    [_glView addSubview:_downHUD];
    
    _btnVideo = [self createPlayBtn:@"video" high:@"video_h"];
    [_btnVideo addTarget:self action:@selector(connectUnVideo:) forControlEvents:UIControlEventTouchUpInside];
    _btnFull = [self createPlayBtn:@"full" high:@"full_h"];
    [_btnFull addTarget:self action:@selector(fullPlayMode) forControlEvents:UIControlEventTouchUpInside];
    _btnShare = [self createPlayBtn:@"video_room_share_icon_n" high:@"video_room_share_icon_p"];
    [_btnShare addTarget:self action:@selector(shareInfo) forControlEvents:UIControlEventTouchUpInside];
    _btnCollet = [self createPlayBtn:@"video_room_follow_icon_n" high:@"personal_follow_icon"];
    [_btnCollet setImage:[UIImage imageNamed:@"personal_follow_icon"] forState:UIControlStateSelected];
    [_btnCollet addTarget:self action:@selector(colletInfo) forControlEvents:UIControlEventTouchUpInside];
    
    [SVRMediaClient sharedSVRMediaClient].delegate = self;
    
    [self updateDownHUD];
    
    _downHUD.alpha = 0;
}


- (void)updateDownHUD
{
    CGFloat fWidth;
    CGFloat fHeight;
    if(bFull)
    {
        fWidth = kScreenWidth>kScreenHeight ? kScreenWidth : kScreenHeight;
        fHeight = kScreenWidth>kScreenHeight ? kScreenHeight : kScreenWidth;
        _TopHUD.frame = Rect(0, 0, fWidth, 44);
        UIImageView *topHud = (UIImageView *)[_TopHUD viewWithTag:1];
        topHud.frame = _TopHUD.bounds;
        _TopHUD.hidden = NO;
        
        UILabel *lblName = [_TopHUD viewWithTag:1001];
        [lblName setFrame:Rect(0, 0, fWidth, 44)];
        
        _downHUD.frame = Rect(0,fHeight-44, fWidth, 44);
        UIImageView *downImg = (UIImageView *)[_downHUD viewWithTag:1];
        downImg.frame = _downHUD.bounds;
   }
   else
   {
       fWidth = kScreenWidth;
       fHeight = kVideoImageHeight;
       _TopHUD.hidden = YES;
       _downHUD.frame = Rect(0,fHeight-44, fWidth, 44);
   }
    int number = 3;
    if (KUserSingleton.nStatus)
    {
        number = 4;
    }
    CGFloat fWith = fWidth / number;
    
    _btnFull.frame = Rect(fWith/2-22, 0,44, 44);
    _btnVideo.frame = Rect(fWith+fWith/2-22, 0,44, 44);
    CGRect frame = _btnVideo.frame;
    frame.origin.x += fWith;
    if (KUserSingleton.nStatus)
    {
        _btnShare.frame = frame;
        frame.origin.x += fWith;
    }
    _btnCollet.frame = frame;
    if (_statusBarHidden)
    {
        _statusBarHidden(YES);
    }
}

- (void)shareInfo
{
    if(_playing)
    {
        NSString *strUrl = [kProtocolSingle getVideoUrl];
        if(strUrl.length>0)
        {
            NSString *strInfo = [[NSString alloc] initWithFormat:@"正在看%@的视频直播，内容很不错，评论分析切中重点，你也快来看看吧",_roomName];
            ZLShareViewController *control = [[ZLShareViewController alloc] initWithTitle:strInfo url:strUrl];
            [control show];
        }
    }
    else
    {
        [ProgressHUD showError:@"没有讲师上麦,暂时无法分享!"];
    }
}

- (void)colletInfo
{
    
    WeakSelf(self);
    
    if(KUserSingleton.nType==1 && KUserSingleton.bIsLogin)
    {
        [[ZLLogonServerSing sharedZLLogonServerSing] colletRoomInfo:!_btnCollet.selected];
        
    }else
    {
        [UIAlertView createAlertViewWithTitle:@"温馨提示" withViewController:self withCancleBtnStr:@"取消" withOtherBtnStr:@"登录" withMessage:@"登录后才能关注讲师" completionCallback:^(NSInteger index) {
            if (index==1) {
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                [weakSelf.navigationController pushViewController:loginVC animated:YES];
            }
        }];

    }
}

- (UIButton *)createPlayBtn:(NSString *)strImg high:(NSString *)strHigh
{
    UIButton *btnVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    [_downHUD addSubview:btnVideo];
    [btnVideo setImage:[UIImage imageNamed:strImg] forState:UIControlStateNormal];
    [btnVideo setImage:[UIImage imageNamed:strHigh] forState:UIControlStateSelected];
    return btnVideo;
}

- (void)updateHUDView
{
    
}

- (void)connectUnVideo:(UIButton *)sender
{
    if (self.playing)
    {
        [self setOnlyAudio:sender.selected];
        sender.selected = !sender.selected;
    }
}

- (void)handleDoubleTapFrom{
    [self fullPlayMode];
}

-(void)fullPlayMode
{
    if (!bFull)
    {
        [_glView removeFromSuperview];
        _glView.frame = Rect(0, 0, kScreenWidth,kScreenHeight);
        [_glView removeFromSuperview];
        
        CGFloat _duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [[UIDevice currentDevice] setValue: [NSNumber numberWithInteger:UIDeviceOrientationLandscapeRight] forKey:@"orientation"];
        [UIViewController attemptRotationToDeviceOrientation];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:_duration];
        CGRect frame = [UIScreen mainScreen].bounds;
        CGPoint center = CGPointMake(frame.origin.x + ceil(frame.size.width/2), frame.origin.y + ceil(frame.size.height/2));
        _glView.center = center;
        _glView.transform = [self transformView];
        _glView.bounds = Rect(0, 0,kScreenHeight,kScreenWidth);
        [[UIApplication sharedApplication].keyWindow addSubview:_glView];
        [UIView commitAnimations];
        bFull = YES;
        [self updateDownHUD];
    }
    else
    {
        [self setHorizontal];
        bFull = NO;
        [self updateDownHUD];
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
    _glView.center = center;
    _glView.transform = [self transformView];
    _glView.bounds = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [UIView commitAnimations];
    [self.view addSubview:_glView];
    _glView.frame = Rect(0, 0, kScreenWidth, kVideoImageHeight);
}

-(CGAffineTransform)transformView
{
    if (!bFull)
    {
        return CGAffineTransformMakeRotation(M_PI/2);
    }
    else
    {
        return CGAffineTransformIdentity;
    }
}

- (void)setNullMic
{
    char cBuffer[100]={0};
    sprintf(cBuffer,"noMic@2x");
    NSString *strName = [NSString stringWithUTF8String:cBuffer];
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:strName withExtension:@"png"];
    [_glView sd_setImageWithURL:url1];
    [_glView.lblContent setText:@"当前无讲师上麦"];
    [_glView removeImgView];
    DLog(@"设置无人上麦!");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)startPlayRoomId:(int)roomid user:(int)userid name:(NSString *)name
{
    DLog(@"播放开启");
    if (_playing)
    {
        return ;
    }
    _roomName = name;
    bCoding = NO;
    if (_playing)
    {
        if (roomid!=_roomid)
        {
            [self stop];
            _roomid = roomid;
            [self startPlayRoomId:_roomid user:_nuserid name:_roomName];
        }
        return ;
    }
    _playing = YES;
    [self initDecode];
    __weak LivePlayViewController *__self = self;
    _roomid = roomid;
    _nuserid = userid;
    __block int __roomId = _roomid;
    __block int __userid = _nuserid;
    [[SVRMediaClient sharedSVRMediaClient] setMainRoomId:_roomid];
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
        if(![[SVRMediaClient sharedSVRMediaClient] clientRcvStreamStart:__userid roomId:__roomId])
        {
            DLog(@"开启接收码流失败");
        }
        [__self playVideoThread];
    });
    dispatch_main_async_safe(
    ^{
         [__self showAlertView];
         __self.btnVideo.selected = YES;
         [__self setDefaultImg];
    });
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)showAlertView
{
    if (KUserSingleton.nowNetwork == 2 && !KUserSingleton.checkNetWork)
    {
        dispatch_async(dispatch_get_global_queue(0, 0),
        ^{
            [[SVRMediaClient sharedSVRMediaClient] clientMuteVideoStream:YES];
        });
        [self setOnlyAudio:YES];
        @WeakObj(self)
        _bVideo = NO;
        [UIAlertView createAlertViewWithTitle:@"温馨提示" withViewController:[RoomViewController sharedRoomViewController] withCancleBtnStr:@"只听音频" withOtherBtnStr:@"继续看视频" withMessage:nil completionCallback:^(NSInteger index) {
            if (index==1)
            {
                KUserSingleton.checkNetWork = 1;
                [selfWeak setOnlyAudio:NO];
            }
        }];
    }
    else
    {
        _bVideo = YES;
    }
}

- (void)setOnlyAudio:(BOOL)enable
{
    if (!enable)
    {
        dispatch_async(dispatch_get_global_queue(0, 0),
        ^{
            [[SVRMediaClient sharedSVRMediaClient] clientMuteVideoStream:NO];
        });
        _bVideo = YES;
        [self setDefaultImg];
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(0, 0),
        ^{
            [[SVRMediaClient sharedSVRMediaClient] clientMuteVideoStream:YES];
        });
        _bVideo= NO;
        [self setNoVideo];
    }
}

- (void)createImage:(NSData *)data
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate((void *)data.bytes,
                                                    _videoWidth, _videoHeight, 8,
                                                    _videoWidth * 4,
                                                    colorSpace, kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedFirst);
    CGImageRef frame = CGBitmapContextCreateImage(newContext);
    _currentImage = [UIImage imageWithCGImage:frame];
    CGImageRelease(frame);
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    @WeakObj(self)
    dispatch_sync(dispatch_get_main_queue(),
    ^{
        if (selfWeak.glView.nMode==1)
        {
            [selfWeak.glView removeImgView];
            selfWeak.glView.nMode = 0;
        }
        if (selfWeak.bVideo)
        {
            [selfWeak.glView setImage:selfWeak.currentImage];
        }
   });
}

- (void)updateGlView
{
    _glView.image = _currentImage;
}

#pragma mark -
#pragma mark ibaction methods
- (void)dealloc
{
    [[SVRMediaClient sharedSVRMediaClient] clientCoreUnInit];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma mark AVAudioSession

- (void)updateCollet:(NSNotification *)notify
{
    @WeakObj(self)
    NSDictionary *dict = notify.object;
    if ([dict[@"code"] intValue]==1)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            selfWeak.btnCollet.selected = YES;
            [ProgressHUD showSuccess:@"关注成功"];
            if (selfWeak.colletView) {
                selfWeak.colletView(YES);
            }
        });
    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            selfWeak.btnCollet.selected = NO;
            [ProgressHUD showSuccess:@"取消关注"];
            if (selfWeak.colletView)
            {
                selfWeak.colletView(NO);
            }
        });
    }
}
- (void)onAudioData:(unsigned char *)cData len:(int32_t)len
{
    @autoreleasepool
    {
        [_openAL openAudioFromQueue:cData dataSize:len];
    }
}

- (void)onVideoData:(unsigned char *)data len:(int32_t)len width:(int32_t)width height:(int32_t)height
{
    _videoWidth = width;
    _videoHeight = height;
    @autoreleasepool
    {
        if (_bVideo)
        {
            NSData *videoData = [NSData dataWithBytes:data length:len];
            @synchronized(_aryVideo)
            {
                [_aryVideo addObject:videoData];
            }
            videoData = nil;
        }
    }
}

- (void)playVideoThread
{
    if (_playing)
    {
        if(_aryVideo.count>0)
        {
            @autoreleasepool
            {
                NSData *data = _aryVideo[0];
                @synchronized(_aryVideo)
                {
                    if (_aryVideo.count>0) {
                        [_aryVideo removeObjectAtIndex:0];
                    }
                    
                }
                [self createImage:data];
                data = nil;
            }
        }
        [NSThread sleepForTimeInterval:0.01f];
        @WeakObj(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1/20 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0),
        ^{
            [selfWeak playVideoThread];
        });
    }
}



@end
