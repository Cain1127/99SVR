//
//  RoomNoticeDataSource.h
//  99SVR
//
//  Created by xia zhonglin  on 4/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomNoticeDataSource : NSObject<UITableViewDelegate,UITableViewDataSource>

- (void)setModel:(NSArray *)aryChat;

@end
