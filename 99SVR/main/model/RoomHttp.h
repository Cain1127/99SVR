//
//  RoomHttp.h
//  99SVR
//
//  Created by xia zhonglin  on 12/17/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomHttp : NSObject

@property (nonatomic,copy) NSString *nvcbid;        ///直播记录ID
@property (nonatomic,copy) NSString *cname;         ///直播房间名
@property (nonatomic,copy) NSString *croompic;      ///直播列表图片
@property (nonatomic,copy) NSString *cdescription;
@property (nonatomic,copy) NSString *ncount;
@property (nonatomic,copy) NSString *cgateaddr;     ///直播地址
@property (nonatomic,copy) NSString *password;

+ (RoomHttp*)resultWithDict:(NSDictionary* )dict;

@end
