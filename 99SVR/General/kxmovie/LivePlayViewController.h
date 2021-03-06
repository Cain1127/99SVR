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
#include <assert.h>
#import <QuartzCore/QuartzCore.h>
#import "LivePlayImageView.h"

//播放器
@interface LivePlayViewController : UIViewController
{
}

@property (nonatomic) BOOL playing;
@property (nonatomic,strong) LivePlayImageView *glView;
@property (nonatomic) BOOL bFull;
@property (nonatomic) int roomIsCollet;
@property (nonatomic) int nuserid;
@property (nonatomic,copy) void (^statusBarHidden)(BOOL bInfo);
@property (nonatomic,copy) void (^colletView)(BOOL bCollet);
@property (nonatomic,copy) void (^roomHiddenHUD)(BOOL bHidden);

//开始播放

- (void)setCollet:(int)iscollet;

- (void)setRoomId:(int)roomId;

- (void)setDefaultImg;

- (void)setNullMic;

- (void)startPlayRoomId:(int)roomid user:(int)userid name:(NSString *)name;

- (void)stop;

- (void)setOnlyAudio:(BOOL)enable;

- (void)fullPlayMode;

- (void)setRoomName:(NSString *)name;

@end
