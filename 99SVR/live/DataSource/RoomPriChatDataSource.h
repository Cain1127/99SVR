//
//  RoomPriChatDataSource.h
//  99SVR
//
//  Created by xia zhonglin  on 5/25/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RoomPriChatDelegate <NSObject>

- (void)priChatShowKeyboard:(int)nToUser;

@end

@interface RoomPriChatDataSource : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) id<RoomPriChatDelegate> delegate;

- (void)setModel:(NSArray *)aryChat;

@end
