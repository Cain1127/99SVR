//
//  OpenAL.h
//  99SVR
//
//  Created by xia zhonglin  on 1/29/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <OpenAL/oalMacOSX_OALExtensions.h>

@interface OpenAL : NSObject
{
    ALCcontext *mContext;
    ALCdevice *mDevicde;
    ALuint outSourceId;
    NSMutableDictionary *soundDictionary;
    NSMutableArray *bufferStorageArray;
    ALuint buff;
    NSTimer *updateBufferTimer;
    BOOL iPodIsPlaying;
    NSCondition* ticketCondition;
}
@property(nonatomic)ALCcontext *mContext;
@property(nonatomic)ALCdevice *mDevice;
@property(nonatomic) BOOL wasInterrupted;
@property (nonatomic) BOOL isPlaying;
@property(nonatomic,retain)NSMutableDictionary *soundDictionary;
@property(nonatomic,retain)NSMutableArray *bufferStorageArray;


-(void)_haltOpenALSession;
-(void)_resumeOpenALSession;

-(void)initOpenAL;
-(void)openAudioFromQueue:(uint8_t *)data dataSize:(UInt32)dataSize;
-(BOOL)updataQueueBuffer;
-(void)playSound;
-(void)stopSound;
-(void)cleanUpOpenAL;

@end
