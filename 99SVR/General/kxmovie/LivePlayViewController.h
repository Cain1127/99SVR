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
#include "libavformat/avformat.h"
#include "libswscale/swscale.h"
#include <assert.h>
#import <QuartzCore/QuartzCore.h>

#import "MediaSocket.h"
//播放器
@interface LivePlayViewController : UIViewController
{
    
}

@property (nonatomic,strong) MediaSocket *media;
@property (nonatomic) BOOL playing;
@property (nonatomic,strong) UIImageView *glView;

//开始播放

- (void)seekWithTime:(int)time;

- (void)playWithUrl:(NSString *)strUrl;

- (void)setDefaultImg;

- (void)setNullMic;

- (void)startPlayRoomId:(int)roomid user:(int)userid;

- (void)stop;

- (void)setOnlyAudio:(BOOL)enable;

@end
