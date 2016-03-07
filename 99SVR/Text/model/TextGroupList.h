//
//  TextGroupList.h
//  99SVR
//
//  Created by xia zhonglin  on 3/1/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextGroupList : NSObject

@property (nonatomic,copy) NSString *gid;
@property (nonatomic,copy) NSString *gname;
@property (nonatomic,copy) NSArray *rooms;

+ (TextGroupList *)resultWithDict:(NSDictionary* )dict;

@end
