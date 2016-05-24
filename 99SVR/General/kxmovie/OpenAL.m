//
//  OpenAL.m
//  SVRMedia
//
//  Created by xia zhonglin  on 5/12/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "OpenAL.h"
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioServices.h>

@implementation OpenAL

@synthesize mDevice,mContext,soundDictionary,bufferStorageArray;
@synthesize wasInterrupted;

- (void)handleAudioNotify:(NSNotification *)notification
{
    printf("声音中断");
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification])
    {
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]])
        {
            alcMakeContextCurrent(NULL);
            alcSuspendContext(mContext);
            [[AVAudioSession sharedInstance] setActive:NO error:nil];
        }
        else if([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeEnded]])
        {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                             withOptions:AVAudioSessionCategoryOptionMixWithOthers
                                                   error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            alcMakeContextCurrent(mContext);
            alcProcessContext(mContext);
        }
    }
}

- (void)teardownOpenAL
{
    ALCcontext	*context = NULL;
    ALCdevice	*device = NULL;
    alDeleteSources(1, &outSourceId);
    alDeleteBuffers(1, &buff);
    context = alcGetCurrentContext();
    device = alcGetContextsDevice(context);
    alcDestroyContext(context);
    alcCloseDevice(device);
}

#pragma make - openal function
- (id)init{
    if(self=[super init]){
        ticketCondition = [[NSCondition alloc] init];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive: YES error:nil];
        NSError *setCategoryError = nil;
        if (![session setCategory:AVAudioSessionCategoryPlayback
                      withOptions:AVAudioSessionCategoryOptionMixWithOthers
                            error:&setCategoryError]) {
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleAudioNotify:) name:AVAudioSessionInterruptionNotification object:nil];
        return self;
    }
    return nil;
}

- (NSString*)GetALCErrorString:(ALenum)err{
    NSString *strMsg = nil;
    switch(err){
        case ALC_NO_ERROR:
            strMsg = @"AL_NO_ERROR";
            break;
        case ALC_INVALID_DEVICE:
            strMsg = @"ALC_INVALID_DEVICE";
            break;
        case ALC_INVALID_CONTEXT:
            strMsg = @"ALC_INVALID_CONTEXT";
            break;
        case ALC_INVALID_ENUM:
            strMsg = @"ALC_INVALID_ENUM";
            break;
        case ALC_INVALID_VALUE:
            strMsg = @"ALC_INVALID_VALUE";
            break;
        case ALC_OUT_OF_MEMORY:
            strMsg = @"ALC_OUT_OF_MEMORY";
            break;
    }
    return strMsg;
}

-(void)initOpenAL
{
    mDevice=alcOpenDevice(NULL);
    if (mDevice)
    {
        mContext=alcCreateContext(mDevice, NULL);
        alcMakeContextCurrent(mContext);
    }
    alGenSources(1, &outSourceId);
    alSpeedOfSound(1.0);
    alDopplerVelocity(1.0);
    alDopplerFactor(1.0);
    alSourcef(outSourceId, AL_PITCH, 1.0f);
    alSourcef(outSourceId, AL_GAIN, 1.0f);
    alSourcef(outSourceId, AL_SOURCE_TYPE, AL_STREAMING);
}

- (void)openAudioFromQueue:(unsigned char*)data dataSize:(UInt32)dataSize
{
    [ticketCondition lock];
    ALuint bufferID = 0;
    alGenBuffers(1, &bufferID);
    int aSampleRate,aBit,aChannel;
    aSampleRate = 48000;
    aBit = 16;
    aChannel = 2;
    ALenum format=AL_FORMAT_STEREO16;
    alBufferData(bufferID, format,data, (ALsizei)dataSize,aSampleRate);
    if (alGetError()!= AL_NO_ERROR)
    {
        NSLog(@"Error generating sources!\n");
        [ticketCondition unlock];
        return ;
    }
    alSourceQueueBuffers(outSourceId, 1, &bufferID);
    if (alGetError()!= AL_NO_ERROR)
    {
        NSLog(@"Error generating sources!\n");
        [ticketCondition unlock];
    }
    else
    {
        [self updataQueueBuffer];
        int queued;
        alGetSourcei(outSourceId, AL_BUFFERS_QUEUED, &queued);
//        NSLog(@"queued:%d",queued);
        if (queued>80)
        {
            [NSThread sleepForTimeInterval:0.04f];
        }
        else if(queued>20)
        {
            [NSThread sleepForTimeInterval:0.02f];
        }
        else
        {
            [NSThread sleepForTimeInterval:0.013f];
        }
        [ticketCondition unlock];
    }
}

- (BOOL)updataQueueBuffer
{
    ALint stateVaue;
    int processed, queued;
    alGetSourcei(outSourceId, AL_BUFFERS_PROCESSED, &processed);
    alGetSourcei(outSourceId, AL_BUFFERS_QUEUED, &queued);
    alGetSourcei(outSourceId, AL_SOURCE_STATE, &stateVaue);
    if (stateVaue == AL_STOPPED ||
        stateVaue == AL_PAUSED ||
        stateVaue == AL_INITIAL)
    {
        if (queued < processed || queued == 0 ||(queued == 1 && processed ==1))
        {
            [self stopSound];
            [self cleanUpOpenAL];
        }
        NSLog(@"queue:%d",queued);
        NSLog(@"stateVaue:%d",stateVaue);
        if (queued>50)
        {
            alDeleteBuffers(1, &outSourceId);
            alDeleteBuffers(1, &buff);
            alGenBuffers(1, &buff);
            alGenSources(1, &outSourceId);
        }
        [self playSound];
        return NO;
    }
    while(processed--)
    {
        alSourceUnqueueBuffers(outSourceId, 1, &buff);
        alDeleteBuffers(1, &buff);
    }
    return YES;
}

- (void)playSound{
    ALint state;
    alGetSourcei(outSourceId, AL_SOURCE_STATE, &state);
    if (state != AL_PLAYING){
        alSourcePlay(outSourceId);
    }
}

- (void)stopSound{
    ALint  state;
    alGetSourcei(outSourceId, AL_SOURCE_STATE, &state);
    if (state != AL_STOPPED)
    {
        alSourceStop(outSourceId);
    }
}

- (void)cleanUpOpenAL
{
    if (outSourceId){
        alDeleteSources(1, &outSourceId);
    }
    if(buff){
        alDeleteBuffers(1, &buff);
    }
    if (mContext)
    {
        alcSuspendContext(mContext);
        alcMakeContextCurrent(NULL);
        alcDestroyContext(mContext);
        alcCloseDevice(mDevicde);
    }
}

- (void)dealloc{
    ticketCondition = nil;
    [self cleanUpOpenAL];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    BOOL bSuccess = [session setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    if (!bSuccess){
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

