//
//  TextSecretAllModel.h
//  99SVR
//
//  Created by xia zhonglin  on 3/29/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cmd_vchat.h"
@interface TextSecretAllModel : NSObject
/**
 *  房间
 */
@property (nonatomic) uint32_t vcbid;
/**
 *  用户id
 */
@property (nonatomic) uint32_t userid;
/**
 *  讲师id
 */
@property (nonatomic) uint32_t teacherid;
/**
 *  秘籍总数
 */
@property (nonatomic) int32_t secretsnum;
/**
 *  购买标志
 */
@property (nonatomic) int32_t ownsnum;
/**
 *  是否已拜师
 */
@property (nonatomic) int8_t bStudent;

+ (TextSecretAllModel *)createModel:(CMDTextRoomSecretsTotalResp_t*)resp;

@end
