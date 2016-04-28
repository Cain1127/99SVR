//
//  RoomHttp.h
//  99SVR
//
//  Created by xia zhonglin  on 12/17/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface RoomHttp : NSObject

@property (nonatomic, copy) NSString *nvcbid;
@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *roomname;
@property (nonatomic, copy) NSString *croompic;
@property (nonatomic, copy) NSString *cdescription;
@property (nonatomic, copy) NSString *ncount;
@property (nonatomic, copy) NSString *cgateaddr;
@property (nonatomic, copy) NSString *password;


@property (nonatomic, copy) NSString *roomid;
@property (nonatomic, copy) NSString *teamid;
@property (nonatomic, copy) NSString *teamname;
@property (nonatomic, copy) NSString *teamicon;
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, copy) NSString *onlineusercount;
@property (nonatomic, copy) NSString *locked;
@property (nonatomic, copy) NSString *alias;

+ (RoomHttp*)resultWithDict:(NSDictionary* )dict;

- (id)initWithData:(void *)data;

@end
