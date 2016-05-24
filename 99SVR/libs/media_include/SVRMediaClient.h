#ifndef clientCoreiOS_h
#define clientCoreiOS_h

#import <Foundation/Foundation.h>
#pragma mark - INTERFACE

@protocol SVRMediaClientDelegate;

@interface SVRMediaClient : NSObject

@property (strong) id<SVRMediaClientDelegate> delegate;


+ (SVRMediaClient *)sharedSVRMediaClient;

- (BOOL) clientCoreInit:(NSString *)strAddr;
- (BOOL) clientCoreUnInit;
- (BOOL) clientRcvStreamStart:(int32_t)userId roomId:(int32_t)roomId;
//- (BOOL) clientRcvStreamStart:(NSString*)tcpAddr tcpPort:(int32_t)tcpPort rtmpAddr:(NSString*)rtmpAddr userId:(int32_t)userId roomId:(int32_t)roomId;

- (BOOL) clientRcvStreamStop;

- (BOOL) clientMuteVideoStream:(BOOL)en;

- (BOOL) clientMuteAudioStream:(BOOL)en;

- (void)setMainRoomId:(int)roomid;

- (void)networkChange;

@end

#pragma mark - CALL BACK

/*!
 @protocol
 @abstract
 */
@protocol SVRMediaClientDelegate <NSObject>

@optional
- (void)onAudioData:(unsigned char *)cData len:(int32_t)len;
- (void)onVideoData:(unsigned char *)data len:(int32_t)len width:(int32_t)width height:(int32_t)height;
@end


#endif /* clientCoreiOS_h */
