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
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification])
    {
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]])
        {
            [[AVAudioSession sharedInstance] setActive:NO error:nil];
        }
        else if([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeEnded]])
        {
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            [self playSound];
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
       [session setActive:YES error:nil];
       [session setPreferredSampleRate:48000 error:nil];
//       [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
       [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];
        return self;
    }
    return nil;
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
#if 0
    mDevice=alcOpenDevice(NULL);
    if (mDevice==nil)
    {
        return ;
    }
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
    if (ticketCondition==nil)
    {
        ticketCondition= [[NSCondition alloc] init];
    }
#endif
#if 1
    ALenum			error;
    ALCcontext		*newContext = NULL;
    ALCdevice		*newDevice = NULL;
    newDevice = alcOpenDevice(NULL);
    if (newDevice != NULL)
    {
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
#endif
    
}

- (void)openAudioFromQueue:(unsigned char*)data dataSize:(UInt32)dataSize
{
#if 1
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
#endif
#if 0
    [ticketCondition lock];
    ALenum  error =AL_NO_ERROR;
    if ((error =alGetError())!=AL_NO_ERROR)
    {
        [ticketCondition unlock];
        return ;
    }
    if (data ==NULL)
    {
        return ;
    }
    [self updataQueueBuffer];                                  //在这里调用了刚才说的清除缓存buffer函数，也附加声音播放
    if ((error =alGetError())!=AL_NO_ERROR)
    {
        [ticketCondition unlock];
        return ;
    }
    ALuint bufferID =0;                                             //存储声音数据，建立一个pcm数据存储器，初始化一块区域用来保存声音数据
    alGenBuffers(1, &bufferID);
    if ((error = alGetError())!=AL_NO_ERROR)
    {
        [ticketCondition unlock];
        return;
    }
    alBufferData(bufferID, AL_FORMAT_STEREO16, (char *)data, (ALsizei)dataSize, 48000);
    if ((error =alGetError())!=AL_NO_ERROR)
    {
        NSLog(@"create bufferData failed");
        [ticketCondition unlock];
        return;
    }
    //添加到缓冲区
    alSourceQueueBuffers(outSourceId, 1, &bufferID);
    if ((error =alGetError())!=AL_NO_ERROR)
    {
        NSLog(@"add buffer to queue failed");
        [ticketCondition unlock];
        return;
    }
    if ((error=alGetError())!=AL_NO_ERROR)
    {
        NSLog(@"play failed");
        alDeleteBuffers(1, &bufferID);
        [ticketCondition unlock];
        return;
    }
    [ticketCondition unlock];
    
#endif
    
}


- (BOOL)updataQueueBuffer
{
#if 1
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
#endif
#if 0
    ALint  state;
    int processed ,queued;
    alGetSourcei(outSourceId, AL_SOURCE_STATE, &state);
    if (state !=AL_PLAYING)
    {
        [self playSound];
        return NO;
    }
    alGetSourcei(outSourceId, AL_BUFFERS_PROCESSED, &processed);
    alGetSourcei(outSourceId, AL_BUFFERS_QUEUED, &queued);
    while (processed--)
    {
        ALuint buffer;
        alSourceUnqueueBuffers(outSourceId, 1, &buffer);
        alDeleteBuffers(1, &buffer);
    }
    return YES;
#endif
    
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
    context = alcGetCurrentContext();
    device = alcGetContextsDevice(context);
    alcDestroyContext(context);
    alcCloseDevice(device);
/*
    alDeleteSources(1, &outSourceId);
    alDeleteBuffers(1, &buff);
    alcDestroyContext(mContext);
    alcCloseDevice(mDevicde);
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
    
}


@end
