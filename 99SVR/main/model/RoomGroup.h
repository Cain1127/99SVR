//
//  RoomTitle.h
//  99SVR
//
//  Created by xia zhonglin  on 12/17/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomGroup : NSObject

@property (nonatomic,copy) NSString *groupId;
@property (nonatomic,copy) NSString *groupName;
@property (nonatomic,copy) NSArray *roomList;
@property (nonatomic,copy) NSArray *groupList;

//@property (nonatomic,strong) NSMutableArray *aryRoomHttp;

+ (RoomGroup*)resultWithDict:(NSDictionary *)dict;

@end
