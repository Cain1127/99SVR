//
//  RoomChatDataSource.h
//  99SVR
//
//  Created by xia zhonglin  on 4/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RoomChatDelegate <NSObject>

- (void)showKeyboard:(int)nToUser;

@end

@interface RoomChatDataSource : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) id<RoomChatDelegate> delegate;

@property (nonatomic,assign) NSInteger nLength;

/**
 *  设置DataSource 展示长度
 */
- (void)setRowLength:(NSInteger)nLength;

- (void)setModel:(NSArray *)aryChat;
    


@end
