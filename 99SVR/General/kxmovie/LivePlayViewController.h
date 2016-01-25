//
//  FSFFPLAYViewController.h
//  TestPlayWithFFMPEGAndSDL
//  参考ffplay.c文件改写
//  Created by  on 12-12-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <inttypes.h>
#include <math.h>
#include <limits.h>
#include <signal.h>
#include "libavutil/avstring.h"
#include "libavutil/colorspace.h"
#include "libavutil/mathematics.h"
#include "libavutil/pixdesc.h"
#include "libavutil/imgutils.h"
#include "libavutil/dict.h"
#include "libavutil/parseutils.h"
#include "libavutil/samplefmt.h"
#include "libavutil/avassert.h"
#include "libavutil/time.h"
#include "libavformat/avformat.h"
#include "libavdevice/avdevice.h"
#include "libswscale/swscale.h"
#include "libavutil/opt.h"
#include "libavcodec/avfft.h"
#include "libswresample/swresample.h"
#include "SDL.h"
#include "SDL_thread.h"
#include "cmdutils.h"
#include <assert.h>
#import <QuartzCore/QuartzCore.h>


//播放器
@interface LivePlayViewController : UIViewController
{
    //显示视频的view

}

@property (nonatomic,strong) UIButton *btnAudio;
@property (nonatomic,strong) UIButton *btnVideo;

@property (nonatomic,strong) UIImageView *glView;

@property (nonatomic, assign) VideoPlayState videoPlayState;

//开始播放
- (void)startPlayWithURLString:(NSString *)playURLString;

//播放控制
- (void)pause;

- (void)stop;

//停止播放原因
- (void)stopWithError:(VideoPlayErrorType)errotType andError:(NSError *)error;

- (void)seekWithTime:(int)time;

//控件操作
- (IBAction)playAction:(id)sender;

//- (IBAction)pausePlayAction:(id)sender;

//- (IBAction)stopPlayAction:(id)sender;

- (void)playWithUrl:(NSString *)strUrl;

- (void)setDefaultImg;

- (void)setNullMic;

#pragma mark

@end
