//
//  RoomListRequest.h
//  99SVR
//
//  Created by xia zhonglin  on 12/18/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HistoryBlock)(int status,NSArray *aryHistory,NSArray *aryColl);

@interface RoomListRequest : NSObject

@property (nonatomic,copy) HistoryBlock historyBlock;

- (void)requestRoomByUserId:(int)userId;

@end
