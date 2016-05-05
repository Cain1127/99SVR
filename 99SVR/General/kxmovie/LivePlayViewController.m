//
//  FSFFPLAYViewController.m
//  TestPlayWithFFMPEGAndSDL
//
//  Created by  on 12-12-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LivePlayViewController.h"
#import "UIImageView+WebCache.h"
#import "RoomHttp.h"
#import "AudioPlayer.h"
#import "Toast+UIView.h"
#import "KxMovieDecoder.h"
#import "MediaSocket.h"
#include <sys/time.h>
#import "opus.h"
#import "SDWebImageCompat.h"
#import <AVFoundation/AVAudioSession.h>
#import "ZLShareViewController.h"

@interface LivePlayViewController()
{
    UITapGestureRecognizer *tapGesture;
    int nSourceWidth;
    int nSourceHeight;
    UIAlertView *myAlert;
    struct SwsContext *_swsContext;
    BOOL _pictureValid;
    AVCodecContext *_audioContext;
    AVCodecContext *_pCodecCtx;
    AVFrame *_pFrame;
    AVPicture _picture;
    OpusDecoder *_decoder;
    NSTimer *_timer;
    dispatch_queue_t videoQueue;
    dispatch_queue_t audioQueue;
    BOOL paused;
    BOOL bFirst;
    UILabel *lblText;
    int _roomid;
    int _nuserid;
    int nReceiveMemory;
    UIView *sunView;
    UIView *_downHUD;
    UIView *_TopHUD;
}
@property (nonatomic) BOOL backGroud;
@property (nonatomic) BOOL bVideo;
@property (nonatomic,strong) AudioPlayer *playAudio;
@property (nonatomic) opus_int16 *out_buffer;
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


- (void)setRoomId:(int)roomId
{
    _roomid = roomId;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadVideoList:) name:MESSAGE_ROOM_COLLET_UPDATE_VC object:nil];
    [kHTTPSingle RequestCollection];
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
    @synchronized(_media.videoBuf)
    {
        [_media.videoBuf removeAllObjects];
    }
    @synchronized(_media.audioBuf)
    {
        [_media.audioBuf removeAllObjects];
    }
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
    dispatch_main_async_safe(
    ^{
         __topHUD.hidden = YES;
         __downHUD.alpha = 0;
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
        [self performSelector:@selector(hiddenTopHud) withObject:nil afterDelay:5.0];
    }
    else
    {
        _TopHUD.hidden = YES;
        _downHUD.alpha = 0;
    }
}

- (void)setRoomName:(NSString *)name
{
    _roomName = name;
}

#pragma mark - View lifecycle
- (void)startLoad
{
    [_glView makeToastActivity_bird_2:@"bottom"];
}

- (void)stopLoad
{
    __weak UIImageView *__glView = _glView;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__glView hideToastActivity];
    });
}

- (void)frameView
{
    _glView = [[UIImageView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kVideoImageHeight)];
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
    if(strMsg)
    {
        [_media connectRoomId:_roomid mic:_nuserid];
    }
}

- (void)setDefaultImg
{
    
    char cBuffer[100]={0};
    sprintf(cBuffer,"video_logo_bg@2x");
    NSString *strName = [NSString stringWithUTF8String:cBuffer];
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:strName withExtension:@"png"];
    [_glView sd_setImageWithURL:url1];
    lblText.hidden = YES;
}

- (void)setNoVideo
{
    char cBuffer[100]={0};
    sprintf(cBuffer,"video_shangmai_bg@2x");
    NSString *strName = [NSString stringWithUTF8String:cBuffer];
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:strName withExtension:@"png"];
    [_glView sd_setImageWithURL:url1];
    lblText.hidden = NO;
    [lblText setText:@"音频模式"];
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
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        av_register_all();
    });
    AVCodec *codec = avcodec_find_decoder(AV_CODEC_ID_H264);
    _pCodecCtx = avcodec_alloc_context3(codec);
    if (avcodec_open2(_pCodecCtx,codec, nil)<0)
    {
        DLog(@"打开失败");
    }
    _pFrame = av_frame_alloc();
    _playAudio = [[AudioPlayer alloc] initWithSampleRate:48000];
    _decoder = opus_decoder_create(48000,2,0);
    _out_buffer = (opus_int16 *)malloc(1920*2*sizeof(opus_int16));
}

- (void)decodeAudio
{
    [_playAudio startPlayWithBufferByteSize:7680];
    int returnValue = 0;
    while (_playing)
    {
        if (_media.audioBuf.count==0)
        {
            [NSThread sleepForTimeInterval:0.5f];
            continue ;
        }
        @autoreleasepool
        {
            NSData *data = nil;
            if(_media.audioBuf.count>0)
            {
                data = [_media.audioBuf objectAtIndex:0];
            }
            if (data && data.length > 0)
            {
                returnValue = opus_decode(_decoder,data.bytes,(int32_t)data.length,_out_buffer, 1920, 0);
                if (returnValue<0)
                {
                    continue;
                }
                [_playAudio putAudioData:_out_buffer];
            }
            @synchronized(_media.audioBuf)
            {
                if(_media.audioBuf.count>0)
                {
                    [_media.audioBuf removeObjectAtIndex:0];
                }
            }
            [NSThread sleepForTimeInterval:0.01];
        }
    }
    [_playAudio stopPlay];
    [_media.audioBuf removeAllObjects];
}

- (void)stop
{
    DLog(@"视频停止");
    _media.nFall = 0;
    _playing = NO;
    [_media closeSocket];
    @WeakObj(self)
    gcd_main_safe(^{
         [selfWeak setDefaultImg];
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
        [_media settingBackVideo:YES];
        __weak LivePlayViewController *__self = self;
        dispatch_async(dispatch_get_main_queue(),
        ^{
            [__self setDefaultImg];
        });
    }
    else
    {
        _backGroud = NO;
        [_media settingBackVideo:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self frameView];
    lblText = [[UILabel alloc] initWithFrame:Rect(kScreenWidth/2-100,160,200,20)];
    [lblText setTextColor:[UIColor whiteColor]];
    [self.view addSubview:lblText];
    [lblText setFont:XCFONT(16)];
    [lblText setTextAlignment:NSTextAlignmentCenter];
    _media = [[MediaSocket alloc] init];
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
    _btnVideo = [self createPlayBtn:@"video_h" high:@"video"];
    [_btnVideo addTarget:self action:@selector(connectUnVideo:) forControlEvents:UIControlEventTouchUpInside];
    _btnFull = [self createPlayBtn:@"full" high:@"full_h"];
    [_btnFull addTarget:self action:@selector(fullPlayMode) forControlEvents:UIControlEventTouchUpInside];
    _btnShare = [self createPlayBtn:@"video_room_share_icon_n" high:@"video_room_share_icon_p"];
    [_btnShare addTarget:self action:@selector(shareInfo) forControlEvents:UIControlEventTouchUpInside];
    _btnCollet = [self createPlayBtn:@"video_room_follow_icon_n" high:@"personal_follow_icon"];
    [_btnCollet addTarget:self action:@selector(colletInfo) forControlEvents:UIControlEventTouchUpInside];
    [self updateDownHUD];
    _downHUD.alpha = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBackGroudMode:) name:MESSAGE_ENTER_BACK_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectMedia:) name:MESSAGE_MEDIA_DISCONNECT_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCollet:) name:MESSAGE_COLLET_RESP_VC object:nil];
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
    CGFloat fWith = fWidth/4;
    _btnFull.frame = Rect(fWith/2-22, 0,44, 44);
    _btnVideo.frame = Rect(fWith+fWith/2-22, 0,44, 44);
    _btnShare.frame = Rect(fWith*2+fWith/2-22, 0,44, 44);
    _btnCollet.frame = Rect(fWith*3+fWith/2-22, 0,44, 44);
    if (_statusBarHidden) {
        _statusBarHidden(YES);
    }
    
}

- (void)shareInfo
{
    NSString *strInfo = [[NSString alloc] initWithFormat:@"正在看%@的视频直播，内容很不错，评论分析切中重点，你也快来看看吧",_roomName];
    ZLShareViewController *control = [[ZLShareViewController alloc] initWithTitle:strInfo url:@"www.99ducaijing.com"];
    [control show];
}

- (void)colletInfo
{
    [[ZLLogonServerSing sharedZLLogonServerSing] colletRoomInfo:!_btnCollet.selected];
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
    if (!bFull)//NO状态表示当前竖屏，需要转换成横屏
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
    
//    lblText.hidden = NO;
//    lblText.text = @"没有讲师上麦";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)startPlayRoomId:(int)roomid user:(int)userid name:(NSString *)name
{
    _roomName = name;
    if (_playing)
    {
        if (roomid!=_roomid)
        {
            [self stop];
            _nuserid = userid;
            _roomid = roomid;
            [self startPlayRoomId:_roomid user:_nuserid name:_roomName];
        }
        return ;
    }
    _playing = YES;
    [self initDecode];
    __weak LivePlayViewController *__self = self;
    dispatch_main_async_safe(
    ^{
        [__self startLoad];
        [__self setDefaultImg];
    });
    _bVideo = YES;
    [_media connectRoomId:roomid mic:userid];
    _roomid = roomid;
    _nuserid = userid;
    if (audioQueue==nil)
    {
        audioQueue = dispatch_queue_create("audio",0);
    }
    if (videoQueue==nil)
    {
        videoQueue = dispatch_queue_create("video_tid", 0);
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
        [__self checkMedia];
    });
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)setOnlyAudio:(BOOL)enable
{
    [_media setEnableVideo:enable];
    _bVideo = enable;
    if (!enable)
    {
        @synchronized(_media.videoBuf)
        {
            [_media.videoBuf removeAllObjects];
        }
        [self setNoVideo];
    }
    else
    {
        __weak LivePlayViewController *__self = self;
        lblText.hidden = YES;
        dispatch_async(videoQueue,
        ^{
            [__self decodeVideo];
        });
    }
}

- (void)checkMedia
{
    return ;
    while (_playing)
    {
        if (_media.audioBuf.count+_media.videoBuf.count>0)
        {
            __weak LivePlayViewController *__self = self;
            dispatch_main_async_safe(
            ^{
                 [__self.glView hideToastActivity];
            });
            dispatch_async(videoQueue,
           ^{
               [__self decodeVideo];
           });
            dispatch_async(audioQueue,
           ^{
               [__self decodeAudio];
           });
           return;
        }
        [NSThread sleepForTimeInterval:0.5f];
    }
}

- (void)decodeVideo
{
    //开定时器播放视频
    if (_playing && _bVideo)
    {
        __weak LivePlayViewController *__self = self;
        if (_media.videoBuf.count<=0)
        {
            [NSThread sleepForTimeInterval:.5f];
        }
        else
        {
            @autoreleasepool
            {
                NSData *data = nil;
                @synchronized(_media.videoBuf)
                {
                    data = [_media.videoBuf objectAtIndex:0];
                    [_media.videoBuf removeObjectAtIndex:0];
                }
                if (data && data.length > 0)
                {
                    AVPacket packet;
                    av_init_packet(&packet);
                    packet.size = (int)data.length;
                    unsigned char cBuffer[data.length];
                    memcpy(cBuffer,data.bytes,data.length);
                    packet.data = cBuffer;
                    int got_pictrue;
                    int len;
                    len = avcodec_decode_video2(_pCodecCtx,_pFrame,&got_pictrue,&packet);
                    if (len<0)
                    {}
                    else
                    {
                        [self createVideoFrame];
                    }
                    av_free_packet(&packet);
                }
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1/20 * NSEC_PER_SEC)),videoQueue,
        ^{
            [__self decodeVideo];
        });
    }
    else
    {
        avcodec_flush_buffers(_pCodecCtx);
        [self closeScaler];
        [_media.videoBuf removeAllObjects];
    }
}

#pragma mark -
#pragma mark custom methods

- (BOOL)setupScaler:(AVCodecContext *)pCodecCtx
{
    [self closeScaler];
    
    _pictureValid = avpicture_alloc(&_picture,
                                    PIX_FMT_RGB24,
                                    nSourceWidth,
                                    nSourceHeight) == 0;
    if (!_pictureValid)
        return NO;
    _swsContext = sws_getCachedContext(_swsContext,
                                       pCodecCtx->width,
                                       pCodecCtx->height,
                                       pCodecCtx->pix_fmt,
                                       nSourceWidth,
                                       nSourceHeight,
                                       PIX_FMT_RGB24,
                                       SWS_FAST_BILINEAR,
                                       NULL, NULL, NULL);
    return _swsContext != NULL;
}

- (void)createVideoFrame
{
    if (!_pictureValid)
    {
        [self setupScaler:_pCodecCtx];
    }
    static uint8_t *p = NULL;
    p = _pFrame->data[1];
    _pFrame->data[1] = _pFrame->data[2];
    _pFrame->data[2] = p;
    
    _pFrame->data[0] += _pFrame->linesize[0] * (_pCodecCtx->height - 1);
    _pFrame->linesize[0] *= -1;
    _pFrame->data[1] += _pFrame->linesize[1] * (_pCodecCtx->height / 2 - 1);
    _pFrame->linesize[1] *= -1;
    _pFrame->data[2] += _pFrame->linesize[2] * (_pCodecCtx->height / 2 - 1);
    _pFrame->linesize[2] *= -1;
    
    int nRef = sws_scale(_swsContext,(const uint8_t **)_pFrame->data,_pFrame->linesize,
              0,_pCodecCtx->height,_picture.data,_picture.linesize);
    if (nRef>0)
    {
        __weak LivePlayViewController *__self = self;
        [self imageFromAVPicture:_picture width:kScreenWidth height:kVideoImageHeight];
        __weak UIImage *__rgbImage = _currentImage;
        dispatch_main_sync_safe(
        ^{
            if(__self.bVideo && !__self.backGroud)
            {
                if(__rgbImage){
                    __self.glView.image = __rgbImage;
                }
            }
        });
    }
}

- (void) closeScaler
{
    if (_swsContext)
    {
        sws_freeContext(_swsContext);
        _swsContext = NULL;
    }
    
    if (_pictureValid) {
        avpicture_free(&_picture);
        _pictureValid = NO;
    }
}

#pragma mark -
#pragma mark ibaction methods

- (void)dealloc
{
    DLog(@"已经释放");
    if(_out_buffer)
    {
        free(_out_buffer);
        _out_buffer = NULL;
    }
    opus_decoder_destroy(_decoder);
    if(_pFrame)
    {
        av_frame_free(&_pFrame);
    }
    if (_pCodecCtx)
    {
        avcodec_close(_pCodecCtx);
    }
}

-(void)imageFromAVPicture:(AVPicture)pict width:(int)width height:(int)height {
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CFDataRef data = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, pict.data[0], pict.linesize[0]*height,kCFAllocatorNull);
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef cgImage = CGImageCreate(width,
                                       height,
                                       8,
                                       24,
                                       pict.linesize[0],
                                       colorSpace,
                                       bitmapInfo,
                                       provider,
                                       NULL,
                                       NO,
                                       kCGRenderingIntentDefault);
    CGColorSpaceRelease(colorSpace);
    if (cgImage) {
        _currentImage = [UIImage imageWithCGImage:cgImage];
    }
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CFRelease(data);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    _smallView.frame = Rect(_glView.width/2-44,_glView.height/2-35, 88, 71);
//    CGFloat originY = _glView.height == kVideoImageHeight ? _glView.height/2+30 : _glView.height/2+40;
//    lblText.frame = Rect(_glView.width/2-100,originY+10, 200, 20);
}

#pragma mark AVAudioSession

- (void)updateCollet:(NSNotification *)notify
{
    
}

@end
