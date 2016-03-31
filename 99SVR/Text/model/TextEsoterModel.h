//
//  TextEsoterModel.h
//  99SVR
//
//  Created by xia zhonglin  on 3/29/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cmd_vchat.h"
@interface TextEsoterModel : NSObject
/**
 *  秘籍id
 */
@property (nonatomic) uint32_t secretsid;
/**
 *   发布时间
 */
@property (nonatomic) uint64_t messagetime;
/**
 *  购买人数
 */
@property (nonatomic) uint32_t buynums;
/**
 *  订阅价格
 */
@property (nonatomic) int32_t prices;
/**
 *  是否购买
 */
@property (nonatomic) int32_t buyflag;
/**
 *  商品ID
 */
@property (nonatomic) int8_t goodsid;
/**
 *  封面小图
 */
@property (nonatomic) int16_t coverlittlelen;

/**
 *  简介标题
 */
@property (nonatomic) int16_t titlelen;
/**
 *   秘籍简介长度
 */
@property (nonatomic) int16_t textlen;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *cover;
@property (nonatomic,copy) NSString *strTime;

+ (TextEsoterModel *)createModel:(CMDTextRoomSecretsListResp_t*)resp buf:(char *)cBuf;

@end
