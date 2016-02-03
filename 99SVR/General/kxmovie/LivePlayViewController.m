//
//  FSFFPLAYViewController.m
//  TestPlayWithFFMPEGAndSDL
//
//  Created by  on 12-12-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LivePlayViewController.h"
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
}
@property (nonatomic) BOOL bVideo;
@property (nonatomic,strong) OpenAL *openAL;
@property (nonatomic) opus_int16 *out_buffer;
@property (nonatomic,copy) UIImage *currentImage;
@property (nonatomic,strong) UIImageView *smallView;
@property (nonatomic,strong) NSMutableArray *aryVideo;
@property (nonatomic,strong) NSMutableArray *aryAudio;
@property (nonatomic,copy) NSString *strPath;

@end

@implementation LivePlayViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    @synchronized(_aryVideo)
    {
        [_aryVideo removeAllObjects];
    }
}

#pragma mark - View lifecycle
- (void)startLoad
{
    [_glView makeToastActivity_2:@"bottom"];
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
    _aryVideo = [NSMutableArray array];
    _aryAudio = [NSMutableArray array];
    [self.view setBackgroundColor:UIColorFromRGB(0x000000)];
    _smallView = [[UIImageView alloc] initWithFrame:Rect(_glView.width/2-44,_glView.height/2-35, 88, 71)];
    [self.view addSubview:_smallView];
    [self setDefaultImg];
}

- (void)setDefaultImg
{
    [_glView setImage:[UIImage imageNamed:@"live_default"]];
    _smallView.hidden = NO;
    [_smallView setImage:[UIImage imageNamed:@"noVideo"]];
}

- (void)initDecode
{
    av_register_all();
    AVCodec *codec = avcodec_find_decoder(AV_CODEC_ID_H264);
    avcodec_register(codec);
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
        if (_aryAudio.count==0)
        {
            [NSThread sleepForTimeInterval:0.03];
            continue ;
        }
        NSData *data = nil;
        @synchronized(_aryAudio)
        {
            data = [_aryAudio objectAtIndex:0];
            [_aryAudio removeObjectAtIndex:0];
        }
        if (data)
        {
            returnValue = opus_decode(_decoder,data.bytes,(int32_t)data.length,_out_buffer, 1920, 0);
            if (returnValue<0)
            {
                DLog(@"解码失败");
                continue;
            }
            int32_t length = returnValue * sizeof(opus_int16) * 2;
            [_openAL openAudioFromQueue:_out_buffer dataSize:length];
        }
        [NSThread sleepForTimeInterval:0.01];
    }
    [_openAL stopSound];
    [_openAL cleanUpOpenAL];
    
    [_aryAudio removeAllObjects];
}

- (void)stop
{
    _playing = NO;
    [_media closeSocket];
    [UIApplication sharedApplication].idleTimerDisabled = _playing;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self initAVAudioSession];
}

//- (void)initAVAudioSession
//{
//    AVAudioSession *sessionInstance = [AVAudioSession sharedInstance];
//    NSError *error;
//    bool success = [sessionInstance setCategory:AVAudioSessionCategoryPlayback error:&error];
//    if (!success) NSLog(@"Error setting AVAudioSession category! %@\n", [error localizedDescription]);
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                               selector:@selector(handleInterruption:)
//                                                   name:AVAudioSessionInterruptionNotification
//                                                 object:sessionInstance];
//    success = [sessionInstance setActive:YES error:&error];
//    if (!success) NSLog(@"Error setting session active! %@\n", [error localizedDescription]);
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self frameView];
    [self initDecode];
    _media = [[MediaSocket alloc] init];
    __weak LivePlayViewController *__self = self;
    _media.block = ^(unsigned char *puf,int nLen,int pt)
    {
        if (pt==99)
        {
            NSData *data = [[NSData alloc] initWithBytes:puf+8 length:nLen-8];
            @synchronized(__self.aryVideo)
            {
                if(__self.bVideo)
                {
                    [__self.aryVideo addObject:data];
                }
            }
            data = nil;
        }
        else if(pt==97 && nLen < 4000)
        {
            NSData *data = [[NSData alloc] initWithBytes:puf length:nLen];
            @synchronized(__self.aryAudio)
            {
                [__self.aryAudio addObject:data];
            }
            data = nil;
        }
    };
    [self setDefaultImg];
}

- (void)setNullMic
{
    [_glView setImage:[UIImage imageNamed:@"live_default"]];
    _smallView.hidden = NO;
    [_smallView setImage:[UIImage imageNamed:@"noMic"]];
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
    __weak LivePlayViewController *__self = self;
    dispatch_main_async_safe(
                             ^{
                                 [__self startLoad];
                             });
    _playing = YES;
    _bVideo = YES;
    [_media connectRoomId:roomid mic:userid];
    if (audioQueue==nil)
    {
        audioQueue = dispatch_queue_create("audio",0);
    }
    if (videoQueue==nil)
    {
        videoQueue = dispatch_queue_create("video_tid", 0);
    }
    dispatch_async(videoQueue,
    ^{
        [__self decodeVideo];
    });
    dispatch_async(audioQueue,
    ^{
        [__self decodeAudio];
    });
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
        [self setDefaultImg];
        [_aryVideo removeAllObjects];
    }
    else
    {
        _smallView.hidden = YES;
        __weak LivePlayViewController *__self = self;
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
        if (_aryVideo.count+_aryAudio.count>0)
        {
            __weak LivePlayViewController *__self = self;
            dispatch_main_async_safe(
            ^{
                 [__self.glView hideToastActivity];
                 __self.smallView.hidden = YES;
            });
            return;
        }
    }
}

- (void)decodeVideo
{
    //开定时器播放视频
    if (_playing && _bVideo)
    {
        __weak LivePlayViewController *__self = self;
        if (_aryVideo.count==0)
        {
            [NSThread sleepForTimeInterval:.03];
        }
        else
        {
            NSData *data = nil;
            @synchronized(_aryVideo)
            {
                data = [_aryVideo objectAtIndex:0];
                [_aryVideo removeObjectAtIndex:0];
            }
            if (data)
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
                {
                    DLog(@"解码失败");
                }
                else
                {
                    [self createVideoFrame];

                }
                av_free_packet(&packet);
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1/20 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
            [__self decodeVideo];
        });
    }
    else
    {
        avcodec_flush_buffers(_pCodecCtx);
        [self closeScaler];
        [_aryVideo removeAllObjects];
        __weak LivePlayViewController *__self = self;
        dispatch_main_async_safe(
        ^{
            [__self setDefaultImg];
        });
    }
}


#pragma mark -
#pragma mark custom methods

- (BOOL)setupScaler:(AVCodecContext *)pCodecCtx
{
    [self closeScaler];
    
    nSourceWidth = _glView.width;
    nSourceHeight = _glView.height;
    
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
            if(__self.bVideo)
            {
                __self.glView.image = __rgbImage;
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

- (void)stopWithError:(VideoPlayErrorType)errotType andError:(NSError *)error
{
    [self stop];
}

#pragma mark -
#pragma mark ibaction methods

- (void)dealloc
{
    free(_out_buffer);
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
    _currentImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CFRelease(data);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _smallView.frame = Rect(_glView.width/2-44,_glView.height/2-35, 88, 71);
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
