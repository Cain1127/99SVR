//
//  RoomTitle.h
//  99SVR
//
//  Created by xia zhonglin  on 12/17/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomGroup : NSObject

@property (nonatomic,copy) NSString *groupid;
@property (nonatomic,copy) NSString *groupname;
@property (nonatomic,strong) NSArray *groupArr;
@property (nonatomic,strong) NSMutableArray *aryRoomHttp;

+ (RoomGroup*)resultWithDict:(NSDictionary *)dict;

@end
