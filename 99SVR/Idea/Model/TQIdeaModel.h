//
//  TQIdeaModel.h
//  99SVR
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TQIdeaModel : NSObject
/** 数据 */
@property (nonatomic ,strong)NSMutableArray *ideaArry;
/** authorID房间ID */
@property (nonatomic ,weak)NSString *authorid;
/** 头像 */
@property (nonatomic ,weak)NSString *icon;
/** name */
@property (nonatomic ,weak)NSString *name;
/** 时间 */
@property (nonatomic ,weak)NSString *time;
/** 评论数 */
@property (nonatomic ,assign)int commentCount;
/** 内容 */
@property (nonatomic ,weak)NSString *content;
/** viewpointid */
@property (nonatomic ,assign)int32_t viewpointid;
/** 礼物数 */
@property (nonatomic ,assign)int flowercount;



@end
