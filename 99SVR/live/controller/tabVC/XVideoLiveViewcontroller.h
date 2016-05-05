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

@protocol VideoLiveDelegate <NSObject>
- (void)fullModel;
@end

@interface XVideoLiveViewcontroller : UIViewController

@property (nonatomic,assign) id<VideoLiveDelegate> delegate;

@property (nonatomic,strong) LivePlayViewController *ffPlay;


- (id)initWithModel:(RoomHttp *)room;

- (void)reloadModel:(RoomHttp *)room;

- (void)stopPlay;

- (void)stopNewPlay;

- (void)removeAllNotify;

- (void)removeNotify;

- (void)addNotify;

- (void)startNewPlay;

@end
