//
//  OpenAL.m
//  99SVR
//
//  Created by xia zhonglin  on 1/29/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "OpenAL.h"
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioServices.h>

@implementation OpenAL
@synthesize mDevice,mContext,soundDictionary,bufferStorageArray;
@synthesize wasInterrupted;

- (void)onAudioSessionEvent:(NSNotification *)notification
{
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        NSLog(@"Interruption notification received %@!", notification);
        //Check to see if it was a Begin interruption
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]])
        {
            alcMakeContextCurrent(NULL);
            if ([self isPlaying])
            {
                self.wasInterrupted = YES;
            }
        }
        else if([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeEnded]])
        {
            OSStatus result = [[AVAudioSession sharedInstance] setActive:YES error:nil];
            alcMakeContextCurrent(self.mContext);
            
            if (self.wasInterrupted)
            {
                [self playSound];
                self.wasInterrupted = NO;
            }
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
- (id)init
{
    if(self=[super init])
    {
       AVAudioSession *session = [AVAudioSession sharedInstance];
       [session setCategory:AVAudioSessionCategoryPlayback error:nil];
       [session setActive: YES error:nil];
       [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];
        return self;
    }
    return nil;
}

+ (UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId
{
    // 1. 设置并激活音频会话类别
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if (newTaskId != UIBackgroundTaskInvalid && backTaskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    return newTaskId;
}

- (void)setPlayBack
{
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [session setActive:YES error:nil];
}

-(void)_haltOpenALSession
{
    NSError *error;
    BOOL bSucess = [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    if (!bSucess) {
        DLog(@"set no:%@",error);
    }
    alSourcePause(outSourceId);
    alcMakeContextCurrent(NULL);
    alcSuspendContext(mContext);
}

-(void)_resumeOpenALSession
{
    NSError *error;
    BOOL bSucess = [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    if (!bSucess)
    {
        DLog(@"play back:%@",error);
    }
    alcMakeContextCurrent(mContext);
    alcProcessContext(mContext);
}

-(void)initOpenAL
{
    NSLog(@"=======initOpenAl===");
    /*
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
    alSourcei(outSourceId, AL_LOOPING, AL_FALSE);
    alSourcef(outSourceId, AL_SOURCE_TYPE, AL_STREAMING);
     */
    ALenum			error;
    ALCcontext		*newContext = NULL;
    ALCdevice		*newDevice = NULL;
    
    // Create a new OpenAL Device
    // Pass NULL to specify the system’s default output device
    newDevice = alcOpenDevice(NULL);
    if (newDevice != NULL)
    {
        // Create a new OpenAL Context
        // The new context will render to the OpenAL Device just created
        newContext = alcCreateContext(newDevice, 0);
        if (newContext != NULL)
        {
            alcMakeContextCurrent(newContext);
            alGenBuffers(1, &buff);
            if((error = alGetError()) != AL_NO_ERROR) {
                printf("Error Generating Buffers: %x", error);
            }
            alGenSources(1, &outSourceId);
            if(alGetError() != AL_NO_ERROR) 
            {
                printf("Error generating sources! %x\n", error);
            }
            
        }
    }
    alGetError();
}

- (void)openAudioFromQueue:(unsigned char*)data dataSize:(UInt32)dataSize
{
    NSCondition* ticketCondition= [[NSCondition alloc] init];
    [ticketCondition lock];
    ALuint bufferID = 0;
    alGenBuffers(1, &bufferID);
    int aSampleRate,aBit,aChannel;
    aSampleRate = 48000;
    aBit = 16;
    aChannel = 2;
    ALenum format=AL_FORMAT_STEREO16;
    alBufferData(bufferID, format,data, (ALsizei)dataSize,aSampleRate);
    alSourceQueueBuffers(outSourceId, 1, &bufferID);
    [self updataQueueBuffer];
    ALint stateVaue;
    alGetSourcei(outSourceId, AL_SOURCE_STATE, &stateVaue);
    [ticketCondition unlock];
    ticketCondition = nil;
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
            DLog(@"释放");
            [self stopSound];
            [self cleanUpOpenAL];
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


#pragma make - play/stop/clean function
-(void)playSound
{
    alSourcePlay(outSourceId);
    
}

-(void)stopSound
{
    alSourceStop(outSourceId);
}

-(void)cleanUpOpenAL
{
    DLog(@"已经释放");
//    [updateBufferTimer invalidate];
//    updateBufferTimer = nil;
    /*
    alDeleteSources(1, &outSourceId);
    alDeleteBuffers(1, &buff);
    alcDestroyContext(mContext);
    alcCloseDevice(mDevicde);
     */
    ALCcontext	*context = NULL;
    ALCdevice	*device = NULL;
    alDeleteSources(1, &outSourceId);
    alDeleteBuffers(1, &buff);
    context = alcGetCurrentContext();
    device = alcGetContextsDevice(context);
    alcDestroyContext(context);
    alcCloseDevice(device);
}

-(void)dealloc
{
    NSLog(@"openal sound dealloc");
}


@end
