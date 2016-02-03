//
//  OpenAL.m
//  99SVR
//
//  Created by xia zhonglin  on 1/29/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "OpenAL.h"

@implementation OpenAL
@synthesize mDevice,mContext,soundDictionary,bufferStorageArray;

#pragma make - openal function

-(void)initOpenAL
{
    NSLog(@"=======initOpenAl===");
    mDevice=alcOpenDevice(NULL);
    if (mDevice) {
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
    
}

- (void) openAudioFromQueue:(unsigned char*)data dataSize:(UInt32)dataSize
{
    NSCondition* ticketCondition= [[NSCondition alloc] init];
    [ticketCondition lock];
    ALuint bufferID = 0;
    alGenBuffers(1, &bufferID);
    NSData * tmpData = [NSData dataWithBytes:data length:dataSize];
    int aSampleRate,aBit,aChannel;
    aSampleRate = 48000;
    aBit = 16;
    aChannel = 2;
    ALenum format;
    if (aBit == 8)
    {
        if (aChannel == 1){
            format = AL_FORMAT_MONO8;
        }
        else if(aChannel == 2){
            format = AL_FORMAT_STEREO8;
        }
        else if( alIsExtensionPresent( "AL_EXT_MCFORMATS" ) )
        {
            if( aChannel == 4 )
            {
                format = alGetEnumValue( "AL_FORMAT_QUAD8" );
            }
            if( aChannel == 6 )
            {
                format = alGetEnumValue( "AL_FORMAT_51CHN8" );
            }
        }
    }
    
    if( aBit == 16 )
    {
        if( aChannel == 1 )
        {
            format = AL_FORMAT_MONO16;
        }
        if( aChannel == 2 )
        {
            // NSLog(@"achhenl= 2!!!!!");
            format = AL_FORMAT_STEREO16;
        }
        if( alIsExtensionPresent( "AL_EXT_MCFORMATS" ) )
        {
            if( aChannel == 4 )
            {
                format = alGetEnumValue( "AL_FORMAT_QUAD16" );
            }
            if( aChannel == 6 )
            {
                NSLog(@"achannel = 6!!!!!!");
                format = alGetEnumValue( "AL_FORMAT_51CHN16" );
            }
        }
    }
    alBufferData(bufferID, format, (char*)[tmpData bytes], (ALsizei)[tmpData length],aSampleRate);
    alSourceQueueBuffers(outSourceId, 1, &bufferID);
    [self updataQueueBuffer];
    ALint stateVaue;
    alGetSourcei(outSourceId, AL_SOURCE_STATE, &stateVaue);
    tmpData = nil;
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
    [updateBufferTimer invalidate];
    updateBufferTimer = nil;
    alDeleteSources(1, &outSourceId);
    alDeleteBuffers(1, &buff);
    alcDestroyContext(mContext);
    alcCloseDevice(mDevicde);
}

-(void)dealloc
{
    NSLog(@"openal sound dealloc");
}

@end
