//
//  ZLReply.h
//  99SVR
//
//  Created by xia zhonglin  on 4/27/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLReply : NSObject

@property (nonatomic) int replytid;
@property (nonatomic) int viewpointid;
@property (nonatomic) int parentreplyid;

@property (nonatomic ,copy) NSString *authorid;
@property (nonatomic ,copy) NSString *authorname;
@property (nonatomic ,copy) NSString *authoricon;

@property (nonatomic ,copy) NSString *fromauthorid;
@property (nonatomic ,copy) NSString *fromauthorname;
@property (nonatomic ,copy) NSString *fromauthoricon;

@property (nonatomic ,copy) NSString *publishtime;
@property (nonatomic ,copy) NSString *content;

@property (nonatomic,copy) NSString *strContent;

@end
