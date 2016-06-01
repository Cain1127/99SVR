//
//  XVideoLiveViewcontroller.h
//  99SVR
//
//  Created by xia zhonglin  on 4/19/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LivePlayViewController.h"

@class RoomHttp;

@interface XVideoLiveViewcontroller : UIViewController

@property (nonatomic,strong) LivePlayViewController *ffPlay;

- (void)setRoom:(RoomHttp *)room;

- (id)initWithModel:(RoomHttp *)room;

- (void)reloadModel:(RoomHttp *)room;

- (void)stopPlay;

- (void)stopNewPlay;

- (void)removeAllNotify;

- (void)removeNotify;

- (void)addNotify;

- (void)startNewPlay;

/**
 *  清除聊天记录
 */
- (void)clearChatModel;

@end
