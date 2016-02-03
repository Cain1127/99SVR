//
//  TestPlayViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/26/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TestPlayViewController.h"
#import <Accelerate/Accelerate.h>
#include "libavformat/avformat.h"
#include "libswscale/swscale.h"
#include "libswresample/swresample.h"
#include "libavutil/pixdesc.h"
#import "KxMovieDecoder.h"
#import "KxAudioManager.h"
#import "TestMedia.h"
#import "EZMicrophone.h"
#import "EZOutput.h"
#import "OpusKit.h"
#import "TPCircularBuffer.h"
#import "OpenAL.h"
#import "SDL.h"
#import "SDL_events.h"
#import "opus.h"

#define kMAX_bufferedDuration   2
#define kMIN_bufferedDuration  0.1
#define MAX_AUDIO_FRAME_SIZE 192000
#define DEFAULT_CHANNELS      2
#define DEFAULT_SAMPLERATE    48000  //48khz
#define DEFAULT_AUDIO_BITRATE 48000 //48kbps

@interface TestPlayViewController ()<EZMicrophoneDelegate,EZOutputDataSource>
{
    TestMedia *_media;
    AVFormatContext     *_formatCtx;
    AVCodecContext      *_videoCodecCtx;
    AVCodecContext      *_audioCodecCtx;
    AVFrame             *_videoFrame;
    AVFrame             *_audioFrame;
    dispatch_queue_t    decodeAudio;
    CGFloat _bufferedDuration;
    NSData              *_currentAudioFrame;
    NSUInteger          _currentAudioFramePos;
    BOOL                _buffered;
    CGFloat _moviePosition;
    NSTimeInterval      _tickCorrectionTime;
    NSTimeInterval      _tickCorrectionPosition;
    void                *_swrBuffer;
    NSUInteger          _swrBufferSize;
    CGFloat       _fpsStart;
    int _decoderBufferLength;
    OpenAL *_openAL;
    int out_buffer_size;
    OpusDecoder *_decoder;
    
}
@property (nonatomic) BOOL decoding;
@property (nonatomic,assign) BOOL bPlaying;
@property (nonatomic,strong) NSMutableArray *aryVideo;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) NSMutableArray *aryAudio;
@property (nonatomic,assign) BOOL validAudio;
@property (nonatomic,assign) BOOL validVideo;
@property (nonatomic,strong) NSMutableArray *audioFrames;
@property (nonatomic) opus_int16 *outputBuffer;

@end

@implementation TestPlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat fHeight = kScreenWidth*3/4;
    _imgView = [[UIImageView alloc] initWithFrame:Rect(0, kScreenHeight/2-fHeight/2,kScreenWidth,kScreenWidth*3/4)];
    [self.view addSubview:_imgView];
    _aryVideo = [NSMutableArray array];
    _aryAudio = [NSMutableArray array];
    _audioFrames = [NSMutableArray array];
    _media = [[TestMedia alloc] init];
    
    _openAL = [[OpenAL alloc] init];
    [_openAL initOpenAL];
    _validAudio = YES;
    
    [_media connectIpAndPort:@"121.12.118.9" port:819];
    
    __weak TestPlayViewController *__self = self;
    _media.block = ^(unsigned char *cBuf,int nLen)
    {
        NSData *data = [NSData dataWithBytes:cBuf length:nLen];
        @synchronized(__self.aryAudio)
        {
            [__self.aryAudio addObject:data];
        }
    };
    decodeAudio = dispatch_queue_create("audio_decode",0);
    dispatch_async(decodeAudio,
    ^{
        [__self initDecode];
    });
}

- (void)initDecode
{
    int opusError = OPUS_OK;
    _decoder = opus_decoder_create(DEFAULT_SAMPLERATE, DEFAULT_CHANNELS,&opusError);
    if (opusError != OPUS_OK)
    {
        DLog(@"初始化解码库失败!");
        return ;
    }
    _outputBuffer = (opus_int16 *)malloc(DEFAULT_CHANNELS * 1920 *sizeof(opus_int16));
    _bPlaying = YES;
    [self goDecoder];
}

- (void)goDecoder
{
    int returnValue=0;
    while (_bPlaying)
    {
        if(_aryAudio.count==0)
        {
            [NSThread sleepForTimeInterval:30];
            continue;
        }
        int32_t decodedSamples = 0;
        NSData *data = [_aryAudio objectAtIndex:0];
        if(data)
        {
            [_aryAudio removeObjectAtIndex:0];
            returnValue = opus_decode(_decoder, data.bytes, (int32_t)data.length,_outputBuffer, 960*2, 0);
            if (returnValue<0)
            {
                DLog(@"解码失败");
                continue ;
            }
            decodedSamples = returnValue;
            uint32_t length = decodedSamples * sizeof(opus_int16) * DEFAULT_CHANNELS;
            [_openAL openAudioFromQueue:_outputBuffer dataSize:length];
        }
    }
}

- (void)startDecode
{
}

- (CGFloat) tickCorrection
{
    if (_buffered)
        return 0;
    const NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    if (!_tickCorrectionTime)
    {
        _tickCorrectionTime = now;
        _tickCorrectionPosition = _moviePosition;
        return 0;
    }
    
    NSTimeInterval dPosition = _moviePosition - _tickCorrectionPosition;
    NSTimeInterval dTime = now - _tickCorrectionTime;
    NSTimeInterval correction = dPosition - dTime;
    
    if (correction > 1.f || correction < -1.f)
    {
        correction = 0;
        _tickCorrectionTime = 0;
    }
    
    return correction;
}
@end
