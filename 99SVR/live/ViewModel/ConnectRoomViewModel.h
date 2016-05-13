//
//  ConnectRoomViewModel.h
//  99SVR
//
//  Created by xia zhonglin  on 4/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
@class RoomHttp;

typedef void(^ConnectRoomResult)(int nStatus,RoomHttp *room);

@interface ConnectRoomViewModel : NSObject

@property (nonatomic, copy) void (^ ConnectRoomResult)(int nStatus);

@property (nonatomic,assign) int nTimes;

@property (nonatomic,strong) RoomHttp *room;

@property (nonatomic,strong) UIViewController *control;

- (void)connectViewModel:(RoomHttp *)room;

- (id)initWithViewController:(UIViewController *)control;

@end
