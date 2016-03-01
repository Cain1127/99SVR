//
//  OpenAL.m
//  99SVR
//
//  Created by xia zhonglin  on 1/29/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "OpenAL.h"
#import <AVFoundation/AVAudioSession.h>
#import "BaseService.h"
#import <AudioToolbox/AudioServices.h>

@implementation OpenAL
@synthesize mDevice,mContext,soundDictionary,bufferStorageArray;
@synthesize wasInterrupted;

- (void)handleAudioNotify:(NSNotification *)notification
{
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification])
    {
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]])
        {
            alcSuspendContext(mContext);
            alcMakeContextCurrent(NULL);
        }
        else if([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeEnded]])
        {
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
- (id)init
{
    if(self=[super init])
    {
       ticketCondition = [[NSCondition alloc] init];
       AVAudioSession *session = [AVAudioSession sharedInstance];
       [session setCategory:AVAudioSessionCategoryPlayback error:nil];
       [session setActive:YES error:nil];
       [session setPreferredSampleRate:48000 error:nil];
       [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(handleAudioNotify:) name:AVAudioSessionInterruptionNotification object:nil];
        return self;
    }
    return nil;
}

-(void)_haltOpenALSession
{
    NSError *error;
    BOOL bSucess = [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    if (!bSucess)
    {
        DLog(@"set no:%@",error);
    }
    alSourcePause(outSourceId);
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
#if 1
    ALenum			error;
    ALCcontext *newContext = NULL;
    ALCdevice *newDevice = NULL;
    newDevice = alcOpenDevice(NULL);
    if (newDevice != NULL)
    {
        mDevicde = newDevice;
        newContext = alcCreateContext(newDevice, 0);
        mContext = newContext;
        if (newContext != NULL)
        {
            alcMakeContextCurrent(newContext);
            alGenBuffers(1, &buff);
            if((error = alGetError()) != AL_NO_ERROR)
            {
                printf("Error Generating Buffers: %x\n", error);
            }
            alGenSources(1, &outSourceId);
            if(alGetError() != AL_NO_ERROR)
            {
                printf("Error generating sources! %x\n", error);
            }
        }
    }
#endif
    
}

- (void)openAudioFromQueue:(unsigned char*)data dataSize:(UInt32)dataSize
{
    [ticketCondition lock];
    @autoreleasepool {
        ALenum  error =AL_NO_ERROR;
        ALuint bufferID = 0;
        alGenBuffers(1, &bufferID);
        int aSampleRate,aBit,aChannel;
        aSampleRate = 48000;
        aBit = 16;
        aChannel = 2;
        ALenum format=AL_FORMAT_STEREO16;
        alBufferData(bufferID, format,data, (ALsizei)dataSize,aSampleRate);
        if ((error =alGetError())!=AL_NO_ERROR)
        {
            DLog(@"create bufferData failed");
            [ticketCondition unlock];
            return;
        }
        alSourceQueueBuffers(outSourceId, 1, &bufferID);
        if ((error =alGetError())!=AL_NO_ERROR)
        {
            DLog(@"push bufferData failed");
            [ticketCondition unlock];
            return;
        }
        [self updataQueueBuffer];
    }
    [ticketCondition unlock];
}

- (BOOL)updataQueueBuffer
{
    ALint stateVaue;
    int processed, queued;
    alGetSourcei(outSourceId, AL_SOURCE_STATE, &stateVaue);
    if (stateVaue != AL_PLAYING)
    {
        DLog(@"stateVaue:%d",stateVaue);
        DLog(@"queued:%d",queued);
        DLog(@"播放");
        [self playSound];
        return NO;
    }
    alGetSourcei(outSourceId, AL_BUFFERS_PROCESSED, &processed);
    alGetSourcei(outSourceId, AL_BUFFERS_QUEUED, &queued);
    if (queued < processed || queued == 0 ||(queued == 1 && processed ==1) || queued >50)
    {
        [BaseService getJSONWithUrl:@"http://42.81.53.201/AnalyticStatistics/?c=Message&type=humanReportBlock&subtype=1&from=1&client=4&content=video_lag" parameters:nil success:nil fail:nil];
        DLog(@"清除缓存");
        alDeleteBuffers(1, &outSourceId);
        alDeleteBuffers(1, &buff);
        DLog(@"重新建立缓存");
        alGenBuffers(1, &buff);
        if (alGetError() != AL_NO_ERROR)
        {
            DLog(@"建立新缓存失败");
        }
        alGenSources(1, &outSourceId);
        if (alGetError() != AL_NO_ERROR)
        {
            DLog(@"建立新buffer失败");
        }
    }
    while(processed--)
    {
        ALuint bufferId;
        alSourceUnqueueBuffers(outSourceId,1,&bufferId);
        alDeleteBuffers(1, &bufferId);
    }
    return YES;
}


#pragma make - play/stop/clean function
-(void)playSound
{
    ALint  state;
    alGetSourcei(outSourceId, AL_SOURCE_STATE, &state);
    if (state != AL_PLAYING)
    {
        alSourcePlay(outSourceId);
    }
}

- (void)pauseSound
{
    alSourcePause(outSourceId);
}

-(void)stopSound
{
    ALint  state;
    alGetSourcei(outSourceId, AL_SOURCE_STATE, &state);
    if (state != AL_STOPPED)
    {
        alSourceStop(outSourceId);
    }
}

-(void)cleanUpOpenAL
{
    DLog(@"已经释放");
    ALCcontext	*context = NULL;
    ALCdevice	*device = NULL;
    alDeleteSources(1, &outSourceId);
    alDeleteBuffers(1, &buff);
    alcDestroyContext(mContext);
    alcCloseDevice(mDevicde);
/*
    alDeleteSources(1, &outSourceId);
    alDeleteBuffers(1, &buff);
*/
}

-(void)dealloc
{
    NSLog(@"openal sound dealloc");
    ticketCondition = nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    BOOL bSuccess = [session setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    if (!bSuccess)
    {
        DLog(@"错误原因:%@",[error description]);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
