//
//  ZLRoomVideoViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 5/5/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "CustomViewController.h"
#import "RoomHttp.h"
#import "LivePlayViewController.h"

@interface ZLRoomVideoViewController : CustomViewController

@property (nonatomic,strong) LivePlayViewController *ffPlay;

- (id)initWithModel:(RoomHttp *)room;
- (void)stopPlay;

@end
