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
#import "UserInfo.h"
#import "DecodeJson.h"

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
- (id)init{
    if(self=[super init]){
       ticketCondition = [[NSCondition alloc] init];
       AVAudioSession *session = [AVAudioSession sharedInstance];
       [session setCategory:AVAudioSessionCategoryPlayback error:nil];
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

-(void)initOpenAL{
    ALenum			error;
    ALCcontext *newContext = NULL;
    ALCdevice *newDevice = NULL;
    newDevice = alcOpenDevice(NULL);
    if (newDevice != NULL){
        mDevicde = newDevice;
        newContext = alcCreateContext(newDevice, 0);
        mContext = newContext;
        if (newContext != NULL){
            alcMakeContextCurrent(mContext);
            alcProcessContext(mContext);
            alGenSources(1, &outSourceId);
            if(alGetError() != AL_NO_ERROR){
                DLog(@"err:%@",[self GetALCErrorString:error]);
                printf("Error generating sources! %x\n", error);
            }
            alSourcei(outSourceId, AL_LOOPING, AL_FALSE);
            alSourcef(outSourceId, AL_SOURCE_TYPE, AL_STREAMING);
        }
    }
}

- (void)openAudioFromQueue:(unsigned char*)data dataSize:(UInt32)dataSize
{
    [ticketCondition lock];
    @autoreleasepool{
        ALenum  error =AL_NO_ERROR;
        ALuint bufferID = 0;
        alGenBuffers(1, &bufferID);
        int aSampleRate = 48000;
        alBufferData(bufferID, AL_FORMAT_STEREO16,data,(ALsizei)dataSize,aSampleRate);
        if ((error =alGetError())!=AL_NO_ERROR){
            [ticketCondition unlock];
            return;
        }
        else{
            alSourceQueueBuffers(outSourceId, 1, &bufferID);
            if ((error =alGetError())!=AL_NO_ERROR){
                DLog(@"err:%@",[self GetALCErrorString:error]);
                DLog(@"push bufferData failed");
                [ticketCondition unlock];
                return;
            }
        
            [self updataQueueBuffer];
        }
    }
    [ticketCondition unlock];
}

- (BOOL)updataQueueBuffer
{
    ALint stateVaue;
    int processed, queued;
    alGetSourcei(outSourceId, AL_SOURCE_STATE, &stateVaue);
    if (stateVaue != AL_PLAYING){
        [self playSound];
        return NO;
    }
    alGetSourcei(outSourceId, AL_BUFFERS_PROCESSED, &processed);
    alGetSourcei(outSourceId, AL_BUFFERS_QUEUED, &queued);
    if (queued < processed || queued >75){
        
        int nUserid = [UserInfo sharedUserInfo].nUserId;
        NSString *strErrlog =[NSString stringWithFormat:@"ReportItem=DirectSeedingQuality&ClientType=3&UserId=%d&ServerIP=%@&Error=kadun",nUserid,[UserInfo sharedUserInfo].strMediaAddr];
        [DecodeJson postPHPServerMsg:strErrlog];
        
        alDeleteSources(1, &outSourceId);
        alDeleteBuffers(1, &buff);
        DLog(@"重新建立缓存,queued:%d--processed:%d",queued,processed);
        alGenBuffers(1, &buff);
        ALenum error = alGetError();
        if (error != AL_NO_ERROR){
            DLog(@"err:%@",[self GetALCErrorString:error]);
            DLog(@"建立新缓存失败");
        }
        alGenSources(1, &outSourceId);
        error = alGetError();
        if (error != AL_NO_ERROR){
            DLog(@"err:%@",[self GetALCErrorString:error]);
            DLog(@"建立新buffer失败");
        }
    }
    while(processed--){
        ALuint bufferId;
        alSourceUnqueueBuffers(outSourceId,1,&bufferId);
        alDeleteBuffers(1, &bufferId);
    }
    return YES;
}

- (void)playSound{
    ALint  state;
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

- (void)cleanUpOpenAL{
    DLog(@"已经释放");
    if (outSourceId){
        alDeleteSources(1, &outSourceId);
    }
    if(buff){
        alDeleteBuffers(1, &buff);
    }
    if (mContext) {
        alcSuspendContext(mContext);
        alcMakeContextCurrent(NULL);
        alcDestroyContext(mContext);
        alcCloseDevice(mDevicde);
    }
}

- (void)dealloc{
    NSLog(@"openal sound dealloc");
    ticketCondition = nil;
    [self cleanUpOpenAL];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    BOOL bSuccess = [session setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    if (!bSuccess){
        DLog(@"错误原因:%@",[error description]);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
