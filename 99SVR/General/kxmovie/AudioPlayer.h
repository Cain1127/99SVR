//
//  AudioPlayer.h
//  99SVR
//
//  Created by xia zhonglin  on 4/30/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <CoreFoundation/CoreFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#include <unistd.h>

#define kNumberBuffers 3

@interface AudioPlayer : NSObject
{
    AudioQueueRef                   mQueue;
    AudioQueueBufferRef             mBuffers[kNumberBuffers];
    AudioStreamBasicDescription     mPlayFormat;
    int                             mIndex;
@public
    Boolean                         mIsRunning;
    Boolean                         mIsInitialized;
    int                             mBufferByteSize;
    int                             pip_fd[2];
    UInt32                          mNumPacketsToRead;
}
@property AudioQueueRef mQueue;

-(id)init;
-(id)initWithSampleRate:(int)sampleRate;
-(void)startPlayWithBufferByteSize:(int)bufferByteSize;
-(void)stopPlay;
-(void)putAudioData:(short*)pcmData;

@end
