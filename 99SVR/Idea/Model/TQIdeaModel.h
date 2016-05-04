//
//  TQIdeaModel.h
//  99SVR
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
//#include "HttpMessage.pb.h"

@interface TQIdeaModel : NSObject

/** authorID房间ID */
@property (nonatomic ,copy) NSString *authorid;

@property (nonatomic ,copy) NSString *roomid;
/** 头像 */
@property (nonatomic ,copy) NSString *authoricon;
/** name */
@property (nonatomic ,copy) NSString *authorname;
/** 时间 */
@property (nonatomic ,copy) NSString *publishtime;
/** 评论数 */
@property (nonatomic)int replycount;
/** 内容 */
@property (nonatomic ,copy)NSString *content;
/** viewpointid */
@property (nonatomic)int32_t viewpointid;
/** 礼物数 */
@property (nonatomic)int giftcount;

@property (nonatomic,copy ) NSString *title;


- (id)initWithViewpointSummary:(void *)pData;

- (id)initWIthNewPointNotify:(void *)pData;

@end
