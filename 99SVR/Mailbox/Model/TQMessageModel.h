//
//  TQMessageModel.h
//  99SVR
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//
#import <Foundation/Foundation.h>
#import "HttpMessage.pb.h"

@interface TQMessageModel : NSObject

- (id)initWithSystemMessage:(SystemMessage *)SystemMessage;
/** 内容 */
@property(nonatomic,copy) NSString *content;
/** 时间 */
@property(nonatomic,copy) NSString *publishtime;
/** 标题 */
@property(nonatomic,copy) NSString *titile;
/**/
/** 用户ID */
@property(nonatomic,assign) int userID;




@end
