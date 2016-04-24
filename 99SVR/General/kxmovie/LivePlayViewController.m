//
//  FSFFPLAYViewController.m
//  TestPlayWithFFMPEGAndSDL
//
//  Created by  on 12-12-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LivePlayViewController.h"
#import "UIImageView+WebCache.h"
#import "Toast+UIView.h"
#import "OpenAL.h"
#import "KxMovieDecoder.h"
#import "MediaSocket.h"
#include <sys/time.h>
#import "opus.h"
#import "SDWebImageCompat.h"
#import <AVFoundation/AVAudioSession.h>

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
}
@property (nonatomic) BOOL backGroud;
@property (nonatomic) BOOL bVideo;
@property (nonatomic,strong) OpenAL *openAL;
@property (nonatomic) opus_int16 *out_buffer;
@property (nonatomic,copy) UIImage *currentImage;
@property (nonatomic,strong) UIImageView *smallView;
@property (nonatomic,copy) NSString *strPath;

//@property (nonatomic,strong) NSMutableArray *aryVideo;
//@property (nonatomic,strong) NSMutableArray *aryAudio;

@end

@implementation LivePlayViewController

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

#pragma mark - View lifecycle
- (void)startLoad
{
    [_glView makeToastActivity_2:@"bottom"];
//    [_glView makeToastActivity];
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
    _openAL = [[OpenAL alloc]  init];
    _decoder = opus_decoder_create(48000,2,0);
    _out_buffer = (opus_int16 *)malloc(1920*2*sizeof(opus_int16));
}

- (void)decodeAudio
{
    [_openAL initOpenAL];
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
                int32_t length = returnValue * sizeof(opus_int16) * 2;
                [_openAL openAudioFromQueue:(uint8_t*)_out_buffer dataSize:length];
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
    [_openAL stopSound];
    [_media.audioBuf removeAllObjects];
}

- (void)stop
{
    DLog(@"视频停止");
    _playing = NO;
    [_media closeSocket];
    [UIApplication sharedApplication].idleTimerDisabled = _playing;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBackGroudMode:) name:MESSAGE_ENTER_BACK_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectMedia:) name:MESSAGE_MEDIA_DISCONNECT_VC object:nil];
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
}

- (void)setNullMic
{
    char cBuffer[100]={0};
    sprintf(cBuffer,"noMic@2x");
    NSString *strName = [NSString stringWithUTF8String:cBuffer];
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:strName withExtension:@"png"];
    [_glView sd_setImageWithURL:url1];
    
    lblText.hidden = NO;
    lblText.text = @"没有讲师上麦";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)startPlayRoomId:(int)roomid user:(int)userid
{
    if (_playing)
    {
        if (roomid!=_roomid) {
            [self stop];
            _nuserid = userid;
            _roomid = roomid;
            [self startPlayRoomId:_roomid user:_nuserid];
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
//    dispatch_async(videoQueue,
//    ^{
//        [__self decodeVideo];
//    });
//    dispatch_async(audioQueue,
//    ^{
//        [__self decodeAudio];
//    });
    
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
    while (_playing)
    {
        if (_media.audioBuf.count+_media.videoBuf.count>0)
        {
            __weak LivePlayViewController *__self = self;
            dispatch_main_async_safe(
            ^{
                 [__self.glView hideToastActivity];
                 __self.smallView.hidden = YES;
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

- (void)handleDoubleTapFrom
{
    
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
    _smallView.frame = Rect(_glView.width/2-44,_glView.height/2-35, 88, 71);
    CGFloat originY = _glView.height == kVideoImageHeight ? _glView.height/2+30 : _glView.height/2+40;
    lblText.frame = Rect(_glView.width/2-100,originY+10, 200, 20);
}

#pragma mark AVAudioSession
/*
- (void)handleInterruption:(NSNotification *)notification
{
    UInt8 theInterruptionType = [[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] intValue];
    if (theInterruptionType == AVAudioSessionInterruptionTypeBegan)
    {
        DLog(@"input:%@",[[AVAudioSession sharedInstance] availableInputs]);
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
    }
    else if (theInterruptionType == AVAudioSessionInterruptionTypeEnded)
    {
        NSError *error;
        BOOL bSucess = [[AVAudioSession sharedInstance] setActive:YES error:&error];
        if (!bSucess)
        {
            DLog(@"error:%@",error);
        }
    }
}
*/
@end
