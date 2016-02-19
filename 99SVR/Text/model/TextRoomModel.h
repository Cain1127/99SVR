//
//  TextRoomGroup.h
//  99SVR
//
//  Created by xia zhonglin  on 2/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextRoomModel : NSObject

@property (nonatomic,copy) NSString *rid;
@property (nonatomic,copy) NSString *roomName;
@property (nonatomic,copy) NSString *roomPic;
@property (nonatomic,assign) int zans;


+ (TextRoomModel *)resultWithDict:(NSDictionary* )dict;

@end
