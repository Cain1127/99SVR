//
//  RoomHttp.h
//  99SVR
//
//  Created by xia zhonglin  on 12/17/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomHttp : NSObject

@property (nonatomic,copy) NSString *nvcbid;
@property (nonatomic,copy) NSString *cname;
@property (nonatomic,copy) NSString *croompic;
@property (nonatomic,copy) NSString *cdescription;
@property (nonatomic,copy) NSString *ncount;
@property (nonatomic,copy) NSString *cgateaddr;
@property (nonatomic,copy) NSString *password;

+ (RoomHttp*)resultWithDict:(NSDictionary* )dict;

@end
