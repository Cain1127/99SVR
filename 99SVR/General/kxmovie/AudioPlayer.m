//
//  AudioPlayer.m
//  99SVR
//
//  Created by xia zhonglin  on 4/30/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "AudioPlayer.h"
#import <AVFoundation/AVAudioSession.h>

@implementation AudioPlayer

@synthesize mQueue;

void AQBufferCallback(void *                inUserData ,
                      AudioQueueRef         inAQ,
                      AudioQueueBufferRef   inBuffer)
{
    AudioPlayer *THIS = (__bridge AudioPlayer *)(inUserData);
    
    if(THIS->mIsRunning)
    {
        inBuffer->mPacketDescriptionCount = THIS->mBufferByteSize/2;
        inBuffer->mAudioDataByteSize =THIS->mBufferByteSize;
        if(read(THIS->pip_fd[0], inBuffer->mAudioData, THIS->mBufferByteSize) > 0 ){
            AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
        }
    }
    
}

- (void)handleAudioNotify:(NSNotification *)notification
{
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification])
    {
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]])
        {
            
        }
        else if([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeEnded]])
        {
            
        }
    }
}

-(id)init
{
    return [self initWithSampleRate:16000];
}

-(id)initWithSampleRate:(int)sampleRate
{
    self = [super init];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAudioNotify:) name:AVAudioSessionInterruptionNotification object:nil];
    if(self)
    {
        memset(&mPlayFormat, 0, sizeof(mPlayFormat));
        mPlayFormat.mFormatID = kAudioFormatLinearPCM;
        mPlayFormat.mSampleRate = 44100;
        mPlayFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger;
        mPlayFormat.mFramesPerPacket = 1;
        mPlayFormat.mBytesPerFrame = 4;
        mPlayFormat.mBitsPerChannel = 16;
        mPlayFormat.mBytesPerPacket = 4;
        mPlayFormat.mChannelsPerFrame = 2;
        mIsRunning = false;
        mIsInitialized = false;
    }
    return self;
}

-(void)startPlayWithBufferByteSize:(int)bufferByteSize
{
    if (mIsInitialized) return;
    
    mBufferByteSize = bufferByteSize;
    AudioQueueNewOutput(&mPlayFormat, AQBufferCallback, (__bridge void *)(self), nil, nil, 0, &mQueue);
    for (int i=0; i<kNumberBuffers; i++) {
        AudioQueueAllocateBuffer(mQueue, mBufferByteSize,  &mBuffers[i]);
    }
    
    AudioQueueSetParameter(mQueue, kAudioQueueParam_Volume, 1.0);
    mIsInitialized = true;
    int ret = pipe(pip_fd);
    if (ret == -1) {
        NSLog(@"create pipe failed");
    }
}

-(void)stopPlay
{
    close(pip_fd[0]);
    close(pip_fd[1]);
    AudioQueueStop(mQueue, false);
    if (mQueue){
        AudioQueueDispose(mQueue, true);
        mQueue = NULL;
        mIsRunning = false;
    }
    mIsInitialized = false;
    NSLog(@"stop play queue");
}

-(void)putAudioData:(short*)pcmData size:(int)nSize
{
    
    if (!mIsRunning) {
        memcpy(mBuffers[mIndex]->mAudioData, pcmData, nSize);
        mBuffers[mIndex]->mAudioDataByteSize = nSize;
        mBuffers[mIndex]->mPacketDescriptionCount = nSize/2;
        AudioQueueEnqueueBuffer(mQueue, mBuffers[mIndex], 0, NULL);
        NSLog(@"fill audio queue buffer[%d]",mIndex);
        if(mIndex == kNumberBuffers - 1) {
            mIsRunning = true;
            mIndex = 0;
            AudioQueueStart(mQueue, NULL);
        }else {
            mIndex++;
        }
    }else {
        if(write(pip_fd[1], pcmData, nSize) < 0){
        }
    }
}
@end

